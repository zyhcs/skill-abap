*&---------------------------------------------------------------------*
*& Report          [PROGRAM_NAME]
*&---------------------------------------------------------------------*
*& Program Name  : [PROGRAM_NAME]
*& Module        : [MODULE_NAME]
*& Title         : [DESCRIPTION] (面向对象 OO ALV 标准企业级模板)
*& Author        : SAP ABAP Development Team
*& Create Date   : [CREATE_DATE]
*& Transport Req : [TRANSPORT_REQ]
*& Package       : [PACKAGE_NAME]
*&---------------------------------------------------------------------*
*& 架构设计说明 (Architecture Overview):
*& 1. 架构范式: 经典分层架构 (Selection Screen -> Extraction -> Processing -> OO ALV on Screen 9000)
*& 2. 交互界面: 自定义屏幕 (Screen 9000) + 自定义容器 (CL_GUI_CUSTOM_CONTAINER)
*& 3. 网格引擎: CL_GUI_ALV_GRID (面向对象 ALV 控件)
*& 4. 字段目录: 采用标准子程序 (FORM build_fieldcat) 显式装载，严禁使用宏以确保可断点调试
*& 5. 事件驱动: 本地类 LCL_EVENT_RECEIVER 截获并分发双击、热点、工具栏及自定义指令
*& 6. 生命周期: PBO 首次渲染/差量刷新，PAI 退出时显式释放 GUI 容器与控件内存句柄
*&---------------------------------------------------------------------*
*& 修改履历 (Change History):
*& 日期       | 修改人    | 请求号     | 描述
*& -----------+-----------+------------+---------------------------------
*& [CREATE_DATE] | DEVELOPER | [TRANSPORT_REQ] | 初始版本创建 (单屏 OO ALV 标准模板)
*&---------------------------------------------------------------------*
REPORT [PROGRAM_NAME] MESSAGE-ID 00.

TABLES: sscrfields.
" TODO: 声明选择屏幕关联的透明表 (如 mara, vbak 等)

*======================================================================*
* 1. CONSTANTS DEFINITION (全局常量定义)
*======================================================================*
CONSTANTS:
  gc_custom_container TYPE scrfname        VALUE 'ALV_CONTAINER', " 屏幕 9000 容器控件名
  gc_status_9000      TYPE syucomm         VALUE 'STATUS_9000',   " GUI 状态名称
  gc_title_9000       TYPE syucomm         VALUE 'TITLE_9000',    " GUI 标题栏名称
  gc_ucomm_refresh    TYPE syucomm         VALUE 'REFRESH',       " ALV 工具栏自定义刷新指令
  gc_default_variant  TYPE slis_vari       VALUE '0001'.          " 默认变式句柄

*======================================================================*
* 2. TYPE DEFINITIONS (业务与 ALV 输出结构定义)
*======================================================================*
TYPES:
  " ALV 输出行数据结构 (Hungarian 命名规范)
  BEGIN OF ty_s_alv,
    " --- 业务字段定义区 (TODO: 注入具体业务字段) ---
    " matnr      TYPE mara-matnr,         " 物料编码
    " maktx      TYPE makt-maktx,         " 物料描述

    " --- ALV 动态控制字段 ---
    cell_color TYPE lvc_t_scol,         " 单元格动态颜色配置表
    cell_style TYPE lvc_t_styl,         " 单元格可编辑/按钮样式配置表
  END OF ty_s_alv,

  " ALV 输出内表类型
  ty_t_alv TYPE STANDARD TABLE OF ty_s_alv WITH DEFAULT KEY.

*======================================================================*
* 3. GLOBAL DATA DECLARATIONS (全局变量与控制器对象)
*======================================================================*
DATA:
  gt_alv              TYPE ty_t_alv,                   " ALV 核心输出内表
  gs_alv              TYPE ty_s_alv,                   " ALV 当前工作区
  gt_fcat             TYPE lvc_t_fcat,                 " ALV 字段目录 (Field Catalog)
  gs_layout           TYPE lvc_s_layo,                 " ALV 网格外观布局配置
  gs_variant          TYPE disvariant,                 " ALV 变式管理结构
  gt_exclude_toolbar  TYPE ui_functions,               " 标准工具栏按钮排除清单
  ok_code             TYPE sy-ucomm,                   " 屏幕 9000 OK 码绑定字段 (与屏幕元素清单严格一致)
  save_ok             TYPE sy-ucomm,                   " OK_CODE 暂存区
  gv_title_text       TYPE string.                     " 动态标题栏文本

