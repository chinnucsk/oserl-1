%%%
% Copyright (C) 2003 Enrique Marcote Pe�a <mpquique@udc.es>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
%%

%%%
% @doc SMPP PDU Library.
%
% <p>Library functions for the SMPP PDU manipulation.</p>
%
% @copyright 2003 Enrique Marcote Pe�a
% @author Enrique Marcote Pe�a <mpquique@udc.es>
%         [http://www.des.udc.es/~mpquique/]
% @version 0.1 alpha, {19 Mar 2003} {@time}.
% @end
%%
-module(pdu_syntax).

%%%-------------------------------------------------------------------
% Include files
%%--------------------------------------------------------------------
-include("smpp_globals.hrl").
-include("pdu_syntax.hrl").

%%%-------------------------------------------------------------------
% External exports
%%--------------------------------------------------------------------
-export([get_value/2, set_value/3, new_pdu/4, pack/3, unpack/3]).

%%%-------------------------------------------------------------------
% Internal exports
%%--------------------------------------------------------------------
-export([]).

%%%-------------------------------------------------------------------
% Macros
%%--------------------------------------------------------------------

%%%-------------------------------------------------------------------
% Records
%%--------------------------------------------------------------------

%%%===================================================================
% External functions
%%====================================================================
%%%
% @spec get_value(ParamName, PduDict) -> ParamValue
%    ParamName  = atom()
%    PduDict    = dictionary()
%    ParamValue = term()
%
% @doc Gets the value of a parameter from a PDU dictionary given the parameter
% name.  If the parameter is not defined on the PDU the atom <tt>undefined
% </tt> is returned.
% @end
%
% %@see
%
% %@equiv
%%
get_value(ParamName, PduDict) ->
    case dict:find(ParamName, PduDict) of
        {ok, ParamValue} ->
            ParamValue;
        error ->
            undefined
    end.


%%%
% @spec set_value(ParamName, ParamValue, PduDict) -> NewPduDict
%    ParamName  = atom()
%    ParamValue = term()
%    PduDict    = dictionary()
%    NewPduDict = dictionary()
%
% @doc Sets the value of a parameter on a PDU dictionary given the parameter
% name, the new PDU dictionary is returned.
% @end
%
% %@see
%
% %@equiv
%%
set_value(ParamName, ParamValue, PduDict) ->
    dict:store(ParamName, ParamValue, PduDict).


%%%
% @spec new_pdu(CommandId, CommandStatus, SequenceNumber, Body) -> PduDict
%    CommandId      = int()
%    CommandStatus  = int()
%    SequenceNumber = int()
%    Body           = [{Key, Value}]
%    PduDict        = dictionary()
%
% @doc Creates a new PDU dictionary for a given the <tt>CommandId</tt>, a
% <tt>CommandStatus</tt>, <tt>SequenceNumber</tt> and a list of
% initial body values.  Every pair of the <tt>Body</tt> list must be on 
% the form <tt>{Key, Value}</tt>.
%
% <p>The <tt>Body</tt> parameter list is ignored whenever 
% <tt>CommandStatus</tt> is different from 0.</p>
% @end
%
% %@see
%
% %@equiv
%%
new_pdu(CommandId, CommandStatus, SequenceNumber, Body) ->
    Header = [{command_id,      CommandId},
              {command_status,  CommandStatus}, 
              {sequence_number, SequenceNumber}],
    case CommandStatus of
        0 ->
            dict:from_list(Header ++ Body);
        _ ->
            dict:from_list(Header)
    end.


%%%
% @spec pack(PduDict, CmdId, PduType) -> Result
%    PduDict        = dictionary()
%    CmdId          = int()
%    PduType        = {pdu, StdsTypes, TlvsTypes}
%    StdsTypes      = [standard()]
%    TlvsTypes      = [tlv()]
%    Result         = {ok, BinaryPdu} | 
%                     {error, CommandId, CommandStatus, SequenceNumber}
%    BinaryPdu      = bin()
%    CommandId      = CmdId | Other
%    Other          = int()
%    CommandStatus  = int()
%    SequenceNumber = int()
% 
% @doc Packs an SMPP PDU dictionary into the corresponding byte stream
% given the command_id (<tt>CmdId</tt>) and the <tt>PduType</tt>.
%
% <p>This function generates an exception if <tt>command_id</tt>, 
% <tt>command_status</tt>, <tt>sequence_number</tt> are not present
% on the PDU dictionary.</p>
%
% <p>Possible return values are:</p>
%
% <ul>
%   <li><tt>{error, Other, ?ESME_RINVCMDID, SequenceNumber}</tt> if the
%     command_id on the <tt>PduDict</tt> is <tt>Other</tt> and doesn't
%     match the command_id given as the parameter <tt>CmdId</tt>.
%   </li>
%   <li><tt>{error, CmdId, CommandStatus, SequenceNumber}</tt> where
%     <tt>CommandStatus</tt> is <tt> ?ESME_RUNKNOWNERR</tt> or an
%     error code associated to the parameter that caused the failure.  The
%     command_id matches <tt>CmdId</tt> but a packing error was
%     encountered.
%   </li>
%   <li><tt>{ok, BinaryPdu}</tt> if the PDU was successfully packed.
%   </li>
% </ul>
%
% @see pack_body/2
% @end
%
% % @equiv
%%
pack(PduDict, CmdId, Type) ->
    PackBody = 
        fun (CommandId, CommandStatus, Dict) when CommandStatus == 0; 
                                                  CommandId < 16#800000000 ->
                pack_body(Dict, Type#pdu.stds_types, Type#pdu.tlvs_types);
            (_CommandId, _CommandStatus, _Dict) ->   
                % Ignore Body on erroneous responses
                {ok, <<>>}
        end,
    Status = dict:fetch(command_status,  PduDict),
    SeqNum = dict:fetch(sequence_number, PduDict),
    case dict:fetch(command_id, PduDict) of
        CmdId ->
            case PackBody(CmdId, Status, PduDict) of
                {ok, Body} ->
                    Len = size(Body) + 16,
                    {ok, <<Len:32,CmdId:32,Status:32,SeqNum:32,Body/binary>>};
                {error, Error} ->
                    {error, CmdId, Error, SeqNum}
            end;
        Other ->
            {error, Other, ?ESME_RINVCMDID, SeqNum}
    end.

%%%
% @spec unpack(BinaryPdu, CmdId, PduType) -> Result
%    BinaryPdu      = bin()
%    CmdId          = int()
%    PduType        = {pdu, StdsTypes, TlvsTypes}
%    StdsTypes      = [standard()]
%    TlvsTypes      = [tlv()]
%    Result         = {ok, PduDict} | 
%                     {error, CommandId, CommandStatus, SequenceNumber}
%    PduDict        = dictionary()
%    Error          = int()
%    CommandId      = undefined | int()
%    CommandStatus  = int()
%    SequenceNumber = int()
% 
% @doc Unpacks an SMPP Binary PDU (octet stream) into the corresponding 
% PDU dictionary using the given command_id (<tt>CmdId</tt>) and the 
% <tt>PduType</tt> descriptor.
%
% <p>This function returns:</p>
%
% <ul>
%   <li><tt>{error, CommandId, ?ESME_RINVCMDID, SequenceNumber}</tt> if
%     the command_id on the <tt>PduDict</tt> doesn't match the command_id
%     given on <tt>PduType</tt>
%   </li>
%   <li><tt>{error, CommandId, ?ESME_RINVCMDLEN, SequenceNumber}</tt> if
%     the PDU is malformed.  The <tt>CommandId</tt> might be the atom
%     <tt>undefined</tt> and the <tt>SequenceNumber</tt> 0 if the
%     PDU is completly unreadable.
%   </li>
%   <li><tt>{error, CmdId, CommandStatus, SequenceNumber}</tt> where 
%     <tt>CommandStatus</tt> is <tt>?ESME_RUNKNOWNERR</tt> or an error
%     code associated to the parameter that caused the failure.  The command_id
%     <tt>CmdId</tt> and the <tt>SequenceNumber</tt> are also included
%     in the error report.
%   </li>
%   <li><tt>{ok, PduDict}</tt> if the PDU was successfully unpacked.
%   </li>
% </ul>
%
% @see unpack_body/2
% @end
%
% % @equiv
%%
unpack(<<Len:32, Rest/binary>>, CmdId, Type) when Len == size(Rest) + 4, 
                                                  Len >= 16 ->
    UnpackBody = 
        fun (CommandId, CommandStatus, Bin) when CommandStatus == 0; 
                                                 CommandId < 16#800000000 ->
                unpack_body(Bin, Type#pdu.stds_types, Type#pdu.tlvs_types);
            (_CommandId, _CommandStatus, _Bin) ->   
                % Ignore Body on erroneous responses
                {ok, []}
        end,
    case Rest of
        <<CmdId:32, Status:32, SeqNum:32, Body/binary>> ->
            case UnpackBody(CmdId, Status, Body) of
                {ok, BodyPairs} ->
                    {ok, new_pdu(CmdId, Status, SeqNum, BodyPairs)};
                {error, Error} ->
                    {error, CmdId, Error, SeqNum}
            end;
        <<Other:32, _Status:32, SeqNum:32, _Body/binary>> ->
            {error, Other, ?ESME_RINVCMDID, SeqNum}
    end;

unpack(_BinaryPdu, _CmdId, _PduType) ->
    {error, undefined, ?ESME_RINVCMDLEN, 0}.


%%%===================================================================
% Internal functions
%%====================================================================
%%%
% @spec pack_body(BodyDict, StdsTypes, TlvsTypes) -> Result
%    Pdu        = dictionary()
%    StdsTypes  = [standard()]
%    TlvsTypes  = [tlv()]
%    Result     = {ok, BinaryBody} | {error, Error}
%    BinaryBody = bin()
%    Error      = int()
% 
% @doc Packs the body's parameter dictionary of a PDU according to their
% corresponding types.
%
% @see pack_stds/2
% @see pack_tlvs/2
% @end
%
% %@equiv
%%
pack_body(BodyDict, StdsTypes, TlvsTypes) ->
    case pack_stds(BodyDict, StdsTypes) of
        {ok, BinaryStdsValues} ->
            case pack_tlvs(BodyDict, TlvsTypes) of
                {ok, BinaryTlvsValues} ->
                    {ok, concat_binary(BinaryStdsValues ++ BinaryTlvsValues)};
                TlvError ->
                    TlvError
            end;
        StdError ->
            StdError
    end.


%%%
% @doc Auxiliary function for pack_body/3
%
% @see pack_stds/3
% @end
%%
pack_stds(BodyDict, StdsTypes) ->
    pack_stds(BodyDict, StdsTypes, []).


%%%
% @doc Auxiliary function for pack_stds/2
%
% @see param_syntax:get_name/1
% @see param_syntax:encode/2
% @end
%%
pack_stds(_BodyDict, [], Acc) ->
    {ok, lists:reverse(Acc)};

pack_stds(BodyDict, [Type|Types], Acc) ->
    % See how param_syntax:encode/2 handles undefined
    Value = get_value(param_syntax:get_name(Type), BodyDict),
    case param_syntax:encode(Value, Type) of
        {ok, BinaryValue} ->
            pack_stds(BodyDict, Types, [BinaryValue|Acc]);
        Error ->
            Error
    end.


%%%
% @doc Auxiliary function for pack_body/3
%
% @see pack_tlvs/3
% @end
%%
pack_tlvs(BodyDict, TlvsTypes) ->
    pack_tlvs(BodyDict, TlvsTypes, []).


%%%
% @doc Auxiliary function for pack_tlvs/2
%
% @see param_syntax:get_name/1
% @see param_syntax:encode/2
% @end
%%
pack_tlvs(_BodyDict, [], Acc) ->
    {ok, lists:reverse(Acc)};

pack_tlvs(BodyDict, [Type|Types], Acc) ->
    % See how param_syntax:encode/2 handles undefined
    Value = get_value(param_syntax:get_name(Type), BodyDict),
    case param_syntax:encode(Value, Type) of
        {ok, BinaryValue} ->
            pack_tlvs(BodyDict, Types, [BinaryValue|Acc]);
        Error ->
            Error
    end.


%%%
% @spec unpack_body(BinaryBody, StdsTypes, TlvTypes) -> Result
%    BinaryBody = bin()
%    StdsTypes  = [standard()]
%    TlvsTypes  = [tlv()]
%    Result     = {ok, BodyPairs} | {error, Error}
%    BodyPairs  = [{Key, Value}]
%    Error      = int()
%
% @doc Unpacks the <tt>BinaryBody</tt> of a PDU according to the types 
% lists of the standard and TLV parameters specifier (<tt>StdsTypes</tt> 
% and <tt>TlvsTypes</tt> respectively).
%
% <p>First the standard parameters are decoded from the head of the 
% <tt>BinaryBody</tt> following the sequence determined by <tt>StdsTypes
% </tt>, the remainder binary contains the TLVs.  Even TLVs may came in any
% order, they're extracted in the order determined by <tt>TlvsTypes</tt>.
% </p>
%
% @see unpack_stds/2
% @see unpack_tlvs/2
% @end
%
% % @equiv
%%
unpack_body(BinaryBody, StdsTypes, TlvsTypes) ->
    case unpack_stds(BinaryBody, StdsTypes) of
        {ok, StdsValues, BinaryTlvs} ->
            case unpack_tlvs(BinaryTlvs, TlvsTypes) of
                {ok, TlvsValues} ->
                    {ok, StdsValues ++ TlvsValues};
                TlvError ->
                    TlvError
            end;
        StdError ->
            StdError
    end.


%%%
% @doc Auxiliary function for unpack_body/3
%
% @see unpack_stds/3
% @end
%%
unpack_stds(BinaryBody, StdsTypes) ->
    unpack_stds(BinaryBody, StdsTypes, []).


%%%
% @doc Auxiliary function for unpack_stds/2
%
% @see param_syntax:get_name/1
% @see param_syntax:decode/2
% @end
%%
unpack_stds(BinaryTlvs, [], Acc) ->
    {ok, lists:reverse(Acc), BinaryTlvs};

unpack_stds(BinaryBody, [Type|Types], Acc) ->
    case param_syntax:decode(BinaryBody, Type) of
        {ok, Value, RestBinaryBody} ->
            Name = param_syntax:get_name(Type),
            unpack_stds(RestBinaryBody, Types, [{Name, Value}|Acc]);
        Error ->
            Error
    end.


%%%
% @doc Auxiliary function for unpack_body/3
%
% @see unpack_tlvs/3
% @end
%%
unpack_tlvs(BinaryTlvs, []) ->
    case param_syntax:chop_tlv(BinaryTlvs) of
        {ok, _Tlv, RestUnusedTlvs} ->
            % Remaining octets seem to be collection of unsupported TLVs.
            % Forward compatibility guidelines recommend to silently discard
            % unsupported TLVs (if they are well-formed).
            %
            % After the first TLV was chopped, we dive into unpack_tlvs/3 
            % course we'd want to return the ?ESME_RINVTLVSTREAM error instead
            % of the ?ESME_RINVCMDLEN error returned by this function.
            unpack_tlvs(RestUnusedTlvs, []);
        {error, <<>>} ->
            {ok, []};
        _Error ->
            % Guess that no unsupported TLVs were appended to the body,
            % just dealing with a malformed PDU.
            {error, ?ESME_RINVCMDLEN}
    end;

unpack_tlvs(BinaryTlvs, TlvsTypes) ->
    unpack_tlvs(BinaryTlvs, TlvsTypes, []).


%%%
% @doc Auxiliary function for unpack_tlvs/2
%
% @see param_syntax:get_name/1
% @see param_syntax:decode/2
% @see param_syntax:chop_tlv/1
% @end
%%
unpack_tlvs(<<>>, [], Acc) ->
    {ok, lists:reverse(Acc)};

unpack_tlvs(UnusedTlvs, [], Acc) ->
    case param_syntax:chop_tlv(UnusedTlvs) of
        {ok, _Tlv, RestUnusedTlvs} ->
            unpack_tlvs(RestUnusedTlvs, [], Acc);
        _Error ->  % Malformed TLV
            {error, ?ESME_RINVTLVSTREAM}
    end;

unpack_tlvs(BinaryTlvs, [Type|Types], Acc) ->
    case param_syntax:decode(BinaryTlvs, Type) of
        {ok, undefined, RestBinaryTlvs} -> % Ignore undefined TLVs
            unpack_tlvs(RestBinaryTlvs, Types, Acc);
        {ok, Value, RestBinaryTlvs} ->
            Name = param_syntax:get_name(Type),
            unpack_tlvs(RestBinaryTlvs, Types, [{Name, Value}|Acc]);
        Error ->
            Error
    end.