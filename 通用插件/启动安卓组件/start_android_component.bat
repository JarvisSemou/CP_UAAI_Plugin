@echo off
chcp 65001 1>nul
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：安卓组件启动插件
@rem 插件版本：0.0.2
@rem 插件描述：在 onCoreLogicFinish 生命周期启动特定的安卓组件
@rem 生命周期：onScriptFirstStart、onCoreLogicFinish
@rem 插件功能：
@rem	1、根据配置文件（.\start_android_component\component_list.txt）启动
@rem		相应的安卓组件，配置方式请看配置文件。如果配置文件不存在则新建一个
@rem		配置文件。
@rem ---------------------------------------------------------------------
@rem 注：以后将使用传输号代替序列号识别不同设备
@rem ---------------------------------------------------------------------
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
if "%~n2"=="opt" goto opt
if "%~2"=="createNewComponentListFile" goto createNewComponentListFile
if "%~2"=="createNewConfigFile" goto createNewConfigFile
if "%~2"=="init_config" goto init_config
if "%~2"=="init_component_list" goto init_component_list
if "%~2"=="startService" goto startService
if "%~2"=="startActivity" goto startActivity
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
        @rem 是否先启动 service 再启动 activity。true 为先启动服务，false 反之，默认为 true
        set start_android_component_isRunServiceFirst=true
        @rem 等待 Activity 和 Service 启动的时间，等待超时之后再继续执行脚本，时间单位为秒,默认为 2 秒
        set start_android_component_waitForSecond=2
        @rem 要启动的 activity 列表
        set start_android_component_activities_list=null
        @rem 要启动的 service 列表
        set start_android_component_services_list=null
        @rem 在这里解析配置文件，如果配置文件不存在则新建配置文件
        if not exist "%~dp0start_android_component" mkdir %~dp0start_android_component
        if not exist "%~dp0start_android_component\config.txt" call "%~f0" boolean createNewConfigFile
        if not exist "%~dp0start_android_component\component_list.txt" call "%~f0" boolean createNewComponentListFile
        call "%~f0" boolean init_config
        if "!boolean!"=="false" (
            echo 读取配置文件 .\start_android_component\config.txt 失败，将使用默认值
        )
        call "%~f0" boolean init_component_list
        if "!boolean!"=="false" (
            echo 解析配置文件 .\start_android_component\component_list.txt 失败
        )
    )
    if "%~3"=="onCoreLogicFinish" (
        @rem 启动 service 和 activity
        if "!start_android_component_isRunServiceFirst!"=="true" (
            call %~nx0 void startService "%~5"
            call %~nx0 void startActivity "%~5"
        ) else (
            call %~nx0 void startActivity "%~5"
            call %~nx0 void startService "%~5"
        )
    )
goto eof


@rem 创建新的 component_list.txt 文件
@rem 
@rem return boolean true 表示成功创建文件，false 表示创建文件失败
:createNewComponentListFile
    echo ###################################################################################### 1>%~dp0start_android_component\component_list.txt
    echo # 1、在这里写入安卓组件列表，如果要启动 Activity 则将组件写在 :activities 下，             1>>%~dp0start_android_component\component_list.txt
    echo #   如果要启动 Service 则写在 :services 下，例如：                                       1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   # 表示要启动 com.android.xxx/.MainActivity 这个 Activity                            1>>%~dp0start_android_component\component_list.txt
    echo #   :activities                                                                        1>>%~dp0start_android_component\component_list.txt
    echo #   com.android.xxx/.MainActivity                                                      1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   # 表示要启动 com.android.xxx/.SomeService 这个 Service                              1>>%~dp0start_android_component\component_list.txt
    echo #   :services                                                                          1>>%~dp0start_android_component\component_list.txt
    echo #   com.android.xxx/.SomeService                                                       1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo # 注：com.android.xxx 是包名，.MainActivity 和 .SomeService 省略包名后的具体的安卓组件     1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo # 2、这这里里面配置的安卓组件将被安卓的 am 命令调用                                        1>>%~dp0start_android_component\component_list.txt
    echo #   Activity 的调用格式如下：                                                            1>>%~dp0start_android_component\component_list.txt
    echo #       am  start  -n  com.android.xxx/.MainActivity                                   1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   Service 的调用格式如下：                                                             1>>%~dp0start_android_component\component_list.txt
    echo #       am  startservice  -n  com.android.xxx/.SomeService                             1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo ###################################################################################### 1>>%~dp0start_android_component\component_list.txt
    echo :activities 1>>%~dp0start_android_component\component_list.txt
    echo.>>%~dp0start_android_component\component_list.txt
    echo :services 1>>%~dp0start_android_component\component_list.txt
    echo.>>%~dp0start_android_component\component_list.txt
    echo.>>%~dp0start_android_component\component_list.txt
	set %~1=true
