# 11. Python Hybrid Lite SDK 客户端实现原理

Python Hybrid Lite SDK 位于 `scripts/` 目录下，是连接 AI Agent 与 SAP REST 服务端的轻量级驱动中间件。

---

## 核心脚本文件说明

```text
scripts/
├── sap_ai_mcp_client.py  # 命令行 CLI 交互入口 (解析 --profile, endpoint 及 JSON 参数)
├── sap_ai_mcp_lib.py     # SapAiMcpClient 核心 API 包装类
├── sap_ai_mcp_call.py    # 底层 HTTP 请求封装与 Base URL 格式检查
└── sap_ai_mcp_debug.py   # 诊断与锁检查调试工具
```

---

## `SapAiMcpClient` 类的核心逻辑

```python
class SapAiMcpClient:
    def __init__(self, profile: str = "dev", config_path: Optional[str] = None):
        self.profile = profile
        self.config = self._load_config(config_path)
        p_cfg = self.config["profiles"][profile]
        
        self.base_url = p_cfg["base_url"]
        self.allow_write = p_cfg.get("allow_write", False)
        self.user = os.getenv(p_cfg.get("user_env", ""), p_cfg.get("user", ""))
        self.password = os.getenv(p_cfg.get("password_env", ""), p_cfg.get("password", ""))

    def ensure_write_allowed(self, endpoint: str) -> None:
        mode = ENDPOINTS.get(endpoint, {}).get("mode", "read")
        if mode == "write" and not self.allow_write:
            raise SapAI_MCPError(f"ENVIRONMENT_WRITE_FORBIDDEN under profile '{self.profile}'")

    def call(self, endpoint: str, payload: dict) -> dict:
        self.ensure_write_allowed(endpoint)
        # 执行 HTTP POST 请求，注入 Basic Auth 与 PATH_INFO Header
        return send_http_request(self.base_url, self.user, self.password, endpoint, payload)
```

---

## CLI 工具命令行使用示例

```bash
# 1. 使用 dev Profile 查询 DDIC 状态
python scripts/sap_ai_mcp_client.py --profile dev ddic_status --domains '[{"name":"ZDO_ZYH_ID"}]'

# 2. 进行 ABAP 程序语法校验
python scripts/sap_ai_mcp_client.py --profile dev object_check --payload '{"object_type":"PROG","object_name":"ZRP_DEMO","source_code":"REPORT zrp_demo."}'

# 3. 触发 qas 只读防护阻断测试
python scripts/sap_ai_mcp_client.py --profile qas object_save --payload '...'
# ➔ 输出错误: SapAI_MCPError: ENVIRONMENT_WRITE_FORBIDDEN
```