* OO ALV 核心对象实例
DATA:
  go_custom_container TYPE REF TO cl_gui_custom_container, " 自定义容器宿主
  go_alv_grid         TYPE REF TO cl_gui_alv_grid.          " ALV 网格控制器

*======================================================================*
* 4. LOCAL CLASS DEFINITION (本地事件接收类定义)
*======================================================================*
CLASS lcl_event_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      " 1. 双击事件 (Double Click)
      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column
          es_row_no,

      " 2. 热点超链接点击事件 (Hotspot Click)
      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id
          es_row_no,

      " 3. 网格工具栏初始化事件 (Toolbar Construction)
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
          e_object
          e_interactive,

      " 4. 网格自定义按钮指令分发 (User Command Dispatcher)
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
          e_ucomm,

      " 5. 数据变更校验事件 (Data Changed)
      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING
          er_data_changed
          e_onf4
          e_onf4_before
          e_onf4_after
          e_ucomm.
ENDCLASS.

DATA: go_event_receiver TYPE REF TO lcl_event_receiver. " 本地事件接收器实例句柄

*======================================================================*
* 5. SELECTION SCREEN LAYOUT (选择屏幕布局定义)
*======================================================================*
SELECTION-SCREEN BEGIN OF BLOCK b_cond WITH FRAME TITLE TEXT-001.
  " TODO: 注入选择屏幕字段 (SELECT-OPTIONS / PARAMETERS)
SELECTION-SCREEN END OF BLOCK b_cond.

SELECTION-SCREEN BEGIN OF BLOCK b_opt WITH FRAME TITLE TEXT-002.
  PARAMETERS:
    p_vari TYPE disvariant-variant.              " ALV 变式
SELECTION-SCREEN END OF BLOCK b_opt.

*======================================================================*
* 6. REPORT LIFECYCLE EVENTS (报表主生命周期事件)
*======================================================================*
*----------------------------------------------------------------------*
* INITIALIZATION (初始化事件)
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM f_init_selection_texts.
  PERFORM f_init_default_values.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN ON VALUE-REQUEST (F4 变式搜索帮助)
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM f_f4_variant.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN OUTPUT (选择屏幕 PBO 输出控制)
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  " 保留供动态控制选择屏幕字段的显示/隐藏

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN (选择屏幕输入校验与权限检查)
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  PERFORM f_authority_check.

*----------------------------------------------------------------------*
* START-OF-SELECTION (核心数据提取与加工)
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_get_data.
  PERFORM f_process_data.

*----------------------------------------------------------------------*
* END-OF-SELECTION (数据校验与屏幕调起)
*----------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM f_check_data.
  CALL SCREEN 9000.

*======================================================================*
* 7. DYNPRO MODULES: SCREEN 9000 (屏幕流逻辑控制)
*======================================================================*
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT (PBO: 渲染前准备)
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS gc_status_9000.
  SET TITLEBAR  gc_title_9000 WITH gv_title_text.
  CLEAR ok_code.
  PERFORM f_display_alv.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_9000 INPUT (PAI: 屏幕交互指令捕获)
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR '&F03' OR '&F15' OR '&F12'.
      PERFORM f_free_alv.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
      " 保留扩展屏幕级通用命令
  ENDCASE.
ENDMODULE.

