@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ������ƣ���׿����������
@rem ����汾��0.0.1
@rem ����������� onCoreLogicFinish �������������ض��İ�׿���
@rem �������ڣ�onScriptFirstStart��onCoreLogicFinish
@rem ������ܣ�
@rem	1�����������ļ���.\start_android_component\component_list.txt������
@rem		��Ӧ�İ�׿��������÷�ʽ�뿴�����ļ�����������ļ����������½�һ��
@rem		�����ļ���
@rem ---------------------------------------------------------------------
@rem ע���Ժ�ʹ�ô���Ŵ������к�ʶ��ͬ�豸
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

@rem �������ڻص��ӿ�
@rem
@rem return boolean
@rem param_3 string ��������
@rem param_4 string ���к�
@rem param_5 int	�����
@rem param_6 string �ļ��ľ���·��
:opt 
    if "%~3"=="onScriptFirstStart" (
        @rem �Ƿ������� service ������ activity��true Ϊ����������false ��֮��Ĭ��Ϊ true
        set start_android_component_isRunServiceFirst=true
        @rem �ȴ� Activity �� Service ������ʱ�䣬�ȴ���ʱ֮���ټ���ִ�нű���ʱ�䵥λΪ��,Ĭ��Ϊ 2 ��
        set start_android_component_waitForSecond=2
        @rem Ҫ������ activity �б�
        set start_android_component_activities_list=null
        @rem Ҫ������ service �б�
        set start_android_component_services_list=null
        @rem ��������������ļ�����������ļ����������½������ļ�
        if not exist "%~dp0start_android_component" mkdir %~dp0start_android_component
        if not exist "%~dp0start_android_component\config.txt" call "%~f0" boolean createNewConfigFile
        if not exist "%~dp0start_android_component\component_list.txt" call "%~f0" boolean createNewComponentListFile
        call "%~f0" boolean init_config
        if "!boolean!"=="false" (
            echo ��ȡ�����ļ� .\start_android_component\config.txt ʧ�ܣ���ʹ��Ĭ��ֵ
        )
        call "%~f0" boolean init_component_list
        if "!boolean!"=="false" (
            echo ���������ļ� .\start_android_component\component_list.txt ʧ��
        )
    )
    if "%~3"=="onCoreLogicFinish" (
        @rem ���� service �� activity
        if "!start_android_component_isRunServiceFirst!"=="true" (
            call %~nx0 void startService "%~5"
            call %~nx0 void startActivity "%~5"
        ) else (
            call %~nx0 void startActivity "%~5"
            call %~nx0 void startService "%~5"
        )
    )
goto eof


@rem �����µ� component_list.txt �ļ�
@rem 
@rem return boolean true ��ʾ�ɹ������ļ���false ��ʾ�����ļ�ʧ��
:createNewComponentListFile
    echo ###################################################################################### 1>%~dp0start_android_component\component_list.txt
    echo # 1��������д�밲׿����б����Ҫ���� Activity �����д�� :activities �£�             1>>%~dp0start_android_component\component_list.txt
    echo #   ���Ҫ���� Service ��д�� :services �£����磺                                       1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   # ��ʾҪ���� com.android.xxx/.MainActivity ��� Activity                            1>>%~dp0start_android_component\component_list.txt
    echo #   :activities                                                                        1>>%~dp0start_android_component\component_list.txt
    echo #   com.android.xxx/.MainActivity                                                      1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   # ��ʾҪ���� com.android.xxx/.SomeService ��� Service                              1>>%~dp0start_android_component\component_list.txt
    echo #   :services                                                                          1>>%~dp0start_android_component\component_list.txt
    echo #   com.android.xxx/.SomeService                                                       1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo # ע��com.android.xxx �ǰ�����.MainActivity �� .SomeService ʡ�԰�����ľ���İ�׿���     1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo # 2���������������õİ�׿���������׿�� am �������                                        1>>%~dp0start_android_component\component_list.txt
    echo #   Activity �ĵ��ø�ʽ���£�                                                            1>>%~dp0start_android_component\component_list.txt
    echo #       am  start  -n  com.android.xxx/.MainActivity                                   1>>%~dp0start_android_component\component_list.txt
    echo #                                                                                      1>>%~dp0start_android_component\component_list.txt
    echo #   Service �ĵ��ø�ʽ���£�                                                             1>>%~dp0start_android_component\component_list.txt
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

