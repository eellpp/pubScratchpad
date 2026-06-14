
# Check usage
https://chatgpt.com/codex/cloud/settings/analytics#usage


# How codex usage work 
For the ChatGPT Plus plan, Codex is included, but it does not work as a fixed one-time credit bucket. Codex usage counts toward your plan’s agentic usage limit, which is shared with some other agentic features such as ChatGPT for Excel and Workspace Agents.   

The exact amount of Codex work you can do depends on task size, model choice, context length, and whether the task is local, cloud-based, or code-review related. Small scripts or simple changes may consume much less usage, while larger codebases, long-running tasks, or tasks with large context can consume significantly more.   

OpenAI has been moving Codex usage toward a credit/token-based model, where usage depends on input tokens, cached input tokens, and output tokens. A typical Codex task using GPT-5.5 may consume around 5–45 credits, but actual usage can vary.

If you hit your Codex limit on Plus, you may be able to either wait for the limit to reset or buy additional credits from the Codex usage dashboard, depending on what is available for your account and region.   


# How to estimate usage
Under the new system, the most useful practical way to understand Codex usage is this:

the longer the agent spends reasoning, the more of your 5-hour limit it consumes.

So the real question is no longer:

“How many messages do I get?”

The real question is:

“How many minutes of reasoning are included in my plan, and how much does each minute cost as a percentage of the 5-hour limit?”

## A practical formula

A simple way to estimate usage is:

Cost of a request = reasoning time × percentage cost per minute

This is not an official formula, but from a practical user perspective it is the most useful way to estimate real-world Codex usage

## Example 
 
Based on testing, the Plus plan on the latest GPT-5.4 model appears to provide roughly:

about 40 minutes of reasoning per 5-hour limit window

That means, approximately:

40 minutes = 100%

20 minutes = 50%

1 minute = 2.5%

So on Plus + GPT-5.4, a good working estimate is:

1 minute of reasoning costs about 2.5% of the 5-hour limit.

**references**:     
https://community.openai.com/t/understanding-the-new-codex-limit-system-after-the-april-9-update/1378768  

