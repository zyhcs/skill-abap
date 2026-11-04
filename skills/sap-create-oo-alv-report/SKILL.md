---
name: sap-create-oo-alv-report
description: 自动生成并部署符合企业级规范的 SAP 面向对象单屏 OO ALV (Screen 9000 + CL_GUI_CUSTOM_CONTAINER + CL_GUI_ALV_GRID) 报表程序，包含完整的 Dynpro 屏幕创建、Blank GUI Status、无宏显式字段目录、事件分发器与生命周期管理。
---

# `sap-create-oo-alv-report` Skill

本 Skill 用于自动化创建并部署符合企业级黄金标准的 SAP 面向对象单屏 OO ALV (`CL_GUI_ALV_GRID`) 报表程序。

---

## 🎯 核心架构规范 (Architecture Standards)

1. **界面交互模型 (UI Interaction Model)**:
   - 采用自定义屏幕（`Screen 9000`）+ 自定义容器（`CL_GUI_CUSTOM_CONTAINER`，名称 `ALV_CONTAINER`）+ 网格控件（`CL_GUI_ALV_GRID`）。
   - 屏幕必须支持自适应宽高拉伸（`vert_resize: true`, `hor_resize: true`）。
   - **OK_CODE 规范**: 屏幕元素清单中的 OK 码字段必须与 ABAP 全局变量名保持严格一致（统一使用 `ok_code` + `save_ok`）。

2. **GUI 状态与工具栏分层 (GUI Status vs Grid Toolbar)**:
   - **窗口控制**: 创建专属纯净 Blank GUI Status（`STATUS_9000`），**仅保留**窗口控制快捷键：`BACK` (F3), `EXIT` (Shift+F3), `CANCEL` (F12)，以及动态标题栏（`TITLE_9000`）。
   - **表格操作**: 报表功能按钮（如刷新数据、导出、自定义业务处理等）全部在 ALV 网格内部工具栏通过 `lcl_event_receiver->handle_toolbar` 动态注入，实现原生一体化交互。

3. **字段目录构建规范 (Field Catalog without Macros)**:
   - **严禁使用宏定义（Macro）**，以便于在 ABAP 调试器（Debug）中设置断点单步跟踪。
   - 采用标准子程序 `PERFORM build_fieldcat USING ...` 逐字段显式赋值。

4. **生命周期与内存管理 (Lifecycle & Resource Cleanup)**:
   - PBO (`MODULE status_9000`): 首次进入实例化容器与网格，后续交互使用 `f_refresh_alv`（带 `is_stable` 保持光标行列稳定）执行差量刷新。
   - PAI (`MODULE user_command_9000`): 退出屏幕时显式调用 `f_free_alv` 释放控件句柄，杜绝 GUI 句柄与内存泄露。

---

## 📋 标准操作流程 (Standard Operating Procedure)

### 第 1 步：确定报表命名与业务需求
- 报表命名遵循前缀规范：`ZREP_<MODULE>_<DESC>_OO` 或 `ZREP_<NAME>`（如 `ZREP_MM_STOCK_OO`）。
- 确认业务模块（MM/PP/SD/FI/CO）、数据源透明表、关联关系、筛选条件与字段展示清单。

### 第 2 步：生成 ABAP 代码
- 读取模板文件 `resources/oo_alv_template.abap`（或根目录 `templates/oo_alv_template.abap`）。
- 替换占位符：`[PROGRAM_NAME]`, `[DESCRIPTION]`, `[MODULE_NAME]`, `[PACKAGE_NAME]`, `[TRANSPORT_REQ]`。
- 填充业务字段结构 `ty_s_alv`、选择屏幕 `SELECTION-SCREEN`、SQL 抽取逻辑 `f_get_data`、字段目录 `f_build_fieldcat`、事件响应 `lcl_event_receiver`。

### 第 3 步：一键部署流水线

使用统一客户端 `scripts/sap_ai_mcp_client.py` 执行部署：

#### 方式 A：通过 Python SDK 一键自动部署 (推荐)
通过 `scripts/sap_ai_mcp_lib.py` 驱动一键部署，SDK 会自动完成主程序创建激活、Dynpro 9000 屏幕创建以及 `STATUS_9000` 空白 GUI 状态生成：
```python
from scripts.sap_ai_mcp_lib import SapAiMcpClient

client = SapAiMcpClient(profile='dev')

res = client.call('report_deploy', {
    "object_name": "ZREP_MM_STOCK_OO",
    "package": "ZDEV",
    "transport": "S4HK900001",
    "source_code": abap_source_code,
    "copy_gui": True,
    "gui_mode": "CREATE_BLANK",         # 自动创建原生纯净 STATUS_9000 与标题
    "gui_target_status": "STATUS_9000"
})
```

#### 方式 B：通过 CLI 步骤式部署
```bash
# 1. 部署并激活主程序 (PROG)
python3 scripts/sap_ai_mcp_client.py --profile dev report deploy \
  --name ZREP_MM_STOCK_OO \
  --package ZDEV \
  --transport S4HK900001 \
  --file path/to/oo_report.abap

# 2. 创建并激活 Dynpro 屏幕 9000
python3 scripts/sap_ai_mcp_client.py --profile dev --allow-dangerous call dynpro_create <DYNPRO_JSON_PATH>

# 3. 创建并激活专用 Blank GUI Status (STATUS_9000)
python3 scripts/sap_ai_mcp_client.py --profile dev --allow-dangerous call gui_status_create '{"program":"ZREP_MM_STOCK_OO","status":"STATUS_9000","standard_keys":true,"package":"ZDEV","transport":"S4HK900001"}'
```

---

## 💡 最佳编码实践 (Best Practices)

1. **SQL 下推**: 优先使用 SQL 92+ 标准语法（`INNER JOIN`, `LEFT OUTER JOIN`, `CASE WHEN`），**严禁在 LOOP 中嵌套 SELECT**。
2. **文本元素解耦**: 在 `f_init_selection_texts` 中动态绑定选择屏幕中文标签，确保程序在未维护文本元素时也不会显示乱码技术字段。
3. **单元格着色**: 使用 `lvc_t_scol` 在 `f_process_data` 中为预警数据动态上色。
4. **变式搜索帮助**: 标准集成 `f_f4_variant`（调用 `REUSE_ALV_VARIANT_F4`），支持用户自定义与全局变式保存管理。
