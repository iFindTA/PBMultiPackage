#!/bin/bash

##########################################################################################################
# @Author: nanhujiaju@gmail.com @Date: 2017.6.6 @Version: 1.1.0
##########################################################################################################

#vars
CMDDIR='PackageCmd'
DEFAULT_CNN='default'
declare -a CHANNELS=($DEFAULT_CNN)

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
BACKUP='BACKUP'
PROJECTNAME=''
SCHEMEBUILD=''
SCHEMEVERSION=''
SOURCEDIR='MCResources'
CUSTOMKEY='MCCustom'
INFOPLIST_FILE='Info.plist'
CHANNELDIR=$PWD/$SOURCEDIR
BACKUPDIR=$PWD/$BACKUP
#default下的资源文件夹
ORIGINASSETS='custom.xcassets'
ORIGINRESOURCEDIR=''
# Provisioning Profile 需修改 查看本地配置文件
CONFIGURE='Release'
#企业(enterprise)证书名#描述文件
#enterprise的Bundle ID
BundleID="com.hzflk.mixintong-5.0"
#xcode8及以后需要设置exportOptions 废弃了exportFormat等
ExportOptionsPlist='exportOptions.plist'
CODE_SIGN_IDENTITY="iPhone Distribution: Flk Information Security Technology Co., Ltd."
PROVISIONING_PROFILE_NAME="d5e26810-7243-4ca5-96fb-2587e57725c3"
############# 重签名需要文件
# 以下文件需放在 ipaPath 路径下
Entitlements=$ipaPath/entitlements.plist
# 生成 APP 路径
BUILD_DIR="build/Release-iphoneos/output"
LOGIN_KEYCHAIN='~/Library/Keychains/login.keychain'
# 用户密码
LOGIN_PASSWORD='410626nanhujiaju'

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
ORIGINRESOURCEDIR="../$PROJECTNAME/$SOURCEDIR/$ORIGINASSETS"
echo 'project scheme is' "'$PROJECTNAME'" $ORIGINRESOURCEDIR
project_infoplist_path=../$PROJECTNAME/$INFOPLIST_FILE
#取版本号
SCHEMEVERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
#取build值
SCHEMEBUILD=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
echo 'build' $SCHEMEBUILD $SCHEMEVERSION
#exitWithErrMsg 'debug'
echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>检索所有配置过的打包渠道'
#检索所有配置过的打包渠道
if [ ! -d "$CHANNELDIR" ];then
  echo 'not exist!'
  exit 1
  #exitWithErrMsg "destnation dir was not exist !"
else
  
  idx=1
  for file in $CHANNELDIR/*; do
    if test -f $file;then
      echo $file 'is file!'
    else
      #echo $file 'is dir!'
      dirExist $file
      if [ $? = 1 ];then
        CHANNELS[idx]=$file
        idx=`expr $idx + 1`
      fi
    fi
  done
fi

echo '检索完毕！'

#!过滤：是否存在渠道，也可以不过滤 空则只打包default渠道


echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>整理渠道 去掉前缀'
#数组长度
# echo '数组长度' ${#CHANNELS[@]}
# echo ${CHANNELS[@]}
removePreSuffixPath
echo 'all channel list:' ${CHANNELS[*]}

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>备份默认渠道资源'
echo 'refresh dir...'
rm -rf $BACKUPDIR
mkdir $BACKUPDIR
echo 'coping resource...'

INFOPLIST_ORIGIN_PATH=../$PROJECTNAME/$INFOPLIST_FILE
cp -r ../$PROJECTNAME/$SOURCEDIR/*.* $BACKUPDIR/
echo 'coping info-plist...'

echo $INFOPLIST_ORIGIN_PATH

cp $INFOPLIST_ORIGIN_PATH $BACKUPDIR/

function resetDefaultConfigure() {
  echo 'reset to default state...'
  #强制覆盖文件 不再提示yesINFOPLIST_FILE or no
  \cp $PWD/$BACKUP/$INFOPLIST_FILE $INFOPLIST_ORIGIN_PATH
  echo 'clean...'
  rm -rf $ORIGINRESOURCEDIR/*
  \cp -r $PWD/$BACKUP/$ORIGINASSETS/*.* $ORIGINRESOURCEDIR/
  echo 'done!'
}

# exit when occured error in progress!
function exitWithErrMsg() {
  echo "could not continue cause of an error:" $1
  resetDefaultConfigure
  exit 1
}

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>按照渠道开始打包'

# fetch custom plist file 4 path
function fetchPlistFile4Path() {
 #  DIR_DEST=($(find $CHANNELDIR -maxdepth 1 -name "custom_*.xcassets"))
 # echo $DIR_DEST
 # DIRPATH=${DIR_DEST[0]}
 # DIR=${DIRPATH##*/}
 # echo $DIR

  tmpPath=$1
  #find . -xdev -name "custom_*.plist"
  FILE_DEST=($(find $tmpPath -maxdepth 1 -name "custom_*.plist"))
  #echo $FILE_DEST

  if [ ! $FILE_DEST ];then
    #echo 'is null'
    exitWithErrMsg 'there is no custom plist file!'
  fi
  FILEPATH=${FILE_DEST[0]}
  FILE=${FILEPATH##*/}
  echo $FILE
  #eval "$1=${tmpPath}/'$FILE'"
}

