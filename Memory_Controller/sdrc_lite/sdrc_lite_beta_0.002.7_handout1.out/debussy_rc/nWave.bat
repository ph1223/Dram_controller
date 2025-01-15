::This bat file is a auto-generated file.
@ECHO OFF
SET debussy=C:\Novas\Debussy\bin\Debussy.exe
%debussy% -nWave %*
RD Debussy.exeLog  /s /q
DEL novas.rc /q
EXIT
