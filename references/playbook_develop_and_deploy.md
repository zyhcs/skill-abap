# Playbook: ABAP 对象开发、修改、语法检查与部署

本文档指导如何通过 `scripts/sap_ai_mcp_client.py` 自动化创建、修改、修复及激活 SAP 开发对象。

---

## 1. 报表程序开发 (`report deploy`)

流水线自动执行：**语法检查 -> 保存源码 -> 激活程序**。

### 1.1 准备 Payload 文件 (`payload.json`)
```json
{
  "object_type": "PROG",
  "object_name": "ZR_SD_ORDER_REPORT",
  "package": "$TMP",
  "transport": "",
  "program_type": "1",
  "source_code": "REPORT zr_sd_order_report.\n\nWRITE: / 'Hello SAP'."
}
```
> **注意**：非 `$TMP` 包对象必须传入有效 Workbench 请求号 `transport`。

### 1.2 执行部署
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 report deploy payload.json
```

---

## 2. 全局类开发与方法级修复 (`class deploy / repair-method`)

### 2.1 全局类整体验证与部署
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 class deploy class_payload.json
```

### 2.2 类方法单点快速修复 (`class repair-method`)
无需保存整个类，仅更新并检查单个方法的实现源码：
```json
{
  "class_name": "ZCL_SD_ORDER_HELPER",
  "method_name": "CALCULATE_PRICE",
  "source_code": "  rv_price = iv_qty * iv_rate.",
  "check_after_save": true,
  "activate_after_check": true
}
```
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 class repair-method method_payload.json
```

---

## 3. 函数模块与函数组 (`function deploy / check / repair`)

### 3.1 创建新函数模块 (`function deploy`)
流水线自动执行：**创建函数 (或函数池) -> 语法检查**。
```json
{
  "function_name": "ZSDF_GET_PRICE",
  "function_group": "ZSDG_SALES",
  "short_text": "获取商品价格",
  "package": "$TMP",
  "transport": "",
  "source_code": "  DATA lv_base TYPE p.\n  ..."
}
```
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 function deploy func_payload.json
```

### 3.2 函数语法检查与源码修复
```bash
# 检查函数语法
python3 scripts/sap_ai_mcp_client.py --profile dev200 function check ZSDF_GET_PRICE

# 修复函数源码
python3 scripts/sap_ai_mcp_client.py --profile dev200 function repair func_repair.json
```

### 3.3 动态执行函数测试 (`function execute`)
可直接模拟调用函数入参并获取返回值：
```json
{
  "function_name": "BAPI_USER_GET_DETAIL",
  "importing": {
    "USERNAME": "021569"
  }
}
```
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 function execute exec_payload.json
```

---

## 4. 文本符号与消息类 (`textpool / message`)

```bash
# 保存报表/函数文本符号 (TEXT-xxx)
python3 scripts/sap_ai_mcp_client.py --profile dev200 call textpool_save textpool_payload.json
# textpool_payload: {"object_type": "PROG", "object_name": "ZR_TEST", "id": "I", "key": "001", "text": "订单已确认"}

# 维护消息类消息文本 (T100)
python3 scripts/sap_ai_mcp_client.py --profile dev200 call message_save message_payload.json
# message_payload: {"message_class": "ZFICO01", "messages": [{"number": "AUTO", "text": "凭证过账成功"}]}
```

---

## 5. DDIC 数据字典对象 (`ddic deploy`)

流水线自动执行：**命名验证 -> 创建对象 -> 状态检查**。
```bash
python3 scripts/sap_ai_mcp_client.py --profile dev200 ddic deploy ddic_payload.json
```
