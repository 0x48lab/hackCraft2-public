#!/bin/bash

# hackCraft2 GitHub Pages ローカルテストサーバー
# セキュリティのため、ローカルホストからのアクセスのみを許可

echo "=========================================="
echo "hackCraft2 GitHub Pages ローカルテストサーバー"
echo "=========================================="
echo ""

# 現在のディレクトリを確認
CURRENT_DIR=$(pwd)
echo "現在のディレクトリ: $CURRENT_DIR"

# docsディレクトリの存在確認
if [ ! -d "docs" ]; then
    echo "❌ エラー: docsディレクトリが見つかりません"
    echo "このスクリプトは、docsディレクトリがある場所で実行してください"
    exit 1
fi

# Pythonのバージョンを確認
echo "Pythonのバージョンを確認中..."
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    echo "✅ Python3 が見つかりました"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
    echo "✅ Python が見つかりました"
else
    echo "❌ エラー: Pythonが見つかりません"
    echo "Python 3.x をインストールしてください"
    exit 1
fi

# ポート番号の設定（デフォルト: 8000）
PORT=${1:-8000}

# ポートが使用可能かチェック
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "❌ エラー: ポート $PORT は既に使用されています"
    echo "別のポート番号を指定してください: ./start_local_server.sh 8001"
    exit 1
fi

echo ""
echo "🚀 ローカルテストサーバーを起動します..."
echo "📁 ドキュメントディレクトリ: $CURRENT_DIR/docs"
echo "🌐 アクセスURL: http://localhost:$PORT"
echo "🔒 セキュリティ: ローカルホストからのアクセスのみ許可"
echo ""
echo "停止するには Ctrl+C を押してください"
echo "=========================================="

# docsディレクトリに移動してPythonサーバーを起動
cd docs

# セキュリティ設定付きでPythonサーバーを起動
# --bind 127.0.0.1: ローカルホストからのアクセスのみ許可
# --directory .: 現在のディレクトリをルートとして設定
$PYTHON_CMD -m http.server $PORT --bind 127.0.0.1

echo ""
echo "✅ サーバーが停止しました" 