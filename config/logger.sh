logger_debug(){
  echo "$(date "+%Y-%m-%d %H:%M:%S") -- PID:$$  ""\033[32m $1 \033[0m"
}

logger_debug test