package_name=



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
