#!/usr/bin/env bash

DISCORD_USER_ID="637824014168883221"
JOB_ID="28df03be-56be-403e-b062-372fa612fe4e"

SCHEDULE="15 8 * * *"
TIMEZONE="America/Edmonton"

PROMPT="Teach me ONE important system design concept for job interviews today. \
First read the file memory/system-design-taught.md in your workspace (create it if it does not exist). \
It lists every concept already covered. Pick one core concept that is NOT in that file yet. \
If every concept from the syllabus below has already been covered, start a new cycle instead: \
pick the concept taught longest ago (the earliest line in the file) and reteach it with a fresh \
explanation and a DIFFERENT real-world example than before. \
Draw topics from the standard interview syllabus used by Grokking the System Design Interview and System Design School, for example: \
load balancing, caching strategies, CDNs, database sharding, replication, consistent hashing, CAP theorem, \
SQL vs NoSQL, database indexing, message queues, pub/sub, rate limiting, API gateways, microservices vs monolith, \
websockets vs polling, idempotency, distributed transactions and sagas, event sourcing, leader election, \
bloom filters, back of the envelope estimation, data partitioning, eventual vs strong consistency, \
object storage, search indexing, fan-out on write vs read, hot spots and celebrity problems. \
Structure the lesson exactly like this: \
1. Concept name. \
2. What it is, in two or three plain sentences. \
3. Why interviewers care and when to bring it up. \
4. How it works, including the key tradeoffs and terms I should say out loud in an interview. \
5. One concrete real-world example of it in use (for example how Twitter, Netflix, or Uber applies it). \
6. One sentence I could actually say in an interview to sound fluent. \
Important: assume I know basic programming but zero system design jargon. Every technical term, \
abbreviation, or acronym you use (for example L4, L7, TTL, quorum, replica, hash ring) must be \
explained in one plain sentence the FIRST time it appears, do not leave any term undefined. \
When a term is one option out of a set, briefly name the other options and what they are, for \
example if you mention L4 and L7 load balancing, say these refer to layers of the OSI networking \
model, give a one-line summary of what that model is, and note what the other relevant layers do. \
Keep it simple and concise but with enough depth to discuss for a few minutes in an interview. \
No emojis, no emdashes. Keep it short enough for one or two Discord messages. \
After composing the lesson, append a line with today's date and the concept name to memory/system-design-taught.md so the rotation stays tracked (repeat entries are expected once a new cycle starts). \
Do not use a message-sending tool to deliver this. Just write the full lesson as your \
final plain-text reply, it gets delivered automatically. If your reply is only a short \
confirmation with no actual lesson content, that is wrong, the full lesson \
text itself must be the final reply."

if [ -z "$DISCORD_USER_ID" ]; then
  echo "smt went wrong, enter user id"
  exit 1
fi

if [ -z "$JOB_ID" ]; then
  echo "Creating the system-design cron job..."
  openclaw cron add --name "system-design" --cron "$SCHEDULE" --tz "$TIMEZONE" \
    --session isolated --message "$PROMPT" \
    --announce --channel discord --to "user:$DISCORD_USER_ID" || exit 1
  echo ""
  echo ">>> Copy the \"id\" value from the JSON above and paste it into JOB_ID in this script."
  exit 0
fi

echo "Updating job settings (prompt + schedule + Discord DM target)"
openclaw cron edit "$JOB_ID" --message "$PROMPT" --cron "$SCHEDULE" --tz "$TIMEZONE" \
  --to "user:$DISCORD_USER_ID" || exit 1

echo "Firing a test run"
openclaw cron run "$JOB_ID"

echo "Run history (newest first):"
openclaw cron runs --id "$JOB_ID"
