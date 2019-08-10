#!/usr/bin/env bash
#实时捕获家长端APP运行日志
running_log() {
  apps_dir=$(pwd)/app_log
  pid=$(adb shell ps | grep dadaabcstudent | head -n1 | grep -v grep | awk '{print $2}')
  adb logcat -v time | grep --color "${pid}" >"${apps_dir}"/"$(date +%F%n%T)"_parent_app_log.log
}

running_log
