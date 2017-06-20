#!/bin/bash

CMDDIR='PackageCmd'
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


# APKPATH='build/outputs/apks/MXT_LNYD_Android_V5.1.0.2324.apk'
# echo '打包完毕！'
# echo '##########################################################################################################'
# echo '准备加固 准备.......'
# cd $ROOTDIR

# chmod a+x $CMDDIR/$JIAGUDIR/java/bin/*

# JIAGU_PRE_CMD="java -jar $CMDDIR/$JIAGUDIR/${JIAGUDIR}.jar"
# $JIAGU_PRE_CMD -login $JIAGUACCOUNT $JIAGUPWD
# $JIAGU_PRE_CMD -importsign $CMDDIR/$KEYSTOREFILE $KEYSTOREPWD $KEYSTOREALIAS $KEYSTOREPWD
# $JIAGU_PRE_CMD -jiagu $APKPATH "build/outputs/apks" -autosign

# cd $ROOTDIR
# MappingPath=$BUILDDIR/$OUTPUTSDIR/mapping/LNYD/release
# MAPPINGFILE="MXT_Mapping_LNYD_V5.1.0_B2325.zip"
# echo 'mapping file' $MappingPath 'now...'
# zip -qj $MAPDIRPATH/$MAPPINGFILE $MappingPath/mapping.txt

# cd $PackageCmd

open $(PWD)/../build/outputs/apks