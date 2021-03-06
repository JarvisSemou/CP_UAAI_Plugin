@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：普华证书导入插件
@rem 插件版本：0.0.3
@rem 生命周期：onCoreStart
@rem 插件功能：
@rem 	1、控制是否清除普华客户端的软件数据
@rem	2、是否导入新证书。证书的默认导入方式为导入同一张证书；
@rem 		另一种为导入方式为逐一导入当前目录下的 ceitsas 目录下的证书，并删除已导入的证书
@rem	3、控制是否在安装新普华客户端前卸载旧普华客户端
@rem ---------------------------------------------------------------------
@rem 注：以后将使用传输号代替序列号识别不同设备
@rem ---------------------------------------------------------------------
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
	@rem 包名列表 -------------------------------
	@rem com.sgit.vpn
	@rem de.blinkt.openvpn
	@rem ----------------------------------------
	@rem 常量配置 -------------------------------
	@rem 控制是否在安装新客户端前卸载旧客户端，true 为在安装新客户端前卸载旧客户端，false 反之
	set UNINSTALL_OLD_WHEN_INSTALL_NEW=false
	@rem 普华旧安全客户端包名
	set OLD_PUHUA_VPN_PACKAGE=null
	@rem 普华新安全客户端包名
	set NEW_PUHUA_VPN_PACKAGE=null
	@rem 是否清除普华客户端数据，true 为清除安全客户端数据，false 反之
	set CLEAN_PUHUA_VPN_DATA=false
	@rem 普华证书存放目录
	set PUHUA_CEITSA_FLODER=%~dp0ceitsas
	@rem 临时目录
	set PUHUA_CEITSA_TMP_FLODER=!PUHUA_CEITSA_FLODER!\tmp
	@rem 是否安装普华证书，true 为安装，false 反之
	set INSTALL_PUHUA_CEITSA=false
	@rem 安装普华证书的方式，REPEAT 为重复安装，NOT_REPEAT 为不重复安装，默认为 REPEAT
	set INSTALL_PUHUA_CEITSA_MODE=REPEAT
	@rem ----------------------------------------
	@rem 这里开始写正式插件代码
	if "%~3"=="onCoreStart" (
		if "!UNINSTALL_OLD_WHEN_INSTALL_NEW!"=="true" (
			adb.exe -t %~5 uninstall !OLD_PUHUA_VPN_PACKAGE!
		)
		if "!CLEAN_PUHUA_VPN_DATA!"=="true" (
			adb.exe -t %~5 shell pm clear !OLD_PUHUA_VPN_PACKAGE!
		)
		if "!INSTALL_PUHUA_CEITSA!"=="true" (
			if exist "!PUHUA_CEITSA_FLODER!" (
				if exist "!PUHUA_CEITSA_FLODER!\*.conf" (
					adb.exe -t %~5 shell rm -rf /sdcard/ceitsa
					adb.exe -t %~5 shell mkdir /sdcard/ceitsa
					if "!INSTALL_PUHUA_CEITSA_MODE!"=="NOT_REPEAT" (
						if not exist "!PUHUA_CEITSA_TMP_FLODER!" (
							md !PUHUA_CEITSA_TMP_FLODER!
						)
						for %%t in (!PUHUA_CEITSA_FLODER!\*.conf) do (
							echo 开始导入证书：%%t
							move %%t !PUHUA_CEITSA_TMP_FLODER!\%%~nxt
							adb.exe -t %~5 push "!PUHUA_CEITSA_TMP_FLODER!\%%~nxt" /sdcard/ceitsa/%%~nxt
							del /f /q "!PUHUA_CEITSA_TMP_FLODER!\%%~nxt"
							goto opt_l_1
						)
					) else (
						for %%t in (!PUHUA_CEITSA_FLODER!\*.conf) do (
							echo 开始导入证书：%%t
							adb.exe -t %~5 push "!PUHUA_CEITSA_FLODER!\%%~nxt" /sdcard/ceitsa/%%~nxt
							goto opt_l_1
						)
					)
					echo 导入证书完成
				) else (
					echo 找不到证书文件，未开始安装证书
				)
			) else (
				echo  找不到证书所在文件夹 “!PUHUA_CEITSA_FLODER!”，未开始安装证书
			)
		)
	)
	:opt_l_1
goto eof

:eof