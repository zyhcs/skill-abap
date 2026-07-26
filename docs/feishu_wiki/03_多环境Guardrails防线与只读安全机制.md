# 03. 多环境 Guardrails 防线与只读安全机制

在企业级 SAP 系统管理中，生产环境 (PRD) 与测试环境 (QAS) 的数据与代码安全至关重要。`sap-ai-mcp-rest-api` 设计了严密的多环境客户端防线机制 (Client-side Guardrails)。

---

## 多环境配置模型 (`config/sap_environments.json`)

系统在 [config/sap_environments.json](file:///c:/Users/37145/Desktop/abap-mcp-api/config/sap_environments.json) 中显式定义各环境的性质与写权限开关 `allow_write`：

```json
{
  "default_profile": "dev",
  "profiles": {
    "dev": {
      "description": "SAP Development System (Client 400) - Full Read/Write",
      "base_url": "http://mysap.goodsap.cn:50400/sap/bc/zai_mcp_rest?sap-client=400",
      "user_env": "SAP_DEV_USER",
      "password_env": "SAP_DEV_PASSWORD",
      "allow_write": true
    },
    "qas": {
      "description": "SAP Quality Assurance System (Client 200) - Controlled Testing",
      "base_url": "http://<your-sap-qas-host>:<port>/sap/bc/zai_mcp_rest?sap-client=200",
      "user_env": "SAP_QAS_USER",
      "password_env": "SAP_QAS_PASSWORD",
      "allow_write": false
    },
    "prd": {
      "description": "SAP Production System (Client 800) - Strict Read-Only & Diagnostics",
      "base_url": "https://<your-sap-prd-host>:<port>/sap/bc/zai_mcp_rest?sap-client=800",
      "user_env": "SAP_PRD_USER",
      "password_env": "SAP_PRD_PASSWORD",
      "allow_write": false
    }
  }
}
```

---

## 客户端防线拦截逻辑 (`sap_ai_mcp_lib.py`)

在发送任何 HTTP 请求前，`SapAiMcpClient` 内部方法 `ensure_write_allowed(endpoint)` 会检查即将调用的端点模式 (`mode: "write"`)：

```python
def ensure_write_allowed(self, endpoint: str) -> None:
    meta = ENDPOINTS.get(endpoint, {})
    mode = meta.get("mode", "read")
    if mode == "write" and not self.allow_write:
        raise SapAI_MCPError(
            f"ENVIRONMENT_WRITE_FORBIDDEN: Write endpoint '{endpoint}' "
            f"is forbidden under profile '{self.profile}' (allow_write=False)"
        )
```

### 环境权限控制矩阵

| 环境 Profile | 适用 SAP Client | `allow_write` | 可调用的端点模式 | 风险控制 |
| :--- | :--- | :--- | :--- | :--- |
| **`dev`** | Client 100 / 400 | `True` | `read`, `check`, `write` | 允许完整的代码开发与 DDIC 创建 |
| **`qas`** | Client 200 | `False` | `read`, `check` | 禁止任何写操作，仅允许检查与只读测试 |
| **`prd`** | Client 800 | `False` | `read`, `check` | 严格只读，防范生产环境破坏 |

---

## 仓库自身修改防护 (Self-Modification Boundary)

除了多环境拦截，SAP 后端 `ZCL_AI_MCP_REST_FUN.abap` 内部还嵌入了**自我保护正交校验**：

```abap
" 阻止通过 AI REST 接口修改 REST 接口本身的处理类
IF iv_object_name = 'ZCL_AI_MCP_REST_FUN' OR iv_object_name = 'ZCL_AI_MCP_REST_HANDLER'.
  ev_error = 'SELF_MODIFICATION_FORBIDDEN: Cannot modify the AI REST handler class via itself'.
  RETURN.
ENDIF.
```
防止 AI 意外修改或毁坏通信核心服务本身。
