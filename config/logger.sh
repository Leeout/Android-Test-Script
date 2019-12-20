logger_debug(){
  echo "\033[32m $(date "+%Y-%m-%d %H:%M:%S") -- PID:$$   $1 \033[0m"
}

logger_debug test