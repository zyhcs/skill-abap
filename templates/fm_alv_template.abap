*&---------------------------------------------------------------------*
*& Report [PROGRAM_NAME]
*&---------------------------------------------------------------------*
*& [DESCRIPTION]
*&---------------------------------------------------------------------*
REPORT [PROGRAM_NAME].

*--------------------------------------------------------------------*
*&---------------------------「TABLES」-----------------------------&*
*--------------------------------------------------------------------*
TABLES:sscrfields.
*--------------------------------------------------------------------*
*&---------------------------「TYPES」------------------------------&*
*--------------------------------------------------------------------*
TYPE-POOLS:slis.
TYPES BEGIN OF ty_alv.
*  INCLUDE TYPE 'XXX'.
TYPES:
  " TODO: Inject specific business fields here

  sel      TYPE c,
  icon     TYPE c LENGTH 4,              " 信号灯
  msg      TYPE c LENGTH 200,            " 消息文本
  rowcolor TYPE c LENGTH 4,              " 行颜色
  colortab TYPE lvc_t_scol,              " 单元格颜色
  styletab TYPE lvc_t_styl,              " 单元格样式，如单元格编辑、按钮等
  END OF ty_alv.
*--------------------------------------------------------------------*
*&-----------------------「INTERNAL TABLES」------------------------&*
*--------------------------------------------------------------------*
DATA:
  gt_alv TYPE TABLE OF ty_alv,
  gs_alv TYPE ty_alv.

*--------------------------------------------------------------------*
*&--------------------------「VARIABLE」----------------------------&*
*--------------------------------------------------------------------*
*--------------- REUSE_ALV_GRID_DISPLAY_LVC ALV 基本参数:------------*
DATA:
  gv_grid_title     TYPE  lvc_title         ,  " ALV标题
  gs_grid_settings  TYPE  lvc_s_glay        ,  " ALV设置
  gs_layout         TYPE  lvc_s_layo        ,  " ALV列表布局信息
  gt_fieldcat       TYPE  lvc_t_fcat        ,  " ALV列表目录
  gt_excluding      TYPE  slis_t_extab      ,  " ALV工具栏按钮功能码隐藏/显示
  gt_special_groups TYPE  lvc_t_sgrp        ,  " 栏目选择的字段分组
  gt_sort           TYPE  lvc_t_sort        ,  " ALV排序设置，可以display前对内表数据排序
  gt_filter         TYPE  lvc_t_filt        ,  " ALV过滤设置，可以在display前时增加过滤
  gv_default        TYPE  c  VALUE 'X'      ,  " 用户是否可以定义默认的ALV布局，'X'-可以定义默认布局
  gv_save           TYPE  c  VALUE 'A'      ,  " 保存ALV布局：'X'-只能保存为全局标准变式，'U'-只能保存特定用户变式，
  " 'A'-都可以保存，SPACE-不能保存变式（默认：space）
  gs_variant        TYPE  disvariant        ,  " ALV布局变式
  gt_events         TYPE  slis_t_event      ,  " 设置事件, 类型为slis_t_event的内表（name：事件名称，form：事件的FORM）
  gt_event_exit     TYPE  slis_t_event_exit .  " 设置预置按钮回调的执行行为，表明用户所写的代码是在执行标准执行之前还是之后


*--------------------------------------------------------------------*
*&--------------------------「CONSTANT」----------------------------&*
*--------------------------------------------------------------------*
CONSTANTS:
  gc_inactive TYPE icon   VALUE '@BZ@',   " ICON_LED_INACTIVE
  gc_red      TYPE icon   VALUE '@5C@',   " ICON_LED_RED
  gc_yellow   TYPE icon   VALUE '@5D@',   " ICON_LED_YELLOW
  gc_green    TYPE icon   VALUE '@5B@'.   " ICON_LED_GREEN

*--------------------------------------------------------------------*
*&--------------------------「SCREEN」------------------------------&*
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.
  " TODO: Inject selection screen fields here
SELECTION-SCREEN END OF BLOCK bk1.




*--------------------------------------------------------------------*
*&--------------------------「PROCESS」-----------------------------&*
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
*&----------------------「INITIALIZATION」--------------------------&*
*--------------------------------------------------------------------*
INITIALIZATION.



*--------------------------------------------------------------------*
*&--------------------「AT SELECTION-SCREEN」-----------------------&*
*--------------------------------------------------------------------*
AT SELECTION-SCREEN.



