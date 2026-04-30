# 세션 추적 시스템

`/clear`로 컨텍스트를 초기화해도 이전 작업 내용을 잃지 않기 위한 시스템.

---

## 동작 원리

```
새 프롬프트 제출
       ↓
UserPromptSubmit 훅 (session-inject.sh)
       ↓
current.md 존재 여부 + 날짜 확인
  ├─ 오늘 세션 있음 → current.md 내용 Claude에 주입
  └─ 없음 or 날짜 변경 → 이전 current.md 아카이브 → 새 세션 생성 → 주입
       ↓
Claude가 컨텍스트를 갖고 응답
       ↓
작업 단위 완료 시 Claude가 current.md 직접 업데이트
```

---

## 파일 구조

```
docs/sessions/
├── README.md              — 이 파일
├── current.md             — 현재 세션 (항상 최신, Claude가 업데이트)
└── YYYY-MM-DD-NNN.md      — 아카이브 세션 (날짜 변경 시 자동 생성)
```

---

## Claude에게 지시하는 내용 (CLAUDE.md)

Claude는 다음 시점에 `docs/sessions/current.md`를 업데이트한다:
- 의미 있는 작업 단위가 완료됐을 때
- 사용자가 `/session-end`를 호출했을 때
- 세션을 명시적으로 닫을 때

---

## 세션 파일 형식

```markdown
# 세션 YYYY-MM-DD-NNN

**시작**: YYYY-MM-DD HH:MM KST
**업데이트**: YYYY-MM-DD HH:MM KST
**상태**: 진행 중 | 완료

## 현재 상태
한 줄 요약

## 완료
- 완료된 작업 bullet

## 다음 / 진행 중
- 다음 할 일

## 주요 파일 변경
- `경로` — 설명

## 중요 결정
- 결정 사항
```

**규칙**: 총 40줄 이하 유지. 길어지면 오래된 항목 삭제.

---

## 슬래시 커맨드

| 커맨드 | 동작 |
|---|---|
| `/session-new` | 현재 세션 아카이브 + 새 세션 강제 시작 |
| `/session-end` | 현재 세션 요약 작성 + 아카이브 + 상태 완료 처리 |

---

## 훅 설정 위치

`.claude/settings.json` → `UserPromptSubmit` → `.claude-hooks/session-inject.sh`

---

## 주의

- `current.md`는 **덮어쓰기**가 원칙. git으로 히스토리 관리할 경우 커밋 빈도 조절.
- 세션 파일은 40줄 이하가 이상적. 길어질수록 주입 오버헤드 증가.
- `session-inject.sh`가 출력하는 내용은 **매 프롬프트마다** Claude에게 전달된다.
