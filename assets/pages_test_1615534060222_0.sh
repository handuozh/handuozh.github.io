#!/bin/sh
 
#显示进度的总格数
total_process=100
#当前进度格数
current_process=0
#百分比
percent=0
#文件大小
total_size=455000
#当前文件大小
current_size=0
#用于记录上一次的进度
old_process=0
  
print_progress ()
{
    incomplete_process=$((${total_process}-${current_process}))
    if [ ${incomplete_process} -lt 0 ]; then
        incomplete_process=0
        current_process=${total_process}
        percent=100
    fi
    #输出已升级部分，用>表示
    printf "\rProgress：[%.${current_process}d" | tr '0' '>'
    #输出未升级部分，用' '表示
    printf "%.${incomplete_process}d]" | tr '0' ' '
    #输出当前百分比
    printf "${percent}%%"
}
 
display ()
{
    while true
    do
        #统计当前已解压文件大小
        current_size=$(du -s /mnt/usb-Seagate_Expansion_NAA28AA9-0:0-part1/Datasets/megadepth/phoenix/S6/zl548/ | awk '{printf $1}')
        percent=$((${current_size}/(${total_size}/100)))
#       echo ${percent}
        current_process=$((${percent}\*${total_process}/100))
#       echo ${current_process}
        if [ ${current_process} -eq 0 ]; then
            print_progress
        elif [ ${current_process} -ne ${old_process} ]; then
            print_progress
            old_progress=${current_process}
        fi
        #以tar进程结束来结束本进程
        ps -ef | grep "tar jxvf" | grep -v "grep" > /dev/null
        if [ $? -ne 0 ]; then
            echo "Update Over"
            break
        fi
    done
}
 
tar -xf MegaDepth_SfM_v1.tar.xz -C /mnt/usb-Seagate_Expansion_NAA28AA9-0:0-part1/Datasets/megadepth/phoenix/S6/zl548/ --skip-old-files > /dev/null &
display
