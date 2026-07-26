# ABAP 语法黄金准则速查卡 (High-Frequency Syntax Card)

> **轻量级常驻规范**（约 500 Tokens）：日常 90% 的 ABAP 代码生成只需遵循本卡片。
> 如需查找复杂的特定语法细节，请根据后文目录索引使用 `view_file` 工具按需查阅参考库。

---

## 1. 常用高频黄金准则 (Top 10 Golden Rules)

1. **Host 变量 `@` (新 Open SQL)**：
   * 所有 SQL 语句中的 ABAP 变量/表达式前**必须**加 `@`。
   * 示例：`SELECT ebeln, bukrs FROM ekko INTO TABLE @DATA(lt_po) WHERE ebeln = @iv_ebeln.`
2. **内联声明 (Inline Declarations)**：
   * 变量：`DATA(lv_val) = 'ABC'.`
   * 循环：`LOOP AT lt_items INTO DATA(ls_item).` 或 `ASSIGNING FIELD-SYMBOL(<ls_item>).`
3. **结构与内表赋值 (`VALUE` & `CORRESPONDING`)**：
   * 结构：`ls_data = VALUE #( id = '001' name = 'Zhang' ).`
   * 拷贝：`ls_target = CORRESPONDING #( ls_source ).`
4. **字符串模板 (String Templates)**：
   * 使用 `|Text { lv_var }|` 替代 `CONCATENATE`。格式化使用 `|{ lv_date DATE = USER }|`。
5. **条件表达式 (`COND` & `SWITCH`)**：
   * `DATA(lv_status) = COND string( WHEN sy-subrc = 0 THEN 'Success' ELSE 'Failed' ).`
6. **表表达式 (Table Expressions)**：
   * 读取内表单行：`DATA(ls_row) = lt_list[ id = '100' ].` (包含防护：`VALUE #( lt_list[ id = '100' ] OPTIONAL )`)
7. **布尔函数 (`XSDBOOL`)**：
   * `DATA(lv_is_valid) = xsdbool( sy-subrc = 0 AND lv_count > 0 ).`
8. **显式异常捕获与 `sy-subrc` 校验**：
   * FM/BAPI 调用后**必须**校验 `IF sy-subrc <> 0.`，核心逻辑使用 `TRY...CATCH cx_root INTO DATA(lx_err).`
9. **强约束标志**：
   * 程序/类必须包含 `FIXPT = 'X'` (固定点算术) 与 `UCCHECK = 'X'` (Unicode 校验)。
10. **废弃语法禁忌 (Forbidden Legacy)**：
    * ❌ 严禁使用 `MOVE`, `COMPUTE`, `TABLES`, `OCCURS 0`, `WITH HEADER LINE`。

---

## 2. 备查参考库与按需目录索引 (On-Demand Reference Index)

只有当需要查询复杂/生僻语法（如 `REDUCE`, `GROUP BY`, `FILTER`, `REGEX`, `CAST` 等）时，才使用 `view_file` 工具读取以下对应的行号区间：

### A. 经典 ABAP 基础语法指南：[rules/abap_syntax_guide_classic.md](file:///c:/Users/37145/Desktop/abap-mcp-api/rules/abap_syntax_guide_classic.md)
* **1.1-1.2 数据类型 (C,D,F,I,P,X) & SY 系统变量** ➔ Line 1 ~ Line 100
* **1.3 DESCRIBE 属性探针** ➔ Line 100 ~ Line 150
* **控制结构 (IF, CASE, DO, WHILE)** ➔ Line 200 ~ Line 400
* **内表基础操作 (SORT, DELETE, READ TABLE)** ➔ Line 500 ~ Line 900
* **Open SQL 经典语法** ➔ Line 1000 ~ Line 1300

### B. ABAP 7.5+ / S4HANA 新特性指南：[rules/abap_syntax_guide_s4hana.md](file:///c:/Users/37145/Desktop/abap-mcp-api/rules/abap_syntax_guide_s4hana.md)
* **`DATA(...)`, `FIELD-SYMBOL`, `NEW`, `VALUE`, `BASE`** ➔ Line 1 ~ Line 120
* **`FOR`, `LET`, `CONV`, `SWITCH`, `COND`, `CORRESPONDING`** ➔ Line 120 ~ Line 250
* **`REDUCE` (聚合计算) & `GROUP BY` (内表分组)** ➔ Line 250 ~ Line 400
* **`FILTER` (过滤) & `EXACT` (精确计算)** ➔ Line 400 ~ Line 500
* **新 Open SQL (Host 变量 `@`, CASE, CAST, Built-in 函数)** ➔ Line 500 ~ Line 900
* **字符串模板格式化选项 (ALPHA, CURRENCY, TIMESTAMP)** ➔ Line 900 ~ Line 1200
* **表表达式 `lt_tab[ ... ]` & OPTIONAL / DEFAULT** ➔ Line 1200 ~ Line 1359
