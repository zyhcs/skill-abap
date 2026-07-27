*&---------------------------------------------------------------------*
*& Program Name        : ZRP_TEMPLATE_STANDARD_ALV                    *
*& Functional Area     : Common Report Template                       *
*& Description         : 基础 ALV 查询报表标准模板                      *
*&---------------------------------------------------------------------*
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
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

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
*    DATA:ls_toolbar  TYPE stb_button.
*
*    " 添加分隔符"
*    CLEAR ls_toolbar.
*    MOVE 3 TO ls_toolbar-butn_type.
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*
*    "添加按钮"
*    CLEAR ls_toolbar.
*    MOVE 'XXX' TO ls_toolbar-function.
*    MOVE icon_create TO ls_toolbar-icon.
*    MOVE 'TEXT' TO ls_toolbar-quickinfo.
*    MOVE 'TEXT' TO ls_toolbar-text.
*    MOVE ' ' TO ls_toolbar-disabled.
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*
*    "去除不需要显示的按钮"
*    DELETE e_object->mt_toolbar WHERE function = '&LOCAL&APPEND'
*                                   OR function = '&DETAIL'
*                                   OR function = '&CHECK'
*                                   OR function = '&LOCAL&PASTE'
*                                   OR function = '&LOCAL&UNDO'
*                                   OR function = '&INFO'
*                                   OR function = '&LOCAL&INSERT_ROW'
*                                   OR function = '&LOCAL&DELETE_ROW'
*                                   OR function = '&LOCAL&CUT'
*                                   OR function = '&LOCAL&COPY'
*                                   OR function = '&REFRESH'
*                                   OR function = '&LOCAL&COPY_ROW'.
  ENDMETHOD.                           "handle_toolbar
*&---------------------------------------------------------------------*
  METHOD handle_user_command.
*     go_grid->check_changed_data( ).  "检查修改数据!!!!"
*    " 添加按钮响应事件"
*    CASE e_ucomm.
*     "全选"
*      WHEN 'SALL'.
*        LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>).
*          <fs_alv>-sel = 'X'.
*        ENDLOOP.
*      "取消全选"
*      WHEN 'DALL'.
*        LOOP AT gt_alv ASSIGNING <fs_alv>.
*          <fs_alv>-sel = ''.
*        ENDLOOP.
*    ENDCASE.
*
*    CALL METHOD go_grid->refresh_table_display.
  ENDMETHOD.                           "handle_user_command

  METHOD handle_onf4.
    " 响应F4 HELP事件
*    PERFORM alv_f4_help USING e_fieldname es_row_no .
*    er_event_data->m_event_handled = 'X'.
  ENDMETHOD.                           "handle_onf4

  METHOD handle_double_click.
    " 响应双击事件
*    READ TABLE gt_alv INTO gs_alv INDEX e_row.
*    IF sy-subrc = 0.
*
*    ENDIF.
  ENDMETHOD.                           "handle_double_click

  METHOD handle_hotspot_click.
    " 响应热点事件"
*    READ TABLE gt_alv INTO gs_alv INDEX e_row_id.
*    IF sy-subrc EQ 0.
*      CASE e_column_id.
*        WHEN ''.
*      ENDCASE.
*    ENDIF.
  ENDMETHOD.                           "handle_hotspot_click

  METHOD handle_data_changed.
    " 响应数据改变事件
*    LOOP AT er_data_changed->mt_mod_cells INTO DATA(ls_edit_cell).
*      READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<ls_alv>) INDEX ls_edit_cell-row_id.
*      IF sy-subrc = 0.
*        CASE ls_edit_cell-fieldname.
*          WHEN 'SEL'.
*            <ls_alv>-sel = ls_edit_cell-value.
*          WHEN 'XXX'.
**            <ls_alv>-XXX = { ls_edit_cell-value ALPHA = IN }|.
**            SELECT SINGLE XXX INTO <ls_alv>-XXX FROM XXX WHERE XXX = <ls_alv>-XXX.
*          WHEN OTHERS.
*        ENDCASE.
*      ENDIF.
*    ENDLOOP.

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
*& ALV 数据展示
*&---------------------------------------------------------------------*
FORM display_data .
  PERFORM set_layout.          " 设置ALV布局

  PERFORM set_fieldcat.        " 设置ALV字段目录

  PERFORM set_alv.             " 设置ALV展示参数
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
*& 设置ALV布局
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra       = 'X'.          " 使ALV呈现斑马线"
  gs_layout-sel_mode    = 'D'.          " 选择模式A D"
