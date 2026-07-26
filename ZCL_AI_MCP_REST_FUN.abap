CLASS ZCL_AI_MCP_REST_FUN DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES: if_http_extension.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_domain_value,
             low         TYPE string,
             high        TYPE string,
             description TYPE string,
           END OF ty_domain_value.
    TYPES tt_domain_values TYPE STANDARD TABLE OF ty_domain_value WITH EMPTY KEY.

    TYPES: BEGIN OF ty_domain,
             name        TYPE string,
             data_type   TYPE string,
             length      TYPE i,
             decimals    TYPE i,
             description TYPE string,
             values      TYPE tt_domain_values,
           END OF ty_domain.
    TYPES tt_domains TYPE STANDARD TABLE OF ty_domain WITH EMPTY KEY.

    TYPES: BEGIN OF ty_data_element,
             name        TYPE string,
             domain      TYPE string,
             description TYPE string,
             short_text  TYPE string,
             medium_text TYPE string,
             long_text   TYPE string,
             heading     TYPE string,
             reptext     TYPE string,
             scrtext_s   TYPE string,
             scrtext_m   TYPE string,
             scrtext_l   TYPE string,
           END OF ty_data_element.
    TYPES tt_data_elements TYPE STANDARD TABLE OF ty_data_element WITH EMPTY KEY.

    TYPES: BEGIN OF ty_table_field,
             name            TYPE string,
             data_element    TYPE string,
             key_flag        TYPE abap_bool,
             not_null        TYPE abap_bool,
             position        TYPE i,
             reference_table TYPE string,
             reference_field TYPE string,
             reftable        TYPE string,
             reffield        TYPE string,
             precfield       TYPE string,
           END OF ty_table_field.
    TYPES tt_table_fields TYPE STANDARD TABLE OF ty_table_field WITH EMPTY KEY.

    TYPES: BEGIN OF ty_table,
             name                 TYPE string,
             description          TYPE string,
             delivery_class       TYPE string,
             data_maintenance     TYPE string,
             data_class           TYPE string,
             size_category        TYPE string,
             storage_type         TYPE string,
             enhancement_category TYPE string,
             fields               TYPE tt_table_fields,
           END OF ty_table.
    TYPES tt_tables TYPE STANDARD TABLE OF ty_table WITH EMPTY KEY.

    TYPES: BEGIN OF ty_ddic_request,
             package       TYPE string,
             transport     TYPE string,
             domains       TYPE tt_domains,
             data_elements TYPE tt_data_elements,
             tables        TYPE tt_tables,
           END OF ty_ddic_request.

    TYPES: BEGIN OF ty_source_request,
             object_type TYPE string,
             object_name TYPE string,
             package     TYPE string,
             transport   TYPE string,
             program_type TYPE string,
             subc         TYPE string,
             source_code  TYPE string,
           END OF ty_source_request.

    TYPES: BEGIN OF ty_check_request,
             object_type TYPE string,
             object_name TYPE string,
             source_code TYPE string,
           END OF ty_check_request.

    TYPES: BEGIN OF ty_activate_request,
             object_type TYPE string,
             object_name TYPE string,
           END OF ty_activate_request.

    TYPES: BEGIN OF ty_repair_target,
             kind    TYPE string,
             name    TYPE string,
             version TYPE string,
           END OF ty_repair_target.

    TYPES: BEGIN OF ty_object_repair_request,
             object_type        TYPE string,
             object_name        TYPE string,
             target             TYPE ty_repair_target,
             target_kind        TYPE string,
             target_name        TYPE string,
             target_version     TYPE string,
             source_code        TYPE string,
             check_after_save   TYPE abap_bool,
             activate_after_check TYPE abap_bool,
           END OF ty_object_repair_request.

    TYPES: BEGIN OF ty_lifecycle_options,
             max_repair_rounds     TYPE i,
             activate_after_check  TYPE abap_bool,
             verify_after_activate TYPE abap_bool,
           END OF ty_lifecycle_options.

    TYPES: BEGIN OF ty_lifecycle_request,
             object_type TYPE string,
             object_name TYPE string,
             mode        TYPE string,
             action      TYPE string,
             package     TYPE string,
             transport   TYPE string,
             source_code TYPE string,
             repair      TYPE ty_object_repair_request,
             options     TYPE ty_lifecycle_options,
           END OF ty_lifecycle_request.

    TYPES: BEGIN OF ty_read_request,
             object_type TYPE string,
             object_name TYPE string,
             source_format TYPE string,
           END OF ty_read_request.

    TYPES: BEGIN OF ty_fm_interface_request,
             function_name TYPE string,
           END OF ty_fm_interface_request.

    TYPES: BEGIN OF ty_function_check_request,
             function_name TYPE string,
             source_format TYPE string,
           END OF ty_function_check_request.

    TYPES: BEGIN OF ty_function_group_read_request,
             function_group TYPE string,
             object_name    TYPE string,
             source_format  TYPE string,
           END OF ty_function_group_read_request.

    TYPES: BEGIN OF ty_function_source_request,
             function_name TYPE string,
             source_code   TYPE string,
           END OF ty_function_source_request.

    TYPES: BEGIN OF ty_include_source_request,
             function_group TYPE string,
             include_name   TYPE string,
             source_code    TYPE string,
             check_function TYPE string,
           END OF ty_include_source_request.

    TYPES: BEGIN OF ty_fugr_main_source_request,
             main_program TYPE string,
             source_code  TYPE string,
           END OF ty_fugr_main_source_request.

    TYPES: BEGIN OF ty_message_entry,
             number TYPE string,
             text   TYPE string,
           END OF ty_message_entry.
    TYPES tt_message_entries TYPE STANDARD TABLE OF ty_message_entry WITH EMPTY KEY.
    TYPES tt_bdcdata TYPE STANDARD TABLE OF bdcdata WITH EMPTY KEY.

    TYPES: BEGIN OF ty_message_save_request,
             message_class TYPE string,
             language      TYPE string,
             transport     TYPE string,
             messages      TYPE tt_message_entries,
           END OF ty_message_save_request.

    TYPES: BEGIN OF ty_textpool_entry,
             id    TYPE string,
             key   TYPE string,
             entry TYPE string,
           END OF ty_textpool_entry.
    TYPES tt_textpool_entries TYPE STANDARD TABLE OF ty_textpool_entry WITH EMPTY KEY.

    TYPES: BEGIN OF ty_textpool_save_request,
             object_type    TYPE string,
             object_name    TYPE string,
             function_group TYPE string,
             function_name  TYPE string,
             language       TYPE string,
             transport      TYPE string,
             texts          TYPE tt_textpool_entries,
           END OF ty_textpool_save_request.

    TYPES: BEGIN OF ty_ddic_fields_request,
             type_name TYPE string,
           END OF ty_ddic_fields_request.

    TYPES: BEGIN OF ty_ddic_type_request,
             type_name TYPE string,
           END OF ty_ddic_type_request.

    TYPES: BEGIN OF ty_domain_values_request,
             domain_name TYPE string,
           END OF ty_domain_values_request.

    TYPES: BEGIN OF ty_doma_values_upd_req,
             domain_name TYPE string,
             language    TYPE string,
             package     TYPE string,
             transport   TYPE string,
             mode        TYPE string,
             values      TYPE tt_domain_values,
           END OF ty_doma_values_upd_req.

    TYPES: BEGIN OF ty_class_methods_request,
             class_name TYPE string,
           END OF ty_class_methods_request.

    TYPES: BEGIN OF ty_class_method_read_request,
             class_name     TYPE string,
             object_name    TYPE string,
             method_name    TYPE string,
             version        TYPE string,
             source_format  TYPE string,
           END OF ty_class_method_read_request.

    TYPES: BEGIN OF ty_probe_run_request,
             runner      TYPE string,
             probe_id    TYPE string,
             object_type TYPE string,
             object_name TYPE string,
             class_name  TYPE string,
           END OF ty_probe_run_request.

    TYPES: BEGIN OF ty_probe_result,
             name        TYPE string,
             status      TYPE string,
             severity    TYPE string,
             object_type TYPE string,
             object_name TYPE string,
             stage       TYPE string,
             value       TYPE string,
             message     TYPE string,
           END OF ty_probe_result.
    TYPES tt_probe_results TYPE STANDARD TABLE OF ty_probe_result WITH EMPTY KEY.

    TYPES: BEGIN OF ty_function_parameter,
             name     TYPE string,
             type     TYPE string,
             optional TYPE abap_bool,
             default  TYPE string,
           END OF ty_function_parameter.
    TYPES tt_function_parameters TYPE STANDARD TABLE OF ty_function_parameter WITH EMPTY KEY.

    TYPES: BEGIN OF ty_function_request,
             function_group TYPE string,
             function_name  TYPE string,
             package        TYPE string,
             transport      TYPE string,
             short_text     TYPE string,
             source_code    TYPE string,
             importing      TYPE tt_function_parameters,
             exporting      TYPE tt_function_parameters,
             changing       TYPE tt_function_parameters,
             tables         TYPE tt_function_parameters,
           END OF ty_function_request.

    TYPES: BEGIN OF ty_lock_request,
             object_name TYPE string,
           END OF ty_lock_request.

    TYPES: BEGIN OF ty_dynpro_request,
             program     TYPE string,
             screen      TYPE string,
             screen_type TYPE string,
             language    TYPE string,
             description TYPE string,
             request     TYPE string,
           END OF ty_dynpro_request.

    TYPES: BEGIN OF ty_dynpro_read_request,
             program TYPE string,
             screen  TYPE string,
           END OF ty_dynpro_read_request.

    TYPES: BEGIN OF ty_dynpro_element,
             container TYPE string,
             name      TYPE string,
             type      TYPE string,
             text      TYPE string,
             line      TYPE i,
             column    TYPE i,
             length    TYPE i,
             height    TYPE i,
             vislength TYPE i,
             fcode     TYPE string,
             ref_field TYPE string,
             icon_name TYPE string,
             icon_text TYPE string,
             group1    TYPE string,
             format    TYPE string,
             input     TYPE abap_bool,
             output    TYPE abap_bool,
             invisible TYPE abap_bool,
             selected  TYPE abap_bool,
           END OF ty_dynpro_element.
    TYPES tt_dynpro_elements TYPE STANDARD TABLE OF ty_dynpro_element WITH EMPTY KEY.
    TYPES tt_dynpro_flow_lines TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TYPES: BEGIN OF ty_dynpro_container,
             name            TYPE string,
             type            TYPE string,
             element_of      TYPE string,
             line            TYPE i,
             column          TYPE i,
             length          TYPE i,
             height          TYPE i,
             resize_v        TYPE abap_bool,
             resize_h        TYPE abap_bool,
             scroll_v        TYPE abap_bool,
             scroll_h        TYPE abap_bool,
             line_min        TYPE i,
             column_min      TYPE i,
             table_type      TYPE string,
             table_header    TYPE abap_bool,
             table_config    TYPE abap_bool,
             select_lines    TYPE string,
             select_columns  TYPE string,
             line_selector   TYPE abap_bool,
             fixed_columns   TYPE i,
           END OF ty_dynpro_container.
    TYPES tt_dynpro_containers TYPE STANDARD TABLE OF ty_dynpro_container WITH EMPTY KEY.

    TYPES: BEGIN OF ty_dynpro_custom_control,
             name     TYPE string,
             line     TYPE i,
             column   TYPE i,
             length   TYPE i,
             height   TYPE i,
             resize_v TYPE abap_bool,
             resize_h TYPE abap_bool,
           END OF ty_dynpro_custom_control.
    TYPES tt_dynpro_custom_controls TYPE STANDARD TABLE OF ty_dynpro_custom_control WITH EMPTY KEY.

    TYPES: BEGIN OF ty_dynpro_column,
             field         TYPE string,
             field_type    TYPE string,
             abap_type     TYPE string,
             template_text TYPE string,
             heading_text  TYPE string,
             column        TYPE i,
             length        TYPE i,
             vislength     TYPE i,
             input         TYPE abap_bool,
             output        TYPE abap_bool,
             generate_heading TYPE abap_bool,
             selection_column TYPE abap_bool,
             omit_column   TYPE abap_bool,
           END OF ty_dynpro_column.
    TYPES tt_dynpro_columns TYPE STANDARD TABLE OF ty_dynpro_column WITH EMPTY KEY.

    TYPES: BEGIN OF ty_dynpro_table_control,
             name           TYPE string,
             data_table     TYPE string,
             line           TYPE i,
             column         TYPE i,
             length         TYPE i,
             height         TYPE i,
             lines_variable TYPE string,
             separ_v        TYPE abap_bool,
             separ_h        TYPE abap_bool,
             scroll_v       TYPE abap_bool,
             scroll_h       TYPE abap_bool,
             resize_v       TYPE abap_bool,
             resize_h       TYPE abap_bool,
             config         TYPE abap_bool,
             select_lines   TYPE abap_bool,
             select_columns TYPE abap_bool,
             line_selector  TYPE abap_bool,
             fixed_columns  TYPE i,
             line_min       TYPE i,
             column_min     TYPE i,
           END OF ty_dynpro_table_control.

    TYPES: BEGIN OF ty_dynpro_json_request,
             program                 TYPE string,
             screen                  TYPE string,
             screen_type             TYPE string,
             language                TYPE string,
             description             TYPE string,
             request                 TYPE string,
             replace_existing        TYPE abap_bool,
             next_screen             TYPE string,
             screen_lines            TYPE i,
             screen_columns          TYPE i,
             top_include             TYPE string,
             function_name_for_check TYPE string,
             ok_code                 TYPE string,
             table_control           TYPE ty_dynpro_table_control,
             screen_elements         TYPE tt_dynpro_elements,
             columns                 TYPE tt_dynpro_columns,
             flow_logic              TYPE tt_dynpro_flow_lines,
             pbo_modules             TYPE tt_dynpro_flow_lines,
             loop_pbo_modules        TYPE tt_dynpro_flow_lines,
             loop_pai_modules        TYPE tt_dynpro_flow_lines,
             pai_modules             TYPE tt_dynpro_flow_lines,
           END OF ty_dynpro_json_request.

    TYPES: BEGIN OF ty_dynpro_custom_request,
             program                 TYPE string,
             screen                  TYPE string,
             screen_type             TYPE string,
             language                TYPE string,
             description             TYPE string,
             request                 TYPE string,
             replace_existing        TYPE abap_bool,
             next_screen             TYPE string,
             screen_lines            TYPE i,
             screen_columns          TYPE i,
             ok_code                 TYPE string,
             custom_controls         TYPE tt_dynpro_custom_controls,
             screen_elements         TYPE tt_dynpro_elements,
             flow_logic              TYPE tt_dynpro_flow_lines,
           END OF ty_dynpro_custom_request.

    TYPES: BEGIN OF ty_dynpro_layout_request,
             program                 TYPE string,
             screen                  TYPE string,
             screen_type             TYPE string,
             language                TYPE string,
             description             TYPE string,
             request                 TYPE string,
             replace_existing        TYPE abap_bool,
             next_screen             TYPE string,
             screen_lines            TYPE i,
             screen_columns          TYPE i,
             ok_code                 TYPE string,
             containers              TYPE tt_dynpro_containers,
             screen_elements         TYPE tt_dynpro_elements,
             flow_logic              TYPE tt_dynpro_flow_lines,
           END OF ty_dynpro_layout_request.

    METHODS handle_run
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_capabilities
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_check
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_read
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_activate
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_object_repair
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_object_lifecycle
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_function_create
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_function_check
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_function_read
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_function_group_read
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_function_source_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_include_source_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_fugr_main_source_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_message_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_textpool_save
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_ddic_create
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_ddic_validate_names
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_ddic_status
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_doma_values_update
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_fm_interface
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_ddic_fields
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_ddic_type
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_domain_values
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_class_methods
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_class_method_read
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_probe_run
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_locks
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_debug_dynpro_read
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_minimal
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_tc_min
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_json
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_screen
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_cctrl
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS handle_dynpro_import_layout
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS run
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS create_ddic_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS validate_names_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS status_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_source_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS check_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS read_object_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS activate_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS object_repair_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS object_lifecycle_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS create_function_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS check_function_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS read_function_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS read_function_group_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_function_source_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_include_source_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_fugr_main_source_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS message_save_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS textpool_save_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS fm_interface_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS ddic_fields_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS ddic_type_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS domain_values_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS domain_update_values_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS class_methods_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS class_method_read_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS probe_run_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS probe_class_activation_check
      IMPORTING iv_class_name TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS capabilities_json
      RETURNING VALUE(rv_json) TYPE string.

    METHODS locks_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_min_dynpro_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_tc_min_dynpro_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_dynpro_from_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_dynpro_screen_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_dynpro_cctrl_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS import_dynpro_layout_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS dynpro_read_json
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS validate_names
      IMPORTING is_request TYPE ty_ddic_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS domain_exists
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS data_element_exists
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS table_exists
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS is_z_object_name
      IMPORTING iv_name TYPE csequence
      RETURNING VALUE(rv_valid) TYPE abap_bool.

    METHODS validate_fugr_include_write
      IMPORTING
        iv_function_group TYPE csequence
        iv_include        TYPE csequence
        iv_allow_u_include TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(rv_json) TYPE string.

    METHODS get_tadir_json
      IMPORTING
        iv_pgmid       TYPE tadir-pgmid
        iv_object_type TYPE tadir-object
        iv_object_name TYPE csequence
      RETURNING VALUE(rv_json) TYPE string.

    METHODS get_domain_status
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS get_data_element_status
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS get_table_status
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS create_domain
      IMPORTING
        is_domain    TYPE ty_domain
        iv_package   TYPE devclass
        iv_transport TYPE trkorr
      RETURNING VALUE(rv_json) TYPE string.

    METHODS create_data_element
      IMPORTING
        is_data_element TYPE ty_data_element
        iv_package      TYPE devclass
        iv_transport    TYPE trkorr
      RETURNING VALUE(rv_json) TYPE string.

    METHODS create_table
      IMPORTING
        is_table     TYPE ty_table
        iv_package   TYPE devclass
        iv_transport TYPE trkorr
      RETURNING VALUE(rv_json) TYPE string.

    METHODS register_cts_object
      IMPORTING
        iv_object_type TYPE trobjtype
        iv_object_name TYPE csequence
        iv_package     TYPE devclass
        iv_transport   TYPE trkorr
      RETURNING VALUE(rv_json) TYPE string.

    METHODS register_tadir_entry
      IMPORTING
        iv_pgmid       TYPE tadir-pgmid
        iv_object_type TYPE tadir-object
        iv_object_name TYPE csequence
        iv_package     TYPE devclass
      RETURNING VALUE(rv_json) TYPE string.

    METHODS append_cts_object
      IMPORTING
        iv_object_type TYPE trobjtype
        iv_object_name TYPE csequence
        iv_transport   TYPE trkorr
      RETURNING VALUE(rv_json) TYPE string.

    METHODS register_class_tadir_entries
      IMPORTING
        iv_class_name TYPE seoclsname
        iv_package    TYPE devclass
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_report
      IMPORTING is_request TYPE ty_source_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS save_class
      IMPORTING is_request TYPE ty_source_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS activate_report
      IMPORTING is_request TYPE ty_activate_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS activate_class
      IMPORTING is_request TYPE ty_activate_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS syntax_check_source
      IMPORTING is_request TYPE ty_check_request
      RETURNING VALUE(rv_json) TYPE string.

    METHODS append_result
      IMPORTING iv_result TYPE string
      CHANGING cv_json TYPE string.

    METHODS append_bdc_field
      IMPORTING
        iv_program  TYPE csequence OPTIONAL
        iv_dynpro   TYPE csequence OPTIONAL
        iv_dynbegin TYPE abap_bool DEFAULT abap_false
        iv_fnam     TYPE csequence OPTIONAL
        iv_fval     TYPE csequence OPTIONAL
      CHANGING
        ct_bdcdata  TYPE tt_bdcdata.

    METHODS build_sy_message
      IMPORTING iv_fallback TYPE string
      RETURNING VALUE(rv_message) TYPE string.

    METHODS build_fm_error_json
      IMPORTING
        iv_stage       TYPE string
        iv_object_type TYPE csequence
        iv_object_name TYPE csequence
        iv_message     TYPE string
        iv_subrc       TYPE i
        iv_suggestion  TYPE string
      RETURNING VALUE(rv_json) TYPE string.

    METHODS write_json
      IMPORTING
        io_server TYPE REF TO if_http_server
        iv_status TYPE i
        iv_json   TYPE string.
ENDCLASS.



CLASS ZCL_AI_MCP_REST_FUN IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->ACTIVATE_CLASS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_ACTIVATE_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD activate_class.
    DATA lv_class TYPE seoclsname.
    DATA ls_clskey TYPE seoclskey.
    DATA ls_active_class TYPE vseoclass.
    DATA lt_objects TYPE STANDARD TABLE OF dwinactiv WITH EMPTY KEY.
    DATA ls_object TYPE dwinactiv.
    DATA lo_messages TYPE REF TO cl_wb_message_container.
    DATA lo_checklist TYPE REF TO cl_wb_checklist.
    DATA lt_errors TYPE STANDARD TABLE OF swbme_error_entry WITH EMPTY KEY.
    DATA ls_error TYPE swbme_error_entry.
    DATA lv_error_count TYPE i.
    DATA lv_error_text TYPE string.
    DATA lv_msg_text TYPE string.
    DATA lv_fm_subrc TYPE sy-subrc.
    DATA lv_mtext_line TYPE string.

    lv_class = to_upper( is_request-object_name ).

    ls_object-object = 'CLAS'.
    ls_object-obj_name = lv_class.
    ls_object-uname = sy-uname.
    APPEND ls_object TO lt_objects.

    CREATE OBJECT lo_messages.

    TRY.
        CALL FUNCTION 'RS_WORKING_OBJECTS_ACTIVATE'
          EXPORTING
            suppress_syntax_check = space
            suppress_generation = space
            suppress_insert = 'X'
            suppress_corr_insert = 'X'
            with_popup = space
            suppress_enqueue = abap_true
            ui_decoupled = abap_true
            message_container = lo_messages
            check_only = space
          IMPORTING
            p_checklist = lo_checklist
          TABLES
            objects = lt_objects
          EXCEPTIONS
            cancelled = 1
            excecution_error = 2
            insert_into_corr_error = 3
            OTHERS = 4.
      CATCH cx_root INTO DATA(lx_seo_activate).
        rv_json = |\{"status":"ERROR","stage":"CLAS_ACTIVATE","object_type":"CLAS",| &&
                  |"object_name":"{ lv_class }",| &&
                  |"message":"{ escape( val = lx_seo_activate->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                  |"suggestion":"Check whether the class exists, has valid source, and is consistent in Class Builder"\}|.
        RETURN.
    ENDTRY.

    lv_fm_subrc = sy-subrc.
    lv_msg_text = build_sy_message( 'RS_WORKING_OBJECTS_ACTIVATE returned without SAP message text' ).

    IF lo_checklist IS BOUND.
      lo_checklist->get_error_messages(
        IMPORTING
          p_error_tab = lt_errors ).
      DESCRIBE TABLE lt_errors LINES lv_error_count.
      READ TABLE lt_errors INTO ls_error INDEX 1.
      IF sy-subrc = 0.
        LOOP AT ls_error-mtext INTO lv_mtext_line.
          IF lv_error_text IS INITIAL.
            lv_error_text = lv_mtext_line.
          ELSE.
            CONCATENATE lv_error_text lv_mtext_line INTO lv_error_text SEPARATED BY ` `.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lv_fm_subrc <> 0 OR lv_error_count > 0.
      IF lv_error_text IS INITIAL.
        lv_error_text = lv_msg_text.
      ENDIF.
      rv_json = build_fm_error_json(
        iv_stage       = 'CLAS_ACTIVATE'
        iv_object_type = 'CLAS'
        iv_object_name = lv_class
        iv_message     = lv_error_text
        iv_subrc       = lv_fm_subrc
        iv_suggestion  = 'Fix the class activation errors returned by RS_WORKING_OBJECTS_ACTIVATE and retry' ).
      RETURN.
    ENDIF.

    ls_clskey-clsname = lv_class.
    CALL FUNCTION 'SEO_CLASS_GET'
      EXPORTING
        clskey  = ls_clskey
        version = seoc_version_active
      IMPORTING
        class   = ls_active_class
      EXCEPTIONS
        not_existing = 1
        deleted      = 2
        is_interface = 3
        model_only   = 4
        OTHERS       = 5.

    IF sy-subrc <> 0 OR ls_active_class-clsname IS INITIAL.
      rv_json = build_fm_error_json(
        iv_stage       = 'CLAS_ACTIVE_VERIFY'
        iv_object_type = 'CLAS'
        iv_object_name = lv_class
        iv_message     = 'Class activation did not produce an active class version'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check SE24 activation log; the class may be inactive or inconsistent even though SEO_CLASS_ACTIVATE returned without a hard error' ).
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"CLAS","object_name":"{ lv_class }","message":"Class activated"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->ACTIVATE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD activate_from_json.
    DATA ls_request TYPE ty_activate_request.
    DATA lv_object_type TYPE string.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-object_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"object_name is required"}'.
      RETURN.
    ENDIF.

    lv_object_type = to_upper( ls_request-object_type ).
    CASE lv_object_type.
      WHEN 'PROG' OR 'REPORT'.
        rv_json = activate_report( ls_request ).
      WHEN 'CLAS' OR 'CLASS'.
        rv_json = activate_class( ls_request ).
      WHEN OTHERS.
        rv_json = |\{"status":"ERROR","stage":"ACTIVATE","object_name":"{ ls_request-object_name }",| &&
                  |"message":"Only PROG/REPORT and CLAS/CLASS activation are implemented"\}|.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->ACTIVATE_REPORT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_ACTIVATE_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD activate_report.
    DATA lv_program TYPE syrepid.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    lv_program = to_upper( is_request-object_name ).

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"PROG","object_name":"{ lv_program }","message":"Report generated successfully"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"PROG_ACTIVATE","object_type":"PROG",| &&
                |"object_name":"{ lv_program }","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }",| &&
                |"suggestion":"Fix the report source and retry activation"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->APPEND_BDC_FIELD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD append_bdc_field.
    DATA ls_bdcdata TYPE bdcdata.

    CLEAR ls_bdcdata.
    IF iv_dynbegin = abap_true.
      ls_bdcdata-program = iv_program.
      ls_bdcdata-dynpro = iv_dynpro.
      ls_bdcdata-dynbegin = 'X'.
    ELSE.
      ls_bdcdata-fnam = iv_fnam.
      ls_bdcdata-fval = iv_fval.
    ENDIF.
    APPEND ls_bdcdata TO ct_bdcdata.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->APPEND_CTS_OBJECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OBJECT_TYPE                 TYPE        TROBJTYPE
* | [--->] IV_OBJECT_NAME                 TYPE        CSEQUENCE
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD append_cts_object.
    DATA lv_object TYPE tadir-obj_name.
    DATA lv_object_type TYPE e071-object.
    DATA lv_transport TYPE e070-trkorr.
    DATA lv_dialog TYPE trboolean.
    DATA lt_e071 TYPE STANDARD TABLE OF e071.
    DATA lt_e071k TYPE STANDARD TABLE OF e071k.
    DATA ls_e071 TYPE e071.

    lv_object = to_upper( iv_object_name ).
    lv_object_type = iv_object_type.
    lv_transport = iv_transport.
    lv_dialog = space.

    IF iv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_APPEND","object_type":"{ iv_object_type }",| &&
                |"object_name":"{ lv_object }","message":"transport is required"\}|.
      RETURN.
    ENDIF.

    CLEAR ls_e071.
    ls_e071-trkorr = lv_transport.
    ls_e071-pgmid = 'R3TR'.
    ls_e071-object = lv_object_type.
    ls_e071-obj_name = lv_object.
    ls_e071-objfunc = space.
    APPEND ls_e071 TO lt_e071.

    TRY.
        CALL FUNCTION 'TR_APPEND_TO_COMM_OBJS_KEYS'
          EXPORTING
            wi_trkorr  = lv_transport
            iv_dialog  = lv_dialog
          TABLES
            wt_e071    = lt_e071
            wt_e071k   = lt_e071k
          EXCEPTIONS
            OTHERS     = 1.
      CATCH cx_root INTO DATA(lx_cts_append).
        rv_json = |\{"status":"ERROR","stage":"CTS_APPEND_EXCEPTION","object_type":"{ lv_object_type }",| &&
                  |"object_name":"{ lv_object }","transport":"{ lv_transport }",| &&
                  |"message":"{ escape( val = lx_cts_append->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'CTS_APPEND'
        iv_object_type = iv_object_type
        iv_object_name = lv_object
        iv_message     = 'TR_APPEND_TO_COMM_OBJS_KEYS failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check Workbench request status, ownership, target system, locks, and transport authorization' ).
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"{ iv_object_type }","object_name":"{ lv_object }","transport":"{ iv_transport }","message":"Object appended to CTS"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->APPEND_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RESULT                      TYPE        STRING
* | [<-->] CV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD append_result.
    IF cv_json <> '['.
      cv_json = cv_json && ','.
    ENDIF.
    cv_json = cv_json && iv_result.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->BUILD_FM_ERROR_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STAGE                       TYPE        STRING
