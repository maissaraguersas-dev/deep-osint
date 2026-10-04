# DEEP-OSINT Agent Reference

Complete reference for all 10 agents in the DEEP-OSINT system.

---

## Primary Agent

### @deep-osint — Orchestrator

| Property | Value |
|---|---|
| **Mode** | primary |
| **Prompt** | `.opencode/prompts/deep-osint-prompt.txt` |
| **Tools** | read, write, edit, bash, webfetch, task |
| **Role** | Investigation coordination, correlation graph construction, pipeline management |

**Capabilities**:
- Seed validation and classification (email, username, domain, phone, image)
- Session workspace creation with unique IDs
- Parallel agent dispatch via the Task tool
- Unified correlation graph construction
- Investigation lifecycle management (7 phases)
- Final output presentation and follow-up recommendations

**Usage**:
```
@deep-osint investigate target@example.com
@deep-osint deep-investigate johndoe --depth 5
@deep-osint status
@deep-osint export <session-id> markdown
```

---

## Subagents

### @osint-discover — Recursive Discovery

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-discover-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Recursive entity expansion across 400+ platforms |

**Tools Used**:
| Tool | Purpose | Platforms |
|---|---|---|
| Sherlock | Username enumeration | 400+ social media, forums, services |
| Maigret | Advanced footprinting | 2000+ sites with metadata extraction |
| Holehe | Email-to-service mapping | 200+ services |
| theHarvester | Email harvesting | Google, Bing, LinkedIn, GitHub |
| Amass | DNS enumeration | Passive DNS, reverse DNS |
| Sublist3r | Subdomain discovery | Search engines, proprietary databases |

**Key Feature — Collision Detection**:
Same username on different platforms does NOT automatically mean same person. Requires 3+ corroborating signals (shared email, matching photo, similar bio, temporal correlation, mutual references).

---

### @osint-crawl — Deep Web Crawler

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-crawl-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | JavaScript-aware, archive-aware content extraction |

**Methods**:
| Method | Purpose | Depth |
|---|---|---|
| Playwright | Render SPAs and JS-heavy pages | Live web |
| Wayback Machine CDX | Historical snapshots | 10+ years |
| Archive.today | Current state capture | Current |
| Common Crawl WARC | Deleted page recovery | Full history |
| Tesseract OCR | Scanned PDF/image extraction | Document parsing |
| pdfplumber | Text PDF extraction | Document parsing |

---

### @osint-temporal — Temporal Analyst

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-temporal-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Timeline reconstruction & pattern-of-life detection |

**Analysis Types**:
- **Timestamp Normalization**: 15+ date formats to unified UTC
- **Gap Analysis**: Flags digital silence > 90 days (significant) and > 30 days (notable)
- **Frequency Analysis**: Human vs. bot posting patterns via statistical measures
- **Timezone Consistency**: Compares inferred vs. claimed timezones
- **Chronolocation**: Correlates content timestamps with geolocation claims

---

### @osint-behavior — Behavioral Fingerprinting

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-behavior-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Stylometric linking & bot detection |

**Feature Categories**:
| Category | Features |
|---|---|
| Lexical | Type-token ratio, hapax legomena, vocabulary richness, function word distribution |
| Syntactic | Sentence length, clause complexity, punctuation habits, contraction usage |
| Orthographic | Capitalization, emoji usage, misspellings, abbreviation habits |
| Structural | Paragraph structure, greeting/sign-off patterns, link sharing |

**Cross-Platform Comparison**: Cosine similarity on feature vectors, range 0.0-1.0, threshold 0.75 for "likely same author".

---

### @osint-infra — Infrastructure Mapper

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-infra-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Deep technical reconnaissance beyond DNS |

**Methods**:
| Method | Purpose |
|---|---|
| crt.sh | Certificate transparency archaeology |
| Passive DNS | CNAME chains, historical resolution |
| Amass + Sublist3r | Subdomain enumeration |
| WhatWeb / Wappalyzer | Technology fingerprinting |
| Exposure Detection | .git/, .env, API keys in JS |
| GitHub Dorking | Leaked credentials search |

---

### @osint-darkweb — Dark Web Monitor

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-darkweb-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Tor & paste site monitoring |

**Methods**:
| Method | Purpose |
|---|---|
| Ahmia.fi | Tor search engine (clearnet interface) |
| Paste Site Scraping | Pastebin, Paste.ee, Rentry.co, Ghostbin, JustPaste.it |
| Regex PII Detection | Emails, phones, AWS keys, API keys, passwords, CCs |
| Forum Linguistics | Thread extraction, user reputation, theme classification |

---

### @osint-geo — Geolocation Engine

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-geo-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | Multi-modal location inference |

**Methods**:
| Method | Precision | Confidence |
|---|---|---|
| EXIF GPS | Exact coordinates | 0.95 |
| Visual Geolocation | Region/City | 0.4-0.7 |
| IP Geolocation | Country/City | 0.7-0.9 |
| Linguistic Analysis | Region | 0.5-0.7 |

---

### @osint-synthetic — Synthetic Identity Detector

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-synthetic-prompt.txt` |
| **Tools** | read, write, bash, webfetch |
| **Role** | AI-generated persona detection |

**Detection Methods**:
| Method | Detects |
|---|---|
| GAN Artifact Detection | AI-generated profile photos |
| Profile Homogeneity | Template-based fake accounts |
| Temporal Impossibility | Bot activity patterns |
| Network Graph Analysis | Botnets, follow rings, clone accounts |
| Persona Coherence | Inconsistent biographical claims |

**Scoring**: Authenticity 0.0-1.0 per entity. Below 0.3 = high confidence fake. Above 0.7 = likely real.

---

### @osint-report — Report Synthesizer

| Property | Value |
|---|---|
| **Mode** | subagent |
| **Prompt** | `.opencode/prompts/osint-report-prompt.txt` |
| **Tools** | read, write, edit, bash, webfetch |
| **Role** | Intelligence report synthesis |

**Report Sections**:
1. Executive Summary
2. Entity Inventory
3. Cross-Platform Identity Assessment
4. Temporal Profile
5. Infrastructure Map
6. Geolocation Assessment
7. Dark Web & Exposure Summary
8. Authenticity Assessment
9. Confidence & Methodology
10. Recommendations

**Export Formats**: Markdown (default), JSON, CSV IOC list.
