# DEEP-OSINT Architecture Guide

## System Overview

DEEP-OSINT is a multi-agent, recursive intelligence system built natively for OpenCode. It treats OSINT not as data collection, but as **adversarial inference** — every data point is a breadcrumb leading to hidden infrastructure, behavioral patterns, and cross-platform personas.

## Agent Hierarchy

```
@deep-osint (Primary Orchestrator)
│
├── @osint-discover    ─── Recursive Entity Expansion
├── @osint-crawl       ─── Deep Content Extraction
├── @osint-temporal    ─── Timeline & Pattern-of-Life
├── @osint-behavior    ─── Stylometric Fingerprinting
├── @osint-infra       ─── Infrastructure Mapping
├── @osint-darkweb     ─── Tor & Paste Monitoring
├── @osint-geo         ─── Geolocation Inference
├── @osint-synthetic   ─── Synthetic Identity Detection
└── @osint-report      ─── Intelligence Report Synthesis
```

## Execution Pipeline

```
 Seed ──► Discovery ──► Crawling ──► Analysis ──► Correlation ──► Validation ──► Report
   │         │            │           │            │              │             │
   ▼         ▼            ▼           ▼            ▼              ▼             ▼
 Input   osint-discover  osint-crawl  osint-temporal  Orchestrator  osint-synthetic  osint-report
           osint-infra   osint-darkweb osint-behavior  (graph)                      
                                            osint-geo
```

### Phase 1: Seed Injection
The user provides a seed entity (email, username, domain, phone, or image). The orchestrator validates the seed, creates a session workspace, and initializes the investigation state.

### Phase 2: Parallel Discovery
`@osint-discover` and `@osint-infra` launch simultaneously. Discover performs recursive entity expansion across 400+ platforms using Sherlock, Maigret, Holehe, theHarvester, Amass, and Sublist3r. Infra maps DNS, certificates, and technology stacks.

### Phase 3: Content Harvesting
`@osint-crawl` and `@osint-darkweb` process all discovered URLs. Crawl extracts content from live pages and archives (Wayback Machine, Common Crawl). Darkweb searches paste sites and Tor-indexed content.

### Phase 4: Feature Extraction
Three analysis agents run in parallel:
- `@osint-temporal` reconstructs timelines and detects behavioral patterns
- `@osint-behavior` performs stylometric analysis for identity linking
- `@osint-geo` performs multi-modal location inference

### Phase 5: Correlation
The orchestrator merges all outputs into a unified property graph with confidence-weighted edges. This phase is not delegated — the orchestrator handles it directly.

### Phase 6: Validation
`@osint-synthetic` analyzes the graph for fabricated personas and coordinated inauthentic behavior, downgrading confidence scores for flagged entities.

### Phase 7: Synthesis
`@osint-report` generates a professional intelligence brief with source attribution, confidence scoring, and bias flagging.

## Data Flow

```
User Input
    │
    ▼
discovery.json ─── raw crawled content
    │                    │
    ▼                    ▼
correlation_graph.json ◄── timeline.json, behavior/, infra/, darkweb/, geo/
    │
    ▼
synthetic/synthetic_analysis.json
    │
    ▼
report.md
```

## Configuration

All agent behavior is defined in `opencode.json` and `.opencode/prompts/*.txt`. The JSON file controls:

- **Agent modes**: `primary` (orchestrator) vs `subagent` (workers)
- **Tool permissions**: Which tools each agent can use
- **Bash permissions**: Granular allow/deny lists for shell commands
- **Prompt references**: Links to detailed instruction files

## Confidence Scoring

| Score | Meaning | Source |
|--------|---------|--------|
| 0.9-1.0 | Verified, multi-source | Direct tool confirmation |
| 0.7-0.89 | Confirmed, single authoritative | Web scraping, API result |
| 0.5-0.69 | Inferred | Pattern analysis, correlation |
| 0.3-0.49 | Speculative | Weak signals, single data point |
| 0.0-0.29 | Unverified | Conflicting or insufficient data |

## Ethical Safeguards

- All agents implement rate limiting (minimum 1.5s between requests)
- robots.txt is respected by default
- No authentication bypass or vulnerability exploitation
- Raw data auto-purges after 30 days
- Every query is logged with timestamp and agent ID for audit trail
- Aggressive tools (nmap, hydra, sqlmap, nikto) are explicitly denied in permissions
