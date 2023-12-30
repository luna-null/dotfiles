#! /bin/bash

# cd to current path
dirname=`dirname $0`
tmp="${dirname#?}"
if [ "${dirname%$tmp}" != "/" ]; then
	dirname=$PWD/$dirname
fi
echo $dirname
cd "$dirname"

# close driver if it running
AppDir=ugeeTablet

#Copy rule
sysRuleDir="/lib/udev/rules.d"
appRuleDir=./App$sysRuleDir
ruleName="ugee4-1.rules"

if [ ! -d "/lib/udev/rules.d" ]; then
	mkdir /lib/udev/rules.d
fi

#echo "$appRuleDir/$ruleName"
#echo "$sysRuleDir/$ruleName"

if [ -f $appRuleDir/$ruleName ]; then
	str=`cp $appRuleDir/$ruleName $sysRuleDir/$ruleName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's rules in package"
	exit
fi

#install app
sysAppDir="/usr/lib"
appAppDir=./App$sysAppDir/$AppDir

#echo $sysAppDir
#echo $appAppDir

if [ -d "$appAppDir" ]; then
	str=`cp -rf $appAppDir $sysAppDir`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's files in package"
	exit
fi

# install shortcut
sysDesktopDir=/usr/share/applications
sysAppIconDir=/usr/share/icons/hicolor/256x256/apps
sysAutoStartDir=/etc/xdg/autostart

appDesktopDir=./App$sysDesktopDir
appAppIconDir=./App$sysAppIconDir
appAutoStartDir=./App$sysAutoStartDir

appDesktopName=ugeetablet.desktop
appIconName=ugeetablet.png


#echo $appDesktopDir/$appDesktopName
#echo $sysDesktopDir/$appDesktopName
#echo $appAppIconDir/$appIconName
#echo $sysAppIconDir/$appIconName

if [ -f $appDesktopDir/$appDesktopName ]; then
	str=`cp $appDesktopDir/$appDesktopName $sysDesktopDir/$appDesktopName`
	chmod +0555 $sysDesktopDir/$appDesktopName
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's shortcut in package"
	exit
fi

if [ -f $appAppIconDir/$appIconName ]; then
	str=`cp $appAppIconDir/$appIconName $sysAppIconDir/$appIconName`
	chmod +0555 $sysAppIconDir/$appIconName
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's icon in package"
	exit
fi

#if [ -f $appAutoStartDir/$appDesktopName ]; then
#	str=`cp $appAutoStartDir/$appDesktopName $sysAutoStartDir/$appDesktopName`
#	chmod +0444 $sysAutoStartDir/$appDesktopName
#	if [ "$str" !=  "" ]; then 
#		echo "$str";
#	fi
#else
#	echo "Cannot find set auto start"
#fi

#Copy config files
chmod +0555 /usr/lib/ugeeTablet/ugeeTablet
chmod +0555 /usr/lib/ugeeTablet/ugeeTabletDriver.sh
chmod +0555 /usr/lib/ugeeTablet/ugeeTabletDriver
confPath="/usr/lib/ugeeTablet/conf"

chmod +0777 $confPath

if [ -f $confPath/Ugee_Tablet.xml ]; then
	chmod +0666 $confPath/Ugee_Tablet.xml
fi

if [ -f $confPath/language.ini ]; then
	chmod +0666 $confPath/language.ini
fi

if [ -f $confPath/name_config.ini ]; then
	chmod +0666 $confPath/name_config.ini
fi

if [ -f /usr/lib/ugeeTablet/resource.rcc ]; then
	chmod +0666 /usr/lib/ugeeTablet/resource.rcc
fi

echo "Installation successful!"
echo "If you are installing for the first time, please use it after restart."