*  gs_layout-cwidth_opt = 'X'.           " 自动优化列宽，不推荐使用"
  gs_layout-box_fname   = 'SEL'.        " 使用系统选择行项"
  gs_layout-info_fname  = 'ROWCOLOR'.   " 行颜色：设定行颜色值所在的列（ COLOR ）"
  gs_layout-ctab_fname  = 'COLORTAB'.   " 单元格颜色：设定单元格颜色值所在的内表（列名 FNAME +颜色值 COLOR）"
  gs_layout-totals_bef  = 'X'.          " 设置后，求和数据放在ALV列标题下面"
  gs_layout-stylefname  = 'STYLETAB'.   " 显示样式，控制单元格可否编辑"
*  gs_layout-no_rowmark = 'X'.           " 隐藏左边的选择块（当Layout-SEL_MODE = A或D，或设置了Layout-BOX_FNAME，或设置了编辑模式）
*  gs_layout-sgl_clk_hd = 'X'.           " 列标题支持单击排序"
*  gs_layout-no_totline = 'X'.           " 不显示合计、小计行"
  gs_layout-numc_total = 'X'.           " 默认情况，NUMC字段设置 FIELDCAT-DO_SUM = 'X' 是不会计算合计的，设置支持合计"


*-----------------------------设置 ALV 数据排序 ----------------------*
* spos:排序顺序  fieldname:排序字段 up:升序 down:降序
  CLEAR gt_sort.
*-----------------------------设置 ALV 事件回调 ----------------------*
  CLEAR gt_events.
  gt_events = VALUE #( BASE gt_events ( name = 'CALLER_EXIT'  form = 'CALLER_EXIT' ) ) .
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM  build_fieldcat
*&---------------------------------------------------------------------*
* 填充fieldcat
*----------------------------------------------------------------------*
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
  ls_fieldcat-reptext       = p_coltext." 字段标题（建议使用该字段，不必设置以下四个字段）
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
* CASE p_fieldname
*    WHEN ''.
**      ls_fieldcat-just = 'C'.           " 单元格中内容显示时对齐方式：(R)ight (L)eft (C)ent.
**      ls_fieldcat-no_zero = 'X'.        " 为X时,不输出前导零，和无意义的空值
**      ls_fieldcat-fix_column = 'X'.     " 单元格固定
**      ls_fieldcat-datatype = 'CURR'.    " 指定数据类型：金额，用于控制输入时的小数位为2位
**      ls_fieldcat-decimals = 4.         " 指定小数位，用于控制输入时的小数位为4位
**      ls_fieldcat-hotspot = ''.        " 设置字段内容下面是否有热点（有下划线，可点击，单击即可触发相应事件）
**      ls_fieldcat-col_opt = ''.          " 单列优化宽度
*      "下拉框设置"
**      ls_fieldcat-drdn_hndl = '1'.      " 对应 gt_dropdown-Handle = 1 的项
**      ls_fieldcat-f4availabl = 'X'.     " F4帮助
*
**      ls_fieldcat-outputlen = ''.      " 设置列宽，当设置自动列宽是，此参数失效
*    WHEN OTHERS.
*  ENDCASE.

  APPEND ls_fieldcat TO gt_fieldcat.
ENDFORM.                    "BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& Form set_fieldcat
*&---------------------------------------------------------------------*
*& 设置字段目录
*&---------------------------------------------------------------------*
FORM set_fieldcat .
*---------------------------根据结构生成字段目录-----------------------*
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
**     I_BUFFER_ACTIVE        =
*      i_structure_name       = 'spfli'
**     I_CLIENT_NEVER_DISPLAY = 'X'
**     I_BYPASSING_BUFFER     =
**     I_INTERNAL_TABNAME     =
*    CHANGING
*      ct_fieldcat            = gt_fieldcat
*    EXCEPTIONS
*      inconsistent_interface = 1
*      program_error          = 2
*      OTHERS                 = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

