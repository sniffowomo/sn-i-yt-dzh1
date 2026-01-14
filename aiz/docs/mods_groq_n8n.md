Below is a ready‑to‑copy Markdown document that explains how to build an automation in **n8n**.  
Save the whole block (including the opening `---` and closing `---` if you like) as **`n8n_groq_mods.md`** on your computer.

---  
```markdown
# n8n Automation – Step‑by‑Step Guide  

*Version: 1.0 – Updated 2024‑10‑01*  

---  

## Table of Contents  

1. [What is n8n?](#what-is-n8n)  
2. [Prerequisites](#prerequisites)  
3. [Installation Options](#installation-options)  
4. [Creating Your First Workflow](#creating-your-first-workflow)  
   - 4.1 [Add a Trigger Node](#add-a-trigger-node)  
   - 4.2 [Add Action Nodes](#add-action-nodes)  
   - 4.3 [Connecting Nodes & Setting Data Flow](#connecting-nodes--setting-data-flow)  
   - 4.4 [Using Expressions & Functions](#using-expressions--functions)  
5. [Managing Credentials Securely](#managing-credentials-securely)  
6. [Testing & Debugging](#testing--debugging)  
7. [Deploying & Scheduling Workflows](#deploying--scheduling-workflows)  
8. [Common Use‑Case Examples](#common-use-case-examples)  
9. [Tips & Best Practices](#tips--best-practices)  
10. [Further Resources](#further-resources)  

---  

## 1. What is n8n?  

n8n (pronounced “n-eight-n”) is an **open‑source workflow automation tool** that lets you connect APIs, databases, SaaS services, and custom code without writing a full application.  
- **Node‑based UI** – each step is a *node* (trigger, action, or function).  
- **Self‑hosted or cloud** – you control where it runs.  
- **Extensible** – write your own JavaScript functions or custom nodes.  

---  

## 2. Prerequisites  

| Item | Why it matters |
|------|----------------|
| **Node.js ≥ 18** | n8n runs on Node; the LTS version is recommended. |
| **Docker (optional)** | Simplifies installation & isolation. |
| **A GitHub/Google/Slack/etc. account** | Most integrations need OAuth credentials. |
| **Basic JavaScript knowledge** | Helpful for expressions, functions, and custom code nodes. |

---  

## 3. Installation Options  

| Method | Command / Steps | When to use |
|--------|----------------|-------------|
| **Docker (quick start)** | ```bash\ndocker run -d --name n8n \\\n  -p 5678:5678 \\\n  -v ~/.n8n:/home/node/.n8n \\\n  n8nio/n8n\n``` | Development, testing, or small‑scale production. |
| **npm (local dev)** | ```bash\nnpm install n8n -g\nn8n start\n``` | When you want to run it directly from your shell. |
| **Self‑hosted (Linux service)** | Follow the official *“Run n8n on a VPS”* guide – install via Docker or systemd. | Production, high‑availability, or when you need custom environment variables. |

> **Tip:** Set `N8N_BASIC_AUTH_ACTIVE=true` and `N8N_BASIC_AUTH_USER` / `N8N_BASIC_AUTH_PASSWORD` environment variables to protect the UI.

---  

## 4. Creating Your First Workflow  

### 4.1 Add a Trigger Node  

1. Open the UI at `http://localhost:5678`.  
2. Click **“+ New Workflow”** → **“Save”** (give it a name).  
3. Click the **“+”** button → **“Trigger”** → choose a trigger type, e.g.:  
   - **Webhook** – receives HTTP requests.  
   - **Cron** – runs on a schedule.  
   - **Schedule Trigger** – similar to Cron but UI‑friendly.  

**Example:** Use a **Webhook** trigger to start the workflow when an external service POSTs data.

```yaml
# (shown in UI, not code)
Trigger → Webhook
  URL: https://your‑domain.com/webhook/n8n-demo
  Method: POST
```

### 4.2 Add Action Nodes  

After the trigger, add nodes that perform work:

| Node | Typical Use |
|------|-------------|
| **HTTP Request** | Call any REST API. |
| **Google Sheets** | Append rows, read data. |
| **Slack** | Send messages to a channel. |
| **Function** | Run custom JavaScript. |
| **Set** | Create or modify JSON fields. |

**Example chain:**  
`Webhook → Set (format payload) → Google Sheets (append row) → Slack (notify)`

### 4.3 Connecting Nodes & Setting Data Flow  

1. Drag the **output** dot of the first node onto the **input** dot of the next node.  
2. The **green line** indicates the data flow.  
3. Click a node to open its **parameters panel**. Use the **“Add Parameter”** button for optional fields.  

