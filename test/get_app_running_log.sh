#!/usr/bin/env bash
get_running_log() {
  apps_dir=$(dirname "$PWD")/report/running_log
  echo "日志存放路径:""${apps_dir}"
  pid=$(adb shell ps | grep "$1" | head -n1 | grep -v grep | awk '{print $2}')
  adb logcat -v time | grep --color "${pid}" >"${apps_dir}"/"$(date +%F%n%T)"_"$1".log
}

echo "-----选择要测试的APP：----- \n 【趣铃声】-输入1 \n 【趣护眼】-输入2 \n 【天天爱清理】-输入3"
read -r test_app
case $test_app in
1)
  echo "-----开始捕捉【趣铃声】APP日志-----"
  get_running_log com.zheyun.bumblebee
  ;;
2)
  echo "-----开始捕捉【趣护眼】APP日志-----"
  get_running_log com.zheyun.qhy
  ;;
3)
  echo "-----开始捕捉【天天爱清理】APP日志-----"
  get_running_log com.xiaoqiao.qclean
  ;;
*)
  echo "输入错误!"
  exit 1
  ;;
esac
exit 0
