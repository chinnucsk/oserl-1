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
% @doc SMPP Parameters definition.
%
% <p>SMPP Standard and TLV Parameters definition.  These parameters are
% defined using the syntax defined in <b>param_syntax.hrl</b>.</p>
%
% <p>As a guideline, some comments include a section number referencing 
% the corresponding section number on [SMPP 5.0].</p>
%
%
% <h2>References</h2>
% <dl>
%   <dt>[SMPP 5.0]</dt><dd>Short Message Peer-to-Peer Protocol Specification. 
%     Version 5.0. SMS Forum.
%   </dd>
%   <dt>[3GPP TS 23.040]</dt><dd>Technical Realization of the Short Message
%     Service (SMS) Release 4.  Version 5.0.0. 
%     <a href="http://www.3gpp.org">3GPP</a>.
%   </dd>
% </dl>
%
%
% @copyright 2003 Enrique Marcote Pe�a
% @author Enrique Marcote Pe�a <mpquique@udc.es>
%         [http://www.des.udc.es/~mpquique/]
% @version 0.1 alpha, {27 Apr 2003} {@time}.
% @end
%%

-ifndef(smpp_param).
-define(smpp_param, true).

%%%-------------------------------------------------------------------
% Include files
%%--------------------------------------------------------------------
-include("smpp_globals.hrl").  % Some global definitions
-include("smpp_base.hrl").     % The parameters base declarations
-include("param_syntax.hrl").  % The syntax used in this file

%%%-------------------------------------------------------------------
% Macros
%%--------------------------------------------------------------------
%%%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% PDU Field Parameter Syntax Definitions
%
% %@see section 4.7 on [SMPP 5.0]
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%%
% addr_ton, source_addr_ton, dest_addr_ton, esme_addr_ton 
%
% %@doc Type of Number.  If not known, set to NULL (Unknown). Integer, 1 octet.
%%
-define(ADDR_TON,        
        ?STANDARD(addr_ton, 
                  ?ADDR_TON_DOMAIN,
                  undefined)).
-define(SOURCE_ADDR_TON, 
        ?STANDARD(source_addr_ton, 
                  ?SOURCE_ADDR_TON_DOMAIN,
                  ?ESME_RINVSRCTON)).
-define(DEST_ADDR_TON,   
        ?STANDARD(dest_addr_ton, 
                  ?DEST_ADDR_TON_DOMAIN, 
                  ?ESME_RINVDSTTON)).
-define(ESME_ADDR_TON,   
        ?STANDARD(esme_addr_ton, 
                  ?ESME_ADDR_TON_DOMAIN, 
                  undefined)).

%%%
% addr_npi, source_addr_npi, dest_addr_npi, esme_addr_npi
%
% %@doc Numbering Plan Indicator.  If not known, set to NULL (Unknown).  
% Integer, 1 octet.
% %@end
%%
-define(ADDR_NPI,        
        ?STANDARD(addr_npi, 
                  ?ADDR_NPI_DOMAIN, 
                  undefined)).
-define(SOURCE_ADDR_NPI, 
        ?STANDARD(source_addr_npi, 
                  ?SOURCE_ADDR_NPI_DOMAIN, 
                  ?ESME_RINVSRCNPI)).
-define(DEST_ADDR_NPI,   
        ?STANDARD(dest_addr_npi, 
                  ?DEST_ADDR_NPI_DOMAIN, 
                  ?ESME_RINVDSTNPI)).
-define(ESME_ADDR_NPI,   
        ?STANDARD(esme_addr_npi, 
                  ?ESME_ADDR_NPI_DOMAIN,  
                  undefined)).

%%%
% address_range
%
% %@doc The ESME address.  If the carrier will not allow the ESME control the
% message routing, this field must be set to NULL.  C-Octet String, Var. max
% 41 octets
% 
% <ul> 
%   <li>Single SME address</li>
%   <li>Range of addresses using UNIX Regular Expression notation</li>
% </ul>
% %@end
%%
-define(ADDRESS_RANGE, 
        ?STANDARD(address_range, 
                  ?ADDRESS_RANGE_DOMAIN, 
                  undefined)).

%%%
% command_id
%
% %@doc Identifies the particular SMPP PDU.  Refer to command_id macros on
% <b>smpp_base.hrl</b> for valid values.  Integer, 4 octets.
%
% <p>On current implementation, encoding/decoding this value is implicitly 
% done by unpacking/packing functions, thus this field must not be included in
% the PDU definitions.  Never used.</p>
% %@end
%%
% -define(COMMAND_ID, 
%         ?STANDARD(command_id, 
%                   ?COMMAND_ID_DOMAIN, 
%                   ?ESME_RINVCMDID)).

%%%
% command_status, error_status_code
%
% %@doc Indicates the success or failure of an SMPP request.  It is relevant
% only in the SMPP response PDU and it must contain a NULL value in an SMPP
% request PDU.  Check command_status macros on <b>smpp_base.hrl</b>
% for a complete list of SMPP Error codes.  Integer, 4 octets.
%
% <p>On current implementation, encoding/decoding the command_status value is
% implicitly done by unpacking/packing functions, thus this field must not be
% included in the PDU definitions.  Never used.</p>
% %@end
%%
% -define(COMMAND_STATUS,    
%         ?STANDARD(command_status, 
%                   ?COMMAND_STATUS_DOMAIN, 
%                   undefined)).
-define(ERROR_STATUS_CODE, 
        ?STANDARD(error_status_code, 
                  ?ERROR_STATUS_CODE_DOMAIN, 
                  undefined)).

%%%
% data_coding
%
% %@doc Defines the encoding scheme of the short message user data.  Integer, 
% 1 octet.  Use ?DATA_CODING_BINARY to send binary data; ring tone, operator
% logo, WAP data...).
% %@end
%%
-define(DATA_CODING, 
        ?STANDARD(data_coding, 
                  ?DATA_CODING_DOMAIN, 
                  ?ESME_RINVDCS)).

%%%
% destination_addr
%
% %@doc Specifies the destination SME address.  For mobile terminated messages,
% this is the directory number of the recipient MS.  IP addresses are 
% specified in "aaa.bbb.ccc.ddd" notation.  C-Octet String, Var. max 21 octets.
% %@end
%%
-define(DESTINATION_ADDR_21, 
        ?STANDARD(destination_addr, 
                  ?DESTINATION_ADDR_21_DOMAIN, 
                  ?ESME_RINVDSTADR)).
-define(DESTINATION_ADDR_65,
        ?STANDARD(destination_addr, 
                  ?DESTINATION_ADDR_65_DOMAIN, 
                  ?ESME_RINVDSTADR)).