*--------------------------------------------------------------------*
*&----------------「AT SELECTION-SCREEN OUTPUT」--------------------&*
*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN ''.
*        IF r_1 EQ 'X'.
*          screen-active = 1.
*        ELSE.
*          screen-active = 0.
*        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
*--------------------------------------------------------------------*
*&--------------------「START-OF-SELECTION」------------------------&*
*--------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM get_data.
*--------------------------------------------------------------------*
*&---------------------「END-OF-SELECTION」-------------------------&*
*--------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM display_data.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
FORM get_data .

  " TODO: Inject SELECT logic here to populate gt_alv

  IF gt_alv IS INITIAL.
    MESSAGE '没有查询到数据,请检查输入!' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
* LOCAL CLASSES: Definition
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS:

      "工具栏"
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      "用户命令"
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      "搜索帮助"
      handle_onf4
        FOR EVENT onf4 OF  cl_gui_alv_grid
        IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells  e_display,

      "双击"
      handle_double_click
        FOR EVENT double_click OF  cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      "热点"
      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,

      "数据改变"
      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after e_ucomm,

      "数据改变完成"
      handle_data_changed_finished
        FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.

ENDCLASS.
*&---------------------------------------------------------------------*
* LOCAL CLASSES: Implementation
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_toolbar.
  ENDMETHOD.                           "handle_toolbar
*&---------------------------------------------------------------------*
  METHOD handle_user_command.
  ENDMETHOD.                           "handle_user_command

  METHOD handle_onf4.
  ENDMETHOD.                           "handle_onf4

  METHOD handle_double_click.
    " 响应双击事件
*    READ TABLE gt_alv INTO gs_alv INDEX e_row.
*    IF sy-subrc = 0.
*
*    ENDIF.
  ENDMETHOD.                           "handle_double_click

  METHOD handle_hotspot_click.
  ENDMETHOD.                           "handle_hotspot_click

  METHOD handle_data_changed.
  ENDMETHOD.                           "handle_data_changed

  METHOD handle_data_changed_finished.
    " 响应数据改变完成事件"
    LOOP AT et_good_cells INTO DATA(ls_good_cells).
      READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<ls_alv>) INDEX ls_good_cells-row_id.
      IF sy-subrc = 0.
        CASE ls_good_cells-fieldname.
          WHEN 'XXX'.
          WHEN OTHERS.
        ENDCASE.
        e_modified = 'X'.
      ENDIF.
    ENDLOOP.

    CHECK e_modified = 'X'.
    PERFORM alv_refresh.

  ENDMETHOD.                           "handle_data_changed_finished
ENDCLASS.
*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
FORM display_data .
  PERFORM set_layout.          " 设置ALV布局
  PERFORM set_fieldcat.        " 设置ALV字段目录
  PERFORM set_alv.             " 设置ALV展示参数
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra       = 'X'.          " 使ALV呈现斑马线"
  gs_layout-sel_mode    = 'D'.          " 选择模式A D"
  gs_layout-box_fname   = 'SEL'.        " 使用系统选择行项"
  gs_layout-info_fname  = 'ROWCOLOR'.   " 行颜色"
  gs_layout-ctab_fname  = 'COLORTAB'.   " 单元格颜色"
  gs_layout-totals_bef  = 'X'.          " 求和数据放在ALV列标题下面"
  gs_layout-stylefname  = 'STYLETAB'.   " 显示样式"
  gs_layout-numc_total = 'X'.           " 支持NUMC字段合计"

  CLEAR gt_sort.
  CLEAR gt_events.
  gt_events = VALUE #( BASE gt_events ( name = 'CALLER_EXIT'  form = 'CALLER_EXIT' ) ) .
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM  build_fieldcat
*&---------------------------------------------------------------------*
FORM build_fieldcat USING p_fieldname   TYPE fieldname
      p_coltext     TYPE lvc_txtcol
      p_ref_table   TYPE lvc_rtname
      p_ref_field   TYPE lvc_rfname
      p_checkbox    TYPE lvc_checkb
      p_edit        TYPE lvc_edit
      p_f4availabl  TYPE ddf4avail
      p_hotspot     TYPE lvc_hotspt
      p_emphasize   TYPE lvc_emphsz.

  DATA:ls_fieldcat TYPE lvc_s_fcat.
  CLEAR:ls_fieldcat.
  ls_fieldcat-fieldname     = p_fieldname.
  ls_fieldcat-reptext       = p_coltext." 字段标题
  ls_fieldcat-scrtext_l     = p_coltext." 长标题
  ls_fieldcat-scrtext_m     = p_coltext." 中标题
  ls_fieldcat-scrtext_s     = p_coltext." 短标题
  ls_fieldcat-coltext       = p_coltext." 列标题
  ls_fieldcat-ref_table     = p_ref_table." 参考表
  ls_fieldcat-ref_field     = p_ref_field." 参考字段
  ls_fieldcat-checkbox      = p_checkbox." 复选框
  ls_fieldcat-edit          = p_edit." 可编辑
  ls_fieldcat-f4availabl    = p_f4availabl." F4
  ls_fieldcat-hotspot       = p_hotspot." 热点标记
  ls_fieldcat-emphasize     = p_emphasize." 列颜色
  ls_fieldcat-col_opt       = 'X'." 单列优化宽度

  APPEND ls_fieldcat TO gt_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fieldcat
