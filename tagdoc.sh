#!/bin/bash
declare -r EDITOR=nano
declare -r EDIT_KEYWORD=edit
declare -r LIST_KEYWORD=list
declare -i COLOR=1
declare -r CONF="${0%.*}.conf"
declare -r SCR="${0##*/}"
declare -r AWK=$(which awk)
declare -r COLORCODE="\033[01;36m" #light cyan
# Text Color Variables http://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://github.com/tagd-tagd/tagdoc
if [[ -z "$AWK" ]];then
  echo "Error: awk not found, please install awk.";exit
fi
if [[ $# -eq 0 ]];then
  cat <<-EOF
  Search by tag1 && tag2 && ... in $CONF
  searching only by tags, not text body
  Usage: $SCR tag1 [tag2 ...[tagN]]
  Example:
  $SCR bcd ~> (seek bcd, abcd, bcde, abcde)
  $SCR _bcd ~> (seek bcd, bcde)
  $SCR bcd_ ~> (seek bcd, abcd)
  $SCR _bcd_ ~> (seek bcd)
  
  To edit conf:     $SCR edit
  To list all tags: $SCR list
EOF
  exit
fi
case "$1" in
  "$EDIT_KEYWORD") eval "$(which $EDITOR) $CONF";exit;;
  "$LIST_KEYWORD") awk '/^#/' "$CONF";exit;;
esac

$AWK 'BEGIN{split("'"$*"'",s," ");color='$COLOR'
  if(color){coloron="'"$COLORCODE"'";coloroff="\033[0m"}}
{if($0 ~ /^#/){
   k0=$0
   gsub(/^#/, "# ")
   for(i=2;i<=NF;i++){
     $i="_" $i "_"}
   p=1;c=1
   for(i in s){
     if($0 !~ s[i]){
       p=0
       break}}
   $0=k0}
 else{
   c=0}
 if(p){
   if(c){
     printf coloron >"/dev/stderr"
     print $0
     printf coloroff >"/dev/stderr"}
   else{
    print}
}}' "$CONF"
