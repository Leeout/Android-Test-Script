package_name=com.hupu.shihuo

shoucang_activity=cn.shihuo.modulelib.views.activitys.CollectionGoodsActivity

activity_list=("${shoucang_activity}")



get_current_activity(){
 command=$(adb shell dumpsys window | grep  mCurrentFocus)
 echo "${command##*/}"
}

check_activity(){
  if [[ "${activity_list[@]}" =~ get_current_activity ]];then
    echo get_current_activity
  fi
}

check_activity