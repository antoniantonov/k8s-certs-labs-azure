# What is Trivy 
Trivy is a simple and comprehensive vulnerability scanner for containers. Trivy detects vulnerabilities of OS packages (Alpine, RHEL, CentOS, etc.) and application dependencies (Bundler, Composer, npm, yarn, etc.). Trivy is easy to use. Just install the binary and you're ready to scan. All you need to do for scanning is to specify an image name of the container.

Static container scanner

# Installation

# Configuration

# Scanning container images
```bash
# Scan an image for given vulnerabilities
trivy image nginx:1.19.1-alpine-perl | grep CVE-2021-28831
trivy image nginx:1.19.1-alpine-perl | grep CVE-2016-9841

# Search for either hit
trivy image nginx:1.19.1-alpine-perl | grep -E "(CVE-2016-9841|CVE-2021-28831)"
```