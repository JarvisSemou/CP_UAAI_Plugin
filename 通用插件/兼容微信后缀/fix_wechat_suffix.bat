@echo off
@rem ������ƣ��޸�΢�ź�׺
@rem ����汾��0.0.1
@rem �����������Ϊ��΢�Ŵ��� apk �ļ�ʱ��΢�Ż��Զ��� .1 ��׺����Ӧ���޷��� adb ��װ����ǰ�����������������
@rem ��ǰ���ע�����������������onScriptFirstStart
@rem ������ܣ�
@rem 	1���˲�����޸� apk Ŀ¼�� .1 ��׺���ļ�Ϊ .apk ��׺����ʹԭ�����ļ����� apk �ļ�
@rem
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
	if "%~3"=="onScriptFirstStart" (
		echo ��ʼִ��΢�ź�׺�޸�
		for %%t in (.\app\*.1) do (
			echo �����޸� "%%~fnxt" �ļ�
			if not exist "%%~dpnt" (
				rename "%%~fnxt" "%%~nt"
				echo �ѽ� "%%~fnxt" �޸�Ϊ "%%~nt"
			) else (
				echo "%%~nt" �ļ��Ѵ��ڣ�δ�� "%%~fnxt" �޸�Ϊ "%%~nt"
			)
		)
	)
	pause
goto eof

:eof