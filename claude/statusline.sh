#!/usr/bin/env bash
set -euo pipefail

# Read JSON from stdin
json=$(cat)

# Extract fields via jq
cwd=$(echo "$json" | jq -r '.cwd // empty')
model=$(echo "$json" | jq -r '.model.display_name // empty')
cost=$(echo "$json" | jq -r '.cost.total_cost_usd // 0')
input_tokens=$(echo "$json" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$json" | jq -r '.context_window.total_output_tokens // 0')
used_pct=$(echo "$json" | jq -r '.context_window.used_percentage // 0')

# ANSI colors
cyan="\033[36m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"
reset="\033[0m"

# Format directory (collapse $HOME to ~)
dir="${cwd/#$HOME/~}"

# Git info (branch + changes)
git_info=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)
  if [ -n "$branch" ]; then
    git_info="$branch"
    shortstat=$(git -C "$cwd" diff --shortstat HEAD 2>/dev/null || true)
    ins=$(echo "$shortstat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || true)
    del=$(echo "$shortstat" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || true)
    changes=""
    ins_part=""
    del_part=""
    [ -n "$ins" ] && ins_part="${green}+${ins}${reset}"
    [ -n "$del" ] && del_part="${red}-${del}${reset}"
    if [ -n "$ins_part" ] && [ -n "$del_part" ]; then
      changes="${ins_part}, ${del_part}"
    elif [ -n "$ins_part" ]; then
      changes="$ins_part"
    elif [ -n "$del_part" ]; then
      changes="$del_part"
    fi
    [ -n "$changes" ] && git_info="$branch (${changes})"
  fi
fi

# Format tokens (e.g. 19.5k)
total_tokens=$(( input_tokens + output_tokens ))
if [ "$total_tokens" -ge 1000000 ]; then
  tokens_fmt=$(awk "BEGIN { printf \"%.1fM\", $total_tokens / 1000000 }")
elif [ "$total_tokens" -ge 1000 ]; then
  tokens_fmt=$(awk "BEGIN { printf \"%.1fk\", $total_tokens / 1000 }")
else
  tokens_fmt="${total_tokens}"
fi

# Format cost
cost_fmt=$(awk "BEGIN { printf \"$%.2f\", $cost }")

# Format context percentage
ctx_pct=$(awk "BEGIN { printf \"%.0f\", $used_pct }")

# Context color: red if >80%, else yellow
if [ "$ctx_pct" -gt 80 ] 2>/dev/null; then
  ctx_color="$red"
else
  ctx_color="$yellow"
fi

# Build output
parts=()
[ -n "$dir" ] && parts+=("${cyan}${dir}${reset}")
[ -n "$git_info" ] && parts+=("${cyan}${git_info}${reset}")
[ -n "$model" ] && parts+=("${model}")
parts+=("${yellow}${cost_fmt}${reset}")
parts+=("${yellow}${tokens_fmt} tokens${reset}")
parts+=("${ctx_color}${ctx_pct}% ctx${reset}")

# Join with dim " | "
dim="\033[2m"
sep="${dim} | ${reset}"
output=""
for i in "${!parts[@]}"; do
  [ "$i" -gt 0 ] && output+="$sep"
  output+="${parts[$i]}"
done
printf "%b\n" "$output"
