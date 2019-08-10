#!/usr/bin/env bash
first_Launch() {
  echo "开始进行3次全新安装启动应用耗时测试"
  for i in {1..3}; do
    echo "-----第 $i 次首次启动测试-----"
    uninsall_app
    install_app
    TotalTime[i]=$(adb shell am start -W "$Package_name"/"$Activity_name" | grep TotalTime | awk -F":" '{print $2}')
    sleep 1s
    echo "首次安装启动耗时:${TotalTime[i]} ms"
  done

  max=${TotalTime[0]}
  # shellcheck disable=SC2068
  for n in ${TotalTime[@]}; do
    if [[ n -gt ${max} ]]; then
      max=$n
    fi
  done
  echo "安装启动峰值:$max ms"

  # shellcheck disable=SC2004
  sum=$((${TotalTime[1]} + ${TotalTime[2]} + ${TotalTime[3]}))
  avg=$((sum / 3))
  echo "安装启动均值:$avg ms"
}

install_app() {
  echo "----重新安装被测APP $Package_name.apk ----"
  apps_dir=$(pwd)/apk
  adb install "$apps_dir"/"$Package_name".apk
}

uninsall_app() {
  echo "-----开始卸载被测App $Package_name.apk-----"
  adb uninstall "$Package_name"
}

Package_name=com.vipkid.app
Activity_name=.splash.SplashActivity
first_Launch
echo "----测试结束----"