@rem �����µ� config.txt �ļ�
@rem 
@rem return boolean true ��ʾ�ɹ������ļ���false ��ʾ�����ļ�ʧ��
:createNewConfigFile
    echo # �Ƿ�����������true Ϊ����������false Ϊ������ activity ��Ĭ��Ϊ true 1>>%~dp0start_android_component\config.txt
    echo isRunServiceFirst=true 1>>%~dp0start_android_component\config.txt
    echo.>>%~dp0start_android_component\config.txt
    echo #�ȴ� Activity �� Service ������ʱ�䣬�ȴ���ʱ֮���ټ���ִ�нű���ʱ�䵥λΪ��,Ĭ��Ϊ 2 �� 1>>%~dp0start_android_component\config.txt
    echo waitForSecond=2 1>>%~dp0start_android_component\config.txt
	set %~1=true
goto eof

@rem ���� .\start_android_component\config.txt �ļ�
@rem
@rem return boolean true ��ʾ�ɹ�������false ��ʾ����ʧ��
:init_config
    echo ���ڽ��� config.txt 
    set result=false
    for /f "eol=# tokens=1,2 delims== " %%l in (%~dp0start_android_component\config.txt) do (
        @rem ��ʼ��ȡ�����ļ�������
        echo �ҵ������%%~l�����ý����%%~l = %%~m
        if "%%~l"=="isRunServiceFirst" set start_android_component_isRunServiceFirst=%%~m
        if "%%~l"=="waitForSecond" set start_android_component_waitForSecond=%%~m
        set result=true
    )
    set %~1=!result!
goto eof

@rem ���� .\start_android_component\component_list.txt �ļ�
@rem
@rem return boolean true ��ʾ�ɹ�������false ��ʾ����ʧ��
:init_component_list
    echo ���ڽ���  .\start_android_component\component_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0start_android_component\component_list.txt) do (
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
            if "!result!"=="false" (
                echo .
                echo ��������������ñ�ǩ !tmp_string_1!
                echo ���������ļ� .\start_android_component\component_list.txt
                echo .
                echo �ű���ֹͣ���������ļ����˳�
                goto init_component_list_1
            )
        ) else (
            @rem ������
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="activities" (
                        @rem Ҫ�������� activity
                        if "!start_android_component_activities_list!" neq "null" (
                            set start_android_component_activities_list=!start_android_component_activities_list!,"!tmp_string_1!"
                        ) else (
                            set start_android_component_activities_list="!tmp_string_1!"
                        )
                    )
                    if "!tmp_string_2!"=="services" (
                        @rem Ҫ�������� service
                        if "!start_android_component_services_list!" neq "null" (
                            set start_android_component_services_list=!start_android_component_services_list!,"!tmp_string_1!"
                        ) else (
                            set start_android_component_services_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo ��⵽ !tmp_string_2! δ������ activities �� services ��ǩ�£�
                    echo �ű���ֹͣ���������ļ����˳�
                    goto init_component_list_1
                )
            )
        )
    )
    :init_component_list_1
    set %~1=!result!
goto eof

@rem �������õ� activity
@rem
@rem param_3 �����
@rem return void
:startActivity
    if "!start_android_component_activities_list!" neq "null" (
        for %%c in (!start_android_component_activities_list!) do (
            adb.exe -t %~3 shell am start -n %%~c
            choice /d y /t !start_android_component_waitForSecond! /n 1>nul
        )
    )
goto eof

@rem �������õ� service
@rem
@rem param_3 �����
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