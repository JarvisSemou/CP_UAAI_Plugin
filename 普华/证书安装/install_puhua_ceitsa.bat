@echo on
@rem �ջ�֤�鵼����
@rem ��ǰ���ע�����������������onCoreStart
@rem ���ܣ�
@rem 	1�������Ƿ�����ջ��ͻ��˵��������
@rem	2���Ƿ�����֤�顣֤���Ĭ�ϵ��뷽ʽΪ����ͬһ��֤�飻
@rem 		��һ��Ϊ���뷽ʽΪ��һ���뵱ǰĿ¼�µ� ceitsas Ŀ¼�µ�֤�飬��ɾ���ѵ����֤��
@rem	3�������Ƿ��ڰ�װ���ջ��ͻ���ǰж�ؾ��ջ��ͻ���
if "%~n2"=="" ( 
	setlocal enabledelayedexpansion
	goto opt
)
if "%~n2"=="opt" goto opt
goto eof

@rem return void
@rem param_3 ��������
@rem param_4 ���к�
:opt 
	@rem �����б� -------------------------------
	@rem com.sgit.vpn
	@rem de.blinkt.openvpn
	@rem ----------------------------------------
	@rem �������� -------------------------------
	@rem �����Ƿ��ڰ�װ�¿ͻ���ǰж�ؾɿͻ��ˣ�true Ϊ�ڰ�װ�¿ͻ���ǰж�ؾɿͻ��ˣ�false ��֮
	set UNINSTALL_OLD_WHEN_INSTALL_NEW=false
	@rem �ջ��ɰ�ȫ�ͻ��˰���
	set OLD_PUHUA_VPN_PACKAGE=null
	@rem �ջ��°�ȫ�ͻ��˰���
	set NEW_PUHUA_VPN_PACKAGE=null
	@rem �Ƿ�����ջ��ͻ������ݣ�true Ϊ�����ȫ�ͻ������ݣ�false ��֮
	set CLEAN_PUHUA_VPN_DATA=false
	@rem �ջ�֤����Ŀ¼
	set PUHUA_CEITSA_FLODER=%~dp0ceitsas
	@rem ��ʱĿ¼
	set PUHUA_CEITSA_TMP_FLODER=!PUHUA_CEITSA_FLODER!\tmp
	@rem �Ƿ�װ�ջ�֤�飬true Ϊ��װ��false ��֮
	set INSTALL_PUHUA_CEITSA=false
	@rem ��װ�ջ�֤��ķ�ʽ��REPEAT Ϊ�ظ���װ��NOT_REPEAT Ϊ���ظ���װ��Ĭ��Ϊ REPEAT
	set INSTALL_PUHUA_CEITSA_MODE=REPEAT
	@rem ----------------------------------------
	@rem ���￪ʼд��ʽ�������
	if "%~3"=="onCoreStart" (
		if "!UNINSTALL_OLD_WHEN_INSTALL_NEW!"=="true" (
			adb.exe -s %~4 uninstall !OLD_PUHUA_VPN_PACKAGE!
		)
		if "!CLEAN_PUHUA_VPN_DATA!"=="true" (
			adb.exe -s %~4 shell pm clear !OLD_PUHUA_VPN_PACKAGE!
		)
		if "!INSTALL_PUHUA_CEITSA!"=="true" (
			if exist "!PUHUA_CEITSA_FLODER!" (
				if exist "!PUHUA_CEITSA_FLODER!\*.conf" (
					adb.exe -s %~4 shell rm -rf /sdcard/ceitsa
					adb.exe -s %~4 shell mkdir /sdcard/ceitsa
					if "!INSTALL_PUHUA_CEITSA_MODE!"=="NOT_REPEAT" (
						if not exist "!PUHUA_CEITSA_TMP_FLODER!" (
							md !PUHUA_CEITSA_TMP_FLODER!
						)
						for %%t in (!PUHUA_CEITSA_FLODER!\*.conf) do (
							echo ��ʼ����֤�飺%%t
							move %%t !PUHUA_CEITSA_TMP_FLODER!\%%~nxt
							adb.exe -s %~4 push "!PUHUA_CEITSA_TMP_FLODER!\%%~nxt" /sdcard/ceitsa/%%~nxt
							del /f /q "!PUHUA_CEITSA_TMP_FLODER!\%%~nxt"
							goto opt_l_1
						)
					) else (
						for %%t in (!PUHUA_CEITSA_FLODER!\*.conf) do (
							echo ��ʼ����֤�飺%%t
							adb.exe -s %~4 push "!PUHUA_CEITSA_FLODER!\%%~nxt" /sdcard/ceitsa/%%~nxt
							goto opt_l_1
						)
					)
					echo ����֤�����
				) else (
					echo �Ҳ���֤���ļ���δ��ʼ��װ֤��
				)
			) else (
				echo  �Ҳ���֤�������ļ��� ��!PUHUA_CEITSA_FLODER!����δ��ʼ��װ֤��
			)
		)
	)
	:opt_l_1
goto eof