%%%
% dest_address
%
% %@doc This field is a composite field containing a mandatory field and then
% either an SME address or a Distribution List.  Additionally this field
% can be encoded multiple times.
% %@end
%%
-define(DEST_ADDRESS,
        ?STANDARD(dest_address, 
                  ?DEST_ADDRESS_DOMAIN,
                  ?ESME_RINVDSTADR)).

%%%
% esme_addr
%
% %@doc Specifies the address of an ESME to which an alert_notification should 
% be routed.  IP address must be in "aaa.bbb.ccc.ddd" notation.
% %@end
%%
-define(ESME_ADDR, 
        ?STANDARD(esme_addr, 
                  ?ESME_ADDR_DOMAIN, 
                  undefined)).

%%%
% esm_class
%
% %@doc Indicates Message Mode and Message Type.  Integer, 1 octet
%
% %@TODO If a default value field is introduced on standard record, this
% parameter has a default value of ?ESM_CLASS_DEFAULT.
% %@end
%%
-define(ESM_CLASS, 
        ?STANDARD(esm_class, 
                  ?ESM_CLASS_DOMAIN, 
                  ?ESME_RINVESMCLASS)).

%%%
% interface_version
%
% %@doc Indicates the version of the SMPP protocol supported by the ESME.  
% Integer, 1 octet.
% %@end
%%
-define(INTERFACE_VERSION, 
        ?STANDARD(interface_version, 
                  ?INTERFACE_VERSION_DOMAIN, 
                  undefined)).

%%%
% message_id
%
% %@doc This field contains the MC message ID of the submitted message.  It
% may be used at a later stage to query the status of a message, cancel or
% replace the message.  C-Octet String, Var. max 65 octets.
%
% <p>Set according to MC implementation.</p>
% %@end
%%
-define(MESSAGE_ID, 
        ?STANDARD(message_id, 
                  ?MESSAGE_ID_DOMAIN, 
                  ?ESME_RINVMSGID)).

%%%
% message_state
%
% %@doc Specifies the status of the queried short message.  Integer, 1 octet 
% %@end
%%
-define(MESSAGE_STATE, 
        ?STANDARD(message_state, 
                  ?MESSAGE_STATE_DOMAIN, 
                  undefined)).

%%%
% password
%
% %@doc The password may be used by the MC to authenticate the the ESME
% requesting to bind. C-Octet String, Var. max 9 octets.
%
% <p>The password is normally issued by the MC system administrator.</p>
% %@end
%%
-define(PASSWORD, 
        ?STANDARD(password, 
                  ?PASSWORD_DOMAIN, 
                  ?ESME_RINVPASWD)).

%%%
% priority_flag
%
% %@doc Designates the priority level of the message.  Integer, 1 octet.
% %@end
%%
-define(PRIORITY_FLAG, 
        ?STANDARD(priority_flag, 
                  ?PRIORITY_FLAG_DOMAIN,
                  ?ESME_RINVPRTFLG)).

%%%
% protocol_id
%
% %@doc Protocol Identifier.  Network specific field.  Integer, 1 octet.
%
% <p>Set according to [3GPP TS 23.040].</p>
%
% <p>On both, TDMA and CDMA, protocol_id is Ignored for mobile terminated
% messages and set to NULL by the MC for mobile originated messages.</p>
% %@end
%%
-define(PROTOCOL_ID, 
        ?STANDARD(protocol_id, 
                  ?PROTOCOL_ID_DOMAIN,
                  ?ESME_RINVPRTFLG)).

%%%
% registered_delivery
%
% %@doc Indicator to signify if a MC delivery receipt, manual ACK, delivery 
% ACK or an intermediate notification is required.  Integer, 1 octet.
%
% %@TODO If a default value field is introduced on standard record, for this
% parameter the default value is ?REGISTERED_DELIVERY_DEFAULT.
% %@end
%%
-define(REGISTERED_DELIVERY, 
        ?STANDARD(registered_delivery, 
                  ?REGISTERED_DELIVERY_DOMAIN,
                  ?ESME_RINVREGDLVFLG)).

%%%
% replace_if_present_flag
%
% %@doc Flag indicating if the submitted message should replace an existing
% message.  Integer, 1 octet.
%
% %@TODO If a default value field is introduced on standard record, for this
% parameter the default value is ?REPLACE_IF_PRESENT_FLAG_DO_NOT_REPLACE.
% %@end
%%
-define(REPLACE_IF_PRESENT_FLAG,
        ?STANDARD(replace_if_present_flag,
                  ?REPLACE_IF_PRESENT_FLAG_DOMAIN,
                  ?ESME_RINVREPFLAG)).

%%%
% schedule_delivery_time
%
% %@doc The short message is to be scheduled by the MC for delivery.  C-Octet
% String, Fixed 17 octets.
%
% <p>It can be specified in either absolute time format or relative time 
% from the current MC time.  "YYMMDDhhmmsstnnp"</p>
% %@end
%%
-define(SCHEDULE_DELIVERY_TIME,
        ?STANDARD(schedule_delivery_time,
                  ?SCHEDULE_DELIVERY_TIME_DOMAIN, 
                  ?ESME_RINVSCHED)).

%%%
% validity_period
%
% %@doc The validity period of this message.  This field is superseded by the
% <tt>qos_time_to_live</tt> TLV if specified.  C-Octet String, Fixed 17
% octets.
%
% <p>It can be specified in either absolute time format or relative time 
% from the current MC time.  "YYMMDDhhmmsstnnp"</p>
% %@end
%%
-define(VALIDITY_PERIOD, 
        ?STANDARD(validity_period, 
                  ?VALIDITY_PERIOD_DOMAIN, 
                  ?ESME_RINVEXPIRY)).

%%%
% final_date
%
% %@doc Date and time when the queried message reached a final state.  For
% messages, which have not yet reached a final state, this field will contain
% a single NULL octet.  C-Octet String, Fixed 17 octets.
%
% <p>It must be specified in absolute time format "YYMMDDhhmmsstnnp"</p>
% %@end
%%
-define(FINAL_DATE, 
        ?STANDARD(final_date, 
                  ?FINAL_DATE_DOMAIN,
                  undefined)).

%%%
% sequence_number
%
% %@doc Allows a response PDU to be correlated with a request PDU.  The allowed
% sequence_number range is from 16#00000001 to 16#7FFFFFFFFF.
%
% <p>On current implementation, encoding/decoding this value is implicitly 
% done by unpacking/packing functions, thus this field must not be included in
% the PDU definitions.  Never used.</p>
% %@end
%%
% -define(SEQUENCE_NUMBER, 
%         ?STANDARD(sequence_number, 
%                   ?SEQUENCE_NUMBER_DOMAIN, 
%                   undefined)).