*======================================================================*
* 8. LOCAL CLASS IMPLEMENTATION (本地事件接收类实现)
*======================================================================*
CLASS lcl_event_receiver IMPLEMENTATION.

  " 1. 处理双击事件
  METHOD handle_double_click.
    READ TABLE gt_alv INTO DATA(ls_row) INDEX e_row-index.
    IF sy-subrc = 0.
      " TODO: 添加双击钻取逻辑 (如 CALL TRANSACTION)
    ENDIF.
  ENDMETHOD.

  " 2. 处理热点点击事件
  METHOD handle_hotspot_click.
    READ TABLE gt_alv INTO DATA(ls_row) INDEX e_row_id-index.
    IF sy-subrc = 0.
      CASE e_column_id-fieldname.
        " TODO: 添加热点点击响应逻辑
        WHEN OTHERS.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  " 3. 构建网格工具栏: 添加分割符与自定义【刷新数据】按钮
  METHOD handle_toolbar.
    DATA ls_toolbar TYPE stb_button.

    " 添加分隔符
    CLEAR ls_toolbar.
    ls_toolbar-butn_type = 3. " 分割线类型
    APPEND ls_toolbar TO e_object->mt_toolbar.

    " 添加【刷新】按钮
    CLEAR ls_toolbar.
    ls_toolbar-function  = gc_ucomm_refresh.
    ls_toolbar-icon      = icon_refresh.
    ls_toolbar-quickinfo = '重新读取数据库数据并刷新表格'.
    ls_toolbar-text      = '刷新数据'.
    ls_toolbar-disabled  = abap_false.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  " 4. 分发工具栏自定义指令
  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN gc_ucomm_refresh.
        PERFORM f_get_data.
        PERFORM f_process_data.
        PERFORM f_refresh_alv.
        MESSAGE '数据已成功刷新' TYPE 'S'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  " 5. 处理单元格数据变更校验 (模板保留)
  METHOD handle_data_changed.
    " 适用于可编辑单元格即时联动
  ENDMETHOD.

ENDCLASS.

*======================================================================*
* 9. SUBROUTINES: SELECTION & INITIALIZATION (初始化与选择屏幕控制)
*======================================================================*
*&---------------------------------------------------------------------*
*& Form F_INIT_SELECTION_TEXTS
*&---------------------------------------------------------------------*
*& 动态初始化选择屏幕文本描述 (确保无文本元素时也能正常显示中文标签)
*&---------------------------------------------------------------------*
FORM f_init_selection_texts.
  " TODO: 注入选择屏幕中文标签动态绑定
  %_p_vari_%_app_%-text  = '布局变式'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_INIT_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*& 初始化屏幕默认过滤条件
*&---------------------------------------------------------------------*
FORM f_init_default_values.
  " TODO: 设置默认日期范围或默认值
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_F4_VARIANT
*&---------------------------------------------------------------------*
*& ALV 布局变式搜索帮助
*&---------------------------------------------------------------------*
FORM f_f4_variant.
  DATA: ls_variant TYPE disvariant.

  CLEAR ls_variant.
  ls_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = ls_variant
      i_save     = 'A'
    IMPORTING
      es_variant = ls_variant
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.

  IF sy-subrc = 0.
    p_vari = ls_variant-variant.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*& 业务权限检查
*&---------------------------------------------------------------------*
FORM f_authority_check.
  " TODO: 注入权限对象校验
ENDFORM.

*======================================================================*
* 10. SUBROUTINES: DATA EXTRACTION & PROCESSING (数据抽取与加工)
*======================================================================*
*&---------------------------------------------------------------------*
*& Form F_GET_DATA
*&---------------------------------------------------------------------*
*& 从数据库抽取业务数据
*&---------------------------------------------------------------------*
FORM f_get_data.
  CLEAR gt_alv.

  " TODO: 编写高效的 SQL 抽取逻辑 (优先使用 JOIN/WITH，杜绝循环 SELECT)

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_PROCESS_DATA
*&---------------------------------------------------------------------*
*& 业务数据加工、告警着色与动态标题生成
*&---------------------------------------------------------------------*
FORM f_process_data.
  " TODO: 业务数据循环补全与单元格着色处理

  " 动态生成窗口标题栏文本
  DATA(lv_lines) = lines( gt_alv ).
  gv_title_text  = |[DESCRIPTION] (共 { lv_lines } 条记录)|.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_CHECK_DATA
