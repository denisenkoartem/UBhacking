# Underscope overnight planning run

What this is: a folder you run Claude Code in. It reads `context/`, plans the 24-hour
build, and writes the plan into `docs/`. It writes no application code.

## 0. Before you run (5 minutes)
1. Edit `context/team.md`: four names, skills, hours, and the day's start time.
2. Replace the example in `context/scanner-sample.txt` with one real scanner output.
3. If your plan does not include Fable, change `model: fable` to `model: opus` in
   `.claude/agents/architect.md`.
4. Install Claude Code if you have not: https://code.claude.com/docs (desktop app
   "Code" tab, or the `claude` terminal command). Log in once.

## 1. Run it (pick one)

Watched for the first 10 minutes, then left alone (recommended the first time):

    cd underscope
    claude --model sonnet

then type:

    Read context/BRIEF.md and execute it fully.

Approve "always allow" for Write, Edit and web search when asked. Do not grant Bash;
nothing tonight needs it.

Fully unattended:

    cd underscope
    ./run-overnight.sh

(`run-overnight.sh` runs headless with an allow-list of tools and a hard turn limit,
and logs to `overnight.log`.)

## 2. In the morning
- Open `docs/PLAN.md`, then your own `docs/team/<name>.md`.
- To fix something: `claude -c` resumes the session; e.g. "the timeline assumes five
  people, we have four, fix it".
- If `overnight.log` shows it re-reading `context/plan.txt` repeatedly, stop it and
  resume with: "you have already read context/; do not read it again".

## What is where
- `context/BRIEF.md`         the prompt (the PM brief)
- `context/plan.pdf`, `plan.txt`  the research plan, requirements, architecture (text + PDF)
- `context/build-plan.md`    engineering sequence, training plan, codemap, architecture
- `context/team.md`          YOU FILL THIS IN
- `context/scanner-sample.txt`  YOU FILL THIS IN
- `.claude/agents/`          the three model tiers (haiku scout, sonnet researcher, fable architect)
- `docs/`                    empty; the run fills it
