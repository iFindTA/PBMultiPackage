#!/bin/bash

#vars
declare -a CHANNELS=(default)

# exit when occured error in progress!
function exitWithErrMsg() {
  echo "could not continue cause of an error:" $1
  exit 1
}

#judge whether empty or not
function whetherEmpty() {
  tmpObj=$1
  echo ${#tmpObj[*]} 'count' $tmpObj
  if [[ ${#$tmpObj[@]} = 0 ]]; then
    #statements
    echo 'null object array'
  fi
  #ret=$false
  if [ ! $1 ]; then
    echo 'empty'
    return 0
  else
    echo 'un empty'
    return 1
  fi
}

# handle paths array: remove presuffix path
function removePreSuffixPath() {
  idx=0
  for iPath in "${CHANNELS[@]}"; do
    #statements
    dir=${iPath##*/}
    CHANNELS[idx]=$dir
    idx=`expr $idx + 1`
  done
}

# function lsdir()
# {
# for i in `ls`;do
#   if [ -d "$i" ] ;then
#      cd ./$i
#      #lsdir
#    else
#      echo $i
#    fi
# done
# }
# lsdir

#进度
# b='' 
# for ((i=0;$i<=100;i+=2))  
# do  
#         printf "progress:[%-50s]%d%%\r" $b $i  
#         sleep 0.1  
#         b=#$b  
# done  
# echo 

#全局定义
PWD='.'
PROJECTNAME=''
SOURCEDIR='MCResources'
CHANNELDIR=$PWD/$SOURCEDIR
# Provisioning Profile 需修改 查看本地配置文件
PROVISIONING_PROFILE="xxxxxxx-xxxx-4bfa-a696-0ec7391b24d8"
############# 重签名需要文件
# 以下文件需放在 ipaPath 路径下
Entitlements=$ipaPath/entitlements.plist
# Code Sign ID
CODE_SIGN_IDENTITY="xx co., LTD"
# 生成 APP 路径
BUILD_DIR="build/Release-iphoneos"

function dirExist() {
  if [[ ! -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}


echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>init project'
projectPath=($(find ../ -maxdepth 1 -name "*.xcodeproj"))
projectPath=${projectPath##*/}
eval tmp='`echo $projectPath | cut -d "." -f1 `'
#echo $projectPath | cut -d "." -f 1 > $PROJECTNAME
PROJECTNAME=$tmp
echo 'project scheme is' "'$PROJECTNAME'"

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>检索所有配置过的打包渠道'
#检索所有配置过的打包渠道
if [ ! -d "$CHANNELDIR" ];then
  echo 'not exist!'
  exitWithErrMsg "destnation dir was not exist !"
else
  
  idx=1
  for file in $CHANNELDIR/*; do
    if test -f $file;then
      echo $file 'is file!'
    else
      echo $file 'is dir!'
      dirExist $file
      if [ $? = 1 ];then
        CHANNELS[idx]=$file
        idx=`expr $idx + 1`
      fi
    fi
  done
fi

#过滤：是否存在渠道，也可以不过滤 空则只打包default渠道


echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>整理渠道 去掉path'
#数组长度
# echo '数组长度' ${#CHANNELS[@]}
# echo ${CHANNELS[@]}
removePreSuffixPath
echo 'all channel list:' ${CHANNELS[*]}

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>备份资源'

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>按照渠道开始打包'
xcodebuild-select


#find . -xdev -name "custom_*.plist"
#FILE_DEST=($(find .. ! -name "." -type d -prune -o -type f -iname "custom_*.plist"))
#FILE_DEST=($(find ../ -xdev -name "custom_*.plist"))
FILE_DEST=($(find ../ -maxdepth 1 -name "custom_*.plist"))
echo $FILE_DEST

if [ ! $FILE_DEST ];then
  echo 'is null'
  #exitWithErrMsg 'null params'
else
  echo 'not null'
fi
# FILEPATH=${FILE_DEST[0]}
# FILE=${FILEPATH##*/}
# echo $FILE
 DIR_DEST=($(find $CHANNELDIR -maxdepth 1 -name "custom_*.xcassets"))
 echo $DIR_DEST
# DIRPATH=${DIR_DEST[0]}
# DIR=${DIRPATH##*/}
# echo $DIR

