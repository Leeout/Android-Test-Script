#!/usr/bin/env bash
#实时捕获家长端APP运行日志
pid=$(adb shell ps | grep dadaabcstudent | head -n1 | grep -v grep | awk '{print $2}')
adb logcat -v time | grep --color "${pid}" >/Users/lijie/app_log/"$(date +%F%n%T)"_parent_app_log.log
