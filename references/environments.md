# SAP 多环境 (DEV / QAS / PRD) Profiles 与安全护栏配置指南

本文档说明如何在 `sap-ai-mcp-rest-api` 中配置并使用多环境（开发环境 DEV、QA 测试环境 QAS、生产环境 PRD）以及客户端安全护栏机制。

---

## 1. 配置文件 `config/sap_environments.json`

在 SDK 根目录下提供 `config/sap_environments.json` 配置文件：

```json
{
  "default_profile": "dev",
  "profiles": {
    "dev": {
      "description": "SAP 开发环境 (Client 100) - 全功能读写",
      "base_url": "http://<your-sap-dev-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100",
      "user_env": "SAP_DEV_USER",
      "password_env": "SAP_DEV_PASSWORD",
      "allow_write": true
    },
    "qas": {
      "description": "SAP 测试环境 (Client 200) - 受控测试只读",
      "base_url": "http://<your-sap-qas-host>:<port>/sap/bc/zai_mcp_rest?sap-client=200",
      "user_env": "SAP_QAS_USER",
      "password_env": "SAP_QAS_PASSWORD",
      "allow_write": false
    },
    "prd": {
      "description": "SAP 生产环境 (Client 800) - 严格只读排错诊断",
      "base_url": "https://<your-sap-prd-host>:<port>/sap/bc/zai_mcp_rest?sap-client=800",
      "user_env": "SAP_PRD_USER",
      "password_env": "SAP_PRD_PASSWORD",
      "allow_write": false
    }
  }
}
```

---

## 2. 客户端只读安全护栏 (Safety Guardrails)

* **`allow_write: true`** (DEV 环境)：允许所有端点操作（包含 `/object/save`, `/object/activate`, `/ddic/create` 等）。
* **`allow_write: false`** (QAS / PRD 环境)：自动开启拦截护栏。
  当尝试发起任何 `mode="write"` 的写入端点时，客户端 SDK 会在本地**直接阻断**并抛出结构化异常：
  ```text
  [ENVIRONMENT_WRITE_FORBIDDEN] Write operation 'object_save' (/object/save) is forbidden in profile 'prd' [SAP Production System]. Current profile is read-only.
  ```

---

## 3. CLI 指令与 MCP 工具使用

在 CLI 脚本中使用 `--profile` / `-p` 指定目标环境：

```bash
# 在 DEV 环境开发部署
python scripts/sap_ai_mcp_client.py --profile dev deploy-report --name ZTEST_PROGRAM --source-file ztest.abap

# 在 QAS 环境只读查看程序
python scripts/sap_ai_mcp_client.py --profile qas read-report --name ZTEST_PROGRAM

# 在 PRD 环境诊断排错 (尝试写操作会被自动阻断)
python scripts/sap_ai_mcp_debug.py --profile prd read-method --class-name ZCL_TEST --method-name MAIN
```

---

## 4. 环境变量覆盖规则

凭据按以下优先级解析：
1. 命令行参数 `--user` / `--password` / `--base-url`
2. 环境指定环境变量（如 `SAP_DEV_USER`, `SAP_PRD_USER`）
3. 通用环境变量 `SAP_AI_MCP_USER` / `SAP_USER`
4. 配置文件 `config/sap_environments.json` 中的 `user` / `base_url`
