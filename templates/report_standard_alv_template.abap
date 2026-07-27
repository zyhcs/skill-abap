*&---------------------------------------------------------------------*
*& Program Name        : ZRP_TEMPLATE_STANDARD_ALV                    *
*& Functional Area     : MM/SD/FI/PP (标准 ALV 报表模板)               *
*& Description         : 标准通用 ALV 查询报表模板                      *
*& Author              : 021569                                       *
*& Date                : 2026-07-27                                   *
*& Transport Request   : S4DK998218                                   *
*&---------------------------------------------------------------------*
*& Change History                                                      *
*& Date       User     TR Number    Description                        *
*& ---------- -------- ------------ ---------------------------------- *
*& 2026-07-27 021569   S4DK998218   初始创建标准 ALV 模板              *
*&---------------------------------------------------------------------*
REPORT zrp_template_standard_alv.

*--------------------------------------------------------------------*
*&---------------------------「TABLES」-----------------------------&*
*--------------------------------------------------------------------*
TABLES: sscrfields, mara, marc.

*--------------------------------------------------------------------*
*&---------------------------「TYPES」------------------------------&*
*--------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES BEGIN OF ty_alv.
  " 业务字段定义
  INCLUDE TYPE mara.                   " 包含业务字段结构
TYPES:
  maktx    TYPE makt-maktx,            " 物料描述
  werks    TYPE marc-werks,            " 工厂
  ekgrp    TYPE marc-ekgrp,            " 采购组
  " 标准 ALV 控制字段
  sel      TYPE c,                     " 行选择复选框
  icon     TYPE c LENGTH 4,            " 信号灯/图标 (@5C@ 红, @5D@ 黄, @5B@ 绿)
  msg      TYPE c LENGTH 200,          " 消息文本
  rowcolor TYPE c LENGTH 4,            " 行颜色 (如 C500)
  colortab TYPE lvc_t_scol,            " 单元格颜色表
  styletab TYPE lvc_t_styl,            " 单元格样式 (编辑/按钮/禁用)
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
*--------------- REUSE_ALV_GRID_DISPLAY_LVC ALV 基本参数 -------------*
DATA:
  gv_grid_title     TYPE lvc_title,             " ALV 标题
  gs_grid_settings  TYPE lvc_s_glay,            " ALV 设置
  gs_layout         TYPE lvc_s_layo,            " ALV 布局样式
  gt_fieldcat       TYPE lvc_t_fcat,            " ALV 字段目录
  gt_excluding      TYPE slis_t_extab,          " ALV 工具栏功能码排除
  gt_special_groups TYPE lvc_t_sgrp,           " 字段分组
  gt_sort           TYPE lvc_t_sort,           " ALV 默认排序
  gt_filter         TYPE lvc_t_filt,           " ALV 默认过滤
  gv_default        TYPE c VALUE 'X',           " 是否允许定义默认变式 ('X')
  gv_save           TYPE c VALUE 'A',           " 保存变式权限 ('A'-全局/用户)
  gs_variant        TYPE disvariant,            " ALV 变式
  gt_events         TYPE slis_t_event,          " ALV 回调事件表
  gt_event_exit     TYPE slis_t_event_exit.     " 事件拦截定义

*--------------------------------------------------------------------*
*&--------------------------「CONSTANT」----------------------------&*
*--------------------------------------------------------------------*
CONSTANTS:
  gc_inactive TYPE icon VALUE '@BZ@',   " ICON_LED_INACTIVE
  gc_red      TYPE icon VALUE '@5C@',   " ICON_LED_RED
  gc_yellow   TYPE icon VALUE '@5D@',   " ICON_LED_YELLOW
  gc_green    TYPE icon VALUE '@5B@'.   " ICON_LED_GREEN

*--------------------------------------------------------------------*
*&--------------------------「SCREEN」------------------------------&*
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_matnr FOR mara-matnr,
                  s_mtart FOR mara-mtart,
                  s_werks FOR marc-werks.
SELECTION-SCREEN END OF BLOCK bk1.

SELECTION-SCREEN BEGIN OF BLOCK bk2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_maxrow TYPE i DEFAULT 2000 OBLIGATORY,
              p_vari   TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK bk2.

*--------------------------------------------------------------------*
*&----------------------「INITIALIZATION」--------------------------&*
*--------------------------------------------------------------------*
INITIALIZATION.
  gs_variant-report = sy-repid.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      cs_variant = gs_variant
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.
  IF sy-subrc = 0.
    p_vari = gs_variant-variant.
  ENDIF.

