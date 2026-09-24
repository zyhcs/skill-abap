# ABAP 开发黄金规则卡片 (Golden Rules)

---

## 1. 对象命名规范

| 对象类型 | 命名模式 | 示例 | 模块前缀 |
| :--- | :--- | :--- | :--- |
| **报表程序** | `Z<MOD>R_<DESC>` | `ZMMR_PO_LIST` | PP, SD, MM, FI, CO, QM, PM |
| **函数组** | `Z<MOD>G_<DESC>` | `ZSDG_SALES` | 必须以 `Z*G_` 格式 |
| **函数模块** | `Z<MOD>F_<DESC>` | `ZSDF_GET_PRICE` | 必须以 `Z*F_` 格式 |
| **透明表** | `ZT<MOD>_<DESC>` | `ZTMM_PR_CONFIG` | 必须定义客户端字段 `MANDT` |
| **数据元素** | `ZDE_<DESC>` / `Z<MOD>DE_<DESC>` | `ZDE_PURCHASE_QTY` | 长度/类型必须与 Domain 一致 |
| **Domain 域** | `ZDO_<DESC>` / `Z<MOD>DO_<DESC>` | `ZDO_ORDER_STATUS` | - |
| **全局类** | `ZCL_<MOD>_<DESC>` | `ZCL_SD_HELPER` | - |

---

## 2. 变量命名与格式规范

- **单值变量**: `lv_<name>` (例如 `DATA lv_count TYPE i.`)
- **工作区/结构**: `ls_<name>` (例如 `DATA ls_header TYPE bapi_order.`)
- **内表**: `lt_<name>` (例如 `DATA lt_items TYPE STANDARD TABLE OF ty_item.`)
- **常量**: `lc_<name>` (例如 `CONSTANTS lc_status_ok TYPE c VALUE 'S'.`)
- **形式参数**: `iv_<name>` (导入), `ev_<name>` (导出), `cv_<name>` (更改), `rv_<name>` (返回), `ct_<name>` (内表)

---

## 3. 报表程序与数据库查询核心准则

### 3.1 报表程序与选择屏幕规范
1. **深层结构与 TABLES 禁忌**：
   - 当透明表或结构包含 `STRING` / `RAWSTRING` 或内表等深层字段时，**严禁使用 `TABLES: <struct>.`** 语法（会触发语法错误：`必须为扁平结构。不能将内部表、字符串等用作组件`）。
   - 选择屏幕 `SELECT-OPTIONS` 应使用字段独立参考变量：`DATA: gv_xxx TYPE <struct>-xxx.`，再通过 `SELECT-OPTIONS: s_xxx FOR gv_xxx.` 引用。
2. **选择屏幕动态文本与注释**：
   - 必须在每个 `SELECT-OPTIONS` 声明后添加清晰的中文行内注释。
   - 在 `INITIALIZATION` 事件中使用 `%_<name>_%_app_%-text = '...'` 动态填充字段标签文本，确保未单独维护文本元素时界面正常呈现中文。
3. **SELECT 字段注释规范**：
   - `SELECT` 语句中的每一个查询字段必须跟上中文行内注释，明确字段业务含义。

### 3.2 数据库查询 (Open SQL) 核心准则
1. **避免 `SELECT *`**：仅查询业务所需字段，降低内存与传输带宽压力。
2. **强制使用 `UP TO n ROWS`**：在非聚合或验证存在的单点查询时，务必加限制。
3. **批量查询优先**：严禁在 `LOOP AT` 中执行 `SELECT`，必须先收集主键使用 `FOR ALL ENTRIES IN` 或 Range 内表在循环外批量拉取。
4. **检查 `sy-subrc`**：任何 `SELECT`、`READ TABLE`、`CALL FUNCTION` 后必须立即判断 `sy-subrc`。

### 3.3 FM ALV 报表工具栏与按钮事件核心准则 (CRITICAL)
1. **FM ALV 按钮必须通过 GUI 状态 (SE41) 定义**：
   - `REUSE_ALV_GRID_DISPLAY_LVC` 是基于函数模块封装的标准全屏 ALV，其应用工具栏按钮**必须通过 GUI 状态（如拷贝 `SAPLKKBL/STANDARD_FULLSCREEN` 并在 SE41 维护）**实现。
   - **严禁混淆使用 OO ALV 的 `lcl_event_receiver` (`handle_toolbar`)** 在 FM ALV 中注入按钮（FM ALV 顶部工具栏属于 SAP GUI Application Toolbar，`handle_toolbar` 无法在全屏模式下生效）。
