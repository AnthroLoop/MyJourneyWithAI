#!/bin/bash
# Read/Grep ツールが .env ファイルにアクセスしようとした場合にブロック
INPUT=$(cat /dev/stdin)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Read の場合: file_path をチェック
if [ "$TOOL_NAME" = "Read" ]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
  if echo "$FILE_PATH" | grep -qE '(^|/)\.env($|\.)'; then
    echo "BLOCKED: .env file access is not allowed" >&2
    exit 2
  fi
fi

# Grep の場合: path をチェック
if [ "$TOOL_NAME" = "Grep" ]; then
  SEARCH_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // ""')
  if echo "$SEARCH_PATH" | grep -qE '(^|/)\.env($|\.)'; then
    echo "BLOCKED: .env file access is not allowed" >&2
    exit 2
  fi
fi

exit 0