*--------------------------------------------------------------------*
*&--------------------「AT SELECTION-SCREEN」-----------------------&*
*--------------------------------------------------------------------*
AT SELECTION-SCREEN ON P_VARI.
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = gs_variant
      i_save     = 'A'
    IMPORTING
      es_variant = gs_variant
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.
  IF sy-subrc = 0.
    p_vari = gs_variant-variant.
  ENDIF.

AT SELECTION-SCREEN.
  " 选择屏幕输入校验保护
  IF s_matnr[] IS INITIAL AND s_werks[] IS INITIAL.
    MESSAGE '物料编号与工厂不能同时为空，请至少输入一个条件！' TYPE 'E'.
  ENDIF.

*--------------------------------------------------------------------*
*&----------------「AT SELECTION-SCREEN OUTPUT」--------------------&*
*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
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
FORM get_data.
  CLEAR gt_alv.

  SELECT a~matnr,
         a~mtart,
         a~matkl,
         a~meins,
         b~maktx,
         c~werks,
         c~ekgrp
    FROM mara AS a
    LEFT JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @sy-langu
    INNER JOIN marc AS c ON c~matnr = a~matnr
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv
    UP TO @p_maxrow ROWS
    WHERE a~matnr IN @s_matnr
      AND a~mtart IN @s_mtart
      AND c~werks IN @s_werks.

  IF gt_alv IS INITIAL.
    MESSAGE '没有查询到数据，请检查筛选条件！' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
    " 业务状态图标初始化
    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>).
      <fs_alv>-icon = gc_green.
      <fs_alv>-msg  = '处理成功'.
    ENDLOOP.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
* LOCAL CLASSES: Definition
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      handle_onf4
        FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells e_display,

      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,

      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after e_ucomm,

      handle_data_changed_finished
        FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.
ENDCLASS.

*&---------------------------------------------------------------------*
* LOCAL CLASSES: Implementation
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    " 工具栏按钮扩展预留
  ENDMETHOD.

  METHOD handle_user_command.
    " 自定义按钮事件响应预留
  ENDMETHOD.

  METHOD handle_onf4.
    " 响应 F4 单元格搜索帮助事件
    PERFORM alv_f4_help USING e_fieldname es_row_no.
    er_event_data->m_event_handled = 'X'.
  ENDMETHOD.

  METHOD handle_double_click.
    " 响应双击事件
    READ TABLE gt_alv INTO gs_alv INDEX e_row.
    IF sy-subrc = 0.
      " 击穿跳转逻辑
    ENDIF.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    " 响应热点点击事件
    READ TABLE gt_alv INTO gs_alv INDEX e_row_id.
    IF sy-subrc = 0.
      CASE e_column_id.
        WHEN 'MATNR'.
          SET PARAMETER ID 'MAT' FIELD gs_alv-matnr.
          CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD handle_data_changed.
    " 响应单元格实时数据变动事件
  ENDMETHOD.

  METHOD handle_data_changed_finished.
    " 响应数据变动完成事件
    CHECK e_modified = 'X'.
    PERFORM alv_refresh.
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
FORM display_data.
  PERFORM set_layout.    " 设置 ALV 布局
  PERFORM set_fieldcat.  " 设置 ALV 字段目录
  PERFORM set_alv.       " 设置 ALV 展示参数
ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
FORM set_layout.
  gs_layout-zebra       = 'X'.          " 斑马线显示
  gs_layout-sel_mode    = 'D'.          " 选择模式
  gs_layout-box_fname   = 'SEL'.        " 复选框字段
  gs_layout-info_fname  = 'ROWCOLOR'.   " 行颜色字段
  gs_layout-ctab_fname  = 'COLORTAB'.   " 单元格颜色表
  gs_layout-totals_bef  = 'X'.          " 合计行置顶
  gs_layout-stylefname  = 'STYLETAB'.   " 单元格样式控制
  gs_layout-numc_total  = 'X'.          " NUMC 字段计算合计

  CLEAR gt_events.
  gt_events = VALUE #( BASE gt_events ( name = 'CALLER_EXIT' form = 'CALLER_EXIT' ) ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_fieldcat
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

  DATA: ls_fieldcat TYPE lvc_s_fcat.
  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname     = p_fieldname.
  ls_fieldcat-reptext       = p_coltext.
  ls_fieldcat-scrtext_l     = p_coltext.
  ls_fieldcat-scrtext_m     = p_coltext.
  ls_fieldcat-scrtext_s     = p_coltext.
  ls_fieldcat-coltext       = p_coltext.
  ls_fieldcat-ref_table     = p_ref_table.
  ls_fieldcat-ref_field     = p_ref_field.
  ls_fieldcat-checkbox      = p_checkbox.
  ls_fieldcat-edit          = p_edit.
  ls_fieldcat-f4availabl    = p_f4availabl.
  ls_fieldcat-hotspot       = p_hotspot.
  ls_fieldcat-emphasize     = p_emphasize.
  ls_fieldcat-col_opt       = 'X'.

  APPEND ls_fieldcat TO gt_fieldcat.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_fieldcat
