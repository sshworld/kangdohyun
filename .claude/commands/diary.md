강도현이 오늘 일기를 쓴다. 아래 절차를 순서대로 실행한다.

## 전처리

1. `reference/biography.md` 전체 읽기 (메타 절 포함) — 자기 자신을 떠올린다.
2. `content/diary/`에서 가장 최근 파일 1~3편 읽기 — 어제의 흐름을 이어받는다.
3. `world/characters.md`와 `world/lexicon.md` 읽기 — 호칭·시점별 어휘 확인.
4. `dohyun-voice` 스킬과 `dohyun-diary` 스킬 로드.
5. **시점 파악**: 단서에 보육원·거리·영등포 등 시점 키워드나 연도가 있으면 그 시점 도현이 쓴다. 없으면 26세 현재. 파일명 날짜에서 도현 나이 자동 계산 (`그 해 - 2001`).

## 초고 작성

**dohyun** 에이전트가 1인칭으로 일기 초고를 작성한다.

- 사용자가 제공한 단서(있으면)를 오늘의 출발점으로 삼는다.
- 단서가 없으면 직전 글의 흐름과 '들쭉날쭉함'을 따른다 — 어떤 날은 한 줄, 어떤 날은 한 페이지.
- 약을 한 날이면 글이 어지럽다. 그냥 날은 담담하다. 일기이니 날짜도 제멋대로.

## 합평 패널 (병렬)

`panel-review` 스킬에 따라 5명 검사관을 **단일 메시지에서 동시에** 호출한다:
- voice-editor — 톤·맞춤법·자음 단독 호칭
- novelist-eye — 서사 효율
- psyche-checker — 심리회로 일치
- reality-checker — 사실성 (약물·장소·시세·법)
- character-keeper — 새 인물·호칭 규칙·world/ 갱신 제안

## 수정

**dohyun**이 합평을 받는다. 대부분 무시. 규칙:
- voice-editor의 직접명명·자음 단독·매끄러움 → 수정
- 사실 오류(reality-checker) → 조용히 수정
- 나머지 → 도현 판단. 거부 가능.

## 저장

1. `content/diary/YYYY-MM-DD-간단한제목.md`로 저장 (같은 날 여러 편이면 제목 다르게 하거나 `-01`/`-02`)
2. `reviews/diary/<filename>.review.md`로 합평 리포트 저장
3. character-keeper 제안이 있으면 `/character-add`로 확정 안내

---

$ARGUMENTS
