#!/usr/bin/env bash
package_name=com.hunting.matrix_callershow
activity_name=com.cootek.smartdialer.v6.TPDTabActivity

install_app() {
  echo "----重新安装被测APP $package_name.apk ----"
  apps_dir=$(pwd)/../apk
  adb install "$apps_dir"/"$package_name".apk
}

uninsall_app() {
  echo "-----开始卸载被测App $package_name.apk-----"
  adb uninstall "$package_name"
}

launch() {
  echo "-----第 $i 次启动测试-----"
  total_time=$(adb shell am start -W "$package_name"/"$activity_name" | grep TotalTime)
  sleep 1s
  echo "第 $i 次 ${total_time} ms"
}

first_launch() {
  echo "开始进行3次全新安装启动应用耗时测试"
  for i in {1..3}; do
    uninsall_app
    install_app
    launch
  done
  echo "3次全新安装启动应用耗时测试结束"
}

hot_launch() {
  echo "开始进行3次热启动应用耗时测试"
  uninsall_app
  install_app
  for i in {1..4}; do
    launch
    adb shell input keyevent 3
  done
  echo "3次热启动应用耗时测试结束"

}

cold_launch() {
  echo "开始进行3次冷启动应用耗时测试"
  for i in {1..3}; do
    adb shell am force-stop $package_name
    launch
  done
  echo "3次冷启动应用耗时测试结束"
}

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
  exit 1
  ;;
esac
exit 0
