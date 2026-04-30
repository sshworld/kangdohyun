---
name: panel-review
description: 합평 패널 워크플로. 도현의 글 작성 후 5명 검사관을 병렬 호출하고 결과를 도현에게 전달하는 규약. /diary, /essay, /novel, /lyric 작성 후 자동 진행.
---

# 합평 패널 워크플로

## 워크플로 개요

```
1. 도현 초고 작성 → 임시 저장
2. 5명 검사관 병렬 호출 (single message, 5 Agent calls)
3. 리포트 수집 → reviews/<type>/<filename>.review.md 저장
4. 도현이 합평 받고 자기 식대로 수정
5. voice-lint hook (자동, 저장 후)
6. content/<type>/ 최종 저장
```

## 단계 2: 병렬 호출 규약

**반드시 단일 메시지에서 5개 Agent 호출을 동시에 발사한다.** 순서가 없다. 병렬.

| 검사관 | 에이전트 | 역할 |
|---|---|---|
| voice-editor | `.claude/agents/voice-editor.md` | 톤·맞춤법·자음 단독 호칭 |
| novelist-eye | `.claude/agents/novelist-eye.md` | 서사 효율 |
| psyche-checker | `.claude/agents/psyche-checker.md` | 심리회로 일치 |
| reality-checker | `.claude/agents/reality-checker.md` | 약물·장소·시세·법 사실성 |
| character-keeper | `.claude/agents/character-keeper.md` | 인물 감지·호칭 규칙·world/ 갱신 |

옵션 (명시적 요청 시만):
- marketer-eye (독자 시선): `/critique --marketer` 또는 사용자 명시 요청

## 단계 3: 리포트 저장

`reviews/<type>/<filename>.review.md`에 5개 리포트를 합쳐 저장.

형식:
```markdown
# 합평 리포트: <filename>
작성일시: <timestamp>

---
## voice-editor
(결과 전문)

---
## novelist-eye
(결과 전문)

---
## psyche-checker
(결과 전문)

---
## reality-checker
(결과 전문)

---
## character-keeper
(결과 전문)
```

## 단계 4: 도현의 수정

리포트를 도현에게 전달하는 방식:
- "검사관들이 한 마디씩 했다. 받아라." 식으로 압축해서 전달. 정중하게 정리하지 않는다.
- 도현이 고를 것: voice-editor의 직접명명·자음 단독·매끄러움 → 반영. 나머지는 도현이 판단.
- 도현이 거부해도 된다: "이 부분은 내 식대로 쓴 거임."
- 사실 오류(reality-checker)는 조용히 반영한다.

## 핵심 원칙

**합평이 도현을 매끄럽게 만들면 실패한 합평이다.**

voice-editor가 다른 검사관의 제안에 거부권을 행사하면, 그 제안은 무시한다.
도현이 거부한 것은 강요하지 않는다.