### 4.4 Using Expressions & Functions  

- **Expressions** are wrapped in `{{ }}` and let you reference previous node data.  
  ```js
  {{ $json["email"] }}          // value of “email” from the current node
  {{ $node["Google Sheets"].json["id"] }} // value from a specific node
  ```
- **Function Node** lets you write JavaScript that receives `items` (an array of objects) and returns a new array.  

```js
// Example: Convert a timestamp to ISO string
return items.map(item => {
  item.json.isoDate = new Date(item.json.timestamp).toISOString();
  return item;
});
```

---  

## 5. Managing Credentials Securely  

1. Click **“Credentials”** in the left sidebar.  
2. Choose the service (e.g., **Google OAuth2**, **Slack API Token**).  
3. Fill in client ID/secret or token – **never hard‑code** them in nodes.  
4. In a node, select the credential from the dropdown.  

**Environment variables** can also be used:  

```bash
export N8N_GOOGLE_API_KEY=$GOOGLE_API_KEY
```

Then reference the variable in the credential UI (`{{ $env.N8N_GOOGLE_API_KEY }}`).

---  

## 6. Testing & Debugging  

| Feature | How to use |
|---------|------------|
| **Execute Workflow** | Click the **“Execute Workflow”** button (top right). The UI shows each node’s input/output in real time. |
| **Error Handling** | Add an **“Error Trigger”** node or enable **“Continue on Fail”** on a node to capture failures. |
| **Log Output** | In the **Function** node, `console.log()` writes to the server logs (visible in Docker logs). |
| **Versioning** | Use **“Save as…”** to duplicate a workflow before making major changes. |

---  

## 7. Deploying & Scheduling Workflows  

1. **Self‑Hosted Production** – run n8n as a Docker container with `restart: unless-stopped`.  
2. **Cron / Schedule Triggers** – set the cron expression (e.g., `0 9 * * MON` for every Monday at 9 AM).  
3. **Webhook Security** – enable **“Authentication”** on the webhook node (basic auth, header token, or signature verification).  

**Example Docker‑Compose for production:**

```yaml
version: "3.8"
services:
  n8n:
    image: n8nio/n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=SuperSecret123
      - N8N_HOST=your-domain.com
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
    volumes:
      - ~/.n8n:/home/node/.n8n
```

---  

## 8. Common Use‑Case Examples  

| Use‑Case | Trigger | Action Nodes | Brief Description |
|----------|---------|--------------|-------------------|
| **New Lead → CRM** | Webhook (from landing‑page form) | Set → HTTP Request (POST to HubSpot) → Slack (notify sales) | Automates lead capture without manual entry. |
| **Daily Report** | Cron (00:00) | Google Sheets (read rows) → Function (aggregate) → Email (send report) | Sends a summary of yesterday’s data every morning. |
| **File Sync** | Dropbox Trigger (new file) | HTTP Request (download) → S3 (upload) → Telegram (alert) | Mirrors a Dropbox folder to an S3 bucket and notifies a channel. |
| **Error Monitoring** | HTTP Request (status endpoint) → Function (check code) → If > 400 → PagerDuty (trigger) | Simple health‑check with alerting. |

---  

## 9. Tips & Best Practices  

- **Keep nodes atomic** – one node should do one logical step; makes debugging easier.  
- **Use “Set” nodes** early to normalise data structures (e.g., rename fields).  
- **Leverage “Execute Workflow”** in a sandbox environment before activating a production webhook.  
- **Document workflows**: add a **“Comment”** node at the top with a description, version, and owner.  
- **Backup** the `~/.n8n` folder (or the Docker volume) regularly; it contains all workflow JSON files.  
- **Limit exposure**: run n8n behind a reverse proxy (NGINX, Traefik) with TLS termination.  

---  

## 10. Further Resources  

| Resource | Link |
|----------|------|
| Official Docs | <https://docs.n8n.io/> |
| Community Forum | <https://community.n8n.io/> |
| GitHub Repository | <https://github.com/n8n-io/n8n> |
| Pre‑built Templates | <https://n8n.io/workflows> |
| Docker Hub Image | <https://hub.docker.com/r/n8nio/n8n> |

---  

*End of `n8n_groq_mods.md`*  

---  

**How to save:**  

1. Copy everything between the three back‑ticks (including the opening/closing triple‑backticks).  
2. Paste it into a plain‑text editor (VS Code, Sublime, Notepad++, etc.).  
3. Save the file as **`n8n_groq_mods.md`**.  

You now have a complete markdown guide you can refer to or share with teammates. Happy automating!

