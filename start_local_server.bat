@echo off
chcp 65001 >nul

REM hackCraft2 GitHub Pages ローカルテストサーバー (Windows版)
REM セキュリティのため、ローカルホストからのアクセスのみを許可

echo ==========================================
echo hackCraft2 GitHub Pages ローカルテストサーバー
echo ==========================================
echo.

REM 現在のディレクトリを確認
set CURRENT_DIR=%CD%
echo 現在のディレクトリ: %CURRENT_DIR%

REM docsディレクトリの存在確認
if not exist "docs" (
    echo ❌ エラー: docsディレクトリが見つかりません
    echo このスクリプトは、docsディレクトリがある場所で実行してください
    pause
    exit /b 1
)

REM Pythonのバージョンを確認
echo Pythonのバージョンを確認中...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_CMD=python
    echo ✅ Python が見つかりました
) else (
    python3 --version >nul 2>&1
    if %errorlevel% equ 0 (
        set PYTHON_CMD=python3
        echo ✅ Python3 が見つかりました
    ) else (
        echo ❌ エラー: Pythonが見つかりません
        echo Python 3.x をインストールしてください
        pause
        exit /b 1
    )
)

REM ポート番号の設定（デフォルト: 8000）
set PORT=%1
if "%PORT%"=="" set PORT=8000

REM ポートが使用可能かチェック（簡易チェック）
netstat -an | find ":%PORT%" | find "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo ❌ エラー: ポート %PORT% は既に使用されています
    echo 別のポート番号を指定してください: start_local_server.bat 8001
    pause
    exit /b 1
)

echo.
echo 🚀 ローカルテストサーバーを起動します...
echo 📁 ドキュメントディレクトリ: %CURRENT_DIR%\docs
echo 🌐 アクセスURL: http://localhost:%PORT%
echo 🔒 セキュリティ: ローカルホストからのアクセスのみ許可
echo.
echo 停止するには Ctrl+C を押してください
echo ==========================================

REM docsディレクトリに移動してPythonサーバーを起動
cd docs

REM セキュリティ設定付きでPythonサーバーを起動
REM --bind 127.0.0.1: ローカルホストからのアクセスのみ許可
%PYTHON_CMD% -m http.server %PORT% --bind 127.0.0.1

echo.
echo ✅ サーバーが停止しました
pause 