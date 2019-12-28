#!/usr/bin/env bash
source ../config/logger.sh

package_name=com.zheyun.qhy
activity_name=com.jifen.open.framework.launch.LauncherActivity

handle_password_window() {
  while true; do
    current_page=$(adb shell dumpsys activity top 2>/dev/null | sed -n '2p')
    pass_input=$(echo "$current_page" | grep AccountVerifyActivity)
    continue_install=$(echo "$current_page" | grep PackageInstallerActivity)
    confirm_install=$(echo "$current_page" | grep PackageInstallerActivityOther)

    if [[ 'x'"$pass_input" != 'x' ]]; then
      adb shell input text 'aaaa1111'
      adb shell input tap 350 860
    fi
    if [[ 'x'"$confirm_install" != 'x' || 'x'"$continue_install" != 'x' ]]; then
      adb shell input tap 480 1683
    fi
    sleep 1
  done
}

install_app() {
  logger_debug "----重新安装被测APP $package_name.apk ----"
  apps_dir=$(pwd)/../apk
  adb install "$apps_dir"/"$package_name".apk
}

uninsall_app() {
  package_check=$(adb shell pm list packages | grep "$package_name")
  if [[ -n ${package_check} ]]; then
    logger_debug "-----开始卸载被测App $package_name.apk-----"
    adb uninstall "$package_name"
  else
    logger_debug "当前没有安装该APP，可直接安装！"
    return 0
  fi
}

launch() {
  logger_debug "-----第 $i 次启动测试-----"
  total_time=$(adb shell am start -W "$package_name"/"$activity_name" | grep TotalTime)
  sleep 1s
  echo "第 $i 次 ${total_time} ms"
}

first_launch() {
  logger_debug "开始进行3次全新安装启动应用耗时测试"
  for i in {1..3}; do
    uninsall_app
    install_app
    launch
  done
  logger_debug "3次全新安装启动应用耗时测试结束"
}

hot_launch() {
  logger_debug "开始进行3次热启动应用耗时测试"
  uninsall_app
  install_app
  for i in {1..4}; do
    launch
    adb shell input keyevent 3
  done
  logger_debug "3次热启动应用耗时测试结束"

}

cold_launch() {
  logger_debug "开始进行3次冷启动应用耗时测试"
  for i in {1..3}; do
    adb shell am force-stop $package_name
    launch
  done
  logger_debug "3次冷启动应用耗时测试结束"
}

# shellcheck disable=SC2028
echo "-----选择要测试的启动方式：----- \n 【全新安装启动】-输入1 \n 【热启动】-输入2 \n 【冷启动】-输入3"
read -r test_type
case $test_type in
1)
  echo "-----开始【全新安装启动】耗时获取-----"
  first_launch
  ;;
2)
  echo "-----开始【热启动】耗时获取-----"
  hot_launch
  ;;
3)
  echo "-----开始【冷启动】耗时获取-----"
  cold_launch
  ;;
*)
  echo "输入错误!"
  ;;
esac
exit 0
