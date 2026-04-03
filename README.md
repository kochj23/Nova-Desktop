# Nova Desktop v1.0.0

![Build](https://github.com/kochj23/Nova-Desktop/actions/workflows/build.yml/badge.svg)
![Platform](https://img.shields.io/badge/platform-macOS%2014.0%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Version](https://img.shields.io/badge/version-1.0.0-purple)
![Port](https://img.shields.io/badge/API-port%2037450-orange)

**macOS dashboard for monitoring all Nova AI infrastructure — OpenClaw, Ollama, MLX, running apps, cron jobs, and GitHub repos.**

Built in the TopGUI design language: dark navy glassmorphic background, floating blob animations, GlassCard components, and heat-map status indicators.

---

## What It Monitors

### OpenClaw Core
- **Gateway** (ws://18789) — online status, version, active sessions, current model, Slack connectivity
- **Memory Server** (18790) — online status, memories count
- **25 cron jobs** — status (ok/error/running/skipped), last run, next run, consecutive error count

### AI Model Services
| Service | Port | What's shown |
|---------|------|-------------|
| **Ollama** | 11434 | Status, loaded model names, model sizes |
| **MLXCode** | 37422 | Model loaded, tokens/sec, generation status |
| **OpenRouter** | cloud | API reachability, latency |
| **Open WebUI** | 3000/8080 | Running status |
| **TinyChat** | 5000 | Running status |
| **SwarmUI** | 7801 | Running status |
| **ComfyUI** | 8188 | Running status, VRAM |

### Jordan's Apps
NovaControl (37400), NMAPScanner (37423), OneOnOne (37421), RsyncGUI (37424), JiraSummary (37425), Mail Summary

### GitHub Repos
nova, NovaControl, MLXCode, NMAPScanner, RsyncGUI, JiraSummary — last commit, open issues, PRs, stars

---

## Control Capabilities

Click to **start, stop, or restart** any service:

- **OpenClaw gateway** — `launchctl kickstart -k gui/$(id -u)/com.openclaw.gateway`
- **Memory server** — `python3 ~/.openclaw/memory_server.py`
- **Ollama** — `ollama serve` / `pkill ollama`
- **All apps** — `NSWorkspace.shared.openApplication` / `NSRunningApplication.terminate()`
- **Run any cron job** — `openclaw cron run <id>`

---

## API Server (port 37450)

```bash
BASE="http://127.0.0.1:37450"

curl $BASE/api/status    # overall health summary
curl $BASE/api/health    # per-service healthcheck with pass/fail
curl $BASE/api/services  # all service states + latency
curl $BASE/api/crons     # cron job list
curl $BASE/api/github    # GitHub repo summaries

# Trigger a manual refresh from scripts/Nova/other apps
curl -X POST $BASE/api/refresh
```

---

## Tabs

| Tab | Content |
|-----|---------|
| **Dashboard** | Overview: gateway/memory status, AI services grid, apps pills, GitHub, recent crons |
| **AI Services** | Full AI service cards with controls and Ollama model list |
| **Apps** | Jordan's running apps with start/stop controls |
| **Cron Jobs** | Full cron table with Run Now buttons |
| **GitHub** | Repo table with last commit, issues, PRs |

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+R` | Refresh all services |
| `Cmd+Shift+G` | Refresh GitHub |
| `Cmd+Shift+O` | Restart OpenClaw gateway |
| `Cmd+Shift+M` | Restart memory server |
| `Cmd+Shift+L` | Start Ollama |

---

## Design

Matches [TopGUI](https://github.com/kochj23/TopGUI)'s design language:
- Dark navy gradient background (`#0F1438` range) with 5 floating animated blobs
- Glassmorphic cards — `ultraThinMaterial` + white border + double shadow
- Status dots with pulsing glow animation for online services
- Heat-map colors: green → yellow → orange → red
- SF Symbols throughout, `.rounded` design system font

---

## Installation

### Requirements
- macOS 14.0+
- Xcode 15+
- [xcodegen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

### Build

```bash
git clone https://github.com/kochj23/Nova-Desktop
cd Nova-Desktop
xcodegen generate
xcodebuild -scheme Nova-Desktop -configuration Release build -allowProvisioningUpdates
```

### GitHub Token (optional, for GitHub section)

Store your token in Keychain for repo data:
```bash
security add-generic-password -a kochj23 -s github-token -w YOUR_TOKEN
```
Without a token, GitHub API allows 60 unauthenticated requests/hour — sufficient for the dashboard.

---

## Architecture

```
Nova-Desktop/
├── Design/
│   └── ModernDesign.swift        # Colors, GlassCard, StatusDot, CircularGauge, ControlButton
├── Models/
│   └── ServiceModels.swift       # MonitoredService, OpenClawStatus, GitHubRepoStatus, etc.
├── Services/
│   ├── NovaMonitor.swift         # @MainActor data aggregator, 10s refresh, GitHub 60s
│   └── ServiceController.swift   # Start/stop/restart all services
├── Views/
│   ├── ContentView.swift         # 5-tab main window (1400×900 min)
│   ├── Components/
│   │   └── ServiceCard.swift     # Service card + pill + control buttons
│   └── Sections/
│       ├── OpenClawSection.swift # Gateway + memory + cron table
│       ├── AIServicesSection.swift
│       ├── AppsSection.swift
│       ├── GitHubSection.swift
│       └── SystemSection.swift
└── API/
    └── NovaAPIServer.swift       # NWListener on port 37450
```

---

## License

MIT License — see [LICENSE](LICENSE)

Written by Jordan Koch
