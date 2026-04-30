#!/bin/bash
# UserPromptSubmit hook: 세션 컨텍스트를 Claude에 주입한다.
# - 오늘 세션이 없으면 새 세션 파일 생성
# - 날짜 변경 시 이전 current.md를 YYYY-MM-DD-NNN.md로 아카이브
# - current.md 내용을 stdout으로 출력 → Claude가 컨텍스트로 수신

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SESSIONS_DIR="$PROJECT_DIR/docs/sessions"
CURRENT="$SESSIONS_DIR/current.md"
TODAY=$(date '+%Y-%m-%d')
NOW=$(date '+%Y-%m-%d %H:%M')

mkdir -p "$SESSIONS_DIR"

# ── 현재 세션이 오늘 세션인지 판별 ──────────────────────────────────
session_is_today() {
    [[ -f "$CURRENT" ]] && grep -q "# 세션 ${TODAY}" "$CURRENT" 2>/dev/null
}

# ── 오늘 날짜 시퀀스 번호 계산 ──────────────────────────────────────
next_seq() {
    local count
    count=$(ls "$SESSIONS_DIR"/${TODAY}-*.md 2>/dev/null | wc -l | tr -d ' ')
    printf '%03d' $((count + 1))
}

# ── 새 세션 스켈레톤 생성 ─────────────────────────────────────────────
create_new_session() {
    local seq="$1"
    local filepath="$SESSIONS_DIR/${TODAY}-${seq}.md"

    cat > "$filepath" << TEMPLATE
# 세션 ${TODAY}-${seq}

**시작**: ${NOW} KST
**업데이트**: ${NOW} KST
**상태**: 진행 중

## 현재 상태

새 세션. 이전 세션 내용은 docs/sessions/ 아카이브 참조.

## 완료

(없음)

## 다음 / 진행 중

(이전 세션 이어서 또는 새 작업)

## 주요 파일 변경

(없음)

## 중요 결정

(없음)
TEMPLATE

    echo "$filepath"
}

# ── 메인 로직 ────────────────────────────────────────────────────────
if ! session_is_today; then
    # 날짜 변경이거나 세션 없음 → 기존 아카이브 후 새 세션 생성
    if [[ -f "$CURRENT" ]]; then
        OLD_DATE=$(grep -oP '\d{4}-\d{2}-\d{2}' "$CURRENT" | head -1 2>/dev/null || echo "unknown")
        OLD_SEQ=$(grep -oP '\d{4}-\d{2}-\d{2}-\K\d{3}' "$CURRENT" | head -1 2>/dev/null || echo "001")
        ARCHIVE="$SESSIONS_DIR/${OLD_DATE}-${OLD_SEQ}.md"
        # 아카이브 파일이 없으면 저장
        [[ ! -f "$ARCHIVE" ]] && cp "$CURRENT" "$ARCHIVE"
    fi

    SEQ=$(next_seq)
    NEW_FILE=$(create_new_session "$SEQ")
    cp "$NEW_FILE" "$CURRENT"
fi

# ── current.md 주입 ───────────────────────────────────────────────────
if [[ -f "$CURRENT" ]]; then
    echo ""
    echo "┌─────────────────────────────────────────────────────────────┐"
    echo "│  세션 컨텍스트  ·  docs/sessions/current.md                │"
    echo "└─────────────────────────────────────────────────────────────┘"
    cat "$CURRENT"
    echo ""
    echo "  → 작업 완료 시 docs/sessions/current.md 업데이트 (CLAUDE.md 참조)"
    echo "  → /session-end 로 세션 닫기 | /session-new 로 새 세션 강제 시작"
    echo "────────────────────────────────────────────────────────────────"
fi

exit 0
