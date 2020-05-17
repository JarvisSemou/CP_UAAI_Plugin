@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：修复微信后缀
@rem 插件版本：0.0.2
@rem 插件描述：因为用微信传输 apk 文件时，微信会自动加 .1 后缀导致应用无法被 adb 安装，
@rem 当前插件用来解决这个问题.
@rem 生命周期：onScriptFirstStart
@rem 插件功能：
@rem 	1、此插件将修改 apk 目录下 .1 后缀的文件为 .apk 后缀，即使原本的文件不是 apk 文件
@rem
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
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
goto eof

:eof