goto eof

@rem 创建新的 config.txt 文件
@rem 
@rem return boolean true 表示成功创建文件，false 表示创建文件失败
:createNewConfigFile
    echo # 是否先启动服务。true 为先启动服务，false 为先启动 activity ，默认为 true 1>>%~dp0start_android_component\config.txt
    echo isRunServiceFirst=true 1>>%~dp0start_android_component\config.txt
    echo.>>%~dp0start_android_component\config.txt
    echo #等待 Activity 和 Service 启动的时间，等待超时之后再继续执行脚本，时间单位为秒,默认为 2 秒 1>>%~dp0start_android_component\config.txt
    echo waitForSecond=2 1>>%~dp0start_android_component\config.txt
	set %~1=true
goto eof

@rem 解析 .\start_android_component\config.txt 文件
@rem
@rem return boolean true 表示成功解析，false 表示解析失败
:init_config
    echo 正在解析 config.txt 
    set result=false
    for /f "eol=# tokens=1,2 delims== " %%l in (%~dp0start_android_component\config.txt) do (
        @rem 开始读取配置文件的内容
        echo 找到配置项：%%~l，配置结果：%%~l = %%~m
        if "%%~l"=="isRunServiceFirst" set start_android_component_isRunServiceFirst=%%~m
        if "%%~l"=="waitForSecond" set start_android_component_waitForSecond=%%~m
        set result=true
    )
    set %~1=!result!
goto eof

@rem 解析 .\start_android_component\component_list.txt 文件
@rem
@rem return boolean true 表示成功解析，false 表示解析失败
:init_component_list
    echo 正在解析  .\start_android_component\component_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0start_android_component\component_list.txt) do (
        @rem 开始读取配置文件的内容
        set tmp_string_1=%%~l
        set tmp_string_3=!tmp_string_1:~0,1!
        if "!tmp_string_3!"==":" (
            @rem 标签行
            set result=false
            set tmp_string_2=!tmp_string_1:~1!
            echo 解析到配置标签 !tmp_string_2!
            if "!tmp_string_2!"=="activities" set result=true
            if "!tmp_string_2!"=="services" set result=true
            if "!result!"=="false" (
                echo .
                echo 解析到错误的配置标签 !tmp_string_1!
                echo 请检查配置文件 .\start_android_component\component_list.txt
                echo .
                echo 脚本将停止解析配置文件并退出
                goto init_component_list_1
            )
        ) else (
            @rem 配置行
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="activities" (
                        @rem 要启动的是 activity
                        if "!start_android_component_activities_list!" neq "null" (
                            set start_android_component_activities_list=!start_android_component_activities_list!,"!tmp_string_1!"
                        ) else (
                            set start_android_component_activities_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="services" (
                        @rem 要启动的是 service
                        if "!start_android_component_services_list!" neq "null" (
                            set start_android_component_services_list=!start_android_component_services_list!,"!tmp_string_1!"
                        ) else (
                            set start_android_component_services_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo 检测到 !tmp_string_2! 未配置在 activities 或 services 标签下，
                    echo 脚本将停止解析配置文件并退出
                    goto init_component_list_1
                )
            )
        )
    )
    :init_component_list_1
    set %~1=!result!
goto eof

@rem 启动配置的 activity
@rem
@rem param_3 传输号
@rem return void
:startActivity
    if "!start_android_component_activities_list!" neq "null" (
        for %%c in (!start_android_component_activities_list!) do (
            adb.exe -t %~3 shell am start -n %%~c
            choice /d y /t !start_android_component_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem 启动配置的 service
@rem
@rem param_3 传输号
@rem return void
:startService
    if "!start_android_component_services_list!" neq "null" (
        for %%c in (!start_android_component_services_list!) do (
            adb.exe -t %~3 shell am startservice -n %%~c
            choice /d y /t !start_android_component_waitForSecond! /n 1>nul
        )
    )
goto eof

:eof