* | [--->] IV_OBJECT_TYPE                 TYPE        CSEQUENCE
* | [--->] IV_OBJECT_NAME                 TYPE        CSEQUENCE
* | [--->] IV_MESSAGE                     TYPE        STRING
* | [--->] IV_SUBRC                       TYPE        I
* | [--->] IV_SUGGESTION                  TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD build_fm_error_json.
    DATA lv_msgid LIKE sy-msgid.
    DATA lv_msgno LIKE sy-msgno.
    DATA lv_msgv1 LIKE sy-msgv1.
    DATA lv_msgv2 LIKE sy-msgv2.
    DATA lv_msgv3 LIKE sy-msgv3.
    DATA lv_msgv4 LIKE sy-msgv4.
    DATA lv_sap_message TYPE string.

    lv_msgid = sy-msgid.
    lv_msgno = sy-msgno.
    lv_msgv1 = sy-msgv1.
    lv_msgv2 = sy-msgv2.
    lv_msgv3 = sy-msgv3.
    lv_msgv4 = sy-msgv4.
    lv_sap_message = build_sy_message( iv_message ).

    rv_json = |\{"status":"ERROR","stage":"{ iv_stage }",| &&
              |"object_type":"{ iv_object_type }",| &&
              |"object_name":"{ iv_object_name }",| &&
              |"message":"{ escape( val = iv_message format = cl_abap_format=>e_json_string ) }",| &&
              |"sap_message":"{ escape( val = lv_sap_message format = cl_abap_format=>e_json_string ) }",| &&
              |"msgid":"{ lv_msgid }","msgno":"{ lv_msgno }",| &&
              |"msgv1":"{ escape( val = lv_msgv1 format = cl_abap_format=>e_json_string ) }",| &&
              |"msgv2":"{ escape( val = lv_msgv2 format = cl_abap_format=>e_json_string ) }",| &&
              |"msgv3":"{ escape( val = lv_msgv3 format = cl_abap_format=>e_json_string ) }",| &&
              |"msgv4":"{ escape( val = lv_msgv4 format = cl_abap_format=>e_json_string ) }",| &&
              |"subrc":{ iv_subrc },| &&
              |"suggestion":"{ escape( val = iv_suggestion format = cl_abap_format=>e_json_string ) }"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->BUILD_SY_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FALLBACK                    TYPE        STRING
* | [<-()] RV_MESSAGE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD build_sy_message.
    DATA lv_message TYPE string.

    IF sy-msgid IS INITIAL OR sy-msgno IS INITIAL.
      rv_message = iv_fallback.
      RETURN.
    ENDIF.

    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = sy-msgid
        msgnr               = sy-msgno
        msgv1               = sy-msgv1
        msgv2               = sy-msgv2
        msgv3               = sy-msgv3
        msgv4               = sy-msgv4
      IMPORTING
        message_text_output = lv_message
      EXCEPTIONS
        OTHERS              = 1.

    IF sy-subrc = 0 AND lv_message IS NOT INITIAL.
      rv_message = lv_message.
    ELSE.
      rv_message = iv_fallback.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CAPABILITIES_JSON
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD capabilities_json.
    rv_json = '{"status":"OK","handler":"ZCL_AI_MCP_REST_FUN",' &&
              '"features":{' &&
              '"object_read_string":true,' &&
              '"object_read_class":true,' &&
              '"object_repair":true,' &&
              '"object_lifecycle":true,' &&
              '"object_lifecycle_max_repair_rounds":5,' &&
              '"class_method_repair":true,' &&
              '"function_read_string":true,' &&
              '"function_group_read_string":true,' &&
              '"ddic_domain_update_values":true,' &&
              '"include_source_save":true,' &&
              '"textpool_save":true,' &&
              '"dynpro_import_screen":true,' &&
              '"dynpro_import_layout":true,' &&
              '"class_method_read":true,' &&
              '"class_method_read_version":true,' &&
              '"probe_run":true,' &&
              '"probe_class_activation_check":true,' &&
              '"summary_hash":false,' &&
              '"analysis_only":false' &&
              '}}'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CHECK_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_from_json.
    DATA ls_request TYPE ty_check_request.
    DATA lv_object_type TYPE string.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    lv_object_type = to_upper( ls_request-object_type ).
    IF lv_object_type = 'CLAS' OR lv_object_type = 'CLASS'.
      rv_json = activate_from_json(
        |\{"object_type":"CLAS","object_name":"{ to_upper( ls_request-object_name ) }"\}| ).
      RETURN.
    ENDIF.

    IF ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","message":"source_code is required"}'.
      RETURN.
    ENDIF.

    rv_json = syntax_check_source( ls_request ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CHECK_FUNCTION_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_function_from_json.
    DATA ls_request TYPE ty_function_check_request.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_include TYPE rs38l-include.
    DATA lv_namespace TYPE rs38l-namespace.
    DATA lv_str_area TYPE rs38l-str_area.
    DATA lv_program TYPE syrepid.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_check_json).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_CHECK_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_check_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-function_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"function_name is required"}'.
      RETURN.
    ENDIF.

    lv_function_name = to_upper( ls_request-function_name ).

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = lv_function_name
      IMPORTING
        group              = lv_function_group
        include            = lv_include
        namespace          = lv_namespace
        str_area           = lv_str_area
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_EXISTS'
        iv_object_type = 'FUNC'
        iv_object_name = lv_function_name
        iv_message     = 'Function module does not exist or cannot be read'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check function module name and authorization' ).
      RETURN.
    ENDIF.

    lv_program = |SAPL{ lv_function_group }|.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"FUNC","object_name":"{ lv_function_name }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"include":"{ lv_include }",| &&
                |"program":"{ lv_program }",| &&
                |"syntax":\{"status":"OK","messages":[]\}\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_SYNTAX_CHECK","object_type":"FUNC",| &&
                |"object_name":"{ lv_function_name }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"include":"{ lv_include }",| &&
                |"program":"{ lv_program }",| &&
                |"line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }",| &&
                |"syntax":\{"status":"ERROR","messages":[\{| &&
                |"severity":"E","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}]\}\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CLASS_METHODS_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_methods_from_json.
    DATA ls_request TYPE ty_class_methods_request.
    DATA lv_class TYPE seoclsname.
    DATA lt_methods TYPE STANDARD TABLE OF vseomethod WITH EMPTY KEY.
    DATA lt_parameters TYPE STANDARD TABLE OF vseoparam WITH EMPTY KEY.
    DATA lv_methods TYPE string VALUE '['.
    DATA lv_parameters TYPE string VALUE '['.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-class_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"class_name is required"}'.
      RETURN.
    ENDIF.

    lv_class = to_upper( ls_request-class_name ).

    SELECT *
      FROM vseomethod
      INTO TABLE lt_methods
      WHERE clsname = lv_class
      ORDER BY version cmpname.

    SELECT *
      FROM vseoparam
      INTO TABLE lt_parameters
      WHERE clsname = lv_class
      ORDER BY version cmpname sconame.

    LOOP AT lt_methods INTO DATA(ls_method).
      IF lv_methods <> '['.
        lv_methods = lv_methods && ','.
      ENDIF.

      lv_methods = lv_methods &&
        |\{"cmpname":"{ ls_method-cmpname }",| &&
        |"version":"{ ls_method-version }",| &&
        |"exposure":"{ ls_method-exposure }",| &&
        |"state":"{ ls_method-state }",| &&
        |"mtdtype":"{ ls_method-mtdtype }",| &&
        |"mtddecltyp":"{ ls_method-mtddecltyp }"\}|.
    ENDLOOP.

    LOOP AT lt_parameters INTO DATA(ls_parameter).
      IF lv_parameters <> '['.
        lv_parameters = lv_parameters && ','.
      ENDIF.

      lv_parameters = lv_parameters &&
        |\{"cmpname":"{ ls_parameter-cmpname }",| &&
        |"sconame":"{ ls_parameter-sconame }",| &&
        |"version":"{ ls_parameter-version }",| &&
        |"cmptype":"{ ls_parameter-cmptype }",| &&
        |"mtdtype":"{ ls_parameter-mtdtype }",| &&
        |"pardecltyp":"{ ls_parameter-pardecltyp }",| &&
        |"parpasstyp":"{ ls_parameter-parpasstyp }",| &&
        |"typtype":"{ ls_parameter-typtype }",| &&
        |"type":"{ escape( val = ls_parameter-type format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.

    lv_methods = lv_methods && ']'.
    lv_parameters = lv_parameters && ']'.
    rv_json = |\{"status":"OK","class_name":"{ lv_class }","methods":{ lv_methods },"parameters":{ lv_parameters }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CLASS_METHOD_READ_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_method_read_from_json.
    DATA ls_request TYPE ty_class_method_read_request.
    DATA lv_class TYPE seoclsname.
    DATA lv_method TYPE seocmpname.
    DATA lt_method_includes TYPE seop_methods_w_include.
    DATA ls_clskey TYPE seoclskey.
    DATA lv_include TYPE syrepid.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_versions TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_source_code TYPE string.
    DATA lv_source_lines TYPE string VALUE '['.
    DATA lv_requested_version TYPE string.
    DATA lv_current_version TYPE string.
    DATA lv_read_state TYPE c LENGTH 1.
    DATA lv_one_json TYPE string.
    DATA lv_versions_json TYPE string VALUE '['.
    DATA lv_string_only TYPE abap_bool.
    DATA lv_line_count TYPE i.
    DATA lv_non_empty_count TYPE i.
    DATA lv_comment_count TYPE i.
    DATA lv_index TYPE i.
    DATA lv_trimmed TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_method_read_json).
        rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_READ_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_method_read_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_class = to_upper( ls_request-class_name ).
    IF lv_class IS INITIAL.
      lv_class = to_upper( ls_request-object_name ).
    ENDIF.
    lv_method = to_upper( ls_request-method_name ).

    IF lv_class IS INITIAL OR lv_method IS INITIAL.
      rv_json = '{"status":"ERROR","message":"class_name/object_name and method_name are required"}'.
      RETURN.
    ENDIF.

    IF to_upper( ls_request-source_format ) = 'STRING'.
      lv_string_only = abap_true.
    ENDIF.

    lv_requested_version = to_upper( ls_request-version ).
    IF lv_requested_version IS INITIAL.
      lv_requested_version = 'ACTIVE'.
    ENDIF.
    CASE lv_requested_version.
      WHEN 'ACTIVE' OR 'A'.
        APPEND 'ACTIVE' TO lt_versions.
      WHEN 'INACTIVE' OR 'I'.
        APPEND 'INACTIVE' TO lt_versions.
      WHEN 'BOTH' OR 'ALL'.
        APPEND 'ACTIVE' TO lt_versions.
        APPEND 'INACTIVE' TO lt_versions.
      WHEN OTHERS.
        rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_VERSION_VALIDATE",| &&
                  |"class_name":"{ lv_class }","method_name":"{ lv_method }",| &&
                  |"version_requested":"{ escape( val = lv_requested_version format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"version must be ACTIVE, INACTIVE, or BOTH"\}|.
        RETURN.
    ENDCASE.

    ls_clskey-clsname = lv_class.
    CALL FUNCTION 'SEO_CLASS_GET_METHOD_INCLUDES'
      EXPORTING
        clskey   = ls_clskey
      IMPORTING
        includes = lt_method_includes
      EXCEPTIONS
        OTHERS   = 1.

    IF sy-subrc <> 0 OR lt_method_includes IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_INCLUDES","object_type":"CLAS",| &&
                |"class_name":"{ lv_class }","method_name":"{ lv_method }",| &&
                |"message":"Method include metadata could not be read"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_method_includes INTO DATA(ls_method_include).
      IF to_upper( ls_method_include-cpdkey-cpdname ) = lv_method.
        lv_include = ls_method_include-incname.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_include IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_NOT_FOUND","object_type":"CLAS",| &&
                |"class_name":"{ lv_class }","method_name":"{ lv_method }",| &&
                |"message":"Method was not found in class method include metadata"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_versions INTO lv_current_version.
      CLEAR: lt_source, lv_source_code, lv_line_count,
             lv_non_empty_count, lv_comment_count, lv_index.
      lv_source_lines = '['.

      IF lv_current_version = 'INACTIVE'.
        lv_read_state = 'I'.
      ELSE.
        lv_read_state = 'A'.
      ENDIF.

      TRY.
          READ REPORT lv_include INTO lt_source STATE lv_read_state.
        CATCH cx_root INTO DATA(lx_read_method).
          rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_READ","object_type":"CLAS",| &&
                    |"class_name":"{ lv_class }","method_name":"{ lv_method }","include":"{ lv_include }",| &&
                    |"version_requested":"{ lv_requested_version }","version_found":"{ lv_current_version }",| &&
                    |"message":"{ escape( val = lx_read_method->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
          RETURN.
      ENDTRY.

      IF sy-subrc <> 0.
        rv_json = |\{"status":"ERROR","stage":"CLASS_METHOD_READ","object_type":"CLAS",| &&
                  |"class_name":"{ lv_class }","method_name":"{ lv_method }","include":"{ lv_include }",| &&
                  |"version_requested":"{ lv_requested_version }","version_found":"{ lv_current_version }",| &&
                  |"message":"Method include source could not be read"\}|.
        RETURN.
      ENDIF.

      LOOP AT lt_source INTO DATA(lv_source_line).
        lv_index = sy-tabix.
        lv_line_count = lv_line_count + 1.
        lv_trimmed = lv_source_line.
        CONDENSE lv_trimmed.
        IF lv_trimmed IS NOT INITIAL.
          lv_non_empty_count = lv_non_empty_count + 1.
        ENDIF.
        IF lv_trimmed CP '*'.
          lv_comment_count = lv_comment_count + 1.
        ENDIF.

        IF lv_source_code IS INITIAL.
          lv_source_code = lv_source_line.
        ELSE.
          lv_source_code = lv_source_code && cl_abap_char_utilities=>newline && lv_source_line.
        ENDIF.

        IF lv_string_only = abap_false.
          IF lv_source_lines <> '['.
            lv_source_lines = lv_source_lines && ','.
          ENDIF.
          lv_source_lines = lv_source_lines &&
            |\{"line":{ lv_index },| &&
            |"source":"{ escape( val = lv_source_line format = cl_abap_format=>e_json_string ) }"\}|.
        ENDIF.
      ENDLOOP.

      IF lv_string_only = abap_false.
        lv_source_lines = lv_source_lines && ']'.
      ENDIF.

      lv_one_json = |\{"version":"{ lv_current_version }","state":"{ lv_read_state }",| &&
                    |"include":"{ lv_include }",| &&
                    |"line_count":{ lv_line_count },| &&
                    |"non_empty_line_count":{ lv_non_empty_count },| &&
                    |"comment_line_count":{ lv_comment_count },| &&
                    |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        lv_one_json = lv_one_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      lv_one_json = lv_one_json && |\}|.

      IF lv_requested_version = 'BOTH' OR lv_requested_version = 'ALL'.
        IF lv_versions_json <> '['.
          lv_versions_json = lv_versions_json && ','.
        ENDIF.
        lv_versions_json = lv_versions_json && lv_one_json.
      ENDIF.
    ENDLOOP.

    IF lv_requested_version = 'BOTH' OR lv_requested_version = 'ALL'.
      lv_versions_json = lv_versions_json && ']'.
      rv_json = |\{"status":"OK","object_type":"CLAS","class_name":"{ lv_class }",| &&
                |"method_name":"{ lv_method }","include":"{ lv_include }",| &&
                |"version_requested":"BOTH","versions":{ lv_versions_json }\}|.
    ELSE.
      rv_json = |\{"status":"OK","object_type":"CLAS","class_name":"{ lv_class }",| &&
                |"method_name":"{ lv_method }","include":"{ lv_include }",| &&
                |"version_requested":"{ lv_requested_version }",| &&
                |"version_found":"{ lv_current_version }","state":"{ lv_read_state }",| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CREATE_DATA_ELEMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA_ELEMENT                TYPE        TY_DATA_ELEMENT
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_data_element.
    DATA ls_dd04v TYPE dd04v.
    DATA lv_dtel_name TYPE ddobjname.
    DATA lv_as4local TYPE dd04l-as4local.
    DATA lv_cts_result TYPE string.
    DATA lv_description TYPE string.
    DATA lv_short_text TYPE string.
    DATA lv_medium_text TYPE string.
    DATA lv_long_text TYPE string.
    DATA lv_heading TYPE string.

    IF is_data_element-name IS INITIAL OR is_data_element-domain IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"DTEL","message":"name and domain are required"}'.
      RETURN.
    ENDIF.

    ls_dd04v-rollname = to_upper( is_data_element-name ).
    ls_dd04v-domname = to_upper( is_data_element-domain ).
    lv_dtel_name = ls_dd04v-rollname.
    lv_description = is_data_element-description.
    lv_short_text = is_data_element-short_text.
    lv_medium_text = is_data_element-medium_text.
    lv_long_text = is_data_element-long_text.
    lv_heading = is_data_element-heading.

    IF lv_short_text IS INITIAL.
      lv_short_text = is_data_element-scrtext_s.
    ENDIF.
    IF lv_medium_text IS INITIAL.
      lv_medium_text = is_data_element-scrtext_m.
    ENDIF.
    IF lv_long_text IS INITIAL.
      lv_long_text = is_data_element-scrtext_l.
    ENDIF.
    IF lv_heading IS INITIAL.
      lv_heading = is_data_element-reptext.
    ENDIF.

    IF lv_description IS INITIAL.
      lv_description = lv_long_text.
    ENDIF.
    IF lv_description IS INITIAL.
      lv_description = lv_medium_text.
    ENDIF.
    IF lv_description IS INITIAL.
      lv_description = lv_short_text.
    ENDIF.
    IF lv_description IS INITIAL.
      lv_description = ls_dd04v-rollname.
    ENDIF.

    IF lv_short_text IS INITIAL.
      lv_short_text = lv_description.
    ENDIF.
    IF lv_medium_text IS INITIAL.
      lv_medium_text = lv_short_text.
    ENDIF.
    IF lv_long_text IS INITIAL.
      lv_long_text = lv_medium_text.
    ENDIF.
    IF lv_heading IS INITIAL.
      lv_heading = lv_medium_text.
    ENDIF.

    ls_dd04v-ddlanguage = sy-langu.
    ls_dd04v-reptext = lv_heading.
    ls_dd04v-scrtext_s = lv_short_text.
    ls_dd04v-scrtext_m = lv_medium_text.
    ls_dd04v-scrtext_l = lv_long_text.
    ls_dd04v-headlen = strlen( ls_dd04v-reptext ).
    ls_dd04v-scrlen1 = strlen( ls_dd04v-scrtext_s ).
    ls_dd04v-scrlen2 = strlen( ls_dd04v-scrtext_m ).
    ls_dd04v-scrlen3 = strlen( ls_dd04v-scrtext_l ).
    ls_dd04v-ddtext = lv_description.

    TRY.
        CALL FUNCTION 'DDIF_DTEL_PUT'
          EXPORTING
            name              = lv_dtel_name
            dd04v_wa          = ls_dd04v
          EXCEPTIONS
            dtel_not_found    = 1
            name_inconsistent = 2
            dtel_inconsistent = 3
            put_failure       = 4
            put_refused       = 5
            OTHERS            = 6.
      CATCH cx_root INTO DATA(lx_dtel_put).
        rv_json = |\{"status":"ERROR","stage":"DTEL_PUT_EXCEPTION","object_type":"DTEL",| &&
                  |"object_name":"{ ls_dd04v-rollname }",| &&
                  |"message":"{ escape( val = lx_dtel_put->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DTEL_PUT'
        iv_object_type = 'DTEL'
        iv_object_name = ls_dd04v-rollname
        iv_message     = 'DDIF_DTEL_PUT failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check data element name, domain assignment, labels, and description' ).
      RETURN.
    ENDIF.

    TRY.
        CALL FUNCTION 'DDIF_DTEL_ACTIVATE'
          EXPORTING
            name   = lv_dtel_name
          EXCEPTIONS
            OTHERS = 1.
      CATCH cx_root INTO DATA(lx_dtel_activate).
        rv_json = |\{"status":"ERROR","stage":"DTEL_ACTIVATE_EXCEPTION","object_type":"DTEL",| &&
                  |"object_name":"{ ls_dd04v-rollname }",| &&
                  |"message":"{ escape( val = lx_dtel_activate->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DTEL_ACTIVATE'
        iv_object_type = 'DTEL'
        iv_object_name = ls_dd04v-rollname
        iv_message     = 'Data element created but activation failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check whether the referenced domain is active and labels are valid' ).
      RETURN.
    ENDIF.

    SELECT SINGLE as4local
      FROM dd04l
      INTO lv_as4local
      WHERE rollname = ls_dd04v-rollname
        AND as4local <> 'D'.

    IF sy-subrc = 0 AND lv_as4local = 'A'.
      lv_cts_result = register_cts_object(
        iv_object_type = 'DTEL'
        iv_object_name = ls_dd04v-rollname
        iv_package     = iv_package
        iv_transport   = iv_transport ).
      IF lv_cts_result CS '"status":"ERROR"'.
        rv_json = lv_cts_result.
        RETURN.
      ENDIF.
      rv_json = |\{"status":"OK","object_type":"DTEL","object_name":"{ ls_dd04v-rollname }","message":"Data element created and activated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DTEL_ACTIVE_VERIFY",| &&
                |"object_type":"DTEL","object_name":"{ ls_dd04v-rollname }",| &&
                |"message":"Data element activation did not produce active version",| &&
                |"as4local":"{ lv_as4local }",| &&
                |"suggestion":"Activation returned without active DD04L version; inspect SAP activation log"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CREATE_DDIC_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_ddic_from_json.
    DATA ls_request TYPE ty_ddic_request.
    DATA lv_results TYPE string VALUE '['.
    DATA lv_result TYPE string.
    DATA lv_validation TYPE string.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_ddic_json).
        rv_json = |\{"status":"ERROR","stage":"DDIC_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_ddic_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_package = to_upper( ls_request-package ).
    lv_transport = to_upper( ls_request-transport ).

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    IF lv_package <> '$TMP' AND lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_VALIDATE",| &&
                |"message":"transport is required when package is not $TMP",| &&
                |"suggestion":"Pass a modifiable Workbench request in transport or use package $TMP"\}|.
      RETURN.
    ENDIF.

    TRY.
        lv_validation = validate_names( ls_request ).
      CATCH cx_root INTO DATA(lx_ddic_validate).
        rv_json = |\{"status":"ERROR","stage":"DDIC_VALIDATE",| &&
                  |"message":"{ escape( val = lx_ddic_validate->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.
    IF lv_validation CS '"status":"ERROR"'.
      rv_json = lv_validation.
      RETURN.
    ENDIF.

    LOOP AT ls_request-domains INTO DATA(ls_domain).
      lv_result = create_domain(
        is_domain    = ls_domain
        iv_package   = lv_package
        iv_transport = lv_transport ).
      append_result(
        EXPORTING iv_result = lv_result
        CHANGING cv_json = lv_results ).
      IF lv_result CS '"status":"ERROR"'.
        lv_results = lv_results && ']'.
        rv_json = |\{"status":"ERROR","stage":"DOMA_CREATE","results":{ lv_results },| &&
                  |"message":"DDIC creation stopped after domain error",| &&
                  |"suggestion":"Fix the domain definition before creating data elements or tables"\}|.
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT ls_request-data_elements INTO DATA(ls_data_element).
      lv_result = create_data_element(
        is_data_element = ls_data_element
        iv_package      = lv_package
        iv_transport    = lv_transport ).
      append_result(
        EXPORTING iv_result = lv_result
        CHANGING cv_json = lv_results ).
      IF lv_result CS '"status":"ERROR"'.
        lv_results = lv_results && ']'.
        rv_json = |\{"status":"ERROR","stage":"DTEL_CREATE","results":{ lv_results },| &&
                  |"message":"DDIC creation stopped after data element error",| &&
                  |"suggestion":"Fix the data element definition or its referenced domain before creating tables"\}|.
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT ls_request-tables INTO DATA(ls_table).
      lv_result = create_table(
        is_table     = ls_table
        iv_package   = lv_package
        iv_transport = lv_transport ).
      append_result(
        EXPORTING iv_result = lv_result
        CHANGING cv_json = lv_results ).
      IF lv_result CS '"status":"ERROR"'.
        lv_results = lv_results && ']'.
        rv_json = |\{"status":"ERROR","stage":"TABL_CREATE","results":{ lv_results },| &&
                  |"message":"DDIC creation stopped after table error",| &&
                  |"suggestion":"Fix the table fields, keys, delivery class, or referenced data elements"\}|.
        RETURN.
      ENDIF.
    ENDLOOP.

    lv_results = lv_results && ']'.
    rv_json = |\{"status":"OK","results":{ lv_results }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CREATE_DOMAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DOMAIN                      TYPE        TY_DOMAIN
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_domain.
    DATA ls_dd01v TYPE dd01v.
    DATA lt_dd07v TYPE STANDARD TABLE OF dd07v WITH EMPTY KEY.
    DATA lv_as4local TYPE dd01l-as4local.
    DATA lv_cts_result TYPE string.

    IF is_domain-name IS INITIAL OR is_domain-data_type IS INITIAL OR is_domain-length IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"DOMA","message":"name, data_type and length are required"}'.
      RETURN.
    ENDIF.

    ls_dd01v-domname = to_upper( is_domain-name ).
    ls_dd01v-ddlanguage = sy-langu.
    ls_dd01v-datatype = to_upper( is_domain-data_type ).
    ls_dd01v-leng = is_domain-length.
    ls_dd01v-decimals = is_domain-decimals.
    ls_dd01v-ddtext = is_domain-description.

    LOOP AT is_domain-values INTO DATA(ls_value).
      APPEND VALUE dd07v(
        domname    = ls_dd01v-domname
        ddlanguage = sy-langu
        valpos     = sy-tabix
        domvalue_l = ls_value-low
        domvalue_h = ls_value-high
        ddtext     = ls_value-description ) TO lt_dd07v.
    ENDLOOP.

    CALL FUNCTION 'DDIF_DOMA_PUT'
      EXPORTING
        name              = ls_dd01v-domname
        dd01v_wa          = ls_dd01v
      TABLES
        dd07v_tab         = lt_dd07v
      EXCEPTIONS
        doma_not_found    = 1
        name_inconsistent = 2
        doma_inconsistent = 3
        put_failure       = 4
        put_refused       = 5
        OTHERS            = 6.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_PUT'
        iv_object_type = 'DOMA'
        iv_object_name = ls_dd01v-domname
        iv_message     = 'DDIF_DOMA_PUT failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check domain name, data type, length, decimals, and fixed values' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'DDIF_DOMA_ACTIVATE'
      EXPORTING
        name   = ls_dd01v-domname
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_ACTIVATE'
        iv_object_type = 'DOMA'
        iv_object_name = ls_dd01v-domname
        iv_message     = 'Domain created but activation failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check activation log in SAP and validate the domain technical attributes' ).
      RETURN.
    ENDIF.

    SELECT SINGLE as4local
      FROM dd01l
      INTO lv_as4local
      WHERE domname = ls_dd01v-domname
        AND as4local <> 'D'.

    IF sy-subrc = 0 AND lv_as4local = 'A'.
      lv_cts_result = register_cts_object(
        iv_object_type = 'DOMA'
        iv_object_name = ls_dd01v-domname
        iv_package     = iv_package
        iv_transport   = iv_transport ).
      IF lv_cts_result CS '"status":"ERROR"'.
        rv_json = lv_cts_result.
        RETURN.
      ENDIF.
      rv_json = |\{"status":"OK","object_type":"DOMA","object_name":"{ ls_dd01v-domname }","message":"Domain created and activated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DOMA_ACTIVE_VERIFY",| &&
                |"object_type":"DOMA","object_name":"{ ls_dd01v-domname }",| &&
                |"message":"Domain activation did not produce active version",| &&
                |"as4local":"{ lv_as4local }",| &&
                |"suggestion":"Activation returned without active DD01L version; inspect SAP activation log"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CREATE_FUNCTION_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_function_from_json.
    DATA ls_request TYPE ty_function_request.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.
    DATA lv_short_text TYPE tftit-stext.
    DATA lv_include TYPE rs38l-include.
    DATA lv_existing_group TYPE rs38l-area.
    DATA lv_namespace TYPE rs38l-namespace.
    DATA lv_str_area TYPE rs38l-str_area.
    DATA lt_source TYPE STANDARD TABLE OF rssource WITH EMPTY KEY.
    DATA ls_source TYPE rssource.
    DATA lt_import TYPE STANDARD TABLE OF rsimp WITH EMPTY KEY.
    DATA lt_export TYPE STANDARD TABLE OF rsexp WITH EMPTY KEY.
    DATA lt_changing TYPE STANDARD TABLE OF rscha WITH EMPTY KEY.
    DATA lt_tables TYPE STANDARD TABLE OF rstbl WITH EMPTY KEY.
    DATA ls_import TYPE rsimp.
    DATA ls_export TYPE rsexp.
    DATA ls_changing TYPE rscha.
    DATA ls_table TYPE rstbl.
    DATA lv_line TYPE string.
    DATA lt_source_lines TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_pool_subrc TYPE i.
    DATA lv_insert_subrc TYPE i.
    DATA lv_pool_existed TYPE string.
    DATA lv_tadir_result TYPE string.
    DATA lv_cts_result TYPE string.
    DATA lv_param_type TYPE string.
    DATA lv_param_table TYPE ddobjname.
    DATA lv_param_field TYPE fieldname.
    DATA lv_type_prefix TYPE string.
    DATA lv_type_suffix TYPE string.
    DATA lt_fieldinfo TYPE STANDARD TABLE OF dfies WITH EMPTY KEY.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_function_json).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_function_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_function_group = to_upper( ls_request-function_group ).
    lv_function_name = to_upper( ls_request-function_name ).
    lv_package = to_upper( ls_request-package ).
    lv_transport = to_upper( ls_request-transport ).
    lv_short_text = ls_request-short_text.

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    IF lv_short_text IS INITIAL.
      lv_short_text = lv_function_name.
    ENDIF.

    IF lv_function_group IS INITIAL OR lv_function_name IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_VALIDATE","object_type":"FUNC",| &&
                |"message":"function_group, function_name and source_code are required",| &&
                |"suggestion":"Pass a Z function group name, a Z function module name, and the function body source code"\}|.
      RETURN.
    ENDIF.

    IF is_z_object_name( lv_function_group ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_NAME_VALIDATE","object_type":"FUGR",| &&
                |"object_name":"{ lv_function_group }",| &&
                |"message":"Only Z* object names are allowed for API-created objects"\}|.
      RETURN.
    ENDIF.

    IF is_z_object_name( lv_function_name ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_NAME_VALIDATE","object_type":"FUNC",| &&
                |"object_name":"{ lv_function_name }",| &&
                |"message":"Only Z* object names are allowed for API-created objects"\}|.
      RETURN.
    ENDIF.

    IF lv_package <> '$TMP' AND lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_VALIDATE","object_type":"FUNC",| &&
                |"message":"transport is required when package is not $TMP",| &&
                |"suggestion":"Pass a modifiable Workbench request in transport or use package $TMP"\}|.
      RETURN.
    ENDIF.

    LOOP AT ls_request-importing INTO DATA(ls_import_check).
      lv_param_type = to_upper( ls_import_check-type ).
      SPLIT lv_param_type AT '-' INTO lv_type_prefix lv_type_suffix.
      IF lv_type_prefix IS INITIAL OR lv_type_suffix IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_PARAMETER_VALIDATE","object_type":"FUNC",| &&
                  |"object_name":"{ lv_function_name }",| &&
                  |"parameter":"{ to_upper( ls_import_check-name ) }",| &&
                  |"type":"{ lv_param_type }",| &&
                  |"message":"Function IMPORTING parameter type must be an existing DDIC table field such as MARA-MATNR"\}|.
        RETURN.
      ENDIF.
      lv_param_table = lv_type_prefix.
      lv_param_field = lv_type_suffix.
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = lv_param_table
          fieldname      = lv_param_field
          langu          = sy-langu
        TABLES
          dfies_tab      = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0 OR lt_fieldinfo IS INITIAL.
        rv_json = build_fm_error_json(
          iv_stage       = 'FUNCTION_PARAMETER_VALIDATE'
          iv_object_type = 'FUNC'
          iv_object_name = lv_function_name
          iv_message     = 'DDIC table field for IMPORTING parameter was not found'
          iv_subrc       = sy-subrc
          iv_suggestion  = 'Use an existing DDIC table field reference such as MARA-MATNR' ).
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT ls_request-exporting INTO DATA(ls_export_check).
      lv_param_type = to_upper( ls_export_check-type ).
      SPLIT lv_param_type AT '-' INTO lv_type_prefix lv_type_suffix.
      IF lv_type_prefix IS INITIAL OR lv_type_suffix IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_PARAMETER_VALIDATE","object_type":"FUNC",| &&
                  |"object_name":"{ lv_function_name }",| &&
                  |"parameter":"{ to_upper( ls_export_check-name ) }",| &&
                  |"type":"{ lv_param_type }",| &&
                  |"message":"Function EXPORTING parameter type must be an existing DDIC table field such as MARA-MATNR"\}|.
        RETURN.
      ENDIF.
      lv_param_table = lv_type_prefix.
      lv_param_field = lv_type_suffix.
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = lv_param_table
          fieldname      = lv_param_field
          langu          = sy-langu
        TABLES
          dfies_tab      = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0 OR lt_fieldinfo IS INITIAL.
        rv_json = build_fm_error_json(
          iv_stage       = 'FUNCTION_PARAMETER_VALIDATE'
          iv_object_type = 'FUNC'
          iv_object_name = lv_function_name
          iv_message     = 'DDIC table field for EXPORTING parameter was not found'
          iv_subrc       = sy-subrc
          iv_suggestion  = 'Use an existing DDIC table field reference such as MARA-MATNR' ).
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT ls_request-changing INTO DATA(ls_changing_check).
      lv_param_type = to_upper( ls_changing_check-type ).
      SPLIT lv_param_type AT '-' INTO lv_type_prefix lv_type_suffix.
      IF lv_type_prefix IS INITIAL OR lv_type_suffix IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_PARAMETER_VALIDATE","object_type":"FUNC",| &&
                  |"object_name":"{ lv_function_name }",| &&
                  |"parameter":"{ to_upper( ls_changing_check-name ) }",| &&
                  |"type":"{ lv_param_type }",| &&
                  |"message":"Function CHANGING parameter type must be an existing DDIC table field such as MARA-MATNR"\}|.
        RETURN.
      ENDIF.
      lv_param_table = lv_type_prefix.
      lv_param_field = lv_type_suffix.
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = lv_param_table
          fieldname      = lv_param_field
          langu          = sy-langu
        TABLES
          dfies_tab      = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0 OR lt_fieldinfo IS INITIAL.
        rv_json = build_fm_error_json(
          iv_stage       = 'FUNCTION_PARAMETER_VALIDATE'
          iv_object_type = 'FUNC'
          iv_object_name = lv_function_name
          iv_message     = 'DDIC table field for CHANGING parameter was not found'
          iv_subrc       = sy-subrc
          iv_suggestion  = 'Use an existing DDIC table field reference such as MARA-MATNR' ).
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT ls_request-tables INTO DATA(ls_table_check).
      lv_param_table = to_upper( ls_table_check-type ).
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = lv_param_table
          langu          = sy-langu
        TABLES
          dfies_tab      = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0 OR lt_fieldinfo IS INITIAL.
        rv_json = build_fm_error_json(
          iv_stage       = 'FUNCTION_PARAMETER_VALIDATE'
          iv_object_type = 'FUNC'
          iv_object_name = lv_function_name
          iv_message     = 'DDIC table or structure for TABLES parameter was not found'
          iv_subrc       = sy-subrc
          iv_suggestion  = 'Use an existing DDIC table or structure such as MARA' ).
        RETURN.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = lv_function_name
      IMPORTING
        group              = lv_existing_group
        include            = lv_include
        namespace          = lv_namespace
        str_area           = lv_str_area
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.

    IF sy-subrc = 0.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_VALIDATE","object_type":"FUNC",| &&
                |"object_name":"{ lv_function_name }",| &&
                |"message":"Function module already exists",| &&
                |"function_group":"{ lv_existing_group }",| &&
                |"include":"{ lv_include }",| &&
                |"suggestion":"Use another name or delete the existing function module manually; this API does not auto-rename"\}|.
      RETURN.
    ELSEIF sy-subrc <> 1.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_EXISTS'
        iv_object_type = 'FUNC'
        iv_object_name = lv_function_name
        iv_message     = 'FUNCTION_EXISTS failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check function module name and authorization' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'RS_FUNCTION_POOL_INSERT'
      EXPORTING
        function_pool          = lv_function_group
        short_text             = lv_short_text
        responsible            = sy-uname
        devclass               = lv_package
        corrnum                = lv_transport
        suppress_corr_check    = 'X'
        suppress_language_check = 'X'
        authority_check        = 'X'
        unicode_checks         = 'X'
      EXCEPTIONS
        name_already_exists    = 1
        name_not_correct       = 2
        function_already_exists = 3
        invalid_function_pool  = 4
        invalid_name           = 5
        too_many_functions     = 6
        no_modify_permission   = 7
        no_show_permission     = 8
        enqueue_system_failure = 9
        canceled_in_corr       = 10
        undefined_error        = 11
        OTHERS                 = 12.

    lv_pool_subrc = sy-subrc.
    IF lv_pool_subrc <> 0 AND lv_pool_subrc <> 1.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_POOL_CREATE'
        iv_object_type = 'FUGR'
        iv_object_name = lv_function_group
        iv_message     = 'RS_FUNCTION_POOL_INSERT failed'
        iv_subrc       = lv_pool_subrc
        iv_suggestion  = 'Check function group name, package, transport request, and authorization' ).
      RETURN.
    ENDIF.

    lv_tadir_result = register_tadir_entry(
      iv_pgmid       = 'R3TR'
      iv_object_type = 'FUGR'
      iv_object_name = lv_function_group
      iv_package     = lv_package ).
    IF lv_tadir_result CS '"status":"ERROR"'.
      rv_json = lv_tadir_result.
      RETURN.
    ENDIF.

    IF lv_package <> '$TMP'.
      lv_cts_result = append_cts_object(
        iv_object_type = 'FUGR'
        iv_object_name = lv_function_group
        iv_transport   = lv_transport ).
      IF lv_cts_result CS '"status":"ERROR"'.
        rv_json = lv_cts_result.
        RETURN.
      ENDIF.
    ENDIF.

    LOOP AT ls_request-importing INTO DATA(ls_import_param).
      CLEAR ls_import.
      ls_import-parameter = to_upper( ls_import_param-name ).
      ls_import-dbfield = to_upper( ls_import_param-type ).
      ls_import-optional = ls_import_param-optional.
      ls_import-default = ls_import_param-default.
      APPEND ls_import TO lt_import.
    ENDLOOP.

    LOOP AT ls_request-exporting INTO DATA(ls_export_param).
      CLEAR ls_export.
      ls_export-parameter = to_upper( ls_export_param-name ).
      ls_export-dbfield = to_upper( ls_export_param-type ).
      APPEND ls_export TO lt_export.
    ENDLOOP.

    LOOP AT ls_request-changing INTO DATA(ls_changing_param).
      CLEAR ls_changing.
      ls_changing-parameter = to_upper( ls_changing_param-name ).
      ls_changing-dbfield = to_upper( ls_changing_param-type ).
      ls_changing-optional = ls_changing_param-optional.
      ls_changing-default = ls_changing_param-default.
      APPEND ls_changing TO lt_changing.
    ENDLOOP.

    LOOP AT ls_request-tables INTO DATA(ls_table_param).
      CLEAR ls_table.
      ls_table-parameter = to_upper( ls_table_param-name ).
      ls_table-types = 'X'.
      ls_table-typ = to_upper( ls_table_param-type ).
      ls_table-optional = ls_table_param-optional.
      APPEND ls_table TO lt_tables.
    ENDLOOP.

    SPLIT ls_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source_lines.
    LOOP AT lt_source_lines INTO lv_line.
      CLEAR ls_source.
      ls_source-line = lv_line.
      APPEND ls_source TO lt_source.
    ENDLOOP.

    CALL FUNCTION 'RS_FUNCTIONMODULE_INSERT'
      EXPORTING
        funcname                = lv_function_name
        function_pool           = lv_function_group
        short_text              = lv_short_text
        suppress_corr_check     = 'X'
        suppress_language_check = 'X'
        authority_check         = 'X'
        save_active             = 'X'
        corrnum                 = lv_transport
      TABLES
        import_parameter        = lt_import
        export_parameter        = lt_export
        changing_parameter      = lt_changing
        tables_parameter        = lt_tables
        source                  = lt_source
      EXCEPTIONS
        function_already_exists = 1
        invalid_function_pool   = 2
        invalid_name            = 3
        too_many_functions      = 4
        no_modify_permission    = 5
        no_show_permission      = 6
        enqueue_system_failure  = 7
        canceled_in_corr        = 8
        OTHERS                  = 9.

    lv_insert_subrc = sy-subrc.
    IF lv_insert_subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_CREATE'
        iv_object_type = 'FUNC'
        iv_object_name = lv_function_name
        iv_message     = 'RS_FUNCTIONMODULE_INSERT failed'
        iv_subrc       = lv_insert_subrc
        iv_suggestion  = 'Check function source body, parameter definitions, function group, and package/request settings' ).
      RETURN.
    ENDIF.

    IF lv_pool_subrc = 1.
      lv_pool_existed = 'true'.
    ELSE.
      lv_pool_existed = 'false'.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"FUNC","object_name":"{ lv_function_name }",| &&
              |"function_group":"{ lv_function_group }",| &&
              |"package":"{ lv_package }",| &&
              |"transport":"{ lv_transport }",| &&
              |"pool_existed":{ lv_pool_existed },| &&
              |"message":"Function module created"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->CREATE_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_TABLE                       TYPE        TY_TABLE
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_table.
    DATA ls_dd02v TYPE dd02v.
    DATA ls_dd09l TYPE dd09l.
    DATA lt_dd03p TYPE STANDARD TABLE OF dd03p WITH EMPTY KEY.
    DATA lt_dd05m TYPE STANDARD TABLE OF dd05m WITH EMPTY KEY.
    DATA lt_dd08v TYPE STANDARD TABLE OF dd08v WITH EMPTY KEY.
    DATA lt_dd35v TYPE STANDARD TABLE OF dd35v WITH EMPTY KEY.
    DATA lt_dd36m TYPE STANDARD TABLE OF dd36m WITH EMPTY KEY.
    DATA lv_as4local TYPE dd02l-as4local.
    DATA lv_cts_result TYPE string.
    FIELD-SYMBOLS <lv_storage_type> TYPE any.

    IF is_table-name IS INITIAL OR is_table-fields IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"TABL","message":"name and fields are required"}'.
      RETURN.
    ENDIF.

    ls_dd02v-tabname = to_upper( is_table-name ).
    ls_dd02v-ddlanguage = sy-langu.
    ls_dd02v-tabclass = 'TRANSP'.
    IF is_table-delivery_class IS INITIAL.
      ls_dd02v-contflag = 'A'.
    ELSE.
      ls_dd02v-contflag = to_upper( is_table-delivery_class ).
    ENDIF.

    IF is_table-data_maintenance IS INITIAL.
      ls_dd02v-mainflag = 'X'.
    ELSE.
      ls_dd02v-mainflag = to_upper( is_table-data_maintenance ).
    ENDIF.

    IF is_table-enhancement_category IS INITIAL.
      ls_dd02v-exclass = '3'.
    ELSE.
      ls_dd02v-exclass = is_table-enhancement_category.
    ENDIF.
    ls_dd02v-ddtext = is_table-description.

    ls_dd09l-tabname = ls_dd02v-tabname.
    IF is_table-data_class IS INITIAL.
      ls_dd09l-tabart = 'APPL0'.
    ELSE.
      ls_dd09l-tabart = to_upper( is_table-data_class ).
    ENDIF.

    IF is_table-size_category IS INITIAL.
      ls_dd09l-tabkat = '0'.
    ELSE.
      ls_dd09l-tabkat = is_table-size_category.
    ENDIF.

    ASSIGN COMPONENT 'ROWORCOLST' OF STRUCTURE ls_dd09l TO <lv_storage_type>.
    IF sy-subrc = 0.
      IF is_table-storage_type IS INITIAL.
        <lv_storage_type> = 'C'.
      ELSE.
        <lv_storage_type> = to_upper( is_table-storage_type ).
      ENDIF.
    ENDIF.

    LOOP AT is_table-fields INTO DATA(ls_field).
      DATA(lv_reftable) = ls_field-reference_table.
      DATA(lv_reffield) = ls_field-reference_field.
      DATA(lv_precfield) = ls_field-precfield.

      IF lv_reftable IS INITIAL.
        lv_reftable = ls_field-reftable.
      ENDIF.
      IF lv_reffield IS INITIAL.
        lv_reffield = ls_field-reffield.
      ENDIF.

      APPEND VALUE dd03p(
        tabname    = ls_dd02v-tabname
        fieldname  = to_upper( ls_field-name )
        position   = COND #( WHEN ls_field-position IS INITIAL THEN sy-tabix ELSE ls_field-position )
        keyflag    = COND #( WHEN ls_field-key_flag = abap_true THEN 'X' ELSE space )
        notnull    = COND #( WHEN ls_field-not_null = abap_true THEN 'X' ELSE space )
        rollname   = to_upper( ls_field-data_element )
        reftable   = to_upper( lv_reftable )
        reffield   = to_upper( lv_reffield )
        precfield  = to_upper( lv_precfield )
        ddlanguage = sy-langu ) TO lt_dd03p.
    ENDLOOP.

    CALL FUNCTION 'DDIF_TABL_PUT'
      EXPORTING
        name              = ls_dd02v-tabname
        dd02v_wa          = ls_dd02v
        dd09l_wa          = ls_dd09l
      TABLES
        dd03p_tab         = lt_dd03p
        dd05m_tab         = lt_dd05m
        dd08v_tab         = lt_dd08v
        dd35v_tab         = lt_dd35v
        dd36m_tab         = lt_dd36m
      EXCEPTIONS
        tabl_not_found    = 1
        name_inconsistent = 2
        tabl_inconsistent = 3
        put_failure       = 4
        put_refused       = 5
        OTHERS            = 6.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'TABL_PUT'
        iv_object_type = 'TABL'
        iv_object_name = ls_dd02v-tabname
        iv_message     = 'DDIF_TABL_PUT failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check table fields, key sequence, referenced data elements, and table attributes' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'DDIF_TABL_ACTIVATE'
      EXPORTING
        name   = ls_dd02v-tabname
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'TABL_ACTIVATE'
        iv_object_type = 'TABL'
        iv_object_name = ls_dd02v-tabname
        iv_message     = 'Table created but activation failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check whether all field data elements are active and table technical settings are complete' ).
      RETURN.
    ENDIF.

    SELECT SINGLE as4local
      FROM dd02l
      INTO lv_as4local
      WHERE tabname = ls_dd02v-tabname
        AND as4local <> 'D'.

    IF sy-subrc = 0 AND lv_as4local = 'A'.
      lv_cts_result = register_cts_object(
        iv_object_type = 'TABL'
        iv_object_name = ls_dd02v-tabname
        iv_package     = iv_package
        iv_transport   = iv_transport ).
      IF lv_cts_result CS '"status":"ERROR"'.
        rv_json = lv_cts_result.
        RETURN.
      ENDIF.
      rv_json = |\{"status":"OK","object_type":"TABL","object_name":"{ ls_dd02v-tabname }","message":"Table created and activated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"TABL_ACTIVE_VERIFY",| &&
                |"object_type":"TABL","object_name":"{ ls_dd02v-tabname }",| &&
                |"message":"Table activation did not produce active version",| &&
                |"as4local":"{ lv_as4local }",| &&
                |"suggestion":"Activation returned without active DD02L version; inspect SAP activation log"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DATA_ELEMENT_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_EXISTS                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD data_element_exists.
    DATA lv_rollname TYPE dd04l-rollname.

    SELECT SINGLE rollname
      FROM dd04l
      INTO lv_rollname
      WHERE rollname = iv_name
        AND as4local <> 'D'.

    rv_exists = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DDIC_FIELDS_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ddic_fields_from_json.
    DATA ls_request TYPE ty_ddic_fields_request.
    DATA lv_type_name TYPE dd03l-tabname.
    DATA lt_fields TYPE STANDARD TABLE OF dd03l WITH EMPTY KEY.
    DATA lv_fields TYPE string VALUE '['.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-type_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"type_name is required"}'.
      RETURN.
    ENDIF.

    lv_type_name = to_upper( ls_request-type_name ).

    SELECT *
      FROM dd03l
      INTO TABLE lt_fields
      WHERE tabname = lv_type_name
        AND as4local = 'A'
        AND fieldname <> '.INCLUDE'
      ORDER BY position.

    IF sy-subrc <> 0 OR lt_fields IS INITIAL.
      rv_json = |\{"status":"ERROR","type_name":"{ lv_type_name }","message":"No active DDIC fields found"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_fields INTO DATA(ls_field).
      IF lv_fields <> '['.
        lv_fields = lv_fields && ','.
      ENDIF.

      lv_fields = lv_fields &&
        |\{"fieldname":"{ ls_field-fieldname }",| &&
        |"position":{ ls_field-position },| &&
        |"rollname":"{ ls_field-rollname }",| &&
        |"datatype":"{ ls_field-datatype }",| &&
        |"leng":"{ ls_field-leng }",| &&
        |"decimals":"{ ls_field-decimals }"\}|.
    ENDLOOP.

    lv_fields = lv_fields && ']'.
    rv_json = |\{"status":"OK","type_name":"{ lv_type_name }","fields":{ lv_fields }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DDIC_TYPE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ddic_type_from_json.
    DATA ls_request TYPE ty_ddic_type_request.
    DATA lv_type_name TYPE string.
    DATA lr_data TYPE REF TO data.
    DATA lr_descr TYPE REF TO cl_abap_typedescr.
    DATA lr_table TYPE REF TO cl_abap_tabledescr.
    DATA lr_struct TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA lv_fields TYPE string VALUE '['.
    FIELD-SYMBOLS <lv_any> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-type_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"type_name is required"}'.
      RETURN.
    ENDIF.

    lv_type_name = to_upper( ls_request-type_name ).

    TRY.
        CREATE DATA lr_data TYPE (lv_type_name).
        ASSIGN lr_data->* TO <lv_any>.
        lr_descr = cl_abap_typedescr=>describe_by_data( <lv_any> ).
      CATCH cx_root INTO DATA(lx_type).
        rv_json = |\{"status":"ERROR","type_name":"{ lv_type_name }",| &&
                  |"message":"{ escape( val = lx_type->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF lr_descr->kind = cl_abap_typedescr=>kind_table.
      lr_table ?= lr_descr.
      lr_descr = lr_table->get_table_line_type( ).
    ENDIF.

    IF lr_descr->kind = cl_abap_typedescr=>kind_struct.
      lr_struct ?= lr_descr.
      lt_components = lr_struct->get_components( ).
      LOOP AT lt_components INTO DATA(ls_component).
        IF lv_fields <> '['.
          lv_fields = lv_fields && ','.
        ENDIF.
        lv_fields = lv_fields &&
          |\{"name":"{ ls_component-name }",| &&
          |"type_kind":"{ ls_component-type->type_kind }",| &&
          |"absolute_name":"{ escape( val = ls_component-type->absolute_name format = cl_abap_format=>e_json_string ) }"\}|.
      ENDLOOP.
    ENDIF.

    lv_fields = lv_fields && ']'.
    rv_json = |\{"status":"OK","type_name":"{ lv_type_name }","kind":"{ lr_descr->kind }","fields":{ lv_fields }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DOMAIN_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_EXISTS                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD domain_exists.
    DATA lv_domname TYPE dd01l-domname.

    SELECT SINGLE domname
      FROM dd01l
      INTO lv_domname
      WHERE domname = iv_name
        AND as4local <> 'D'.

    rv_exists = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DOMAIN_UPDATE_VALUES_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD domain_update_values_from_json.
    TYPES: BEGIN OF ty_domain_value_key,
             low  TYPE string,
             high TYPE string,
           END OF ty_domain_value_key.
    TYPES tt_domain_value_keys TYPE STANDARD TABLE OF ty_domain_value_key WITH EMPTY KEY.

    DATA ls_request TYPE ty_doma_values_upd_req.
    DATA lv_domain_name TYPE dd01v-domname.
    DATA lv_language TYPE dd01v-ddlanguage.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.
    DATA lv_mode TYPE string.
    DATA ls_dd01v TYPE dd01v.
    DATA lt_current_values TYPE STANDARD TABLE OF dd07v WITH EMPTY KEY.
    DATA lt_new_values TYPE STANDARD TABLE OF dd07v WITH EMPTY KEY.
    DATA lt_readback_values TYPE STANDARD TABLE OF dd07v WITH EMPTY KEY.
    DATA lt_request_keys TYPE tt_domain_value_keys.
    DATA ls_request_key TYPE ty_domain_value_key.
    DATA lv_valpos TYPE dd07v-valpos.
    DATA lv_values_json TYPE string VALUE '['.
    DATA lv_cts_json TYPE string VALUE 'null'.
    DATA lv_active TYPE dd01l-as4local.
    DATA lv_existing TYPE dd01l-domname.
    DATA lv_found TYPE abap_bool.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_domain_update_json).
        rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_domain_update_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_domain_name = to_upper( ls_request-domain_name ).
    lv_language = to_upper( ls_request-language ).
    lv_package = to_upper( ls_request-package ).
    lv_transport = to_upper( ls_request-transport ).
    lv_mode = to_lower( ls_request-mode ).

    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.
    IF lv_mode IS INITIAL.
      lv_mode = 'replace'.
    ENDIF.

    IF lv_domain_name IS INITIAL OR ls_request-values IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE","message":"domain_name and values are required"}'.
      RETURN.
    ENDIF.

    IF is_z_object_name( lv_domain_name ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE",| &&
                |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"Only existing Z* domains can be changed through this API"\}|.
      RETURN.
    ENDIF.

    IF lv_mode <> 'replace' AND lv_mode <> 'merge'.
      rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE",| &&
                |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                |"mode":"{ escape( val = lv_mode format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"mode must be replace or merge"\}|.
      RETURN.
    ENDIF.

    IF lv_package <> '$TMP' AND lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_VALIDATE",| &&
                |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"transport is required when package is not $TMP",| &&
                |"suggestion":"Pass a modifiable Workbench request in transport or use package $TMP"\}|.
      RETURN.
    ENDIF.

    SELECT SINGLE domname as4local
      FROM dd01l
      INTO (lv_existing, lv_active)
      WHERE domname = lv_domain_name
        AND as4local = 'A'.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE",| &&
                |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"domain must already exist as an active version; this endpoint does not create domains"\}|.
      RETURN.
    ENDIF.

    LOOP AT ls_request-values INTO DATA(ls_in_value).
      IF ls_in_value-low IS INITIAL OR ls_in_value-description IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE",| &&
                  |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                  |"low":"{ escape( val = ls_in_value-low format = cl_abap_format=>e_json_string ) }",| &&
                  |"high":"{ escape( val = ls_in_value-high format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"Each fixed value must provide low and non-empty description; high may be empty"\}|.
        RETURN.
      ENDIF.

      CLEAR ls_request_key.
      ls_request_key-low = ls_in_value-low.
      ls_request_key-high = ls_in_value-high.
      READ TABLE lt_request_keys WITH KEY low = ls_request_key-low high = ls_request_key-high TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        rv_json = |\{"status":"ERROR","stage":"DOMA_VALUES_VALIDATE",| &&
                  |"object_type":"DOMA","object_name":"{ escape( val = lv_domain_name format = cl_abap_format=>e_json_string ) }",| &&
                  |"low":"{ escape( val = ls_in_value-low format = cl_abap_format=>e_json_string ) }",| &&
                  |"high":"{ escape( val = ls_in_value-high format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"Duplicate fixed value low/high in request"\}|.
        RETURN.
      ENDIF.
      APPEND ls_request_key TO lt_request_keys.
    ENDLOOP.

    CALL FUNCTION 'DDIF_DOMA_GET'
      EXPORTING
        name          = lv_domain_name
        state         = 'A'
        langu         = lv_language
      IMPORTING
        dd01v_wa      = ls_dd01v
      TABLES
        dd07v_tab     = lt_current_values
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0 OR ls_dd01v-domname IS INITIAL.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_GET'
        iv_object_type = 'DOMA'
        iv_object_name = lv_domain_name
        iv_message     = 'DDIF_DOMA_GET failed for active domain'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check the domain name, active version, language, and DDIC authorization' ).
      RETURN.
    ENDIF.

    IF lv_mode = 'merge'.
      lt_new_values = lt_current_values.
      LOOP AT ls_request-values INTO ls_in_value.
        lv_found = abap_false.
        LOOP AT lt_new_values INTO DATA(ls_merge_value)
             WHERE domvalue_l = ls_in_value-low
               AND domvalue_h = ls_in_value-high.
          ls_merge_value-ddlanguage = lv_language.
          ls_merge_value-ddtext = ls_in_value-description.
          MODIFY lt_new_values FROM ls_merge_value INDEX sy-tabix.
          lv_found = abap_true.
          EXIT.
        ENDLOOP.
        IF lv_found = abap_false.
          APPEND VALUE dd07v(
            domname    = lv_domain_name
            ddlanguage = lv_language
            domvalue_l = ls_in_value-low
            domvalue_h = ls_in_value-high
            ddtext     = ls_in_value-description ) TO lt_new_values.
        ENDIF.
      ENDLOOP.
    ELSE.
      CLEAR lt_new_values.
      LOOP AT ls_request-values INTO ls_in_value.
        APPEND VALUE dd07v(
          domname    = lv_domain_name
          ddlanguage = lv_language
          domvalue_l = ls_in_value-low
          domvalue_h = ls_in_value-high
          ddtext     = ls_in_value-description ) TO lt_new_values.
      ENDLOOP.
    ENDIF.

    lv_valpos = 0.
    LOOP AT lt_new_values INTO DATA(ls_new_value).
      lv_valpos = lv_valpos + 1.
      ls_new_value-domname = lv_domain_name.
      ls_new_value-ddlanguage = lv_language.
      ls_new_value-valpos = lv_valpos.
      MODIFY lt_new_values FROM ls_new_value INDEX sy-tabix.
    ENDLOOP.

    IF lv_transport IS NOT INITIAL.
      lv_cts_json = append_cts_object(
        iv_object_type = 'DOMA'
        iv_object_name = lv_domain_name
        iv_transport   = lv_transport ).
      IF lv_cts_json CS '"status":"ERROR"'.
        rv_json = lv_cts_json.
        RETURN.
      ENDIF.
    ENDIF.

    ls_dd01v-domname = lv_domain_name.
    ls_dd01v-ddlanguage = lv_language.

    CALL FUNCTION 'DDIF_DOMA_PUT'
      EXPORTING
        name              = lv_domain_name
        dd01v_wa          = ls_dd01v
      TABLES
        dd07v_tab         = lt_new_values
      EXCEPTIONS
        doma_not_found    = 1
        name_inconsistent = 2
        doma_inconsistent = 3
        put_failure       = 4
        put_refused       = 5
        OTHERS            = 6.
    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_VALUES_PUT'
        iv_object_type = 'DOMA'
        iv_object_name = lv_domain_name
        iv_message     = 'DDIF_DOMA_PUT failed while updating fixed values'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check fixed value lengths against the existing domain technical definition and DDIC locks' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'DDIF_DOMA_ACTIVATE'
      EXPORTING
        name   = lv_domain_name
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_VALUES_ACTIVATE'
        iv_object_type = 'DOMA'
        iv_object_name = lv_domain_name
        iv_message     = 'Domain fixed values were written but activation failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check activation log, domain value lengths, and DDIC locks' ).
      RETURN.
    ENDIF.

    CLEAR lt_readback_values.
    CALL FUNCTION 'DDIF_DOMA_GET'
      EXPORTING
        name          = lv_domain_name
        state         = 'A'
        langu         = lv_language
      TABLES
        dd07v_tab     = lt_readback_values
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DOMA_VALUES_READBACK'
        iv_object_type = 'DOMA'
        iv_object_name = lv_domain_name
        iv_message     = 'Domain activated but fixed value readback failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Call /debug/domain_values to inspect the active fixed values' ).
      RETURN.
    ENDIF.

    LOOP AT lt_readback_values INTO DATA(ls_readback_value).
      IF lv_values_json <> '['.
        lv_values_json = lv_values_json && ','.
      ENDIF.
      lv_values_json = lv_values_json &&
        |\{"low":"{ escape( val = ls_readback_value-domvalue_l format = cl_abap_format=>e_json_string ) }",| &&
        |"high":"{ escape( val = ls_readback_value-domvalue_h format = cl_abap_format=>e_json_string ) }",| &&
        |"description":"{ escape( val = ls_readback_value-ddtext format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.
    lv_values_json = lv_values_json && ']'.

    SELECT SINGLE as4local
      FROM dd01l
      INTO lv_active
      WHERE domname = lv_domain_name
        AND as4local = 'A'.

    rv_json = |\{"status":"OK","object_type":"DOMA","object_name":"{ lv_domain_name }",| &&
              |"mode":"{ lv_mode }","language":"{ lv_language }",| &&
              |"active":{ COND string( WHEN sy-subrc = 0 AND lv_active = 'A' THEN 'true' ELSE 'false' ) },| &&
              |"cts":{ lv_cts_json },"values":{ lv_values_json }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DOMAIN_VALUES_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD domain_values_from_json.
    DATA ls_request TYPE ty_domain_values_request.
    DATA lv_domain_name TYPE dd07v-domname.
    DATA lt_values TYPE STANDARD TABLE OF dd07v WITH EMPTY KEY.
    DATA lv_values TYPE string VALUE '['.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-domain_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"domain_name is required"}'.
      RETURN.
    ENDIF.

    lv_domain_name = to_upper( ls_request-domain_name ).

    SELECT *
      FROM dd07v
      INTO TABLE lt_values
      WHERE domname = lv_domain_name
        AND ddlanguage = sy-langu
      ORDER BY valpos.

    IF sy-subrc <> 0 OR lt_values IS INITIAL.
      SELECT *
        FROM dd07v
        INTO TABLE lt_values
        WHERE domname = lv_domain_name
        ORDER BY valpos.
    ENDIF.

    IF lt_values IS INITIAL.
      rv_json = |\{"status":"ERROR","domain_name":"{ lv_domain_name }","message":"No active fixed values found"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_values INTO DATA(ls_value).
      IF lv_values <> '['.
        lv_values = lv_values && ','.
      ENDIF.

      lv_values = lv_values &&
        |\{"low":"{ escape( val = ls_value-domvalue_l format = cl_abap_format=>e_json_string ) }",| &&
        |"high":"{ escape( val = ls_value-domvalue_h format = cl_abap_format=>e_json_string ) }",| &&
        |"text":"{ escape( val = ls_value-ddtext format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.

    lv_values = lv_values && ']'.
    rv_json = |\{"status":"OK","domain_name":"{ lv_domain_name }","values":{ lv_values }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->DYNPRO_READ_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD dynpro_read_json.
    DATA ls_request TYPE ty_dynpro_read_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA lt_fields TYPE STANDARD TABLE OF d021s.
    DATA lv_containers TYPE string VALUE '['.
    DATA lv_field_containers TYPE string VALUE '['.
    DATA lv_fields TYPE string VALUE '['.
    FIELD-SYMBOLS <ls_cont> LIKE LINE OF lt_containers.
    FIELD-SYMBOLS <lv_c_resize_v> TYPE any.
    FIELD-SYMBOLS <lv_c_resize_h> TYPE any.
    FIELD-SYMBOLS <lv_c_scroll_v> TYPE any.
    FIELD-SYMBOLS <lv_c_scroll_h> TYPE any.
    FIELD-SYMBOLS <lv_tc_tabtype> TYPE any.
    FIELD-SYMBOLS <lv_tc_separ_v> TYPE any.
    FIELD-SYMBOLS <lv_tc_separ_h> TYPE any.
    FIELD-SYMBOLS <lv_cont_tc_title> TYPE any.
    FIELD-SYMBOLS <lv_cont_tc_header> TYPE any.
    FIELD-SYMBOLS <lv_tc_config> TYPE any.
    FIELD-SYMBOLS <lv_tc_sel_lns> TYPE any.
    FIELD-SYMBOLS <lv_tc_sel_cls> TYPE any.
    FIELD-SYMBOLS <lv_tc_lsel_cl> TYPE any.
    FIELD-SYMBOLS <lv_tc_fixcol> TYPE any.
    FIELD-SYMBOLS <ls_field_cont> TYPE any.
    FIELD-SYMBOLS <lv_cont_type> TYPE any.
    FIELD-SYMBOLS <lv_cont_name> TYPE any.
    FIELD-SYMBOLS <lv_name> TYPE any.
    FIELD-SYMBOLS <lv_type> TYPE any.
    FIELD-SYMBOLS <lv_text> TYPE any.
    FIELD-SYMBOLS <lv_line> TYPE any.
    FIELD-SYMBOLS <lv_column> TYPE any.
    FIELD-SYMBOLS <lv_length> TYPE any.
    FIELD-SYMBOLS <lv_height> TYPE any.
    FIELD-SYMBOLS <lv_vislength> TYPE any.
    FIELD-SYMBOLS <lv_push_fcode> TYPE any.
    FIELD-SYMBOLS <lv_push_ftype> TYPE any.
    FIELD-SYMBOLS <lv_input_fld> TYPE any.
    FIELD-SYMBOLS <lv_output_fld> TYPE any.
    FIELD-SYMBOLS <lv_tc_heading> TYPE any.
    FIELD-SYMBOLS <lv_tc_title> TYPE any.
    FIELD-SYMBOLS <lv_tc_selcol> TYPE any.
    FIELD-SYMBOLS <lv_butt_right> TYPE any.
    FIELD-SYMBOLS <lv_format> TYPE any.
    FIELD-SYMBOLS <lv_bright> TYPE any.
    FIELD-SYMBOLS <lv_invisible> TYPE any.
    FIELD-SYMBOLS <lv_2_dimens> TYPE any.
    FIELD-SYMBOLS <lv_icon_name> TYPE any.
    FIELD-SYMBOLS <lv_icon_qinfo> TYPE any.
    FIELD-SYMBOLS <lv_with_icon> TYPE any.
    FIELD-SYMBOLS <lv_group1> TYPE any.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json = |\{"status":"ERROR","stage":"DYNPRO_READ_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.

    CALL FUNCTION 'RPY_DYNPRO_READ'
      EXPORTING
        progname             = lv_program
        dynnr                = lv_screen
        suppress_exist_checks = 'X'
        suppress_corr_checks  = 'X'
      IMPORTING
        header               = ls_header
      TABLES
        containers           = lt_containers
        fields_to_containers = lt_field_containers
        flow_logic           = lt_flow
        params               = lt_params
        fields_list          = lt_fields
      EXCEPTIONS
        cancelled            = 1
        not_found            = 2
        permission_error     = 3
        OTHERS               = 4.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_READ'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_READ failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check program, screen number, and authorization' ).
      RETURN.
    ENDIF.

    LOOP AT lt_containers ASSIGNING <ls_cont>.
      ASSIGN COMPONENT 'C_RESIZE_V' OF STRUCTURE <ls_cont> TO <lv_c_resize_v>.
      ASSIGN COMPONENT 'C_RESIZE_H' OF STRUCTURE <ls_cont> TO <lv_c_resize_h>.
      ASSIGN COMPONENT 'C_SCROLL_V' OF STRUCTURE <ls_cont> TO <lv_c_scroll_v>.
      ASSIGN COMPONENT 'C_SCROLL_H' OF STRUCTURE <ls_cont> TO <lv_c_scroll_h>.
      ASSIGN COMPONENT 'TC_TABTYPE' OF STRUCTURE <ls_cont> TO <lv_tc_tabtype>.
      ASSIGN COMPONENT 'TC_SEPAR_V' OF STRUCTURE <ls_cont> TO <lv_tc_separ_v>.
      ASSIGN COMPONENT 'TC_SEPAR_H' OF STRUCTURE <ls_cont> TO <lv_tc_separ_h>.
      ASSIGN COMPONENT 'TC_TITLE' OF STRUCTURE <ls_cont> TO <lv_cont_tc_title>.
      ASSIGN COMPONENT 'TC_HEADER' OF STRUCTURE <ls_cont> TO <lv_cont_tc_header>.
      ASSIGN COMPONENT 'TC_CONFIG' OF STRUCTURE <ls_cont> TO <lv_tc_config>.
      ASSIGN COMPONENT 'TC_SEL_LNS' OF STRUCTURE <ls_cont> TO <lv_tc_sel_lns>.
      ASSIGN COMPONENT 'TC_SEL_CLS' OF STRUCTURE <ls_cont> TO <lv_tc_sel_cls>.
      ASSIGN COMPONENT 'TC_LSEL_CL' OF STRUCTURE <ls_cont> TO <lv_tc_lsel_cl>.
      ASSIGN COMPONENT 'TC_FIXCOL' OF STRUCTURE <ls_cont> TO <lv_tc_fixcol>.
      IF lv_containers <> '['.
        lv_containers = lv_containers && ','.
      ENDIF.
      lv_containers = lv_containers &&
        |\{"type":"{ escape( val = <ls_cont>-type format = cl_abap_format=>e_json_string ) }",| &&
        |"name":"{ escape( val = <ls_cont>-name format = cl_abap_format=>e_json_string ) }",| &&
        |"element_of":"{ escape( val = <ls_cont>-element_of format = cl_abap_format=>e_json_string ) }",| &&
        |"line":"{ <ls_cont>-line }",| &&
        |"column":"{ <ls_cont>-column }",| &&
        |"length":"{ <ls_cont>-length }",| &&
        |"height":"{ <ls_cont>-height }",| &&
        |"loop_type":"{ escape( val = <ls_cont>-loop_type format = cl_abap_format=>e_json_string ) }",| &&
        |"loop_block":"{ <ls_cont>-loop_block }",| &&
        |"loop_disp":"{ <ls_cont>-loop_disp }",| &&
        |"c_resize_v":"{ COND string( WHEN <lv_c_resize_v> IS ASSIGNED THEN <lv_c_resize_v> ELSE '' ) }",| &&
        |"c_resize_h":"{ COND string( WHEN <lv_c_resize_h> IS ASSIGNED THEN <lv_c_resize_h> ELSE '' ) }",| &&
        |"c_scroll_v":"{ COND string( WHEN <lv_c_scroll_v> IS ASSIGNED THEN <lv_c_scroll_v> ELSE '' ) }",| &&
        |"c_scroll_h":"{ COND string( WHEN <lv_c_scroll_h> IS ASSIGNED THEN <lv_c_scroll_h> ELSE '' ) }",| &&
        |"tc_tabtype":"{ COND string( WHEN <lv_tc_tabtype> IS ASSIGNED THEN <lv_tc_tabtype> ELSE '' ) }",| &&
        |"tc_separ_v":"{ COND string( WHEN <lv_tc_separ_v> IS ASSIGNED THEN <lv_tc_separ_v> ELSE '' ) }",| &&
        |"tc_separ_h":"{ COND string( WHEN <lv_tc_separ_h> IS ASSIGNED THEN <lv_tc_separ_h> ELSE '' ) }",| &&
        |"tc_title":"{ COND string( WHEN <lv_cont_tc_title> IS ASSIGNED THEN <lv_cont_tc_title> ELSE '' ) }",| &&
        |"tc_header":"{ COND string( WHEN <lv_cont_tc_header> IS ASSIGNED THEN <lv_cont_tc_header> ELSE '' ) }",| &&
        |"tc_config":"{ COND string( WHEN <lv_tc_config> IS ASSIGNED THEN <lv_tc_config> ELSE '' ) }",| &&
        |"tc_sel_lns":"{ COND string( WHEN <lv_tc_sel_lns> IS ASSIGNED THEN <lv_tc_sel_lns> ELSE '' ) }",| &&
        |"tc_sel_cls":"{ COND string( WHEN <lv_tc_sel_cls> IS ASSIGNED THEN <lv_tc_sel_cls> ELSE '' ) }",| &&
        |"tc_lsel_cl":"{ COND string( WHEN <lv_tc_lsel_cl> IS ASSIGNED THEN <lv_tc_lsel_cl> ELSE '' ) }",| &&
        |"tc_fixcol":"{ COND string( WHEN <lv_tc_fixcol> IS ASSIGNED THEN <lv_tc_fixcol> ELSE '' ) }"\}|.
      UNASSIGN: <lv_c_resize_v>, <lv_c_resize_h>, <lv_c_scroll_v>, <lv_c_scroll_h>,
                <lv_tc_tabtype>, <lv_tc_separ_v>, <lv_tc_separ_h>, <lv_cont_tc_title>,
                <lv_cont_tc_header>, <lv_tc_config>, <lv_tc_sel_lns>, <lv_tc_sel_cls>,
                <lv_tc_lsel_cl>, <lv_tc_fixcol>.
    ENDLOOP.
    lv_containers = lv_containers && ']'.

    LOOP AT lt_field_containers ASSIGNING <ls_field_cont>.
      ASSIGN COMPONENT 'CONT_TYPE' OF STRUCTURE <ls_field_cont> TO <lv_cont_type>.
      ASSIGN COMPONENT 'CONT_NAME' OF STRUCTURE <ls_field_cont> TO <lv_cont_name>.
      ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_field_cont> TO <lv_name>.
      ASSIGN COMPONENT 'TYPE' OF STRUCTURE <ls_field_cont> TO <lv_type>.
      ASSIGN COMPONENT 'TEXT' OF STRUCTURE <ls_field_cont> TO <lv_text>.
      ASSIGN COMPONENT 'LINE' OF STRUCTURE <ls_field_cont> TO <lv_line>.
      ASSIGN COMPONENT 'COLUMN' OF STRUCTURE <ls_field_cont> TO <lv_column>.
      ASSIGN COMPONENT 'LENGTH' OF STRUCTURE <ls_field_cont> TO <lv_length>.
      ASSIGN COMPONENT 'HEIGHT' OF STRUCTURE <ls_field_cont> TO <lv_height>.
      ASSIGN COMPONENT 'VISLENGTH' OF STRUCTURE <ls_field_cont> TO <lv_vislength>.
      ASSIGN COMPONENT 'PUSH_FCODE' OF STRUCTURE <ls_field_cont> TO <lv_push_fcode>.
      ASSIGN COMPONENT 'PUSH_FTYPE' OF STRUCTURE <ls_field_cont> TO <lv_push_ftype>.
      ASSIGN COMPONENT 'INPUT_FLD' OF STRUCTURE <ls_field_cont> TO <lv_input_fld>.
      ASSIGN COMPONENT 'OUTPUT_FLD' OF STRUCTURE <ls_field_cont> TO <lv_output_fld>.
      ASSIGN COMPONENT 'TC_HEADING' OF STRUCTURE <ls_field_cont> TO <lv_tc_heading>.
      ASSIGN COMPONENT 'TC_TITLE' OF STRUCTURE <ls_field_cont> TO <lv_tc_title>.
      ASSIGN COMPONENT 'TC_SELCOL' OF STRUCTURE <ls_field_cont> TO <lv_tc_selcol>.
      ASSIGN COMPONENT 'BUTT_RIGHT' OF STRUCTURE <ls_field_cont> TO <lv_butt_right>.
      ASSIGN COMPONENT 'FORMAT' OF STRUCTURE <ls_field_cont> TO <lv_format>.
      ASSIGN COMPONENT 'BRIGHT' OF STRUCTURE <ls_field_cont> TO <lv_bright>.
      ASSIGN COMPONENT 'INVISIBLE' OF STRUCTURE <ls_field_cont> TO <lv_invisible>.
      ASSIGN COMPONENT '2_DIMENS' OF STRUCTURE <ls_field_cont> TO <lv_2_dimens>.
      ASSIGN COMPONENT 'ICON_NAME' OF STRUCTURE <ls_field_cont> TO <lv_icon_name>.
      ASSIGN COMPONENT 'ICON_QINFO' OF STRUCTURE <ls_field_cont> TO <lv_icon_qinfo>.
      ASSIGN COMPONENT 'WITH_ICON' OF STRUCTURE <ls_field_cont> TO <lv_with_icon>.
      ASSIGN COMPONENT 'GROUP1' OF STRUCTURE <ls_field_cont> TO <lv_group1>.

      IF lv_field_containers <> '['.
        lv_field_containers = lv_field_containers && ','.
      ENDIF.
      lv_field_containers = lv_field_containers &&
        |\{"cont_type":"{ COND string( WHEN <lv_cont_type> IS ASSIGNED THEN <lv_cont_type> ELSE '' ) }",| &&
        |"cont_name":"{ COND string( WHEN <lv_cont_name> IS ASSIGNED THEN <lv_cont_name> ELSE '' ) }",| &&
        |"name":"{ COND string( WHEN <lv_name> IS ASSIGNED THEN <lv_name> ELSE '' ) }",| &&
        |"type":"{ COND string( WHEN <lv_type> IS ASSIGNED THEN <lv_type> ELSE '' ) }",| &&
        |"text":"{ escape( val = COND string( WHEN <lv_text> IS ASSIGNED THEN <lv_text> ELSE '' ) format = cl_abap_format=>e_json_string ) }",| &&
        |"line":"{ COND string( WHEN <lv_line> IS ASSIGNED THEN <lv_line> ELSE '' ) }",| &&
        |"column":"{ COND string( WHEN <lv_column> IS ASSIGNED THEN <lv_column> ELSE '' ) }",| &&
        |"length":"{ COND string( WHEN <lv_length> IS ASSIGNED THEN <lv_length> ELSE '' ) }",| &&
        |"height":"{ COND string( WHEN <lv_height> IS ASSIGNED THEN <lv_height> ELSE '' ) }",| &&
        |"vislength":"{ COND string( WHEN <lv_vislength> IS ASSIGNED THEN <lv_vislength> ELSE '' ) }",| &&
        |"push_fcode":"{ COND string( WHEN <lv_push_fcode> IS ASSIGNED THEN <lv_push_fcode> ELSE '' ) }",| &&
        |"push_ftype":"{ COND string( WHEN <lv_push_ftype> IS ASSIGNED THEN <lv_push_ftype> ELSE '' ) }",| &&
        |"input_fld":"{ COND string( WHEN <lv_input_fld> IS ASSIGNED THEN <lv_input_fld> ELSE '' ) }",| &&
        |"output_fld":"{ COND string( WHEN <lv_output_fld> IS ASSIGNED THEN <lv_output_fld> ELSE '' ) }",| &&
        |"tc_heading":"{ COND string( WHEN <lv_tc_heading> IS ASSIGNED THEN <lv_tc_heading> ELSE '' ) }",| &&
        |"tc_title":"{ COND string( WHEN <lv_tc_title> IS ASSIGNED THEN <lv_tc_title> ELSE '' ) }",| &&
        |"tc_selcol":"{ COND string( WHEN <lv_tc_selcol> IS ASSIGNED THEN <lv_tc_selcol> ELSE '' ) }",| &&
        |"butt_right":"{ COND string( WHEN <lv_butt_right> IS ASSIGNED THEN <lv_butt_right> ELSE '' ) }",| &&
        |"format":"{ COND string( WHEN <lv_format> IS ASSIGNED THEN <lv_format> ELSE '' ) }",| &&
        |"bright":"{ COND string( WHEN <lv_bright> IS ASSIGNED THEN <lv_bright> ELSE '' ) }",| &&
        |"invisible":"{ COND string( WHEN <lv_invisible> IS ASSIGNED THEN <lv_invisible> ELSE '' ) }",| &&
        |"2_dimens":"{ COND string( WHEN <lv_2_dimens> IS ASSIGNED THEN <lv_2_dimens> ELSE '' ) }",| &&
        |"icon_name":"{ COND string( WHEN <lv_icon_name> IS ASSIGNED THEN <lv_icon_name> ELSE '' ) }",| &&
        |"icon_qinfo":"{ escape( val = COND string( WHEN <lv_icon_qinfo> IS ASSIGNED THEN <lv_icon_qinfo> ELSE '' ) format = cl_abap_format=>e_json_string ) }",| &&
        |"with_icon":"{ COND string( WHEN <lv_with_icon> IS ASSIGNED THEN <lv_with_icon> ELSE '' ) }",| &&
        |"group1":"{ COND string( WHEN <lv_group1> IS ASSIGNED THEN <lv_group1> ELSE '' ) }"\}|.
      UNASSIGN: <lv_cont_type>, <lv_cont_name>, <lv_name>, <lv_type>, <lv_text>, <lv_line>, <lv_column>, <lv_length>,
                <lv_height>, <lv_vislength>, <lv_push_fcode>, <lv_push_ftype>, <lv_input_fld>, <lv_output_fld>,
                <lv_tc_heading>, <lv_tc_title>, <lv_tc_selcol>, <lv_butt_right>, <lv_format>,
                <lv_bright>, <lv_invisible>, <lv_2_dimens>, <lv_icon_name>, <lv_icon_qinfo>, <lv_with_icon>, <lv_group1>.
    ENDLOOP.
    lv_field_containers = lv_field_containers && ']'.

    LOOP AT lt_fields INTO DATA(ls_field).
      IF lv_fields <> '['.
        lv_fields = lv_fields && ','.
      ENDIF.
      lv_fields = lv_fields &&
        |\{"fnam":"{ escape( val = ls_field-fnam format = cl_abap_format=>e_json_string ) }",| &&
        |"type":"{ escape( val = ls_field-type format = cl_abap_format=>e_json_string ) }",| &&
        |"line":"{ ls_field-line }",| &&
        |"coln":"{ ls_field-coln }",| &&
        |"leng":"{ ls_field-leng }",| &&
        |"ityp":"{ escape( val = ls_field-ityp format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.
    lv_fields = lv_fields && ']'.

    rv_json = |\{"status":"OK","program":"{ lv_program }","screen":"{ lv_screen }",| &&
              |"header":\{"program":"{ ls_header-program }","screen":"{ ls_header-screen }","type":"{ ls_header-type }","descript":"{ escape( val = ls_header-descript format = cl_abap_format=>e_json_string ) }"\},| &&
              |"containers":{ lv_containers },| &&
              |"fields_to_containers":{ lv_field_containers },| &&
              |"fields_list":{ lv_fields }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->FM_INTERFACE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fm_interface_from_json.
    DATA ls_request TYPE ty_fm_interface_request.
    DATA lv_funcname TYPE tfdir-funcname.
    DATA lt_params TYPE STANDARD TABLE OF fupararef WITH EMPTY KEY.
    DATA lv_params TYPE string VALUE '['.
    DATA lv_parameter TYPE string.
    DATA lv_paramtype TYPE string.
    DATA lv_structure TYPE string.
    DATA lv_default TYPE string.
    DATA lv_optional TYPE string.
    FIELD-SYMBOLS <ls_param> TYPE any.
    FIELD-SYMBOLS <lv_parameter> TYPE any.
    FIELD-SYMBOLS <lv_paramtype> TYPE any.
    FIELD-SYMBOLS <lv_structure> TYPE any.
    FIELD-SYMBOLS <lv_default> TYPE any.
    FIELD-SYMBOLS <lv_optional> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-function_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"function_name is required"}'.
      RETURN.
    ENDIF.

    lv_funcname = to_upper( ls_request-function_name ).

    SELECT *
      FROM fupararef
      INTO TABLE lt_params
      WHERE funcname = lv_funcname
      ORDER BY pposition.

    IF sy-subrc <> 0 OR lt_params IS INITIAL.
      rv_json = |\{"status":"ERROR","function_name":"{ lv_funcname }","message":"Function interface was not found in FUPARAREF"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_params ASSIGNING <ls_param>.
      IF lv_params <> '['.
        lv_params = lv_params && ','.
      ENDIF.

      ASSIGN COMPONENT 'PARAMETER' OF STRUCTURE <ls_param> TO <lv_parameter>.
      ASSIGN COMPONENT 'PARAMTYPE' OF STRUCTURE <ls_param> TO <lv_paramtype>.
      ASSIGN COMPONENT 'STRUCTURE' OF STRUCTURE <ls_param> TO <lv_structure>.
      ASSIGN COMPONENT 'DEFAULTVAL' OF STRUCTURE <ls_param> TO <lv_default>.
      ASSIGN COMPONENT 'OPTIONAL' OF STRUCTURE <ls_param> TO <lv_optional>.

      CLEAR: lv_parameter, lv_paramtype, lv_structure, lv_default, lv_optional.
      IF <lv_parameter> IS ASSIGNED.
        lv_parameter = <lv_parameter>.
      ENDIF.
      IF <lv_paramtype> IS ASSIGNED.
        lv_paramtype = <lv_paramtype>.
      ENDIF.
      IF <lv_structure> IS ASSIGNED.
        lv_structure = <lv_structure>.
      ENDIF.
      IF <lv_default> IS ASSIGNED.
        lv_default = <lv_default>.
      ENDIF.
      IF <lv_optional> IS ASSIGNED.
        lv_optional = <lv_optional>.
      ENDIF.

      lv_params = lv_params &&
        |\{"parameter":"{ lv_parameter }",| &&
        |"paramtype":"{ lv_paramtype }",| &&
        |"structure":"{ lv_structure }",| &&
        |"default":"{ escape( val = lv_default format = cl_abap_format=>e_json_string ) }",| &&
        |"optional":"{ lv_optional }"\}|.
    ENDLOOP.

    lv_params = lv_params && ']'.
    rv_json = |\{"status":"OK","function_name":"{ lv_funcname }","parameters":{ lv_params }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->GET_DATA_ELEMENT_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data_element_status.
    DATA lv_rollname TYPE dd04l-rollname.
    DATA lv_domname TYPE dd04l-domname.
    DATA lv_as4local TYPE dd04l-as4local.
    DATA lv_domain_as4local TYPE dd01l-as4local.
    DATA lv_reason TYPE string.
    DATA lv_tadir_json TYPE string.

    IF iv_name IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"DTEL","message":"Data element name is required"}'.
      RETURN.
    ENDIF.

    SELECT SINGLE rollname domname as4local
      FROM dd04l
      INTO (lv_rollname, lv_domname, lv_as4local)
      WHERE rollname = iv_name
        AND as4local <> 'D'.

    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","object_type":"DTEL","object_name":"{ iv_name }","active":false,"message":"Data element does not exist"\}|.
      RETURN.
    ENDIF.

    SELECT SINGLE as4local
      FROM dd01l
      INTO lv_domain_as4local
      WHERE domname = lv_domname
        AND as4local <> 'D'.

    IF sy-subrc <> 0.
      lv_reason = 'Referenced domain does not exist'.
      rv_json = |\{"status":"ERROR","object_type":"DTEL","object_name":"{ lv_rollname }",| &&
                |"domain":"{ lv_domname }","active":false,"as4local":"{ lv_as4local }",| &&
                |"message":"{ lv_reason }"\}|.
      RETURN.
    ENDIF.

    IF lv_domain_as4local <> 'A'.
      lv_reason = 'Referenced domain exists but is not active'.
      rv_json = |\{"status":"ERROR","object_type":"DTEL","object_name":"{ lv_rollname }",| &&
                |"domain":"{ lv_domname }","active":false,"as4local":"{ lv_as4local }",| &&
                |"domain_as4local":"{ lv_domain_as4local }","message":"{ lv_reason }"\}|.
      RETURN.
    ENDIF.

    lv_tadir_json = get_tadir_json(
      iv_pgmid       = 'R3TR'
      iv_object_type = 'DTEL'
      iv_object_name = lv_rollname ).

    IF lv_as4local = 'A'.
      lv_reason = 'Data element is active'.
      rv_json = |\{"status":"OK","object_type":"DTEL","object_name":"{ lv_rollname }",| &&
                |"domain":"{ lv_domname }","active":true,"as4local":"{ lv_as4local }",| &&
                |"domain_as4local":"{ lv_domain_as4local }","tadir":{ lv_tadir_json },| &&
                |"message":"{ lv_reason }"\}|.
    ELSE.
      lv_reason = 'Data element exists but is not active'.
      rv_json = |\{"status":"ERROR","object_type":"DTEL","object_name":"{ lv_rollname }",| &&
                |"domain":"{ lv_domname }","active":false,"as4local":"{ lv_as4local }",| &&
                |"domain_as4local":"{ lv_domain_as4local }","tadir":{ lv_tadir_json },| &&
                |"message":"{ lv_reason }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->GET_DOMAIN_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_domain_status.
    DATA lv_domname TYPE dd01l-domname.
    DATA lv_as4local TYPE dd01l-as4local.
    DATA lv_reason TYPE string.
    DATA lv_tadir_json TYPE string.

    IF iv_name IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"DOMA","message":"Domain name is required"}'.
      RETURN.
    ENDIF.

    SELECT SINGLE domname as4local
      FROM dd01l
      INTO (lv_domname, lv_as4local)
      WHERE domname = iv_name
        AND as4local <> 'D'.

    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","object_type":"DOMA","object_name":"{ iv_name }","active":false,"message":"Domain does not exist"\}|.
      RETURN.
    ENDIF.

    lv_tadir_json = get_tadir_json(
      iv_pgmid       = 'R3TR'
      iv_object_type = 'DOMA'
      iv_object_name = lv_domname ).

    IF lv_as4local = 'A'.
      lv_reason = 'Domain is active'.
      rv_json = |\{"status":"OK","object_type":"DOMA","object_name":"{ lv_domname }","active":true,| &&
                |"as4local":"{ lv_as4local }","tadir":{ lv_tadir_json },"message":"{ lv_reason }"\}|.
    ELSE.
      lv_reason = 'Domain exists but is not active'.
      rv_json = |\{"status":"ERROR","object_type":"DOMA","object_name":"{ lv_domname }","active":false,| &&
                |"as4local":"{ lv_as4local }","tadir":{ lv_tadir_json },"message":"{ lv_reason }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->GET_TABLE_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_table_status.
    DATA lv_tabname TYPE dd02l-tabname.
    DATA lv_as4local TYPE dd02l-as4local.
    DATA lv_reason TYPE string.
    DATA lv_tadir_json TYPE string.

    IF iv_name IS INITIAL.
      rv_json = '{"status":"ERROR","object_type":"TABL","message":"Table name is required"}'.
      RETURN.
    ENDIF.

    SELECT SINGLE tabname as4local
      FROM dd02l
      INTO (lv_tabname, lv_as4local)
      WHERE tabname = iv_name
        AND as4local <> 'D'.

    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","object_type":"TABL","object_name":"{ iv_name }","active":false,"message":"Table does not exist"\}|.
      RETURN.
    ENDIF.

    lv_tadir_json = get_tadir_json(
      iv_pgmid       = 'R3TR'
      iv_object_type = 'TABL'
      iv_object_name = lv_tabname ).

    IF lv_as4local = 'A'.
      lv_reason = 'Table is active'.
      rv_json = |\{"status":"OK","object_type":"TABL","object_name":"{ lv_tabname }","active":true,| &&
                |"as4local":"{ lv_as4local }","tadir":{ lv_tadir_json },"message":"{ lv_reason }"\}|.
    ELSE.
      lv_reason = 'Table exists but is not active'.
      rv_json = |\{"status":"ERROR","object_type":"TABL","object_name":"{ lv_tabname }","active":false,| &&
                |"as4local":"{ lv_as4local }","tadir":{ lv_tadir_json },"message":"{ lv_reason }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->GET_TADIR_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PGMID                       TYPE        TADIR-PGMID
* | [--->] IV_OBJECT_TYPE                 TYPE        TADIR-OBJECT
* | [--->] IV_OBJECT_NAME                 TYPE        CSEQUENCE
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tadir_json.
    DATA lv_pgmid TYPE tadir-pgmid.
    DATA lv_object_type TYPE tadir-object.
    DATA lv_object TYPE tadir-obj_name.
    DATA lv_devclass TYPE tadir-devclass.
    DATA lv_author TYPE tadir-author.
    DATA lv_srcsystem TYPE tadir-srcsystem.
    DATA lv_masterlang TYPE tadir-masterlang.

    lv_pgmid = iv_pgmid.
    lv_object_type = iv_object_type.
    lv_object = to_upper( iv_object_name ).

    SELECT SINGLE devclass author srcsystem masterlang
      FROM tadir
      INTO (lv_devclass, lv_author, lv_srcsystem, lv_masterlang)
      WHERE pgmid = lv_pgmid
        AND object = lv_object_type
        AND obj_name = lv_object.

    IF sy-subrc = 0.
      rv_json = |\{"found":true,"pgmid":"{ lv_pgmid }","object":"{ lv_object_type }",| &&
                |"obj_name":"{ escape( val = lv_object format = cl_abap_format=>e_json_string ) }",| &&
                |"package":"{ escape( val = lv_devclass format = cl_abap_format=>e_json_string ) }",| &&
                |"devclass":"{ escape( val = lv_devclass format = cl_abap_format=>e_json_string ) }",| &&
                |"author":"{ escape( val = lv_author format = cl_abap_format=>e_json_string ) }",| &&
                |"srcsystem":"{ escape( val = lv_srcsystem format = cl_abap_format=>e_json_string ) }",| &&
                |"masterlang":"{ escape( val = lv_masterlang format = cl_abap_format=>e_json_string ) }"\}|.
    ELSE.
      rv_json = |\{"found":false,"pgmid":"{ lv_pgmid }","object":"{ lv_object_type }",| &&
                |"obj_name":"{ escape( val = lv_object format = cl_abap_format=>e_json_string ) }",| &&
                |"package":"","devclass":""\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_ACTIVATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_activate.
    DATA(lv_result) = activate_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_CAPABILITIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_capabilities.
    DATA(lv_result) = capabilities_json( ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_check.
    DATA(lv_result) = check_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_CLASS_METHOD_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_class_method_read.
    DATA(lv_result) = class_method_read_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DDIC_CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_ddic_create.
    DATA(lv_result) = create_ddic_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DDIC_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_ddic_status.
    DATA(lv_result) = status_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DDIC_VALIDATE_NAMES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_ddic_validate_names.
    DATA(lv_result) = validate_names_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_CLASS_METHODS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_class_methods.
    DATA(lv_result) = class_methods_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_DDIC_FIELDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_ddic_fields.
    DATA(lv_result) = ddic_fields_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_DDIC_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_ddic_type.
    DATA(lv_result) = ddic_type_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_DOMAIN_VALUES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_domain_values.
    DATA(lv_result) = domain_values_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_DYNPRO_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_dynpro_read.
    DATA(lv_result) = dynpro_read_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_FM_INTERFACE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_fm_interface.
    DATA(lv_result) = fm_interface_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DEBUG_LOCKS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_debug_locks.
    DATA(lv_result) = locks_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DOMA_VALUES_UPDATE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_doma_values_update.
    DATA(lv_result) = domain_update_values_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_json.
    DATA(lv_result) = import_dynpro_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_SCREEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_screen.
    DATA(lv_result) = import_dynpro_screen_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_CCTRL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_cctrl.
    DATA(lv_result) = import_dynpro_cctrl_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_LAYOUT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_layout.
    DATA(lv_result) = import_dynpro_layout_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_MINIMAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_minimal.
    DATA(lv_result) = import_min_dynpro_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_DYNPRO_IMPORT_TC_MIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_dynpro_import_tc_min.
    DATA(lv_result) = import_tc_min_dynpro_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUGR_MAIN_SOURCE_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_fugr_main_source_save.
    DATA(lv_result) = save_fugr_main_source_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUNCTION_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_function_check.
    DATA(lv_result) = check_function_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUNCTION_CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_function_create.
    DATA(lv_result) = create_function_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUNCTION_GROUP_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_function_group_read.
    DATA(lv_result) = read_function_group_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUNCTION_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_function_read.
    DATA(lv_result) = read_function_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_FUNCTION_SOURCE_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_function_source_save.
    DATA(lv_result) = save_function_source_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_INCLUDE_SOURCE_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_include_source_save.
    DATA(lv_result) = save_include_source_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_MESSAGE_SAVE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_message_save.
    DATA(lv_result) = message_save_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_OBJECT_LIFECYCLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_object_lifecycle.
    DATA(lv_result) = object_lifecycle_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_OBJECT_REPAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_object_repair.
    DATA(lv_result) = object_repair_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_PROBE_RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_probe_run.
    DATA(lv_result) = probe_run_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_read.
    DATA(lv_result) = read_object_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_run.
    DATA(lv_result) = run( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_save.
    DATA(lv_result) = save_source_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->HANDLE_TEXTPOOL_SAVE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_textpool_save.
    DATA(lv_result) = textpool_save_from_json( io_server->request->get_cdata( ) ).
    write_json( io_server = io_server iv_status = 200 iv_json = lv_result ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AI_MCP_REST_FUN->IF_HTTP_EXTENSION~HANDLE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] SERVER                         TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_http_extension~handle_request.
    DATA lv_method TYPE string.
    DATA lv_path TYPE string.
    DATA lv_error_json TYPE string.

    TRY.
        lv_method = server->request->get_method( ).
        lv_path = server->request->get_header_field( 'PATH_INFO' ).

        IF lv_method <> 'POST'.
          write_json(
            io_server = server
            iv_status = 405
            iv_json   = '{"status":"ERROR","message":"Only POST is supported"}' ).
          RETURN.
        ENDIF.

        CASE lv_path.
          WHEN '/capabilities'.
            handle_capabilities( server ).
          WHEN '/run'.
            handle_run( server ).
          WHEN '/object/check'.
            handle_check( server ).
          WHEN '/object/read'.
            handle_read( server ).
          WHEN '/object/save'.
            handle_save( server ).
          WHEN '/object/activate'.
            handle_activate( server ).
          WHEN '/object/repair'.
            handle_object_repair( server ).
          WHEN '/object/lifecycle'.
            handle_object_lifecycle( server ).
          WHEN '/function/create'.
            handle_function_create( server ).
          WHEN '/function/check'.
            handle_function_check( server ).
          WHEN '/function/read'.
            handle_function_read( server ).
          WHEN '/function_group/read'.
            handle_function_group_read( server ).
          WHEN '/function/source_save'.
            handle_function_source_save( server ).
          WHEN '/include/source_save'.
            handle_include_source_save( server ).
          WHEN '/function/main_source_save'.
            handle_fugr_main_source_save( server ).
          WHEN '/message/save'.
            handle_message_save( server ).
          WHEN '/textpool/save'.
            handle_textpool_save( server ).
          WHEN '/ddic/create'.
            handle_ddic_create( server ).
          WHEN '/ddic/validate_names'.
            handle_ddic_validate_names( server ).
          WHEN '/ddic/status'.
            handle_ddic_status( server ).
          WHEN '/ddic/domain/update_values'.
            handle_doma_values_update( server ).
          WHEN '/debug/fm_interface'.
            handle_debug_fm_interface( server ).
          WHEN '/debug/ddic_fields'.
            handle_debug_ddic_fields( server ).
          WHEN '/debug/ddic_type'.
            handle_debug_ddic_type( server ).
          WHEN '/debug/domain_values'.
            handle_debug_domain_values( server ).
          WHEN '/debug/class_methods'.
            handle_debug_class_methods( server ).
          WHEN '/class/method/read'.
            handle_class_method_read( server ).
          WHEN '/probe/run'.
            handle_probe_run( server ).
          WHEN '/debug/locks'.
            handle_debug_locks( server ).
          WHEN '/debug/dynpro_read'.
            handle_debug_dynpro_read( server ).
          WHEN '/dynpro/import_minimal'.
            handle_dynpro_import_minimal( server ).
          WHEN '/dynpro/import_tc_minimal'.
            handle_dynpro_import_tc_min( server ).
          WHEN '/dynpro/import_from_json'.
            handle_dynpro_import_json( server ).
          WHEN '/dynpro/import_screen'.
            handle_dynpro_import_screen( server ).
          WHEN '/dynpro/import_custom_control'.
            handle_dynpro_import_cctrl( server ).
          WHEN '/dynpro/import_layout'.
            handle_dynpro_import_layout( server ).
          WHEN OTHERS.
            write_json(
              io_server = server
              iv_status = 404
              iv_json   = '{"status":"ERROR","message":"Unknown endpoint"}' ).
        ENDCASE.
      CATCH cx_root INTO DATA(lx_request).
        lv_error_json = |\{"status":"ERROR","stage":"HTTP_HANDLER",| &&
                        |"message":"{ escape( val = lx_request->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        IF server IS BOUND.
          server->response->set_status( code = 500 reason = 'ERROR' ).
          server->response->set_header_field( name = 'Content-Type' value = 'application/json; charset=utf-8' ).
          server->response->set_cdata( lv_error_json ).
        ENDIF.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_DYNPRO_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_dynpro_from_json.
    DATA ls_request TYPE ty_dynpro_json_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA lv_top_include TYPE syrepid.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA ls_container LIKE LINE OF lt_containers.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA ls_field_container LIKE LINE OF lt_field_containers.
    DATA lt_top_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_tc_name TYPE string.
    DATA lv_data_table TYPE string.
    DATA lv_ok_code TYPE string.
    DATA lv_lines_variable TYPE string.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.
    DATA lv_upper_name TYPE string.
    DATA lv_col_type TYPE string.
    DATA lv_function_pool TYPE string.
    DATA lv_default_length TYPE i.
    DATA lv_column_index TYPE i.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json = |\{"status":"ERROR","stage":"DYNPRO_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-table_control-name IS INITIAL OR ls_request-table_control-data_table IS INITIAL.
      rv_json = '{"status":"ERROR","message":"table_control.name and table_control.data_table are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-columns IS INITIAL.
      rv_json = '{"status":"ERROR","message":"columns are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-screen NP '9+++'.
      rv_json = '{"status":"ERROR","message":"screen must be a 4-digit number starting with 9"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.
    IF ls_request-replace_existing = abap_true.
      lv_suppress_exist = 'X'.
    ENDIF.

    lv_tc_name = to_upper( ls_request-table_control-name ).
    lv_data_table = to_upper( ls_request-table_control-data_table ).
    lv_ok_code = to_upper( ls_request-ok_code ).
    IF lv_ok_code IS INITIAL.
      lv_ok_code = 'OK_CODE'.
    ENDIF.
    lv_lines_variable = to_upper( ls_request-table_control-lines_variable ).
    IF lv_lines_variable IS INITIAL.
      lv_lines_variable = |G_{ lv_tc_name }_LINES|.
    ENDIF.

    IF ls_request-top_include IS NOT INITIAL.
      lv_top_include = to_upper( ls_request-top_include ).
      IF lv_top_include(2) <> 'LZ'.
        rv_json = |\{"status":"ERROR","stage":"TOP_INCLUDE_VALIDATE",| &&
                  |"message":"Only LZ* generated includes can be changed through this API",| &&
                  |"include":"{ lv_top_include }"\}|.
        RETURN.
      ENDIF.

      lv_function_pool = lv_program.
      IF lv_function_pool CP 'SAPL*'.
        lv_function_pool = lv_function_pool+4.
      ENDIF.

      APPEND |FUNCTION-POOL { lv_function_pool }.| TO lt_top_source.
      APPEND || TO lt_top_source.
      APPEND |DATA: { lv_ok_code } TYPE sy-ucomm.| TO lt_top_source.
      APPEND || TO lt_top_source.
      APPEND |DATA: BEGIN OF { lv_data_table } OCCURS 0,| TO lt_top_source.
      LOOP AT ls_request-columns INTO DATA(ls_top_column).
        lv_upper_name = to_upper( ls_top_column-field ).
        lv_col_type = to_lower( ls_top_column-abap_type ).
        IF lv_col_type IS INITIAL.
          lv_col_type = 'char20'.
        ENDIF.
        APPEND |        { lv_upper_name } TYPE { lv_col_type },| TO lt_top_source.
      ENDLOOP.
      APPEND |      END OF { lv_data_table }.| TO lt_top_source.
      APPEND || TO lt_top_source.
      APPEND |CONTROLS: { lv_tc_name } TYPE TABLEVIEW USING SCREEN { lv_screen }.| TO lt_top_source.
      APPEND || TO lt_top_source.
      APPEND |DATA: { lv_lines_variable } LIKE sy-loopc.| TO lt_top_source.

      TRY.
          INSERT REPORT lv_top_include FROM lt_top_source PROGRAM TYPE 'I'.
        CATCH cx_root INTO DATA(lx_top_save).
          rv_json = |\{"status":"ERROR","stage":"TOP_INCLUDE_SAVE",| &&
                    |"include":"{ lv_top_include }",| &&
                    |"message":"{ escape( val = lx_top_save->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
          RETURN.
      ENDTRY.
    ENDIF.

    IF ls_request-function_name_for_check IS NOT INITIAL.
      lv_function_name = to_upper( ls_request-function_name_for_check ).
      DATA(lv_check_json) = check_function_from_json( |\{"function_name":"{ lv_function_name }"\}| ).
      IF lv_check_json CS '"status":"ERROR"'.
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_GROUP_CHECK",| &&
                  |"check":{ lv_check_json }\}|.
        RETURN.
      ENDIF.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP generated screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    IF ls_request-next_screen IS NOT INITIAL.
      ls_header-nextscreen = ls_request-next_screen.
    ELSE.
      ls_header-nextscreen = lv_screen.
    ENDIF.
    IF ls_request-screen_lines > 0.
      ls_header-lines = ls_request-screen_lines.
    ELSE.
      ls_header-lines = '24'.
    ENDIF.
    IF ls_request-screen_columns > 0.
      ls_header-columns = ls_request-screen_columns.
    ELSE.
      ls_header-columns = '80'.
    ENDIF.

    CLEAR ls_container.
    ls_container-type = 'SCREEN'.
    ls_container-name = 'SCREEN'.
    APPEND ls_container TO lt_containers.

    CLEAR ls_container.
    ls_container-type = 'TABLE_CTRL'.
    ls_container-name = lv_tc_name.
    ls_container-element_of = 'SCREEN'.
    IF ls_request-table_control-line > 0.
      ls_container-line = ls_request-table_control-line.
    ELSE.
      ls_container-line = 3.
    ENDIF.
    IF ls_request-table_control-column > 0.
      ls_container-column = ls_request-table_control-column.
    ELSE.
      ls_container-column = 1.
    ENDIF.
    IF ls_request-table_control-length > 0.
      ls_container-length = ls_request-table_control-length.
    ELSE.
      ls_container-length = 60.
    ENDIF.
    IF ls_request-table_control-height > 0.
      ls_container-height = ls_request-table_control-height.
    ELSE.
      ls_container-height = 8.
    ENDIF.
    ls_container-tc_header = 'X'.
    IF ls_request-table_control-separ_v = abap_false AND
       ls_request-table_control-separ_h = abap_false.
      ls_container-tc_separ_v = 'X'.
      ls_container-tc_separ_h = 'X'.
    ELSE.
      IF ls_request-table_control-separ_v = abap_true.
        ls_container-tc_separ_v = 'X'.
      ENDIF.
      IF ls_request-table_control-separ_h = abap_true.
        ls_container-tc_separ_h = 'X'.
      ENDIF.
    ENDIF.
    IF ls_request-table_control-scroll_v = abap_true.
      ls_container-c_scroll_v = 'X'.
    ENDIF.
    IF ls_request-table_control-scroll_h = abap_true.
      ls_container-c_scroll_h = 'X'.
    ENDIF.
    IF ls_request-table_control-resize_v = abap_true.
      ls_container-c_resize_v = 'X'.
    ENDIF.
    IF ls_request-table_control-resize_h = abap_true.
      ls_container-c_resize_h = 'X'.
    ENDIF.
    IF ls_request-table_control-config = abap_true.
      ls_container-tc_config = 'X'.
    ENDIF.
    IF ls_request-table_control-line_min > 0.
      ls_container-c_line_min = ls_request-table_control-line_min.
    ENDIF.
    IF ls_request-table_control-column_min > 0.
      ls_container-c_coln_min = ls_request-table_control-column_min.
    ENDIF.
    IF ls_request-table_control-select_lines = abap_true.
      ls_container-tc_sel_lns = 'MULTIPLE'.
    ENDIF.
    IF ls_request-table_control-select_columns = abap_true.
      ls_container-tc_sel_cls = 'X'.
    ENDIF.
    IF ls_request-table_control-line_selector = abap_true.
      ls_container-tc_lsel_cl = 'X'.
    ENDIF.
    IF ls_request-table_control-fixed_columns > 0.
      ls_container-tc_fixcol = ls_request-table_control-fixed_columns.
    ENDIF.
    APPEND ls_container TO lt_containers.

    LOOP AT ls_request-screen_elements INTO DATA(ls_element).
      CLEAR ls_field_container.
      ls_field_container-cont_type = 'SCREEN'.
      ls_field_container-cont_name = 'SCREEN'.
      ls_field_container-name = to_upper( ls_element-name ).
      ls_field_container-type = to_upper( ls_element-type ).
      ls_field_container-text = ls_element-text.
      ls_field_container-line = ls_element-line.
      ls_field_container-column = ls_element-column.
      ls_field_container-length = ls_element-length.
      IF ls_element-vislength > 0.
        ls_field_container-vislength = ls_element-vislength.
      ELSE.
        ls_field_container-vislength = ls_element-length.
      ENDIF.
      IF ls_element-height > 0.
        ls_field_container-height = ls_element-height.
      ELSEIF ls_field_container-type = 'FRAME'.
        ls_field_container-height = 20.
      ELSE.
        ls_field_container-height = 1.
      ENDIF.
      IF ls_element-format IS NOT INITIAL.
        ls_field_container-format = to_upper( ls_element-format ).
      ELSE.
        ls_field_container-format = 'CHAR'.
      ENDIF.
      IF ls_element-input = abap_true.
        ls_field_container-input_fld = 'X'.
      ENDIF.
      IF ls_element-output = abap_true.
        ls_field_container-output_fld = 'X'.
      ENDIF.
      IF ls_element-invisible = abap_true.
        ls_field_container-invisible = 'X'.
      ENDIF.
      IF ls_field_container-type = 'FRAME' AND ls_field_container-text IS INITIAL.
        CLEAR ls_field_container-text.
        DO ls_field_container-length TIMES.
          ls_field_container-text = ls_field_container-text && '_'.
        ENDDO.
      ENDIF.
      IF ls_field_container-type = 'PUSH'.
        ls_field_container-push_fcode = to_upper( ls_element-fcode ).
      ENDIF.
      IF ls_element-icon_name IS NOT INITIAL.
        ls_field_container-icon_name = to_upper( ls_element-icon_name ).
        ls_field_container-with_icon = 'X'.
      ENDIF.
      IF ls_element-icon_text IS NOT INITIAL.
        ls_field_container-icon_qinfo = ls_element-icon_text.
      ENDIF.
      IF ls_element-group1 IS NOT INITIAL.
        ls_field_container-group1 = to_upper( ls_element-group1 ).
      ENDIF.
      APPEND ls_field_container TO lt_field_containers.
    ENDLOOP.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = lv_ok_code.
    ls_field_container-type = 'OKCODE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '0'.
    ls_field_container-column = '0'.
    ls_field_container-length = '20'.
    ls_field_container-height = 1.
    ls_field_container-vislength = 20.
    ls_field_container-input_fld = 'X'.
    ls_field_container-format = 'CHAR'.
    APPEND ls_field_container TO lt_field_containers.

    lv_column_index = 0.
    LOOP AT ls_request-columns INTO DATA(ls_column).
      lv_column_index = lv_column_index + 1.
      CLEAR ls_field_container.
      ls_field_container-cont_type = 'TABLE_CTRL'.
      ls_field_container-cont_name = lv_tc_name.
      ls_field_container-name = |{ lv_data_table }-{ to_upper( ls_column-field ) }|.
      IF to_upper( ls_column-field_type ) = 'CHECK'.
        ls_field_container-type = 'CHECK'.
      ELSE.
        ls_field_container-type = 'TEMPLATE'.
      ENDIF.
      IF ls_column-length > 0.
        lv_default_length = ls_column-length.
      ELSE.
        lv_default_length = 20.
      ENDIF.
      IF ls_column-generate_heading = abap_true OR ls_column-heading_text IS NOT INITIAL.
        CLEAR ls_field_container.
        ls_field_container-cont_type = 'TABLE_CTRL'.
        ls_field_container-cont_name = lv_tc_name.
        ls_field_container-name = |{ lv_data_table }-{ to_upper( ls_column-field ) }|.
        ls_field_container-type = 'TEXT'.
        IF ls_column-heading_text IS INITIAL.
          ls_field_container-text = to_upper( ls_column-field ).
        ELSE.
          ls_field_container-text = ls_column-heading_text.
        ENDIF.
        ls_field_container-line = '1'.
        IF ls_column-column > 0.
          ls_field_container-column = ls_column-column.
        ELSE.
          ls_field_container-column = lv_column_index.
        ENDIF.
        ls_field_container-length = lv_default_length.
        IF ls_column-vislength > 0.
          ls_field_container-vislength = ls_column-vislength.
        ELSE.
          ls_field_container-vislength = lv_default_length.
        ENDIF.
        ls_field_container-height = 1.
        ls_field_container-tc_heading = 'X'.
        ls_field_container-format = 'CHAR'.
        APPEND ls_field_container TO lt_field_containers.
      ENDIF.

      CLEAR ls_field_container.
      ls_field_container-cont_type = 'TABLE_CTRL'.
      ls_field_container-cont_name = lv_tc_name.
      ls_field_container-name = |{ lv_data_table }-{ to_upper( ls_column-field ) }|.
      IF to_upper( ls_column-field_type ) = 'CHECK'.
        ls_field_container-type = 'CHECK'.
      ELSE.
        ls_field_container-type = 'TEMPLATE'.
      ENDIF.
      IF ls_column-template_text IS INITIAL.
        CLEAR ls_field_container-text.
        DO lv_default_length TIMES.
          ls_field_container-text = ls_field_container-text && '_'.
        ENDDO.
      ELSE.
        ls_field_container-text = ls_column-template_text.
      ENDIF.
      ls_field_container-line = '1'.
      IF ls_column-omit_column = abap_false AND
         ls_column-selection_column = abap_false.
        IF ls_column-column > 0.
          ls_field_container-column = ls_column-column.
        ELSE.
          ls_field_container-column = lv_column_index.
        ENDIF.
      ENDIF.
      ls_field_container-length = lv_default_length.
      IF ls_column-vislength > 0.
        ls_field_container-vislength = ls_column-vislength.
      ELSE.
        ls_field_container-vislength = lv_default_length.
      ENDIF.
      ls_field_container-height = 1.
      ls_field_container-format = 'CHAR'.
      IF ls_field_container-type = 'CHECK' AND
         ls_column-selection_column = abap_true.
        ls_field_container-tc_selcol = 'X'.
      ENDIF.
      IF ls_column-input = abap_false AND ls_column-output = abap_false.
        ls_field_container-input_fld = 'X'.
        ls_field_container-output_fld = 'X'.
      ELSE.
        IF ls_column-input = abap_true.
          ls_field_container-input_fld = 'X'.
        ENDIF.
        IF ls_column-output = abap_true.
          ls_field_container-output_fld = 'X'.
        ENDIF.
      ENDIF.
      APPEND ls_field_container TO lt_field_containers.
    ENDLOOP.

    IF ls_request-flow_logic IS NOT INITIAL.
      LOOP AT ls_request-flow_logic INTO DATA(lv_flow_line).
        CLEAR ls_flow.
        ls_flow-line = lv_flow_line.
        APPEND ls_flow TO lt_flow.
      ENDLOOP.
    ELSE.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
      APPEND ls_flow TO lt_flow.
      LOOP AT ls_request-pbo_modules INTO DATA(lv_pbo_module).
        IF lv_pbo_module IS NOT INITIAL.
          CLEAR ls_flow.
          ls_flow-line = lv_pbo_module.
          APPEND ls_flow TO lt_flow.
        ENDIF.
      ENDLOOP.
      CLEAR ls_flow.
      ls_flow-line = |  LOOP AT { lv_data_table } WITH CONTROL { lv_tc_name }.|.
      APPEND ls_flow TO lt_flow.
      LOOP AT ls_request-loop_pbo_modules INTO DATA(lv_loop_pbo_module).
        IF lv_loop_pbo_module IS NOT INITIAL.
          CLEAR ls_flow.
          ls_flow-line = |    { lv_loop_pbo_module }|.
          APPEND ls_flow TO lt_flow.
        ENDIF.
      ENDLOOP.
      CLEAR ls_flow.
      ls_flow-line = '  ENDLOOP.'.
      APPEND ls_flow TO lt_flow.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS AFTER INPUT.'.
      APPEND ls_flow TO lt_flow.
      CLEAR ls_flow.
      ls_flow-line = |  LOOP AT { lv_data_table }.|.
      APPEND ls_flow TO lt_flow.
      LOOP AT ls_request-loop_pai_modules INTO DATA(lv_loop_pai_module).
        IF lv_loop_pai_module IS NOT INITIAL.
          CLEAR ls_flow.
          ls_flow-line = |    { lv_loop_pai_module }|.
          APPEND ls_flow TO lt_flow.
        ENDIF.
      ENDLOOP.
      LOOP AT ls_request-columns INTO ls_column.
        CLEAR ls_flow.
        ls_flow-line = |    FIELD { lv_data_table }-{ to_upper( ls_column-field ) }.|.
        APPEND ls_flow TO lt_flow.
      ENDLOOP.
      CLEAR ls_flow.
      ls_flow-line = '  ENDLOOP.'.
      APPEND ls_flow TO lt_flow.
      LOOP AT ls_request-pai_modules INTO DATA(lv_pai_module).
        IF lv_pai_module IS NOT INITIAL.
          CLEAR ls_flow.
          ls_flow-line = lv_pai_module.
          APPEND ls_flow TO lt_flow.
        ENDIF.
      ENDLOOP.
    ENDIF.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_JSON_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT JSON import failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check JSON table_control, screen_elements, columns, and TOP include declarations' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"DYNP","program":"{ lv_program }",| &&
                |"screen":"{ lv_screen }","message":"Dynpro imported from JSON and program generated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DYNPRO_JSON_GENERATE","object_type":"DYNP",| &&
                |"program":"{ lv_program }","screen":"{ lv_screen }",| &&
                |"line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_DYNPRO_SCREEN_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_dynpro_screen_json.
    DATA ls_request TYPE ty_dynpro_custom_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA lv_ok_code TYPE string.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA ls_container LIKE LINE OF lt_containers.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA ls_field_container LIKE LINE OF lt_field_containers.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json = |\{"status":"ERROR","stage":"DYNPRO_SCREEN_JSON_PARSE","message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-screen_elements IS INITIAL.
      rv_json = '{"status":"ERROR","message":"screen_elements are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-screen NP '9+++'.
      rv_json = '{"status":"ERROR","message":"screen must be a 4-digit number starting with 9"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.
    IF ls_request-replace_existing = abap_true.
      lv_suppress_exist = 'X'.
    ENDIF.

    lv_ok_code = to_upper( ls_request-ok_code ).
    IF lv_ok_code IS INITIAL.
      lv_ok_code = 'OK_CODE'.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP generated screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    IF ls_request-next_screen IS NOT INITIAL.
      ls_header-nextscreen = ls_request-next_screen.
    ELSE.
      ls_header-nextscreen = lv_screen.
    ENDIF.
    IF ls_request-screen_lines > 0.
      ls_header-lines = ls_request-screen_lines.
    ELSE.
      ls_header-lines = '24'.
    ENDIF.
    IF ls_request-screen_columns > 0.
      ls_header-columns = ls_request-screen_columns.
    ELSE.
      ls_header-columns = '80'.
    ENDIF.

    CLEAR ls_container.
    ls_container-type = 'SCREEN'.
    ls_container-name = 'SCREEN'.
    APPEND ls_container TO lt_containers.

    LOOP AT ls_request-screen_elements INTO DATA(ls_element).
      CLEAR ls_field_container.
      ls_field_container-cont_type = 'SCREEN'.
      ls_field_container-cont_name = 'SCREEN'.
      ls_field_container-name = to_upper( ls_element-name ).
      ls_field_container-type = to_upper( ls_element-type ).
      ls_field_container-text = ls_element-text.
      ls_field_container-line = ls_element-line.
      ls_field_container-column = ls_element-column.
      ls_field_container-length = ls_element-length.
      IF ls_element-vislength > 0.
        ls_field_container-vislength = ls_element-vislength.
      ELSE.
        ls_field_container-vislength = ls_element-length.
      ENDIF.
      IF ls_element-height > 0.
        ls_field_container-height = ls_element-height.
      ELSEIF ls_field_container-type = 'FRAME'.
        ls_field_container-height = 20.
      ELSE.
        ls_field_container-height = 1.
      ENDIF.
      IF ls_element-format IS NOT INITIAL.
        ls_field_container-format = to_upper( ls_element-format ).
      ELSE.
        ls_field_container-format = 'CHAR'.
      ENDIF.
      IF ls_element-input = abap_true.
        ls_field_container-input_fld = 'X'.
      ENDIF.
      IF ls_element-output = abap_true.
        ls_field_container-output_fld = 'X'.
      ENDIF.
      IF ls_element-invisible = abap_true.
        ls_field_container-invisible = 'X'.
      ENDIF.
      IF ls_field_container-type = 'FRAME' AND ls_field_container-text IS INITIAL.
        CLEAR ls_field_container-text.
        DO ls_field_container-length TIMES.
          ls_field_container-text = ls_field_container-text && '_'.
        ENDDO.
      ENDIF.
      IF ls_field_container-type = 'PUSH'.
        ls_field_container-push_fcode = to_upper( ls_element-fcode ).
      ENDIF.
      IF ls_element-icon_name IS NOT INITIAL.
        ls_field_container-icon_name = to_upper( ls_element-icon_name ).
        ls_field_container-with_icon = 'X'.
      ENDIF.
      IF ls_element-icon_text IS NOT INITIAL.
        ls_field_container-icon_qinfo = ls_element-icon_text.
      ENDIF.
      IF ls_element-group1 IS NOT INITIAL.
        ls_field_container-group1 = to_upper( ls_element-group1 ).
      ENDIF.
      APPEND ls_field_container TO lt_field_containers.
    ENDLOOP.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = lv_ok_code.
    ls_field_container-type = 'OKCODE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '0'.
    ls_field_container-column = '0'.
    ls_field_container-length = '20'.
    ls_field_container-height = 1.
    ls_field_container-vislength = 20.
    ls_field_container-input_fld = 'X'.
    ls_field_container-format = 'CHAR'.
    APPEND ls_field_container TO lt_field_containers.

    IF ls_request-flow_logic IS NOT INITIAL.
      LOOP AT ls_request-flow_logic INTO DATA(lv_flow_line).
        CLEAR ls_flow.
        ls_flow-line = lv_flow_line.
        APPEND ls_flow TO lt_flow.
      ENDLOOP.
    ELSE.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
      APPEND ls_flow TO lt_flow.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS AFTER INPUT.'.
      APPEND ls_flow TO lt_flow.
    ENDIF.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_SCREEN_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT screen import failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check screen_elements, field coordinates, field types, and flow_logic' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"DYNP","program":"{ lv_program }","screen":"{ lv_screen }","message":"Dynpro screen imported"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DYNPRO_SCREEN_GENERATE","object_type":"DYNP","program":"{ lv_program }","screen":"{ lv_screen }","line":{ lv_line },"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }","message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_DYNPRO_CCTRL_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_dynpro_cctrl_json.
    DATA ls_request TYPE ty_dynpro_custom_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA lv_ok_code TYPE string.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA ls_container LIKE LINE OF lt_containers.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA ls_field_container LIKE LINE OF lt_field_containers.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json =
          |\{"status":"ERROR",| &&
          |"stage":"DYNPRO_CUSTOM_JSON_PARSE",| &&
          |"message":"| &&
          escape(
            val = lx_dynpro_json->get_text( )
            format = cl_abap_format=>e_json_string ) &&
          |"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json =
        '{"status":"ERROR",' &&
        '"message":"program and screen are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-custom_controls IS INITIAL.
      rv_json =
        '{"status":"ERROR","message":"custom_controls are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-screen NP '9+++'.
      rv_json =
        '{"status":"ERROR",' &&
        '"message":"screen must be a 4-digit number starting with 9"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.
    IF ls_request-replace_existing = abap_true.
      lv_suppress_exist = 'X'.
    ENDIF.

    lv_ok_code = to_upper( ls_request-ok_code ).
    IF lv_ok_code IS INITIAL.
      lv_ok_code = 'OK_CODE'.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP custom control screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    IF ls_request-next_screen IS NOT INITIAL.
      ls_header-nextscreen = ls_request-next_screen.
    ELSE.
      ls_header-nextscreen = lv_screen.
    ENDIF.
    IF ls_request-screen_lines > 0.
      ls_header-lines = ls_request-screen_lines.
    ELSE.
      ls_header-lines = '24'.
    ENDIF.
    IF ls_request-screen_columns > 0.
      ls_header-columns = ls_request-screen_columns.
    ELSE.
      ls_header-columns = '80'.
    ENDIF.

    CLEAR ls_container.
    ls_container-type = 'SCREEN'.
    ls_container-name = 'SCREEN'.
    APPEND ls_container TO lt_containers.

    LOOP AT ls_request-custom_controls INTO DATA(ls_custom_control).
      IF ls_custom_control-name IS INITIAL.
        rv_json =
          '{"status":"ERROR",' &&
          '"message":"custom control name is required"}'.
        RETURN.
      ENDIF.

      CLEAR ls_container.
      ls_container-type = 'CUST_CTRL'.
      ls_container-name = to_upper( ls_custom_control-name ).
      ls_container-element_of = 'SCREEN'.
      ls_container-line = ls_custom_control-line.
      ls_container-column = ls_custom_control-column.
      ls_container-length = ls_custom_control-length.
      ls_container-height = ls_custom_control-height.
      IF ls_container-line <= 0.
        ls_container-line = 3.
      ENDIF.
      IF ls_container-column <= 0.
        ls_container-column = 1.
      ENDIF.
      IF ls_container-length <= 0.
        ls_container-length = 60.
      ENDIF.
      IF ls_container-height <= 0.
        ls_container-height = 8.
      ENDIF.
      IF ls_custom_control-resize_v = abap_true.
        ls_container-c_resize_v = 'X'.
      ENDIF.
      IF ls_custom_control-resize_h = abap_true.
        ls_container-c_resize_h = 'X'.
      ENDIF.
      APPEND ls_container TO lt_containers.
    ENDLOOP.

    LOOP AT ls_request-screen_elements INTO DATA(ls_element).
      CLEAR ls_field_container.
      ls_field_container-cont_type = 'SCREEN'.
      ls_field_container-cont_name = 'SCREEN'.
      ls_field_container-name = to_upper( ls_element-name ).
      ls_field_container-type = to_upper( ls_element-type ).
      ls_field_container-text = ls_element-text.
      ls_field_container-line = ls_element-line.
      ls_field_container-column = ls_element-column.
      ls_field_container-length = ls_element-length.
      IF ls_element-vislength > 0.
        ls_field_container-vislength = ls_element-vislength.
      ELSE.
        ls_field_container-vislength = ls_element-length.
      ENDIF.
      IF ls_element-height > 0.
        ls_field_container-height = ls_element-height.
      ELSEIF ls_field_container-type = 'FRAME'.
        ls_field_container-height = 20.
      ELSE.
        ls_field_container-height = 1.
      ENDIF.
      IF ls_element-format IS NOT INITIAL.
        ls_field_container-format = to_upper( ls_element-format ).
      ELSE.
        ls_field_container-format = 'CHAR'.
      ENDIF.
      IF ls_element-input = abap_true.
        ls_field_container-input_fld = 'X'.
      ENDIF.
      IF ls_element-output = abap_true.
        ls_field_container-output_fld = 'X'.
      ENDIF.
      IF ls_element-invisible = abap_true.
        ls_field_container-invisible = 'X'.
      ENDIF.
      IF ls_field_container-type = 'FRAME' AND
         ls_field_container-text IS INITIAL.
        CLEAR ls_field_container-text.
        DO ls_field_container-length TIMES.
          ls_field_container-text = ls_field_container-text && '_'.
        ENDDO.
      ENDIF.
      IF ls_field_container-type = 'PUSH'.
        ls_field_container-push_fcode = to_upper( ls_element-fcode ).
      ENDIF.
      IF ls_element-icon_name IS NOT INITIAL.
        ls_field_container-icon_name = to_upper( ls_element-icon_name ).
        ls_field_container-with_icon = 'X'.
      ENDIF.
      IF ls_element-icon_text IS NOT INITIAL.
        ls_field_container-icon_qinfo = ls_element-icon_text.
      ENDIF.
      IF ls_element-group1 IS NOT INITIAL.
        ls_field_container-group1 = to_upper( ls_element-group1 ).
      ENDIF.
      APPEND ls_field_container TO lt_field_containers.
    ENDLOOP.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = lv_ok_code.
    ls_field_container-type = 'OKCODE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '0'.
    ls_field_container-column = '0'.
    ls_field_container-length = '20'.
    ls_field_container-height = 1.
    ls_field_container-vislength = 20.
    ls_field_container-input_fld = 'X'.
    ls_field_container-format = 'CHAR'.
    APPEND ls_field_container TO lt_field_containers.

    IF ls_request-flow_logic IS NOT INITIAL.
      LOOP AT ls_request-flow_logic INTO DATA(lv_flow_line).
        CLEAR ls_flow.
        ls_flow-line = lv_flow_line.
        APPEND ls_flow TO lt_flow.
      ENDLOOP.
    ELSE.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
      APPEND ls_flow TO lt_flow.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS AFTER INPUT.'.
      APPEND ls_flow TO lt_flow.
    ENDIF.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_CUSTOM_CONTROL_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT custom import failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check custom_controls and coordinates' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json =
        |\{"status":"OK","object_type":"DYNP",| &&
        |"program":"{ lv_program }",| &&
        |"screen":"{ lv_screen }",| &&
        |"message":"Dynpro custom controls imported"\}|.
    ELSE.
      rv_json =
        |\{"status":"ERROR",| &&
        |"stage":"DYNPRO_CUSTOM_CONTROL_GENERATE",| &&
        |"object_type":"DYNP",| &&
        |"program":"{ lv_program }",| &&
        |"screen":"{ lv_screen }",| &&
                |"line":{ lv_line },| &&
        |"word":"| &&
        escape(
          val = lv_word
          format = cl_abap_format=>e_json_string ) &&
        |",| &&
        |"message":"| &&
        escape(
          val = lv_message
          format = cl_abap_format=>e_json_string ) &&
        |"\}|.
    ENDIF.
  ENDMETHOD.



* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_DYNPRO_LAYOUT_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_dynpro_layout_json.
    DATA ls_request TYPE ty_dynpro_layout_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA lv_ok_code TYPE string.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA ls_container LIKE LINE OF lt_containers.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA ls_field_container LIKE LINE OF lt_field_containers.
    DATA lv_container_name TYPE string.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.
    FIELD-SYMBOLS <lv_selected> TYPE any.
    FIELD-SYMBOLS <lv_ref_field> TYPE any.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json =
          |\{"status":"ERROR","stage":"DYNPRO_LAYOUT_JSON_PARSE",| &&
          |"message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.
    IF ls_request-screen NP '9+++'.
      rv_json = '{"status":"ERROR","message":"screen must be a 4-digit number starting with 9"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.
    IF ls_request-replace_existing = abap_true.
      lv_suppress_exist = 'X'.
    ENDIF.

    lv_ok_code = to_upper( ls_request-ok_code ).
    IF lv_ok_code IS INITIAL.
      lv_ok_code = 'OK_CODE'.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP layout screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    IF ls_request-next_screen IS NOT INITIAL.
      ls_header-nextscreen = ls_request-next_screen.
    ELSE.
      ls_header-nextscreen = lv_screen.
    ENDIF.
    IF ls_request-screen_lines > 0.
      ls_header-lines = ls_request-screen_lines.
    ELSE.
      ls_header-lines = '24'.
    ENDIF.
    IF ls_request-screen_columns > 0.
      ls_header-columns = ls_request-screen_columns.
    ELSE.
      ls_header-columns = '80'.
    ENDIF.

    CLEAR ls_container.
    ls_container-type = 'SCREEN'.
    ls_container-name = 'SCREEN'.
    APPEND ls_container TO lt_containers.

    LOOP AT ls_request-containers INTO DATA(ls_req_container).
      IF ls_req_container-name IS INITIAL OR ls_req_container-type IS INITIAL.
        rv_json = '{"status":"ERROR","message":"container name and type are required"}'.
        RETURN.
      ENDIF.

      CLEAR ls_container.
      ls_container-type = to_upper( ls_req_container-type ).
      ls_container-name = to_upper( ls_req_container-name ).
      IF ls_req_container-element_of IS INITIAL.
        ls_container-element_of = 'SCREEN'.
      ELSE.
        ls_container-element_of = to_upper( ls_req_container-element_of ).
      ENDIF.
      ls_container-line = ls_req_container-line.
      ls_container-column = ls_req_container-column.
      ls_container-length = ls_req_container-length.
      ls_container-height = ls_req_container-height.
      IF ls_req_container-resize_v = abap_true.
        ls_container-c_resize_v = 'X'.
      ENDIF.
      IF ls_req_container-resize_h = abap_true.
        ls_container-c_resize_h = 'X'.
      ENDIF.
      IF ls_req_container-scroll_v = abap_true.
        ls_container-c_scroll_v = 'X'.
      ENDIF.
      IF ls_req_container-scroll_h = abap_true.
        ls_container-c_scroll_h = 'X'.
      ENDIF.
      IF ls_req_container-line_min > 0.
        ls_container-c_line_min = ls_req_container-line_min.
      ENDIF.
      IF ls_req_container-column_min > 0.
        ls_container-c_coln_min = ls_req_container-column_min.
      ENDIF.
      IF ls_req_container-table_type IS NOT INITIAL.
        ls_container-tc_tabtype = to_upper( ls_req_container-table_type ).
      ENDIF.
      IF ls_req_container-table_header = abap_true.
        ls_container-tc_header = 'X'.
      ENDIF.
      IF ls_req_container-table_config = abap_true.
        ls_container-tc_config = 'X'.
      ENDIF.
      IF ls_req_container-select_lines IS NOT INITIAL.
        ls_container-tc_sel_lns = to_upper( ls_req_container-select_lines ).
      ENDIF.
      IF ls_req_container-select_columns IS NOT INITIAL.
        ls_container-tc_sel_cls = to_upper( ls_req_container-select_columns ).
      ENDIF.
      IF ls_req_container-line_selector = abap_true.
        ls_container-tc_lsel_cl = 'X'.
      ENDIF.
      IF ls_req_container-fixed_columns > 0.
        ls_container-tc_fixcol = ls_req_container-fixed_columns.
      ENDIF.
      APPEND ls_container TO lt_containers.
    ENDLOOP.

    LOOP AT ls_request-screen_elements INTO DATA(ls_element).
      CLEAR ls_field_container.
      lv_container_name = to_upper( ls_element-container ).
      IF lv_container_name IS INITIAL.
        lv_container_name = 'SCREEN'.
      ENDIF.
      READ TABLE lt_containers TRANSPORTING NO FIELDS
        WITH KEY name = lv_container_name.
      IF sy-subrc <> 0.
        rv_json =
          |\{"status":"ERROR","message":"unknown field container { lv_container_name }"\}|.
        RETURN.
      ENDIF.

      ls_field_container-cont_name = lv_container_name.
      IF lv_container_name = 'SCREEN'.
        ls_field_container-cont_type = 'SCREEN'.
      ELSE.
        READ TABLE lt_containers INTO DATA(ls_field_parent)
          WITH KEY name = lv_container_name.
        ls_field_container-cont_type = ls_field_parent-type.
      ENDIF.
      ls_field_container-name = to_upper( ls_element-name ).
      ls_field_container-type = to_upper( ls_element-type ).
      ls_field_container-text = ls_element-text.
      ls_field_container-line = ls_element-line.
      ls_field_container-column = ls_element-column.
      ls_field_container-length = ls_element-length.
      IF ls_element-vislength > 0.
        ls_field_container-vislength = ls_element-vislength.
      ELSE.
        ls_field_container-vislength = ls_element-length.
      ENDIF.
      IF ls_element-height > 0.
        ls_field_container-height = ls_element-height.
      ELSEIF ls_field_container-type = 'FRAME'.
        ls_field_container-height = 20.
      ELSE.
        ls_field_container-height = 1.
      ENDIF.
      IF ls_element-format IS NOT INITIAL.
        ls_field_container-format = to_upper( ls_element-format ).
      ELSE.
        ls_field_container-format = 'CHAR'.
      ENDIF.
      IF ls_element-input = abap_true.
        ls_field_container-input_fld = 'X'.
      ENDIF.
      IF ls_element-output = abap_true.
        ls_field_container-output_fld = 'X'.
      ENDIF.
      IF ls_element-invisible = abap_true.
        ls_field_container-invisible = 'X'.
      ENDIF.
      IF ls_element-selected = abap_true.
        ASSIGN COMPONENT 'SELECTED'
          OF STRUCTURE ls_field_container TO <lv_selected>.
        IF <lv_selected> IS ASSIGNED.
          <lv_selected> = 'X'.
        ENDIF.
      ENDIF.
      IF ls_field_container-type = 'FRAME' AND ls_field_container-text IS INITIAL.
        CLEAR ls_field_container-text.
        DO ls_field_container-length TIMES.
          ls_field_container-text = ls_field_container-text && '_'.
        ENDDO.
      ENDIF.
      IF ls_field_container-type = 'PUSH'.
        ls_field_container-push_fcode = to_upper( ls_element-fcode ).
      ENDIF.
      IF ls_element-ref_field IS NOT INITIAL.
        ASSIGN COMPONENT 'REF_FIELD'
          OF STRUCTURE ls_field_container TO <lv_ref_field>.
        IF <lv_ref_field> IS ASSIGNED.
          <lv_ref_field> = to_upper( ls_element-ref_field ).
        ENDIF.
      ENDIF.
      IF ls_element-icon_name IS NOT INITIAL.
        ls_field_container-icon_name = to_upper( ls_element-icon_name ).
        ls_field_container-with_icon = 'X'.
      ENDIF.
      IF ls_element-icon_text IS NOT INITIAL.
        ls_field_container-icon_qinfo = ls_element-icon_text.
      ENDIF.
      IF ls_element-group1 IS NOT INITIAL.
        ls_field_container-group1 = to_upper( ls_element-group1 ).
      ENDIF.
      APPEND ls_field_container TO lt_field_containers.
    ENDLOOP.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = lv_ok_code.
    ls_field_container-type = 'OKCODE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '0'.
    ls_field_container-column = '0'.
    ls_field_container-length = '20'.
    ls_field_container-height = 1.
    ls_field_container-vislength = 20.
    ls_field_container-input_fld = 'X'.
    ls_field_container-format = 'CHAR'.
    APPEND ls_field_container TO lt_field_containers.

    IF ls_request-flow_logic IS NOT INITIAL.
      LOOP AT ls_request-flow_logic INTO DATA(lv_flow_line).
        CLEAR ls_flow.
        ls_flow-line = lv_flow_line.
        APPEND ls_flow TO lt_flow.
      ENDLOOP.
    ELSE.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
      APPEND ls_flow TO lt_flow.
      CLEAR ls_flow.
      ls_flow-line = 'PROCESS AFTER INPUT.'.
      APPEND ls_flow TO lt_flow.
    ENDIF.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_LAYOUT_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT layout import failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check containers, screen_elements, coordinates, and flow_logic' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json =
        |\{"status":"OK","object_type":"DYNP","program":"{ lv_program }",| &&
        |"screen":"{ lv_screen }","message":"Dynpro layout imported"\}|.
    ELSE.
      rv_json =
        |\{"status":"ERROR","stage":"DYNPRO_LAYOUT_GENERATE",| &&
        |"object_type":"DYNP","program":"{ lv_program }","screen":"{ lv_screen }",| &&
        |"line":{ lv_line },"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
        |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.



* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_MIN_DYNPRO_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_min_dynpro_json.
    DATA ls_request TYPE ty_dynpro_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json = |\{"status":"ERROR","stage":"DYNPRO_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP minimal screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    ls_header-nextscreen = lv_screen.
    ls_header-lines = '24'.
    ls_header-columns = '80'.

    CLEAR ls_flow.
    ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = 'PROCESS AFTER INPUT.'.
    APPEND ls_flow TO lt_flow.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check program, screen number, RPY_DYHEAD header values, flow logic, authorization, and whether the function group exists' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"DYNP","program":"{ lv_program }",| &&
                |"screen":"{ lv_screen }","message":"Minimal dynpro imported and program generated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DYNPRO_GENERATE","object_type":"DYNP",| &&
                |"program":"{ lv_program }","screen":"{ lv_screen }",| &&
                |"line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IMPORT_TC_MIN_DYNPRO_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD import_tc_min_dynpro_json.
    DATA ls_request TYPE ty_dynpro_request.
    DATA lv_program TYPE d020s-prog.
    DATA lv_screen TYPE d020s-dnum.
    DATA lv_language TYPE d020s-spra.
    DATA lv_corrnum TYPE e071-trkorr.
    DATA ls_header TYPE rpy_dyhead.
    DATA lt_flow TYPE STANDARD TABLE OF rpy_dyflow.
    DATA ls_flow TYPE rpy_dyflow.
    DATA lt_params TYPE STANDARD TABLE OF rpy_dypara.
    DATA lt_containers TYPE dycatt_tab.
    DATA ls_container LIKE LINE OF lt_containers.
    DATA lt_field_containers TYPE dyfatc_tab.
    DATA ls_field_container LIKE LINE OF lt_field_containers.
    DATA lv_suppress_corr TYPE c LENGTH 1 VALUE 'X'.
    DATA lv_suppress_exist TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_generate TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_dict TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_extended TYPE c LENGTH 1 VALUE space.
    DATA lv_use_corrnum TYPE c LENGTH 1 VALUE space.
    DATA lv_suppress_commit TYPE c LENGTH 1 VALUE space.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_dynpro_json).
        rv_json = |\{"status":"ERROR","stage":"DYNPRO_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_dynpro_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-program IS INITIAL OR ls_request-screen IS INITIAL.
      rv_json = '{"status":"ERROR","message":"program and screen are required"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-program ).
    lv_screen = ls_request-screen.
    lv_language = ls_request-language.
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.
    IF strlen( ls_request-request ) > 3.
      lv_corrnum = to_upper( ls_request-request ).
      lv_use_corrnum = 'X'.
    ENDIF.

    CLEAR ls_header.
    ls_header-program = lv_program.
    ls_header-screen = lv_screen.
    ls_header-language = lv_language.
    IF ls_request-description IS INITIAL.
      ls_header-descript = |AI_MCP table control screen { lv_screen }|.
    ELSE.
      ls_header-descript = ls_request-description.
    ENDIF.
    ls_header-type = to_upper( ls_request-screen_type ).
    IF ls_header-type <> 'I' AND ls_header-type <> 'N'.
      ls_header-type = 'N'.
    ENDIF.
    ls_header-nextscreen = lv_screen.
    ls_header-lines = '24'.
    ls_header-columns = '80'.

    CLEAR ls_container.
    ls_container-type = 'SCREEN'.
    ls_container-name = 'SCREEN'.
    APPEND ls_container TO lt_containers.

    CLEAR ls_container.
    ls_container-type = 'TABLE_CTRL'.
    ls_container-name = 'ZTC_AI_MCP'.
    ls_container-element_of = 'SCREEN'.
    ls_container-line = '3'.
    ls_container-column = '1'.
    ls_container-length = '60'.
    ls_container-height = '8'.
    ls_container-tc_header = 'X'.
    APPEND ls_container TO lt_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = '%#AUTOTEXT001'.
    ls_field_container-type = 'FRAME'.
    ls_field_container-text = '____________________________________________________________'.
    ls_field_container-line = '1'.
    ls_field_container-column = '1'.
    ls_field_container-length = '70'.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = 'ZTC_AI_MCP_INSERT'.
    ls_field_container-type = 'PUSH'.
    ls_field_container-text = 'Insert'.
    ls_field_container-line = '2'.
    ls_field_container-column = '4'.
    ls_field_container-length = '27'.
    ls_field_container-push_fcode = 'INSR'.
    ls_field_container-push_ftype = ' '.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = 'ZTC_AI_MCP_DELETE'.
    ls_field_container-type = 'PUSH'.
    ls_field_container-text = 'Delete'.
    ls_field_container-line = '2'.
    ls_field_container-column = '8'.
    ls_field_container-length = '4'.
    ls_field_container-push_fcode = 'DELE'.
    ls_field_container-push_ftype = ' '.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'SCREEN'.
    ls_field_container-cont_name = 'SCREEN'.
    ls_field_container-name = 'OK_CODE'.
    ls_field_container-type = 'OKCODE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '0'.
    ls_field_container-column = '0'.
    ls_field_container-length = '20'.
    ls_field_container-height = 1.
    ls_field_container-vislength = 20.
    ls_field_container-input_fld = 'X'.
    ls_field_container-format = 'CHAR'.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'TABLE_CTRL'.
    ls_field_container-cont_name = 'ZTC_AI_MCP'.
    ls_field_container-name = 'GT_AI_MCP-COL1'.
    ls_field_container-type = 'TEMPLATE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '1'.
    ls_field_container-column = '1'.
    ls_field_container-length = '20'.
    ls_field_container-vislength = '20'.
    ls_field_container-input_fld = 'X'.
    ls_field_container-output_fld = 'X'.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_field_container.
    ls_field_container-cont_type = 'TABLE_CTRL'.
    ls_field_container-cont_name = 'ZTC_AI_MCP'.
    ls_field_container-name = 'GT_AI_MCP-COL2'.
    ls_field_container-type = 'TEMPLATE'.
    ls_field_container-text = '____________________'.
    ls_field_container-line = '1'.
    ls_field_container-column = '25'.
    ls_field_container-length = '20'.
    ls_field_container-vislength = '20'.
    ls_field_container-input_fld = 'X'.
    ls_field_container-output_fld = 'X'.
    APPEND ls_field_container TO lt_field_containers.

    CLEAR ls_flow.
    ls_flow-line = 'PROCESS BEFORE OUTPUT.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '  LOOP AT GT_AI_MCP WITH CONTROL ZTC_AI_MCP CURSOR ZTC_AI_MCP-CURRENT_LINE.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '  ENDLOOP.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = 'PROCESS AFTER INPUT.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '  LOOP AT GT_AI_MCP.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '    FIELD GT_AI_MCP-COL1.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '    FIELD GT_AI_MCP-COL2.'.
    APPEND ls_flow TO lt_flow.
    CLEAR ls_flow.
    ls_flow-line = '  ENDLOOP.'.
    APPEND ls_flow TO lt_flow.

    CALL FUNCTION 'RPY_DYNPRO_INSERT'
      EXPORTING
        header                    = ls_header
        corrnum                   = lv_corrnum
        suppress_corr_checks      = lv_suppress_corr
        suppress_exist_checks     = lv_suppress_exist
        suppress_generate         = lv_suppress_generate
        suppress_dict_support     = lv_suppress_dict
        suppress_extended_checks  = lv_suppress_extended
        use_corrnum_immediatedly  = lv_use_corrnum
        suppress_commit_work      = lv_suppress_commit
      TABLES
        flow_logic                = lt_flow
        params                    = lt_params
        containers                = lt_containers
        fields_to_containers      = lt_field_containers
      EXCEPTIONS
        cancelled                 = 1
        already_exists            = 2
        program_not_exists        = 3
        not_executed              = 4
        missing_required_field    = 5
        illegal_field_value       = 6
        field_not_allowed         = 7
        not_generated             = 8
        illegal_field_position    = 9
        OTHERS                    = 10.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'DYNPRO_TC_IMPORT'
        iv_object_type = 'DYNP'
        iv_object_name = |{ lv_program } { lv_screen }|
        iv_message     = 'RPY_DYNPRO_INSERT table control PoC failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check RPY_DYHEAD, DYCATT_TAB, DYFATC_TAB field values and required table control include declarations' ).
      RETURN.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"DYNP","program":"{ lv_program }",| &&
                |"screen":"{ lv_screen }","message":"Minimal table control dynpro imported and program generated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"DYNPRO_TC_GENERATE","object_type":"DYNP",| &&
                |"program":"{ lv_program }","screen":"{ lv_screen }",| &&
                |"line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->IS_Z_OBJECT_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        CSEQUENCE
* | [<-()] RV_VALID                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_z_object_name.
    DATA lv_name TYPE string.

    lv_name = to_upper( iv_name ).
    rv_valid = xsdbool( lv_name CP 'Z*' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->LOCKS_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD locks_from_json.
    DATA ls_request TYPE ty_lock_request.
    DATA lt_locks TYPE STANDARD TABLE OF seqg3 WITH EMPTY KEY.
    DATA lv_locks TYPE string VALUE '['.
    DATA lv_object_name TYPE string.
    DATA lv_number TYPE sy-tabix.
    DATA lv_subrc TYPE sy-subrc.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-object_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"object_name is required"}'.
      RETURN.
    ENDIF.

    lv_object_name = to_upper( ls_request-object_name ).

    CALL FUNCTION 'ENQUEUE_READ'
      IMPORTING
        number = lv_number
        subrc  = lv_subrc
      TABLES
        enq    = lt_locks
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'ENQUEUE_READ'
        iv_object_type = 'LOCK'
        iv_object_name = lv_object_name
        iv_message     = 'ENQUEUE_READ failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check enqueue server availability and authorization' ).
      RETURN.
    ENDIF.

    LOOP AT lt_locks INTO DATA(ls_lock)
      WHERE garg CS lv_object_name.
      IF lv_locks <> '['.
        lv_locks = lv_locks && ','.
      ENDIF.
      lv_locks = lv_locks &&
        |\{"gname":"{ escape( val = ls_lock-gname format = cl_abap_format=>e_json_string ) }",| &&
        |"garg":"{ escape( val = ls_lock-garg format = cl_abap_format=>e_json_string ) }",| &&
        |"guname":"{ escape( val = ls_lock-guname format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.

    lv_locks = lv_locks && ']'.
    rv_json = |\{"status":"OK","object_name":"{ lv_object_name }","lock_count":{ lv_number },"subrc":{ lv_subrc },"locks":{ lv_locks }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->MESSAGE_SAVE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD message_save_from_json.
    TYPES: BEGIN OF ty_message_work,
             requested_number TYPE string,
             number           TYPE string,
             text             TYPE string,
           END OF ty_message_work.
    TYPES tt_message_work TYPE STANDARD TABLE OF ty_message_work WITH EMPTY KEY.

    DATA ls_request TYPE ty_message_save_request.
    DATA ls_message_work TYPE ty_message_work.
    DATA ls_previous_message TYPE ty_message_work.
    DATA lt_message_work TYPE tt_message_work.
    DATA lt_message_check TYPE tt_message_work.
    DATA lv_message_class TYPE arbgb.
    DATA lv_language TYPE spras.
    DATA lv_transport TYPE trkorr.
    DATA lv_msgnr TYPE symsgno.
    DATA lv_number TYPE string.
    DATA lv_requested_number TYPE string.
    DATA lv_text TYPE string.
    DATA lv_t100_text TYPE t100-text.
    DATA lv_max_msgnr TYPE t100-msgnr.
    DATA lv_next_msgnr_i TYPE i.
    DATA lv_next_msgnr_n TYPE n LENGTH 3.
    DATA lv_prev_index TYPE sy-tabix.
    DATA lv_results_json TYPE string VALUE '['.
    DATA lv_bdc_json TYPE string VALUE '['.
    DATA lv_cts_json TYPE string VALUE 'null'.
    DATA lv_has_error TYPE abap_bool.
    DATA lv_message_found TYPE abap_bool.
    DATA lt_bdcdata TYPE tt_bdcdata.
    DATA lt_bdcmsg TYPE STANDARD TABLE OF bdcmsgcoll.
    DATA ls_ctu TYPE ctu_params.
    DATA lv_subrc TYPE sy-subrc.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_message_json).
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_message_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_message_class = to_upper( ls_request-message_class ).
    lv_language = to_upper( ls_request-language ).
    lv_transport = to_upper( ls_request-transport ).
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.

    IF lv_message_class IS INITIAL OR ls_request-messages IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"MESSAGE_VALIDATE","message":"message_class and messages are required"}'.
      RETURN.
    ENDIF.

    IF is_z_object_name( lv_message_class ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"MESSAGE_CLASS_VALIDATE",| &&
                |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"Only Z* message classes can be changed through this API"\}|.
      RETURN.
    ENDIF.

    SELECT SINGLE arbgb
      FROM t100a
      INTO @DATA(lv_existing_msg_class)
      WHERE arbgb = @lv_message_class.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"MESSAGE_CLASS_VALIDATE",| &&
                |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"message_class must already exist; this endpoint does not create message classes"\}|.
      RETURN.
    ENDIF.

    LOOP AT ls_request-messages INTO DATA(ls_message_check).
      lv_requested_number = to_upper( ls_message_check-number ).
      CONDENSE lv_requested_number NO-GAPS.
      lv_text = ls_message_check-text.

      IF lv_text IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_VALIDATE",| &&
                  |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                  |"requested_number":"{ escape( val = lv_requested_number format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"message text is required"\}|.
        RETURN.
      ENDIF.
      IF strlen( lv_text ) > 73.
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_VALIDATE",| &&
                  |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                  |"requested_number":"{ escape( val = lv_requested_number format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"message text exceeds T100-TEXT length 73"\}|.
        RETURN.
      ENDIF.

      CLEAR ls_message_work.
      ls_message_work-requested_number = lv_requested_number.
      ls_message_work-text = lv_text.
      IF lv_requested_number = 'AUTO'.
        APPEND ls_message_work TO lt_message_work.
      ELSEIF lv_requested_number CN '0123456789' OR strlen( lv_requested_number ) <> 3.
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_VALIDATE",| &&
                  |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                  |"number":"{ escape( val = ls_message_check-number format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"message number must be AUTO or three digits from 000 to 999"\}|.
        RETURN.
      ELSE.
        ls_message_work-number = lv_requested_number.
        APPEND ls_message_work TO lt_message_work.
      ENDIF.
    ENDLOOP.

    SELECT MAX( msgnr )
      FROM t100
      INTO @lv_max_msgnr
      WHERE sprsl = @lv_language
        AND arbgb = @lv_message_class
        AND msgnr BETWEEN '001' AND '999'.
    IF lv_max_msgnr IS INITIAL.
      lv_next_msgnr_i = 1.
    ELSE.
      lv_next_msgnr_i = lv_max_msgnr.
      lv_next_msgnr_i = lv_next_msgnr_i + 1.
    ENDIF.

    LOOP AT lt_message_work INTO ls_message_work WHERE requested_number = 'AUTO'.
      IF lv_next_msgnr_i > 999.
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_NUMBER_RANGE_FULL",| &&
                  |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                  |"language":"{ lv_language }",| &&
                  |"message":"No free automatic message number remains in range 001-999"\}|.
        RETURN.
      ENDIF.
      lv_next_msgnr_n = lv_next_msgnr_i.
      ls_message_work-number = lv_next_msgnr_n.
      MODIFY lt_message_work FROM ls_message_work INDEX sy-tabix.
      lv_next_msgnr_i = lv_next_msgnr_i + 1.
    ENDLOOP.

    lt_message_check = lt_message_work.
    SORT lt_message_check BY number.
    LOOP AT lt_message_check INTO ls_message_work.
      IF sy-tabix > 1.
        lv_prev_index = sy-tabix - 1.
        READ TABLE lt_message_check INDEX lv_prev_index INTO ls_previous_message.
        IF sy-subrc = 0 AND ls_previous_message-number = ls_message_work-number.
          rv_json = |\{"status":"ERROR","stage":"MESSAGE_VALIDATE",| &&
                    |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                    |"number":"{ ls_message_work-number }",| &&
                    |"message":"Duplicate message number in request after AUTO allocation"\}|.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_transport IS NOT INITIAL.
      lv_cts_json = append_cts_object(
        iv_object_type = 'MSAG'
        iv_object_name = lv_message_class
        iv_transport   = lv_transport ).
      IF lv_cts_json CS '"status":"ERROR"'.
        rv_json = lv_cts_json.
        RETURN.
      ENDIF.
    ENDIF.

    ls_ctu-dismode = 'N'.
    ls_ctu-updmode = 'S'.
    ls_ctu-defsize = abap_true.

    LOOP AT lt_message_work INTO DATA(ls_message).
      lv_number = ls_message-number.
      lv_requested_number = ls_message-requested_number.
      lv_msgnr = lv_number.
      lv_text = ls_message-text.
      CLEAR lt_bdcdata.
      CLEAR lt_bdcmsg.

      append_bdc_field(
        EXPORTING iv_program = 'SAPLWBMESSAGES' iv_dynpro = '0100' iv_dynbegin = abap_true
        CHANGING  ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'RSDAG-ARBGB' iv_fval = lv_message_class CHANGING ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'RSDAG-MSGFLAG' iv_fval = 'X' CHANGING ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'MSG_NUMMER' iv_fval = lv_number CHANGING ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'BDC_OKCODE' iv_fval = '=WB_EDIT' CHANGING ct_bdcdata = lt_bdcdata ).

      append_bdc_field(
        EXPORTING iv_program = 'SAPLWBMESSAGES' iv_dynpro = '1000' iv_dynbegin = abap_true
        CHANGING  ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'T100-TEXT(01)' iv_fval = lv_text CHANGING ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'BDC_OKCODE' iv_fval = '=WB_SAVE' CHANGING ct_bdcdata = lt_bdcdata ).

      append_bdc_field(
        EXPORTING iv_program = 'SAPLWBMESSAGES' iv_dynpro = '1000' iv_dynbegin = abap_true
        CHANGING  ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'BDC_OKCODE' iv_fval = '=WB_BACK' CHANGING ct_bdcdata = lt_bdcdata ).

      append_bdc_field(
        EXPORTING iv_program = 'SAPLWBMESSAGES' iv_dynpro = '0100' iv_dynbegin = abap_true
        CHANGING  ct_bdcdata = lt_bdcdata ).
      append_bdc_field( EXPORTING iv_fnam = 'BDC_OKCODE' iv_fval = '=WB_END' CHANGING ct_bdcdata = lt_bdcdata ).

      CALL TRANSACTION 'SE91'
        USING lt_bdcdata
        OPTIONS FROM ls_ctu
        MESSAGES INTO lt_bdcmsg.
      lv_subrc = sy-subrc.

      LOOP AT lt_bdcmsg INTO DATA(ls_bdcmsg).
        IF lv_bdc_json <> '['.
          lv_bdc_json = lv_bdc_json && ','.
        ENDIF.
        lv_bdc_json = lv_bdc_json &&
          |\{"requested_number":"{ escape( val = lv_requested_number format = cl_abap_format=>e_json_string ) }",| &&
          |"number":"{ lv_msgnr }",| &&
          |"program":"{ escape( val = ls_bdcmsg-dyname format = cl_abap_format=>e_json_string ) }",| &&
          |"dynpro":"{ ls_bdcmsg-dynumb }",| &&
          |"msgtyp":"{ ls_bdcmsg-msgtyp }","msgid":"{ ls_bdcmsg-msgid }","msgnr":"{ ls_bdcmsg-msgnr }",| &&
          |"msgv1":"{ escape( val = ls_bdcmsg-msgv1 format = cl_abap_format=>e_json_string ) }",| &&
          |"msgv2":"{ escape( val = ls_bdcmsg-msgv2 format = cl_abap_format=>e_json_string ) }",| &&
          |"msgv3":"{ escape( val = ls_bdcmsg-msgv3 format = cl_abap_format=>e_json_string ) }",| &&
          |"msgv4":"{ escape( val = ls_bdcmsg-msgv4 format = cl_abap_format=>e_json_string ) }"\}|.
      ENDLOOP.

      IF lv_subrc <> 0.
        lv_bdc_json = lv_bdc_json && ']'.
        rv_json = |\{"status":"ERROR","stage":"MESSAGE_SAVE_BDC",| &&
                  |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
                  |"language":"{ lv_language }",| &&
                  |"requested_number":"{ escape( val = lv_requested_number format = cl_abap_format=>e_json_string ) }",| &&
                  |"number":"{ lv_msgnr }","subrc":{ lv_subrc },| &&
                  |"message":"SE91 BDC returned a non-zero subrc",| &&
                  |"bdc_messages":{ lv_bdc_json }\}|.
        RETURN.
      ENDIF.
    ENDLOOP.
    lv_bdc_json = lv_bdc_json && ']'.

    LOOP AT lt_message_work INTO DATA(ls_message_verify).
      lv_number = ls_message_verify-number.
      lv_requested_number = ls_message_verify-requested_number.
      lv_msgnr = lv_number.
      lv_text = ls_message_verify-text.
      CLEAR lv_t100_text.
      SELECT SINGLE text
        FROM t100
        INTO lv_t100_text
        WHERE sprsl = lv_language
          AND arbgb = lv_message_class
          AND msgnr = lv_msgnr.
      lv_message_found = xsdbool( sy-subrc = 0 AND lv_t100_text = lv_text ).
      IF lv_message_found = abap_false.
        lv_has_error = abap_true.
      ENDIF.
      IF lv_results_json <> '['.
        lv_results_json = lv_results_json && ','.
      ENDIF.
      lv_results_json = lv_results_json &&
        |\{"requested_number":"{ escape( val = lv_requested_number format = cl_abap_format=>e_json_string ) }",| &&
        |"number":"{ lv_msgnr }",| &&
        |"status":"{ COND string( WHEN lv_message_found = abap_true THEN 'OK' ELSE 'ERROR' ) }",| &&
        |"expected_text":"{ escape( val = lv_text format = cl_abap_format=>e_json_string ) }",| &&
        |"actual_text":"{ escape( val = lv_t100_text format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.
    lv_results_json = lv_results_json && ']'.

    rv_json = |\{"status":"{ COND string( WHEN lv_has_error = abap_true THEN 'ERROR' ELSE 'OK' ) }",| &&
              |"stage":"MESSAGE_SAVE",| &&
              |"message_class":"{ escape( val = lv_message_class format = cl_abap_format=>e_json_string ) }",| &&
              |"language":"{ lv_language }",| &&
              |"transport":"{ escape( val = lv_transport format = cl_abap_format=>e_json_string ) }",| &&
              |"cts":{ lv_cts_json },| &&
              |"results":{ lv_results_json },| &&
              |"bdc_messages":{ lv_bdc_json }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->OBJECT_LIFECYCLE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD object_lifecycle_from_json.
    DATA ls_request TYPE ty_lifecycle_request.
    DATA lv_object_type TYPE string.
    DATA lv_mode TYPE string.
    DATA lv_max_rounds TYPE i.
    DATA lv_round TYPE i.
    DATA lv_save_json TYPE string.
    DATA lv_check_json TYPE string.
    DATA lv_repair_json TYPE string.
    DATA lv_activate_json TYPE string.
    DATA lv_verify_json TYPE string.
    DATA lv_final_status TYPE string VALUE 'ERROR'.
    DATA lv_step_status TYPE string.
    DATA lv_steps TYPE string VALUE '['.
    DATA lv_step TYPE string.
    DATA lv_repair_payload TYPE string.
    DATA lv_repair_source TYPE string.
    DATA lv_repair_object TYPE string.
    DATA lv_repair_type TYPE string.
    DATA lv_repair_kind TYPE string.
    DATA lv_repair_name TYPE string.
    DATA lv_repair_version TYPE string.
    DATA lv_check_ok TYPE abap_bool.
    DATA lv_activate_ok TYPE abap_bool.
    DATA lv_active_json TYPE string.
    DATA lv_error_count_json TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_lifecycle_json).
        rv_json = |\{"status":"ERROR","stage":"OBJECT_LIFECYCLE_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_lifecycle_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_object_type = to_upper( ls_request-object_type ).
    lv_mode = to_upper( ls_request-mode ).
    IF lv_mode IS INITIAL.
      lv_mode = to_upper( ls_request-action ).
    ENDIF.
    IF lv_mode IS INITIAL.
      lv_mode = 'CHECK_ACTIVATE'.
    ENDIF.

    lv_max_rounds = ls_request-options-max_repair_rounds.
    IF lv_max_rounds IS INITIAL OR lv_max_rounds < 1.
      lv_max_rounds = 3.
    ENDIF.
    IF lv_max_rounds > 5.
      lv_max_rounds = 5.
    ENDIF.
    ls_request-options-verify_after_activate = abap_true.

    IF ls_request-object_name IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"OBJECT_LIFECYCLE_VALIDATE","message":"object_name is required"}'.
      RETURN.
    ENDIF.

    IF lv_object_type <> 'PROG' AND lv_object_type <> 'REPORT'
       AND lv_object_type <> 'CLAS' AND lv_object_type <> 'CLASS'.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_LIFECYCLE_VALIDATE",| &&
                |"object_type":"{ escape( val = lv_object_type format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"First lifecycle version supports PROG/REPORT and CLAS/CLASS"\}|.
      RETURN.
    ENDIF.

    IF lv_mode = 'SAVE_CHECK_ACTIVATE' OR lv_mode = 'CREATE_CHECK_ACTIVATE'.
      lv_save_json = save_source_from_json( iv_json ).
      lv_step_status = 'OK'.
      IF lv_save_json CP '{"status":"ERROR"*'.
        lv_step_status = 'ERROR'.
      ENDIF.
      lv_step = |\{"step":"save","status":"{ lv_step_status }","result":{ lv_save_json }\}|.
      append_result( EXPORTING iv_result = lv_step CHANGING cv_json = lv_steps ).
      IF lv_step_status = 'ERROR'.
        lv_steps = lv_steps && ']'.
        rv_json = |\{"status":"ERROR","object_type":"{ lv_object_type }","object_name":"{ ls_request-object_name }",| &&
                  |"mode":"{ lv_mode }","max_repair_rounds":{ lv_max_rounds },"steps":{ lv_steps },| &&
                  |"final":\{"active":false,"error_count":1\}\}|.
        RETURN.
      ENDIF.
    ENDIF.

    DO lv_max_rounds TIMES.
      lv_round = sy-index.
      CLEAR lv_check_ok.

      IF lv_object_type = 'CLAS' OR lv_object_type = 'CLASS'.
        lv_check_json = probe_class_activation_check( ls_request-object_name ).
      ELSE.
        lv_check_json = check_from_json( iv_json ).
      ENDIF.

      lv_step_status = 'OK'.
      IF lv_check_json CP '{"status":"ERROR"*'.
        lv_step_status = 'ERROR'.
      ENDIF.
      lv_step = |\{"step":"check","round":{ lv_round },"status":"{ lv_step_status }","result":{ lv_check_json }\}|.
      append_result( EXPORTING iv_result = lv_step CHANGING cv_json = lv_steps ).
      IF lv_step_status = 'OK'.
        lv_check_ok = abap_true.
        EXIT.
      ENDIF.

      IF lv_mode <> 'REPAIR_CHECK_ACTIVATE' AND lv_mode <> 'CHECK_REPAIR_ACTIVATE'.
        EXIT.
      ENDIF.

      lv_repair_source = ls_request-repair-source_code.
      IF lv_repair_source IS INITIAL.
        EXIT.
      ENDIF.

      lv_repair_type = to_upper( ls_request-repair-object_type ).
      IF lv_repair_type IS INITIAL.
        lv_repair_type = lv_object_type.
      ENDIF.
      lv_repair_object = to_upper( ls_request-repair-object_name ).
      IF lv_repair_object IS INITIAL.
        lv_repair_object = to_upper( ls_request-object_name ).
      ENDIF.
      lv_repair_kind = to_upper( ls_request-repair-target-kind ).
      IF lv_repair_kind IS INITIAL.
        lv_repair_kind = to_upper( ls_request-repair-target_kind ).
      ENDIF.
      lv_repair_name = to_upper( ls_request-repair-target-name ).
      IF lv_repair_name IS INITIAL.
        lv_repair_name = to_upper( ls_request-repair-target_name ).
      ENDIF.
      lv_repair_version = to_upper( ls_request-repair-target-version ).
      IF lv_repair_version IS INITIAL.
        lv_repair_version = to_upper( ls_request-repair-target_version ).
      ENDIF.
      IF lv_repair_version IS INITIAL.
        lv_repair_version = 'INACTIVE'.
      ENDIF.
      IF lv_repair_kind IS INITIAL.
        lv_repair_kind = 'METHOD'.
      ENDIF.

      IF lv_object_type = 'CLAS' OR lv_object_type = 'CLASS'.
        lv_repair_payload = |\{"object_type":"CLAS","object_name":"{ lv_repair_object }",| &&
                            |"target":\{"kind":"{ lv_repair_kind }","name":"{ lv_repair_name }","version":"{ lv_repair_version }"\},| &&
                            |"source_code":"{ escape( val = lv_repair_source format = cl_abap_format=>e_json_string ) }",| &&
                            |"check_after_save":true,"activate_after_check":false\}|.
        lv_repair_json = object_repair_from_json( lv_repair_payload ).
      ELSE.
        lv_repair_payload = |\{"object_type":"PROG","object_name":"{ ls_request-object_name }",| &&
                            |"package":"{ escape( val = ls_request-package format = cl_abap_format=>e_json_string ) }",| &&
                            |"transport":"{ escape( val = ls_request-transport format = cl_abap_format=>e_json_string ) }",| &&
                            |"source_code":"{ escape( val = lv_repair_source format = cl_abap_format=>e_json_string ) }"\}|.
        lv_repair_json = save_source_from_json( lv_repair_payload ).
      ENDIF.

      lv_step_status = 'OK'.
      IF lv_repair_json CP '{"status":"ERROR"*'.
        lv_step_status = 'ERROR'.
      ENDIF.
      lv_step = |\{"step":"repair","round":{ lv_round },"status":"{ lv_step_status }","result":{ lv_repair_json }\}|.
      append_result( EXPORTING iv_result = lv_step CHANGING cv_json = lv_steps ).
      IF lv_step_status = 'ERROR'.
        EXIT.
      ENDIF.
    ENDDO.

    IF lv_check_ok <> abap_true.
      lv_steps = lv_steps && ']'.
      rv_json = |\{"status":"ERROR","object_type":"{ lv_object_type }","object_name":"{ ls_request-object_name }",| &&
                |"mode":"{ lv_mode }","max_repair_rounds":{ lv_max_rounds },| &&
                |"message":"Lifecycle stopped before activation because check did not pass",| &&
                |"steps":{ lv_steps },"final":\{"active":false,"error_count":1\}\}|.
      RETURN.
    ENDIF.

    lv_activate_json = activate_from_json(
      |\{"object_type":"{ lv_object_type }","object_name":"{ ls_request-object_name }"\}| ).
    lv_activate_ok = abap_true.
    lv_step_status = 'OK'.
    IF lv_activate_json CP '{"status":"ERROR"*'.
      lv_step_status = 'ERROR'.
      lv_activate_ok = abap_false.
    ENDIF.
    lv_step = |\{"step":"activate","status":"{ lv_step_status }","result":{ lv_activate_json }\}|.
    append_result( EXPORTING iv_result = lv_step CHANGING cv_json = lv_steps ).

    IF ls_request-options-verify_after_activate = abap_true.
      IF lv_object_type = 'CLAS' OR lv_object_type = 'CLASS'.
        lv_verify_json = probe_class_activation_check( ls_request-object_name ).
      ELSE.
        lv_verify_json = check_from_json( iv_json ).
      ENDIF.
      lv_step_status = 'OK'.
      IF lv_verify_json CP '{"status":"ERROR"*'.
        lv_step_status = 'ERROR'.
        lv_activate_ok = abap_false.
      ENDIF.
      lv_step = |\{"step":"verify","status":"{ lv_step_status }","result":{ lv_verify_json }\}|.
      append_result( EXPORTING iv_result = lv_step CHANGING cv_json = lv_steps ).
    ENDIF.

    IF lv_activate_ok = abap_true.
      lv_final_status = 'OK'.
      lv_active_json = 'true'.
      lv_error_count_json = '0'.
    ELSE.
      lv_active_json = 'false'.
      lv_error_count_json = '1'.
    ENDIF.
    lv_steps = lv_steps && ']'.
    rv_json = |\{"status":"{ lv_final_status }","object_type":"{ lv_object_type }",| &&
              |"object_name":"{ ls_request-object_name }","mode":"{ lv_mode }",| &&
              |"max_repair_rounds":{ lv_max_rounds },"steps":{ lv_steps },| &&
              |"final":\{"active":{ lv_active_json },"error_count":{ lv_error_count_json }\}\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->OBJECT_REPAIR_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD object_repair_from_json.
    DATA ls_request TYPE ty_object_repair_request.
    DATA lv_object_type TYPE string.
    DATA lv_target_kind TYPE string.
    DATA lv_class TYPE seoclsname.
    DATA lv_method TYPE seocmpname.
    DATA lv_version TYPE string.
    DATA lv_seoversion TYPE seoversion.
    DATA lt_source TYPE seop_source.
    DATA ls_mtdkey TYPE seocpdkey.
    DATA lv_save_subrc TYPE sy-subrc.
    DATA lv_read_back TYPE string.
    DATA lv_check_result TYPE string.
    DATA lv_activate_result TYPE string.
    DATA lv_save_status TYPE string.
    DATA lv_class_name TYPE string.
    DATA lv_include TYPE syrepid.
    DATA lv_read_state TYPE c LENGTH 1.
    DATA lt_existing_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_repair_json).
        rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_repair_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_object_type = to_upper( ls_request-object_type ).
    lv_target_kind = to_upper( ls_request-target-kind ).
    IF lv_target_kind IS INITIAL.
      lv_target_kind = to_upper( ls_request-target_kind ).
    ENDIF.

    IF lv_object_type <> 'CLAS' AND lv_object_type <> 'CLASS'.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_VALIDATE",| &&
                |"object_type":"{ escape( val = lv_object_type format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"Only CLAS/METHOD repair is implemented in this version"\}|.
      RETURN.
    ENDIF.

    IF lv_target_kind <> 'METHOD'.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_VALIDATE",| &&
                |"object_type":"CLAS","target_kind":"{ escape( val = lv_target_kind format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"Only target.kind METHOD is implemented for CLAS repair"\}|.
      RETURN.
    ENDIF.

    lv_class = to_upper( ls_request-object_name ).
    lv_class_name = lv_class.
    lv_method = to_upper( ls_request-target-name ).
    IF lv_method IS INITIAL.
      lv_method = to_upper( ls_request-target_name ).
    ENDIF.
    lv_version = to_upper( ls_request-target-version ).
    IF lv_version IS INITIAL.
      lv_version = to_upper( ls_request-target_version ).
    ENDIF.
    IF lv_version IS INITIAL.
      lv_version = 'INACTIVE'.
    ENDIF.

    IF lv_class IS INITIAL OR lv_method IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"OBJECT_REPAIR_VALIDATE","message":"object_name, target.name, and source_code are required"}'.
      RETURN.
    ENDIF.

    CASE lv_version.
      WHEN 'ACTIVE' OR 'A'.
        lv_seoversion = seoc_version_active.
        lv_version = 'ACTIVE'.
        lv_read_state = 'A'.
      WHEN 'INACTIVE' OR 'I'.
        lv_seoversion = seoc_version_inactive.
        lv_version = 'INACTIVE'.
        lv_read_state = 'I'.
      WHEN OTHERS.
        rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_VALIDATE",| &&
                  |"version":"{ escape( val = lv_version format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"target.version must be ACTIVE or INACTIVE"\}|.
        RETURN.
    ENDCASE.

    SPLIT ls_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.
    ls_mtdkey-clsname = lv_class.
    ls_mtdkey-cpdname = lv_method.

    CALL FUNCTION 'SEO_METHOD_GET_INCLUDE_BY_NAME'
      EXPORTING
        mtdkey  = ls_mtdkey
      IMPORTING
        progname = lv_include
      EXCEPTIONS
        OTHERS  = 1.

    IF sy-subrc <> 0 OR lv_include IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_INCLUDE_LOOKUP",| &&
                |"object_type":"CLAS","object_name":"{ lv_class }",| &&
                |"method_name":"{ lv_method }","message":"Method include lookup failed"\}|.
      RETURN.
    ENDIF.

    IF lt_source IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"OBJECT_REPAIR_VALIDATE","message":"source_code produced no source lines"}'.
      RETURN.
    ENDIF.

    READ REPORT lv_include INTO lt_existing_source STATE lv_read_state.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_INCLUDE_READ",| &&
                |"object_type":"CLAS","object_name":"{ lv_class }",| &&
                |"method_name":"{ lv_method }","include":"{ lv_include }",| &&
                |"message":"Method include could not be read before repair"\}|.
      RETURN.
    ENDIF.

    TRY.
        INSERT REPORT lv_include FROM lt_source STATE lv_read_state PROGRAM TYPE 'I'.
      CATCH cx_root INTO DATA(lx_repair_insert).
        rv_json = |\{"status":"ERROR","stage":"OBJECT_REPAIR_INCLUDE_SAVE",| &&
                  |"object_type":"CLAS","object_name":"{ lv_class }",| &&
                  |"method_name":"{ lv_method }","include":"{ lv_include }",| &&
                  |"message":"{ escape( val = lx_repair_insert->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_save_subrc = sy-subrc.
    IF lv_save_subrc = 0.
      lv_save_status = 'OK'.
    ELSE.
      lv_save_status = 'ERROR'.
    ENDIF.

    lv_read_back = class_method_read_from_json(
      |\{"class_name":"{ lv_class }","method_name":"{ lv_method }","version":"{ lv_version }","source_format":"STRING"\}| ).

    IF ls_request-check_after_save = abap_true.
      lv_check_result = probe_class_activation_check( lv_class_name ).
    ELSE.
      lv_check_result = '{"status":"SKIPPED","message":"check_after_save is false"}'.
    ENDIF.

    IF ls_request-activate_after_check = abap_true.
      lv_activate_result = activate_from_json(
        |\{"object_type":"CLAS","object_name":"{ lv_class }"\}| ).
    ELSE.
      lv_activate_result = '{"status":"SKIPPED","message":"activate_after_check is false"}'.
    ENDIF.

    rv_json = |\{"status":"{ lv_save_status }","object_type":"CLAS",| &&
              |"object_name":"{ lv_class }",| &&
              |"target":\{"kind":"METHOD","name":"{ lv_method }","version":"{ lv_version }"\},| &&
              |"save":\{"api":"INSERT_REPORT_METHOD_INCLUDE","subrc":{ lv_save_subrc },| &&
              |"include":"{ lv_include }","previous_state":"{ lv_read_state }"\},| &&
              |"read_back":{ lv_read_back },"check":{ lv_check_result },| &&
              |"activate":{ lv_activate_result }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->PROBE_CLASS_ACTIVATION_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CLASS_NAME                  TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD probe_class_activation_check.
    DATA lv_class TYPE seoclsname.
    DATA lt_objects TYPE STANDARD TABLE OF dwinactiv WITH EMPTY KEY.
    DATA ls_object TYPE dwinactiv.
    DATA lo_messages TYPE REF TO cl_wb_message_container.
    DATA lo_checklist TYPE REF TO cl_wb_checklist.
    DATA lt_errors TYPE STANDARD TABLE OF swbme_error_entry WITH EMPTY KEY.
    DATA ls_error TYPE swbme_error_entry.
    DATA lt_results TYPE tt_probe_results.
    DATA lv_results_json TYPE string.
    DATA lv_before_count TYPE i.
    DATA lv_after_count TYPE i.
    DATA lv_error_count TYPE i.
    DATA lv_error_index TYPE i.
    DATA lv_exception TYPE string VALUE 'NONE'.
    DATA lv_fm_subrc TYPE sy-subrc.
    DATA lv_msg_text TYPE string.
    DATA lv_msgid TYPE symsgid.
    DATA lv_msgno TYPE symsgno.
    DATA lv_msgty TYPE symsgty.
    DATA lv_msgv1 TYPE symsgv.
    DATA lv_status TYPE string.
    DATA lv_severity TYPE string.
    DATA lv_value TYPE string.
    DATA lv_value_c TYPE c LENGTH 40.
    DATA lv_error_text TYPE string.

    lv_class = to_upper( iv_class_name ).
    IF lv_class IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"PROBE_VALIDATE","probe_id":"CLASS_ACTIVATION_CHECK","message":"class_name is required"}'.
      RETURN.
    ENDIF.

    SELECT COUNT( * )
      FROM dwinactiv
      INTO lv_before_count
      WHERE object = 'CLAS'
        AND obj_name = lv_class.

    ls_object-object = 'CLAS'.
    ls_object-obj_name = lv_class.
    ls_object-uname = sy-uname.
    APPEND ls_object TO lt_objects.

    CREATE OBJECT lo_messages.

    CALL FUNCTION 'RS_WORKING_OBJECTS_ACTIVATE'
      EXPORTING
        suppress_syntax_check = space
        suppress_generation = space
        suppress_insert = 'X'
        suppress_corr_insert = 'X'
        with_popup = space
        suppress_enqueue = abap_true
        ui_decoupled = abap_true
        message_container = lo_messages
        check_only = abap_true
      IMPORTING
        p_checklist = lo_checklist
      TABLES
        objects = lt_objects
      EXCEPTIONS
        cancelled = 1
        excecution_error = 2
        insert_into_corr_error = 3
        OTHERS = 4.

    lv_fm_subrc = sy-subrc.
    lv_msgid = sy-msgid.
    lv_msgno = sy-msgno.
    lv_msgty = sy-msgty.
    lv_msgv1 = sy-msgv1.
    lv_msg_text = build_sy_message( 'RS_WORKING_OBJECTS_ACTIVATE returned without SAP message text' ).

    CASE lv_fm_subrc.
      WHEN 0.
        lv_exception = 'NONE'.
      WHEN 1.
        lv_exception = 'CANCELLED'.
      WHEN 2.
        lv_exception = 'EXCECUTION_ERROR'.
      WHEN 3.
        lv_exception = 'INSERT_INTO_CORR_ERROR'.
      WHEN OTHERS.
        lv_exception = 'OTHERS'.
    ENDCASE.

    SELECT COUNT( * )
      FROM dwinactiv
      INTO lv_after_count
      WHERE object = 'CLAS'
        AND obj_name = lv_class.

    IF lo_checklist IS BOUND.
      lo_checklist->get_error_messages(
        IMPORTING
          p_error_tab = lt_errors ).
      DESCRIBE TABLE lt_errors LINES lv_error_count.
    ENDIF.

    IF lv_fm_subrc = 0 AND lv_error_count = 0.
      lv_status = 'OK'.
      lv_severity = 'I'.
    ELSE.
      lv_status = 'ERROR'.
      lv_severity = 'E'.
    ENDIF.

    WRITE lv_fm_subrc TO lv_value_c.
    lv_value = lv_value_c.
    APPEND VALUE ty_probe_result(
      name        = 'FM_SUBRC'
      status      = lv_status
      severity    = lv_severity
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_value
      message     = 'Return code from RS_WORKING_OBJECTS_ACTIVATE' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'EXCEPTION'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_exception
      message     = 'Mapped exception branch' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'SY_MESSAGE'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_msg_text
      message     = 'Message text built from sy-msg fields' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'SY_MSGID'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_msgid
      message     = 'Message id' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'SY_MSGNO'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_msgno
      message     = 'Message number' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'SY_MSGTY'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_msgty
      message     = 'Message type' ) TO lt_results.
    APPEND VALUE ty_probe_result(
      name        = 'SY_MSGV1'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
      value       = lv_msgv1
      message     = 'Message variable 1' ) TO lt_results.

    IF lo_messages IS BOUND.
      APPEND VALUE ty_probe_result(
        name        = 'MESSAGE_CONTAINER_BOUND'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
        value       = 'X'
        message     = 'CL_WB_MESSAGE_CONTAINER reference state' ) TO lt_results.
    ELSE.
      APPEND VALUE ty_probe_result(
        name        = 'MESSAGE_CONTAINER_BOUND'
        status      = 'ERROR'
        severity    = 'E'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
        value       = ''
        message     = 'CL_WB_MESSAGE_CONTAINER reference state' ) TO lt_results.
    ENDIF.

    IF lo_checklist IS BOUND.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_BOUND'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
        value       = 'X'
        message     = 'CL_WB_CHECKLIST reference state' ) TO lt_results.
    ELSE.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_BOUND'
        status      = 'WARN'
        severity    = 'W'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'RS_WORKING_OBJECTS_ACTIVATE'
        value       = ''
        message     = 'CL_WB_CHECKLIST reference state' ) TO lt_results.
    ENDIF.

    WRITE lv_error_count TO lv_value_c.
    lv_value = lv_value_c.
    APPEND VALUE ty_probe_result(
      name        = 'CHECKLIST_ERROR_COUNT'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'CL_WB_CHECKLIST'
      value       = lv_value
      message     = 'Number of messages returned by CL_WB_CHECKLIST->GET_ERROR_MESSAGES' ) TO lt_results.

    LOOP AT lt_errors INTO ls_error.
      lv_error_index = sy-tabix.
      CLEAR lv_error_text.
      LOOP AT ls_error-mtext INTO DATA(lv_mtext_line).
        IF lv_error_text IS INITIAL.
          lv_error_text = lv_mtext_line.
        ELSE.
          CONCATENATE lv_error_text lv_mtext_line INTO lv_error_text SEPARATED BY ` `.
        ENDIF.
      ENDLOOP.

      WRITE lv_error_index TO lv_value_c.
      lv_value = lv_value_c.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_INDEX'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = lv_value
        message     = lv_error_text ) TO lt_results.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_TYPE'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = ls_error-mtype
        message     = lv_error_text ) TO lt_results.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_TEXT'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = lv_error_text
        message     = ls_error-object_text ) TO lt_results.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_OBJECT'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = ls_error-object_text
        message     = lv_error_text ) TO lt_results.
      WRITE ls_error-line TO lv_value_c.
      lv_value = lv_value_c.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_LINE'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = lv_value
        message     = lv_error_text ) TO lt_results.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_CATEGORY'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = ls_error-category
        message     = lv_error_text ) TO lt_results.
      APPEND VALUE ty_probe_result(
        name        = 'CHECKLIST_ERROR_CODE'
        status      = 'OK'
        severity    = 'I'
        object_type = 'CLAS'
        object_name = lv_class
        stage       = 'CL_WB_CHECKLIST'
        value       = ls_error-code
        message     = lv_error_text ) TO lt_results.
    ENDLOOP.

    WRITE lv_before_count TO lv_value_c.
    lv_value = lv_value_c.
    APPEND VALUE ty_probe_result(
      name        = 'DWINACTIV_BEFORE'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'DWINACTIV'
      value       = lv_value
      message     = 'DWINACTIV entries before check' ) TO lt_results.
    WRITE lv_after_count TO lv_value_c.
    lv_value = lv_value_c.
    APPEND VALUE ty_probe_result(
      name        = 'DWINACTIV_AFTER'
      status      = 'OK'
      severity    = 'I'
      object_type = 'CLAS'
      object_name = lv_class
      stage       = 'DWINACTIV'
      value       = lv_value
      message     = 'DWINACTIV entries after check' ) TO lt_results.

    lv_results_json = /ui2/cl_json=>serialize( data = lt_results ).
    rv_json = |\{"status":"{ lv_status }","probe_id":"CLASS_ACTIVATION_CHECK",| &&
              |"object_type":"CLAS","object_name":"{ lv_class }",| &&
              |"check_only":true,"error_count":{ lv_error_count },| &&
              |"results":{ lv_results_json }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->PROBE_RUN_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD probe_run_from_json.
    DATA ls_request TYPE ty_probe_run_request.
    DATA lv_runner TYPE syrepid.
    DATA lv_memid TYPE c LENGTH 80.
    DATA lv_results_json TYPE string.
    DATA lt_results TYPE tt_probe_results.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_probe_json).
        rv_json = |\{"status":"ERROR","stage":"PROBE_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_probe_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-probe_id IS NOT INITIAL.
      CASE to_upper( ls_request-probe_id ).
        WHEN 'CLASS_ACTIVATION_CHECK'.
          IF ls_request-class_name IS NOT INITIAL.
            rv_json = probe_class_activation_check( ls_request-class_name ).
          ELSEIF ls_request-object_name IS NOT INITIAL.
            rv_json = probe_class_activation_check( ls_request-object_name ).
          ELSE.
            rv_json = '{"status":"ERROR","stage":"PROBE_VALIDATE","probe_id":"CLASS_ACTIVATION_CHECK","message":"class_name or object_name is required"}'.
          ENDIF.
        WHEN OTHERS.
          rv_json = |\{"status":"ERROR","stage":"PROBE_VALIDATE",| &&
                    |"probe_id":"{ escape( val = to_upper( ls_request-probe_id ) format = cl_abap_format=>e_json_string ) }",| &&
                    |"message":"Unsupported built-in probe_id"\}|.
      ENDCASE.
      RETURN.
    ENDIF.

    lv_runner = to_upper( ls_request-runner ).
    IF lv_runner IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"PROBE_VALIDATE","message":"runner or probe_id is required"}'.
      RETURN.
    ENDIF.

    IF lv_runner NP 'ZSDRP_AI_MCP_*'.
      rv_json = |\{"status":"ERROR","stage":"PROBE_VALIDATE","runner":"{ lv_runner }",| &&
                |"message":"Only ZSDRP_AI_MCP_* probe runner reports are allowed"\}|.
      RETURN.
    ENDIF.

    READ REPORT lv_runner INTO lt_source.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"PROBE_VALIDATE","runner":"{ lv_runner }",| &&
                |"message":"Probe runner report could not be read"\}|.
      RETURN.
    ENDIF.

    lv_memid = |zai_mcp_rest_PROBE_{ sy-datum }_{ sy-uzeit }_{ sy-index }|.
    FREE MEMORY ID lv_memid.

    TRY.
        SUBMIT (lv_runner)
          WITH p_memid = lv_memid
          AND RETURN.
      CATCH cx_root INTO DATA(lx_probe_submit).
        FREE MEMORY ID lv_memid.
        rv_json = |\{"status":"ERROR","stage":"PROBE_SUBMIT","runner":"{ lv_runner }",| &&
                  |"memory_id":"{ lv_memid }",| &&
                  |"message":"{ escape( val = lx_probe_submit->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IMPORT gt_result = lt_results FROM MEMORY ID lv_memid.
    FREE MEMORY ID lv_memid.

    IF lt_results IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"PROBE_RESULT","runner":"{ lv_runner }",| &&
                |"memory_id":"{ lv_memid }",| &&
                |"message":"Probe runner did not export gt_result to ABAP memory"\}|.
      RETURN.
    ENDIF.

    lv_results_json = /ui2/cl_json=>serialize( data = lt_results ).
    rv_json = |\{"status":"OK","runner":"{ lv_runner }","memory_id":"{ lv_memid }",| &&
              |"results":{ lv_results_json }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->READ_FUNCTION_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_function_from_json.
    DATA ls_request TYPE ty_function_check_request.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_include TYPE rs38l-include.
    DATA lv_namespace TYPE rs38l-namespace.
    DATA lv_str_area TYPE rs38l-str_area.
    DATA lv_program TYPE syrepid.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_source_code TYPE string.
    DATA lv_source_lines TYPE string VALUE '['.
    DATA lv_string_only TYPE abap_bool.
    DATA lv_line_count TYPE i.
    DATA lv_non_empty_count TYPE i.
    DATA lv_comment_count TYPE i.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.
    DATA lv_index TYPE i.
    DATA lv_trimmed TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_read_json).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_READ_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_read_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-function_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"function_name is required"}'.
      RETURN.
    ENDIF.

    lv_function_name = to_upper( ls_request-function_name ).
    IF to_upper( ls_request-source_format ) = 'STRING'.
      lv_string_only = abap_true.
    ENDIF.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = lv_function_name
      IMPORTING
        group              = lv_function_group
        include            = lv_include
        namespace          = lv_namespace
        str_area           = lv_str_area
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.

    IF sy-subrc <> 0 OR lv_include IS INITIAL.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_EXISTS'
        iv_object_type = 'FUNC'
        iv_object_name = lv_function_name
        iv_message     = 'Function module does not exist or include cannot be determined'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check function module name and authorization' ).
      RETURN.
    ENDIF.

    TRY.
        READ REPORT lv_include INTO lt_source.
      CATCH cx_root INTO DATA(lx_read_function).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_READ","object_type":"FUNC",| &&
                  |"object_name":"{ lv_function_name }",| &&
                  |"function_group":"{ lv_function_group }",| &&
                  |"include":"{ lv_include }",| &&
                  |"message":"{ escape( val = lx_read_function->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_READ","object_type":"FUNC",| &&
                |"object_name":"{ lv_function_name }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"include":"{ lv_include }",| &&
                |"message":"Function include source could not be read"\}|.
      RETURN.
    ENDIF.

    LOOP AT lt_source INTO DATA(lv_source_line).
      lv_index = sy-tabix.
      lv_line_count = lv_line_count + 1.
      lv_trimmed = lv_source_line.
      CONDENSE lv_trimmed.
      IF lv_trimmed IS NOT INITIAL.
        lv_non_empty_count = lv_non_empty_count + 1.
      ENDIF.
      IF lv_trimmed CP '*'.
        lv_comment_count = lv_comment_count + 1.
      ENDIF.

      IF lv_source_code IS INITIAL.
        lv_source_code = lv_source_line.
      ELSE.
        lv_source_code = lv_source_code && cl_abap_char_utilities=>newline && lv_source_line.
      ENDIF.

      IF lv_string_only = abap_false.
        IF lv_source_lines <> '['.
          lv_source_lines = lv_source_lines && ','.
        ENDIF.
        lv_source_lines = lv_source_lines &&
          |\{"line":{ lv_index },| &&
          |"source":"{ escape( val = lv_source_line format = cl_abap_format=>e_json_string ) }"\}|.
      ENDIF.
    ENDLOOP.

    IF lv_string_only = abap_false.
      lv_source_lines = lv_source_lines && ']'.
    ENDIF.

    lv_program = |SAPL{ lv_function_group }|.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"FUNC","object_name":"{ lv_function_name }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"include":"{ lv_include }",| &&
                |"program":"{ lv_program }",| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"OK","messages":[]\},| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_ANALYZE","object_type":"FUNC","object_name":"{ lv_function_name }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"include":"{ lv_include }",| &&
                |"program":"{ lv_program }",| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"ERROR","messages":[\{| &&
                |"severity":"E","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}]\},| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->READ_FUNCTION_GROUP_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_function_group_from_json.
    DATA ls_request TYPE ty_function_group_read_request.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_program TYPE syrepid.
    DATA lv_allowed_include_prefix TYPE string.
    DATA lt_main_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_include_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_merged_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_includes_json TYPE string VALUE '['.
    DATA lv_source_code TYPE string.
    DATA lv_source_lines TYPE string VALUE '['.
    DATA lv_part_source_code TYPE string.
    DATA lv_part_source_lines TYPE string.
    DATA lv_string_only TYPE abap_bool.
    DATA lv_line_count TYPE i.
    DATA lv_non_empty_count TYPE i.
    DATA lv_comment_count TYPE i.
    DATA lv_part_line_count TYPE i.
    DATA lv_index TYPE i.
    DATA lv_part_index TYPE i.
    DATA lv_trimmed TYPE string.
    DATA lv_upper_line TYPE string.
    DATA lv_include TYPE syrepid.
    DATA lv_include_keyword TYPE string.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_fugr_read_json).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_GROUP_READ_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_fugr_read_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_function_group = to_upper( ls_request-function_group ).
    IF lv_function_group IS INITIAL.
      lv_function_group = to_upper( ls_request-object_name ).
    ENDIF.
    IF lv_function_group CP 'SAPL*'.
      lv_function_group = lv_function_group+4.
    ENDIF.

    IF lv_function_group IS INITIAL.
      rv_json = '{"status":"ERROR","message":"function_group or object_name is required"}'.
      RETURN.
    ENDIF.

    IF to_upper( ls_request-source_format ) = 'STRING'.
      lv_string_only = abap_true.
    ENDIF.

    lv_program = |SAPL{ lv_function_group }|.
    lv_allowed_include_prefix = |L{ lv_function_group }|.

    TRY.
        READ REPORT lv_program INTO lt_main_source.
      CATCH cx_root INTO DATA(lx_fugr_read_main).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_GROUP_MAIN_READ","object_type":"FUGR",| &&
                  |"object_name":"{ lv_function_group }","program":"{ lv_program }",| &&
                  |"message":"{ escape( val = lx_fugr_read_main->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_GROUP_MAIN_READ","object_type":"FUGR",| &&
                |"object_name":"{ lv_function_group }","program":"{ lv_program }",| &&
                |"message":"Function group main program could not be read"\}|.
      RETURN.
    ENDIF.

    APPEND |* >>> BEGIN MAIN PROGRAM { lv_program }| TO lt_merged_source.
    APPEND LINES OF lt_main_source TO lt_merged_source.
    APPEND |* <<< END MAIN PROGRAM { lv_program }| TO lt_merged_source.

    LOOP AT lt_main_source INTO DATA(lv_main_line).
      lv_trimmed = lv_main_line.
      SHIFT lv_trimmed LEFT DELETING LEADING space.
      IF lv_trimmed IS INITIAL OR lv_trimmed(1) = '*'.
        CONTINUE.
      ENDIF.

      lv_upper_line = to_upper( lv_trimmed ).
      IF lv_upper_line CP 'INCLUDE *'.
        SPLIT lv_upper_line AT space INTO lv_include_keyword lv_include.
        SPLIT lv_include AT '"' INTO lv_include DATA(lv_include_comment).
        REPLACE ALL OCCURRENCES OF '.' IN lv_include WITH ''.
        CONDENSE lv_include NO-GAPS.
        IF lv_include IS INITIAL OR lv_include NP |{ lv_allowed_include_prefix }*|.
          CONTINUE.
        ENDIF.

        CLEAR: lt_include_source, lv_part_source_code, lv_part_source_lines, lv_part_line_count.
        lv_part_source_lines = '['.

        READ REPORT lv_include INTO lt_include_source.
        IF sy-subrc = 0.
          LOOP AT lt_include_source INTO DATA(lv_part_line).
            lv_part_index = sy-tabix.
            lv_part_line_count = lv_part_line_count + 1.

            IF lv_part_source_code IS INITIAL.
              lv_part_source_code = lv_part_line.
            ELSE.
              lv_part_source_code = lv_part_source_code && cl_abap_char_utilities=>newline && lv_part_line.
            ENDIF.

            IF lv_string_only = abap_false.
              IF lv_part_source_lines <> '['.
                lv_part_source_lines = lv_part_source_lines && ','.
              ENDIF.
              lv_part_source_lines = lv_part_source_lines &&
                |\{"line":{ lv_part_index },| &&
                |"source":"{ escape( val = lv_part_line format = cl_abap_format=>e_json_string ) }"\}|.
            ENDIF.
          ENDLOOP.
          IF lv_string_only = abap_false.
            lv_part_source_lines = lv_part_source_lines && ']'.
          ENDIF.

          IF lv_includes_json <> '['.
            lv_includes_json = lv_includes_json && ','.
          ENDIF.
          IF lv_string_only = abap_true.
            lv_includes_json = lv_includes_json &&
              |\{"include":"{ lv_include }","status":"OK","line_count":{ lv_part_line_count },| &&
              |"source_code":"{ escape( val = lv_part_source_code format = cl_abap_format=>e_json_string ) }"\}|.
          ELSE.
            lv_includes_json = lv_includes_json &&
              |\{"include":"{ lv_include }","status":"OK","line_count":{ lv_part_line_count },| &&
              |"source_code":"{ escape( val = lv_part_source_code format = cl_abap_format=>e_json_string ) }",| &&
              |"source_lines":{ lv_part_source_lines }\}|.
          ENDIF.

          APPEND |* >>> BEGIN INCLUDE { lv_include }| TO lt_merged_source.
          APPEND LINES OF lt_include_source TO lt_merged_source.
          APPEND |* <<< END INCLUDE { lv_include }| TO lt_merged_source.
        ELSE.
          IF lv_includes_json <> '['.
            lv_includes_json = lv_includes_json && ','.
          ENDIF.
          lv_includes_json = lv_includes_json &&
            |\{"include":"{ lv_include }","status":"ERROR","message":"Include source could not be read"\}|.
        ENDIF.
      ENDIF.
    ENDLOOP.

    lv_includes_json = lv_includes_json && ']'.

    LOOP AT lt_merged_source INTO DATA(lv_source_line).
      lv_index = sy-tabix.
      lv_line_count = lv_line_count + 1.
      lv_trimmed = lv_source_line.
      CONDENSE lv_trimmed.
      IF lv_trimmed IS NOT INITIAL.
        lv_non_empty_count = lv_non_empty_count + 1.
      ENDIF.
      IF lv_trimmed CP '*'.
        lv_comment_count = lv_comment_count + 1.
      ENDIF.

      IF lv_source_code IS INITIAL.
        lv_source_code = lv_source_line.
      ELSE.
        lv_source_code = lv_source_code && cl_abap_char_utilities=>newline && lv_source_line.
      ENDIF.

      IF lv_string_only = abap_false.
        IF lv_source_lines <> '['.
          lv_source_lines = lv_source_lines && ','.
        ENDIF.
        lv_source_lines = lv_source_lines &&
          |\{"line":{ lv_index },| &&
          |"source":"{ escape( val = lv_source_line format = cl_abap_format=>e_json_string ) }"\}|.
      ENDIF.
    ENDLOOP.

    IF lv_string_only = abap_false.
      lv_source_lines = lv_source_lines && ']'.
    ENDIF.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"FUGR","object_name":"{ lv_function_group }",| &&
                |"program":"{ lv_program }",| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"OK","messages":[]\},| &&
                |"includes":{ lv_includes_json },| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"FUNCTION_GROUP_ANALYZE","object_type":"FUGR","object_name":"{ lv_function_group }",| &&
                |"program":"{ lv_program }",| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"ERROR","messages":[\{| &&
                |"severity":"E","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}]\},| &&
                |"includes":{ lv_includes_json },| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->READ_OBJECT_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_object_from_json.
    DATA ls_request TYPE ty_read_request.
    DATA lv_object_type TYPE string.
    DATA lv_program TYPE syrepid.
    DATA lv_class TYPE seoclsname.
    DATA lv_response_type TYPE string.
    DATA lv_response_name TYPE string.
    DATA lv_tadir_object TYPE tadir-object.
    DATA lv_tadir_json TYPE string.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_main_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_syntax_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_include_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_method_includes TYPE seop_methods_w_include.
    DATA ls_clskey TYPE seoclskey.
    DATA lv_source_code TYPE string.
    DATA lv_source_lines TYPE string VALUE '['.
    DATA lv_string_only TYPE abap_bool.
    DATA lv_line_count TYPE i.
    DATA lv_non_empty_count TYPE i.
    DATA lv_comment_count TYPE i.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.
    DATA lv_index TYPE i.
    DATA lv_trimmed TYPE string.
    DATA lv_upper_line TYPE string.
    DATA lv_include TYPE syrepid.
    DATA lv_include_keyword TYPE string.
    DATA ls_trdir TYPE trdir.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-object_name IS INITIAL.
      rv_json = '{"status":"ERROR","message":"object_name is required"}'.
      RETURN.
    ENDIF.

    lv_object_type = to_upper( ls_request-object_type ).
    IF lv_object_type IS INITIAL.
      lv_object_type = 'PROG'.
    ENDIF.
    IF to_upper( ls_request-source_format ) = 'STRING'.
      lv_string_only = abap_true.
    ENDIF.

    CASE lv_object_type.
      WHEN 'PROG' OR 'REPORT'.
        lv_program = to_upper( ls_request-object_name ).
        lv_response_type = 'PROG'.
        lv_response_name = lv_program.
        lv_tadir_object = 'PROG'.

        TRY.
            READ REPORT lv_program INTO lt_source.
          CATCH cx_root INTO DATA(lx_read_report).
            rv_json = |\{"status":"ERROR","stage":"OBJECT_READ","object_type":"PROG",| &&
                      |"object_name":"{ lv_program }",| &&
                      |"message":"{ escape( val = lx_read_report->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
            RETURN.
        ENDTRY.

        IF sy-subrc <> 0.
          rv_json = |\{"status":"ERROR","stage":"OBJECT_READ","object_type":"PROG",| &&
                    |"object_name":"{ lv_program }","message":"Program source could not be read"\}|.
          RETURN.
        ENDIF.
        lt_syntax_source = lt_source.

      WHEN 'CLAS' OR 'CLASS'.
        lv_class = to_upper( ls_request-object_name ).
        lv_program = |{ lv_class WIDTH = 30 PAD = '=' }CP|.
        lv_response_type = 'CLAS'.
        lv_response_name = lv_class.
        lv_tadir_object = 'CLAS'.

        TRY.
            READ REPORT lv_program INTO lt_main_source.
          CATCH cx_root INTO DATA(lx_read_class).
            rv_json = |\{"status":"ERROR","stage":"CLASS_POOL_READ","object_type":"CLAS",| &&
                      |"object_name":"{ lv_class }","class_pool_program":"{ lv_program }",| &&
                      |"message":"{ escape( val = lx_read_class->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
            RETURN.
        ENDTRY.

        IF sy-subrc <> 0.
          rv_json = |\{"status":"ERROR","stage":"CLASS_POOL_READ","object_type":"CLAS",| &&
                    |"object_name":"{ lv_class }","class_pool_program":"{ lv_program }",| &&
                    |"message":"Class pool source could not be read"\}|.
          RETURN.
        ENDIF.

        LOOP AT lt_main_source INTO DATA(lv_class_source_line).
          APPEND lv_class_source_line TO lt_source.

          lv_trimmed = lv_class_source_line.
          SHIFT lv_trimmed LEFT DELETING LEADING space.
          lv_upper_line = to_upper( lv_trimmed ).
          IF lv_upper_line = 'INCLUDE METHODS.'.
            CLEAR lt_method_includes.
            ls_clskey-clsname = lv_class.
            CALL FUNCTION 'SEO_CLASS_GET_METHOD_INCLUDES'
              EXPORTING
                clskey   = ls_clskey
              IMPORTING
                includes = lt_method_includes
              EXCEPTIONS
                OTHERS   = 1.
            IF sy-subrc = 0.
              LOOP AT lt_method_includes INTO DATA(ls_method_include).
                CLEAR lt_include_source.
                READ REPORT ls_method_include-incname INTO lt_include_source.
                IF sy-subrc = 0.
                  APPEND |* >>> BEGIN METHOD INCLUDE { ls_method_include-incname }| TO lt_source.
                  APPEND LINES OF lt_include_source TO lt_source.
                  APPEND |* <<< END METHOD INCLUDE { ls_method_include-incname }| TO lt_source.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ELSEIF lv_upper_line CP 'INCLUDE *'.
            SPLIT lv_upper_line AT space INTO lv_include_keyword lv_include.
            SPLIT lv_include AT '"' INTO lv_include DATA(lv_include_comment).
            REPLACE ALL OCCURRENCES OF '.' IN lv_include WITH ''.
            CONDENSE lv_include NO-GAPS.
            IF lv_include IS NOT INITIAL.
              CLEAR lt_include_source.
              READ REPORT lv_include INTO lt_include_source.
              IF sy-subrc = 0.
                APPEND |* >>> BEGIN INCLUDE { lv_include }| TO lt_source.
                APPEND LINES OF lt_include_source TO lt_source.
                APPEND |* <<< END INCLUDE { lv_include }| TO lt_source.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
        lt_syntax_source = lt_main_source.

      WHEN OTHERS.
        rv_json = |\{"status":"ERROR","stage":"OBJECT_READ","object_name":"{ ls_request-object_name }",| &&
                  |"message":"Only PROG/REPORT and CLAS/CLASS source read are implemented"\}|.
        RETURN.
    ENDCASE.

    LOOP AT lt_source INTO DATA(lv_source_line).
      lv_index = sy-tabix.
      lv_line_count = lv_line_count + 1.
      lv_trimmed = lv_source_line.
      CONDENSE lv_trimmed.
      IF lv_trimmed IS NOT INITIAL.
        lv_non_empty_count = lv_non_empty_count + 1.
      ENDIF.
      IF lv_trimmed CP '*'.
        lv_comment_count = lv_comment_count + 1.
      ENDIF.

      IF lv_source_code IS INITIAL.
        lv_source_code = lv_source_line.
      ELSE.
        lv_source_code = lv_source_code && cl_abap_char_utilities=>newline && lv_source_line.
      ENDIF.

      IF lv_string_only = abap_false.
        IF lv_source_lines <> '['.
          lv_source_lines = lv_source_lines && ','.
        ENDIF.
        lv_source_lines = lv_source_lines &&
          |\{"line":{ lv_index },| &&
          |"source":"{ escape( val = lv_source_line format = cl_abap_format=>e_json_string ) }"\}|.
      ENDIF.
    ENDLOOP.

    IF lv_string_only = abap_false.
      lv_source_lines = lv_source_lines && ']'.
    ENDIF.

    " Keep /object/read syntax status aligned with /object/check and
    " saved reports; otherwise read results can falsely report FIXPT errors.
    CLEAR ls_trdir.
    ls_trdir-name = lv_program.
    ls_trdir-subc = '1'.
    ls_trdir-fixpt = abap_true.
    ls_trdir-uccheck = abap_true.
    ls_trdir-appl = space.

    SYNTAX-CHECK FOR lt_syntax_source
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word
      PROGRAM lv_program
      DIRECTORY ENTRY ls_trdir.

    lv_tadir_json = get_tadir_json(
      iv_pgmid       = 'R3TR'
      iv_object_type = lv_tadir_object
      iv_object_name = lv_response_name ).

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"{ lv_response_type }","object_name":"{ lv_response_name }",| &&
                |"program":"{ lv_program }",| &&
                |"tadir":{ lv_tadir_json },| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"OK","messages":[]\},| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_ANALYZE","object_type":"{ lv_response_type }","object_name":"{ lv_response_name }",| &&
                |"program":"{ lv_program }",| &&
                |"tadir":{ lv_tadir_json },| &&
                |"line_count":{ lv_line_count },| &&
                |"non_empty_line_count":{ lv_non_empty_count },| &&
                |"comment_line_count":{ lv_comment_count },| &&
                |"syntax":\{"status":"ERROR","messages":[\{| &&
                |"severity":"E","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}]\},| &&
                |"source_code":"{ escape( val = lv_source_code format = cl_abap_format=>e_json_string ) }"|.
      IF lv_string_only = abap_false.
        rv_json = rv_json && |,"source_lines":{ lv_source_lines }|.
      ENDIF.
      rv_json = rv_json && |\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->REGISTER_CLASS_TADIR_ENTRIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CLASS_NAME                  TYPE        SEOCLSNAME
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD register_class_tadir_entries.
    DATA lv_package TYPE devclass.
    DATA lv_class TYPE tadir-obj_name.
    DATA lv_result TYPE string.

    lv_package = iv_package.
    lv_class = to_upper( iv_class_name ).

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    lv_result = register_tadir_entry( iv_pgmid = 'R3TR' iv_object_type = 'CLAS' iv_object_name = lv_class iv_package = lv_package ).
    IF lv_result CS '"status":"ERROR"'.
      rv_json = lv_result.
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"CLAS","object_name":"{ lv_class }","message":"Class TADIR entries registered"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->REGISTER_CTS_OBJECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OBJECT_TYPE                 TYPE        TROBJTYPE
* | [--->] IV_OBJECT_NAME                 TYPE        CSEQUENCE
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD register_cts_object.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.
    DATA lv_object TYPE tadir-obj_name.
    DATA lv_object_type TYPE trobjtype.
    DATA lv_result TYPE string.

    lv_package = iv_package.
    lv_transport = iv_transport.
    lv_object = to_upper( iv_object_name ).
    lv_object_type = iv_object_type.

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    lv_result = register_tadir_entry(
      iv_pgmid       = 'R3TR'
      iv_object_type = lv_object_type
      iv_object_name = lv_object
      iv_package     = lv_package ).
    IF lv_result CS '"status":"ERROR"'.
      rv_json = lv_result.
      RETURN.
    ENDIF.

    IF lv_package = '$TMP'.
      rv_json = |\{"status":"OK","object_type":"{ lv_object_type }","object_name":"{ lv_object }",| &&
                |"package":"{ lv_package }","message":"Local object registered in TADIR; CTS append skipped"\}|.
      RETURN.
    ENDIF.

    IF lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_REGISTER","object_type":"{ lv_object_type }",| &&
                |"object_name":"{ lv_object }","message":"transport is required for package { lv_package }",| &&
                |"suggestion":"Pass a modifiable Workbench request or use package $TMP"\}|.
      RETURN.
    ENDIF.

    lv_result = append_cts_object(
      iv_object_type = lv_object_type
      iv_object_name = lv_object
      iv_transport   = lv_transport ).
    IF lv_result CS '"status":"ERROR"'.
      rv_json = lv_result.
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"{ lv_object_type }","object_name":"{ lv_object }",| &&
              |"package":"{ lv_package }","transport":"{ lv_transport }","message":"Object registered in CTS"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->REGISTER_TADIR_ENTRY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PGMID                       TYPE        TADIR-PGMID
* | [--->] IV_OBJECT_TYPE                 TYPE        TADIR-OBJECT
* | [--->] IV_OBJECT_NAME                 TYPE        CSEQUENCE
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD register_tadir_entry.
    DATA lv_pgmid TYPE tadir-pgmid.
    DATA lv_object_type TYPE tadir-object.
    DATA lv_object TYPE tadir-obj_name.
    DATA lv_package TYPE devclass.
    DATA lv_srcsystem TYPE tadir-srcsystem.
    DATA lv_author TYPE tadir-author.
    DATA lv_masterlang TYPE tadir-masterlang.
    DATA lv_no_pak_check TYPE tadir-paknocheck.
    DATA lv_test_modus TYPE trpari-s_checked.

    lv_pgmid = iv_pgmid.
    lv_object_type = iv_object_type.
    lv_object = to_upper( iv_object_name ).
    lv_package = iv_package.
    lv_srcsystem = sy-sysid.
    lv_author = sy-uname.
    lv_masterlang = sy-langu.
    lv_no_pak_check = 'X'.
    lv_test_modus = space.
    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    TRY.
        CALL FUNCTION 'TR_TADIR_INTERFACE'
          EXPORTING
            wi_test_modus       = lv_test_modus
            wi_tadir_pgmid      = lv_pgmid
            wi_tadir_object     = lv_object_type
            wi_tadir_obj_name   = lv_object
            wi_tadir_srcsystem  = lv_srcsystem
            wi_tadir_author     = lv_author
            wi_tadir_devclass   = lv_package
            wi_tadir_masterlang = lv_masterlang
            iv_no_pak_check     = lv_no_pak_check
          EXCEPTIONS
            OTHERS              = 1.
      CATCH cx_root INTO DATA(lx_tadir).
        rv_json = |\{"status":"ERROR","stage":"TADIR_REGISTER_EXCEPTION","object_type":"{ lv_object_type }",| &&
                  |"object_name":"{ lv_object }",| &&
                  |"message":"{ escape( val = lx_tadir->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'TADIR_REGISTER'
        iv_object_type = lv_object_type
        iv_object_name = lv_object
        iv_message     = 'TR_TADIR_INTERFACE failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check package, object directory authorization, and whether the object is reserved or locked' ).
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"{ lv_object_type }","object_name":"{ lv_object }","message":"TADIR entry registered"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD run.
    DATA(lv_ddic_result) = create_ddic_from_json( iv_json ).
    IF lv_ddic_result CS '"status":"ERROR"'.
      rv_json = |\{"status":"ERROR","stage":"DDIC_CREATE","ddic":{ lv_ddic_result },"message":"DDIC creation failed; source save and program check were skipped"\}|.
      RETURN.
    ENDIF.

    DATA(lv_check_result) = check_from_json( iv_json ).
    IF lv_check_result CS '"status":"ERROR"'.
      rv_json = |\{"status":"ERROR","stage":"SYNTAX_CHECK","ddic":{ lv_ddic_result },| &&
                |"check":{ lv_check_result },| &&
                |"message":"Syntax check failed; source save and activation were skipped"\}|.
      RETURN.
    ENDIF.

    DATA(lv_save_result) = save_source_from_json( iv_json ).
    IF lv_save_result CS '"status":"ERROR"'.
      rv_json = |\{"status":"ERROR","stage":"SOURCE_SAVE","ddic":{ lv_ddic_result },| &&
                |"check":{ lv_check_result },"save":{ lv_save_result },| &&
                |"message":"Source save failed; activation was skipped"\}|.
      RETURN.
    ENDIF.

    DATA(lv_activate_result) = activate_from_json( iv_json ).
    rv_json = |\{"status":"OK","ddic":{ lv_ddic_result },"check":{ lv_check_result },"save":{ lv_save_result },"activate":{ lv_activate_result }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_CLASS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_SOURCE_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_class.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_class TYPE seoclsname.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.
    DATA lv_cts_result TYPE string.
    DATA lv_tadir_result TYPE string.
    DATA ls_class TYPE vseoclass.
    DATA lv_lock_class TYPE seoclsenq-clsname.
    DATA lv_synchron TYPE ddenq_like-synchron.
    DATA lt_declarations TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_declaration TYPE string.
    DATA lv_collect_declaration TYPE abap_bool.
    DATA lv_in_public_section TYPE abap_bool.
    DATA lv_in_implementation TYPE abap_bool.
    DATA lv_collect_source TYPE abap_bool.
    DATA lv_line_upper TYPE string.
    DATA lv_work TYPE string.
    DATA lt_tokens TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_token TYPE string.
    DATA lv_next TYPE string.
    DATA lv_next2 TYPE string.
    DATA lv_method_name TYPE seocmpname.
    DATA lv_param_name TYPE seosconame.
    DATA lv_param_type TYPE rs38l_typ.
    DATA lv_param_decl TYPE seopardecl.
    DATA lv_has_param_decl TYPE abap_bool.
    DATA lv_order TYPE i.
    DATA lv_index TYPE sy-tabix.
    DATA lv_next_index TYPE sy-tabix.
    DATA lv_next2_index TYPE sy-tabix.
    DATA lt_methods TYPE seoo_methods_r.
    DATA ls_method LIKE LINE OF lt_methods.
    DATA lt_parameters TYPE seos_parameters_r.
    DATA ls_parameter LIKE LINE OF lt_parameters.
    DATA lt_method_sources TYPE seo_method_source_table.
    DATA ls_method_source LIKE LINE OF lt_method_sources.

    SPLIT is_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.
    lv_class = to_upper( is_request-object_name ).
    lv_package = to_upper( is_request-package ).
    lv_transport = to_upper( is_request-transport ).

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    IF is_z_object_name( lv_class ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_NAME_VALIDATE","object_type":"CLAS",| &&
                |"object_name":"{ lv_class }",| &&
                |"message":"Only Z* object names are allowed for API-created objects"\}|.
      RETURN.
    ENDIF.

    IF lv_package <> '$TMP' AND lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_VALIDATE","object_type":"CLAS",| &&
                |"message":"transport is required when package is not $TMP",| &&
                |"suggestion":"Pass a modifiable Workbench request in transport or use package $TMP"\}|.
      RETURN.
    ENDIF.

    ls_class-clsname = lv_class.
    ls_class-descript = lv_class.
    ls_class-exposure = '2'.
    ls_class-state = '1'.
    ls_class-clsfinal = 'X'.
    ls_class-fixpt = 'X'.
    ls_class-langu = sy-langu.
    ls_class-author = sy-uname.
    ls_class-createdon = sy-datum.
    ls_class-changedby = sy-uname.
    ls_class-changedon = sy-datum.

    LOOP AT lt_source INTO DATA(lv_source_line).
      lv_line_upper = to_upper( lv_source_line ).
      CONDENSE lv_line_upper.

      IF lv_line_upper CS 'PUBLIC SECTION.'.
        lv_in_public_section = abap_true.
        CONTINUE.
      ENDIF.

      IF lv_line_upper CS 'PROTECTED SECTION.' OR lv_line_upper CS 'PRIVATE SECTION.'.
        lv_in_public_section = abap_false.
        CONTINUE.
      ENDIF.

      IF lv_line_upper CS 'IMPLEMENTATION.'.
        lv_in_public_section = abap_false.
        lv_in_implementation = abap_true.
        CONTINUE.
      ENDIF.

      IF lv_in_public_section = abap_true.
        IF lv_collect_declaration = abap_true.
          lv_declaration = lv_declaration && ` ` && lv_line_upper.
          IF lv_line_upper CS '.'.
            APPEND lv_declaration TO lt_declarations.
            CLEAR lv_declaration.
            lv_collect_declaration = abap_false.
          ENDIF.
        ELSEIF lv_line_upper CP 'METHODS *'.
          lv_declaration = lv_line_upper.
          IF lv_line_upper CS '.'.
            APPEND lv_declaration TO lt_declarations.
            CLEAR lv_declaration.
          ELSE.
            lv_collect_declaration = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_in_implementation = abap_true.
        IF lv_collect_source = abap_true.
          IF lv_line_upper CP 'ENDMETHOD*'.
            APPEND ls_method_source TO lt_method_sources.
            CLEAR ls_method_source.
            lv_collect_source = abap_false.
          ELSE.
            APPEND lv_source_line TO ls_method_source-source.
          ENDIF.
        ELSEIF lv_line_upper CP 'METHOD *'.
          CLEAR lt_tokens.
          lv_work = lv_line_upper.
          REPLACE ALL OCCURRENCES OF '.' IN lv_work WITH space.
          CONDENSE lv_work.
          SPLIT lv_work AT space INTO TABLE lt_tokens.
          READ TABLE lt_tokens INDEX 2 INTO lv_token.
          IF sy-subrc = 0.
            ls_method_source-cpdname = lv_token.
            lv_collect_source = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_declarations INTO lv_declaration.
      CLEAR lt_tokens.
      lv_work = lv_declaration.
      REPLACE ALL OCCURRENCES OF '.' IN lv_work WITH space.
      REPLACE ALL OCCURRENCES OF ',' IN lv_work WITH space.
      CONDENSE lv_work.
      SPLIT lv_work AT space INTO TABLE lt_tokens.

      READ TABLE lt_tokens INDEX 2 INTO lv_method_name.
      IF sy-subrc <> 0 OR lv_method_name IS INITIAL.
        CONTINUE.
      ENDIF.

      lv_order = lv_order + 1.
      CLEAR ls_method.
      ls_method-clsname = lv_class.
      ls_method-cmpname = lv_method_name.
      ls_method-version = seoc_version_active.
      ls_method-langu = sy-langu.
      ls_method-descript = lv_method_name.
      ls_method-exposure = '2'.
      ls_method-state = '1'.
      ls_method-editorder = lv_order.
      ls_method-author = sy-uname.
      ls_method-createdon = sy-datum.
      ls_method-changedby = sy-uname.
      ls_method-changedon = sy-datum.
      ls_method-mtdtype = '0'.
      ls_method-mtddecltyp = '0'.
      APPEND ls_method TO lt_methods.

      CLEAR: lv_param_decl, lv_has_param_decl.
      LOOP AT lt_tokens INTO lv_token.
        CASE lv_token.
          WHEN 'IMPORTING'.
            lv_param_decl = '0'.
            lv_has_param_decl = abap_true.
            CONTINUE.
          WHEN 'EXPORTING'.
            lv_param_decl = '1'.
            lv_has_param_decl = abap_true.
            CONTINUE.
          WHEN 'CHANGING'.
            lv_param_decl = '2'.
            lv_has_param_decl = abap_true.
            CONTINUE.
          WHEN 'RETURNING'.
            lv_param_decl = '3'.
            lv_has_param_decl = abap_true.
            CONTINUE.
          WHEN 'TYPE'.
            CONTINUE.
        ENDCASE.

        IF lv_has_param_decl <> abap_true.
          CONTINUE.
        ENDIF.

        lv_index = sy-tabix.
        lv_next_index = lv_index + 1.
        lv_next2_index = lv_index + 2.
        CLEAR: lv_next, lv_next2.
        READ TABLE lt_tokens INDEX lv_next_index INTO lv_next.
        READ TABLE lt_tokens INDEX lv_next2_index INTO lv_next2.
        IF lv_param_decl = '3'.
          IF lv_token CS 'VALUE('.
            lv_param_name = lv_token.
            REPLACE ALL OCCURRENCES OF 'VALUE(' IN lv_param_name WITH space.
            REPLACE ALL OCCURRENCES OF ')' IN lv_param_name WITH space.
            CONDENSE lv_param_name.
            IF lv_next = 'TYPE' AND lv_next2 IS NOT INITIAL.
              lv_param_type = lv_next2.
            ELSE.
              CONTINUE.
            ENDIF.
          ELSE.
            CONTINUE.
          ENDIF.
        ELSE.
          IF lv_next = 'TYPE' AND lv_next2 IS NOT INITIAL.
            lv_param_name = lv_token.
            lv_param_type = lv_next2.
          ELSE.
            CONTINUE.
          ENDIF.
        ENDIF.

        CLEAR ls_parameter.
        ls_parameter-clsname = lv_class.
        ls_parameter-cmpname = lv_method_name.
        ls_parameter-sconame = lv_param_name.
        ls_parameter-version = seoc_version_active.
        ls_parameter-langu = sy-langu.
        ls_parameter-descript = lv_param_name.
        ls_parameter-cmptype = '1'.
        ls_parameter-mtdtype = '0'.
        ls_parameter-editorder = sy-tabix.
        ls_parameter-author = sy-uname.
        ls_parameter-createdon = sy-datum.
        ls_parameter-changedby = sy-uname.
        ls_parameter-changedon = sy-datum.
        ls_parameter-pardecltyp = lv_param_decl.
        IF lv_param_decl = '3'.
          ls_parameter-parpasstyp = '0'.
        ELSE.
          ls_parameter-parpasstyp = '1'.
        ENDIF.
        ls_parameter-typtype = '1'.
        ls_parameter-type = lv_param_type.
        APPEND ls_parameter TO lt_parameters.
      ENDLOOP.
    ENDLOOP.

    IF lt_methods IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CLASS_PARSE","object_type":"CLAS",| &&
                |"object_name":"{ lv_class }",| &&
                |"message":"No public method declarations could be parsed",| &&
                |"suggestion":"Generate a public class with METHODS declarations before saving"\}|.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
        devclass        = lv_package
        overwrite       = abap_true
        version         = seoc_version_active
        genflag         = space
        authority_check = abap_false
        suppress_dialog = abap_true
        suppress_corr   = abap_true
        method_sources  = lt_method_sources
        suppress_unlock = abap_false
      CHANGING
        class           = ls_class
        methods         = lt_methods
        parameters      = lt_parameters
      EXCEPTIONS
        OTHERS          = 1.

    IF sy-subrc <> 0.
      rv_json = build_fm_error_json(
        iv_stage       = 'CLASS_CREATE'
        iv_object_type = 'CLAS'
        iv_object_name = lv_class
        iv_message     = 'SEO_CLASS_CREATE_COMPLETE failed'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check class name, package, authorization, and Class Builder function signature' ).
      RETURN.
    ENDIF.

    lv_lock_class = lv_class.
    lv_synchron = 'X'.
    CALL FUNCTION 'DEQUEUE_ESEOCLASS'
      EXPORTING
        clsname   = lv_lock_class
        _synchron = lv_synchron
      EXCEPTIONS
        OTHERS   = 1.

    CALL FUNCTION 'DEQUEUE_ALL'
      EXPORTING
        _synchron = lv_synchron
      EXCEPTIONS
        OTHERS    = 1.

    lv_tadir_result = register_class_tadir_entries(
      iv_class_name = lv_class
      iv_package    = lv_package ).
    IF lv_tadir_result CS '"status":"ERROR"'.
      rv_json = lv_tadir_result.
      RETURN.
    ENDIF.

    lv_cts_result = register_cts_object(
      iv_object_type = 'CLAS'
      iv_object_name = lv_class
      iv_package     = lv_package
      iv_transport   = lv_transport ).
    IF lv_cts_result CS '"status":"ERROR"'.
      rv_json = lv_cts_result.
      RETURN.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"CLAS","object_name":"{ lv_class }","message":"Class saved"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_FUGR_MAIN_SOURCE_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_fugr_main_source_json.
    DATA ls_request TYPE ty_fugr_main_source_request.
    DATA lv_program TYPE syrepid.
    DATA lv_group TYPE string.
    DATA lv_allowed_include_prefix TYPE string.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_trimmed TYPE string.
    DATA lv_include TYPE string.
    DATA lv_upper_line TYPE string.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_main_json).
        rv_json = |\{"status":"ERROR","stage":"FUGR_MAIN_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_main_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-main_program IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","message":"main_program and source_code are required"}'.
      RETURN.
    ENDIF.

    lv_program = to_upper( ls_request-main_program ).
    IF lv_program NP 'SAPLZ*'.
      rv_json = |\{"status":"ERROR","stage":"FUGR_MAIN_VALIDATE","object_type":"PROG",| &&
                |"object_name":"{ lv_program }",| &&
                |"message":"Only SAPLZ* function group main programs can be changed through this API"\}|.
      RETURN.
    ENDIF.

    lv_group = lv_program+4.
    lv_allowed_include_prefix = |L{ lv_group }|.

    SPLIT ls_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.

    LOOP AT lt_source INTO DATA(lv_source_line).
      lv_trimmed = lv_source_line.
      SHIFT lv_trimmed LEFT DELETING LEADING space.
      IF lv_trimmed IS INITIAL OR lv_trimmed(1) = '*'.
        CONTINUE.
      ENDIF.

      lv_upper_line = to_upper( lv_trimmed ).
      IF lv_upper_line CP 'INCLUDE *'.
        SPLIT lv_upper_line AT space INTO DATA(lv_include_keyword) lv_include.
        REPLACE ALL OCCURRENCES OF '.' IN lv_include WITH ''.
        rv_json = validate_fugr_include_write(
          iv_function_group  = lv_group
          iv_include         = lv_include
          iv_allow_u_include = abap_true ).
        IF rv_json IS NOT INITIAL.
          rv_json = |\{"status":"ERROR","stage":"FUGR_MAIN_INCLUDE_VALIDATE","object_type":"PROG",| &&
                    |"object_name":"{ lv_program }",| &&
                    |"message":"Main program source may only include generated includes for its own Z function group",| &&
                    |"include":"{ lv_include }",| &&
                    |"detail":{ rv_json }\}|.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.

    TRY.
        INSERT REPORT lv_program FROM lt_source.
      CATCH cx_root INTO DATA(lx_main_source).
        rv_json = |\{"status":"ERROR","stage":"FUGR_MAIN_SOURCE_SAVE",| &&
                  |"object_type":"PROG","object_name":"{ lv_program }",| &&
                  |"message":"{ escape( val = lx_main_source->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    GENERATE REPORT lv_program
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_type":"PROG","object_name":"{ lv_program }",| &&
                |"message":"Function group main program source saved and generated"\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"FUGR_MAIN_GENERATE","object_type":"PROG",| &&
                |"object_name":"{ lv_program }",| &&
                |"line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }"\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_FUNCTION_SOURCE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_function_source_from_json.
    DATA ls_request TYPE ty_function_source_request.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_include TYPE rs38l-include.
    DATA lv_namespace TYPE rs38l-namespace.
    DATA lv_str_area TYPE rs38l-str_area.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_source_json).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_SOURCE_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_source_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-function_name IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","message":"function_name and source_code are required"}'.
      RETURN.
    ENDIF.

    lv_function_name = to_upper( ls_request-function_name ).
    IF is_z_object_name( lv_function_name ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_NAME_VALIDATE","object_type":"FUNC",| &&
                |"object_name":"{ lv_function_name }",| &&
                |"message":"Only Z* function modules can be changed through this API"\}|.
      RETURN.
    ENDIF.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = lv_function_name
      IMPORTING
        group              = lv_function_group
        include            = lv_include
        namespace          = lv_namespace
        str_area           = lv_str_area
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.

    IF sy-subrc <> 0 OR lv_include IS INITIAL.
      rv_json = build_fm_error_json(
        iv_stage       = 'FUNCTION_EXISTS'
        iv_object_type = 'FUNC'
        iv_object_name = lv_function_name
        iv_message     = 'Function module does not exist or include cannot be determined'
        iv_subrc       = sy-subrc
        iv_suggestion  = 'Check function module name and authorization' ).
      RETURN.
    ENDIF.

    rv_json = validate_fugr_include_write(
      iv_function_group  = lv_function_group
      iv_include         = lv_include
      iv_allow_u_include = abap_true ).
    IF rv_json IS NOT INITIAL.
      RETURN.
    ENDIF.

    SPLIT ls_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.

    TRY.
        INSERT REPORT lv_include FROM lt_source PROGRAM TYPE 'I'.
      CATCH cx_root INTO DATA(lx_function_source).
        rv_json = |\{"status":"ERROR","stage":"FUNCTION_SOURCE_SAVE",| &&
                  |"object_type":"FUNC","object_name":"{ lv_function_name }",| &&
                  |"include":"{ lv_include }",| &&
                  |"message":"{ escape( val = lx_function_source->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                  |"suggestion":"Pass complete FUNCTION...ENDFUNCTION source for the generated function include"\}|.
        RETURN.
    ENDTRY.

    rv_json = |\{"status":"OK","object_type":"FUNC","object_name":"{ lv_function_name }",| &&
              |"function_group":"{ lv_function_group }",| &&
              |"include":"{ lv_include }",| &&
              |"message":"Function include source saved"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_INCLUDE_SOURCE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_include_source_from_json.
    DATA ls_request TYPE ty_include_source_request.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_include TYPE syrepid.
    DATA lv_check_json TYPE string.
    DATA lv_group_len TYPE i.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_include_json).
        rv_json = |\{"status":"ERROR","stage":"INCLUDE_SOURCE_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_include_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-include_name IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","message":"include_name and source_code are required"}'.
      RETURN.
    ENDIF.

    lv_include = to_upper( ls_request-include_name ).
    lv_function_group = to_upper( ls_request-function_group ).
    IF lv_function_group IS INITIAL AND strlen( lv_include ) > 1 AND lv_include+1(1) = 'Z'.
      IF lv_include CP 'L*TOP'.
        lv_group_len = strlen( lv_include ) - 4.
      ELSEIF strlen( lv_include ) > 4.
        lv_group_len = strlen( lv_include ) - 4.
      ENDIF.
      IF lv_group_len > 0.
        lv_function_group = lv_include+1(lv_group_len).
      ENDIF.
    ENDIF.

    rv_json = validate_fugr_include_write(
      iv_function_group  = lv_function_group
      iv_include         = lv_include
      iv_allow_u_include = abap_false ).
    IF rv_json IS NOT INITIAL.
      RETURN.
    ENDIF.

    SPLIT ls_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.

    TRY.
        INSERT REPORT lv_include FROM lt_source PROGRAM TYPE 'I'.
      CATCH cx_root INTO DATA(lx_include_source).
        rv_json = |\{"status":"ERROR","stage":"INCLUDE_SOURCE_SAVE",| &&
                  |"object_type":"INCL","object_name":"{ lv_include }",| &&
                  |"message":"{ escape( val = lx_include_source->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                  |"suggestion":"Pass complete include source and ensure the generated include exists or can be created"\}|.
        RETURN.
    ENDTRY.

    IF ls_request-check_function IS NOT INITIAL.
      lv_check_json = check_function_from_json( |\{"function_name":"{ to_upper( ls_request-check_function ) }"\}| ).
      IF lv_check_json CS '"status":"ERROR"'.
        rv_json = |\{"status":"ERROR","stage":"INCLUDE_SOURCE_CHECK",| &&
                  |"object_type":"INCL","object_name":"{ lv_include }",| &&
                  |"check":{ lv_check_json }\}|.
        RETURN.
      ENDIF.
    ENDIF.

    rv_json = |\{"status":"OK","object_type":"INCL","object_name":"{ lv_include }",| &&
              |"function_group":"{ lv_function_group }",| &&
              |"message":"Include source saved"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_REPORT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_SOURCE_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_report.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_program TYPE progname.
    DATA lv_package TYPE devclass.
    DATA lv_transport TYPE trkorr.
    DATA lv_cts_result TYPE string.
    DATA lv_program_type TYPE string.
    DATA lv_subc TYPE string.
    DATA ls_trdir TYPE trdir.

    SPLIT is_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.
    lv_program = to_upper( is_request-object_name ).
    lv_package = to_upper( is_request-package ).
    lv_transport = to_upper( is_request-transport ).
    lv_program_type = to_upper( is_request-program_type ).
    lv_subc = to_upper( is_request-subc ).

    IF lv_package IS INITIAL.
      lv_package = '$TMP'.
    ENDIF.

    IF is_z_object_name( lv_program ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"OBJECT_NAME_VALIDATE","object_type":"PROG",| &&
                |"object_name":"{ lv_program }",| &&
                |"message":"Only Z* object names are allowed for API-created objects"\}|.
      RETURN.
    ENDIF.

    IF lv_package <> '$TMP' AND lv_transport IS INITIAL.
      rv_json = |\{"status":"ERROR","stage":"CTS_VALIDATE","object_type":"PROG",| &&
                |"message":"transport is required when package is not $TMP",| &&
                |"suggestion":"Pass a modifiable Workbench request in transport or use package $TMP"\}|.
      RETURN.
    ENDIF.

    IF lv_program_type = 'I' OR lv_subc = 'I'.
      TRY.
          INSERT REPORT lv_program FROM lt_source PROGRAM TYPE 'I'.
        CATCH cx_root INTO DATA(lx_include_program).
          rv_json = |\{"status":"ERROR","stage":"INCLUDE_SOURCE_SAVE","object_type":"PROG",| &&
                    |"object_name":"{ is_request-object_name }",| &&
                    |"program_type":"I",| &&
                    |"message":"{ escape( val = lx_include_program->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                    |"suggestion":"Fix the ABAP include source object name or source format and retry"\}|.
          RETURN.
      ENDTRY.
    ELSE.
      ls_trdir-name = lv_program.
      ls_trdir-subc = '1'.
      ls_trdir-appl = space.
      ls_trdir-fixpt = 'X'.
      ls_trdir-uccheck = 'X'.

      TRY.
          INSERT REPORT lv_program FROM lt_source DIRECTORY ENTRY ls_trdir.
        CATCH cx_root INTO DATA(lx_program).
          rv_json = |\{"status":"ERROR","stage":"SOURCE_SAVE","object_type":"PROG",| &&
                    |"object_name":"{ is_request-object_name }",| &&
                    |"message":"{ escape( val = lx_program->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                    |"suggestion":"Fix the ABAP source object name or source format and retry"\}|.
          RETURN.
      ENDTRY.
    ENDIF.

    TRY.
        lv_cts_result = register_cts_object(
          iv_object_type = 'PROG'
          iv_object_name = lv_program
          iv_package     = lv_package
          iv_transport   = lv_transport ).
        IF lv_cts_result CS '"status":"ERROR"'.
          rv_json = lv_cts_result.
          RETURN.
        ENDIF.
      CATCH cx_root INTO DATA(lx_program_cts).
        rv_json = |\{"status":"ERROR","stage":"SOURCE_CTS_REGISTER","object_type":"PROG",| &&
                  |"object_name":"{ is_request-object_name }",| &&
                  |"message":"{ escape( val = lx_program_cts->get_text( ) format = cl_abap_format=>e_json_string ) }",| &&
                  |"suggestion":"Check package/request registration types and CTS authorization"\}|.
        RETURN.
    ENDTRY.

    rv_json = |\{"status":"OK","object_type":"PROG","object_name":"{ is_request-object_name }",| &&
              |"program_type":"{ COND string( WHEN lv_program_type = 'I' OR lv_subc = 'I' THEN 'I' ELSE '1' ) }",| &&
              |"message":"Source saved"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SAVE_SOURCE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_source_from_json.
    DATA ls_request TYPE ty_source_request.

    /ui2/cl_json=>deserialize(
      EXPORTING json = iv_json
      CHANGING  data = ls_request ).

    IF ls_request-object_name IS INITIAL OR ls_request-source_code IS INITIAL.
      rv_json = '{"status":"ERROR","message":"object_name and source_code are required"}'.
      RETURN.
    ENDIF.

    CASE to_upper( ls_request-object_type ).
      WHEN 'PROG' OR 'REPORT'.
        rv_json = save_report( ls_request ).
      WHEN 'CLAS' OR 'CLASS'.
        rv_json = save_class( ls_request ).
      WHEN OTHERS.
        rv_json = '{"status":"ERROR","message":"Only PROG/REPORT and CLAS/CLASS are implemented"}'.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->STATUS_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD status_from_json.
    DATA ls_request TYPE ty_ddic_request.
    DATA lv_results TYPE string VALUE '['.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_status_json).
        rv_json = |\{"status":"ERROR","stage":"DDIC_STATUS_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_status_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    LOOP AT ls_request-domains INTO DATA(ls_domain).
      append_result(
        EXPORTING iv_result = get_domain_status( to_upper( ls_domain-name ) )
        CHANGING cv_json = lv_results ).
    ENDLOOP.

    LOOP AT ls_request-data_elements INTO DATA(ls_data_element).
      append_result(
        EXPORTING iv_result = get_data_element_status( to_upper( ls_data_element-name ) )
        CHANGING cv_json = lv_results ).
    ENDLOOP.

    LOOP AT ls_request-tables INTO DATA(ls_table).
      append_result(
        EXPORTING iv_result = get_table_status( to_upper( ls_table-name ) )
        CHANGING cv_json = lv_results ).
    ENDLOOP.

    lv_results = lv_results && ']'.
    rv_json = |\{"status":"OK","results":{ lv_results }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->SYNTAX_CHECK_SOURCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_CHECK_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD syntax_check_source.
    DATA lt_source TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_message TYPE string.
    DATA lv_line TYPE i.
    DATA lv_word TYPE string.
    DATA ls_trdir TYPE trdir.

    SPLIT is_request-source_code AT cl_abap_char_utilities=>newline INTO TABLE lt_source.

    " Keep /object/check aligned with saved report attributes so valid
    " new Open SQL does not fail due to missing fixed point arithmetic.
    ls_trdir-name = to_upper( is_request-object_name ).
    ls_trdir-subc = '1'.
    ls_trdir-fixpt = abap_true.
    ls_trdir-uccheck = abap_true.
    ls_trdir-appl = space.

    SYNTAX-CHECK FOR lt_source
      MESSAGE lv_message
      LINE lv_line
      WORD lv_word
      PROGRAM is_request-object_name
      DIRECTORY ENTRY ls_trdir.

    IF sy-subrc = 0.
      rv_json = |\{"status":"OK","object_name":"{ is_request-object_name }","messages":[]\}|.
    ELSE.
      rv_json = |\{"status":"ERROR","stage":"SYNTAX_CHECK",| &&
                |"object_name":"{ is_request-object_name }","messages":[\{| &&
                |"severity":"E","line":{ lv_line },| &&
                |"word":"{ escape( val = lv_word format = cl_abap_format=>e_json_string ) }",| &&
                |"message":"{ escape( val = lv_message format = cl_abap_format=>e_json_string ) }",| &&
                |"check_type":"SYNTAX",| &&
                |"suggestion":"Fix the syntax error at the returned line and word, then retry"\}]\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->TABLE_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_EXISTS                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD table_exists.
    DATA lv_tabname TYPE dd02l-tabname.

    SELECT SINGLE tabname
      FROM dd02l
      INTO lv_tabname
      WHERE tabname = iv_name
        AND as4local <> 'D'.

    rv_exists = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->TEXTPOOL_SAVE_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD textpool_save_from_json.
    TYPES: BEGIN OF ty_textpool_work,
             requested_key TYPE string,
             id            TYPE string,
             key           TYPE string,
             entry         TYPE string,
           END OF ty_textpool_work.
    TYPES tt_textpool_work TYPE STANDARD TABLE OF ty_textpool_work WITH EMPTY KEY.

    DATA ls_request TYPE ty_textpool_save_request.
    DATA ls_work TYPE ty_textpool_work.
    DATA lt_work TYPE tt_textpool_work.
    DATA lt_check TYPE tt_textpool_work.
    DATA ls_previous TYPE ty_textpool_work.
    DATA lv_object_type TYPE string.
    DATA lv_object_name TYPE string.
    DATA lv_program TYPE syrepid.
    DATA lv_language TYPE spras.
    DATA lv_transport TYPE trkorr.
    DATA lv_function_group TYPE rs38l-area.
    DATA lv_function_name TYPE rs38l-name.
    DATA lv_program_from_fm TYPE tfdir-pname.
    DATA lv_id TYPE c LENGTH 1.
    DATA lv_requested_key TYPE string.
    DATA lv_entry TYPE string.
    DATA lv_max_key TYPE textpool-key.
    DATA lv_next_key_i TYPE i.
    DATA lv_next_key_n TYPE n LENGTH 3.
    DATA lv_prev_index TYPE sy-tabix.
    DATA lv_cts_object_type TYPE e071-object.
    DATA lv_cts_object_name TYPE tadir-obj_name.
    DATA lv_exists_program TYPE progname.
    DATA lv_cts_json TYPE string VALUE 'null'.
    DATA lv_results_json TYPE string VALUE '['.
    DATA lv_has_error TYPE abap_bool.
    DATA lt_textpool TYPE STANDARD TABLE OF textpool WITH EMPTY KEY.
    DATA lt_after TYPE STANDARD TABLE OF textpool WITH EMPTY KEY.
    DATA ls_textpool TYPE textpool.
    DATA ls_after TYPE textpool.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).
      CATCH cx_root INTO DATA(lx_textpool_json).
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_JSON_PARSE",| &&
                  |"message":"{ escape( val = lx_textpool_json->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
        RETURN.
    ENDTRY.

    lv_object_type = to_upper( ls_request-object_type ).
    lv_object_name = to_upper( ls_request-object_name ).
    lv_language = to_upper( ls_request-language ).
    lv_transport = to_upper( ls_request-transport ).
    IF lv_language IS INITIAL.
      lv_language = sy-langu.
    ENDIF.

    IF ls_request-texts IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"TEXTPOOL_VALIDATE","message":"texts are required"}'.
      RETURN.
    ENDIF.

    CASE lv_object_type.
      WHEN 'PROG' OR 'REPORT'.
        lv_program = lv_object_name.
        IF lv_program IS INITIAL OR is_z_object_name( lv_program ) = abap_false.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"object_type":"{ lv_object_type }","object_name":"{ escape( val = lv_object_name format = cl_abap_format=>e_json_string ) }",| &&
                    |"message":"Only Z* reports/programs can be changed through this API"\}|.
          RETURN.
        ENDIF.
      WHEN 'FUGR'.
        lv_function_group = to_upper( ls_request-function_group ).
        IF lv_function_group IS INITIAL.
          lv_function_group = lv_object_name.
        ENDIF.
        IF lv_function_group CP 'SAPL*'.
          lv_function_group = lv_function_group+4.
        ENDIF.
        IF lv_function_group IS INITIAL OR is_z_object_name( lv_function_group ) = abap_false.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"object_type":"FUGR","object_name":"{ escape( val = lv_function_group format = cl_abap_format=>e_json_string ) }",| &&
                    |"message":"Only Z* function groups can be changed through this API"\}|.
          RETURN.
        ENDIF.
        lv_program = |SAPL{ lv_function_group }|.
        lv_cts_object_type = 'FUGR'.
        lv_cts_object_name = lv_function_group.
      WHEN 'FUNC'.
        lv_function_name = to_upper( ls_request-function_name ).
        IF lv_function_name IS INITIAL.
          lv_function_name = lv_object_name.
        ENDIF.
        IF lv_function_name IS INITIAL OR is_z_object_name( lv_function_name ) = abap_false.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"object_type":"FUNC","object_name":"{ escape( val = lv_function_name format = cl_abap_format=>e_json_string ) }",| &&
                    |"message":"Only Z* function modules can be changed through this API"\}|.
          RETURN.
        ENDIF.
        SELECT SINGLE pname
          FROM tfdir
          INTO @lv_program_from_fm
          WHERE funcname = @lv_function_name.
        IF sy-subrc <> 0 OR lv_program_from_fm IS INITIAL.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"object_type":"FUNC","object_name":"{ lv_function_name }",| &&
                    |"message":"Function module could not be resolved to a function group"\}|.
          RETURN.
        ENDIF.
        lv_program = to_upper( lv_program_from_fm ).
        IF lv_program CP 'SAPLZ*'.
          lv_function_group = lv_program+4.
        ELSE.
          lv_function_group = lv_program.
        ENDIF.
        IF is_z_object_name( lv_function_group ) = abap_false.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"object_type":"FUGR","object_name":"{ lv_function_group }",| &&
                    |"message":"Resolved function group is not Z*"\}|.
          RETURN.
        ENDIF.
        lv_cts_object_type = 'FUGR'.
        lv_cts_object_name = lv_function_group.
      WHEN OTHERS.
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                  |"object_type":"{ escape( val = lv_object_type format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"Supported object_type values are PROG, REPORT, FUGR, and FUNC"\}|.
        RETURN.
    ENDCASE.

    IF lv_program IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"TEXTPOOL_VALIDATE","message":"Could not resolve textpool program"}'.
      RETURN.
    ENDIF.

    IF lv_cts_object_type IS INITIAL.
      lv_cts_object_type = 'PROG'.
      lv_cts_object_name = lv_program.
    ENDIF.

    SELECT SINGLE name
      FROM trdir
      INTO @lv_exists_program
      WHERE name = @lv_program.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                |"program":"{ lv_program }",| &&
                |"message":"Resolved textpool program does not exist"\}|.
      RETURN.
    ENDIF.

    READ TEXTPOOL lv_program INTO lt_textpool LANGUAGE lv_language.
    IF sy-subrc <> 0.
      CLEAR lt_textpool.
    ENDIF.

    LOOP AT ls_request-texts INTO DATA(ls_text).
      lv_id = to_upper( ls_text-id ).
      lv_requested_key = to_upper( ls_text-key ).
      CONDENSE lv_requested_key NO-GAPS.
      lv_entry = ls_text-entry.

      IF lv_id <> 'I' AND lv_id <> 'R' AND lv_id <> 'S'.
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                  |"program":"{ lv_program }",| &&
                  |"id":"{ escape( val = ls_text-id format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"Text id must be I, R, or S"\}|.
        RETURN.
      ENDIF.
      IF lv_entry IS INITIAL.
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                  |"program":"{ lv_program }","id":"{ lv_id }",| &&
                  |"key":"{ escape( val = lv_requested_key format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"entry is required"\}|.
        RETURN.
      ENDIF.
      IF strlen( lv_entry ) > 132.
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                  |"program":"{ lv_program }","id":"{ lv_id }",| &&
                  |"key":"{ escape( val = lv_requested_key format = cl_abap_format=>e_json_string ) }",| &&
                  |"message":"entry exceeds TEXTPOOL-ENTRY length 132"\}|.
        RETURN.
      ENDIF.

      CLEAR ls_work.
      ls_work-id = lv_id.
      ls_work-requested_key = lv_requested_key.
      ls_work-entry = lv_entry.
      IF lv_requested_key = 'AUTO'.
        IF lv_id <> 'I'.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"program":"{ lv_program }","id":"{ lv_id }",| &&
                    |"message":"AUTO key is only supported for text symbols with id I"\}|.
          RETURN.
        ENDIF.
        APPEND ls_work TO lt_work.
      ELSEIF lv_id = 'I'.
        IF lv_requested_key CN '0123456789' OR strlen( lv_requested_key ) <> 3.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"program":"{ lv_program }","id":"I",| &&
                    |"key":"{ escape( val = lv_requested_key format = cl_abap_format=>e_json_string ) }",| &&
                    |"message":"Text symbol key must be AUTO or three digits from 000 to 999"\}|.
          RETURN.
        ENDIF.
        ls_work-key = lv_requested_key.
        APPEND ls_work TO lt_work.
      ELSE.
        IF lv_requested_key IS INITIAL.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"program":"{ lv_program }","id":"{ lv_id }",| &&
                    |"message":"key is required for id R and S"\}|.
          RETURN.
        ENDIF.
        ls_work-key = lv_requested_key.
        APPEND ls_work TO lt_work.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_textpool INTO ls_textpool WHERE id = 'I'.
      IF ls_textpool-key CO '0123456789' AND strlen( ls_textpool-key ) = 3 AND ls_textpool-key > lv_max_key.
        lv_max_key = ls_textpool-key.
      ENDIF.
    ENDLOOP.
    IF lv_max_key IS INITIAL.
      lv_next_key_i = 1.
    ELSE.
      lv_next_key_i = lv_max_key.
      lv_next_key_i = lv_next_key_i + 1.
    ENDIF.

    LOOP AT lt_work INTO ls_work WHERE requested_key = 'AUTO'.
      IF lv_next_key_i > 999.
        rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_KEY_RANGE_FULL",| &&
                  |"program":"{ lv_program }","language":"{ lv_language }",| &&
                  |"message":"No free automatic text symbol key remains in range 001-999"\}|.
        RETURN.
      ENDIF.
      lv_next_key_n = lv_next_key_i.
      ls_work-key = lv_next_key_n.
      MODIFY lt_work FROM ls_work INDEX sy-tabix.
      lv_next_key_i = lv_next_key_i + 1.
    ENDLOOP.

    lt_check = lt_work.
    SORT lt_check BY id key.
    LOOP AT lt_check INTO ls_work.
      IF sy-tabix > 1.
        lv_prev_index = sy-tabix - 1.
        READ TABLE lt_check INDEX lv_prev_index INTO ls_previous.
        IF sy-subrc = 0 AND ls_previous-id = ls_work-id AND ls_previous-key = ls_work-key.
          rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_VALIDATE",| &&
                    |"program":"{ lv_program }","id":"{ ls_work-id }","key":"{ ls_work-key }",| &&
                    |"message":"Duplicate textpool key in request after AUTO allocation"\}|.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_transport IS NOT INITIAL.
      lv_cts_json = append_cts_object(
        iv_object_type = lv_cts_object_type
        iv_object_name = lv_cts_object_name
        iv_transport   = lv_transport ).
      IF lv_cts_json CS '"status":"ERROR"'.
        rv_json = lv_cts_json.
        RETURN.
      ENDIF.
    ENDIF.

    LOOP AT lt_work INTO ls_work.
      READ TABLE lt_textpool INTO ls_textpool WITH KEY id = ls_work-id key = ls_work-key.
      IF sy-subrc = 0.
        ls_textpool-entry = ls_work-entry.
        ls_textpool-length = strlen( ls_work-entry ).
        MODIFY lt_textpool FROM ls_textpool INDEX sy-tabix.
      ELSE.
        CLEAR ls_textpool.
        ls_textpool-id = ls_work-id.
        ls_textpool-key = ls_work-key.
        ls_textpool-entry = ls_work-entry.
        ls_textpool-length = strlen( ls_work-entry ).
        APPEND ls_textpool TO lt_textpool.
      ENDIF.
    ENDLOOP.

    SORT lt_textpool BY id key.
    INSERT TEXTPOOL lv_program FROM lt_textpool LANGUAGE lv_language.
    IF sy-subrc <> 0.
      rv_json = |\{"status":"ERROR","stage":"TEXTPOOL_SAVE",| &&
                |"program":"{ lv_program }","language":"{ lv_language }",| &&
                |"subrc":{ sy-subrc },| &&
                |"message":"INSERT TEXTPOOL failed"\}|.
      RETURN.
    ENDIF.

    READ TEXTPOOL lv_program INTO lt_after LANGUAGE lv_language.
    LOOP AT lt_work INTO ls_work.
      CLEAR ls_after.
      READ TABLE lt_after INTO ls_after WITH KEY id = ls_work-id key = ls_work-key.
      IF sy-subrc <> 0 OR ls_after-entry <> ls_work-entry.
        lv_has_error = abap_true.
      ENDIF.
      IF lv_results_json <> '['.
        lv_results_json = lv_results_json && ','.
      ENDIF.
      lv_results_json = lv_results_json &&
        |\{"id":"{ ls_work-id }",| &&
        |"requested_key":"{ escape( val = ls_work-requested_key format = cl_abap_format=>e_json_string ) }",| &&
        |"key":"{ escape( val = ls_work-key format = cl_abap_format=>e_json_string ) }",| &&
        |"status":"{ COND string( WHEN sy-subrc = 0 AND ls_after-entry = ls_work-entry THEN 'OK' ELSE 'ERROR' ) }",| &&
        |"expected_entry":"{ escape( val = ls_work-entry format = cl_abap_format=>e_json_string ) }",| &&
        |"actual_entry":"{ escape( val = ls_after-entry format = cl_abap_format=>e_json_string ) }"\}|.
    ENDLOOP.
    lv_results_json = lv_results_json && ']'.

    rv_json = |\{"status":"{ COND string( WHEN lv_has_error = abap_true THEN 'ERROR' ELSE 'OK' ) }",| &&
              |"stage":"TEXTPOOL_SAVE",| &&
              |"object_type":"{ lv_object_type }",| &&
              |"object_name":"{ escape( val = lv_object_name format = cl_abap_format=>e_json_string ) }",| &&
              |"program":"{ lv_program }",| &&
              |"language":"{ lv_language }",| &&
              |"transport":"{ escape( val = lv_transport format = cl_abap_format=>e_json_string ) }",| &&
              |"cts":{ lv_cts_json },| &&
              |"results":{ lv_results_json }\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->VALIDATE_FUGR_INCLUDE_WRITE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD validate_fugr_include_write.
    DATA lv_function_group TYPE string.
    DATA lv_include TYPE string.
    DATA lv_prefix TYPE string.
    DATA lv_suffix TYPE string.
    DATA lv_len TYPE i.

    lv_function_group = to_upper( iv_function_group ).
    lv_include = to_upper( iv_include ).

    IF lv_function_group IS INITIAL OR lv_include IS INITIAL.
      rv_json = '{"status":"ERROR","stage":"FUGR_INCLUDE_VALIDATE","message":"function_group and include are required"}'.
      RETURN.
    ENDIF.

    IF is_z_object_name( lv_function_group ) = abap_false.
      rv_json = |\{"status":"ERROR","stage":"FUGR_INCLUDE_VALIDATE","object_type":"FUGR",| &&
                |"object_name":"{ lv_function_group }",| &&
                |"message":"Only Z* function groups can be changed through this API"\}|.
      RETURN.
    ENDIF.

    IF strlen( lv_include ) < 2 OR lv_include+1(1) <> 'Z'.
      rv_json = |\{"status":"ERROR","stage":"FUGR_INCLUDE_VALIDATE","object_type":"INCL",| &&
                |"object_name":"{ lv_include }",| &&
                |"message":"Only LZ* generated includes can be changed through this API"\}|.
      RETURN.
    ENDIF.

    lv_prefix = |L{ lv_function_group }|.
    IF lv_include NP |{ lv_prefix }*|.
      rv_json = |\{"status":"ERROR","stage":"FUGR_INCLUDE_VALIDATE","object_type":"INCL",| &&
                |"object_name":"{ lv_include }",| &&
                |"function_group":"{ lv_function_group }",| &&
                |"message":"Include does not belong to the requested function group"\}|.
      RETURN.
    ENDIF.

    lv_len = strlen( lv_prefix ).
    lv_suffix = lv_include+lv_len.

    IF lv_suffix = 'TOP'.
      RETURN.
    ENDIF.

    IF strlen( lv_suffix ) = 3 AND lv_suffix+1(2) CO '0123456789'.
      IF lv_suffix(1) = 'F' OR lv_suffix(1) = 'O' OR lv_suffix(1) = 'I'.
        RETURN.
      ENDIF.
      IF lv_suffix(1) = 'U' AND iv_allow_u_include = abap_true.
        RETURN.
      ENDIF.
    ENDIF.

    rv_json = |\{"status":"ERROR","stage":"FUGR_INCLUDE_VALIDATE","object_type":"INCL",| &&
              |"object_name":"{ lv_include }",| &&
              |"function_group":"{ lv_function_group }",| &&
              |"message":"Only TOP, Fxx, Oxx, Ixx generated includes are allowed for this route"\}|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->VALIDATE_NAMES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_REQUEST                     TYPE        TY_DDIC_REQUEST
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD validate_names.
    DATA lv_messages TYPE string VALUE '['.
    DATA lt_domain_names TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_dtel_names TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_table_names TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    LOOP AT is_request-domains INTO DATA(ls_domain).
      DATA(lv_domain_name) = to_upper( ls_domain-name ).

      IF lv_domain_name IS INITIAL.
        append_result(
          EXPORTING iv_result = '{"severity":"E","object_type":"DOMA","message":"Domain name is required"}'
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      IF is_z_object_name( lv_domain_name ) = abap_false.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DOMA",| &&
                                |"object_name":"{ lv_domain_name }",| &&
                                |"message":"Only Z* object names are allowed for API-created objects"\}|
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      READ TABLE lt_domain_names WITH KEY table_line = lv_domain_name TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DOMA",| &&
                                |"object_name":"{ lv_domain_name }",| &&
                                |"message":"Duplicate domain name in request"\}|
          CHANGING cv_json = lv_messages ).
      ELSE.
        APPEND lv_domain_name TO lt_domain_names.
      ENDIF.

      IF domain_exists( lv_domain_name ) = abap_true.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DOMA",| &&
                                |"object_name":"{ lv_domain_name }",| &&
                                |"message":"Domain already exists in SAP. Name will not be changed automatically."\}|
          CHANGING cv_json = lv_messages ).
      ENDIF.
    ENDLOOP.

    LOOP AT is_request-data_elements INTO DATA(ls_data_element).
      DATA(lv_dtel_name) = to_upper( ls_data_element-name ).

      IF lv_dtel_name IS INITIAL.
        append_result(
          EXPORTING iv_result = '{"severity":"E","object_type":"DTEL","message":"Data element name is required"}'
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      IF is_z_object_name( lv_dtel_name ) = abap_false.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DTEL",| &&
                                |"object_name":"{ lv_dtel_name }",| &&
                                |"message":"Only Z* object names are allowed for API-created objects"\}|
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      READ TABLE lt_dtel_names WITH KEY table_line = lv_dtel_name TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DTEL",| &&
                                |"object_name":"{ lv_dtel_name }",| &&
                                |"message":"Duplicate data element name in request"\}|
          CHANGING cv_json = lv_messages ).
      ELSE.
        APPEND lv_dtel_name TO lt_dtel_names.
      ENDIF.

      IF data_element_exists( lv_dtel_name ) = abap_true.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"DTEL",| &&
                                |"object_name":"{ lv_dtel_name }",| &&
                                |"message":"Data element already exists in SAP. Name will not be changed automatically."\}|
          CHANGING cv_json = lv_messages ).
      ENDIF.
    ENDLOOP.

    LOOP AT is_request-tables INTO DATA(ls_table).
      DATA(lv_table_name) = to_upper( ls_table-name ).

      IF lv_table_name IS INITIAL.
        append_result(
          EXPORTING iv_result = '{"severity":"E","object_type":"TABL","message":"Table name is required"}'
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      IF is_z_object_name( lv_table_name ) = abap_false.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"TABL",| &&
                                |"object_name":"{ lv_table_name }",| &&
                                |"message":"Only Z* object names are allowed for API-created objects"\}|
          CHANGING cv_json = lv_messages ).
        CONTINUE.
      ENDIF.

      READ TABLE lt_table_names WITH KEY table_line = lv_table_name TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"TABL",| &&
                                |"object_name":"{ lv_table_name }",| &&
                                |"message":"Duplicate table name in request"\}|
          CHANGING cv_json = lv_messages ).
      ELSE.
        APPEND lv_table_name TO lt_table_names.
      ENDIF.

      IF table_exists( lv_table_name ) = abap_true.
        append_result(
          EXPORTING iv_result = |\{"severity":"E","object_type":"TABL",| &&
                                |"object_name":"{ lv_table_name }",| &&
                                |"message":"Table already exists in SAP. Name will not be changed automatically."\}|
          CHANGING cv_json = lv_messages ).
      ENDIF.
    ENDLOOP.

    lv_messages = lv_messages && ']'.

    IF lv_messages = '[]'.
      rv_json = '{"status":"OK","messages":[]}'.
    ELSE.
      rv_json = |\{"status":"ERROR","messages":{ lv_messages }\}|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->VALIDATE_NAMES_FROM_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<-()] RV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD validate_names_from_json.
    DATA ls_request TYPE ty_ddic_request.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING json = iv_json
          CHANGING  data = ls_request ).

        rv_json = validate_names( ls_request ).
      CATCH cx_root INTO DATA(lx_validate).
        rv_json = |\{"status":"ERROR","stage":"DDIC_VALIDATE",| &&
                  |"message":"{ escape( val = lx_validate->get_text( ) format = cl_abap_format=>e_json_string ) }"\}|.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_AI_MCP_REST_FUN->WRITE_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SERVER                      TYPE REF TO IF_HTTP_SERVER
* | [--->] IV_STATUS                      TYPE        I
* | [--->] IV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD write_json.
    io_server->response->set_status( code = iv_status reason = 'OK' ).
    io_server->response->set_header_field( name = 'Content-Type' value = 'application/json; charset=utf-8' ).
    io_server->response->set_cdata( iv_json ).
  ENDMETHOD.
ENDCLASS.
