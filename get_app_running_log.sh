#!/usr/bin/env bash
#实时捕获家长端APP运行日志
get_running_log() {
  apps_dir=$(pwd)/report/running_log
  pid=$(adb shell ps | grep dadaabcstudent | head -n1 | grep -v grep | awk '{print $2}')
  adb logcat -v time | grep --color "${pid}" >"${apps_dir}"/"$(date +%F%n%T)"_parent_app_log.report
}

get_running_log
