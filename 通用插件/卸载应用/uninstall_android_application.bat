@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ������ƣ�ж�ذ�׿Ӧ��
@rem ����汾��0.0.1
@rem ����������� onCoreStart �������������ض��İ�׿���
@rem �������ڣ�onScriptFirstStart��onCoreStart
@rem ������ܣ�
@rem	1�����������ļ���.\uninstall_android_application\package_list.txt��
@rem        ж����Ӧ��׿Ӧ�ó�����������ļ������ڽ�����һ��
@rem ---------------------------------------------------------------------
@rem ע���Ժ�ʹ�ô���Ŵ������к�ʶ��ͬ�豸
@rem ---------------------------------------------------------------------
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
if "%~n2"=="opt" goto opt
if "%~2"=="createNewPackageListFile" goto createNewPackageListFile
if "%~2"=="init_package_list" goto init_package_list
if "%~2"=="unstallApp" goto uninstallApp
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
        @rem Ҫж�صİ�׿Ӧ��
        set uninstall_android_application_uninstall_list=null
        @rem ��������������ļ�����������ļ����������½������ļ�
        if not exist "%~dp0uninstall_android_application" mkdir %~dp0uninstall_android_application
        if not exist "%~dp0uninstall_android_application\package_list.txt" call "%~f0" boolean createNewPackageListFile
        call "%~f0" boolean init_package_list
        if "!boolean!"=="false" (
            echo ���������ļ� .\uninstall_android_application\package_list.txt ʧ��
        )
    )
    if "%~3"=="onCoreStart" (
        @rem ж��Ӧ��
        call %~nx0 void unstallApp "%~5"
    )
goto eof


@rem �����µ� package_list.txt �ļ�
@rem 
@rem return boolean true ��ʾ�ɹ������ļ���false ��ʾ�����ļ�ʧ��
:createNewPackageListFile
    echo ###################################################################################### 1>%~dp0uninstall_android_application\package_list.txt
    echo # 1��������д�밲׿Ӧ�ð����б�                                                          1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo #   #��ʾҪж�� com.android.xxx ���Ӧ��                                                1>%~dp0uninstall_android_application\package_list.txt
    echo #   :uninstall                                                                         1>%~dp0uninstall_android_application\package_list.txt
    echo #   com.android.xxx                                                                    1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo # ע��com.android.xxx �ǰ���                                                            1>%~dp0uninstall_android_application\package_list.txt
    echo #                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    echo ###################################################################################### 1>%~dp0uninstall_android_application\package_list.txt
    echo :uninstall                                                                             1>%~dp0uninstall_android_application\package_list.txt
    echo .                                                                                      1>%~dp0uninstall_android_application\package_list.txt
    set %~1=true
goto eof

@rem ���� .\uninstall_android_application\package_list.txt �ļ�
@rem
@rem return boolean true ��ʾ�ɹ�������false ��ʾ����ʧ��
:init_package_list
    echo ���ڽ���  .\uninstall_android_application\package_list.txt
    set tmp_string_1=null
    set tmp_string_2=null
    set result=false
    for /f "eol=#" %%l in (%~dp0uninstall_android_application\package_list.txt) do (
        @rem ��ʼ��ȡ�����ļ�������
        set tmp_string_1=%%~l
        set tmp_string_3=!tmp_string_1:~0,1!
        if "!tmp_string_3!"==":" (
            @rem ��ǩ��
            set result=false
            set tmp_string_2=!tmp_string_1:~1!
            echo ���������ñ�ǩ !tmp_string_2!
            if "!tmp_string_2!"=="uninstall" set result=true
            if "!result!"=="false" (
                echo .
                echo ��������������ñ�ǩ !tmp_string_1!
                echo ���������ļ� .\uninstall_android_application\package_list.txt
                echo .
                echo �ű���ֹͣ���������ļ����˳�
                goto init_package_list_1
            )
        ) else (
            @rem ������
            if "!tmp_string_1!" neq "" (
                if "!tmp_string_2!" neq "null" (
                    if "!tmp_string_2!"=="uninstall" (
                        @rem ����Ҫж�ص�Ӧ��
                        if "!uninstall_android_application_uninstall_list!" neq "null" (
                            set uninstall_android_application_uninstall_list=!uninstall_android_application_uninstall_list!,"!tmp_string_1!"
                        ) else (
                            set uninstall_android_application_uninstall_list="!tmp_string_1!"
                        )
                    )
                    set result=true
                ) else (
                    set result=false
                    echo ��⵽ !tmp_string_2! δ������ uninstall ��ǩ�£�
                    echo �ű���ֹͣ���������ļ����˳�
                    goto init_package_list_1
                )
            )
        )
    )
    :init_package_list_1
    set %~1=!result!
goto eof

@rem ж�����õ�Ӧ�ó���
@rem
@rem param_3 �����
@rem return void
:startService
    if "!uninstall_android_application_uninstall_list!" neq "null" (
        for %%p in (!uninstall_android_application_uninstall_list!) do (
            adb.exe -t %~3 uninstall %%p
        )
    )
goto eof

:eof