*  PERFORM build_fieldcat USING 'ICON' '状态' '' '' '' '' '' '' ''.
*  PERFORM build_fieldcat USING 'MSG'  '消息文本' '' '' '' '' '' '' ''.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  set_alv
*&---------------------------------------------------------------------*
*       ALV显示
*----------------------------------------------------------------------*
FORM set_alv.
  gs_grid_settings-edt_cll_cb = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '                        " 接口一致性检查
*     I_BYPASSING_BUFFER       =                            " 是否使用缓存
*     I_BUFFER_ACTIVE          =                            " 是否激活缓存，如果每次显示ALV都是相同的字段目录，则该字段目录会被放到一特殊的缓存里，加快显示速度。
      i_callback_program       = sy-repid                   " 回调函数、输出内表所在的程序名
      i_callback_pf_status_set = 'PF_STATUS_SET'            " 回调本地FORM，设置ALV工具栏
      i_callback_user_command  = 'USER_COMMAND'             " 回调本地FORM，设置工具栏按钮或数据行事件触发时的操作
*     i_callback_top_of_page   = 'TOP_OF_PAGE'              " 回调函数，设置ALV报表表头信息
*     i_callback_html_top_of_page = 'HTML_TOP_OF_PAGE'         " 回调函数，设置ALV报表表头HTML代码
*     i_callback_html_end_of_list = 'HTML_END_OF_LIST'         " 回调函数，设置ALV报表表尾HTML代码
*     I_STRUCTURE_NAME         = ' '                        " 字段目录结构，参考数据字典结构
      i_grid_title             = gv_grid_title              " ALV 标题，位于ALV工具栏和ALV GRID之间
      i_grid_settings          = gs_grid_settings           " GRID信息设置
      is_layout_lvc            = gs_layout                  " ALV输出布局样式
      it_fieldcat_lvc          = gt_fieldcat                " 设定显示的项目名称及输出设定
      it_excluding             = gt_excluding               " 隐藏设置的ALV工具栏
      it_sort_lvc              = gt_sort                    " ALV排序设置，可以display前对内表数据排序
      it_filter_lvc            = gt_filter                  " ALV过滤设置，可以在get_data时增加过滤
      i_default                = gv_default                 " 用户是否可以定义默认的布局，’X'-可以定义默认布局，Space-不可以定义默认布局 （默认：X）
      i_save                   = gv_save                    " 保存表格布局：'X'-只能保存为全局标准变式，'U'-只能保存特定用户变式，'A'-都可以保存，SPACE-不能保存变式（默认：space）
      is_variant               = gs_variant                 " 表格布局变式
      it_events                = gt_events                  " 设置事件, 类型为slis_t_event的内表（name：事件名称，form：事件的FORM）
      it_event_exit            = gt_event_exit              " 设置预置按钮回调的执行行为，表明用户所写的代码是在执行标准执行之前还是之后
    TABLES
      t_outtab                 = gt_alv                      " 必须参数，要显示的内表
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
*& 定义工具栏按钮状态
*&---------------------------------------------------------------------*
FORM pf_status_set USING ut_exclude TYPE kkblo_t_extab .
* GUI STATUS TOOLBAR
  DATA exclude_code TYPE TABLE OF sy-ucomm.
*  exclude_code =  VALUE #( ( '&XXX' ) ).
  SET PF-STATUS 'PF_STATUS' OF PROGRAM sy-repid EXCLUDING exclude_code .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
*& 定义ALV按钮事件
*&---------------------------------------------------------------------*
FORM user_command USING uv_ucomm LIKE sy-ucomm us_selfield TYPE slis_selfield .
* 设置ALV内容改变事件回调
  DATA:lo_grid TYPE REF TO cl_gui_alv_grid.
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  CALL METHOD lo_grid->check_changed_data.

