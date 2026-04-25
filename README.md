# outgoing-traffic-tracker

This script tracks outgoing network traffic on Unix-like systems.

## Prerequisites

-   **sh** (POSIX shell)
-   **awk** Text parsing language (usually preinstalled on Unix-like systems)

## Installation

### Install dependencies

**Debian / Ubuntu**

``` bash
sudo apt update
sudo apt install awk
```

**Arch Linux**

``` bash
sudo pacman -Syu awk
```

**Fedora**

``` bash
sudo dnf upgrade
sudo dnf install awk
```

### Download the script

``` bash
wget https://raw.githubusercontent.com/Vaenyx/outgoing-traffic-tracker/main/outgoing-traffic-tracker.sh
chmod +x outgoing-traffic-tracker.sh
```

## Usage

``` bash
./outgoing-traffic-tracker.sh [OPTIONS]
```

### Options

| Option    | Description |
| -------- | ------- |
|  `-d, --duration <seconds>`   |  Duration to run in seconds (default: `10`) |
|  `-i, --interface <interface>`   |  Interface to track (auto-detected if ommitted) |
|  `-q, --quiet`   |  Show only the numeric result |
|  `-n, --now`   |  Show current total outgoing bytes |
|  `-h, --help`   |  Show help and exit |

### Examples

``` bash
./outgoing-traffic-tracker.sh
```

``` bash
./outgoing-traffic-tracker.sh -d 30
```

``` bash
./outgoing-traffic-tracker.sh -i eth0
```

``` bash
./outgoing-traffic-tracker.sh --now
```

``` bash
BYTES=$(./outgoing-traffic-tracker.sh -d 5 -q)
echo "Sent: $BYTES bytes"
```