%%%
% service_type
%
% %@doc The service_type parameter can be used to indicate the SMS Application
% service associated with the message.  Specifying the service_type allows the
% ESME to avail of enhanced message services such us "replace by service_type"
% or to control teleservice used on the air interface.  Set to NULL for
% default MC settings.  C-Octet String, Var. max 6 octets.
% %@end
%%
-define(SERVICE_TYPE, 
        ?STANDARD(service_type, 
                  ?SERVICE_TYPE_DOMAIN, 
                  ?ESME_RINVSERTYP)).

%%%
% short_message
%
% %@doc Short message user data.  This field is superceded by the
% message_payload TLV if specified.  This field embraces sm_length also, a
% variable length octet string is encoded in length + string format.  Octet
% String, Var.  max 255 octets.
% %@end
%%
-define(SHORT_MESSAGE, 
        ?STANDARD(short_message, 
                  ?SHORT_MESSAGE_DOMAIN, 
                  ?ESME_RINVMSGLEN)).

%%%
% sm_default_msg_id
%
% %@doc Indicates the short message to send from a list of pre-defined
% ("canned") short messages stored on the MC.  If not using a MC canned
% message, set to NULL.  Integer, 1 octet.
% %@end
%%
-define(SM_DEFAULT_MSG_ID, 
        ?STANDARD(sm_default_msg_id, 
                  ?SM_DEFAULT_MSG_ID_DOMAIN, 
                  ?ESME_RINVDFTMSGID)).

%%%
% source_addr
%
% %@doc Specifies the address of the SME which originated this message.  IP
% address must be in "aaa.bbb.ccc.ddd" notation.
% %@end
%%
-define(SOURCE_ADDR_21, 
        ?STANDARD(source_addr, 
                  ?SOURCE_ADDR_21_DOMAIN, 
                  ?ESME_RINVSRCADR)).
-define(SOURCE_ADDR_65, 
        ?STANDARD(source_addr, 
                  ?SOURCE_ADDR_65_DOMAIN, 
                  ?ESME_RINVSRCADR)).

%%%
% system_id
%
% %@doc Identifies an ESME or a MC at bind time.
% %@end
%%
-define(SYSTEM_ID, 
        ?STANDARD(system_id, 
                  ?SYSTEM_ID_DOMAIN, 
                  ?ESME_RINVSYSID)).

%%%
% system_type
%
% %@doc Used to categorize the type of ESME that is binding to the MC.  
% Examples include "VMS" (voice mail system) and "OTA" (over-the-air 
% activation system).
%
% <p>Some MCs may not require this parameter, in this case a NULL can be
% used.</p>
% %@end
%%
-define(SYSTEM_TYPE, 
        ?STANDARD(system_type, 
                  ?SYSTEM_TYPE_DOMAIN, 
                  ?ESME_RINVSYSTYP)).

%%%
% error_code
%
% %@doc The range of values returned depends on the underlying 
% telecommunications network.
% %@end
%%
-define(ERROR_CODE, 
        ?STANDARD(error_code, 
                  ?ERROR_CODE_DOMAIN, 
                  undefined)).

%%%
% unsuccess_sme_multi
%
% %@doc This field is a composite field containing an SME address and an error
% code.  Additionally this field can be encoded multiple times.
% %@end
%%
-define(UNSUCCESS_SME, 
        ?STANDARD(unsuccess_sme, 
                  ?UNSUCCESS_SME_DOMAIN, 
                  ?ESME_RINVDSTADR)).