*&---------------------------------------------------------------------*
*& 检查抽取结果，若为空则给出友好提示并终止后续屏幕流
*&---------------------------------------------------------------------*
FORM f_check_data.
  IF gt_alv IS INITIAL.
    MESSAGE '未找到符合筛选条件的数据记录!' TYPE 'S' DISPLAY LIKE 'W'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.

*======================================================================*
* 11. SUBROUTINES: FIELDCATALOG & LAYOUT CONFIGURATION (字段目录与布局)
*======================================================================*
*&---------------------------------------------------------------------*
*& Form F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& 构建 ALV 字段目录 (逐字段显式调用 FORM，杜绝宏定义以支持单步调试)
*&---------------------------------------------------------------------*
FORM f_build_fieldcat.
  CLEAR gt_fcat.

  " 语法说明:
  " PERFORM build_fieldcat USING 字段名 列标题 参考表 参考字段 货币字段 数量字段 热点 可编辑 复选框 颜色.
  " TODO: 逐字段调用 build_fieldcat 填充目录

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& 单个字段目录属性封装子程序 (支持断点单步调试)
*&---------------------------------------------------------------------*
FORM build_fieldcat USING VALUE(iv_fieldname)  TYPE lvc_fname
                          VALUE(iv_coltext)    TYPE lvc_txtcol
                          VALUE(iv_ref_table)  TYPE lvc_rtname
                          VALUE(iv_ref_field)  TYPE lvc_rfname
                          VALUE(iv_cfieldname) TYPE lvc_cfname
                          VALUE(iv_qfieldname) TYPE lvc_qfname
                          VALUE(iv_hotspot)    TYPE lvc_hotspt
                          VALUE(iv_edit)       TYPE lvc_edit
                          VALUE(iv_checkbox)   TYPE lvc_checkb
                          VALUE(iv_emphasize)  TYPE lvc_emphsz.

  DATA: ls_fcat TYPE lvc_s_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname   = iv_fieldname.
  ls_fcat-coltext     = iv_coltext.
  ls_fcat-reptext     = iv_coltext.
  ls_fcat-scrtext_s   = iv_coltext.
  ls_fcat-scrtext_m   = iv_coltext.
  ls_fcat-scrtext_l   = iv_coltext.
  ls_fcat-ref_table   = iv_ref_table.
  ls_fcat-ref_field   = iv_ref_field.
  ls_fcat-cfieldname  = iv_cfieldname.
  ls_fcat-qfieldname  = iv_qfieldname.
  ls_fcat-hotspot     = iv_hotspot.
  ls_fcat-edit        = iv_edit.
  ls_fcat-checkbox    = iv_checkbox.
  ls_fcat-emphasize   = iv_emphasize.
  ls_fcat-col_opt     = abap_true. " 自动优化单列宽度

  APPEND ls_fcat TO gt_fcat.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*& 配置 ALV 整体网格布局属性
*&---------------------------------------------------------------------*
FORM f_build_layout.
  CLEAR gs_layout.
  gs_layout-zebra             = abap_true.     " 启用斑马纹
  gs_layout-cwidth_opt        = abap_true.     " 启用列宽自适应
  gs_layout-sel_mode          = 'D'.           " 多选模式 (行+单元格选择)
  gs_layout-ctab_fname        = 'CELL_COLOR'.  " 挂载动态颜色字段
  gs_layout-stylefname        = 'CELL_STYLE'.  " 挂载动态样式字段
  gs_layout-grid_title        = '[DESCRIPTION]'. " 网格内嵌标题
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*& 排除不需要的标准 ALV 工具栏按钮
*&---------------------------------------------------------------------*
FORM f_exclude_tb_functions.
  CLEAR gt_exclude_toolbar.
  APPEND cl_gui_alv_grid=>mc_fc_info  TO gt_exclude_toolbar. " 排除信息
  APPEND cl_gui_alv_grid=>mc_fc_graph TO gt_exclude_toolbar. " 排除图表
  APPEND cl_gui_alv_grid=>mc_fc_print TO gt_exclude_toolbar. " 排除打印
  APPEND cl_gui_alv_grid=>mc_fc_views TO gt_exclude_toolbar. " 排除视图切换
