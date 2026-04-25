#!/usr/bin/env sh

get_outgoing_bytes() {
  awk -v iface="$INTERFACE" '
    $1 == iface":" {
      print $10
    }' /proc/net/dev
}

print_info() {
  if [[ -z "$QUIET" ]]; then
    printf "%b" "$1"
  fi
}

print_error() {
  printf "%b" "$1" >&2
}

print_result() {
  printf "%b" "$1"
}

show_help() {
  printf "%b" "Usage: $(basename "$0") [OPTIONS]

Options:
  -d, --duration <seconds>          Duration to run in seconds (default: 10)
  -i, --interface <interface>       Interface to track (auto-detected if ommitted)
  -q, --quiet                       Show only the numeric result
  -n, --now                         Show the total outgoing bytes at this moment
  -h, --help                        Show this help and exit
"
}

get_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--duration)
        if [[ -z "$2" || "$2" == -* ]]; then
          print_error "Option $1 requires a value\n"
          exit 1
        fi
        DURATION="$2"
        shift 2
        ;;
      -i|--interface)
        if [[ -z "$2" || "$2" == -* ]]; then
          print_error "Option $1 requires a value\n"
          exit 1
        fi
        INTERFACE="$2"
        shift 2
        ;;
      -q|--quiet)
        QUIET=true
        shift
        ;;
      -n|--now)
        NOW=true
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        print_error "Unknown option: $1\n"
        show_help >&2
        exit 1
        ;;
    esac
  done
}

DURATION=10
get_args "$@"

INTERFACE="${INTERFACE:-$(ip -json route get 1.1.1.1 | jq -r '.[0].dev')}"

if [[ -z "$INTERFACE" ]]; then
  print_error "Could not determine interface\n"
  exit 1
fi

if [[ -n "$NOW" ]]; then
  print_info "Reading total outgoing traffic on $INTERFACE.\n"
  BYTES=$(get_outgoing_bytes)
  print_info "Outgoing bytes: "
  print_result "$BYTES\n"
  exit 0
fi


print_info "Measuring outgoing traffic on $INTERFACE for $DURATION seconds...\n"

START_BYTES=$(get_outgoing_bytes)
sleep "$DURATION"
END_BYTES=$(get_outgoing_bytes)

BYTES=$((END_BYTES - START_BYTES))

print_info "Outgoing bytes: "
print_result "$BYTES\n"
