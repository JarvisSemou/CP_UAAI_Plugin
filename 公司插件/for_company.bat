@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.3													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.12													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：公司插件
@rem 插件版本：0.0.1
@rem 生命周期：onPushFileCompleted、onCoreLogicFinish
@rem 插件功能：
@rem 	1、将部分与设备相关的信息导入设备
@rem ---------------------------------------------------------------------
@rem 注：以后将使用传输号代替序列号识别不同设备
@rem ---------------------------------------------------------------------
if "%~n2"=="" ( 
	setlocal enabledelayedexpansion
	goto opt
)
if "%~n2"=="opt" goto opt
goto eof

@rem 生命周期回调接口
@rem
@rem return boolean
@rem param_3 string 周期名字
@rem param_4 string 序列号
@rem param_5 int	传输号
@rem param_6 string 文件的绝对路径
:opt 
	if "%~3"=="onPushFileCompleted" (
        if exist ".\files\Deviceinfo-enc" (
            @rem 推送设备信息到设备
            adb.exe -t %~5 shell mkdir /sdcard/Android/data/com.thinta.ZZMinTechService
            adb.exe -t %~5 shell mkdir /sdcard/Android/data/com.thinta.ZZMinTechService/cache
            adb.exe -t %~5 push .\files\Deviceinfo-enc  /sdcard/Android/data/com.thinta.ZZMinTechService/cache/Deviceinfo-enc
            adb.exe -t %~5 push .\files\Deviceinfo-enc  /sdcard/BackUp/com.thinta.ZZMinTechService/files/Deviceinfo-enc
        )
    )
    if "%~3"=="onCoreLogicFinish" (
        @rem 在这里配置启动项

        @rem 重启应用设备信息
        adb.exe -t %~5 shell reboot
    )
goto eof

:eof