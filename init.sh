#!/bin/bash

## --------------------------------------------------------------------------
## 定数定義
## --------------------------------------------------------------------------

TAS_PRJ_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd);



## --------------------------------------------------------------------------
## 初期化処理
## --------------------------------------------------------------------------

## 必要なモジュールのロード
for SH_FILE in `ls "${TAS_PRJ_DIR}"/init.d/*.sh`;
do
	source "${SH_FILE}";
done



## --------------------------------------------------------------------------
## 開発に使用するコマンドの定義
## --------------------------------------------------------------------------

## Reset File Owner
## ファイル所有者をすべて自分に上書き
alias rfo="sudo chown -R $(whoami):$(whoami) ${TAS_PRJ_DIR}/.*";

## Clear All Cache
## キャッシュファイル関連をすべて削除
alias cac="rfo && rm -rf ${TAS_PRJ_DIR}/node_modules/*";

## Generate all Setting Files
alias gsf='\
  tas_gen_vscode_settings \
   && \
  tas_gen_vscode_extensions \
   && \
  tas_gen_vscode_launch \
';

## もし npm がないかつ docker が入っているなら、docker コンテナで環境作って実行する
[ "$(which npm)" = '' -o "${TAS_USE_NPM_ON_DOCKER}" != '' ] && function npm() { docker compose run --rm node npm "${@}"; }

## もし npx がないかつ docker が入っているなら、docker コンテナで環境作って実行する
[ "$(which npx)" = '' -o "${TAS_USE_NPM_ON_DOCKER}" != '' ] && function npx() { docker compose run --rm node npx "${@}"; }
