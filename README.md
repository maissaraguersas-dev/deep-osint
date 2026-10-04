# DEEP-OSINT

> **Deep Entity Extraction & Exploitation Platform for Open-Source Intelligence**

[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Native-green.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Zero Cost](https://img.shields.io/badge/Cost-%240.00-success.svg)]()

A **multi-agent, recursive intelligence system** built natively for **OpenCode**. DEEP-OSINT performs deep adversarial inference through specialized subagents — going far beyond surface-level reconnaissance into cross-domain entity resolution, temporal behavioral fingerprinting, synthetic identity detection, and infrastructure archaeology.

**Zero external APIs. Zero paid services. Zero rate limits.** All intelligence is gathered through local tools, web scraping, and OpenCode's integrated LLM capabilities.

---

## Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Agent Reference](#agent-reference)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Data Sources](#data-sources)
- [Project Structure](#project-structure)
- [Ethics & Legal](#ethics--legal-compliance)
- [License](#license)

---

## Overview

DEEP-OSINT treats OSINT not as data collection, but as **adversarial inference**. Every data point is a breadcrumb leading to hidden infrastructure, behavioral patterns, and cross-platform personas.

### Design Philosophy

> **Surface data is noise. Correlation is signal. Depth is the objective.**

### Key Capabilities

| Capability | Surface OSINT | DEEP-OSINT |
|---|---|---|
| Username lookup | Single platform | Cross-platform recursive chaining with collision detection |
| Email validation | Format check | Registered service enumeration + breach correlation + timeline |
| Domain recon | A/AAAA records | Certificate transparency archaeology + passive DNS + tech stack + exposed git |
| Social media | Profile viewing | Stylometric linking + bot detection + temporal pattern-of-life |
| Image analysis | Reverse search | EXIF + shadow geolocation + GAN artifact detection + chronolocation |
| Dark web | Manual Tor browsing | Automated paste monitoring + forum linguistics + keyword persistence |
| Report generation | Copy-paste URLs | Source-attributed narrative with confidence scoring and bias flagging |

---

## System Architecture

```
User
  |
  v
+------------------------------------------+
|  @deep-osint (Primary Orchestrator)      |
|  Mode: primary                           |
|  Tools: read, write, edit, bash, webfetch|
+------------------------------------------+
  |
  |---> @osint-discover (Subagent)
  |     Mode: subagent
  |     Function: Recursive entity expansion across 400+ platforms
  |
  |---> @osint-crawl (Subagent)
  |     Mode: subagent
  |     Function: JavaScript-aware, archive-aware content extraction
  |
  |---> @osint-temporal (Subagent)
  |     Mode: subagent
  |     Function: Timeline reconstruction & pattern-of-life detection
  |
  |---> @osint-behavior (Subagent)
  |     Mode: subagent
  |     Function: Stylometric linking & bot detection
  |
  |---> @osint-infra (Subagent)
  |     Mode: subagent
  |     Function: Deep technical reconnaissance beyond DNS
  |
  |---> @osint-darkweb (Subagent)
  |     Mode: subagent
  |     Function: Tor & paste site monitoring
  |
  |---> @osint-geo (Subagent)
  |     Mode: subagent
  |     Function: Multi-modal location inference
  |
  |---> @osint-synthetic (Subagent)
  |     Mode: subagent
  |     Function: AI-generated persona detection
  |
  +---> @osint-report (Subagent)
        Mode: subagent
        Function: LLM-powered intelligence report synthesis
```

### Execution Flow

1. **Seed Injection**: User provides a seed entity (email, username, domain, image, phone)
2. **Parallel Discovery**: `@osint-discover` + `@osint-infra` launch simultaneously via `Task` tool
3. **Content Harvesting**: `@osint-crawl` follows discovered URLs; `@osint-darkweb` searches paste sites
4. **Feature Extraction**: `@osint-temporal`, `@osint-behavior`, `@osint-geo` process raw content in parallel
5. **Correlation**: All outputs merge into a unified property graph with confidence weights
6. **Validation**: `@osint-synthetic` flags fabricated personas; correlation engine resolves conflicts
7. **Synthesis**: `@osint-report` generates an attributed intelligence brief

---

## Agent Reference

### Primary Agent: `@deep-osint`

**File**: `opencode.json` -> `agent.deep-osint`
**Prompt**: `.opencode/prompts/deep-osint-prompt.txt`

The main orchestrator. Receives the investigation seed, dispatches subagents in parallel, manages the correlation graph, and produces the final intelligence product.

**Invocation**:
```
@deep-osint investigate target@example.com
```

### Subagents

All subagents are defined in `opencode.json` under the `agent` key and reference prompt files in `.opencode/prompts/`.

#### `@osint-discover` — Recursive Discovery

**Config**: `opencode.json` -> `agent.osint-discover`  
**Prompt**: `.opencode/prompts/osint-discover-prompt.txt`

Performs infinite-depth entity expansion from a single seed using local CLI tools:
- **Sherlock**: Username enumeration across 400+ platforms
- **Maigret**: Advanced footprinting with metadata extraction
- **Holehe**: Email-to-service registration mapping
- **theHarvester**: Email harvesting and subdomain discovery
- **Amass**: DNS enumeration and network mapping
- **Sublist3r**: Subdomain discovery

**Depth**: Configurable recursion (default: 5 layers)  
**Collision Detection**: Prevents false positive merging (same username != same person)

#### `@osint-crawl` — Deep Web Crawler

**Config**: `opencode.json` -> `agent.osint-crawl`  
**Prompt**: `.opencode/prompts/osint-crawl-prompt.txt`

Extracts intelligence from dynamic, archived, and deleted content:
- **Playwright**: JavaScript rendering for SPAs
- **Wayback Machine**: Historical snapshot recovery (10+ years)
- **Archive.today**: Current state capture
- **Common Crawl**: Deleted page recovery via WARC files
- **Document Parsing**: PDF/DOC extraction via Tesseract OCR + pdfplumber

#### `@osint-temporal` — Temporal Analyst

**Config**: `opencode.json` -> `agent.osint-temporal`  
**Prompt**: `.opencode/prompts/osint-temporal-prompt.txt`

Reconstructs digital timelines and detects behavioral patterns:
- **Timestamp Normalization**: 15+ date formats -> unified UTC
- **Gap Analysis**: Detects suspicious digital silence (>90 days)
- **Frequency Analysis**: Human vs. bot posting patterns
- **Timezone Consistency**: Cross-reference claimed vs. inferred timezones
- **Chronolocation**: Correlates content timestamps with geolocation claims

#### `@osint-behavior` — Behavioral Fingerprinting

**Config**: `opencode.json` -> `agent.osint-behavior`  
**Prompt**: `.opencode/prompts/osint-behavior-prompt.txt`

Links pseudonymous accounts and detects automation via stylometry:
- **Lexical Fingerprinting**: Vocabulary richness, function word distribution
- **Syntactic Fingerprinting**: Sentence length variation, punctuation habits
- **Orthographic Fingerprinting**: Capitalization, emoji usage, misspellings
- **Cross-Platform Comparison**: Cosine similarity across writing samples
- **Bot Detection**: Entropy analysis, repetition patterns

#### `@osint-infra` — Infrastructure Mapper

**Config**: `opencode.json` -> `agent.osint-infra`  
**Prompt**: `.opencode/prompts/osint-infra-prompt.txt`

Deep technical reconnaissance beyond surface DNS records:
- **Certificate Transparency**: crt.sh historical certificate queries
- **Passive DNS**: CNAME chains, historical resolution
- **Subdomain Enumeration**: Amass + Sublist3r + permutation generation
- **Technology Fingerprinting**: WhatWeb + Wappalyzer CLI
- **Exposure Detection**: `.git/` directories, `.env` files, API keys in JS
- **GitHub Recon**: GitDorker patterns for leaked credentials

#### `@osint-darkweb` — Dark Web Monitor

**Config**: `opencode.json` -> `agent.osint-darkweb`  
**Prompt**: `.opencode/prompts/osint-darkweb-prompt.txt`

Monitors anonymized networks and paste sites:
- **Tor Crawling**: Ahmia.fi-indexed .onion sites via local SOCKS5
- **Paste Monitoring**: Automated scraping of public paste sites
- **Leak Detection**: Regex patterns for PII, credentials, API keys
- **Forum Linguistics**: Thread extraction, user reputation, slang analysis

#### `@osint-geo` — Geolocation Engine

**Config**: `opencode.json` -> `agent.osint-geo`  
**Prompt**: `.opencode/prompts/osint-geo-prompt.txt`

Determines physical location from sparse digital traces:
- **EXIF Geolocation**: GPS coordinates from images
- **Visual Geolocation**: SunCalc shadow analysis, signage language, architecture
- **Network Geolocation**: IP geolocation + traceroute analysis
- **Linguistic Geolocation**: Region-specific spelling, slang, holiday references

#### `@osint-synthetic` — Synthetic Identity Detector

**Config**: `opencode.json` -> `agent.osint-synthetic`  
**Prompt**: `.opencode/prompts/osint-synthetic-prompt.txt`

Detects fabricated personas and coordinated inauthentic behavior:
- **GAN Artifact Detection**: Frequency-domain checkerboard pattern analysis
- **Profile Homogeneity**: Stock photo detection, template structure matching
- **Temporal Impossibility**: Activity patterns violating human sleep cycles
- **Network Graph Analysis**: Botnet structure detection via follower anomalies
- **Persona Coherence**: LLM-evaluated biography consistency

#### `@osint-report` — Report Synthesizer

**Config**: `opencode.json` -> `agent.osint-report`  
**Prompt**: `.opencode/prompts/osint-report-prompt.txt`

Generates professional intelligence reports:
- **Narrative Generation**: OpenCode LLM-powered prose with source attribution
- **Confidence Scoring**: Every claim weighted 0.0-1.0
- **Bias Flagging**: Marks single-source claims and low-confidence inferences
- **Export Formats**: Markdown (default), JSON, CSV IOC lists

---

## Installation

### Prerequisites

- **OpenCode CLI** installed and configured
- **System packages**: `tesseract-ocr`, `tor` (optional), `git`
- **Python 3.11+** with pip

### Step 1: Install OpenCode

```bash
# macOS/Linux
brew install opencode

# Or download from https://opencode.ai
```

### Step 2: Clone DEEP-OSINT

```bash
git clone https://github.com/yourorg/deep-osint.git
cd deep-osint
```

### Step 3: Install OSINT Tools (All Free, Local)

```bash
bash scripts/install-tools.sh
```

This installs:
- `sherlock` — username enumeration
- `maigret` — advanced footprinting
- `amass` — DNS enumeration
- `sublist3r` — subdomain discovery
- `theHarvester` — email harvesting
- `holehe` — email-to-service mapping
- `whatweb` — technology fingerprinting
- `exiftool` — metadata extraction
- `ghunt` — Google account analysis

### Step 4: Configure OpenCode

The `opencode.json` file in the project root automatically registers all agents when you run OpenCode from this directory:

```bash
# Verify agents are loaded
opencode agent list

# Should show:
# - deep-osint (primary)
# - osint-discover (subagent)
# - osint-crawl (subagent)
# - osint-temporal (subagent)
# - osint-behavior (subagent)
# - osint-infra (subagent)
# - osint-darkweb (subagent)
# - osint-geo (subagent)
# - osint-synthetic (subagent)
# - osint-report (subagent)
```

---

## Configuration

### `opencode.json`

The central configuration file defines all agents, their modes, tools, permissions, and prompt references:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode/default",
  "default_agent": "deep-osint",
  "agent": {
    "deep-osint": { ... },
    "osint-discover": { ... },
    "osint-crawl": { ... },
    ...
  },
  "permissions": [ ... ]
}
```

### Agent Modes

| Agent | Mode | Purpose |
|-------|------|---------|
| `deep-osint` | `primary` | Orchestrator — dispatches subagents, manages state |
| `osint-*` | `subagent` | Specialized workers — called by primary via `Task` |

### Tool Permissions

Each agent has granular tool permissions defined in `opencode.json`:

```json
"tools": {
  "read": true,
  "write": true,
  "bash": true,
  "webfetch": true
}
```

### Bash Command Permissions

Bash commands are explicitly allowed/denied per agent:

```json
"permission": {
  "bash": {
    "sherlock *": "allow",
    "amass *": "allow",
    "nmap *": "deny",
    "*": "ask"
  }
}
```

### Prompt Files

Agent behavior is defined in `.opencode/prompts/*.txt` files referenced by the `prompt` key:

```json
"prompt": "{file:.opencode/prompts/deep-osint-prompt.txt}"
```

---

## Usage

### Standard Investigation

```
@deep-osint investigate target@example.com
```

The primary agent will:
1. Validate the seed as an email
2. Create workspace: `./deep-osint-output/deep_20240731_143052_a1b2c3d4/`
3. Dispatch `@osint-discover` and `@osint-infra` in parallel
4. Continue through all phases
5. Present final summary

### Deep Investigation (Maximum Depth)

```
@deep-osint deep-investigate johndoe --depth 5
```

Activates all agents with 5-layer recursion for high-value targets.

### Infrastructure-Only Mapping

```
@osint-infra map example.com
```

Direct invocation of the infrastructure mapper without social discovery.

### Dark Web Monitoring

```
@osint-darkweb monitor "target_username"
```

Direct invocation of the dark web monitor for continuous surveillance.

### Report Generation from Existing Data

```
@osint-report synthesize ./deep-osint-output/deep_20240731_143052_a1b2c3d4/
```

Regenerate report from completed investigation data.

---

## Data Sources (100% Free)

| Source | Tool | Access Method |
|--------|------|---------------|
| Username Search | Sherlock | Local CLI |
| Advanced Footprinting | Maigret | Local CLI |
| Email Verification | Holehe | Local CLI |
| Email Harvesting | theHarvester | Local CLI |
| Subdomain Enum | Amass | Local CLI |
| Subdomain Discovery | Sublist3r | Local CLI |
| DNS Recon | DNSdumpster | HTML Scraping |
| Certificate Transparency | crt.sh | JSON API (no key) |
| Web Crawling | Playwright | Local Browser |
| Archive Access | Wayback CDX | JSON API (no key) |
| Technology Detection | WhatWeb | Local CLI |
| Git Exposure | GitDorker | Local Execution |
| Google Account | GHunt | Local CLI |
| Tor Search | Ahmia.fi | HTML Scraping |
| IP Geolocation | ip-api.com | JSON API (free tier, throttled) |
| Sun Position | SunCalc | Local Calculation |
| Metadata Extraction | ExifTool | Local CLI |
| OCR | Tesseract | Local CLI |
| Search Aggregation | SearXNG | Self-hosted or Public Instances |
| Reverse Image | Yandex Images | HTML Scraping |

---

## Project Structure

```
deep-osint/
|
|-- opencode.json                          # Central agent manifest
|   # Defines all agents, modes, tools, permissions, prompts
|
|-- .opencode/
|   |-- agents/                            # (optional) Additional agent markdown files
|   |-- commands/                          # (optional) Custom commands
|   |-- prompts/
|   |   |-- deep-osint-prompt.txt          # Primary orchestrator instructions
|   |   |-- osint-discover-prompt.txt      # Recursive discovery protocol
|   |   |-- osint-crawl-prompt.txt         # Deep crawling protocol
|   |   |-- osint-temporal-prompt.txt      # Timeline analysis protocol
|   |   |-- osint-behavior-prompt.txt      # Stylometry protocol
|   |   |-- osint-infra-prompt.txt         # Infrastructure mapping protocol
|   |   |-- osint-darkweb-prompt.txt       # Dark web monitoring protocol
|   |   |-- osint-geo-prompt.txt           # Geolocation inference protocol
|   |   |-- osint-synthetic-prompt.txt     # AI persona detection protocol
|   |   |-- osint-report-prompt.txt        # Report synthesis protocol
|
|-- scripts/
|   |-- install-tools.sh                   # One-command tool installer
|
|-- data/
|   |-- raw/                               # Unprocessed harvests
|   |-- graph/                             # Serialized entity graphs
|   |-- cache/                             # Temporary computation cache
|
|-- output/
|   |-- reports/                           # Generated intelligence reports
|   |-- exports/                           # JSON/CSV/IOC exports
|
|-- docs/                                  # Additional documentation
|-- README.md                              # This file
|-- LICENSE                                # MIT License
|-- .gitignore                             # Git exclusions
```

### Output Structure (Per Investigation)

```
deep-osint-output/<session-id>/
|-- discovery.json          # All discovered entities by layer
|-- raw/                    # Crawled content, screenshots, documents
|-- correlation_graph.json  # Unified entity graph with confidence scores
|-- timeline.json           # Temporal analysis results
|-- behavior/               # Stylometric profiles and matches
|-- infra/                  # Infrastructure mapping results
|-- darkweb/                # Dark web mentions and leaks
|-- geo/                    # Location estimates
|-- synthetic/              # Authenticity scores and flags
|-- report.md               # Final intelligence report
```

---

## Ethics & Legal Compliance

### Scope & Authorization
- **Target only entities you have explicit legal authorization to investigate**
- Designed for: security research, corporate due diligence, journalism, missing persons, threat intelligence
- **Prohibited**: Stalking, harassment, unauthorized surveillance, doxxing

### Technical Safeguards
- **Rate limiting**: All scraping modules implement exponential backoff (default: 1.5s delay)
- **Robots.txt compliance**: Respected by default
- **No authentication bypass**: Does not brute-force credentials or exploit vulnerabilities
- **Data retention**: Raw data auto-purges after 30 days
- **Audit trail**: Every query logged with timestamp and agent ID

---

## License

MIT License — see [LICENSE](LICENSE) for full text.

**Disclaimer**: This tool is provided for educational and authorized security research purposes only. The authors assume no liability for misuse or illegal activity.

---

<div align="center">

**DEEP-OSINT** — *Surface is noise. Correlation is signal. Depth is the objective.*

Built for OpenCode · Zero Cost · Maximum Depth

</div>
