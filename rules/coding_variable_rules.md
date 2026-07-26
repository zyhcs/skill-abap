# ABAP 代码内容与变量命名规范 (Coding & Variable Rules)

本文档用于约束 ABAP 程序、类、函数模块内部的代码编写格式、变量命名约定及代码结构。

---

## 1. 变量与数据对象命名约定 (Variable Naming Conventions)

AI Agent 在生成或修改 ABAP 代码时，必须遵循以下变量命名前缀（匈牙利命名法）：

| 类型前缀 | 适用对象说明 | 示例 |
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

*(注：此处已配置通用标准前缀，用户稍后可添加或替换为特定企业规范。)*

---

## 2. 代码注释与 Header 规范 (Comments & Header Standards)

1. **文件 Header**：每个创建的程序或类，必须在顶部附带标准 Header 注释框架（详见 `templates/abap_header.txt`）。
2. **逻辑段注释**：在复杂的条件分支、SQL 联表查询、外包接口调用前，必须加入简要说明注释。
3. **语言匹配**：注释语言应与用户提示词或代码已有注释一致（默认推荐中文/英文）。

---

## 3. 代码结构与异常处理规范 (Structure & Exception Rules)

1. **避免全局变量滥用**：优先在类/方法局部定义变量，减少全局变量定义。
2. **显式异常捕获**：在调用 FM / BAPI 或外部 REST 接口时，必须检查 `sy-subrc` 或使用 `TRY...CATCH cx_root` 捕获异常，严禁忽略错误。

---

> 提示：具体细则待用户补充规则后启用。
