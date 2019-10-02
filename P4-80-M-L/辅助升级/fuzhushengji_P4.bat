@echo off
@rem p4 fu zhu sheng ji
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
		adb.exe -s %~4 shell input touchscreen tap 200 876 
		adb.exe -s %~4 shell input touchscreen tap 155 750 
		adb.exe -s %~4 shell input touchscreen tap 120 1012 
		adb.exe -s %~4 shell input touchscreen tap 81 126 
		adb.exe -s %~4 shell input touchscreen swipe 300 1740 300 0 150
		adb.exe -s %~4 shell input touchscreen tap 878 1735 
		adb.exe -s %~4 shell input touchscreen tap 260 323 
		adb.exe -s %~4 shell input touchscreen tap 1840 111
		adb.exe -s %~4 shell input touchscreen tap 1840 111
		adb.exe -s %~4 shell input touchscreen tap 170 782
		adb.exe -s %~4 shell input touchscreen tap 1350 673
		choice /d y /t 3 /n 1>nul
		adb.exe -s %~4 shell input touchscreen tap 1830 366 
		adb.exe -s %~4 shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1
	)
goto eof

:eof