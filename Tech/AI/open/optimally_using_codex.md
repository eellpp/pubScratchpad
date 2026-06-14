as_of : June 2026

OpenAI’s model release notes mention Codex CLI/IDE offering to switch to **GPT-5-Codex-Mini when you reach 90% of your 5-hour usage limit**. So the 5-hour window language is real. ([OpenAI Help Center][1])

But OpenAI’s current Codex usage docs do **not** describe Plus as “X messages every 5 hours” in a simple fixed way. They say Codex usage counts toward your **agentic usage limit**, and the number of Codex messages varies based on task size, complexity, where the task runs, and how much context is needed. ([OpenAI Help Center][2])

## How to estimate usage

Think of Codex usage less like “number of prompts” and more like:

**usage = model cost × context size × output size × number of turns/tool steps**

OpenAI says a typical Codex task using GPT-5.5 may consume around **5–45 credits per task**, but there is large variance depending on model used, number of instances, automations, and fast mode. ([OpenAI Help Center][3])

A rough mental model:

| Task type                                                         | Likely usage |
| ----------------------------------------------------------------- | -----------: |
| “Fix this one Java method”                                        |          Low |
| “Add a small endpoint and tests”                                  |   Low–medium |
| “Understand this whole Spring Boot project and implement feature” |  Medium–high |
| “Refactor multiple modules with tests and debugging”              |         High |
| “Keep a long session open across many files and repeated retries” |    Very high |

## How to optimise so more work gets done

The biggest trick is: **do not ask Codex to rediscover the whole project every time**.

For your Java 17 / Maven / Spring Boot / SQLite kind of project, I would use this pattern:

### 1. Give Codex one small task at a time

Bad:

> Analyse the whole repo, design the app, create DB schema, implement UI, write tests, fix bugs, and update docs.

Better:

> Implement only the SQLite schema and repository layer for storing HN stories, comments, YouTube links, tags, and context. Do not touch UI yet. Add unit tests.

This keeps context and output smaller.

### 2. Keep a `TASK.md` file in the repo

Create a file like:

```md
# Current Codex Task

Project: HN YouTube Link Extractor
Stack: Java 17, Maven, Spring Boot, SQLite
Current goal: Implement minimal local UI for browsing extracted links.

Do:
- Add endpoint/listing for links by date range.
- Add filter by tag.
- Show story title, HN URL, YouTube URL, comment context, classification tag.
- Keep UI minimal.

Do not:
- Add authentication.
- Add cloud deployment.
- Add React unless necessary.
- Rewrite existing schema unless required.
```

Then ask Codex:

> Read TASK.md and implement only that.

This reduces repeated explanation and prevents Codex from expanding scope.

### 3. Ask for a plan first, then implementation

Use two turns:

> Inspect the repo and propose the smallest implementation plan. Do not edit files yet.

Then:

> Implement step 1 only.

This may sound like more messages, but it often saves usage because it avoids wrong large edits and repeated corrections.

### 4. Prefer smaller model / mini mode when available

OpenAI says Codex can offer to switch to a Mini model near 90% of the 5-hour usage limit, and Mini is intended to help you work longer. ([OpenAI Help Center][1])

Use the strongest model for:

* architecture decisions
* hard bug diagnosis
* complex refactoring

Use mini / cheaper mode for:

* adding tests
* README updates
* simple CRUD
* formatting
* small shell scripts
* minor fixes

### 5. Avoid “scan everything” prompts

These are expensive:

> Understand the whole codebase.

> Review all files.

> Find all issues.

Better:

> Look only at `src/main/java/.../YoutubeLinkService.java`, `schema.sql`, and related tests.

Or:

> Search for the repository class used for YouTube links, then modify only the necessary files.

### 6. Keep outputs short

Long explanations consume output tokens. Tell Codex:

> Keep the final summary under 10 lines. Do not paste full files unless needed.

### 7. Batch related tiny changes, but not unrelated changes

Good batch:

> Add date filter, tag filter, and pagination to the link listing endpoint.

Bad batch:

> Add UI, add scheduler, redesign schema, add LLM classification, add Docker, add export to CSV.

### 8. Use your IDE/build locally

Do not make Codex repeatedly run heavy commands unless needed. For example, you can run:

```bash
mvn test
```

Then paste only the failing error section. This is cheaper than asking Codex to run and inspect everything repeatedly.

### 9. Watch the usage dashboard

OpenAI says you can monitor limits in **Codex Settings > Usage**, and some Plus/Pro users can buy credits after included usage is exhausted. ([OpenAI Help Center][3]) Your included usage is used first; after hitting plan limits, usage can draw from purchased credits if available. ([OpenAI Help Center][4])

## Practical workflow for your project

For your HN YouTube extractor, I’d split Codex sessions like this:

**Session 1: storage and data model**

> Implement SQLite schema + entities/repositories only. No UI.

**Session 2: extraction pipeline**

> Given stored HN story/comment data, extract YouTube links and save URL + comment context.

**Session 3: classification**

> Add simple rule-based tag classifier first: tech, science, arts, politics, finance, misc. No LLM yet.

**Session 4: minimal UI**

> Add a minimal Spring Boot HTML page or Datasette-compatible view to filter by date and tag.

**Session 5: polish**

> Add README, bash start script, sample queries, and tests.

This is much more limit-friendly than one huge “build the whole thing” Codex request.

[1]: https://help.openai.com/en/articles/9624314-model-release-notes "Model Release Notes | OpenAI Help Center"
[2]: https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan "Using Codex with your ChatGPT plan | OpenAI Help Center"
[3]: https://help.openai.com/en/articles/20001106-codex-rate-card "Codex rate card | OpenAI Help Center"
[4]: https://help.openai.com/en/articles/12642688-using-credits-for-flexible-usage-in-chatgpt-freegopluspro-sora "Using Credits for Flexible Usage in ChatGPT (Free/Go/Plus/Pro)  | OpenAI Help Center"
