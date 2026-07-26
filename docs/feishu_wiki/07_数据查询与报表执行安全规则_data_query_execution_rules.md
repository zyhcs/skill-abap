# 07. 数据查询与报表执行安全规则 (data_query_execution_rules.md)

为了防止 AI 产生的 SQL 查询拖垮数据库，或在动态执行时发生破坏性修改，[rules/data_query_execution_rules.md](file:///c:/Users/37145/Desktop/abap-mcp-api/rules/data_query_execution_rules.md) 制定了严格的数据查询与执行安全红线。

---

## 1. 数据库查询 (Open SQL) 安全限制

1. **禁止全表 `SELECT *` 滥用**：
   * 在查询数据时，必须显式指定所需字段列表（如 `SELECT kunnr, name1 FROM kunnr`），避免无谓拉取不相关大字段。
2. **强制 `UP TO n ROWS` 分页与上限限制**：
   * 任何数据预览或探针性查询，必须附带 `UP TO n ROWS` 约束（默认推荐 `UP TO 100 ROWS`），防止数据库全表扫描。
3. **主键与索引字段匹配**：
   * `WHERE` 条件中必须优先使用表的主键字段（如 `MANDT`, `EBELN`）或已有二级索引字段。严禁使用无索引的 `LIKE '%...'` 全表模糊匹配。
4. **禁止循环内嵌入查询 (No SQL in LOOP)**：
   * **严禁**在 `LOOP AT lt_table` 循环体内嵌入 `SELECT` 语句，必须采用 `FOR ALL ENTRIES IN` 或 `JOIN` 批量提取。

---

## 2. 动态代码执行与探针安全边界 (`/run` & `/probe/run`)

1. **破坏性写操作禁忌**：
   * 动态执行探针逻辑时，**严禁**执行 `DELETE FROM <table>`, `UPDATE <table>`, `COMMIT WORK AND WAIT` 等未授权的数据库写操作。
2. **内存与临时对象隔离**：
   * 动态执行的探针程序命名必须严格限制在临时安全范围内（如 `ZTMP_*` 或 `ZSDRP_AI_MCP_*`），并使用后及时清理 ABAP Memory ID。
