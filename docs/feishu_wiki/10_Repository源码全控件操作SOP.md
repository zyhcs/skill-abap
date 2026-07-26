# 10. Repository 源码全控件操作 SOP (Report, Class, FM, Dynpro, Message, Textpool)

`sap-ai-mcp-rest-api` 覆盖了 SAP 核心 Repository 对象全生态的操作能力，每个对象类型均有专用的 Playbook SOP。

---

## 1. 报表程序 (Report Program - R3TR PROG)
* **SOP 流程**：`references/playbook-report.md`
* **标准三步法**：
  1. `/object/check` (语法检查，捕获 `SYNTAX-CHECK` 错误与词位置)
  2. `/object/save` (保存源码至 `$TMP` 或 Workbench 传输号)
  3. `/object/activate` (生成并激活程序)

---

## 2. 全局类与接口 (Global Class - R3TR CLAS / INTF)
* **SOP 流程**：`references/playbook-class.md`
* **接口约定**：
  * 支持类 Header/Local Definition/Implementation 与 Method 级别代码分段更新。
  * 自动维护 `VSEOCLASS` 元数据及包归属。

---

## 3. 函数模块与函数组 (Function Module / Group - R3TR FUGR / FUGR)
* **SOP 流程**：`references/playbook-function-module.md`
* **机制**：
  * 新建函数模块前自动校验或创建关联的函数组 (Function Group) `ZFG_*`；
  * 函数模块传输挂载在其绑定的函数组上 (`R3TR FUGR <group>`)。

---

## 4. Dynpro 屏幕与消息类 (Dynpro, Message Class, Textpool)
* **Dynpro 屏幕**：`references/playbook-dynpro.md`（屏幕号 `9___` 逻辑，流逻辑 FLOW LOGIC 格式）
* **消息类**：`references/playbook-message.md`（`MSAG` 消息编号与带参数消息文本）
* **文本池 Textpool**：`references/playbook-textpool.md`（程序选择文本 Selection Texts 与标题按钮池）
