---
name: implement-story
description: Runs an automated implementation loop delegating story planning, architecture review, coding, and PR review across specialized subagents.
---

# Implement Story Process
You do not have a very big context window, using sub agents and keeping to the workflow is VERY IMPORTANT.
Execute this workflow when tasked with implementing a user story, feature, or GitHub issue:

## Step 1: Implementation
1. Invoke `@implementation` sub agent with the content of the github ticket, instruct it to use the 'implementation' skill.
2. Ensure `@implementation` sub agent writes corresponding tests and executes them using `bash`.

## Step 2: Automated Peer Review Loop
1. Invoke `@review` sub agent to inspect the created/modified files, tell it to use the 'review' skill.
2. Evaluate review output:
   - **If Critical / High / Medium issues are found:** Send feedback to `@implementation` to refactor, then repeat Step 3.
   - **If Approved / Nitpicks only:** Proceed to Step 4.

## Step 3: Finalization
Summarize the story implementation, modified files, test pass verification, and any open nitpicks.
