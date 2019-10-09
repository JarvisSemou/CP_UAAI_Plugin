@echo off
@rem 插件名称：修复微信后缀
@rem 插件版本：0.0.1
@rem 插件描述：因为用微信传输 apk 文件时，微信会自动加 .1 后缀导致应用无法被 adb 安装，当前插件用来解决这个问题
@rem 当前插件注册在如下生命周期里：onScriptFirstStart
@rem 插件功能：
@rem 	1、此插件将修改 apk 目录下 .1 后缀的文件为 .apk 后缀，即使原本的文件不是 apk 文件
@rem
if "%~n2"=="" ( 
	setlocal enabledelayedexpansion
	goto opt
)
if "%~n2"=="opt" goto opt
goto eof

@rem return void
@rem param_3 周期名字
@rem param_4 序列号
:opt 
	if "%~3"=="onScriptFirstStart" (
		echo 开始执行微信后缀修复
		for %%t in (.\app\*.1) do (
			echo 正在修复 "%%~fnxt" 文件
			if not exist "%%~dpnt" (
				rename "%%~fnxt" "%%~nt"
				echo 已将 "%%~fnxt" 修复为 "%%~nt"
			) else (
				echo "%%~nt" 文件已存在，未将 "%%~fnxt" 修复为 "%%~nt"
			)
		)
	)
	pause
goto eof

:eof