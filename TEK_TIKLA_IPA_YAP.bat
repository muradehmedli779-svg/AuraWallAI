@echo off
chcp 65001 >nul
title AuraWall AI - Tek Tıkla GitHub'da IPA Derleme

echo =====================================================================
echo          AuraWall AI - Otomatik Bulut IPA Derleme Sihirbazi
echo =====================================================================
echo.
echo Bilgisayarinizda hicbir sunucu acik tutmaniza veya Mac aramaniza gerek yok!
echo Bu betik kodlari GitHub deponuza gonderecek ve GitHub'in macOS bulut
echo sunucusu xcodebuild calistirarak hazir .IPA dosyanizi uretecektir.
echo.
echo ---------------------------------------------------------------------
echo ADIM 1: GitHub'da yeni ve bos bir repo olusturun:
echo         https://github.com/new
echo         (Repo adini 'AuraWallAI' yapin, Public veya Private secin)
echo ---------------------------------------------------------------------
echo.
set /p REPO_URL="Olusturdugunuz GitHub Repo URL'sini buraya yapistirin: "

if "%REPO_URL%"=="" (
    echo.
    echo [HATA] Bir URL girmediniz! Lutfen tekrar calistirin.
    pause
    exit /b
)

echo.
echo [1/3] Git ayarlari yapilandiriliyor...
git branch -M main
git remote remove origin 2>nul
git remote add origin %REPO_URL%

echo [2/3] Kodlar GitHub'a gonderiliyor...
git push -u origin main --force

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =====================================================================
    echo [BASARILI] Kodlar basariyla GitHub'a yuklendi!
    echo.
    echo GitHub Actions simdi buluttaki macOS-14 sunucusunu baslatti.
    echo Projeniz otomatik derlenecek ve IPA dosyaniz uretilecek.
    echo.
    echo Derleme durumunu gormek ve IPA'yi indirmek icin su sayfaya gidin:
    echo %REPO_URL%/actions
    echo.
    echo Derleme bittiginde (yaklasik 3-4 dakika), 'Releases' veya 'Artifacts'
    echo kismindan AuraWall.ipa dosyanizi tek tikla indirebilirsiniz!
    echo =====================================================================
) else (
    echo.
    echo [HATA] GitHub'a yuklenirken bir sorun olustu.
    echo Lutfen GitHub kullanici adi ve sifrenizi/tokeninizi kontrol edin.
)

echo.
pause
