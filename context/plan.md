# Overnight brief: plan the 24-hour build of the Underscope routing app

You are the project manager and technical lead for a four-person team that has 24 hours
to build a working prototype. Tonight you plan; you do not build. Your output is a set of
markdown files that four people can open at 8 a.m. and start executing in parallel without
talking to you.

## Read first (once, then summarize to yourself in under 300 words)
- context/plan.md — the research plan, requirements and architecture we already agreed
- context/build-plan.md — the engineering sequence, codemap and training plan
- context/team.md — the four team members and their skills
- The current repo (if any code exists, note the stack; the front end is a Lovable app)

Do not re-read these files later. Work from your summary.

## The product to plan
Inputs per vehicle:
1. Photos (exterior, interior, engine bay, underbody)
2. Scanner output: a list of diagnostic trouble codes (OBD-II standard P/B/C/U codes,
   possibly manufacturer-specific ones)
3. VIN

Pipeline the app must perform:
1. Decode the VIN (NHTSA vPIC, free) into year, make, model, trim, body, engine.
2. Decode the scanner codes into affected systems and a severity, marking any code we
   cannot map as "unknown" rather than guessing.
3. Grade the photos part by part with a hosted vision-language model (no training) into
   fine / repairable / replace / unknown, plus flags for what photos cannot show.
4. Merge 2 and 3 into one condition record.
5. Produce a repair-cost band, an as-is value band per channel, and a recommendation:
   fix then sell, or sell as-is (and where), with a confidence level and the single
   check that would most change the answer. The decision rules are in context/plan.md
   (sections "Definition of a good buyer" and "Underlying logic").
6. Show it on a screen with the evidence, and let a human change a grade and recompute.

## What you must decide tonight
1. Feasibility. Define three versions (minimal, medium, stretch) of the pipeline above.
   For each, estimate person-hours by task, name the hard dependency, and state what
   the demo can and cannot show. Pick one version for the 24 hours and justify it in
   under 200 words. Default to the smallest version that runs end to end on 20 test
   vehicles; stretch items go in a "if ahead of schedule" list.
2. Interfaces first. Write the JSON contracts between stages (VIN result, decoded codes,
   photo grades, merged condition, bands, decision) so four people can work in parallel
   from hour one. Every field has a type, an example, and who produces and consumes it.
3. Task breakdown. Assign work to the four people by their skills in context/team.md.
   Every task has: owner, hour block, inputs, output file or endpoint, definition of
   done, and who is blocked by it. Build an hour-by-hour timeline with integration
   checkpoints at hours 8, 16 and 22.
4. Research you still need. Investigate tonight, with web search, and record findings
   with links: (a) the best free source for standard OBD-II code definitions and how to
   handle manufacturer-specific codes; (b) vPIC endpoint and response fields; (c) prompt
   patterns for structured JSON output from a vision model on multi-image input;
   (d) a quick source for rough parts prices and labor hours for 25 common parts on
   full-size pickups and cargo vans; (e) where to hand-collect comparable sold prices
   for the 20 test vehicles; (f) constraints of calling an external API from the
   Lovable app (edge functions, secrets, CORS). Cap research at 8 sources per topic.
   Anything unresolved becomes a task with an owner, not a guess.
5. Files and structure. Propose the folder layout and list every additional file the
   build will need (prompts, lookup tables, fixtures, schemas, scripts). Create the
   folders and stub files with a header comment saying what goes in each; write no
   application code.
6. Risks. List the five most likely ways the day fails and the fallback for each
   (for example: vision model returns inconsistent JSON → fix parser and lower
   temperature; code mapping incomplete → "unknown" path; API quota → cache results
   for the 20 test vehicles).
7. The demo. Write the 5-minute demo script and the exact 20 test vehicles to use
   (vehicle class, damage type, why each is in the set), including at least three
   where the answer should be "too close to call".

## Files to write (all markdown, all under docs/)
- docs/PLAN.md — chosen version, why, timeline, checkpoints, risks, out of scope
- docs/ARCHITECTURE.md — components and data flow with Mermaid diagrams
  (one flowchart of the pipeline, one sequence diagram of a single request,
  one diagram of who owns which component)
- docs/CONTRACTS.md — the JSON contracts between stages with examples
- docs/RESEARCH.md — findings from item 4 with sources, plus open questions as tasks
- docs/DEMO.md — the demo script and the 20-vehicle test set with a scoring sheet
- docs/TASKS.md — the master task list, grouped by hour block, with dependencies
- docs/team/<name>.md — one file per person: their tasks in order, each with inputs,
  output, definition of done, the contract fields they own, what they hand to whom and
  when, and what to do if they finish early or get stuck

## Token and model discipline (this matters)
- Route work by difficulty. Use the smallest capable model for each sub-agent: a fast
  model for scaffolding, formatting, file stubs and extracting facts from pages; a
  mid-tier model for research synthesis and task decomposition; the top-tier model only
  for the feasibility decision, the contracts and the final review of PLAN.md. Do not
  run the top-tier model for routine work.
- Spawn sub-agents with narrow briefs (one research topic or one output file each),
  parallel where independent, and have each return a summary under 400 words rather
  than raw page text.
- Read each context file once. Never paste a file back into the conversation. Write
  outputs incrementally and do not rewrite a file that is already correct.
- Hard stops: at most 8 sources per research topic; if a question cannot be settled in
  two searches, log it as a task and move on. Finish within a bounded budget; a complete
  plan with gaps marked is worth more than a perfect plan that is still running at 8 a.m.
- Before finishing, run one review pass with the top-tier model on PLAN.md and the four
  team files only, checking that no task is unowned, no hour block exceeds the person's
  capacity, and every contract field has a producer and a consumer.

## Rules
- Plan only. No application code tonight.
- Mark every estimate and unverified fact as such; never invent a number.
- Assume the team has no prior machine-learning experience: tasks must be
  concrete enough to execute from the file alone.
- End with docs/PLAN.md containing a 10-line summary a teammate can read in one minute.
