@echo off

REM Set site name
set site_name=PHL

echo Hello! Welcome to backup/restore/checksum operation machine!

:menu
cls
echo Menu:
echo 1. Compress
echo 2. Encrypt
echo 3. Decrypt
echo 4. Decompress
echo 5. Checksum
echo 6. Quit
echo.

REM Get user choice
set /p choice=Enter the number corresponding to your choice: 

REM Check if choice is blank or whitespace
if "%choice%"=="" (
    echo Choice cannot be blank. Please enter a valid number between 1 and 6.
    pause
    goto menu
)

REM Process user choice
if "%choice%"=="1" goto compress
if "%choice%"=="2" goto encrypt
if "%choice%"=="3" goto decrypt
if "%choice%"=="4" goto decompress
if "%choice%"=="5" goto checksum
if "%choice%"=="6" goto :eof

REM Handle invalid choice
echo Invalid choice. Please enter a number between 1 and 6.
pause
goto menu

:compress
REM Get source filename from command line argument
set source_file=%1

REM If source filename is not provided as an argument, prompt the user to enter it
if "%source_file%"=="" (
    set /p source_file=Enter source filename to compress: 
)

REM Check if source file exists
if not exist "%source_file%" (
    echo Error: Source file "%source_file%" not found.
    pause
    goto menu
)

REM Get current date in YYYYMMDD format
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set date=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%

REM Backup the file
echo Backing up %source_file%...
copy "%source_file%" %site_name%_%date%.txt > nul

REM Compress the backup file using PowerShell Compress-Archive cmdlet
echo Compressing backup file...
powershell -Command "Compress-Archive -Path '%site_name%_%date%.txt' -DestinationPath '%site_name%_%date%.zip'"

echo Compression completed.
del %site_name%_%date%.txt
del %source_file%
pause
goto menu

:encrypt
REM Get source filename from command line argument
set source_file=%1

REM If source filename is not provided as an argument, prompt the user to enter it
if "%source_file%"=="" (
    set /p source_file=Enter source filename to encrypt: 
)

REM Check if source file exists
if not exist "%source_file%" (
    echo Error: Source file "%source_file%" not found.
    pause
    goto menu
)

REM Encrypt the source file using AESCrypt
echo Encrypting %source_file%...
"D:\AESCrypt\aescrypt.exe" -e -p wI1btTnp34i9z "%source_file%" > nul

echo Encryption completed.
del %source_file%
pause
goto menu

:decrypt
REM Get source filename from command line argument
set source_file=%1

REM If source filename is not provided as an argument, prompt the user to enter it
if "%source_file%"=="" (
    set /p source_file=Enter source filename to decrypt: 
)

REM Check if source file exists
if not exist "%source_file%" (
    echo Error: Source file "%source_file%" not found.
    pause
    goto menu
)

REM Decrypt the source file using AESCrypt
echo Decrypting %source_file%...
"D:\AESCrypt\aescrypt.exe" -d -p wI1btTnp34i9z "%source_file%" > nul

echo Decryption completed.
del %source_file%
pause
goto menu

:decompress
REM Get source filename from command line argument
set source_file=%1

REM If source filename is not provided as an argument, prompt the user to enter it
if "%source_file%"=="" (
    set /p source_file=Enter source filename to decompress: 
)

REM Check if source file exists
if not exist "%source_file%" (
    echo Error: Source file "%source_file%" not found.
    pause
    goto menu
)

REM Get current date in YYYYMMDD format
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set date=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%

REM Decompress the source file using PowerShell Expand-Archive cmdlet
echo Decompressing %source_file%...
powershell Expand-Archive '%site_name%_%date%.zip' -DestinationPath '.'

echo Decompression completed.
del %source_file%
pause
goto menu

:checksum
@echo off

REM Get source filename from command line argument
set source_file=%1

REM If source filename is not provided as an argument, prompt the user to enter it
if "%source_file%"=="" (
    set /p source_file=Enter source filename to generate a checksum: 
)

REM Check if source file exists
if not exist "%source_file%" (
    echo Error: Source file "%source_file%" not found.
    exit /b
)

REM Choose checksum algorithm
:choose_algorithm
echo Choose checksum algorithm:
echo 1. MD5
echo 2. SHA1
echo 3. SHA256
echo.
set /p choice=Enter the number corresponding to the checksum algorithm: 

REM Process user choice
if "%choice%"=="1" goto generate_md5
if "%choice%"=="2" goto generate_sha1
if "%choice%"=="3" goto generate_sha256

REM Handle invalid choice
echo Invalid choice. Please enter a number between 1 and 3.
goto choose_algorithm

:generate_md5
REM Generate MD5 checksum for the source file using PowerShell
echo Generating MD5 checksum...
if exist "%source_file%" (
    powershell -Command "$hash = Get-FileHash '%source_file%' -Algorithm MD5; Write-Host $hash.Hash; $hash.Hash | Out-File %source_file%.md5"
    echo.
    echo MD5 checksum saved as %source_file%.md5
) else (
    echo Error: Source file "%source_file%" not found.
)
goto verify_checksum

:generate_sha1
REM Generate SHA1 checksum for the source file using PowerShell
echo Generating SHA1 checksum...
if exist "%source_file%" (
    powershell -Command "$hash = Get-FileHash '%source_file%' -Algorithm SHA1; Write-Host $hash.Hash; $hash.Hash | Out-File %source_file%.sha1"
    echo.
    echo SHA1 checksum saved as %source_file%.sha1
) else (
    echo Error: Source file "%source_file%" not found.
)
goto verify_checksum

:generate_sha256
REM Generate SHA256 checksum for the source file using PowerShell
echo Generating SHA256 checksum...
if exist "%source_file%" (
    powershell -Command "$hash = Get-FileHash '%source_file%' -Algorithm SHA256; Write-Host $hash.Hash; $hash.Hash | Out-File %source_file%.sha256"
    echo.
    echo SHA256 checksum saved as %source_file%.sha256
) else (
    echo Error: Source file "%source_file%" not found.
)
goto verify_checksum

:verify_checksum
REM Ask the user if they want to verify the checksum
set /p verify=Do you want to verify the checksum (Y/N) 

REM Process user verification choice
if /i "%verify%"=="Y" (
        goto choose_algorithm
    ) else (
        goto end
    )
) else (
    REM If no, exit the script
    goto end
)

:end
echo.
echo Press any key to return to the menu...
pause > nul

goto menu