%%%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% PDU TLV Definitions
%
% %@see section 4.8 on [SMPP 5.0]
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%%
% additional_status_info_text
%
% %@doc Free format text. 
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(ADDITIONAL_STATUS_INFO_TEXT, 
        ?OPTIONAL_TLV(additional_status_info_text,
                      16#001D, 
                      ?ADDITIONAL_STATUS_INFO_TEXT_DOMAIN, 
                      ?ADDITIONAL_STATUS_INFO_TEXT_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% alert_on_message_delivery
%
% %@doc Request an MS alert signal be invoked on message delivery.  Integer, 1 
% octet (default is ?ALERT_ON_MESSAGE_DELIVERY_DEFAULT).
%
% <p>Wireless Network Technology:  CDMA</p>
% %@end
%%
-define(ALERT_ON_MESSAGE_DELIVERY, 
        ?OPTIONAL_TLV(alert_on_message_delivery,
                      16#130C, 
                      ?ALERT_ON_MESSAGE_DELIVERY_DOMAIN,
                      ?ALERT_ON_MESSAGE_DELIVERY_RESERVED, 
                      ?ALERT_ON_MESSAGE_DELIVERY_DEFAULT,
                      undefined)).

%%%
% billing_identification
%
% %@doc Billing information passed from ESME to MC. Octet String, Var. max 
% 1024.
%
% <p>The first octet represents the Billing Format tag and indicates the 
% format of the billing information in the remaining octets.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(BILLING_IDENTIFICATION, 
        ?OPTIONAL_TLV(billing_identification,
                      16#060B, 
                      ?BILLING_IDENTIFICATION_DOMAIN, 
                      ?BILLING_IDENTIFICATION_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% broadcast_area_identifier, failed_broadcast_area_identifier
%
% %@doc A broadcast_area_identifier (or failed_broadcast_area_identifier) 
% value should be defined using the broadcast_area record.
%
% <p>Wireless Network Technology:  CDMA, TDMA, GSM</p>
%
% %@see broadcast_area record definition below.
% %@end
%%
-define(BROADCAST_AREA_IDENTIFIER, 
        ?MULTIPLE_MANDATORY_TLV(broadcast_area_identifier,
                                16#0606,
                                ?BROADCAST_AREA_IDENTIFIER_DOMAIN,
                                ?BROADCAST_AREA_IDENTIFIER_RESERVED,
                                undefined,
                                ?ESME_RINVBCASTAREAFMT)).
-define(FAILED_BROADCAST_AREA_IDENTIFIER, 
        ?MULTIPLE_OPTIONAL_TLV(failed_broadcast_area_identifier, 
                               16#0606,
                               ?FAILED_BROADCAST_AREA_IDENTIFIER_DOMAIN,
                               ?FAILED_BROADCAST_AREA_IDENTIFIER_RESERVED,
                               undefined,
                               ?ESME_RINVBCASTAREAFMT)).

%%%
% broadcast_area_success
%
% %@doc 0-100 is the allowed range.
%
% <p>Wireless Network Technology:  GSM</p>
% %@end
%%
-define(BROADCAST_AREA_SUCCESS, 
        ?MULTIPLE_MANDATORY_TLV(broadcast_area_success,
                                16#0608, 
                                ?BROADCAST_AREA_SUCCESS_DOMAIN, 
                                ?BROADCAST_AREA_SUCCESS_RESERVED, 
                                undefined, 
                                undefined)).

%%%
% broadcast_content_type_info
%
% %@doc The value is a free format Octet String
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
% %@end
%%
-define(BROADCAST_CONTENT_TYPE_INFO, 
        ?OPTIONAL_TLV(broadcast_content_type_info,
                      16#0602, 
                      ?BROADCAST_CONTENT_TYPE_INFO_DOMAIN,
                      ?BROADCAST_CONTENT_TYPE_INFO_RESERVED,
                      undefined,
                      undefined)).

%%%
% broadcast_channel_indicator
%
% %@doc Wireless Network Technology:  GSM
% %@end
%%
-define(BROADCAST_CHANNEL_INDICATOR, 
        ?OPTIONAL_TLV(broadcast_channel_indicator,
                      16#0600,
                      ?BROADCAST_CHANNEL_INDICATOR_DOMAIN,
                      ?BROADCAST_CHANNEL_INDICATOR_RESERVED,
                      ?BROADCAST_CHANNEL_INDICATOR_BASIC,
                      ?ESME_RINVBCASTCHANIND)).

%%%
% broadcast_content_type
%
% %@doc A broadcast_content_type value should be defined using the 
% broadcast_content_type record.
%
% <p>Wireless Network Technology:  CDMA, TDMA, GSM</p>
%
% %@see broadcast_content_type record definition on smpp_base.hrl
% %@end
%%
% As in broadcast_sm
-define(MANDATORY_BROADCAST_CONTENT_TYPE, 
        ?MULTIPLE_MANDATORY_TLV(broadcast_content_type,
                                16#0601,
                                ?BROADCAST_CONTENT_TYPE_DOMAIN,
                                ?BROADCAST_CONTENT_TYPE_RESERVED,
                                undefined,
                                ?ESME_RINVBCASTCNTTYPE)).

% As in cancel_broadcast_sm
-define(OPTIONAL_BROADCAST_CONTENT_TYPE, 
        ?OPTIONAL_TLV(broadcast_content_type,
                      16#0601,
                      ?BROADCAST_CONTENT_TYPE_DOMAIN,
                      ?BROADCAST_CONTENT_TYPE_RESERVED,
                      undefined,
                      ?ESME_RINVBCASTCNTTYPE)).

%%%
% broadcast_end_time
%
% %@doc It must be specified in absolute time format "YYMMDDhhmmsstnnp"
%
% <p>Wireless Network Technology:  CDMA, TDMA, GSM</p>
% %@end
%%
-define(BROADCAST_END_TIME, 
        ?OPTIONAL_TLV(broadcast_end_time,
                      16#0609, 
                      ?BROADCAST_END_TIME_DOMAIN, 
                      ?BROADCAST_END_TIME_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% broadcast_error_status
% 
% %@doc One of the SMPP Error Code Values as defined for error_status_code
%
% <p>Wireless Network Technology:  CDMA, TDMA, GSM</p>
% %@end
%%
-define(BROADCAST_ERROR_STATUS, 
        ?MULTIPLE_OPTIONAL_TLV(broadcast_error_status,
                               16#0607, 
                               ?BROADCAST_ERROR_STATUS_DOMAIN, 
                               ?BROADCAST_ERROR_STATUS_RESERVED, 
                               undefined, 
                               undefined)).

%%%
% broadcast_frequency_interval
%
% %@doc Wireless Network Technology:  CDMA, TDMA, GSM
% %@end
%%
-define(BROADCAST_FREQUENCY_INTERVAL,
        ?MANDATORY_TLV(broadcast_frequency_interval,
                       16#0605,
                       ?BROADCAST_FREQUENCY_INTERVAL_DOMAIN,
                       ?BROADCAST_FREQUENCY_INTERVAL_RESERVED,
                       undefined,
                       ?ESME_RINVBCASTFREQINT)).

%%%
% broadcast_message_class
%
% %@doc Wireless Network Technology:  GSM
% %@end
%%
-define(BROADCAST_MESSAGE_CLASS, 
        ?OPTIONAL_TLV(broadcast_message_class,
                      16#0603,
                      ?BROADCAST_MESSAGE_CLASS_DOMAIN,
                      ?BROADCAST_MESSAGE_CLASS_RESERVED,
                      ?BROADCAST_MESSAGE_CLASS_NO_CLASS, 
                      ?ESME_RINVBCASTMSGCLASS)). 

%%%
% broadcast_rep_num
%
% %@doc The value 0 has the following significance:
%
% <ul>
%   <li>If no validity_period has been specified for a broadcast, then the
%     broadcasts should be repeated indefinitely.
%   </li>
%   <li>If a validity_period and a broadcast_frequency_interval have been
%     specified, then 0 in this field indicates that the broadcast_rep_num is
%     implicit according to the settings of these parameters.
%   </li>
% </ul>
%
% <p>Where a broadcast priority (i.e. priority_flag setting) of 1 (Immediate
% Broadcast) has been requested, then the broadcast_rep_num parameter should
% not be supplied and be ignored if supplied.</p>
%
% <p>Wireless Network Technology:  GSM</p>
% %@end
%%
-define(BROADCAST_REP_NUM,
        ?MANDATORY_TLV(broadcast_rep_num,
                       16#0604, 
                       ?BROADCAST_REP_NUM_DOMAIN, 
                       ?BROADCAST_REP_NUM_RESERVED, 
                       undefined, 
                       ?ESME_RINVBCAST_REP)).

%%%
% broadcast_service_group
%
% %@doc The value is a free format Octet String.
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
% %@end
%%
-define(BROADCAST_SERVICE_GROUP, 
        ?OPTIONAL_TLV(broadcast_service_group,
                      16#060A,
                      ?BROADCAST_SERVICE_GROUP_DOMAIN,
                      ?BROADCAST_SERVICE_GROUP_RESERVED,
                      undefined,
                      ?ESME_RINVBCASTSRVGRP)).

%%%
% callback_num
%
% %@doc A call-back number associated with the short message.
%
% <p>This parameter can be included a number of times for multiple call-back 
% addresses.  List of callback_num records.</p>
%
% <p>A callback_num value should be defined using the callback_num record.</p>
%
% <p>Wireless Network Technology:  CDMA, TDMA, GSM, iDEN</p>
%
% %@see callback_num record definition on smpp_base.hrl
% %@end
%%
-define(CALLBACK_NUM, 
        ?MULTIPLE_OPTIONAL_TLV(callback_num,
                               16#0381, 
                               ?CALLBACK_NUM_DOMAIN, 
                               ?CALLBACK_NUM_RESERVED, 
                               undefined, 
                               undefined)).

%%%
% callback_num_atag
%
% %@doc Associates a displayable alphanimeric tag with the call-back number.  
%
% <p>If this parameter is present and there are multiple instances of the
% callback_num parameter then this parameter must occur an equal number of
% instances and the order of occurrence determines the particular
% callback_num_atag which corresponds to a particular callback_num.  List
% of callback_num_atag records.</p>
%
% <p>A callback_num_atag value should be defined using the callback_num record.
% </p>
%
% <p>Wireless Network Technology:  TDMA</p>
%
% %@see callback_num_atag record definition on smpp_base.hrl
% %@end
%%
-define(CALLBACK_NUM_ATAG, 
        ?MULTIPLE_OPTIONAL_TLV(callback_num_atag,
                               16#0303, 
                               ?CALLBACK_NUM_ATAG_DOMAIN, 
                               ?CALLBACK_NUM_ATAG_RESERVED, 
                               undefined, 
                               undefined)).

%%%
% callback_num_pres_ind
%
% %@doc Defines the call-back number presentation and screening.  
%
% <p>If this parameter is present and there are multiple instances of the
% callback_num parameter then this parameter must occur an equal number of
% instances and the order of occurrence determines the particular
% callback_num_pres_ind which corresponds to a particular callback_num.
% List of 1 octet integers.</p>
%
% <p>Wireless Network Technology:  TDMA</p>
% %@end
%%
-define(CALLBACK_NUM_PRES_IND, 
        ?MULTIPLE_OPTIONAL_TLV(callback_num_pres_ind,
                               16#0302, 
                               ?CALLBACK_NUM_PRES_IND_DOMAIN, 
                               ?CALLBACK_NUM_PRES_IND_RESERVED, 
                               undefined, 
                               undefined)).

%%%
% congestion_state
%
% %@doc Wireless Network Technology:  Generic
% %@end
%%
-define(CONGESTION_STATE, 
        ?OPTIONAL_TLV(congestion_state,
                      16#0428, 
                      ?CONGESTION_STATE_DOMAIN, 
                      ?CONGESTION_STATE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% delivery_failure_reason
%
% %@doc Wireless Network Technology:  Generic
% %@end
%%
-define(DELIVERY_FAILURE_REASON, 
        ?OPTIONAL_TLV(delivery_failure_reason,
                      16#0425, 
                      ?DELIVERY_FAILURE_REASON_DOMAIN, 
                      ?DELIVERY_FAILURE_REASON_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_addr_np_country
%
% %@doc E.164 information to the operator country code.  Refer to e164.hrl for 
% a complete list of E.164 country codes.   Integer, 5 octets.
%
% <p>A list with all countries and global destinations with a country codes
% can be found on e164.hrl</p>
%
% <p>Wireless Network Technology:  CDMA, TDMA (US Only)</p>
%
% %@see e164.hrl
% %@end
%%
-define(DEST_ADDR_NP_COUNTRY, 
        ?OPTIONAL_TLV(dest_addr_np_country,
                      16#0613, 
                      ?DEST_ADDR_NP_COUNTRY_DOMAIN, 
                      ?DEST_ADDR_NP_COUNTRY_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_addr_np_information
%
% %@doc Number portability information for the destination address.  Octet
% String, Fixed 10 octets.
%
% <p>Wireless Network Technology:  CDMA, TDMA (US Only)</p>
% %@end
%%
-define(DEST_ADDR_NP_INFORMATION, 
        ?OPTIONAL_TLV(dest_addr_np_information,
                      16#0612, 
                      ?DEST_ADDR_NP_INFORMATION_DOMAIN, 
                      ?DEST_ADDR_NP_INFORMATION_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_addr_np_resolution
%
% %doc Number portability query indicator.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  CDMA, TDMA (US Only)</p>
% %@end
%%
-define(DEST_ADDR_NP_RESOLUTION, 
        ?OPTIONAL_TLV(dest_addr_np_resolution,
                      16#0611, 
                      ?DEST_ADDR_NP_RESOLUTION_DOMAIN, 
                      ?DEST_ADDR_NP_RESOLUTION_RESERVED, 
                      ?DEST_ADDR_NP_RESOLUTION_NO_QUERY_PERFORMED, 
                      undefined)).

%%%
% dest_addr_subunit
%
% %@doc The subcomponent in the destination device for which the user data is
% intended.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  GSM</p>
% %@end
%%
-define(DEST_ADDR_SUBUNIT,   
        ?OPTIONAL_TLV(dest_addr_subunit,
                      16#0005, 
                      ?DEST_ADDR_SUBUNIT_DOMAIN,
                      ?DEST_ADDR_SUBUNIT_RESERVED,
                      ?ADDR_SUBUNIT_UNKNOWN,
                      ?ESME_RINVDSTADDRSUBUNIT)).

%%%
% dest_bearer_type
%
% %@doc The correct beared type for delivering the user data to the 
% destination. Integer, 1 octet.
%
% <p>Wireless Network Technology:  Generic</p>
% %@doc
%%
-define(DEST_BEARER_TYPE,   
        ?OPTIONAL_TLV(dest_bearer_type,
                      16#0007, 
                      ?DEST_BEARER_TYPE_DOMAIN, 
                      ?DEST_BEARER_TYPE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_network_id
%
% %@doc Identification of the destination network. C-Octet String, Var. max
% 65 octets.
%
% <p>Unique address that may be derived and assigned bye the node owner without
% establishing a central assignment and management authority.</p>
%
% <p>When this TLV is specified, it must be accompanied with a dest_node_id
% TLV.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(DEST_NETWORK_ID,   
        ?OPTIONAL_TLV(dest_network_id,
                      16#060E, 
                      ?DEST_NETWORK_ID_DOMAIN, 
                      ?DEST_NETWORK_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_network_type
%
% %@doc The correct network for the destination device.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(DEST_NETWORK_TYPE,   
        ?OPTIONAL_TLV(dest_network_type,
                      16#0006, 
                      ?DEST_NETWORK_TYPE_DOMAIN, 
                      ?DEST_NETWORK_TYPE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_node_id
%
% %@doc Identification of the destination node.  Octet String, Fixed 6 octets.
%
% <p>Sequence of 6 decimal digits identifying the destination node.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(DEST_NODE_ID,
        ?OPTIONAL_TLV(dest_node_id,
                      16#0610, 
                      ?DEST_NODE_ID_DOMAIN, 
                      ?DEST_NODE_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_subaddress
%
% %@doc The sub-address of the message destination.   Record of type 
% subaddress.
%
% <p>A dest_subaddress value should be defined using the subaddress record.</p>
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see subaddress record definition smpp_base.hrl
% %@end
%%
-define(DEST_SUBADDRESS,   
        ?OPTIONAL_TLV(dest_subaddress,
                      16#0203, 
                      ?DEST_SUBADDRESS_DOMAIN, 
                      ?DEST_SUBADDRESS_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_telematics_id
%
% %@doc The telematics identifier associated with the destination.  Record of
% type telematics_id.
%
% <p>A dest_telematics_id value should be defined using the telematics_id 
% record.</p>
%
% <p>Wireless Network Technology:  GSM</p>
%
% %@see telematics_id record definition on smpp_base.hrl
% %@end
%%
-define(DEST_TELEMATICS_ID,   
        ?OPTIONAL_TLV(dest_telematics_id,
                      16#0008, 
                      ?DEST_TELEMATICS_ID_DOMAIN, 
                      ?DEST_TELEMATICS_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% dest_port
%
% %@doc Indicates de application port number associated with destination 
% address of the message.  This parameter should be present for WAP 
% applications. Integer, 2 octets.
%
% <p>All values allowed.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(DEST_PORT, 
        ?OPTIONAL_TLV(dest_port,
                      16#020B, 
                      ?DEST_PORT_DOMAIN, 
                      ?DEST_PORT_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% display_time
%
% %@doc Provides the receiving MS with a display time associated with the 
% message. Integer, 1 octet.
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see section 4.8.4.31 on [SMPP 5.0]
% %@end
%%
-define(DISPLAY_TIME, 
        ?OPTIONAL_TLV(display_time,
                      16#1201,
                      ?DISPLAY_TIME_DOMAIN, 
                      ?DISPLAY_TIME_RESERVED, 
                      ?DISPLAY_TIME_DEFAULT, 
                      undefined)).

%%%
% dpf_result
%
% %@doc Wireless Network Technology:  Generic
%
% %@see section 4.8.4.32 on [SMPP 5.0]
% %@end
%%
-define(DPF_RESULT, 
        ?OPTIONAL_TLV(dpf_result,
                      16#0420, 
                      ?DPF_RESULT_DOMAIN, 
                      ?DPF_RESULT_RESERVED, 
                      ?DPF_RESULT_NOT_SET, 
                      undefined)).

%%%
% its_reply_type
%
% %@doc The MS user's reply method to an SMS delivery message received from the
% network, is indicated and cotrolled by this parameter. Integer, 1 octet.
%
% <p>Wireless Network Technology:  CDMA</p>
%
% %@see section 4.8.4.33 on [SMPP 5.0]
% %@end
%%
-define(ITS_REPLY_TYPE, 
        ?OPTIONAL_TLV(its_reply_type,
                      16#1380, 
                      ?ITS_REPLY_TYPE_DOMAIN, 
                      ?ITS_REPLY_TYPE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% its_session_info
%
% %@doc Session control information for interactive Teleservice. Record of type
% its_session_info.
%
% <p>A its_session_info value should be defined using the its_session_info
% record.</p>
%
% <p>Wireless Network Technology:  CDMA</p>
%
% %@see section 4.8.4.34 on [SMPP 5.0]
% %@see its_session_info record definition on smpp_base.hrl
% %@end
%%
-define(ITS_SESSION_INFO, 
        ?OPTIONAL_TLV(its_session_info,
                      16#1383, 
                      ?ITS_SESSION_INFO_DOMAIN, 
                      ?ITS_SESSION_INFO_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% language_indicator
%
% %@doc Indicates the language of an alphanumeric text message. Integer, 1 
% octet.
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see section 4.8.4.35 on [SMPP 5.0]
% %@end
%%
-define(LANGUAGE_INDICATOR, 
        ?OPTIONAL_TLV(language_indicator,
                      16#020D, 
                      ?LANGUAGE_INDICATOR_DOMAIN, 
                      ?LANGUAGE_INDICATOR_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% message_payload
%
% %@doc Contains the extended short message user data.  Up to 64K octets can be
% transmitted.  Octet String, Var. max 65536.
%
% <p>Note:  The short message data should be inserted in either the
% short_message or message_payload fields.  Both fields should not be
% used simultaneously.</p>
%
% <p>The sm_length field should be set to zero if using the message_payload
% parameter.</p>
%
% <p>Note:  In the case of data_sm. the message_payload TLV is the only
% means of specifying text.</p>
%
% <p>The maximun size is MC and network implementation specific.</p>
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.36 on [SMPP 5.0]
% %@end
%%
% As for most of PDUs
-define(OPTIONAL_MESSAGE_PAYLOAD, 
        ?OPTIONAL_TLV(message_payload,
                      16#0424, 
                      ?MESSAGE_PAYLOAD_DOMAIN, 
                      ?MESSAGE_PAYLOAD_RESERVED, 
                      undefined, 
                      undefined)).

% As for data_sm
-define(MANDATORY_MESSAGE_PAYLOAD, 
        ?MANDATORY_TLV(message_payload,
                       16#0424, 
                       ?MESSAGE_PAYLOAD_DOMAIN, 
                       ?MESSAGE_PAYLOAD_RESERVED, 
                       undefined, 
                       undefined)).

%%%
% message_state
%
% %@doc Values as per message_state field.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.37 on [SMPP 5.0]
% %@end
%%
% As for most PDUs
-define(OPTIONAL_MESSAGE_STATE, 
        ?OPTIONAL_TLV(message_state,
                      16#0427, 
                      ?MESSAGE_STATE_DOMAIN, 
                      ?MESSAGE_STATE_RESERVED, 
                      undefined, 
                      undefined)).

% As for query_broadcast_sm_resp
-define(MANDATORY_MESSAGE_STATE, 
        ?MANDATORY_TLV(message_state,
                       16#0427, 
                       ?MESSAGE_STATE_DOMAIN, 
                       ?MESSAGE_STATE_RESERVED, 
                       undefined, 
                       undefined)).

%%%
% more_messages_to_send
%
% %@doc Indicates that there are more messages to follow for the destination 
% SME. Integer, 1 octet.
%
% <p>Wireless Network Technology:  GSM</p>
%
% %@see section 4.8.4.38 on [SMPP 5.0]
% %@end
%%
-define(MORE_MESSAGES_TO_SEND, 
        ?OPTIONAL_TLV(more_messages_to_send,
                      16#0426, 
                      ?MORE_MESSAGES_TO_SEND_DOMAIN, 
                      ?MORE_MESSAGES_TO_SEND_RESERVED, 
                      ?MORE_MESSAGES_TO_SEND_YES,
                      undefined)).

%%%
% ms_availability_status
%
% %@doc Wireless Network Technology:  Generic
%
% %@see section 4.8.4.39 on [SMPP 5.0]
% %@end
%%
-define(MS_AVAILABILITY_STATUS, 
        ?OPTIONAL_TLV(ms_availability_status,
                      16#0422, 
                      ?MS_AVAILABILITY_STATUS_DOMAIN,
                      ?MS_AVAILABILITY_STATUS_RESERVED,
                      ?MS_AVAILABILITY_STATUS_AVAILABLE,
                      undefined)).

%%%
% ms_msg_wait_facilities
%
% %@doc This parameter controls the indication and specifies the message type
% (of the message associate with the MWI) at the mobile station.  Integer, 1
% octet.
%
% <p>Wireless Network Technology:  GSM</p>
%
% %@see section 4.8.4.40 on [SMPP 5.0]
% %@doc
%%
-define(MS_MSG_WAIT_FACILITIES, 
        ?OPTIONAL_TLV(ms_msg_wait_facilities,
                      16#0030, 
                      ?MS_MSG_WAIT_FACILITIES_DOMAIN, 
                      ?MS_MSG_WAIT_FACILITIES_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% ms_validity
%
% %@doc Indicates validity information for this message to the recipient MS.
% Record of type ms_validity_absolute or ms_validity_relative.
%
% <p>A ms_validity value should be defined using the ms_validity_absolute or
% ms_validity_relative record.</p>
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see section 4.8.4.41 on [SMPP 5.0]
% %@see ms_validity_absolute and ms_validity_relative record definitions on
%       smpp_base.hrl
% %@end
%%
-define(MS_VALIDITY, 
        ?OPTIONAL_TLV(ms_validity,
                      16#1204, 
                      ?MS_VALIDITY_DOMAIN, 
                      ?MS_VALIDITY_RESERVED, 
                      ?MS_VALIDITY_DEFAULT, 
                      undefined)).

%%%
% network_error_code 
%
% %@doc A network_error_code value should be defined using the 
% <tt>network_error_code</tt> record.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.42 on [SMPP 5.0]
% %@see network_error_code record definition on smpp_base.hrl
% %@end
%%
-define(NETWORK_ERROR_CODE, 
        ?OPTIONAL_TLV(network_error_code,
                      16#0423, 
                      ?NETWORK_ERROR_CODE_DOMAIN, 
                      ?NETWORK_ERROR_CODE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% number_of_messages
%
% %@doc Wireless Network Technology:  CDMA
%
% %@see section 4.8.4.43 on [SMPP 5.0]
% %@end
%%
-define(NUMBER_OF_MESSAGES, 
        ?OPTIONAL_TLV(number_of_messages,
                      16#0304, 
                      ?NUMBER_OF_MESSAGES_DOMAIN, 
                      ?NUMBER_OF_MESSAGES_RESERVED, 
                      undefined, 
                      ?ESME_RINVNUMMSGS)).

%%%
% payload_type
%
% %@doc Defines the type of payload (e.g. WDP, WCMP, etc.).  Integer, 1 octet.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.44 on [SMPP 5.0]
% %@end
%%
-define(PAYLOAD_TYPE, 
        ?OPTIONAL_TLV(payload_type,
                      16#0019, 
                      ?PAYLOAD_TYPE_DOMAIN, 
                      ?PAYLOAD_TYPE_RESERVED, 
                      ?PAYLOAD_TYPE_DEFAULT, 
                      undefined)).

%%%
% privacy_indicator
%
% %@doc Indicates the level of privacy associated with the message.  Integer, 1
% octet.
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see section 4.8.4.45 on [SMPP 5.0]
% %@end
%%
-define(PRIVACY_INDICATOR, 
        ?OPTIONAL_TLV(privacy_indicator,
                      16#0201, 
                      ?PRIVACY_INDICATOR_DOMAIN, 
                      ?PRIVACY_INDICATOR_RESERVED, 
                      ?PRIVACY_INDICATOR_NOT_RESTRICTED,
                      undefined)).

%%%
% qos_time_to_live 
%
% %@doc Time to live as a relative time in seconds from submission.  Integer, 4
% octets.
%
% <p>If not present, the MC may apply a default value.</p>
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.46 on [SMPP 5.0]
% %@end
%%
-define(QOS_TIME_TO_LIVE, 
        ?OPTIONAL_TLV(qos_time_to_live,
                      16#0017, 
                      ?QOS_TIME_TO_LIVE_DOMAIN, 
                      ?QOS_TIME_TO_LIVE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% receipted_message_id 
%
% %@doc Same as message_id parameter.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.47 on [SMPP 5.0]
% %@end
%%
-define(RECEIPTED_MESSAGE_ID, 
        ?OPTIONAL_TLV(receipted_message_id,
                      16#001E, 
                      ?RECEIPTED_MESSAGE_ID_DOMAIN, 
                      ?RECEIPTED_MESSAGE_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% sar_msg_ref_num
%
% %@doc The reference number for a particular concatenated short message. 
% Integer, 2 octets.
%
% <p>Current implementation automatically fills this field with the lower 
% order bytes of the sequence_number of the first segment.</p>
%
% <p>Current implementation automatically fills this field with the lower 
% order bytes of the sequence_number of the first segment.</p>
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.48 on [SMPP 5.0]
% %@end
%%
-define(SAR_MSG_REF_NUM, 
        ?OPTIONAL_TLV(sar_msg_ref_num,
                      16#020C, 
                      ?SAR_MSG_REF_NUM_DOMAIN, 
                      ?SAR_MSG_REF_NUM_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% sar_segment_seqnum
%
% %@doc Indicates the sequence number of a particular short message fragment 
% within the concatenated short message.  Integer, 1 octet.
%
% <p>A Value in the range 1 to 255 indicating the sequence number of a
% particular message within the concatenated short message.</p>
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.49 on [SMPP 5.0]
% %@end
%%
-define(SAR_SEGMENT_SEQNUM, 
        ?OPTIONAL_TLV(sar_segment_seqnum,
                      16#020F, 
                      ?SAR_SEGMENT_SEQNUM_DOMAIN, 
                      ?SAR_SEGMENT_SEQNUM_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% sar_total_segments
%
% %@doc Indicates the total number of short message segments within the 
% concatenated short message.  Integer, 1 octet.
%
% <p>A Value in the range 1 to 255 indicating the total number of fragments
% within the concatenated short message.</p>
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.50 on [SMPP 5.0]
% %@end
%%
-define(SAR_TOTAL_SEGMENTS, 
        ?OPTIONAL_TLV(sar_total_segments,
                      16#020E, 
                      ?SAR_TOTAL_SEGMENTS_DOMAIN, 
                      ?SAR_TOTAL_SEGMENTS_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% sc_interface_version
%
% %@doc Values as per interface_version, see above.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.51 on [SMPP 5.0]
% %@end
%%
-define(SC_INTERFACE_VERSION, 
        ?OPTIONAL_TLV(sc_interface_version,
                      16#0210, 
                      ?SC_INTERFACE_VERSION_DOMAIN, 
                      ?SC_INTERFACE_VERSION_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% set_dpf
%
% %@doc Indicator for setting mechanism when the message is received by an MS.
% Integer, 1 octet.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.52 on [SMPP 5.0]
% %@end
%%
-define(SET_DPF, 
        ?OPTIONAL_TLV(set_dpf,
                      16#0421, 
                      ?SET_DPF_DOMAIN, 
                      ?SET_DPF_RESERVED, 
                      ?SET_DPF_REQUESTED, 
                      undefined)).

%%%
% sms_signal
%
% %@doc Indicates the alerting mechanism when the message is received by an MS.
% Integer, 2 octets.
%
% <p>Wireless Network Technology:  TDMA</p>
%
% %@see section 4.8.4.53 on [SMPP 5.0]
% %@end
%%
-define(SMS_SIGNAL, 
        ?OPTIONAL_TLV(sms_signal,
                      16#1203, 
                      ?SMS_SIGNAL_DOMAIN, 
                      ?SMS_SIGNAL_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_addr_subunit
%
% %@doc The subcomponent in the destination device, which created the user 
% data.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  GSM</p>
%
% %@see section 4.8.4.54 on [SMPP 5.0]
% %@end
%%
-define(SOURCE_ADDR_SUBUNIT, 
        ?OPTIONAL_TLV(source_addr_subunit,
                      16#000D,
                      ?SOURCE_ADDR_SUBUNIT_DOMAIN,
                      ?SOURCE_ADDR_SUBUNIT_RESERVED,
                      undefined,
                      ?ESME_RINVSRCADDRSUBUNIT)).


%%%
% source_bearer_type
%
% %@doc The correct bearer type for delivering the user data to the 
% destination.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  Generic</p>
%
% %@see section 4.8.4.55 on [SMPP 5.0]
% %@end
%%
-define(SOURCE_BEARER_TYPE, 
        ?OPTIONAL_TLV(source_bearer_type,
                      16#000F, 
                      ?SOURCE_BEARER_TYPE_DOMAIN, 
                      ?SOURCE_BEARER_TYPE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_network_id
%
% %@doc Identification of source network.  C-Octet String, Var. max 65 octets.
%
% <p>Unique address that may be derived and assigned bye the node owner without
% establishing a central assignment and management authority.</p>
%
% <p>When this TLV is specified, it must be accompanied with a source_node_id
% TLV.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(SOURCE_NETWORK_ID, 
        ?OPTIONAL_TLV(source_network_id,
                      16#060D, 
                      ?SOURCE_NETWORK_ID_DOMAIN, 
                      ?SOURCE_NETWORK_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_network_type
%
% %@doc The correct network associated with the originating device.  Integer, 1
% octet.
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(SOURCE_NETWORK_TYPE, 
        ?OPTIONAL_TLV(source_network_type,
                      16#000E, 
                      ?SOURCE_NETWORK_TYPE_DOMAIN, 
                      ?SOURCE_NETWORK_TYPE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_node_id
%
% %@doc Identification of the source node.  Octet String, Fixed 6 octets.
%
% <p>Sequence of 6 decimal digits identifying the source node.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(SOURCE_NODE_ID, 
        ?OPTIONAL_TLV(source_node_id,
                      16#060F, 
                      ?SOURCE_NODE_ID_DOMAIN, 
                      ?SOURCE_NODE_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_port
%
% %@doc Indicates the application port number associated with the source 
% address of the message.  This parameter should be present for WAP 
% applications.  Integer, 2 octets.
%
% <p>All values allowed.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(SOURCE_PORT, 
        ?OPTIONAL_TLV(source_port,
                      16#020A, 
                      ?SOURCE_PORT_DOMAIN, 
                      ?SOURCE_PORT_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_subaddress
%
% %@doc The sub-address of the message originator.  Record of type subaddress.
%
% <p>A source_subaddress value should be defined using the subaddress 
% record.</p>
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
%
% %@see subaddress record definition smpp_base.hrl
% %@end
%%
-define(SOURCE_SUBADDRESS, 
        ?OPTIONAL_TLV(source_subaddress,
                      16#0202, 
                      ?SOURCE_SUBADDRESS_DOMAIN, 
                      ?SOURCE_SUBADDRESS_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% source_telematics_id
%
% %@doc The telematics identifier associated with the source.  Record of type
% telematics_id.
%
% <p>A source_telematics_id value should be defined using the telematics_id
% record.</p>
%
% <p>Wireless Network Technology:  GSM</p>
%
% %@see telematics_id record definition on smpp_base.hrl
% %@end
%%
-define(SOURCE_TELEMATICS_ID, 
        ?OPTIONAL_TLV(source_telematics_id,
                      16#0010, 
                      ?SOURCE_TELEMATICS_ID_DOMAIN, 
                      ?SOURCE_TELEMATICS_ID_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% user_message_reference 
%
% %@doc ESME assigned message reference number.  Integer, 2 octets.
%
% <p>All values allowed.</p>
%
% <p>Wireless Network Technology:  Generic</p>
% %@end
%%
-define(USER_MESSAGE_REFERENCE, 
        ?OPTIONAL_TLV(user_message_reference,
                      16#0204, 
                      ?USER_MESSAGE_REFERENCE_DOMAIN, 
                      ?USER_MESSAGE_REFERENCE_RESERVED, 
                      undefined, 
                      undefined)).

%%%
% user_response_code 
%
% %@doc A user response code.  The actual response codes are implementation 
% specific.  Integer, 1 octet.
%
% <p>Application specific.</p>
%
% <ul>
%   <li>0 to 255 (IS-96 CDMA)</li> 
%   <li>0 to 12 (CMT-136 TDMA)</li>
% </ul>
%
% <p>Wireless Network Technology:  CDMA, TDMA</p>
% %@end
%%
-define(USER_RESPONSE_CODE, 
        ?OPTIONAL_TLV(user_response_code,
                      16#0205, 
                      ?USER_RESPONSE_CODE_TDMA_DOMAIN,  % Do not uncomment both
                      ?USER_RESPONSE_CODE_RESERVED, 
%                      ?USER_RESPONSE_CODE_CDMA_DOMAIN, 
                      undefined, 
                      undefined)).

%%%
% ussd_service_op
%
% %@doc This parameter is used to identify the required USSD Service type when
% interfacing to a USSD system.  Integer, 1 octet.
%
% <p>Wireless Network Technology:  GSM (USSD)</p>
% %@end
%%
-define(USSD_SERVICE_OP, 
        ?OPTIONAL_TLV(ussd_service_op,
                      16#0501, 
                      ?USSD_SERVICE_OP_DOMAIN, 
                      ?USSD_SERVICE_OP_RESERVED, 
                      undefined, 
                      undefined)).

%%%-------------------------------------------------------------------
% Records
%%--------------------------------------------------------------------

-endif.  % -ifndef(smpp_param)
