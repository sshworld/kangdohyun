기존 글에 합평 패널을 다시 돌린다. 새로 쓰는 게 아니라 이미 저장된 파일을 검수한다.

## 사용 방법

```
/critique content/diary/2026-04-29.md
/critique content/novel/모텔방.md --marketer
```

## 절차

1. 지정된 파일 읽기.
2. `panel-review` 스킬 로드.
3. 5명 검사관 병렬 호출 (기본):
   - voice-editor
   - novelist-eye
   - psyche-checker
   - reality-checker
   - character-keeper
4. `--marketer` 옵션이 있으면 marketer-eye도 포함.
5. 리포트를 `reviews/<type>/<filename>.review.md`에 저장 (기존 파일이면 덮어쓰거나 `-v2` 붙임).
6. 도현에게 결과 전달.

$ARGUMENTS