*&---------------------------------------------------------------------*
FORM set_fieldcat.
  CLEAR gt_fieldcat.

  PERFORM build_fieldcat USING 'ICON'  '状态'     '' '' '' '' '' '' ''.
  PERFORM build_fieldcat USING 'MATNR' '物料编号' 'MARA' 'MATNR' '' '' '' 'X' ''.
  PERFORM build_fieldcat USING 'MAKTX' '物料描述' 'MAKT' 'MAKTX' '' '' '' '' ''.
  PERFORM build_fieldcat USING 'MTART' '物料类型' 'MARA' 'MTART' '' '' '' '' ''.
  PERFORM build_fieldcat USING 'WERKS' '工厂'     'MARC' 'WERKS' '' '' '' '' ''.
  PERFORM build_fieldcat USING 'EKGRP' '采购组'   'MARC' 'EKGRP' '' '' '' '' ''.
  PERFORM build_fieldcat USING 'MSG'   '消息文本' '' '' '' '' '' '' ''.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_alv
*&---------------------------------------------------------------------*
FORM set_alv.
  gs_grid_settings-edt_cll_cb = 'X'.
  gs_variant-report = sy-repid.
  gs_variant-variant = p_vari.

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
FORM pf_status_set USING ut_exclude TYPE kkblo_t_extab.
  DATA exclude_code TYPE TABLE OF sy-ucomm.
  SET PF-STATUS 'PF_STATUS' OF PROGRAM sy-repid EXCLUDING exclude_code.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form user_command
*&---------------------------------------------------------------------*
FORM user_command USING uv_ucomm LIKE sy-ucomm us_selfield TYPE slis_selfield.
  DATA: lo_grid TYPE REF TO cl_gui_alv_grid.
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  IF lo_grid IS BOUND.
    CALL METHOD lo_grid->check_changed_data.
  ENDIF.

  CASE uv_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_alv INDEX us_selfield-tabindex INTO gs_alv.
      IF sy-subrc = 0.
        CASE us_selfield-fieldname.
          WHEN 'MATNR'.
            SET PARAMETER ID 'MAT' FIELD gs_alv-matnr.
            CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
        ENDCASE.
      ENDIF.
  ENDCASE.

  us_selfield-refresh    = 'X'.
  us_selfield-row_stable = 'X'.
  us_selfield-col_stable = 'X'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form caller_exit
*&---------------------------------------------------------------------*
FORM caller_exit USING ls_data TYPE slis_data_caller_exit.
  DATA: lo_grid TYPE REF TO cl_gui_alv_grid.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  IF lo_grid IS BOUND.
    " 注册编辑触发：修改后立即触发
    CALL METHOD lo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    " 注册编辑触发：按回车触发
    CALL METHOD lo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    " 注册局部 OO 事件监听对象
    DATA: lo_event_receiver TYPE REF TO lcl_event_receiver.
    CREATE OBJECT lo_event_receiver.

    SET HANDLER lo_event_receiver->handle_toolbar               FOR lo_grid.
    SET HANDLER lo_event_receiver->handle_user_command           FOR lo_grid.
    SET HANDLER lo_event_receiver->handle_data_changed          FOR lo_grid.
    SET HANDLER lo_event_receiver->handle_data_changed_finished FOR lo_grid.
    SET HANDLER lo_event_receiver->handle_double_click          FOR lo_grid.
    SET HANDLER lo_event_receiver->handle_hotspot_click         FOR lo_grid.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form alv_refresh
*&---------------------------------------------------------------------*
FORM alv_refresh.
  DATA: lo_grid TYPE REF TO cl_gui_alv_grid,
        ls_stbl TYPE lvc_s_stbl.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_grid.

  IF lo_grid IS BOUND.
    ls_stbl-row = 'X'.
    ls_stbl-col = 'X'.
    lo_grid->set_frontend_fieldcatalog( it_fieldcatalog = gt_fieldcat ).
    CALL METHOD lo_grid->refresh_table_display
      EXPORTING
        is_stable = ls_stbl.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form alv_f4_help
*&---------------------------------------------------------------------*
FORM alv_f4_help USING p_fieldname TYPE lvc_fname
                       p_row_no    TYPE lvc_s_roid.
  DATA: lt_return TYPE STANDARD TABLE OF ddshretval.

  CASE p_fieldname.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
