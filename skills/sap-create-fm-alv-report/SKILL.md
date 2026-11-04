---
name: sap-create-fm-alv-report
description: 自动生成并部署符合企业级规范的标准函数式 ABAP ALV 报表程序 (基于 REUSE_ALV_GRID_DISPLAY_LVC 模板，含自动 GUI 状态复制、事件接收器与字段目录规范)。
---

# `sap-create-fm-alv-report` Skill

本 Skill 用于自动化创建符合企业级规范的标准函数式 ABAP ALV 报表程序（基于 `REUSE_ALV_GRID_DISPLAY_LVC`）。

---

## 🎯 适用场景 (When to Use)

当用户提出以下需求时使用本 Skill：
* 需要创建通用的业务“查询报表”、“台账查询程序”或“明细清单”。
* 明确要求使用函数式 ALV（`REUSE_ALV_GRID_DISPLAY_LVC`）或经典全屏报表结构。

---

## 📋 标准操作流程 (Standard Operating Procedure)

### 第 1 步：确定报表命名与业务逻辑
1. **程序命名**：若用户未显式指定，统一命名为 `ZREP_<MODULE>_<DESC>`（如 `ZREP_MM_PURCHASE_LIST`）。
2. **业务逻辑分析**：
   - 确定主表与关联表（如 `MARA`/`MAKT`、`EKKO`/`EKPO`、`VBAK`/`VBAP` 等）。
   - 确定选择屏幕过滤条件（`SELECT-OPTIONS` / `PARAMETERS`）。
   - 确定展示列、主键列、数量/金额单位参考字段。

### 第 2 步：基于模板生成 ABAP 源码
1. 读取模板文件 `resources/fm_alv_template.abap`（或根目录 `templates/fm_alv_template.abap`）。
2. 将业务字段注入到 `TYPES: BEGIN OF ty_alv` 定义中。
3. 将选择屏幕元素、`TABLES` 以及 SQL 取数逻辑注入到 `FORM get_data` 中。
4. 将字段目录定义（`build_fieldcat`）注入到 `FORM set_fieldcat` 中。
5. 保留模板中的标准骨架（包括布局优化、变式支持、事件接收器与双击/工具栏响应逻辑）。

### 第 3 步：一键部署到 SAP 系统

使用统一客户端 `scripts/sap_ai_mcp_client.py` 一键部署：

```bash
# 一键完成程序创建、锁定、写入、解锁、激活以及从 SAPLKKBL 克隆标准全屏 GUI 状态
python3 scripts/sap_ai_mcp_client.py --profile dev report deploy \
  --name ZREP_DEMO01 \
  --description "采购订单明细查询报表" \
  --package ZDEV \
  --transport S4HK900001 \
  --file path/to/generated_report.abap \
  --copy-gui
```

> 💡 **参数说明**：
> - `--copy-gui`: 自动从 `SAPLKKBL/STANDARD_FULLSCREEN` 复制标准 GUI 状态，确保报表具备完整的打印、导出 Excel、筛选、排序等全部工具栏按钮。
> - `--transport`: 非 `$TMP` 包必须指定有效的 Workbench 传输请求号。

---

## 💡 最佳编码实践 (Best Practices)

1. **SQL 下推与性能**：
   - 严禁在 `LOOP` 中嵌套 `SELECT`。
   - 尽量使用多表 `JOIN` 或利用 ABAP SQL `WITH +lt_itab AS (...)` 语法。
2. **字段目录规范**：
   - 字段目录显式指明参考表（`ref_table`）与参考字段（`ref_field`），以便自动获取数据字典标签与 F1/F4 帮助。
3. **选择屏幕动态文本**：
   - 在 `INITIALIZATION` 事件中动态设置 `%_s_xxx_%_app_%-text`，避免因未维护文本池导致选择屏幕显示技术字段名。
