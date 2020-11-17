@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：卸载安卓应用
@rem 插件版本：0.0.1
@rem 插件描述：在 onCoreStart 生命周期启动特定的安卓组件
@rem 生命周期：onScriptFirstStart、onCoreStart
@rem 插件功能：
@rem	1、根据配置文件（.\uninstall_android_application\package_list.txt）
@rem        卸载相应安卓应用程序，如果配置文件不存在将生成一个
@rem ---------------------------------------------------------------------
@rem 注：以后将使用传输号代替序列号识别不同设备
@rem ---------------------------------------------------------------------
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
if "%~n2"=="opt" goto opt
if "%~2"=="createNewPackageListFile" goto createNewPackageListFile
if "%~2"=="init_package_list" goto init_package_list
if "%~2"=="unstallApp" goto uninstallApp
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
        @rem 要卸载的安卓应用
        set uninstall_android_application_uninstall_list=null
        @rem 在这里解析配置文件，如果配置文件不存在则新建配置文件
        if not exist "%~dp0uninstall_android_application" mkdir %~dp0uninstall_android_application
        if not exist "%~dp0uninstall_android_application\package_list.txt" call "%~f0" boolean createNewPackageListFile
        call "%~f0" boolean init_package_list
        if "!boolean!"=="false" (
            echo 解析配置文件 .\uninstall_android_application\package_list.txt 失败
        )
    )
    if "%~3"=="onCoreStart" (
        @rem 卸载应用
        call %~nx0 void unstallApp "%~5"
    )
goto eof


@rem 创建新的 package_list.txt 文件
@rem 
@rem return boolean true 表示成功创建文件，false 表示创建文件失败
:createNewPackageListFile
    echo ###################################################################################### 1>%~dp0uninstall_android_application\package_list.txt
    echo # 1、在这里写入安卓应用包名列表                                                          1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo #   #表示要卸载 com.android.xxx 这个应用                                                1>%~dp0uninstall_android_application\package_list.txt
    echo #   :uninstall                                                                         1>%~dp0uninstall_android_application\package_list.txt
    echo #   com.android.xxx                                                                    1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo # 注：com.android.xxx 是包名                                                            1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo ###################################################################################### 1>%~dp0uninstall_android_application\package_list.txt
    echo :uninstall                                                                             1>%~dp0uninstall_android_application\package_list.txt
    echo .                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    set %~1=true
goto eof

@rem 解析 .\uninstall_android_application\package_list.txt 文件
@rem
@rem return boolean true 表示成功解析，false 表示解析失败
:init_package_list
    echo 正在解析  .\uninstall_android_application\package_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0uninstall_android_application\package_list.txt) do (
        @rem 开始读取配置文件的内容
        set tmp_string_1=%%~l
        set tmp_string_3=!tmp_string_1:~0,1!
        if "!tmp_string_3!"==":" (
            @rem 标签行
            set result=false
            set tmp_string_2=!tmp_string_1:~1!
            echo 解析到配置标签 !tmp_string_2!
            if "!tmp_string_2!"=="uninstall" set result=true
            if "!result!"=="false" (
                echo .
                echo 解析到错误的配置标签 !tmp_string_1!
                echo 请检查配置文件 .\uninstall_android_application\package_list.txt
                echo .
                echo 脚本将停止解析配置文件并退出
                goto init_package_list_1
            )
        ) else (
            @rem 配置行
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="uninstall" (
                        @rem 解析要卸载的应用
                        if "!uninstall_android_application_uninstall_list!" neq "null" (
                            set uninstall_android_application_uninstall_list=!uninstall_android_application_uninstall_list!,"!tmp_string_1!"
                        ) else (
                            set uninstall_android_application_uninstall_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo 检测到 !tmp_string_2! 未配置在 uninstall 标签下，
                    echo 脚本将停止解析配置文件并退出
                    goto init_package_list_1
                )
            )
        )
    )
    :init_package_list_1
    set %~1=!result!
goto eof

@rem 卸载配置的应用程序
@rem
@rem param_3 传输号
@rem return void
:startService
    if "!uninstall_android_application_uninstall_list!" neq "null" (
        for %%p in (!uninstall_android_application_uninstall_list!) do (
            adb.exe -t %~3 uninstall %%p
        )
    )
goto eof

:eof