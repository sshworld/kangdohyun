강도현이 장편 다음 화를 쓴다. 기본은 장편 모드. `--short` 또는 `_index.md` 없을 때 단편 fallback.

## 모드 분기

1. `content/novel/`에서 `_index.md`를 가진 슬러그 디렉토리를 찾는다.
   - 있으면 → **장편 다음 화 모드** (아래 절차).
   - 없으면 → **단편 모드** fallback: `dohyun-voice` + `dohyun-novel` 스킬 로드 후 1500~2500자 단편 작성. `content/novel/<title-or-date>.md` 저장.
2. `--short` 인자가 있으면 강제 단편 모드.

---

## 장편 다음 화 작성 — 전처리 (순서 엄수)

1. `CLAUDE.md` + `reference/biography.md` 읽기.
2. `dohyun-voice` + `dohyun-novel-long` 스킬 로드.
3. **시리즈 메타 3종 읽기** (이 순서):
   a. `content/novel/<slug>/_index.md` — 다음 화 번호·진입점 단서·아크 위치·voice 패치.
   b. `content/novel/<slug>/_outline.md` — 5부 외곽·현재 화 위치.
   c. `content/novel/<slug>/_canon.md` — 미해결 단서·인물 좌표·시기별 voice 분기.
4. **직전 2~3화 본문 읽기** — 마지막 완성 번호 기준.
5. `world/characters.md` + `world/relations.md` + `world/lexicon.md` 확인.
6. (선택) 동시기 일기 1~2편 `content/diary/` — 톤 참조용. 본문 그대로 가져오지 않는다.

---

## 초고 작성

**dohyun** 에이전트가 `dohyun-novel-long` 스킬 규약대로 다음 화 초고 작성.

- `_index.md`의 "다음 화 진입점 단서"가 출발점. `$ARGUMENTS` 단서가 있으면 그게 우선. 충돌 시 도현이 비틀어 흡수.
- 길이: 2500~4500자. 한 호흡 안 한 장면.
- 끝은 결말 아님. 다음 화 진입점이 자연스럽게 떠오를 만큼만 흐려지거나 잘린다.

---

## 합평 패널 (장편 모드 — 10인 + 옵션 병렬)

단일 메시지에서 동시 호출:
- voice-editor (거부권 보유)
- novelist-eye
- psyche-checker
- reality-checker (`_canon.md` 시기별 voice 분기 + `world/lexicon.md` 약물 고증)
- character-keeper (`_canon.md` "인물 좌표"도 함께 읽도록 명시)
- **continuity-checker** (`_canon.md` + `_outline.md` + 직전 화 frontmatter 읽기)
- **korean-grammar** (한국어 맞춤법·띄어쓰기·문장부호. 도현 voice 의도적 받침 어긋남 풀은 보존)
- **erotic-detail-fanatic** (페르소나: 40대 남 한국 19금 야설 마니아. 신체·압력·온도·체액·소리·박자 디테일 광적 거부)
- **novel-craft-fanatic** (페르소나: 30대 여 한국 본격 문학 마니아. 시점·산문 호흡·인물 입체감·문장 미감 광)
- **continuity-foreshadow-fanatic** (페르소나: 20대 남 웹소설 마니아. 떡밥·복선·정합성·캐논·인물 동선 광)
- marketer-eye (옵션 — 사용자 명시 시 또는 1화처럼 흡인력 점검 필요)

---

## 합평·수정·재합평 루틴 (반복 의무)

장편 모드는 합평 한 번으로 끝내지 않는다. 다음 루틴을 반복한다:

```
[1] 본문 작성
 ↓
[2] 합평 N인 병렬 호출
 ↓
[3] 결과 정리 — 페르소나 3명 + voice-editor 핵심 수정 사항 추출
 ↓
[4] 본문 + 시스템(_canon·_outline·_index·world/) 수정 반영
 ↓
[5] 페르소나 3명 + voice-editor 재합평 호출
 ↓
[6] 만족 여부 판정
    - voice-editor: 거부권 없음
    - erotic-detail-fanatic: ★★★★ 이상
    - novel-craft-fanatic: ★★★★ 이상
    - continuity-foreshadow-fanatic: ★★★★ 이상
    → 미달 시 [4]로 돌아가 수정 후 [5] 다시
    → 모두 충족 시 [7]로
 ↓
[7] 최종 합평 리포트 `reviews/novel/<slug>/NNN-*.review.md` 저장 (라운드별 누적)
 ↓
[8] `_canon.md` / `_index.md` / `world/characters.md` 최종 갱신
 ↓
[9] `docs/sessions/current.md` 갱신
 ↓
[10] **`/session-end` 호출 (한 화 완료 시 자동)**
```

**중요**:
- 페르소나 3명이 모두 ★★★★ 이상 받기 전까지 절대 세션 종료 X.
- 라운드 사이마다 본문 변경 사항을 합평 리포트에 누적 기록.
- 합평·수정 라운드는 보통 2~4회 필요. 무한 반복 안 되도록 라운드 5회 초과 시 사용자에게 진행 상황 보고 후 진행 여부 확인.
- 한 화 완료 = 한 루틴 종료 = `/session-end`. 다음 화는 새 세션에서 `/novel` 단독으로 진입.

---

## 저장 + 갱신 (페르소나 3명 모두 만족 후)

페르소나 3명 + voice-editor 만족 확인 후에만 진행. 라운드 중에는 저장만, 갱신은 최종 라운드에서.

1. **본문 저장**: `content/novel/<slug>/NNN-<title>.md` (frontmatter 포함)
2. **합평 저장**: `reviews/novel/<slug>/NNN-<title>.review.md` (라운드별 누적)
3. **`_canon.md` 갱신**:
   - 새 단서 → "미해결 단서" 절 추가
   - 단서 회수 → ~~취소선~~ + 회수 화 번호
   - 인물 마지막 등장 갱신
   - 시간선 충돌 감시 항목 추가/해소
4. **`_index.md` 갱신** (이게 마지막):
   - 마지막 완성 → 방금 작성한 화 번호
   - 다음 화 번호 → +1
   - 다음 화 진입점 단서 → 방금 화 끝 분위기 두세 문장 (도현 식, 정리 X)
   - 현재 아크 → +1 위치
   - 색인 표 → 방금 화 한 줄 채우기
   - 최종 갱신 타임스탬프
5. character-keeper 신규 인물 제안 있으면 `/character-add` 안내.
6. `docs/sessions/current.md` 업데이트.
7. **`/session-end` 호출** — 한 화 완성 = 한 루틴 종료. 자동.

---

$ARGUMENTS
