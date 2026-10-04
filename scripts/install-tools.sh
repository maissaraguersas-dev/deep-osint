#!/usr/bin/env bash
# ============================================================
# DEEP-OSINT — OSINT Tool Installer
# Installs all required free, local OSINT tools.
# Tested on: Ubuntu 22.04+, Debian 12+, macOS 13+
# ============================================================

set -euo pipefail

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Helper Functions ---

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

section() {
    echo -e ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""
}

check_command() {
    if command -v "$1" &>/dev/null; then
        success "$1 is already installed ($(command -v "$1"))"
        return 0
    else
        return 1
    fi
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This operation requires root privileges."
        error "Please run: sudo $0"
        exit 1
    fi
}

# --- Detect OS ---

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
            PKG_MANAGER="apt-get"
        elif [ -f /etc/redhat-release ]; then
            OS="rhel"
            PKG_MANAGER="dnf"
        elif [ -f /etc/arch-release ]; then
            OS="arch"
            PKG_MANAGER="pacman"
        else
            OS="linux-unknown"
            PKG_MANAGER="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    else
        OS="unknown"
        PKG_MANAGER="unknown"
    fi
    info "Detected OS: $OS (package manager: $PKG_MANAGER)"
}

# --- Install System Dependencies ---

install_system_deps() {
    section "Installing System Dependencies"

    case "$OS" in
        debian)
            require_root
            info "Updating package lists..."
            $PKG_MANAGER update -qq
            info "Installing system packages..."
            $PKG_MANAGER install -y -qq \
                git curl wget jq \
                python3 python3-pip python3-venv \
                tesseract-ocr tesseract-ocr-eng \
                libffi-dev libssl-dev \
                libxml2-dev libxslt1-dev \
                zlib1g-dev \
                chromium-browser \
                tor \
                exiftool \
                dnsutils \
                whois \
                sqlite3 \
                2>&1 | tail -5
            ;;
        rhel)
            require_root
            info "Installing system packages via DNF..."
            $PKG_MANAGER install -y -q \
                git curl wget jq \
                python3 python3-pip \
                tesseract tesseract-langpack-eng \
                openssl-devel libffi-devel \
                libxml2-devel libxslt-devel \
                chromium \
                tor \
                perl-Image-ExifTool \
                bind-utils \
                whois \
                sqlite \
                2>&1 | tail -5
            ;;
        arch)
            require_root
            info "Installing system packages via Pacman..."
            $PKG_MANAGER -S --noconfirm \
                git curl wget jq \
                python python-pip \
                tesseract tesseract-data-eng \
                openssl libffi \
                libxml2 libxslt \
                chromium \
                tor \
                perl-image-exiftool \
                bind whois \
                sqlite \
                2>&1 | tail -5
            ;;
        macos)
            info "Installing system packages via Homebrew..."
            $PKG_MANAGER install \
                git curl wget jq \
                python@3.11 \
                tesseract tesseract-lang \
                exiftool \
                dnsmasq \
                whois \
                sqlite \
                tor \
                2>&1 | tail -5
            ;;
        *)
            warn "Unsupported OS: $OS. Install system dependencies manually."
            ;;
    esac

    success "System dependencies installed."
}

# --- Python Environment Setup ---

setup_python_env() {
    section "Setting Up Python Environment"

    PYTHON_BIN="python3"

    # Create virtual environment in project root
    VENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.venv"

    if [ -d "$VENV_DIR" ]; then
        info "Virtual environment already exists at $VENV_DIR"
    else
        info "Creating virtual environment..."
        $PYTHON_BIN -m venv "$VENV_DIR"
        success "Virtual environment created."
    fi

    # Activate
    source "$VENV_DIR/bin/activate"
    info "Virtual environment activated."

    # Upgrade pip
    pip install --quiet --upgrade pip setuptools wheel
    success "Pip upgraded."
}

# --- Install OSINT Tools ---

install_sherlock() {
    section "Installing Sherlock (Username Enumeration)"

    if check_command sherlock; then
        return
    fi

    info "Cloning Sherlock repository..."
    git clone --depth 1 https://github.com/sherlock-project/sherlock.git /opt/sherlock 2>/dev/null || {
        warn "Git clone failed. Trying pip install..."
        pip install sherlock-project 2>&1 | tail -3
    }

    if [ -d /opt/sherlock ]; then
        cd /opt/sherlock
        pip install -r requirements.txt 2>&1 | tail -3
        ln -sf /opt/sherlock/sherlock /usr/local/bin/sherlock 2>/dev/null || true
        cd -
    fi

    check_command sherlock || warn "Sherlock may need manual setup. Run: cd /opt/sherlock && python3 sherlock --help"
}

