@echo off
@rem p3 fu zhu sheng ji
@rem 当前插件注册在如下生命周期里：onCoreStart
if "%~2"=="" (
	setlocal enabledelayedexpansion
)
if "%~2"=="opt" goto opt
goto eof

@rem return boolean
@rem param_3 life cycle name
@rem param_4 serial number
:opt
	if "%~3"=="onCoreStart" (
		adb.exe -s %~4 shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
		adb.exe -s %~4 shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:0
		adb.exe -s %~4 shell am force-stop com.android.settings
		adb.exe -s %~4 shell am start -n com.android.settings/com.android.settings.Settings
		adb.exe -s %~4 shell input touchscreen tap 300 1750 
		adb.exe -s %~4 shell input touchscreen tap 557 1140 
		adb.exe -s %~4 shell input touchscreen tap 186 1100 
		adb.exe -s %~4 shell input touchscreen tap 92 180 
		adb.exe -s %~4 shell input touchscreen swipe 300 1840 300 0 150
		adb.exe -s %~4 shell input touchscreen tap 520 1772 
		adb.exe -s %~4 shell input touchscreen tap 490 490 
		adb.exe -s %~4 shell input touchscreen tap 1011 181 
		adb.exe -s %~4 shell input touchscreen tap 1011 181 
		adb.exe -s %~4 shell input touchscreen tap 159 1136 
		adb.exe -s %~4 shell input touchscreen tap 858 1138 
		choice /d y /t 3 /n 1>nul
		adb.exe -s %~4 shell input touchscreen swipe 530 1000 530 1600 150
		adb.exe -s %~4 shell input touchscreen tap 946 568 
		adb.exe -s %~4 shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1
	)
goto eof

:eof