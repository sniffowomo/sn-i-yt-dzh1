# n8n Automation Example - From

## Simple Email Notification Workflow

**Trigger**: New row added to Google Sheet
**Action**: Send Slack notification with row data

### Workflow Structure

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Google      │───▶│ Set         │───▶│ Slack       │
│ Sheets      │    │ (Format)    │    │ Message     │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Node Configuration

#### 1. Google Sheets Trigger

```json
{
  "node": "GoogleSheets",
  "operation": "onChangeCreatedUpdated",
  "sheetId": "YOUR_SHEET_ID",
  "worksheet": "Sheet1",
  "returnAll": false,
  "limit": 1
}
```

#### 2. Set Node (Format Data)

```json
{
  "node": "Set",
  "options": {
    "values": {
      "Name": "={{ $json.Name }}",
      "Email": "={{ $json.Email }}",
      "Status": "={{ $json.Status }}"
    }
  }
}
```

#### 3. Slack Node

```json
{
  "node": "Slack",
  "operation": "message",
  "channel": "#notifications",
  "text": "=New lead: {{ $json.Name }} ({{ $json.Email }}) - Status: {{ $json.Status }}"
}
```

---

## AI-Powered Customer Support Bot

**Trigger**: Incoming webhook
**Action**: Classify intent → Query knowledge base → Send response

### Workflow Structure

```
┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐
│ Webhook   │──▶│ Classify  │──▶│ Vector    │──▶│ Format    │
│ (POST)    │   │ Intent    │   │ Search    │   │ Response  │
└───────────┘   └───────────┘   └───────────┘   └───────────┘
                                                      │
                                                      ▼
                                              ┌───────────┐
                                              │ Send      │
                                              │ Response  │
                                              └───────────┘
```

### Node Configuration

#### 1. Webhook

```json
{
  "node": "Webhook",
  "path": "support-bot",
  "method": "POST",
  "responseMode": "lastNode"
}
```

#### 2. AI Agent (Classify Intent)

```json
{
  "node": "LangChain Agent",
  "model": "gpt-4",
  "prompt": "=Classify this customer message into one of: [billing, technical, general]\n\nMessage: {{ $json.message }}"
}
```

#### 3. Vector Store Search (Knowledge Base)

```json
{
  "node": "Pinecone",
  "operation": "search",
  "query": "={{ $json.message }}",
  "index": "support-docs",
  "topK": 3
}
```

#### 4. AI Agent (Generate Response)

```json
{
  "node": "LangChain Agent",
  "model": "gpt-4",
  "prompt": "=Based on this context, answer the customer's question:\n\nQuestion: {{ $json.message }}\n\nContext: {{ $json.results }}"
}
```

---

## Scheduled Data Sync

**Trigger**: Every hour
**Action**: Fetch API data → Transform → Update database

### Workflow Structure

```
┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐
│ Schedule  │──▶│ HTTP      │──▶│ Code      │──▶│ Postgres  │
│ (Hourly)  │   │ Request   │   │ (Transform)│   │ Upsert    │
└───────────┘   └───────────┘   └───────────┘   └───────────┘
```

### Node Configuration

#### 1. Schedule Trigger

```json
{
  "node": "Schedule Trigger",
  "triggerTimes": {
    "item": {
      "mode": "everyHour"
    }
  }
}
```

#### 2. HTTP Request

```json
{
  "node": "HTTP Request",
  "method": "GET",
  "url": "https://api.example.com/products",
  "authentication": "predefinedCredentialType",
  "nodeCredentialType": "httpHeaderAuth",
  "options": {
    "response": {
      "response": {
        "fullResponse": true
      }
    }
  }
}
```

#### 3. Code Node (Transform)

```javascript
// JavaScript transformation
const products = $input.all().map((item) => {
  const data = item.json
  return {
    external_id: data.id,
    name: data.title,
    price: parseFloat(data.price),
    category: data.category?.name,
    in_stock: data.inventory > 0,
    last_updated: new Date().toISOString(),
  }
})

return products.map((p) => ({ json: p }))
```

#### 4. Postgres Upsert

```json
{
  "node": "Postgres",
  "operation": "upsert",
  "table": "products",
  "schema": "public",
  "columns": [
    "external_id",
    "name",
    "price",
    "category",
    "in_stock",
    "last_updated"
  ],
  "updateColumns": ["name", "price", "category", "in_stock", "last_updated"],
  "conflictColumn": "external_id"
}
```

---

## Error Handling Pattern

Add error handling to any workflow:

```
┌───────────┐   ┌───────────┐   ┌───────────┐
│ Main      │──▶│ Try It    │──▶│ Error     │
│ Workflow  │   │ (Action)  │   │ Trigger   │
└───────────┘   └───────────┘   └───────────┘
                              │
                              ▼
                       ┌──────────────┐
                       │ Catch Error  │
                       │ → Log → Alert│
                       └──────────────┘
```

---

## Getting Started Tips

1. **Start simple**: One trigger → one action
2. **Use templates**: n8n has a template library
3. **Test with manual trigger**: Switch to manual while building
4. **Use expressions**: `{{ $json.field }}` for dynamic values
5. **Error handling**: Wrap critical operations in Try/Catch
6. **Credentials**: Store separately from workflow logic
