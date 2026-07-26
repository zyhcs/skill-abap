# 04. 对象命名规范机制 (object_naming_rules.json)

为确保 AI 生成的所有 SAP 仓库对象（程序、类、表、数据元素、域等）符合企业统一规范，系统构建了可调配的命名规则引擎 [rules/object_naming_rules.json](file:///c:/Users/37145/Desktop/abap-mcp-api/rules/object_naming_rules.json)。

---

## 配置文件结构

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "SAP Object Naming Rules",
  "description": "定义 SAP 自定义对象（程序、类、函数、透明表、域等）的命名规范",
  "global_prefix": "Z",
  "module_prefixes": {
    "SD": "ZSD",
    "MM": "ZMM",
    "FI": "ZFI",
    "CO": "ZCO",
    "PP": "ZPP",
    "SYS": "ZSYS"
  },
  "object_patterns": {
    "PROG": "{TAG}{MODULE}RP_{NAME}",
    "CLAS": "ZCL_{NAME}",
    "FUNC": "ZFM_{MODULE}_{NAME}",
    "FUGR": "ZFG_{MODULE}_{NAME}",
    "TABL": "ZT{MODULE}_{NAME}",
    "DTEL": "ZDE_{NAME}",
    "DOMA": "ZDO_{NAME}"
  },
  "rules_notes": [
    "1. 所有自定义对象名必须以 Z 开头 (系统硬性防护)。",
    "2. 建议根据业务模块填充 {MODULE} 前缀。"
  ]
}
```

---

## 对应关系与实例

| 对象类型 (R3TR) | 命名 Pattern | 标准命名示例 | 说明 |
| :--- | :--- | :--- | :--- |
| **TABL (透明表)** | `ZT{MODULE}_{NAME}` | `ZTDEMO_ZYH` | 透明表前缀 `ZT` |
| **DTEL (数据元素)** | `ZDE_{NAME}` | `ZDE_ZYH_ID` | 数据元素前缀 `ZDE` |
| **DOMA (域)** | `ZDO_{NAME}` | `ZDO_ZYH_ID` | 数据域前缀 `ZDO` |
| **CLAS (全局类)** | `ZCL_{NAME}` | `ZCL_AI_MCP_REST_FUN` | 全局类前缀 `ZCL` |
| **PROG (报表程序)** | `{TAG}{MODULE}RP_{NAME}` | `ZRP_DEMO_ZYH` | 报表程序前缀 `ZRP` |
| **FUNC (函数模块)** | `ZFM_{MODULE}_{NAME}` | `ZFM_SD_CALC_TAX` | 函数模块前缀 `ZFM` |
| **FUGR (函数组)** | `ZFG_{MODULE}_{NAME}` | `ZFG_SD_INTERFACE` | 函数组前缀 `ZFG` |

---

## 校验逻辑与扩展方式

1. **AI Agent 前置校验**：AI 在调用 `/ddic/validate_names` 或构造 `/object/save` Payload 之前，必须先读取本 JSON 文件中的规则，生成符合规则的对象名称。
2. **企业自定义**：企业可根据自身的 SAP 开发规范，修改 `module_prefixes` 或 `object_patterns` 中的模板定义。
