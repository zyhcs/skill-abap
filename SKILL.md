---
name: sap-ai-mcp-rest-api
description: 使用自定义 SAP AI MCP REST 接口实现 SAP ABAP 与 DDIC 对象的自动化读取、创建、语法检查、修复、激活、表查询与 CTS 传输流水线。
---

# SAP AI MCP REST API 统一开发指南

本 Skill 用于通过 `zai_mcp_rest` 服务与 SAP 系统进行实时交互。

---

## 1. 唯一操作入口 (Unified Client)

所有与 SAP 的交互**必须 100% 统一使用官方客户端** `scripts/sap_ai_mcp_client.py`，严禁直接使用 curl 或手写未封装的临时网络请求。

* **指定目标环境**：使用 `--profile <name>` 或 `-p <name>`（如 `--profile dev200`、`--profile qas600`）。
* **查看连通性与能力**：
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev200 capabilities
  ```

---

## 2. 三大核心工作流 (Playbook 快速索引)

根据当前任务场景，**仅按需阅读对应的单个 Playbook**：

| 业务场景 | 对应 Playbook | 典型命令示例 |
| :--- | :--- | :--- |
| **① 读取/诊断/查表** | `references/playbook_inspect_and_read.md` | `python3 scripts/sap_ai_mcp_client.py read report <NAME>`<br>`python3 scripts/sap_ai_mcp_client.py table read MARA` |
| **② 编写/修改/部署** | `references/playbook_develop_and_deploy.md` | `python3 scripts/sap_ai_mcp_client.py report deploy <JSON>`<br>`python3 scripts/sap_ai_mcp_client.py class repair-method <JSON>` |
| **③ 传输请求/TOC/测试导入** | `references/playbook_transport_pipeline.md` | `python3 scripts/sap_ai_mcp_client.py transport create --type T`<br>`python3 scripts/sap_ai_mcp_client.py transport copy --source-tr ...` |

---

## 3. 核心安全铁律 (Strict Safety Guardrails)

1. **环境隔离**：所有的代码修改与对象创建必须在 DEV 环境（例如 `--profile dev200`）进行；严禁在 QAS/PRD 等非开发系统修改代码。
2. **CTS 请求关联**：任何非 `$TMP`（正式包）的对象创建或修改，必须传入有效的 Workbench 传输请求号（`transport`）。
3. **导入测试环境**：执行 `/transport/import` 导入请求到测试系统时，必须使用测试环境 Profile（例如 `--profile qas600`），严禁使用 DEV Profile。
4. **禁止自修改**：绝对禁止通过 REST 接口保存或修改 `ZCL_AI_MCP_REST_FUN` / `ZCL_AI_MCP_REST_HANDLER*` 自身。

---

## 4. 规范与排错参考 (按需查阅)

* **黄金规则卡片**：`rules/golden_rules.md` (命名规范、变量前缀 `lv_/lt_/ls_`、SQL 查询限制)
* **故障与错误自愈**：`references/troubleshooting.md`
* **深层语法手册 (严禁全量加载，仅按需行切片查看)**：
  - 经典语法：`rules/abap_syntax_guide_classic.md`
  - S/4HANA 7.5+ 语法：`rules/abap_syntax_guide_s4hana.md`
