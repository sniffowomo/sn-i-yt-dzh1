[36m---AI MODULE START---[0m
[34mExecuting: mods -f "Write a markdown file, that explains how to write AgentSkills whicih i can use with Gemini and OpenCode"  [0m
```markdown
# Writing **AgentSkills** for Gemini & OpenCode  

*Version: 1.0*  
*Author: Your Name*  

---

## Table of Contents
1. [What are AgentSkills?](#what-are-agentskills)  
2. [Prerequisites](#prerequisites)  
3. [AgentSkill Anatomy](#agentskill-anatomy)  
4. [Creating a New Skill](#creating-a-new-skill)  
5. [Registering the Skill with Gemini](#registering-with-gemini)  
6. [Using the Skill with OpenCode](#using-with-opencode)  
7. [Testing & Debugging](#testing--debugging)  
8. [Best Practices & Tips](#best-practices--tips)  
9. [Full Example Project](#full-example-project)  

---

## 1. What are **AgentSkills**?  
**AgentSkills** are modular, reusable pieces of logic that an LLM‑based agent (e.g., Google Gemini) can invoke during a conversation.  
- They expose a **well‑defined JSON schema** for inputs and outputs.  
- The LLM decides *when* to call the skill based on the user’s intent.  
- The underlying implementation can be any Python (or other language) function, a REST endpoint, or a containerised service.  

When paired with **OpenCode**, the skill can also request code generation, compilation, or execution, making it ideal for tasks such as:
- Data extraction & transformation  
- Unit‑test generation  
- Automated refactoring  
- Querying external APIs  

---

## 2. Prerequisites  

| Item | Minimum version | Why it matters |
|------|----------------|----------------|
| **Python** | 3.9+ | Type hints & `dataclasses` |
| **Gemini SDK** | `google-generativeai>=0.3.0` | Skill‑calling support |
| **OpenCode SDK** | `opencode>=0.2.0` | Code‑generation utilities |
| **FastAPI** (optional) | 0.104+ | Expose skills as HTTP endpoints |
| **pydantic** | 2.0+ | Schema validation |
| **Docker** (optional) | – | Containerise skills for production |

Install the core libraries:

```bash
pip install google-generativeai opencode fastapi[all] pydantic
```

---

## 3. AgentSkill Anatomy  

A minimal skill consists of three parts:

1. **Schema** – JSON‑serialisable description of the input & output.  
2. **Implementation** – Python callable that receives the parsed input and returns the output.  
3. **Registration** – Code that tells Gemini/OpenCode about the skill (name, description, schema, endpoint).

### 3.1 Schema (pydantic)

```python
from pydantic import BaseModel, Field

class MySkillInput(BaseModel):
    """What the user must provide."""
    query: str = Field(..., description="Natural‑language question to answer.")
    max_results: int = Field(
        5,
        ge=1,
        le=20,
        description="Maximum number of results to return."
    )

class MySkillOutput(BaseModel):
    """What the skill returns to the LLM."""
    answer: str = Field(..., description="Short answer to the query.")
    sources: list[str] = Field(
        default_factory=list,
        description="List of URLs or references used."
    )
```

### 3.2 Implementation

```python
import httpx
from typing import List

def my_skill_impl(payload: MySkillInput) -> MySkillOutput:
    """
    Example: a simple web‑search skill using a public API.
    """
    # 1️⃣ Call an external API (e.g., SerpAPI, Bing)
    resp = httpx.get(
        "https://api.example.com/search",
        params={"q": payload.query, "num": payload.max_results},
        timeout=10,
    )
    resp.raise_for_status()
    data = resp.json()

    # 2️⃣ Build the answer (you could also let Gemini summarise)
    answer = " | ".join([item["title"] for item in data["results"]])
    sources = [item["link"] for item in data["results"]]

    return MySkillOutput(answer=answer, sources=sources)
```

### 3.3 Registration (FastAPI example)

```python
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse

app = FastAPI(title="AgentSkills Service")

@app.post(
    "/skills/my_search",
    response_model=MySkillOutput,
    summary="Search the web and return concise results."
)
async def my_search_endpoint(payload: MySkillInput):
    try:
        result = my_skill_impl(payload)
        return JSONResponse(content=result.model_dump())
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
```

Run locally:

```bash
uvicorn my_skill:app --host 0.0.0.0 --port 8000
```

---

## 4. Creating a New Skill  

1. **Define the problem** – What does the agent need to do?  
2. **Design the schema** – Keep it *small* (≤ 5 fields) for better LLM prompting.  
3. **Implement the logic** – Prefer pure functions; side‑effects (I/O) should be isolated.  
4. **Wrap with an API** (FastAPI, Flask, or a serverless function).  
5. **Document** – Provide a one‑sentence description and field‑level docs; Gemini uses them to decide when to call.  

**Tip:** If you plan to host many skills, create a shared `BaseSkill` class that stores `name`, `description`, and `endpoint_url`.  

---

## 5. Registering the Skill with **Gemini**  

Gemini’s SDK lets you supply a *tool* definition that mirrors the OpenAI function‑calling format.

```python
import google.generativeai as genai
from google.generativeai.types import Tool

# 1️⃣ Build the tool definition from the pydantic schema
def schema_to_tool(name: str, description: str, input_model: BaseModel) -> Tool:
    # Convert pydantic fields to JSON schema
    json_schema = input_model.model_json_schema()
    return Tool(
        name=name,
        description=description,
        parameters=json_schema,
    )

my_search_tool = schema_to_tool(
    name="my_search",
    description="Search the web for a short answer and return sources.",
    input_model=MySkillInput,
)

# 2️⃣ Initialise the Gemini model with the tool
model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    tools=[my_search_tool],
)

# 3️⃣ Example call – the model decides to invoke the tool
response = model.generate_content(
    "Find the latest release date of the Python 3.12 series.",
    generation_config={"temperature": 0.2},
)

print(response.candidates[0].content.parts)   # will include a tool call if needed
```

When the model returns a **tool call**, you must:

1. Extract the arguments.  
2. POST them to the skill endpoint (`/skills/my_search`).  
3. Feed the skill’s JSON response back to Gemini as a *tool result*.

```python
if response.candidates[0].content.parts[0].function_call:
    call = response.candidates[0].content.parts[0].function_call
    args = call.arguments  # already a dict
    # invoke the skill
    skill_resp = httpx.post(
        "http://localhost:8000/skills/my_search",
        json=args,
        timeout=10,
    ).json()
    # give Gemini the result
    final = model.generate_content(
        [response.candidates[0].content, {"role": "function", "name": call.name, "content": skill_resp}]
    )
    print(final.text)
```

---

## 6. Using the Skill with **OpenCode**  

OpenCode can call external tools the same way Gemini does, but it also lets you **generate code** to run inside the skill. A common pattern:

1. **Prompt OpenCode** to produce a helper function (e.g., a regex extractor).  
2. **Execute** the generated code in a sandbox.  
3. **Return** the result to Gemini (or directly to the user).

### 6.1 Example: Dynamic Data‑Parsing Skill

```python
from opencode import OpenCodeClient

oc = OpenCodeClient(model="opencode-1.0")

def dynamic_parser(input_text: str, pattern: str) -> list[str]:
    # Ask OpenCode to generate a Python function that extracts all matches
    prompt = f"""
    Write a pure‑Python function `extract(text: str) -> list[str]` that returns
    every substring of `text` matching the regular expression `{pattern}`.
    Do not import any third‑party libraries.
    """
    code = oc.generate_code(prompt)
    # Execute safely (use exec in a restricted namespace)
    namespace = {}
    exec(code, {}, namespace)
    extract = namespace["extract"]
    return extract(input_text)
```

Now embed this logic inside an AgentSkill:

```python
class RegexExtractInput(BaseModel):
    text: str = Field(..., description="The text to search.")
    regex: str = Field(..., description="Python regex pattern.")

class RegexExtractOutput(BaseModel):
    matches: list[str] = Field(..., description="All matches found.")

def regex_extract_impl(payload: RegexExtractInput) -> RegexExtractOutput:
    matches = dynamic_parser(payload.text, payload.regex)
    return RegexExtractOutput(matches=matches)
```

Register the skill with Gemini exactly as shown in Section 5, and you have a **self‑extending** skill that can generate its own parsing code on the fly.

---

## 7. Testing & Debugging  

| Step | Tool | Command |
|------|------|---------|
| **Unit test** | `pytest` | `pytest tests/test_my_skill.py` |
| **Schema validation** | `pydantic` | `MySkillInput(**bad_payload)` raises `ValidationError`. |
| **API sanity check** | `httpx` / `curl` | `curl -X POST http://localhost:8000/skills/my_search -d '{"query":"Python", "max_results":3}'` |
| **Gemini tool flow** | `gcloud` or local script | Run the snippet from Section 5 and inspect the `function_call` object. |
| **OpenCode sandbox** | `opencode` built‑in sandbox | `oc.run_code(code, timeout=5)` – ensures no infinite loops. |

Create a `tests/` folder with a few simple cases:

```python
# tests/test_my_skill.py
import pytest
from my_skill import MySkillInput, my_skill_impl

def test_basic_search():
    payload = MySkillInput(query="Python release date", max_results=1)
    result = my_skill_impl(payload)
    assert isinstance(result.answer, str)
    assert len(result.sources) == 1
```

Run:

```bash
pytest -q
```

---

## 8. Best Practices & Tips  

| Area | Recommendation |
|------|----------------|
| **Schema size** | Keep ≤ 5 fields; LLMs struggle with deep nesting. |
| **Naming** | Use snake_case for tool names (`my_search`, `regex_extract`). |
| **Idempotency** | Skills should be safe to call multiple times with the same input. |
| **Timeouts** | Enforce ≤ 5 s per HTTP call; longer calls cause the LLM to fallback. |
| **Security** | Never expose raw user input to `exec`/`eval` without sanitisation. Use OpenCode sandbox. |
| **Observability** | Log the incoming payload, the result, and the latency (e.g., via `structlog`). |
| **Versioning** | Include a `skill_version` field in the output schema for future upgrades. |
| **Testing** | Add property‑based tests (`hypothesis`) for random payloads. |
| **Documentation** | Keep the tool description under 150 characters – Gemini truncates longer strings. |

---

## 9. Full Example Project  

```
agent-skills/
│
├─ my_skill.py          # schema, impl, FastAPI app
├─ gemini_client.py    # Gemini registration & call helper
├─ opencode_helper.py  # dynamic code generation utilities
├─ requirements.txt
├─ Dockerfile           # optional containerisation
└─ tests/
   └─ test_my_skill.py
```

### `my_skill.py`

```python
# --------------------------------------------------------------
# my_skill.py – a complete AgentSkill (search + regex)
# --------------------------------------------------------------
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
import httpx
from typing import List
from opencode_helper import dynamic_parser   # see below

app = FastAPI(title="AgentSkills Service")

# ---------- Schemas ----------
class SearchInput(BaseModel):
    query: str = Field(..., description="Search query.")
    max_results: int = Field(5, ge=1, le=20, description="How many results to fetch.")

class SearchOutput(BaseModel):
    answer: str = Field(..., description="Concise answer.")
    sources: List[str] = Field(default_factory=list, description="Reference URLs

[31m---AI MODULE END---[0m
