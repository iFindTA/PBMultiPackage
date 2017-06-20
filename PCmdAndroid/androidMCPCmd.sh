#!/bin/bash

##########################################################################################################
# @Author: nanhujiaju@gmail.com @Date: 2017.6.19 @Version: 1.1.0
##########################################################################################################

#vars
CMDDIR='PCmdAndroid'
ROOTDIR='../'
BUILDDIR='build'
OUTPUTSDIR='outputs'
APKSDIRNAME='apks'
APKSDIRPATH=$BUILDDIR/$OUTPUTSDIR/$APKSDIRNAME
JIAGUDIRNAME='jiagu'
JIAGUAPKSDIRPATH=$BUILDDIR/$OUTPUTSDIR/$APKSDIRNAME/$JIAGUDIRNAME
MAPDIRPATH=$BUILDDIR/$OUTPUTSDIR/$APKSDIRNAME/maps
DEFAULT_CNN='native'
declare -a CHANNELS=($DEFAULT_CNN)
FULL_PLATFORMS=('NATIVE', 'LNYD', 'SYJCY', 'RZSW')
declare -a PACKSETS
KEYSTOREFILE='flk.keystore'
KEYSTOREALIAS='ssmszjyd'
KEYSTOREPWD='comlinkjane'
Configuration='Release'
JIAGUACCOUNT='flkdeveloper'
JIAGUPWD='flkdev@123456'

function dirExist() {
  if [[ ! -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}

# exit when occured error in progress!
function exitWithErrMsg() {
  	echo "could not continue cause of an error:" $1
  	exit 1
}

echo '##########################################################################################################'
echo '解析参数.....'
PARAM_COUNT=$#
#echo $PARAM_COUNT
if [[ $PARAM_COUNT == 0 ]]; then
	exitWithErrMsg 'empty params!'
fi

function containsCnn() {
	tmpObj=$1
	if [[ "${FULL_PLATFORMS[*]}" == *"${tmpObj}"* ]]; then
		#statements
		return 1
	else
		return 0
	fi
}

idx=0
for tmpCnn in $@; do
	#echo 'cnn:' $tmpCnn 
	containsCnn $tmpCnn
	if [[ $? = 1 ]]; then
		#statements
		PACKSETS[idx]=$tmpCnn
		idx=`expr $idx + 1`
	fi
done

echo "可有效打包的渠道:" ${PACKSETS[@]}
if [[ ${#CHANNELS[@]} == 0 ]]; then
	exitWithErrMsg 'empty params!'
fi

cd $ROOTDIR
MANIFEST_FILE='AndroidManifest.xml'
MANIFEST_TMP_FILE='AndroidManifest.xml.tmp'
chmod a+x $MANIFEST_FILE
VERSION_CODE=`grep versionCode $MANIFEST_FILE | sed -e 's/.*versionCode\s*=\s*\"\([0-9.]*\)\".*/\1/g' | cut -d\" -f2`
echo "version code is: $VERSION_CODE"
VERSION_NAME=`grep versionName $MANIFEST_FILE | sed -e 's/.*versionName\s*=\s*\"\([0-9.]*\)\".*/\1/g' | cut -d\" -f2`
echo "version name is: $VERSION_NAME"
#NEW_VERSION=$((VERSION_CODE+1))
#cat $MANIFEST_FILE  | sed 's/versionCode="'${VERSION_CODE}'"/versionCode="'${NEW_VERSION}'"/g' > $MANIFEST_TMP_FILE
#mv -f $MANIFEST_TMP_FILE $MANIFEST_FILE

echo '##########################################################################################################'
echo '准备打包 clean......'
rm -rf *.apk
gradle clean
chmod a+x $CMDDIR/$JIAGUDIRNAME/java/bin/*

build_cmd=''
for cnn in "${PACKSETS[@]}"; do
	#statements
	#配置渠道资源
  	echo 'packaging' $cnn 'now...'
  	build_cmd="assemble${cnn}${Configuration}"

  	sleep 1.5

  	gradle $build_cmd
  	#exitWithErrMsg 'build'
done


echo '打包完毕！'
echo '##########################################################################################################'
echo '加固准备中.......'

echo 'deleting old jiagu-apks......'
dirExist $JIAGUAPKSDIRPATH
if [[ $? = 1 ]]; then
	#statements
	echo '删除文件...'
	rm -rf $JIAGUAPKSDIRPATH/*.apk
else
	echo '创建文件夹'
	mkdir $JIAGUAPKSDIRPATH
fi

echo '开始加固......'
APKNAME=''
APKPATH=''
#APKPATH='build/outputs/apks/MXT_LNYD_Android_V5.1.0.2324.apk'
JIAGU_PRE_CMD="java -jar $CMDDIR/$JIAGUDIRNAME/${JIAGUDIRNAME}.jar"
$JIAGU_PRE_CMD -login $JIAGUACCOUNT $JIAGUPWD
$JIAGU_PRE_CMD -importsign $CMDDIR/$KEYSTOREFILE $KEYSTOREPWD $KEYSTOREALIAS $KEYSTOREPWD
for cnn in "${PACKSETS[@]}"; do
	#statements
	#配置渠道资源
	APKNAME="MXT_${cnn}_Android_V${VERSION_NAME}.${VERSION_CODE}.apk"
  	echo 'jiagu' $APKNAME 'now...'
  	APKPATH=$APKSDIRPATH/$APKNAME

  	sleep 1.5

  	$JIAGU_PRE_CMD -jiagu $APKPATH $JIAGUAPKSDIRPATH -autosign
  	sleep 2
done

echo '加固完毕！'

echo '##########################################################################################################'
echo 'mapping文件准备中.......'

echo 'deleting old jiagu-apks......'
dirExist $MAPDIRPATH
if [[ $? = 1 ]]; then
	#statements
	rm -rf $MAPDIRPATH/*
else
	mkdir $MAPDIRPATH
fi

MappingPath=''
MAPPINGFILE=''
cfg=$(echo $Configuration | tr '[A-Z]' '[a-z]')
for cnn in "${PACKSETS[@]}"; do
	#statements
	#配置渠道资源
	MappingPath=$BUILDDIR/$OUTPUTSDIR/mapping/$cnn/$cfg
	MAPPINGFILE="MXT_Mapping_${cnn}_V${VERSION_NAME}_B${VERSION_CODE}.zip"
  	echo 'mapping file' $MappingPath 'now...'
  	zip -qj $MAPDIRPATH/$MAPPINGFILE $MappingPath/mapping.txt
  	#mv -f $MappingPath/$MAPPINGFILE $MAPDIRPATH
done

echo 'zip mapping files done!'

echo '##########################################################################################################'
echo 'upgrading build code now.......'
NEW_VERSION=$((VERSION_CODE+1))
cat $MANIFEST_FILE  | sed 's/versionCode="'${VERSION_CODE}'"/versionCode="'${NEW_VERSION}'"/g' > $MANIFEST_TMP_FILE
mv -f $MANIFEST_TMP_FILE $MANIFEST_FILE
cd $PackageCmd

open $(PWD)/../$APKSDIRPATH