* 设置按钮触发事件
  CASE uv_ucomm.
    WHEN '&IC1'.                                  " ALV双击事件
*    获取当前双击的行目索引"
      READ TABLE gt_alv INDEX us_selfield-tabindex INTO gs_alv.
      CASE us_selfield-fieldname.
        WHEN 'XXX'.
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
*       调用出口，可结合OO ALV使用
*----------------------------------------------------------------------*
FORM caller_exit USING ls_data TYPE slis_data_caller_exit.
  DATA:lo_grid TYPE REF TO cl_gui_alv_grid.
*
*  DATA:
*    lt_dropdown TYPE lvc_t_drop,           " 下拉框项，按handle分组，对应fieldcat-drdn_hndl
*    ls_dropdown TYPE lvc_s_drop.
*
*  DATA:
*    lt_f4_help TYPE  lvc_t_f4.             " F4 帮助参数
*
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  "注册编辑事件触发方式：修改后立即触发
  CALL METHOD lo_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.

  " 注册编辑事件触发方式：回车触发
  CALL METHOD lo_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.

* 以上两句作用等同于：gs_setting-edt_cll_cb = 'X'. "  值修改后立即触发data_changed

  DATA:lo_event_receiver TYPE REF TO lcl_event_receiver.
  CREATE OBJECT lo_event_receiver.
  SET HANDLER lo_event_receiver->handle_toolbar FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_user_command FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_data_changed FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_data_changed_finished FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_double_click FOR lo_grid.
  SET HANDLER lo_event_receiver->handle_hotspot_click FOR lo_grid.
* 以上两句作用等同于：
*  CLEAR gt_event.
*  gt_event-name = 'DATA_CHANGED'.
*  gt_event-form = 'FRM_DATA_CHANGED'.
*  APPEND gt_event.

  "设置下拉框赋值&设置fieldcat drdn_hndl属性"
*  lt_dropdown = VALUE #(
*  ( value = 'value1' handle = '1' )
*  ( value = 'value2' handle = '1' ) ).
*  CALL METHOD lo_grid->set_drop_down_table
*    EXPORTING
*      it_drop_down = lt_dropdown.

  "设置F4 HELP 参数值"
*  lt_f4_help = VALUE #(  BASE lt_f4_help
*    ( fieldname = 'XXX' register = 'X'  getbefore = 'X' chngeafter = 'X' ) ).
*
*  SET HANDLER lo_event_receiver->handle_onf4 FOR lo_grid.
  " 需要设置相应的fieldcat f4availabl属性
*  CALL METHOD lo_grid->register_f4_for_fields
*    EXPORTING
*      it_f4 = lt_f4_help.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_refresh
*&---------------------------------------------------------------------*
*& alv 刷新
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
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
*& alv 搜索帮助
*&---------------------------------------------------------------------*
*&      --> E_FIELDNAME
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM alv_f4_help  USING    p_fieldname TYPE lvc_fname
                           p_row_no    TYPE lvc_s_roid.

* 获取ALV上点击的行数据
  DATA:lt_return TYPE STANDARD TABLE OF ddshretval.

  CASE p_fieldname.
    WHEN 'XXX'.
      READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>) INDEX p_row_no-row_id.
      IF sy-subrc = 0.
*        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*          EXPORTING
*            retfield        = 'XXX'            "筛选内表里面的字段
*            dynpprog        = sy-repid
*            dynpnr          = sy-dynnr
*            dynprofield     = '<fs_alv>-XXX'   "ALV内表字段
*            value_org       = 'S'
*      "     CALLBACK_PROGRAM = SY-REPID
*          TABLES
*            value_tab       = lt_xxx         "需要显示帮助的值内表
*            return_tab      = lt_return        "返回值
*          EXCEPTIONS
*            parameter_error = 1
*            no_values_found = 2
*            OTHERS          = 3.
**       将搜索帮助选中的返回值写到ALV上
*        IF sy-subrc = 0.
*          READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
*          IF ls_return-fieldval IS NOT INITIAL .
**           获取选中的库存地点
**            <fs_alv>-XXX = ls_return-fieldval.
*          ENDIF.
*        ENDIF.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
