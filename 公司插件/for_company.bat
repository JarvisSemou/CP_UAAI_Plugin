@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem 插件名称：公司插件
@rem 插件版本：0.0.2
@rem 生命周期：onScriptFirstStart、onCoreStart、onPushFileCompleted、onCoreLogicFinish
@rem 插件功能：
@rem 	1、将部分与设备相关的信息导入设备
@rem    2、根据配置列表（.\for_company\for_company_component_list.txt）启动安卓组件
@rem        或卸载软件
@rem    3、根据配置文件（.\for_company\for_company_config.txt）判断是否需要重启设备，
@rem        如果配置文件不存在则新建，默认设置为重启设备
@rem ---------------------------------------------------------------------
@rem 注：以后将使用传输号代替序列号识别不同设备
@rem ---------------------------------------------------------------------
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
if "%~n2"=="opt" goto opt
if "%~2"=="createNewComponentListFile" goto createNewComponentListFile
if "%~2"=="createNewConfigFile" goto createNewConfigFile
if "%~2"=="for_company_init_config" goto for_company_init_config
if "%~2"=="for_company_init_component_list" goto for_company_init_component_list
if "%~2"=="startService" goto startService
if "%~2"=="startActivity" goto startActivity
if "%~2"=="uninstallApp" goto uninstallApp
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
        @rem 是否在执行完逻辑后重启。true 为要重启，false 反之，默认为 true
        set for_company_isReboot=true
        @rem 是否先启动 service 再启动 activity。true 为先启动服务，false 反之，默认为 true
        set for_company_isRunServiceFirst=true
        @rem 等待 Activity 和 Service 启动的时间，等待超时之后再继续执行脚本，时间单位为秒,默认为 2 秒
        set for_company_waitForSecond=2
        @rem 要启动的 activity 列表
        set for_company_activities_list=null
        @rem 要启动的 service 列表
        set for_company_services_list=null
        @rem 要卸载的 app 列表
        set for_company_uninstall_list=null
        @rem 在这里解析配置文件，如果配置文件不存在则新建配置文件
        if not exist "%~dp0for_company" mkdir %~dp0for_company
        if not exist "%~dp0for_company\for_company_config.txt" call "%~f0" boolean createNewConfigFile
        if not exist "%~dp0for_company\for_company_component_list.txt" call "%~f0" boolean createNewComponentListFile
        call "%~f0" boolean for_company_init_config
        if "!boolean!"=="false" (
            echo 读取配置文件 .\for_company\for_company_config.txt 失败，将使用默认值
        )
        call "%~f0" boolean for_company_init_component_list
        if "!boolean!"=="false" (
            echo 解析配置文件 .\for_company\for_company_component_list.txt 失败
        )
    )
    if "%~3"=="onCoreStart" (
        @rem 卸载服务
        adb.exe -t %~5 uninstall com.thinta.ZZMinTechService
        call %~nx0 void uninstall "%~5"
    )
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
        @rem 启动 service 和 activity
        if "!for_company_isRunServiceFirst!"=="true" (
            call %~nx0 void startService "%~5"
            call %~nx0 void startActivity "%~5"
        ) else (
            call %~nx0 void startActivity "%~5"
            call %~nx0 void startService "%~5"
        )
        @rem 根据配置重启设备
        if "!for_company_isReboot!"=="true" adb.exe -t %~5 reboot
    )
goto eof


@rem 创建新的 for_company_component_list.txt 文件
@rem 
@rem return boolean true 表示成功创建文件，false 表示创建文件失败
:createNewComponentListFile
    echo ###################################################################################### 1>%~dp0for_company\for_company_component_list.txt
    echo # 1、在这里写入安卓组件列表，如果要启动 Activity 则将组件写在 :activities 下，             1>>%~dp0for_company\for_company_component_list.txt
    echo #   如果要启动 Service 则写在 :services 下，例如：                                       1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   # 表示要启动 com.android.xxx/.MainActivity 这个 Activity                            1>>%~dp0for_company\for_company_component_list.txt
    echo #   :activities                                                                        1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx/.MainActivity                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   # 表示要启动 com.android.xxx/.SomeService 这个 Service                              1>>%~dp0for_company\for_company_component_list.txt
    echo #   :services                                                                          1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx/.SomeService                                                       1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   #表示要卸载 com.android.xxx 这个应用                                                 1>>%~dp0for_company\for_company_component_list.txt
    echo #   :uninstall                                                                         1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx                                                                    1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo # 注：com.android.xxx 是包名，.MainActivity 和 .SomeService 省略包名后的具体的安卓组件     1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo # 2、这这里里面配置的安卓组件将被安卓的 am 命令调用                                        1>>%~dp0for_company\for_company_component_list.txt
    echo #   Activity 的调用格式如下：                                                            1>>%~dp0for_company\for_company_component_list.txt
    echo #       am  start  -n  com.android.xxx/.MainActivity                                   1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   Service 的调用格式如下：                                                             1>>%~dp0for_company\for_company_component_list.txt
    echo #       am  startservice  -n  com.android.xxx/.SomeService                             1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo ###################################################################################### 1>>%~dp0for_company\for_company_component_list.txt
    echo :activities 1>>%~dp0for_company\for_company_component_list.txt
    echo.>>%~dp0for_company\for_company_component_list.txt
    echo :services 1>>%~dp0for_company\for_company_component_list.txt
    echo.>>%~dp0for_company\for_company_component_list.txt
    echo :uninstall 1>>%~dp0for_company\for_company_component_list.txt
    echo.>>%~dp0for_company\for_company_component_list.txt
    echo.>>%~dp0for_company\for_company_component_list.txt
    set %~1=true