*&---------------------------------------------------------------------*
FORM set_fieldcat .
  " TODO: Inject build_fieldcat calls here
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  set_alv
*&---------------------------------------------------------------------*
FORM set_alv.
  gs_grid_settings-edt_cll_cb = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = gv_grid_title
      i_grid_settings          = gs_grid_settings
      is_layout_lvc            = gs_layout
      it_fieldcat_lvc          = gt_fieldcat
      it_excluding             = gt_excluding
      it_sort_lvc              = gt_sort
      it_filter_lvc            = gt_filter
      i_default                = gv_default
      i_save                   = gv_save
      is_variant               = gs_variant
      it_events                = gt_events
      it_event_exit            = gt_event_exit
    TABLES
      t_outtab                 = gt_alv
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form pf_status_set
*&---------------------------------------------------------------------*
FORM pf_status_set USING ut_exclude TYPE kkblo_t_extab .
  DATA exclude_code TYPE TABLE OF sy-ucomm.
  SET PF-STATUS 'PF_STATUS' OF PROGRAM sy-repid EXCLUDING exclude_code .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
FORM user_command USING uv_ucomm LIKE sy-ucomm us_selfield TYPE slis_selfield .
  DATA:lo_grid TYPE REF TO cl_gui_alv_grid.
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.
  CALL METHOD lo_grid->check_changed_data.

  CASE uv_ucomm.
    WHEN '&IC1'.                                  " ALV双击事件
      READ TABLE gt_alv INDEX us_selfield-tabindex INTO gs_alv.
      CASE us_selfield-fieldname.
        " TODO: Add field-specific double-click logic
      ENDCASE.
    WHEN OTHERS.
  ENDCASE.
  us_selfield-refresh = 'X'.                      " 刷新ALV屏幕
  us_selfield-row_stable = 'X'.                   " 行固定
  us_selfield-col_stable = 'X'.                   " 列固定
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  caller_exit
*&---------------------------------------------------------------------*
FORM caller_exit USING ls_data TYPE slis_data_caller_exit.
  DATA:lo_grid TYPE REF TO cl_gui_alv_grid.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  CALL METHOD lo_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.

  CALL METHOD lo_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.

  DATA:lo_event_receiver TYPE REF TO lcl_event_receiver.
  CREATE OBJECT lo_event_receiver.
  SET HANDLER lo_event_receiver->handle_toolbar FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_user_command FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_data_changed FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_data_changed_finished FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_double_click FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_hotspot_click FOR lo_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_refresh
*&---------------------------------------------------------------------*
FORM alv_refresh .
  DATA:lo_grid TYPE  REF TO cl_gui_alv_grid,
       ls_stbl TYPE  lvc_s_stbl.
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  ls_stbl-row = 'X'." 基于行稳定刷新
  ls_stbl-col = 'X'." 基于列稳定刷新

  lo_grid->set_frontend_fieldcatalog( it_fieldcatalog = gt_fieldcat ).
  CALL METHOD lo_grid->refresh_table_display
    EXPORTING
      is_stable = ls_stbl.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_f4_help
*&---------------------------------------------------------------------*
FORM alv_f4_help  USING    p_fieldname TYPE lvc_fname
                           p_row_no    TYPE lvc_s_roid.

  DATA:lt_return TYPE STANDARD TABLE OF ddshretval.

  CASE p_fieldname.
    " TODO: Add F4 help logic
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