ENDFORM.

*======================================================================*
* 12. SUBROUTINES: OO ALV ENGINE LIFECYCLE (ALV 引擎生命周期与渲染)
*======================================================================*
*&---------------------------------------------------------------------*
*& Form F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*& ALV 容器与网格实例化及数据渲染 (PBO 调用)
*&---------------------------------------------------------------------*
FORM f_display_alv.
  IF go_custom_container IS INITIAL.
    " 1. 实例化自定义容器
    CREATE OBJECT go_custom_container
      EXPORTING
        container_name              = gc_custom_container
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE '创建 ALV 自定义容器失败' TYPE 'E'.
      RETURN.
    ENDIF.

    " 2. 实例化 ALV 网格控件
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent          = go_custom_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE '创建 ALV 网格控件失败' TYPE 'E'.
      RETURN.
    ENDIF.

    " 3. 构建字段目录与网格布局
    PERFORM f_build_fieldcat.
    PERFORM f_build_layout.
    PERFORM f_exclude_tb_functions.

    " 4. 配置变式参数
    CLEAR gs_variant.
    gs_variant-report  = sy-repid.
    gs_variant-handle  = gc_default_variant.
    gs_variant-variant = p_vari.

    " 5. 注册事件处理器
    PERFORM f_register_events.

    " 6. 注册编辑触发事件 (适用于可编辑单元格即时生效)
    go_alv_grid->register_edit_event(
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2 ).

    " 7. 首次渲染输出
    go_alv_grid->set_table_for_first_display(
      EXPORTING
        is_variant                    = gs_variant
        i_save                        = 'A'
        i_default                     = 'X'
        is_layout                     = gs_layout
        it_toolbar_excluding          = gt_exclude_toolbar
      CHANGING
        it_outtab                     = gt_alv
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).
    IF sy-subrc <> 0.
      MESSAGE 'ALV 数据渲染失败' TYPE 'E'.
    ENDIF.

  ELSE.
    " 已经初始化则执行差量刷新
    PERFORM f_refresh_alv.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_REGISTER_EVENTS
*&---------------------------------------------------------------------*
*& 注册 ALV 网格交互事件
*&---------------------------------------------------------------------*
FORM f_register_events.
  CREATE OBJECT go_event_receiver.

  SET HANDLER go_event_receiver->handle_double_click  FOR go_alv_grid.
  SET HANDLER go_event_receiver->handle_hotspot_click FOR go_alv_grid.
  SET HANDLER go_event_receiver->handle_toolbar       FOR go_alv_grid.
  SET HANDLER go_event_receiver->handle_user_command  FOR go_alv_grid.
  SET HANDLER go_event_receiver->handle_data_changed  FOR go_alv_grid.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_REFRESH_ALV
*&---------------------------------------------------------------------*
*& 稳定差量刷新 ALV 显示 (保持当前光标行和列位置不跳动)
*&---------------------------------------------------------------------*
FORM f_refresh_alv.
  DATA: ls_stable TYPE lvc_s_stbl.

  IF go_alv_grid IS BOUND.
    ls_stable-row = abap_true. " 保持当前选中行稳定
    ls_stable-col = abap_true. " 保持当前选中列稳定

    go_alv_grid->refresh_table_display(
      EXPORTING
        is_stable      = ls_stable
        i_soft_refresh = abap_true
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2 ).
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_FREE_ALV
*&---------------------------------------------------------------------*
*& 安全释放 GUI 控件资源与内存引用句柄 (退出屏幕时调用)
*&---------------------------------------------------------------------*
FORM f_free_alv.
  IF go_alv_grid IS BOUND.
    go_alv_grid->free( ).
    FREE go_alv_grid.
  ENDIF.

  IF go_custom_container IS BOUND.
    go_custom_container->free( ).
    FREE go_custom_container.
  ENDIF.

  FREE go_event_receiver.
ENDFORM.