install_maigret() {
    section "Installing Maigret (Advanced Footprinting)"

    if check_command maigret; then
        return
    fi

    pip install maigret 2>&1 | tail -5
    check_command maigret || warn "Maigret installation may need troubleshooting."
}

install_holehe() {
    section "Installing Holehe (Email-to-Service Mapping)"

    if check_command holehe; then
        return
    fi

    pip install holehe 2>&1 | tail -5
    check_command holehe || warn "Holehe installation may need troubleshooting."
}

install_theharvester() {
    section "Installing theHarvester (Email Harvesting)"

    if check_command theHarvester; then
        return
    fi

    git clone --depth 1 https://github.com/laramies/theHarvester.git /opt/theHarvester 2>/dev/null
    if [ -d /opt/theHarvester ]; then
        cd /opt/theHarvester
        pip install -r requirements.txt 2>&1 | tail -3
        ln -sf /opt/theHarvester/theHarvester.py /usr/local/bin/theHarvester 2>/dev/null || true
        cd -
    fi

    check_command theHarvester || warn "theHarvester may need manual setup."
}

install_amass() {
    section "Installing Amass (DNS Enumeration)"

    if check_command amass; then
        return
    fi

    case "$OS" in
        debian|rhel|arch)
            # Try Go install first
            if command -v go &>/dev/null; then
                info "Installing Amass via Go..."
                go install -v github.com/owasp-amass/amass/v4/...@latest 2>&1 | tail -3
                export PATH="$PATH:$(go env GOPATH)/bin"
            else
                # Download pre-built binary
                info "Downloading Amass binary..."
                AMASS_VERSION="4.2.0"
                case "$(uname -m)" in
                    x86_64)
                        AMASS_ARCH="linux_amd64"
                        ;;
                    aarch64)
                        AMASS_ARCH="linux_arm64"
                        ;;
                esac
                if [ -n "${AMASS_ARCH:-}" ]; then
                    curl -sL "https://github.com/owasp-amass/amass/releases/download/v${AMASS_VERSION}/amass_${AMASS_ARCH}.zip" \
                        -o /tmp/amass.zip
                    unzip -qo /tmp/amass.zip -d /opt/ 2>/dev/null
                    ln -sf /opt/amass_${AMASS_ARCH}/amass /usr/local/bin/amass 2>/dev/null || true
                    rm -f /tmp/amass.zip
                fi
            fi
            ;;
        macos)
            $PKG_MANAGER install amass 2>&1 | tail -3
            ;;
    esac

    check_command amass || warn "Amass may need manual installation. See: https://github.com/owasp-amass/amass"
}

install_sublist3r() {
    section "Installing Sublist3r (Subdomain Discovery)"

    if check_command sublist3r; then
        return
    fi

    git clone --depth 1 https://github.com/aboul3la/Sublist3r.git /opt/Sublist3r 2>/dev/null
    if [ -d /opt/Sublist3r ]; then
        cd /opt/Sublist3r
        pip install -r requirements.txt 2>&1 | tail -3
        ln -sf /opt/Sublist3r/sublist3r.py /usr/local/bin/sublist3r 2>/dev/null || true
        cd -
    fi

    check_command sublist3r || warn "Sublist3r may need manual setup."
}

install_whatweb() {
    section "Installing WhatWeb (Technology Fingerprinting)"

    if check_command whatweb; then
        return
    fi

    case "$OS" in
        debian|rhel)
            gem install whatweb 2>&1 | tail -3 || {
                git clone --depth 1 https://github.com/urbanadventurer/WhatWeb.git /opt/WhatWeb 2>/dev/null
                ln -sf /opt/WhatWeb/whatweb /usr/local/bin/whatweb 2>/dev/null || true
            }
            ;;
        macos)
            $PKG_MANAGER install whatweb 2>&1 | tail -3
            ;;
        *)
            git clone --depth 1 https://github.com/urbanadventurer/WhatWeb.git /opt/WhatWeb 2>/dev/null
            ln -sf /opt/WhatWeb/whatweb /usr/local/bin/whatweb 2>/dev/null || true
            ;;
    esac

    check_command whatweb || warn "WhatWeb may need manual installation."
}

install_python_extras() {
    section "Installing Python Libraries"

    pip install --quiet \
        playwright \
        beautifulsoup4 \
        pdfplumber \
        Pillow \
        numpy \
        requests \
        pytz \
        python-dateutil \
        2>&1 | tail -3

    # Install Playwright browser (Chromium)
    if command -v playwright &>/dev/null; then
        info "Installing Playwright Chromium..."
        playwright install chromium 2>&1 | tail -3
    fi

    success "Python libraries installed."
}

