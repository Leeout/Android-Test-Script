#!/usr/bin/env bash
get_adb_log() {
  apps_dir=$(dirname "$PWD")/report/running_log
  echo "日志存放路径:""${apps_dir}"
  param=-v
  log_level=_VERBOSE
  pid=$(adb shell ps | grep "$1" | head -n1 | grep -v grep | awk '{print $2}')
  if [[ $2 -ne 1 ]]; then
    param="*:W"
    log_level=_WARN
  fi
  adb logcat "${param}" time | grep --color "${pid}" | tee -a "${apps_dir}"/"$(date +%F%n%T)"_"$1""$log_level".log
}

echo "-----选择要捕获的日志等级：----- \n VERBOSE-输入1 \n WARN以上-输入2"
read -r log_level

package_name=$(test)
get_adb_log "$package_name" "$log_level"
