# Query 1: e2e_cli alias set Information Storage

## Summary
This document details the exact file locations and mechanisms where `e2e_cli alias set` command information is stored and managed.

## Key Findings

### 1. Primary Storage Location
- **File Path**: `~/.E2E_CLI/config.json` (Linux/Mac)
- **Windows Path**: `~/.E2E_CLI\config.json`
- **File Type**: JSON configuration file

### 2. Core Module Files

#### File: `e2e_cli/core/alias_service.py`
**Purpose**: Handles alias credential retrieval and system file path determination

**Key Functions**:
- `system_file()` (lines 37-41): Determines the exact config file path based on OS
- `get_user_cred()` (lines 44-73): Retrieves credentials for a specific alias
- `get_api_credentials()` (lines 22-35): Returns API credentials for a given alias
- `get_default_value()` (lines 75-87): Retrieves default configuration values

#### File: `e2e_cli/config/config.py`
**Purpose**: Manages authentication configuration and alias operations

**Key Class**: `AuthConfig`
- `set_default()` (lines 180-196): Stores default alias configuration including:
  - api_key
  - api_auth_token
  - project_id
  - location
- `add_to_config()` (lines 123-138): Adds new aliases to config
- `delete_from_config()` (lines 141-159): Removes aliases from config
- `check_if_file_exist()` (lines 47-51): Verifies config file existence

#### File: `e2e_cli/config/config_routing.py`
**Purpose**: Routes and processes alias commands

**Key Class**: `ConfigRouting`
- `route()` method (lines 16-111): Handles alias command routing
- **alias set command handler** (lines 64-109):
  - Validates alias existence
  - Prompts for project_id and location
  - Sets default configuration using `AuthConfig.set_default()`

### 3. Command Processing Flow

1. User executes: `e2e_cli alias set`
2. `main.py` parses command and routes to `ConfigRouting.route()`
3. User prompted for:
   - Alias name to set as default
   - Project ID (must be positive integer)
   - Location (Delhi/Mumbai)
4. Configuration stored in `~/.E2E_CLI/config.json` under "default" key
5. Success message displayed with default settings

### 4. Configuration File Structure

The `config.json` file contains:
```json
{
  "alias_name": {
    "api_key": "your-api-key",
    "api_auth_token": "your-auth-token"
  },
  "default": {
    "api_key": "default-alias-name",
    "api_auth_token": "default-alias-name", 
    "project_id": "12345",
    "location": "Mumbai"
  }
}
```

## Installation Location
- **Package**: `e2e_cli` version 0.9.30
- **Installation Path**: `/workspaces/sn-i-yt-dzh1/W/tf/e1/.venv/lib/python3.14/site-packages/e2e_cli/`
- **Binary**: `/workspaces/sn-i-yt-dzh1/W/tf/e1/.venv/bin/e2e_cli`
