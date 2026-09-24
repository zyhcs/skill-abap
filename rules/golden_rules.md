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

## 3. 数据库查询 (Open SQL) 核心准则

1. **避免 `SELECT *`**：仅查询业务所需字段，降低内存与传输带宽压力。
2. **强制使用 `UP TO n ROWS`**：在非聚合或验证存在的单点查询时，务必加限制。
3. **批量查询优先**：严禁在 `LOOP AT` 中执行 `SELECT`，必须先收集主键使用 `FOR ALL ENTRIES IN` 或 Range 内表在循环外批量拉取。
4. **检查 `sy-subrc`**：任何 `SELECT`、`READ TABLE`、`CALL FUNCTION` 后必须立即判断 `sy-subrc`。

---

## 4. DDIC 数据字典与 CTS 传输核心规则

### 4.1 CTS 请求号层级与挂载规则
1. **区分父请求与子任务**：
   - 父请求（Header Request，`TRFUNCTION = 'K'` / `'W'`）不可直接承载物理对象。
   - 开发对象（`E071`）必须挂载至 **开发/纠错任务（`TRFUNCTION = 'S'`）**，严禁挂载到修复任务（`'R'`）。
   - 服务端已支持传入父请求号时自动定位当前用户的可修改 Task（若无则基于父请求自动创建 Task）。
2. **PGMID 规范**：独立物理对象在 `E071` 中必须设置 `PGMID = 'R3TR'`（不可留空）。

### 4.2 DDIC 字典对象创建与激活规则
1. **TADIR 目录前置注册**：
   - 必须在执行 `DDIF_*_PUT` 和 `DDIF_*_ACTIVATE` 之前，先完成 `TADIR` 目录包归属注册与 CTS 加锁，否则激活内核因缺少开发包归属而失败。
2. **客户端依赖 (`CLIDEP`)**：
   - 当透明表第一个主键字段为 `MANDT` 时，表头属性必须设置 `CLIDEP = 'X'`，否则将触发 `WRONGCL = 'X'` 阻断激活。
3. **深层字段与增强类别 (`EXCLASS`)**：
   - 当透明表包含 `STRING` 或 `RAWSTRING` 等不定长深层字段时，**增强类别必须设置为 `4`（可以增强 - 深度）**，不可设为 `3`（仅字符型）。
4. **技术设置 (`DD09L`)**：
   - S/4HANA 要求透明表必须显式指定缓冲许可（如 `BUFALLOW = 'N'` 不允许缓冲），HANA 列存指定 `ROWORCOLST = 'C'`。
5. **字段物理属性绑定**：
   - `DD03P` 结构中引用数据元素时，必须设置 `COMPTYPE = 'E'` 并填充由数据元素决定的数据类型、长度与内部类型。

### 4.3 已存在对象的治理原则
1. **跨包冲突（如对象已存在于 `$TMP` 或其他包）**：
   - 严禁静默覆盖或强行写入，必须中断并向用户返回明确的包冲突提示（`severity = 'E'`），由用户决策是否通过重新打包转入目标包或更换对象名。
2. **同包更新（对象已属于当前包）**：
   - 允许执行安全的字段增删与结构重构（`severity = 'W'`），重新激活并同步 CTS 锁。

---

## 5. 安全红线

- 严禁在 DEV 以外的任何环境直接修改代码。
- 严禁在修改非 `$TMP` 对象时不挂载有效的 Workbench 请求。
- 严禁直接释放开发主请求，测试推送必须通过 TOC (Transport of Copies)。
