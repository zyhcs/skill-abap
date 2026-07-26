# 数据查询与报表执行安全规则 (Data Query & Execution Rules)

本文档约束 AI Agent 在进行数据库查询 (Open SQL / SELECT)、表预览、报表动态执行时的性能与安全规则。

---

## 1. 数据库查询 (Open SQL) 安全规则

1. **避免 `SELECT *` 滥用**：
   * 在生产或测试环境中查询时，显式指定所需字段列表（例如 `SELECT kunnr, name1 FROM kunnr`），避免拉取无关大字段。
2. **强制分页 / 结果条数限制**：
   * 任何数据预览或测试性查询，必须附带 `UP TO n ROWS` 约束（默认推荐 `UP TO 100 ROWS`），防止产生全表扫描拖垮数据库。
3. **主键与索引优化**：
   * `WHERE` 条件中必须优先使用表的主键字段（如 `MANDT`, `EBELN`）或已有二级索引字段。避免无索引的 `LIKE '%...'` 全表匹配。
4. **禁止循环内查询 (No SQL in LOOP)**：
   * 严禁在 `LOOP AT lt_table` 循环体内嵌入 `SELECT` 语句，必须采用 `FOR ALL ENTRIES IN` 或 `JOIN` 批量查询。

---

## 2. 报表与代码动态执行规则

1. **执行安全边界 (`/run` & `/probe/run`)**：
   * 动态执行代码时，仅允许执行受控探针或只读测试逻辑。
   * 严禁在动态执行脚本中执行 `DELETE FROM <table>`, `UPDATE <table>`, `COMMIT WORK AND WAIT` 等破坏性写操作。
2. **内存隔离**：
   * 在使用 ABAP 内存传递探针数据时，探针程序命名必须符合安全范围（如 `ZSDRP_AI_MCP_*`），并使用后清理 Memory ID。

---

> 提示：具体细则待用户补充规则后启用。
