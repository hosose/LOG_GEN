@echo off
chcp 65001 >nul
setlocal

set "ROOT=%~dp0.."
set "FLINK_DIR=%ROOT%\flink"

:: 1. Java check and fallback
where java >nul 2>nul
if errorlevel 1 (
    if defined JAVA_HOME (
        if exist "%JAVA_HOME%\bin\java.exe" set "PATH=%JAVA_HOME%\bin;%PATH%"
    )
)
where java >nul 2>nul
if errorlevel 1 (
    if exist "C:\Program Files\Microsoft\jdk-11.0.32.9-hotspot\bin\java.exe" (
        set "PATH=C:\Program Files\Microsoft\jdk-11.0.32.9-hotspot\bin;%PATH%"
        if not defined JAVA_HOME set "JAVA_HOME=C:\Program Files\Microsoft\jdk-11.0.32.9-hotspot"
    )
)
where java >nul 2>nul
if errorlevel 1 (
    echo ERROR: Java JDK 11이 필요합니다. JDK 11을 설치한 뒤 다시 실행하세요.
    exit /b 1
)

:: 2. Maven check and fallback
where mvn >nul 2>nul
if errorlevel 1 (
    if defined MAVEN_HOME (
        if exist "%MAVEN_HOME%\bin\mvn.cmd" set "PATH=%MAVEN_HOME%\bin;%PATH%"
    )
)
where mvn >nul 2>nul
if errorlevel 1 (
    if exist "%LOCALAPPDATA%\Programs\apache-maven\apache-maven-3.9.16\bin\mvn.cmd" (
        set "PATH=%LOCALAPPDATA%\Programs\apache-maven\apache-maven-3.9.16\bin;%PATH%"
        if not defined MAVEN_HOME set "MAVEN_HOME=%LOCALAPPDATA%\Programs\apache-maven\apache-maven-3.9.16"
    )
)
where mvn >nul 2>nul
if errorlevel 1 (
    echo ERROR: Maven이 필요합니다. JDK 11 + Maven을 설치한 뒤 다시 실행하세요.
    exit /b 1
)

echo [1/2] Build PyFlink application package
pushd "%FLINK_DIR%"
call mvn clean package
if errorlevel 1 (
    popd
    exit /b 1
)
popd

if not exist "%FLINK_DIR%\target\flink-silver.zip" (
    echo ERROR: Flink 배포 ZIP이 생성되지 않았습니다.
    exit /b 1
)

echo [2/2] Build complete
echo %FLINK_DIR%\target\flink-silver.zip

endlocal
