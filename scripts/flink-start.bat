@echo off
setlocal
set "REGION=%~1"
if "%REGION%"=="" set "REGION=ap-northeast-2"

pushd "%~dp0..\infra"
for /f "usebackq delims=" %%A in (`terraform output -raw flink_application_name`) do set "APP_NAME=%%A"
popd

if "%APP_NAME%"=="" (
  echo [ERROR] Failed to get flink_application_name from terraform output.
  endlocal & exit /b 1
)

echo Starting Flink application: %APP_NAME% (%REGION%)...
aws kinesisanalyticsv2 start-application --region "%REGION%" --application-name "%APP_NAME%"
set "RC=%ERRORLEVEL%"
endlocal & exit /b %RC%