function fetchAssetsFile4Path() {
  tmpPath=$1
  #find . -xdev -name "custom_*.plist"
  DIR_DEST=($(find $tmpPath -maxdepth 1 -name "custom_*.xcassets"))
  #echo $FILE_DEST
  if [ ! $DIR_DEST ];then
    #echo 'is null'
    exitWithErrMsg 'there is no custom plist file!'
  fi
  DIRPATH=${DIR_DEST[0]}
  FILE=${DIRPATH##*/}
  echo $FILE
}

# custom resource for difference channel
function cutomResource4Channel() {
  tmpCnn=$1
  echo 'configure info-plist...'
  #/usr/libexec/PlistBuddy -c "Print" $INFOPLIST_ORIGIN_PATH
  echo "delete old cfgs for '$CUSTOMKEY'..."
  /usr/libexec/PlistBuddy -c "Delete :'$CUSTOMKEY'" $INFOPLIST_ORIGIN_PATH
  /usr/libexec/PlistBuddy -c "Delete :'CFBundleDisplayName'" $INFOPLIST_ORIGIN_PATH
  echo 'merge new cfgs...'
  tmpPath=$PWD/$SOURCEDIR/$tmpCnn
  plist_file=`fetchPlistFile4Path $tmpPath`
  new_file_path=$tmpPath/$plist_file
  /usr/libexec/PlistBuddy -c "Merge '$new_file_path'" $INFOPLIST_ORIGIN_PATH
  echo 'merge result:'
  /usr/libexec/PlistBuddy -c "Print" $INFOPLIST_ORIGIN_PATH

  echo 'configure resource...'
  assets_file=`fetchAssetsFile4Path $tmpPath`
  new_dir_path=$tmpPath/$assets_file
  echo $new_dir_path
  rm -rf $ORIGINRESOURCEDIR/*
  cp -r $new_dir_path/*.* $ORIGINRESOURCEDIR/
}

rm -rf ../build/*
for cnn in "${CHANNELS[@]}"; do
  #配置渠道资源
  echo 'package' $cnn 'now...'

  if [ "$cnn"x != "$DEFAULT_CNN"x ]; then
    cutomResource4Channel $cnn
  fi
  sleep 1.5
  
  #开始真正打包
  cd ../
  #此项需要解锁登录keychain中的私有秘钥访问权限
  security unlock-keychain -p ${LOGIN_PASSWORD} ${LOGIN_KEYCHAIN}
  exitWithErrMsg 'debug'
  xcodebuild clean
  xcodebuild -workspace $PROJECTNAME.xcworkspace -scheme $PROJECTNAME -configuration $configuration CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" -archivePath build/$PROJECTNAME.xcarchive clean archive PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${BundleID}"
  echo 'build结束 开始导出'
  DATE=$(date +%Y.%m.%d.%H.%M)
  xcodebuild -exportArchive -archivePath build/$PROJECTNAME.xcarchive -exportPath $BUILD_DIR/ -exportOptionsPlist $PROJECTNAME/$SOURCEDIR/$ExportOptionsPlist
  mv $BUILD_DIR/"$PROJECTNAME.ipa" $BUILD_DIR/${PROJECTNAME}_C${cnn}_V${SCHEMEVERSION}_B${SCHEMEBUILD}_D${DATE}.ipa
  zip -r $BUILD_DIR/${PROJECTNAME}_C${cnn}_V${SCHEMEVERSION}_B${SCHEMEBUILD}.dsym.zip build/${PROJECTNAME}.xcarchive/dSYMs/${PROJECTNAME}.app.DSYM
  cd $CMDDIR
done
open $BUILD_DIR

echo '->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>打包完毕 恢复默认状态'
resetDefaultConfigure
