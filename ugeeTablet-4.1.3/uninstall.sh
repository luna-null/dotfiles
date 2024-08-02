#! /bin/bash

AppName=ugeeTablet
AppDir=ugeeTablet

#uninstall app
sysAppDir=/usr/lib/ugeeTablet
if [ -d "$sysAppDir" ]; then
	str=`rm -rf $sysAppDir`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi


#uninstall shortcut
sysDesktopDir=/usr/share/applications
sysAppIconDir=/usr/share/icons/hicolor/256x256/apps
sysAutoStartDir=/etc/xdg/autostart

appDesktopName=ugeetablet.desktop
appIconName=ugeetablet.png
if [ -f "$sysDesktopDir/$appDesktopName" ]; then
	str=`rm $sysDesktopDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAppIconDir/$appIconName ]; then
	str=`rm $sysAppIconDir/$appIconName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAutoStartDir/$appDesktopName ]; then
	str=`rm $sysAutoStartDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

#uninstall hid permission
sysRuleFile=/lib/udev/rules.d/ugee4-1.rules
if [ -f $sysRuleFile ]; then
	str=`rm $sysRuleFile`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

echo "Uninstall succeeded."

