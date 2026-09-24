# Playbook: 对象读取、诊断与表数据查询

本文档指导如何通过 `scripts/sap_ai_mcp_client.py` 进行 SAP 对象源码读取、表数据检索与接口/锁诊断。

---

## 1. 源码与结构读取

统一使用 `read` 子命令。默认输出简要信息与日志路径，如需在终端查看完整代码，添加 `--full-source` 参数。

### 1.1 读取报表 (Report / Program)
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 read report <REPORT_NAME> [--full-source]
```

### 1.2 读取类 (Global Class)
```bash
# 读取整个类结构/方法列表
python3 scripts/sap_ai_mcp_client.py --profile dev200 read class <CLASS_NAME>

# 读取指定方法源码 (版本支持 ACTIVE, INACTIVE, BOTH)
python3 scripts/sap_ai_mcp_client.py --profile dev200 read method <CLASS_NAME> <METHOD_NAME> [--version ACTIVE] [--full-source]
```

### 1.3 读取函数模块与函数组 (Function Module / Function Group)
```bash
# 读取单个函数源码
python3 scripts/sap_ai_mcp_client.py --profile dev200 read function <FUNCTION_NAME> [--full-source]

# 读取整个函数组及其 Include 清单
python3 scripts/sap_ai_mcp_client.py --profile dev200 read function-group <FUNCTION_GROUP>
```

---

## 2. 数据库透明表查询 (`table read`)

用于安全查询 SAP 业务表或配置表数据（单次最大默认 100 行，上限 1000 行）。

```bash
# 基本查询
python3 scripts/sap_ai_mcp_client.py --profile dev200 table read MARA --max-rows 10

# 带 Open SQL WHERE 条件查询
python3 scripts/sap_ai_mcp_client.py --profile dev200 table read VBAK --where "VBTYP = 'C' AND ERDAT >= '20250101'" --max-rows 20
```

---

## 3. 探针与锁诊断 (Diagnostic Calls)

对于锁状态、DDIC 字段结构等诊断，使用 `call` 子命令配合简易 JSON：

```bash
# 查询对象锁定情况
python3 scripts/sap_ai_mcp_client.py --profile dev200 call debug_locks <PAYLOAD_JSON>
# PAYLOAD: {"object_name": "ZTEST_PROG"}

# 查询 DDIC 字段定义
python3 scripts/sap_ai_mcp_client.py --profile dev200 call debug_ddic_fields <PAYLOAD_JSON>
# PAYLOAD: {"type_name": "ZTFI002"}
```
