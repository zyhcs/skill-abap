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

## 4. 安全红线

- 严禁在 DEV 以外的任何环境直接修改代码。
- 严禁在修改非 `$TMP` 对象时不挂载有效的 Workbench 请求。
- 严禁直接释放开发主请求，测试推送必须通过 TOC (Transport of Copies)。
