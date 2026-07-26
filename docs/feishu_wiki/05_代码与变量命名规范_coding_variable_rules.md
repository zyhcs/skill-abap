# 05. 代码与变量命名规范 (coding_variable_rules.md)

[rules/coding_variable_rules.md](file:///c:/Users/37145/Desktop/abap-mcp-api/rules/coding_variable_rules.md) 用于约束 ABAP 源码内部的匈牙利变量命名前缀、标准 Header 注释结构及异常处理规范。

---

## 1. 变量与数据对象命名约定 (匈牙利命名法)

AI Agent 在生成或修改 ABAP 代码时，必须遵循以下变量命名前缀：

| 类型前缀 | 适用对象说明 | 示例代码 |
| :--- | :--- | :--- |
| **`lv_`** | 局部单值变量 (Local Variable) | `DATA lv_ebeln TYPE ebeln.` |
| **`ls_`** | 局部结构体 (Local Structure) | `DATA ls_header TYPE ty_header.` |
| **`lt_`** | 局部内表 (Local Internal Table) | `DATA lt_items TYPE TABLE OF ty_item.` |
| **`gv_`** | 全局单值变量 (Global Variable) | `DATA gv_repid TYPE syrepid.` |
| **`gs_`** | 全局结构体 (Global Structure) | `DATA gs_config TYPE zfit_config.` |
| **`gt_`** | 全局内表 (Global Internal Table) | `DATA gt_data TYPE TABLE OF zfit_data.` |
| **`iv_`** | Importing 局部输入参数 | `IMPORTING iv_ebeln TYPE ebeln` |
| **`ev_`** | Exporting 局部输出参数 | `EXPORTING ev_status TYPE char1` |
| **`cv_`** | Changing 局部改变参数 | `CHANGING cv_amount TYPE menge_d` |
| **`rv_`** | Returning 函数/方法返回值 | `RETURNING VALUE(rv_success) TYPE abap_bool` |
| **`io_` / `eo_`**| 导入/导出接口引用对象 (Object) | `IMPORTING io_server TYPE REF TO if_http_server` |

---

## 2. 代码 Header 标准模板与示例

每个新建的程序或类，必须在源码最上方附带从 [templates/abap_header.txt](file:///c:/Users/37145/Desktop/abap-mcp-api/templates/abap_header.txt) 导出的标准注释框架：

```abap
*&---------------------------------------------------------------------*
*& Program / Class : ZRP_DEMO_ZYH
*& Author          : KN090
*& Create Date     : 2026-07-26
*& Description     : Query & Test Data Initialization for ZTDEMO_ZYH
*& Module          : SD
*& Requirement ID  : REQ_ZYH_DEMO_001
*&---------------------------------------------------------------------*
*& Change History  :
*& Date       Author      Transport      Description
*& ---------- ----------- -------------- ------------------------------*
*& 2026-07-26 KN090       $TMP           Initial Creation
*&---------------------------------------------------------------------*
```

---

## 3. 结构与异常处理强约束

1. **避免全局变量滥用**：优先在类/方法局部定义变量，减少全局 `DATA` 定义。
2. **显式异常捕获与 `sy-subrc` 校验**：
   * 在调用 FM / BAPI 时，**必须**显式校验 `IF sy-subrc <> 0.`；
   * 在面向对象代码中，必须使用 `TRY...CATCH cx_root INTO DATA(lx_err)` 捕获异常，严禁静默吞掉错误。
