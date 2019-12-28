#!/usr/bin/env bash
#--------------------------------------------
# 兼容性测试的详细过程：
#1.屏幕解锁；
#2.设备连接；
#3.安装APK；
#4.启动APP；
#5.启动logcat；
#6.启动GT抓取性能数据；
#7.运行APP；
#8.控件遍历；
#9.停止GT；
#10.停止logcat；
#11.卸载APP；
#--------------------------------------------
source running_log.sh
source start_time.sh

gt_report_dir=$(dirname "$PWD")/report/gt_report
device_id=$(adb get-serialno)
Package_name=
Activity_name=#启动页Activity

if ! ${device_id};then
  echo "测试设备未连接！"
  exit 1
fi

#屏幕解锁
adb shell am start -n io.appium.unlock/.Unlock

#先卸载然后安装APP
uninsall_app
insall_app

#启动APP
adb -s "${device_id}" shell am start -W -n ${Activity_name}

#启动logcat
get_running_log ${Package_name} 1

#启动GT-有以下6个过程
adb -s "${device_id}" shell am start -W -n com.tencent.wstt.gt/.activity.GTMainActivity
#运行被测应用
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.baseCommand.startTest --es pkgName ${Package_name}
#勾选CPU
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.baseCommand.sampleData --ei cpu 1
#勾选内存
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.baseCommand.sampleData --ei pss 1
#勾选流量
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.baseCommand.sampleData --ei net 1
#电量采集
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.plugin.battery.startTest --ei refreshRate 250 --ei
brightness 100 --ez T true

#monkey随机点击
adb -s "${device_id}" shell monkey -p ${Package_name} --pct-touch 45 --pct-motion 20 --pct-trackball 5 --pct-nav 1 --pct-appswitch 20 --pct-flip 6 --throttle 50 -s 10 -v 3000

#停止GT
adb -s "${device_id}" shell am broadcast -a com.tencent.wstt.gt.baseCommand.endTest --es saveFolderName report

#停止logcat
pid=$(adb shell ps | grep ${Package_name} | head -n1 | grep -v grep | awk '{print $2}')
kill -9 "${pid}"

#拉取GT采集到的性能数据到PC
adb -s "${device_id}" pull /sdcard/GT/GW/com.tencent.mobileqq/7.0.0/temp "${gt_report_dir}"

#最后卸载APP
uninsall_app