2. **事件处理统一走 `USER_COMMAND` 回调**：
   - 所有 GUI 按钮功能码（如 `&DATA_SAVE`, `ADD`, `DEL` 等）统一在 `i_callback_user_command` 指定的子例程（`FORM user_command USING uv_ucomm ...`）中集中捕获并分发。
   - 在执行增删改逻辑前后，调用 `lo_grid->check_changed_data( )` 确保网格数据同步，并通过 `us_selfield-refresh = 'X'` 刷新视图。

---

## 4. AI 执行 DDIC 数据字典标准作业程序 (AI Agent SOP)

AI 代理在接收到数据字典（域、数据元素、透明表）创建或修改任务时，**必须严格按以下 5 个阶段逐步执行**，严禁跳步或自作主张：

### Phase 1: 需求解析与建模自检 (Pre-Flight Checklist)
1. **客户端主键检查**：
   - 业务透明表第一个字段必须是 `MANDT`（数据元素 `MANDT`，`key_flag: true`, `not_null: true`）。
   - 只要包含 `MANDT`，表头属性必须包含 `CLIDEP = 'X'`。
2. **字段类型与增强类别联动 (`EXCLASS`)**：
   - 检查字段列表中是否包含 `STRING` 或 `RAWSTRING` 等不定长深层字段。
   - **若包含**：表增强类别必须指定 `"enhancement_category": "4"`（可以增强 - 深度）；严禁设置为 `"3"`（字符型增强），否则 SAP 激活器将直接报错。
   - **若不包含**：通常可指定 `"enhancement_category": "3"` 或保持默认。
3. **技术设置规范 (`DD09L`)**：
   - 数据类：主数据用 `APPL0`，交易数据用 `APPL1`，配置表用 `APPL2`。
   - 缓冲许可：默认设置 `BUFALLOW = 'N'`（不允许缓冲），列存存储 `ROWORCOLST = 'C'`。
4. **命名规范**：
   - 自定义数据元素使用 `ZE_` / `ZDE_` / `Z<MOD>DE_` 前缀，字段名使用业务描述英文大写缩写。

### Phase 2: 传输请求 (CTS) 预检查与挂载规范
1. **非 `$TMP` 必须有请求号**：
   - 若目标包非 `$TMP`（如 `ZPMCP`），必须指定 Workbench 请求号。
   - 若用户传入父请求号（`TRFUNCTION = 'K'`），流水线会自动定位/新建开发子任务（`'S'`），AI 无需强制要求用户必须给子任务号。
2. **严禁使用修复任务 (`'R'`)**：
   - 自建原创对象只能挂载至 `'S'`（开发任务），挂载至 `'R'` 将被 SAP 底层拦截（`TK181`）。

### Phase 3: 构造 Payload 并执行部署
1. **声明式 Payload**：在工作区 scratch 目录生成标准 `payload.json`，通过 `python3 scripts/sap_ai_mcp_client.py --profile <env> ddic deploy <json>` 提交。
2. **TADIR 与 CTS 自动前置**：流水线会确保在 `PUT` 与 `ACTIVATE` 之前完成 TADIR 登记与请求加锁。

### Phase 4: 校验结果判定与用户交互决策 (CRITICAL)
- **场景 A（跨包冲突 `severity = 'E'`）**：
  - 若系统返回对象已存在于其他包（例如之前在 `$TMP` 临时包创建过）：
  - **AI 行为准则**：**绝对严禁私自决定覆盖或强行写入！** 必须暂停并向用户展示冲突详情，提供选项：
    1. 用户确认通过修改 TADIR 将对象由原包转入目标包并写入请求；
    2. 更换新对象名称重新创建。
- **场景 B（同包增量修改 `severity = 'W'`）**：
  - 若对象已在当前目标包存在，流水线会返回警告并自动执行安全的表结构重构与重新激活。

### Phase 5: 物理验证与交付闭环
1. 部署完成后，AI **必须**调用 `table read <TABNAME>` 实际读取一次该表，验证底层 HANA 物理表已真正生成且可访问。
2. 向用户汇报包含完整字段列表、数据类型、数据元素、CTS 任务号及激活状态的确认报告。

---

## 5. 安全红线

- 严禁在 DEV 以外的任何环境直接修改代码。
- 严禁在修改非 `$TMP` 对象时不挂载有效的 Workbench 请求。
- 严禁直接释放开发主请求，测试推送必须通过 TOC (Transport of Copies)。
