@echo off
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ::	version: v0.0.4													::
@rem ::	author: Mouse.JiangWei											::
@rem ::	date: 2020.5.17													::
@rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem ������ƣ��޸�΢�ź�׺
@rem ����汾��0.0.2
@rem �����������Ϊ��΢�Ŵ��� apk �ļ�ʱ��΢�Ż��Զ��� .1 ��׺����Ӧ���޷��� adb ��װ��
@rem ��ǰ�����������������.
@rem �������ڣ�onScriptFirstStart
@rem ������ܣ�
@rem 	1���˲�����޸� apk Ŀ¼�� .1 ��׺���ļ�Ϊ .apk ��׺����ʹԭ�����ļ����� apk �ļ�
@rem
if "!RUN_ONCE!" neq "%RUN_ONCE%" setlocal enableDelayedExpansion
if "%~n2"=="opt" goto opt
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
goto eof

:eof