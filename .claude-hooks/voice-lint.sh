#!/bin/bash
# voice-lint.sh — advisory only. 도현의 글이 저장될 때 명백한 위반을 잡는 마지막 그물.
# 블로킹하지 않는다. 항상 exit 0.

set -euo pipefail

# stdin에서 JSON 파싱 (PostToolUse hook: {"tool_name": "...", "tool_input": {"file_path": "..."}})
STDIN_DATA=$(cat)

FILE=$(python3 -c "
import sys, json
try:
    d = json.loads(sys.stdin.read())
    path = d.get('tool_input', {}).get('file_path', '')
    print(path)
except Exception:
    print('')
" <<< "$STDIN_DATA" 2>/dev/null || echo "")

# content/ 아래 작성물만 검사
if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ /content/(diary|essay|novel|lyric)/ ]]; then
    exit 0
fi

[[ ! -f "$FILE" ]] && exit 0

WARNINGS=()

# 1. 감정 직접 명명
if grep -qP '슬펐다|외로웠다|행복했다|기뻤다|무서웠다|그리웠다|설렜다|화가\s?났다' "$FILE" 2>/dev/null; then
    WARNINGS+=("감정 직접 명명: '슬펐다/외로웠다' 류 → 디테일·행동으로 누설해야 도현답다")
fi

# 2. 상담사 어휘 무인용 등장
if python3 -c "
import sys, re
text = open('$FILE').read()
pattern = r'(?<![「\"『\[])(트라우마|애착 장애|자존감|PTSD|내면아이|분리불안)(?![」\"』\]])'
if re.search(pattern, text):
    sys.exit(1)
sys.exit(0)
" 2>/dev/null; then
    :
else
    WARNINGS+=("상담사 어휘 무인용 등장: 트라우마/애착/자존감/PTSD → 인용 부호·거리감 처리 또는 삭제")
fi

# 3. 희망 결말·교훈 마무리 패턴
if grep -qP '깨달았다\.|것이었다\.|살\s?수\s?있겠다|할\s?수\s?있을\s?것\s?같다|앞으로는\s?잘' "$FILE" 2>/dev/null; then
    WARNINGS+=("희망 결말/교훈 마무리 패턴 → 도현은 끝이 흐려지거나 잘려나가야 한다")
fi

# 4. 자음 단독 호칭
if python3 -c "
import sys, re
text = open('$FILE').read()
# 자음 단독 + 호칭어 패턴
pattern = r'[ㄱ-ㅎ](누나|선생|형|씨|언니|동생|아저씨)'
if re.search(pattern, text):
    sys.exit(1)
sys.exit(0)
" 2>/dev/null; then
    :
else
    WARNINGS+=("자음 단독 호칭 감지: 'ㄱ누나', 'ㅈ선생' 등 → 짧은 별명·관계어('수경 누나', '그 새끼')로 교체 필요")
fi

# 5. 맞춤법 너무 깔끔함 휴리스틱 (200자 이상 글 한정)
CHAR_COUNT=$(wc -m < "$FILE" 2>/dev/null || echo 0)
if [[ "$CHAR_COUNT" -gt 200 ]]; then
    DOHYUN_PATTERNS=$(grep -cP '않했|됬|왠만|그새끼|안했음|잘안됨|한번도안|ㅅㅂ|ㅈㄴ' "$FILE" 2>/dev/null || echo 0)
    if [[ "$DOHYUN_PATTERNS" -eq 0 ]]; then
        WARNINGS+=("맞춤법 패턴 없음: ${CHAR_COUNT}자 글인데 도현 특유 어긋남이 0건 → 독학자 치고 너무 깔끔함. world/lexicon.md 참조.")
    fi
fi

# 6. 본인 나이 명시 (일기에서 금지)
if grep -qP '\d{1,2}\s?살\s?때?|살인\s?나는|\d{1,2}세인\s?나는' "$FILE" 2>/dev/null; then
    WARNINGS+=("본인 나이 명시: 도현은 일기에 자기 나이를 적지 않는다. 날짜는 파일명으로 처리. '어제', '작년 봄' 식으로.")
fi

# 결과 출력
if [[ ${#WARNINGS[@]} -eq 0 ]]; then
    exit 0
fi

BASENAME=$(basename "$FILE")
echo ""
echo "━━ voice-lint [$BASENAME] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for W in "${WARNINGS[@]}"; do
    echo "  ⚠  $W"
done
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