goto eof

@rem 创建新的 for_company_config.txt 文件
@rem 
@rem return boolean true 表示成功创建文件，false 表示创建文件失败
:createNewConfigFile
    echo # 执行完公司插件逻辑后，是否重启。true 为重启，false 为不重启，默认为 true 1>%~dp0for_company\for_company_config.txt
    echo isReboot=true 1>>%~dp0for_company\for_company_config.txt
    echo.>>%~dp0for_company\for_company_config.txt
    echo # 是否先启动服务。true 为先启动服务，false 为先启动 activity ，默认为 true 1>>%~dp0for_company\for_company_config.txt
    echo isRunServiceFirst=true 1>>%~dp0for_company\for_company_config.txt
    echo.>>%~dp0for_company\for_company_config.txt
    echo #等待 Activity 和 Service 启动的时间，等待超时之后再继续执行脚本，时间单位为秒,默认为 2 秒 1>>%~dp0for_company\for_company_config.txt
    echo waitForSecond=2 1>>%~dp0for_company\for_company_config.txt
    set %~1=true
goto eof

@rem 解析 .\for_company\for_company_config.txt 文件
@rem
@rem return boolean true 表示成功解析，false 表示解析失败
:for_company_init_config
    echo 正在解析 for_company_config.txt 
    set result=false
    for /f "eol=# tokens=1,2 delims== " %%l in (%~dp0for_company\for_company_config.txt) do (
        @rem 开始读取配置文件的内容
        echo 找到配置项：%%~l，配置结果：%%~l = %%~m
        if "%%~l"=="isReboot" set for_company_isReboot=%%~m
        if "%%~l"=="isRunServiceFirst" set for_company_isRunServiceFirst=%%~m
        if "%%~l"=="waitForSecond" set for_company_waitForSecond=%%~m
        set result=true
    )
    set %~1=!result!
goto eof

@rem 解析 .\for_company\for_company_component_list.txt 文件
@rem
@rem return boolean true 表示成功解析，false 表示解析失败
:for_company_init_component_list
    echo 正在解析  .\for_company\for_company_component_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0for_company\for_company_component_list.txt) do (
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
            if "!tmp_string_2!"=="uninstall" set result=true
            if "!result!"=="false" (
                echo .
                echo 解析到错误的配置标签 !tmp_string_1!
                echo 请检查配置文件 .\for_company\for_company_component_list.txt
                echo .
                echo 脚本将停止解析配置文件并退出
                goto for_company_init_component_list_1
            )
        ) else (
            @rem 配置行
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="activities" (
                        @rem 要启动的是 activity
                        if "!for_company_activities_list!" neq "null" (
                            set for_company_activities_list=!for_company_activities_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_activities_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="services" (
                        @rem 要启动的是 service
                        if "!for_company_services_list!" neq "null" (
                            set for_company_services_list=!for_company_services_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_services_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="uninstall" (
                        @rem 要启动的是 service
                        if "!for_company_uninstall_list!" neq "null" (
                            set for_company_uninstall_list=!for_company_uninstall_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_uninstall_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo 检测到 !tmp_string_2! 未配置在 activities 或 services 或 uninstall 标签下，
                    echo 脚本将停止解析配置文件并退出
                    goto for_company_init_component_list_1
                )
            )
        )
    )
    :for_company_init_component_list_1
    set %~1=!result!
goto eof

@rem 启动配置的 activity
@rem
@rem param_3 传输号
@rem return void
:startActivity
    if "!for_company_activities_list!" neq "null" (
        for %%c in (!for_company_activities_list!) do (
            adb.exe -t %~3 shell am start -n %%~c
            choice /d y /t !for_company_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem 启动配置的 service
@rem
@rem param_3 传输号
@rem return void
:startService
    if "!for_company_services_list!" neq "null" (
        for %%c in (!for_company_services_list!) do (
            adb.exe -t %~3 shell am startservice -n %%~c
            choice /d y /t !for_company_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem 卸载配置的 app
@rem
@rem param_3 传输号
@rem return void
:uninstallApp
    if "!for_company_uninstall_list!" neq "null" (
        for %%p in (!for_company_uninstall_list!) do (
            adb.exe -t %~3 uninstall %%~p
        )
    )
goto eof

:eof