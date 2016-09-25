call setup_mssdk71.bat

cd .
nmake -f Discrete.mk  MODELLIB=Discretelib.lib RELATIVE_PATH_TO_ANCHOR=.. MODELREF_TARGET_TYPE=NONE
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
