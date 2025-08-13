@echo off
setlocal enabledelayedexpansion

:: Loop through all .sql files in the current directory
for %%F in (*.sql) do (
    set "filename=%%~nxF"
    if exist "abc\%%~nxF" (
        echo Comparing %%~nxF with abc\%%~nxF
        fc "%%~nxF" "abc\%%~nxF"
    ) else (
        echo File abc\%%~nxF not found.
    )
)

endlocal
