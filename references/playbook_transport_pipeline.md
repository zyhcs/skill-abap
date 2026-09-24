# Playbook: 传输请求 (TR) 精密锁定与 TOC 自动化测试流水线

本文档指导如何通过 `scripts/sap_ai_mcp_client.py` 自动化完成开发请求管理、修改挂载锁定、TOC 副本打包以及测试系统导入。

---

## 1. 核心铁律 (Safety Guardrails)

1. **开发环境写操作**：严禁在除 DEV 开发环境之外的任何环境（如 QAS 测试环境）直接修改代码。
2. **非本地包挂载请求**：任何非本地包（非 `$TMP`）的对象修改，都必须将对象包含在有效的传输请求 (TR) 中。
3. **测试环境导入使用专属 Profile**：导入到测试环境时，必须使用测试环境专用的 Profile（例如 `--profile qas600`），绝对不能使用默认的开发环境 Profile。

---

## 2. 端到端自动化修改流 (Modify -> Lock -> TOC -> QA)

### 步骤 1：查询或创建 Workbench 开发请求 (TR)

```bash
# 1. 查找当前用户未释放的主请求
python3 scripts/sap_ai_mcp_client.py --profile dev200 transport search

# 2. 如果没有合适的请求，自动创建 Workbench 开发请求
# 命名规则: <MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>
python3 scripts/sap_ai_mcp_client.py --profile dev200 transport create --type W --text "SD_UPDATE_PRICE_CALC_BY_021569_20260924"
# 输出返回: {"status": "OK", "trkorr": "S4DK900123"}
```

### 步骤 2：执行源码修改并精密挂载锁定 (LIMU)

在保存修改时传入 TR 号，底层会自动将修改挂载到 TR 任务中：

- **函数模块 (Function Module)**: 会精密挂载 `LIMU FUNC <FUNCTION_NAME>`，不会锁死整个函数组。
- **Include 文件**: 会精密挂载 `LIMU REPS <INCLUDE_NAME>`。
- **报表/类 (Report/Class)**: 挂载 `R3TR PROG <NAME>` 或 `R3TR CLAS <NAME>`。

```bash
# 修改并部署（Payload 中携带 transport: "S4DK900123"）
python3 scripts/sap_ai_mcp_client.py --profile dev200 function repair repair_payload.json
```

### 步骤 3：创建 TOC (Transport of Copies) 并合并物理对象

为保证开发请求始终处于可编辑状态，禁止直接释放开发主请求。通过 TOC 将物理对象打包并推送给测试环境：

```bash
# 1. 创建 TOC 请求 (类型传 T，target 传目标系统如 S4Q)
# 命名规则: TOC_<MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>
python3 scripts/sap_ai_mcp_client.py --profile dev200 transport create --type T --text "TOC_SD_UPDATE_PRICE_CALC_BY_021569_20260924" --target "S4Q"
# 输出返回: {"status": "OK", "trkorr": "S4DK900999"}

# 2. 将原开发请求中的物理对象合并到 TOC (自动过滤 CORR 垃圾条目)
python3 scripts/sap_ai_mcp_client.py --profile dev200 transport copy --source-tr "S4DK900123" --target-tr "S4DK900999"
```

### 步骤 4：释放 TOC 并导入测试系统 (QAS)

```bash
# 1. 释放 TOC 请求 (自动倒序释放任务与主请求)
python3 scripts/sap_ai_mcp_client.py --profile dev200 transport release --trkorr "S4DK900999"

# 2. 调用测试系统 Profile 执行物理导入
python3 scripts/sap_ai_mcp_client.py --profile qas600 transport import --trkorr "S4DK900999" --system "S4Q" --client "600"
```
