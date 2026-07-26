# 08. SAP 后端处理类 ZCL_AI_MCP_REST_FUN 源码级实现解析

`ZCL_AI_MCP_REST_FUN.abap` 是部署在 SAP 系统后端的核心 REST 响应处理类（9,400+ 行），实现了接口 `if_http_extension`。

---

## 核心实现结构

### 1. 接口入口方法 `if_http_extension~handle_request`
```abap
METHOD if_http_extension~handle_request.
  DATA: lv_path_info TYPE string,
        lv_method    TYPE string,
        lv_body      TYPE string,
        lv_response  TYPE string.

  " 1. 获取请求上下文
  lv_path_info = server->request->get_header_field( name = 'PATH_INFO' ).
  lv_method    = server->request->get_method( ).
  lv_body      = server->request->get_cdata( ).

  " 2. 依据 PATH_INFO 路由分发
  CASE lv_path_info.
    WHEN '/ddic/validate_names'.
      me->handle_ddic_validate( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/ddic/create'.
      me->handle_ddic_create( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/ddic/status'.
      me->handle_ddic_status( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/object/check'.
      me->handle_object_check( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/object/save'.
      me->handle_object_save( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/object/activate'.
      me->handle_object_activate( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN '/run'.
      me->handle_dynamic_run( EXPORTING iv_body = lv_body IMPORTING ev_response = lv_response ).
    WHEN OTHERS.
      server->response->set_status( code = 404 reason = 'Endpoint Not Found' ).
      RETURN.
  ENDCASE.

  " 3. 设置响应 Header 并输出
  server->response->set_header_field( name = 'Content-Type' value = 'application/json; charset=utf-8' ).
  server->response->set_cdata( data = lv_response ).
ENDMETHOD.
```

---

## 核心功能方法拆解

### 1. 语法校验逻辑 `handle_object_check`
使用 SAP ABAP 内置的 `SYNTAX-CHECK` 语句对传入的源码进行编译预检：
```abap
SYNTAX-CHECK FOR lt_source
  MESSAGE lv_message
  LINE lv_line
  WORD lv_word
  PROGRAM sy-repid.
IF sy-subrc <> 0.
  " 返回精准的 Error 行号、单词与 Message
ENDIF.
```

### 2. 源码增量保存 `handle_object_save`
对于 Report 程序，直接使用 API 写入临时表或执行 `INSERT REPORT` 提交至开发包 `$TMP`；对于 Class / Function Module 则调度相应的 R3TR 引擎。

### 3. 对象生成与编译激活 `handle_object_activate`
调用 SAP 系统的 `BAPI_CTOM_OBJECT_ACTIVATE` 或 `RSD_DDIC_OBJECT_ACTIVATE` / `RS_WORKING_OBJECTS_ACTIVATE` 完成依赖关系的强校验与生成激活。
