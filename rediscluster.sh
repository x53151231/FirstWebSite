#!/bin/bash
PORT=6379
NAME=redis-server
ID=`ps -ef | grep "$NAME" | grep -v "grep" | awk '{print $2}'`
#CHECK_PORT=`netstat -tnlp|grep "\b$PORT\b"`
REDIS_SERVER=/usr/local/bin/redis-server
REDIS_CLI=/usr/local/bin/redis-cli
REDIS_CONFIG=/etc/redis.conf
RETAVL=0
#检查shell公共函数库是否存在，存在就加载
FUNCTIONS_PATH=/etc/init.d/functions
[ -f $FUNCTIONS_PATH ]&& source $FUNCTIONS_PATH
#检查redis文件是否存在并可执行
[ -x $REDIS_SERVER ]|| exit 0

#定义函数
#检查是否执行成功
check(){
    RETAVL=$?
    if
        [ $RETAVL -eq 0 ];then
        action "redis is $1" /bin/true
    else
        action "redis is $1" /bin/false
    fi
}
#启动redis集群
start(){
    for i in {1..6}
    do
        ssh root@redis-cluster-$i "redis-server /etc/redis.conf"
    done
    
    RETAVL=$?
    if [[ $RETAVL -eq 0 ]]; then
        echo "rediscluster is started!";
    else
        echo "rediscluster start failed!";
    fi
    return $RETAVL

}
#停止redis集群
stop(){
    for i in {1..6}
    do
        ssh root@redis-cluster-$i "redis-cli shutdown"
    done

    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "rediscluster is stopped!";
    else
        echo "rediscluster stop failed!";
    fi
    return $RETVAL;
}
#清空集群数据
cleanup(){
    for i in {1..6}
    do
        ssh root@redis-cluster-$i "redis-cli FLUSHALL"
    done

    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "rediscluster data cleared!";
    else
        echo "rediscluster data cleanup failed!";
    fi
    return $RETVAL;
}
#redis集群状态
status(){
    /usr/local/bin/redis-cli CLUSTER INFO
    
    RETAVL=$?
    if [[ $RETAVL -eq 0 ]]; then
        echo "rediscluster is not running!";
    else
        echo "rediscluster is running!";
    fi
}

#重启服务
restart(){
    stop
    sleep 1
    start
}

#判断
case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
cleanup)
        cleanup
        ;;
status)
        status
        ;;
restart)
        restart
        ;;
*)
        echo $"Usage:$0{start|stop|cleanup|status|restart|help}"
esac
exit $RETAVL
