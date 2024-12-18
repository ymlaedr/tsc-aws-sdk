#!/bin/bash



## 文頭に青文字で INFO を出力
function echo_info() { echo "$(printf '\033[34m%s\033[m\n' 'INFO'): ${@}"; }
## 文頭に緑文字で SUCCESS を出力
function echo_success() { echo "$(printf '\033[32m%s\033[m\n' 'SUCCESS'): ${@}"; }
## 文頭に黄文字で WARNING を出力
function echo_warning() { echo "$(printf '\033[33m%s\033[m\n' 'WARNING'): ${@}"; }
## 文頭に赤文字で ERROR を出力
function echo_error() { echo "$(printf '\033[31m%s\033[m\n' 'ERROR'): ${@}"; }

## キャメルまたはパスカルケースからスネークケースへ変換
function camel_or_pascal_to_snake() { echo "${1}" | sed -E 's/(.)([A-Z])/\1_\2/g' | tr '[A-Z]' '[a-z]'; }
## キャメルまたはパスカルケースからケバブケースへ変換
function camel_or_pascal_to_kebab() { echo "${1}" | sed -E 's/(.)([A-Z])/\1-\2/g' | tr '[A-Z]' '[a-z]'; }
## スネークケースからパスカルケースへ変換
function snake_to_pascal() { echo "${1}" | awk -F '_' '{ for(i=1; i<=NF; i++) {printf toupper(substr($i,1,1)) substr($i,2)}} END {print ""}'; }
## ケバブケースからパスカルケースへ変換
function kebab_to_pascal() { echo "${1}" | awk -F '-' '{ for(i=1; i<=NF; i++) {printf toupper(substr($i,1,1)) substr($i,2)}} END {print ""}'; }
## スネークケースからキャメルケースへ変換
function snake_to_camel() { echo "${1}" | awk -F '_' '{ printf $1; for(i=2; i<=NF; i++) {printf toupper(substr($1,1,1)) substr($i,2)}} END {print ""}'; }
## ケバブケースからキャメルケースへ変換
function kebab_to_camel() { echo "${1}" | awk -F '-' '{ printf $1; for(i=2; i<=NF; i++) {printf toupper(substr($1,1,1)) substr($i,2)}} END {print ""}'; }

## 引数で受け取った変数名が存在しているか確認する
function variable_exist() {
	if [[ -v ${2} ]]; then
		return 0;
	else
		echo_error "[${1}] ${2} is not set.";
		return 1;
  fi
}

## 引数で受け取った変数名(複数)が存在しているか確認する
## 戻り値は存在しない数分返却される
function variable_exists() {
	SCRIPT_NAME="${1}";

	RESULT=0;
	for VARIABLE in "${@:2}";
	do
		variable_exist ${SCRIPT_NAME} ${VARIABLE};
		RESULT=$(( $? + ${RESULT} ));
	done
	return ${RESULT};
}

## 引数で受け取ったパスにある JSON ファイルからコメント部分を削除する
## 戻り値は jq コマンドで整形済みの文字列を返す
function remove_json_comments() { cat "${1}" | sed 's/^ *\/\/.*//' | jq .; }
