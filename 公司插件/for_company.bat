@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ������ƣ���˾���
@rem ����汾��0.0.2
@rem �������ڣ�onScriptFirstStart��onCoreStart��onPushFileCompleted��onCoreLogicFinish
@rem ������ܣ�
@rem 	1�����������豸��ص���Ϣ�����豸
@rem    2�����������б�.\for_company\for_company_component_list.txt��������׿���
@rem        ��ж�����
@rem    3�����������ļ���.\for_company\for_company_config.txt���ж��Ƿ���Ҫ�����豸��
@rem        ��������ļ����������½���Ĭ������Ϊ�����豸
@rem ---------------------------------------------------------------------
@rem ע���Ժ�ʹ�ô���Ŵ������к�ʶ��ͬ�豸
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

@rem �������ڻص��ӿ�
@rem
@rem return boolean
@rem param_3 string ��������
@rem param_4 string ���к�
@rem param_5 int	�����
@rem param_6 string �ļ��ľ���·��
:opt 
    if "%~3"=="onScriptFirstStart" (
        @rem �Ƿ���ִ�����߼���������true ΪҪ������false ��֮��Ĭ��Ϊ true
        set for_company_isReboot=true
        @rem �Ƿ������� service ������ activity��true Ϊ����������false ��֮��Ĭ��Ϊ true
        set for_company_isRunServiceFirst=true
        @rem �ȴ� Activity �� Service ������ʱ�䣬�ȴ���ʱ֮���ټ���ִ�нű���ʱ�䵥λΪ��,Ĭ��Ϊ 2 ��
        set for_company_waitForSecond=2
        @rem Ҫ������ activity �б�
        set for_company_activities_list=null
        @rem Ҫ������ service �б�
        set for_company_services_list=null
        @rem Ҫж�ص� app �б�
        set for_company_uninstall_list=null
        @rem ��������������ļ�����������ļ����������½������ļ�
        if not exist "%~dp0for_company" mkdir %~dp0for_company
        if not exist "%~dp0for_company\for_company_config.txt" call "%~f0" boolean createNewConfigFile
        if not exist "%~dp0for_company\for_company_component_list.txt" call "%~f0" boolean createNewComponentListFile
        call "%~f0" boolean for_company_init_config
        if "!boolean!"=="false" (
            echo ��ȡ�����ļ� .\for_company\for_company_config.txt ʧ�ܣ���ʹ��Ĭ��ֵ
        )
        call "%~f0" boolean for_company_init_component_list
        if "!boolean!"=="false" (
            echo ���������ļ� .\for_company\for_company_component_list.txt ʧ��
        )
    )
    if "%~3"=="onCoreStart" (
        @rem ж�ط���
        adb.exe -t %~5 uninstall com.thinta.ZZMinTechService
        call %~nx0 void uninstall "%~5"
    )
	if "%~3"=="onPushFileCompleted" (
        if exist ".\files\Deviceinfo-enc" (
            @rem �����豸��Ϣ���豸
            adb.exe -t %~5 shell mkdir /sdcard/Android/data/com.thinta.ZZMinTechService
            adb.exe -t %~5 shell mkdir /sdcard/Android/data/com.thinta.ZZMinTechService/cache
            adb.exe -t %~5 push .\files\Deviceinfo-enc  /sdcard/Android/data/com.thinta.ZZMinTechService/cache/Deviceinfo-enc
            adb.exe -t %~5 push .\files\Deviceinfo-enc  /sdcard/BackUp/com.thinta.ZZMinTechService/files/Deviceinfo-enc
        )
    )
    if "%~3"=="onCoreLogicFinish" (
        @rem ���� service �� activity
        if "!for_company_isRunServiceFirst!"=="true" (
            call %~nx0 void startService "%~5"
            call %~nx0 void startActivity "%~5"
        ) else (
            call %~nx0 void startActivity "%~5"
            call %~nx0 void startService "%~5"
        )
        @rem �������������豸
        if "!for_company_isReboot!"=="true" adb.exe -t %~5 reboot
    )
goto eof


@rem �����µ� for_company_component_list.txt �ļ�
@rem 
@rem return boolean true ��ʾ�ɹ������ļ���false ��ʾ�����ļ�ʧ��
:createNewComponentListFile
    echo ###################################################################################### 1>%~dp0for_company\for_company_component_list.txt
    echo # 1��������д�밲׿����б����Ҫ���� Activity �����д�� :activities �£�             1>>%~dp0for_company\for_company_component_list.txt
    echo #   ���Ҫ���� Service ��д�� :services �£����磺                                       1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   # ��ʾҪ���� com.android.xxx/.MainActivity ��� Activity                            1>>%~dp0for_company\for_company_component_list.txt
    echo #   :activities                                                                        1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx/.MainActivity                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   # ��ʾҪ���� com.android.xxx/.SomeService ��� Service                              1>>%~dp0for_company\for_company_component_list.txt
    echo #   :services                                                                          1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx/.SomeService                                                       1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   #��ʾҪж�� com.android.xxx ���Ӧ��                                                 1>>%~dp0for_company\for_company_component_list.txt
    echo #   :uninstall                                                                         1>>%~dp0for_company\for_company_component_list.txt
    echo #   com.android.xxx                                                                    1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo # ע��com.android.xxx �ǰ�����.MainActivity �� .SomeService ʡ�԰�����ľ���İ�׿���     1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo # 2���������������õİ�׿���������׿�� am �������                                        1>>%~dp0for_company\for_company_component_list.txt
    echo #   Activity �ĵ��ø�ʽ���£�                                                            1>>%~dp0for_company\for_company_component_list.txt
    echo #       am  start  -n  com.android.xxx/.MainActivity                                   1>>%~dp0for_company\for_company_component_list.txt
    echo #                                                                                      1>>%~dp0for_company\for_company_component_list.txt
    echo #   Service �ĵ��ø�ʽ���£�                                                             1>>%~dp0for_company\for_company_component_list.txt
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

