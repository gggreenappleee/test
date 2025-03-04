@echo off
REM 清除遠程桌面連線的歷史記錄和配置

REM 設置遠程桌面連接的IP地址和端口
set RDP_ADDRESS=

REM 刪除註冊表中的遠程桌面歷史記錄
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"

REM 刪除預設的.rdp文件
cd %userprofile%\documents\
attrib Default.rdp -s -h
if exist Default.rdp del Default.rdp

REM 創建自定義的.rdp文件，已設置麥克風和解析度色彩
echo screen mode id:i:2 > custom.rdp
echo use multimon:i:0 >> custom.rdp
echo session bpp:i:15 >> custom.rdp
echo redirectprinters:i:1 >> custom.rdp
echo redirectcomports:i:0 >> custom.rdp
echo redirectsmartcards:i:1 >> custom.rdp
echo redirectclipboard:i:1 >> custom.rdp
echo redirectposdevices:i:0 >> custom.rdp
echo redirectdirectx:i:1 >> custom.rdp
echo drivestoredirect:s:* >> custom.rdp
echo redirectdrives:i:1 >> custom.rdp
echo keyboardhook:i:2 >> custom.rdp
echo audiocapturemode:i:1 >> custom.rdp
echo videoplaybackmode:i:1 >> custom.rdp
echo connection type:i:7 >> custom.rdp
echo networkautodetect:i:1 >> custom.rdp
echo bandwidthautodetect:i:1 >> custom.rdp
echo displayconnectionbar:i:1 >> custom.rdp
echo enableworkspacereconnect:i:0 >> custom.rdp
echo disable wallpaper:i:1 >> custom.rdp
echo allow font smoothing:i:0 >> custom.rdp
echo allow desktop composition:i:0 >> custom.rdp
echo disable full window drag:i:1 >> custom.rdp
echo disable menu anims:i:1 >> custom.rdp
echo disable themes:i:1 >> custom.rdp
echo disable cursor setting:i:0 >> custom.rdp
echo bitmapcachepersistenable:i:1 >> custom.rdp
echo full address:s:%RDP_ADDRESS% >> custom.rdp
echo compression:i:1 >> custom.rdp
echo keyboard layout:s:00000409 >> custom.rdp
echo administrative session:i:0 >> custom.rdp

REM 連接到指定的遠程桌面
mstsc custom.rdp /f

REM 循環檢測遠程桌面是否關閉
:CheckRDP
tasklist | find /i "mstsc.exe"
if errorlevel 1 goto CleanUp
timeout /t 5
goto CheckRDP

REM 清理遠程桌面連線痕跡
:CleanUp
REM 刪除註冊表中的遠程桌面歷史記錄
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"

REM 刪除預設的.rdp文件和自定義的.rdp文件
cd %userprofile%\documents\
attrib Default.rdp -s -h
if exist Default.rdp del Default.rdp
if exist custom.rdp del custom.rdp

REM 腳本結束
echo 清理完成