install_ghunt() {
    section "Installing GHunt (Google Account Analysis)"

    warn "GHunt requires a Google account for authentication."
    warn "This is optional and can be installed manually if needed."

    git clone --depth 1 https://github.com/mxrch/GHunt.git /opt/GHunt 2>/dev/null || true
    if [ -d /opt/GHunt ]; then
        cd /opt/GHunt
        pip install -r requirements.txt 2>&1 | tail -3
        cd -
        success "GHunt cloned to /opt/GHunt. Run 'python3 /opt/GHunt/main.py --help' to use."
    fi
}

# --- Verification ---

verify_installation() {
    section "Verifying Installation"

    TOOLS=(
        "sherlock:Username Enumeration"
        "maigret:Advanced Footprinting"
        "holehe:Email-to-Service Mapping"
        "theHarvester:Email Harvesting"
        "amass:DNS Enumeration"
        "sublist3r:Subdomain Discovery"
        "whatweb:Technology Fingerprinting"
        "exiftool:Metadata Extraction"
        "tesseract:OCR Engine"
        "curl:HTTP Client"
        "jq:JSON Processor"
        "python3:Python Runtime"
    )

    INSTALLED=0
    MISSING=0

    echo -e "${BOLD}Tool Verification Summary:${NC}"
    echo -e "${BOLD}──────────────────────────────────────────────────────────${NC}"
    printf "${BOLD}%-25s %-35s %-10s${NC}\n" "TOOL" "PURPOSE" "STATUS"
    echo "───────────────────────────────────────────────────────────"

    for tool_info in "${TOOLS[@]}"; do
        TOOL_NAME="${tool_info%%:*}"
        TOOL_DESC="${tool_info#*:}"

        if command -v "$TOOL_NAME" &>/dev/null; then
            printf "${GREEN}%-25s${NC} %-35s ${GREEN}✓ Installed${NC}\n" "$TOOL_NAME" "$TOOL_DESC"
            ((INSTALLED++)) || true
        else
            printf "${RED}%-25s${NC} %-35s ${RED}✗ Missing${NC}\n" "$TOOL_NAME" "$TOOL_DESC"
            ((MISSING++)) || true
        fi
    done

    echo -e "${BOLD}──────────────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}Installed: $INSTALLED${NC}  ${RED}Missing: $MISSING${NC}"
    echo -e ""

    if [ "$MISSING" -eq 0 ]; then
        success "All tools installed successfully!"
    else
        warn "$MISSING tool(s) missing. Check the warnings above for manual installation steps."
    fi
}

# --- Data Cache Cleanup Setup ---

setup_cache_cleanup() {
    section "Setting Up Data Cache Auto-Cleanup"

    CRON_JOB="# Auto-purge DEEP-OSINT cache older than 30 days
0 3 * * * find $(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/data/cache -type f -mtime +30 -delete 2>/dev/null"

    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "DEEP-OSINT"; then
        info "Cache cleanup cron job already exists."
    else
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab - 2>/dev/null \
            && success "Cache cleanup cron job added (runs daily at 3 AM)." \
            || warn "Could not install cron job. Cache will need manual cleanup."
    fi
}

# --- Main ---

main() {
    echo -e ""
    echo -e "${BOLD}${CYAN}"
    echo "  ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗"
    echo " ██╔════╝ ██╔════╝██╔════╝██╔═══██╗████╗  ██║"
    echo " ██║  ███╗█████╗  ██║     ██║   ██║██╔██╗ ██║"
    echo " ██║   ██║██╔══╝  ██║     ██║   ██║██║╚██╗██║"
    echo " ╚██████╔╝███████╗╚██████╗╚██████╔╝██║ ╚████║"
    echo "  ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝"
    echo ""
    echo "  Deep Entity Extraction & Exploitation Platform"
    echo "  Open-Source Intelligence Tool Installer"
    echo -e "${NC}"
    echo -e "${BOLD}  Zero Cost. Zero APIs. Zero Rate Limits.${NC}"
    echo -e ""

    detect_os
    install_system_deps
    setup_python_env
    install_sherlock
    install_maigret
    install_holehe
    install_theharvester
    install_amass
    install_sublist3r
    install_whatweb
    install_python_extras
    install_ghunt
    setup_cache_cleanup
    verify_installation

    echo -e ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}  Installation Complete!${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""
    echo -e "  Start an investigation:"
    echo -e "    ${CYAN}@deep-osint investigate target@example.com${NC}"
    echo -e ""
    echo -e "  Deep investigation (5 layers):"
    echo -e "    ${CYAN}@deep-osint deep-investigate johndoe --depth 5${NC}"
    echo -e ""
    echo -e "  Infrastructure mapping:"
    echo -e "    ${CYAN}@osint-infra map example.com${NC}"
    echo -e ""
}

main "$@"