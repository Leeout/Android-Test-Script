#!/usr/bin/env bash
get_running_log() {
  apps_dir=$(dirname "$PWD")/report/running_log
  echo "日志存放路径:""${apps_dir}"
  pid=$(adb shell ps | grep "$1" | head -n1 | grep -v grep | awk '{print $2}')
  if [[ $2 -eq 1 ]]; then
    adb logcat -v time | grep --color "${pid}" >"${apps_dir}"/"$(date +%F%n%T)"_"$1".log
  else
    adb logcat *:W time | grep --color "${pid}" >"${apps_dir}"/"$(date +%F%n%T)"_"$1".log
  fi
}

# shellcheck disable=SC2028
echo "-----选择要抓取日志的APP：----- \n 【趣铃声】-输入1 \n 【趣护眼】-输入2 \n 【天天爱清理】-输入3"
read -r test_app
# shellcheck disable=SC2028
echo "-----选择要捕获的日志等级：----- \n VERBOSE-输入1 \n WARN以上-输入2"
read -r log_level

case $test_app in
1)
  echo "-----开始捕捉【趣铃声】APP日志-----"
  get_running_log com.zheyun.bumblebee "$log_level"
  ;;
2)
  echo "-----开始捕捉【趣护眼】APP日志-----"
  get_running_log com.zheyun.qhy "$log_level"
  ;;
3)
  echo "-----开始捕捉【天天爱清理】APP日志-----"
  get_running_log com.xiaoqiao.qclean "$log_level"
  ;;
*)
  echo "输入错误!"
  exit 1
  ;;
esac
exit 0
