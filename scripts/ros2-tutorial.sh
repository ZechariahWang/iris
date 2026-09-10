#!/usr/bin/env bash

DISCORD_USER_ID="637824014168883221"
# Same job id the old system-design job used; this script repurposes that slot.
JOB_ID="28df03be-56be-403e-b062-372fa612fe4e"

SCHEDULE="15 8 * * *"
TIMEZONE="America/New_York"

PROMPT="Teach me ONE core ROS2 (Robot Operating System 2) concept today, focused on the syntax. \
First read the file memory/ros2-taught.md in your workspace (create it if it does not exist). \
It lists every concept already covered. Pick one concept from the syllabus below that is NOT in that file yet, \
working roughly in the order the syllabus is written so the fundamentals come first. \
If every concept has already been covered, start a new cycle instead: pick the concept taught longest ago \
(the earliest line in the file) and reteach it with a fresh explanation, a DIFFERENT example, and any syntax \
detail that was skipped last time. \
Syllabus (the most common ROS2 concepts, in learning order): \
workspaces and packages (colcon build, source install/setup.bash, ros2 pkg create, package.xml and setup.py), \
nodes (rclpy.init, Node subclass, spin), \
topics with publishers and subscribers (create_publisher, create_subscription, timers), \
the ros2 CLI for inspection (ros2 run, ros2 node list/info, ros2 topic list/echo/pub/hz, ros2 interface show), \
standard message types (std_msgs, geometry_msgs, sensor_msgs) and how to import and fill them, \
services and clients (.srv, create_service, create_client, call_async, futures), \
parameters (declare_parameter, get_parameter, YAML param files, ros2 param CLI), \
launch files (Python launch API, LaunchDescription, Node action, arguments, ros2 launch), \
custom interfaces (.msg, .srv, .action files, rosidl in CMakeLists.txt and package.xml), \
actions (action servers and clients, goals, feedback, results), \
QoS (Quality of Service) profiles (reliability, durability, history depth, common mismatches), \
executors and callback groups (SingleThreadedExecutor vs MultiThreadedExecutor, reentrant vs mutually exclusive), \
tf2 (frames, TransformBroadcaster, static transforms, Buffer and TransformListener, lookup_transform), \
URDF and robot_state_publisher, \
ros2 bag (record, play, info), \
rviz2 and rqt (rqt_graph, rqt_console), \
lifecycle (managed) nodes and their state machine, \
namespaces and remapping (--ros-args -r, -p, __node, __ns), \
rclcpp equivalents of the rclpy patterns above, \
and Gazebo or simulation bringup basics. \
Format the lesson exactly like this, with no numbered headings: \
Line 1: the concept name in ALL CAPS, wrapped in double asterisks so it is bold on Discord, for example **PUBLISHERS AND SUBSCRIBERS**. \
Then a blank line, then one or two short plain-English sentences saying what it is and what problem it solves. \
Then one code block with the smallest complete, runnable example of the syntax (Python/rclpy by default, CLI \
commands when the concept is CLI-only). Keep the code minimal: no extra features, no error handling, only \
what is needed to show the pattern. Add a short inline comment on each important line so the code explains itself. \
Then a bullet list of at most four bullets, one line each, explaining the key syntax pieces: what each function \
or command does and which arguments matter. \
Then one final line starting with 'Gotcha:' with the single most common beginner mistake for this concept. \
Rules: I know Python but I am brand new to ROS2, so write like you are explaining to a beginner. Use everyday \
words, short sentences, and no jargon without a two or three word plain-English gloss the first time it appears, \
for example 'a node (one running program)'. Prioritize showing the syntax over explaining theory. \
Hard limit: the whole lesson must fit in ONE Discord message, under 1800 characters including the code block. \
No emojis, no emdashes, no section numbers, no closing summary. \
After composing the lesson, append a line with today's date and the concept name to memory/ros2-taught.md so the rotation stays tracked (repeat entries are expected once a new cycle starts). \
Do not use a message-sending tool to deliver this. Just write the full lesson as your \
final plain-text reply, it gets delivered automatically. If your reply is only a short \
confirmation with no actual lesson content, that is wrong, the full lesson \
text itself must be the final reply."

if [ -z "$DISCORD_USER_ID" ]; then
  echo "smt went wrong, enter user id"
  exit 1
fi

if [ -z "$JOB_ID" ]; then
  echo "Creating the ros2-tutorial cron job..."
  openclaw cron add --name "ros2-tutorial" --description "Daily ROS2 Syntax Tutorial" \
    --cron "$SCHEDULE" --tz "$TIMEZONE" \
    --session isolated --message "$PROMPT" \
    --announce --channel discord --to "user:$DISCORD_USER_ID" || exit 1
  echo ""
  echo ">>> Copy the \"id\" value from the JSON above and paste it into JOB_ID in this script."
  exit 0
fi

echo "Updating job settings (name + prompt + schedule + Discord DM target)"
openclaw cron edit "$JOB_ID" --clear-tools --name "ros2-tutorial" --description "Daily ROS2 Syntax Tutorial" \
  --message "$PROMPT" --cron "$SCHEDULE" --tz "$TIMEZONE" \
  --to "user:$DISCORD_USER_ID" || exit 1

echo "Firing a test run"
openclaw cron run "$JOB_ID"

echo "Run history (newest first):"
openclaw cron runs --id "$JOB_ID"