@rem �����µ� for_company_config.txt �ļ�
@rem 
@rem return boolean true ��ʾ�ɹ������ļ���false ��ʾ�����ļ�ʧ��
:createNewConfigFile
    echo # ִ���깫˾����߼����Ƿ�������true Ϊ������false Ϊ��������Ĭ��Ϊ true 1>%~dp0for_company\for_company_config.txt
    echo isReboot=true 1>>%~dp0for_company\for_company_config.txt
    echo.>>%~dp0for_company\for_company_config.txt
    echo # �Ƿ�����������true Ϊ����������false Ϊ������ activity ��Ĭ��Ϊ true 1>>%~dp0for_company\for_company_config.txt
    echo isRunServiceFirst=true 1>>%~dp0for_company\for_company_config.txt
    echo.>>%~dp0for_company\for_company_config.txt
    echo #�ȴ� Activity �� Service ������ʱ�䣬�ȴ���ʱ֮���ټ���ִ�нű���ʱ�䵥λΪ��,Ĭ��Ϊ 2 �� 1>>%~dp0for_company\for_company_config.txt
    echo waitForSecond=2 1>>%~dp0for_company\for_company_config.txt
    set %~1=true
goto eof

@rem ���� .\for_company\for_company_config.txt �ļ�
@rem
@rem return boolean true ��ʾ�ɹ�������false ��ʾ����ʧ��
:for_company_init_config
    echo ���ڽ��� for_company_config.txt 
    set result=false
    for /f "eol=# tokens=1,2 delims== " %%l in (%~dp0for_company\for_company_config.txt) do (
        @rem ��ʼ��ȡ�����ļ�������
        echo �ҵ������%%~l�����ý����%%~l = %%~m
        if "%%~l"=="isReboot" set for_company_isReboot=%%~m
        if "%%~l"=="isRunServiceFirst" set for_company_isRunServiceFirst=%%~m
        if "%%~l"=="waitForSecond" set for_company_waitForSecond=%%~m
        set result=true
    )
    set %~1=!result!
goto eof

@rem ���� .\for_company\for_company_component_list.txt �ļ�
@rem
@rem return boolean true ��ʾ�ɹ�������false ��ʾ����ʧ��
:for_company_init_component_list
    echo ���ڽ���  .\for_company\for_company_component_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0for_company\for_company_component_list.txt) do (
        @rem ��ʼ��ȡ�����ļ�������
        set tmp_string_1=%%~l
        set tmp_string_3=!tmp_string_1:~0,1!
        if "!tmp_string_3!"==":" (
            @rem ��ǩ��
            set result=false
            set tmp_string_2=!tmp_string_1:~1!
            echo ���������ñ�ǩ !tmp_string_2!
            if "!tmp_string_2!"=="activities" set result=true
            if "!tmp_string_2!"=="services" set result=true
            if "!tmp_string_2!"=="uninstall" set result=true
            if "!result!"=="false" (
                echo .
                echo ��������������ñ�ǩ !tmp_string_1!
                echo ���������ļ� .\for_company\for_company_component_list.txt
                echo .
                echo �ű���ֹͣ���������ļ����˳�
                goto for_company_init_component_list_1
            )
        ) else (
            @rem ������
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="activities" (
                        @rem Ҫ�������� activity
                        if "!for_company_activities_list!" neq "null" (
                            set for_company_activities_list=!for_company_activities_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_activities_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="services" (
                        @rem Ҫ�������� service
                        if "!for_company_services_list!" neq "null" (
                            set for_company_services_list=!for_company_services_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_services_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="uninstall" (
                        @rem Ҫ�������� service
                        if "!for_company_uninstall_list!" neq "null" (
                            set for_company_uninstall_list=!for_company_uninstall_list!,"!tmp_string_1!"
                        ) else (
                            set for_company_uninstall_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo ��⵽ !tmp_string_2! δ������ activities �� services �� uninstall ��ǩ�£�
                    echo �ű���ֹͣ���������ļ����˳�
                    goto for_company_init_component_list_1
                )
            )
        )
    )
    :for_company_init_component_list_1
    set %~1=!result!
goto eof

@rem �������õ� activity
@rem
@rem param_3 �����
@rem return void
:startActivity
    if "!for_company_activities_list!" neq "null" (
        for %%c in (!for_company_activities_list!) do (
            adb.exe -t %~3 shell am start -n %%~c
            choice /d y /t !for_company_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem �������õ� service
@rem
@rem param_3 �����
@rem return void
:startService
    if "!for_company_services_list!" neq "null" (
        for %%c in (!for_company_services_list!) do (
            adb.exe -t %~3 shell am startservice -n %%~c
            choice /d y /t !for_company_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem ж�����õ� app
@rem
@rem param_3 �����
@rem return void
:uninstallApp
    if "!for_company_uninstall_list!" neq "null" (
        for %%p in (!for_company_uninstall_list!) do (
            adb.exe -t %~3 uninstall %%~p
        )
    )
goto eof

:eof