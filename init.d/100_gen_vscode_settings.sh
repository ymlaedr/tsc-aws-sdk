#!/bin/bash

## vscode にまつわる設定ファイルの運用方法について
##   リポジトリを触るコミッターに合わせて自由に設定を弄れるようにしたいので以下の運用方針
##   - 基本的に *.base.jsonc で大本を残しておく
##   - このファイルに定義した関数で生成処理を担う

## extensions.json 生成元のパス
TAS_EXTENSIONS_JSON_BASE_PATH="${TAS_PRJ_DIR}/.vscode/extensions.base.jsonc";
## extensions.json 生成先のパス
TAS_EXTENSIONS_JSON_PATH="${TAS_PRJ_DIR}/.vscode/extensions.json";
## launch.json 生成元のパス
TAS_LAUNCH_JSON_BASE_PATH="${TAS_PRJ_DIR}/.vscode/launch.base.jsonc";
## launch.json 生成先のパス
TAS_LAUNCH_JSON_PATH="${TAS_PRJ_DIR}/.vscode/launch.json";
## settings.json 生成元のパス
TAS_SETTINGS_JSON_BASE_PATH="${TAS_PRJ_DIR}/.vscode/settings.base.jsonc";
## settings.json 生成先のパス
TAS_SETTINGS_JSON_PATH="${TAS_PRJ_DIR}/.vscode/settings.json";



function tas_gen_vscode_extensions() {

	## 変数確認: プロジェクトディレクトリ
	variable_exists ${BASH_SOURCE[0]##*/} TAS_PRJ_DIR;
	[ $? -gt 0 ] && return 1;

  ## ディレクトリが無いなら作る
	[ ! -d "${TAS_EXTENSIONS_JSON_PATH%/*}" ] && mkdir -p "${TAS_EXTENSIONS_JSON_PATH%/*}";
  ## ファイルを作る
	remove_json_comments "${TAS_EXTENSIONS_JSON_BASE_PATH}" > "${TAS_EXTENSIONS_JSON_PATH}";
}



function tas_gen_vscode_launch() {

	## 変数確認: プロジェクトディレクトリ
	variable_exists ${BASH_SOURCE[0]##*/} TAS_PRJ_DIR;
	[ $? -gt 0 ] && return 1;

  ## ディレクトリが無いなら作る
	[ ! -d "${TAS_LAUNCH_JSON_PATH%/*}" ] && mkdir -p "${TAS_LAUNCH_JSON_PATH%/*}";
  ## ファイルを作る
	remove_json_comments "${TAS_LAUNCH_JSON_BASE_PATH}" > "${TAS_LAUNCH_JSON_PATH}";
}



function tas_gen_vscode_settings() {

	## 変数確認: プロジェクトディレクトリ
	variable_exists ${BASH_SOURCE[0]##*/} TAS_PRJ_DIR;
	[ $? -gt 0 ] && return 1;

	## ディレクトリが無いなら作る
	[ ! -d "${TAS_SETTINGS_JSON_PATH%/*}" ] && mkdir -p "${TAS_SETTINGS_JSON_PATH%/*}";
	## ファイルを作る
	remove_json_comments "${TAS_SETTINGS_JSON_BASE_PATH}" > "${TAS_SETTINGS_JSON_PATH}";
}
