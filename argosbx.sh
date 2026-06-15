#!/bin/sh
export LANG=en_US.UTF-8

# ===== S1: 全局变量与初始化 =====
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; }
[ -z "${vwpt+x}" ] || { vwp=yes; vmag=yes; }
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${tupt+x}" ] || tup=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${vxpt+x}" ] || vxp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${sspt+x}" ] || ssp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${sopt+x}" ] || sop=yes
[ -z "${vupt+x}" ] || { vup=yes; vmag=yes; }
[ -z "${twpt+x}" ] || { twp=yes; vmag=yes; }
[ -z "${tuhpt+x}" ] || { tuhp=yes; vmag=yes; }
[ -z "${vgpt+x}" ] || vgp=yes
[ -z "${tgpt+x}" ] || tgp=yes
[ -z "${mgpt+x}" ] || mgp=yes
[ -z "${mupt+x}" ] || mup=yes
[ -z "${txpt+x}" ] || txp=yes
[ -z "${mxpt+x}" ] || mxp=yes
[ -z "${swpt+x}" ] || swp=yes
[ -z "${vwept+x}" ] || vwep=yes
[ -z "${stpt+x}" ] || stp=yes
[ -z "${napt+x}" ] || nap=yes
[ -z "${trpt+x}" ] || trp=yes
[ -z "${vtpt+x}" ] || vtp=yes
[ -z "${ttpt+x}" ] || ttp=yes
[ -z "${warp+x}" ] || wap=yes
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
if [ "$1" = "rep" ]; then
[ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || [ "$vup" = yes ] || [ "$twp" = yes ] || [ "$tuhp" = yes ] || [ "$vgp" = yes ] || [ "$tgp" = yes ] || [ "$mgp" = yes ] || [ "$mup" = yes ] || [ "$txp" = yes ] || [ "$mxp" = yes ] || [ "$swp" = yes ] || [ "$vwep" = yes ] || [ "$stp" = yes ] || [ "$nap" = yes ] || [ "$trp" = yes ] || [ "$vtp" = yes ] || [ "$ttp" = yes ] || { echo "提示：rep重置协议时，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
else
[ "$1" = "del" ] || [ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || [ "$vup" = yes ] || [ "$twp" = yes ] || [ "$tuhp" = yes ] || [ "$vgp" = yes ] || [ "$tgp" = yes ] || [ "$mgp" = yes ] || [ "$mup" = yes ] || [ "$txp" = yes ] || [ "$mxp" = yes ] || [ "$swp" = yes ] || [ "$vwep" = yes ] || [ "$stp" = yes ] || [ "$nap" = yes ] || [ "$trp" = yes ] || [ "$vtp" = yes ] || [ "$ttp" = yes ] || { echo "提示：未安装argosbx脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_vw=${vwpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export port_xh=${xhpt:-''}
export port_vx=${vxpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_ss=${sspt:-''}
export port_so=${sopt:-''}
export port_st=${stpt:-''}
export port_na=${napt:-''}
export port_tr=${trpt:-''}
export port_vtv=${vtpt:-''}
export port_tt=${ttpt:-''}
export nap_user=${nap_user:-''}
export stls_dest=${stdst:-''}
export ym_vl_re=${reym:-''}
export cdnym=${cdnym:-''}
export directnym=${directnym:-''}
export basepath=${basepath:-''}
export cfapi=${cfapi:-''}
export cfzone=${cfzone:-''}
export argo=${argo:-''}
export argopro=${argopro:-''}
export ARGO_DOMAIN=${agn:-''}
export ARGO_AUTH=${agk:-''}
export ippz=${ippz:-''}
export warp=${warp:-''}
export name=${name:-''}
export oap=${oap:-''}
v46url="https://icanhazip.com"
agsbxurl="https://raw.githubusercontent.com/Be90nia/argosbx/main/argosbx.sh"
tplbaseurl="https://raw.githubusercontent.com/Be90nia/argosbx/main/templates"
showmode(){
echo "Argosbx脚本一键SSH命令生器在线网址：https://yonggekkk.github.io/argosbx/"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/Be90nia/argosbx/main/argosbx.sh) 或 bash <(wget -qO- https://raw.githubusercontent.com/Be90nia/argosbx/main/argosbx.sh)"  
echo "显示节点信息命令：agsbx list 【或者】 主脚本 list"
echo "重置变量组命令：自定义各种协议变量组 agsbx rep 【或者】 自定义各种协议变量组 主脚本 rep"
echo "更新脚本命令：原已安装的自定义各种协议变量组 主脚本 rep"
echo "更新Xray、Singbox或Cloudflared内核命令：agsbx upx、ups或upc 【或者】 主脚本 upx、ups或upc"
echo "重启脚本命令：agsbx res 【或者】 主脚本 res"
echo "卸载脚本命令：agsbx del 【或者】 主脚本 del"
echo "双栈VPS显示IPv4/IPv6节点配置命令：ippz=4或6 agsbx list 【或者】 ippz=4或6 主脚本 list"
echo "---------------------------------------------------------"
echo
}

# ===== S2: 工具函数库 =====

# dl url file — curl/wget双轨下载到文件
dl() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$2" --retry 2 "$1" && return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -O "$2" --tries=2 "$1" && return 0
  fi
  return 1
}

# dl_s url — curl/wget双轨下载到stdout
dl_s() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" 2>/dev/null && return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$1" 2>/dev/null && return 0
  fi
  return 1
}

# alloc_port portvar — 端口分配(随机/指定/持久化)
alloc_port() {
  local _apvar="$1"
  local _apval
  eval _apval="\$$_apvar"
  local _apfile="$HOME/agsbx/$_apvar"
  if [ -z "$_apval" ] && [ ! -e "$_apfile" ]; then
    eval "$_apvar=\$(shuf -i 10000-65535 -n 1)"
    eval "echo \"\$$_apvar\" > \"$_apfile\""
  elif [ -n "$_apval" ]; then
    eval "echo \"\$$_apvar\" > \"$_apfile\""
  fi
  eval "$_apvar=\$(cat \"$_apfile\")"
}

# gen_basepath — 生成或读取basepath(用户指定 or 随机16位hex，持久化)
gen_basepath() {
  mkdir -p "$HOME/agsbx"
  if [ -z "$basepath" ] && [ ! -e "$HOME/agsbx/basepath" ]; then
    basepath=$(head -c 32 /dev/urandom | sha256sum | cut -c 1-16)
    echo "$basepath" > "$HOME/agsbx/basepath"
  elif [ -n "$basepath" ]; then
    echo "$basepath" > "$HOME/agsbx/basepath"
  fi
  basepath=$(cat "$HOME/agsbx/basepath")
}

# parse_argopro — 解析argopro变量为argo_xxx标志(兼容旧argo变量)
# 支持的协议缩写: vw vx vm vu tw tu mu tx mx sw (不含gRPC，CF Tunnel bug #1641)
parse_argopro() {
  # 兼容旧argo变量: argo=vwpt/vmpt/vxpt → argopro=vw/vm/vx
  if [ -z "$argopro" ] && [ -n "$argo" ]; then
    case $argo in
      vwpt) argopro=vw ;;
      vmpt) argopro=vm ;;
      vxpt) argopro=vx ;;
    esac
  fi
  # all=全部10个按path分发的CDN协议
  if [ "$argopro" = "all" ]; then
    argopro="vw,vx,vm,vu,tw,tu,mu,tx,mx,sw"
  fi
  # 解析逗号分隔列表为独立标志
  if [ -n "$argopro" ]; then
    for _p in $(echo "$argopro" | tr ',' ' '); do
      case $_p in
        vw|vx|vm|vu|tw|tu|mu|tx|mx|sw) eval "argo_$_p=1" ;;
      esac
    done
  fi
}

# argopro_setup — 构建Argo选中协议的端口映射，设置argoport.log(临时隧道首协议)和argo_cf_rules(CF Dashboard配置指引)
argopro_setup() {
  _xrjson="$HOME/agsbx/xr.json"
  argo_first_port=""
  argo_cf_rules=""
  argo_count=0
  # vw: VLESS+WS (tag=vless-ws, port=port_vw动态)
  if [ -n "$argo_vw" ] && grep -q 'vless-ws' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vw | HTTP | localhost:${port_vw}\\n"
    [ -z "$argo_first_port" ] && argo_first_port="$port_vw"; argo_count=$((argo_count+1))
  fi
  # vx: VLESS+XHTTP (tag=vless-xhttp, port=2053固定)
  if [ -n "$argo_vx" ] && grep -q 'vless-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vx | HTTP | localhost:2053\\n"
    [ -z "$argo_first_port" ] && argo_first_port=2053; argo_count=$((argo_count+1))
  fi
  # vm: VMess+WS (tag=vmess-xr, port=2083固定)
  if [ -n "$argo_vm" ] && grep -q 'vmess-xr' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vm | HTTP | localhost:2083\\n"
    [ -z "$argo_first_port" ] && argo_first_port=2083; argo_count=$((argo_count+1))
  fi
  # vu: VLESS+HTTPUpgrade+ENC (tag=vless-httpupgrade, port=2087固定)
  if [ -n "$argo_vu" ] && grep -q 'vless-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vu | HTTP | localhost:2087\\n"
    [ -z "$argo_first_port" ] && argo_first_port=2087; argo_count=$((argo_count+1))
  fi
  # tw: Trojan+WS (tag=trojan-ws, port=2096固定)
  if [ -n "$argo_tw" ] && grep -q 'trojan-ws' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tw | HTTP | localhost:2096\\n"
    [ -z "$argo_first_port" ] && argo_first_port=2096; argo_count=$((argo_count+1))
  fi
  # tu: Trojan+HTTPUpgrade (tag=trojan-httpupgrade, port=8443固定)
  if [ -n "$argo_tu" ] && grep -q 'trojan-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tu | HTTP | localhost:8443\\n"
    [ -z "$argo_first_port" ] && argo_first_port=8443; argo_count=$((argo_count+1))
  fi
  # mu: VMess+HTTPUpgrade (tag=vmess-httpupgrade, port=39000固定, B组)
  if [ -n "$argo_mu" ] && grep -q 'vmess-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-mu | HTTP | localhost:39000\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39000; argo_count=$((argo_count+1))
  fi
  # tx: Trojan+XHTTP (tag=trojan-xhttp, port=39001固定, B组)
  if [ -n "$argo_tx" ] && grep -q 'trojan-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tx | HTTP | localhost:39001\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39001; argo_count=$((argo_count+1))
  fi
  # mx: VMess+XHTTP (tag=vmess-xhttp, port=39002固定, B组)
  if [ -n "$argo_mx" ] && grep -q 'vmess-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-mx | HTTP | localhost:39002\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39002; argo_count=$((argo_count+1))
  fi
  # sw: SS+WS (tag=ss-ws, port=39003固定, B组)
  if [ -n "$argo_sw" ] && grep -q 'ss-ws' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-sw | HTTP | localhost:39003\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39003; argo_count=$((argo_count+1))
  fi
  echo "$argo_first_port" > "$HOME/agsbx/argoport.log"
  # 持久化选中Argo的已安装协议缩写列表(cip函数读取)
  argo_sel_list=""
  for _p in vw vx vm vu tw tu mu tx mx sw; do
    eval "_flag=\$argo_$_p"
    if [ -n "$_flag" ]; then
      case $_p in
        vw) grep -q 'vless-ws' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vw" ;;
        vx) grep -q 'vless-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vx" ;;
        vm) grep -q 'vmess-xr' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vm" ;;
        vu) grep -q 'vless-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vu" ;;
        tw) grep -q 'trojan-ws' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tw" ;;
        tu) grep -q 'trojan-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tu" ;;
        mu) grep -q 'vmess-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list mu" ;;
        tx) grep -q 'trojan-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tx" ;;
        mx) grep -q 'vmess-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list mx" ;;
        sw) grep -q 'ss-ws' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list sw" ;;
      esac
    fi
  done
  echo "$argo_sel_list" > "$HOME/agsbx/argopro_sel.log"
}

# certsign 域名 证书名 — 使用acme.sh + CF DNS API签发TLS证书(含泛域名)
certsign() {
  local _csdomain="$1"
  local _csprefix="$2"
  local _cscrt="/etc/argosbx/certs/${_csprefix}.crt"
  local _cskey="/etc/argosbx/certs/${_csprefix}.key"
  local _acme="$HOME/.acme.sh/acme.sh"
  mkdir -p /etc/argosbx/certs
  if [ -f "$_cscrt" ] && [ -f "$_cskey" ]; then
    echo "证书已存在: $_cscrt"
    return 0
  fi
  if [ ! -e "$_acme" ]; then
    echo "安装acme.sh..."
    dl https://get.acme.sh "$HOME/agsbx/acme_install.sh" && sh "$HOME/agsbx/acme_install.sh" && rm -f "$HOME/agsbx/acme_install.sh"
  fi
  if [ ! -e "$_acme" ]; then
    echo "⚠️ acme.sh安装失败，无法签发证书"
    return 1
  fi
  export CF_Token="$cfapi"
  export CF_Zone_ID="$cfzone"
  echo "签发证书: $_csdomain (含泛域名)..."
  local _csretry=0
  while [ "$_csretry" -lt 3 ]; do
    if "$_acme" --issue -d "$_csdomain" -d "*.$_csdomain" --dns dns_cf; then
      break
    fi
    _csretry=$((_csretry + 1))
    if [ "$_csretry" -lt 3 ]; then
      echo "签发重试(${_csretry}/3)，等待30秒..."
      sleep 30
    fi
  done
  if [ "$_csretry" -ge 3 ]; then
    echo "⚠️ 证书签发失败: $_csdomain（已重试3次）"
    unset CF_Token CF_Zone_ID
    return 1
  fi
  "$_acme" --install-cert -d "$_csdomain" -d "*.$_csdomain" \
    --key-file "$_cskey" \
    --fullchain-file "$_cscrt" \
    --reloadcmd "if command -v systemctl >/dev/null 2>&1; then systemctl restart xray sing-box 2>/dev/null; elif command -v rc-service >/dev/null 2>&1; then rc-service xray restart 2>/dev/null; rc-service sing-box restart 2>/dev/null; fi"
  unset CF_Token CF_Zone_ID
  echo "✅ 证书签发成功: $_csdomain → $_cscrt"
}

# tpl_xr 模板名 — 加载xray inbound模板(下载/缓存)，替换占位符，追加到xr.json(末尾加逗号)
tpl_xr() {
  local _tplname="$1"
  local _tpldir="$HOME/agsbx/templates/xr"
  local _tplfile="$_tpldir/$_tplname.json"
  mkdir -p "$_tpldir"
  if [ ! -f "$_tplfile" ]; then
    dl "$tplbaseurl/xr/$_tplname.json" "$_tplfile" || { echo "⚠️ 模板下载失败: $_tplname"; return 1; }
  fi
  sed -e "s|__UUID__|${uuid}|g" \
      -e "s|__BASEPATH__|${basepath}|g" \
      -e "s|__DEKEY__|${dekey}|g" \
      -e "s|__SSKEY__|${sskey}|g" \
      "$_tplfile" | sed '$s/$/,/' >> "$HOME/agsbx/xr.json"
}

# ===== S3: 系统初始化 =====
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "甬哥Github项目 ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx一键无交互小钢炮脚本💣"
echo "当前版本：V26.5.10"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
arm64|aarch64) cpu=arm64;;
amd64|x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
if [ "$1" != "del" ]; then
mkdir -p "$HOME/agsbx"
if [ ! -f sbx_update ]; then
echo "执行必要的脚本依赖中，请稍等10秒……"
if command -v apk >/dev/null 2>&1; then
apk update >/dev/null 2>&1 && apk add --no-cache bash busybox-extras gcompat libc6-compat iptables >/dev/null 2>&1
elif command -v apt >/dev/null 2>&1; then
export DEBIAN_FRONTEND=noninteractive
printf 'iptables-persistent iptables-persistent/autosave_v4 boolean true\niptables-persistent iptables-persistent/autosave_v6 boolean true\n' | debconf-set-selections
apt update >/dev/null 2>&1 && apt install -y busybox coreutils util-linux iptables iptables-persistent cron >/dev/null 2>&1
fi
touch sbx_update
fi
fi
v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- "$v46url" 2>/dev/null) )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- "$v46url" 2>/dev/null) )
v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) )
v6dq=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
}
warpsx(){
warpurl=$( (command -v curl >/dev/null 2>&1 && curl -sm5 -k https://warp.xijp.eu.org 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget --tries=2 -qO- https://warp.xijp.eu.org 2>/dev/null) )
if [ -z "$warpurl" ] || printf '%s' "$warpurl" | grep -q html; then
wpv6='2606:4700:110:8d8d:1845:c39f:2dd5:a03a'
pvk='52cuYFgCJXp0LAq7+nWJIbCXXgU9eGggOc+Hlfz5u6A='
res='[215, 69, 233]'
else
pvk=$(echo "$warpurl" | awk -F'：' '/Private_key/{print $2}' | xargs)
wpv6=$(echo "$warpurl" | awk -F'：' '/IPV6/{print $2}' | xargs)
res=$(echo "$warpurl" | awk -F'：' '/reserved/{print $2}' | xargs)
fi
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsbx/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
if echo "$v6" | grep -q '^2a09' || echo "$v4" | grep -q '^104.28'; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
echo; echo "请注意：你已安装了warp"
else
if [ "$wap" != yes ]; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
else
case "$warp" in
""|sx|xs) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s ) s1outtag=warp-out; s2outtag=warp-out; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
x ) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x4) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x6) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4x4|x4s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s4x6|x6s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6x4|x4s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
s6x6|x6s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0"'; wap=warp ;;
sx4|x4s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
sx6|x6s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
xs4|s4x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
xs6|s6x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
* ) s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo ;;
esac
fi
fi
case "$warp" in *x4*) wxryx='ForceIPv4' ;; *x6*) wxryx='ForceIPv6' ;; *) wxryx='ForceIPv6v4' ;; esac
if command -v curl >/dev/null 2>&1; then
curl -s4m5 -k "$v46url" >/dev/null 2>&1 && v4_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -4 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v4_ok=true
fi
if command -v curl >/dev/null 2>&1; then
curl -s6m5 -k "$v46url" >/dev/null 2>&1 && v6_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -6 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v6_ok=true
fi
if [ "$v4_ok" = true ] && [ "$v6_ok" = true ]; then
case "$warp" in *s4*) sbyx='prefer_ipv4' ;; *) sbyx='prefer_ipv6' ;; esac
case "$warp" in *x4*) xryx='ForceIPv4v6' ;; *x*) xryx='ForceIPv6v4' ;; *) xryx='ForceIPv4v6' ;; esac
elif [ "$v4_ok" = true ] && [ "$v6_ok" != true ]; then
case "$warp" in *s4*|x) sbyx='ipv4_only' ;; *) sbyx='prefer_ipv6' ;; esac
case "$warp" in *x4*) xryx='ForceIPv4' ;; *x*) xryx='ForceIPv6v4' ;; *) xryx='ForceIPv4v6' ;; esac
elif [ "$v4_ok" != true ] && [ "$v6_ok" = true ]; then
case "$warp" in *s6*|x) sbyx='ipv6_only' ;; *) sbyx='prefer_ipv4' ;; esac
case "$warp" in *x6*) xryx='ForceIPv6' ;; *x*) xryx='ForceIPv4v6' ;; *) xryx='ForceIPv6v4' ;; esac
fi
}

# ===== S4: 内核下载 =====
upxray(){
xrarch="64"
[ "$cpu" = "arm64" ] && xrarch="arm64-v8a"
xrcore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/XTLS/Xray-core" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Xray官方最新正式版内核：$xrcore"
tmpdir=$(mktemp -d)
url="https://github.com/XTLS/Xray-core/releases/download/v${xrcore}/Xray-linux-${xrarch}.zip"
out="$tmpdir/xray.zip"
dl "$url" "$out"
if [ -f "$out" ]; then
  command -v unzip >/dev/null 2>&1 || { command -v apk >/dev/null 2>&1 && apk add --no-cache unzip >/dev/null 2>&1; } || { command -v apt >/dev/null 2>&1 && apt install -y unzip >/dev/null 2>&1; }
  unzip -o "$out" -d "$tmpdir/xray_extract" >/dev/null 2>&1
  mv "$tmpdir/xray_extract/xray" "$HOME/agsbx/xray" 2>/dev/null
  chmod +x "$HOME/agsbx/xray"
  rm -rf "$tmpdir"
fi
sbcore=$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
}
upsingbox(){
sbarch="$cpu"
sbcore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/SagerNet/sing-box" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Sing-box官方最新正式版内核：$sbcore"
tmpdir=$(mktemp -d)
url="https://github.com/SagerNet/sing-box/releases/download/v${sbcore}/sing-box-${sbcore}-linux-${sbarch}.tar.gz"
out="$tmpdir/sing-box.tar.gz"
dl "$url" "$out"
if [ -f "$out" ]; then
  tar -xzf "$out" -C "$tmpdir" >/dev/null 2>&1
  mv "$tmpdir/sing-box-${sbcore}-linux-${sbarch}/sing-box" "$HOME/agsbx/sing-box" 2>/dev/null
  chmod +x "$HOME/agsbx/sing-box"
  rm -rf "$tmpdir"
fi
sbcore=$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
}
upcloudflared(){
argocore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Cloudflared官方最新正式版内核：$argocore"
url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu"
out="$HOME/agsbx/cloudflared"
dl "$url" "$out"
chmod +x "$HOME/agsbx/cloudflared"
echo "已安装Cloudflared正式版内核：$argocore"
}

# ===== S5: 密钥生成与配置生成 =====
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsbx/uuid" ]; then
if [ -e "$HOME/agsbx/sing-box" ]; then
uuid=$("$HOME/agsbx/sing-box" generate uuid)
else
uuid=$("$HOME/agsbx/xray" uuid)
fi
echo "$uuid" > "$HOME/agsbx/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsbx/uuid"
fi
uuid=$(cat "$HOME/agsbx/uuid")
echo "UUID密码：$uuid"
}
installxray(){
echo
echo "=========启用xray内核========="
mkdir -p "$HOME/agsbx/xrk"
if [ ! -e "$HOME/agsbx/xray" ]; then
upxray
fi
cat > "$HOME/agsbx/xr.json" <<EOF
{
  "log": {
  "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ] || [ -n "$trp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
if [ ! -e "$HOME/agsbx/xrk/private_key" ]; then
key_pair=$("$HOME/agsbx/xray" x25519)
private_key=$(echo "$key_pair" | awk -F':' '/PrivateKey/ {print $2}' | xargs)
public_key=$(echo "$key_pair" | awk -F':' '/Password/ {print $2}' | xargs)
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/agsbx/xrk/private_key"
echo "$public_key" > "$HOME/agsbx/xrk/public_key"
echo "$short_id" > "$HOME/agsbx/xrk/short_id"
fi
private_key_x=$(cat "$HOME/agsbx/xrk/private_key")
public_key_x=$(cat "$HOME/agsbx/xrk/public_key")
short_id_x=$(cat "$HOME/agsbx/xrk/short_id")
fi
if [ -n "$xhp" ] || [ -n "$vxp" ] || [ -n "$vwp" ] || [ -n "$vup" ] || [ -n "$vgp" ] || [ -n "$vwep" ]; then
if [ ! -e "$HOME/agsbx/xrk/dekey" ]; then
vlkey=$("$HOME/agsbx/xray" vlessenc)
dekey=$(echo "$vlkey" | grep '"decryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
enkey=$(echo "$vlkey" | grep '"encryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
echo "$dekey" > "$HOME/agsbx/xrk/dekey"
echo "$enkey" > "$HOME/agsbx/xrk/enkey"
fi
  dekey=$(cat "$HOME/agsbx/xrk/dekey")
  enkey=$(cat "$HOME/agsbx/xrk/enkey")
fi

# basepath生成(CDN协议path和gRPC serviceName需要)
if [ -n "$vxp" ] || [ -n "$vwp" ] || [ -n "$vup" ] || [ -n "$twp" ] || [ -n "$tuhp" ] || [ -n "$vgp" ] || [ -n "$tgp" ] || [ -n "$mgp" ] || [ -n "$mup" ] || [ -n "$txp" ] || [ -n "$mxp" ] || [ -n "$swp" ] || [ -n "$vwep" ]; then
  gen_basepath
  echo "Basepath: $basepath"
fi

if [ -n "$xhp" ]; then
xhp=xhpt
alloc_port port_xh
 echo "Vless-xhttp-reality-enc端口：$port_xh"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptargo
fi
# cdnym持久化(任何CDN协议启用时统一处理)
if [ -n "$cdnym" ] && { [ -n "$vxp" ] || [ -n "$vwp" ] || [ -n "$vup" ] || [ -n "$twp" ] || [ -n "$tuhp" ]; }; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "CDN host域名: $cdnym"
fi
if [ -n "$vxp" ]; then
vxp=vxpt
 echo "Vless-xhttp-enc端口：2053 (CF HTTPS固定端口)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-xhttp",
      "listen": "::",
      "port": 2053,
      "protocol": "vless",
      "settings": {
        "users": [
          {
            "id": "${uuid}"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "tls",
        "xhttpSettings": {
          "host": "",
          "path": "/${basepath}-vx",
          "mode": "packet-up"
        },
        "tlsSettings": {
          "certificates": [{
            "certificateFile": "/etc/argosbx/certs/cdnym.crt",
            "keyFile": "/etc/argosbx/certs/cdnym.key"
          }],
          "alpn": ["h2", "http/1.1"]
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vxp=vxptargo
fi
if [ -n "$vwp" ]; then
vwp=vwpt
 echo "Vless-ws端口：443 (CF HTTPS主端口, 含gRPC fallbacks)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-ws",
      "listen": "::",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "users": [
          {
            "id": "${uuid}"
          }
        ],
        "decryption": "none",
        "fallbacks": [
EOF
if [ -n "$vgp" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
          {"alpn":"h2","path":"/${basepath}-vg","dest":"@vless-grpc","xver":0},
EOF
fi
if [ -n "$tgp" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
          {"alpn":"h2","path":"/${basepath}-tg","dest":"@trojan-grpc","xver":0},
EOF
fi
if [ -n "$mgp" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
          {"alpn":"h2","path":"/${basepath}-mg","dest":"@vmess-grpc","xver":0},
EOF
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
          {"dest":444}
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "/${basepath}-vw",
          "host": ""
        },
        "tlsSettings": {
          "certificates": [{
            "certificateFile": "/etc/argosbx/certs/cdnym.crt",
            "keyFile": "/etc/argosbx/certs/cdnym.key"
          }],
          "alpn": ["h2", "http/1.1"]
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vwp=vwptargo
fi
if [ -n "$vup" ]; then
vup=vupt
 echo "Vless-httpupgrade-enc端口：2087 (CF HTTPS固定端口)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-httpupgrade",
      "listen": "::",
      "port": 2087,
      "protocol": "vless",
      "settings": {
        "users": [
          {
            "id": "${uuid}"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "httpupgrade",
        "security": "tls",
        "httpupgradeSettings": {
          "path": "/${basepath}-vu",
          "host": ""
        },
        "tlsSettings": {
          "certificates": [{
            "certificateFile": "/etc/argosbx/certs/cdnym.crt",
            "keyFile": "/etc/argosbx/certs/cdnym.key"
          }],
          "alpn": ["h2", "http/1.1"]
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vup=vuptargo
fi
if [ -n "$twp" ]; then
twp=twpt
 echo "Trojan-ws端口：2096 (CF HTTPS固定端口)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"trojan-ws",
      "listen": "::",
      "port": 2096,
      "protocol": "trojan",
      "settings": {
        "users": [
          {
            "password": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "/${basepath}-tw",
          "host": ""
        },
        "tlsSettings": {
          "certificates": [{
            "certificateFile": "/etc/argosbx/certs/cdnym.crt",
            "keyFile": "/etc/argosbx/certs/cdnym.key"
          }],
          "alpn": ["h2", "http/1.1"]
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
twp=twptargo
fi
if [ -n "$tuhp" ]; then
tuhp=tuhpt
 echo "Trojan-httpupgrade端口：8443 (CF HTTPS固定端口)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"trojan-httpupgrade",
      "listen": "::",
      "port": 8443,
      "protocol": "trojan",
      "settings": {
        "users": [
          {
            "password": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "httpupgrade",
        "security": "tls",
        "httpupgradeSettings": {
          "path": "/${basepath}-tuh",
          "host": ""
        },
        "tlsSettings": {
          "certificates": [{
            "certificateFile": "/etc/argosbx/certs/cdnym.crt",
            "keyFile": "/etc/argosbx/certs/cdnym.key"
          }],
          "alpn": ["h2", "http/1.1"]
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
tuhp=tuhptargo
fi
if [ -n "$vgp" ]; then
vgp=vgpt
 echo "Vless-grpc-enc：443 fallbacks转发 (Unix socket @vless-grpc, TLS在443终止)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-grpc",
      "listen": "@vless-grpc",
      "protocol": "vless",
      "settings": {
        "users": [
          {
            "id": "${uuid}"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "${basepath}-vg",
          "multiMode": true
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vgp=vgptargo
fi
if [ -n "$tgp" ]; then
tgp=tgpt
 echo "Trojan-grpc：443 fallbacks转发 (Unix socket @trojan-grpc, TLS在443终止)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"trojan-grpc",
      "listen": "@trojan-grpc",
      "protocol": "trojan",
      "settings": {
        "users": [
          {
            "password": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "${basepath}-tg",
          "multiMode": true
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
tgp=tgptargo
fi
if [ -n "$mgp" ]; then
mgp=mgpt
 echo "Vmess-grpc：443 fallbacks转发 (Unix socket @vmess-grpc, TLS在443终止)"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vmess-grpc",
      "listen": "@vmess-grpc",
      "protocol": "vmess",
      "settings": {
        "users": [
          {
            "id": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "${basepath}-mg",
          "multiMode": true
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
mgp=mgptargo
fi
if [ -n "$mup" ]; then
mup=mupt
 echo "VMess-httpupgrade端口：39000 (B组Origin Rules回源端口)"
 tpl_xr b-mu-httpupgrade
fi
if [ -n "$txp" ]; then
txp=txpt
 echo "Trojan-xhttp端口：39001 (B组Origin Rules回源端口)"
 tpl_xr b-tx-xhttp
fi
if [ -n "$mxp" ]; then
mxp=mxpt
 echo "VMess-xhttp端口：39002 (B组Origin Rules回源端口)"
 tpl_xr b-mx-xhttp
fi
if [ -n "$swp" ]; then
swp=swpt
 if [ ! -e "$HOME/agsbx/sskey" ]; then
 sskey=$("$HOME/agsbx/sing-box" generate rand 16 --base64)
 echo "$sskey" > "$HOME/agsbx/sskey"
 fi
 sskey=$(cat "$HOME/agsbx/sskey")
 echo "Shadowsocks-ws端口：39003 (B组Origin Rules回源端口)"
 tpl_xr b-sw-ws
fi
if [ -n "$vwep" ]; then
vwep=vwept
 echo "Vless-ws-enc端口：39004 (B组Origin Rules回源端口，支持ENC加密)"
 tpl_xr b-vwe-ws-enc
fi
if [ -n "$vlp" ]; then
vlp=vlpt
alloc_port port_vl_re
 echo "Vless-tcp-reality-v端口：$port_vl_re"
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptargo
fi
if [ -n "$trp" ]; then
  trp=trpt
  [ -z "$ym_vl_re" ] && ym_vl_re=apple.com
  echo "Reality域名：$ym_vl_re"
  alloc_port port_tr
  echo "Trojan+Reality端口：$port_tr"
  cat >> "$HOME/agsbx/xr.json" <<EOF
        {
          "tag": "trojan-reality",
          "listen": "::",
          "port": ${port_tr},
          "protocol": "trojan",
          "settings": {
            "users": [{ "password": "${uuid}" }]
          },
          "streamSettings": {
            "network": "tcp",
            "security": "reality",
            "realitySettings": {
              "dest": "${ym_vl_re}:443",
              "serverNames": ["${ym_vl_re}"],
              "privateKey": "$private_key_x",
              "shortIds": ["$short_id_x"]
            }
          },
          "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
          }
        },
EOF
fi
if [ -n "$vtp" ]; then
  vtp=vtpt
  alloc_port port_vtv
  echo "VLESS+TLS+Vision端口：$port_vtv"
  cat >> "$HOME/agsbx/xr.json" <<EOF
        {
          "tag": "vless-tls-vision",
          "listen": "::",
          "port": ${port_vtv},
          "protocol": "vless",
          "settings": {
            "users": [{ "id": "${uuid}", "flow": "xtls-rprx-vision" }],
            "decryption": "none"
          },
          "streamSettings": {
            "network": "tcp",
            "security": "tls",
            "tlsSettings": {
              "certificates": [{
                "certificateFile": "/etc/argosbx/certs/directnym.crt",
                "keyFile": "/etc/argosbx/certs/directnym.key"
              }],
              "alpn": ["http/1.1"]
            }
          },
          "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
          }
        },
EOF
fi
if [ -n "$ttp" ]; then
  ttp=ttpt
  alloc_port port_tt
  echo "Trojan+TLS端口：$port_tt"
  cat >> "$HOME/agsbx/xr.json" <<EOF
        {
          "tag": "trojan-tls",
          "listen": "::",
          "port": ${port_tt},
          "protocol": "trojan",
          "settings": {
            "users": [{ "password": "${uuid}" }]
          },
          "streamSettings": {
            "network": "tcp",
            "security": "tls",
            "tlsSettings": {
              "certificates": [{
                "certificateFile": "/etc/argosbx/certs/directnym.crt",
                "keyFile": "/etc/argosbx/certs/directnym.key"
              }],
              "alpn": ["http/1.1"]
            }
          },
          "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
          }
        },
EOF
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsbx/sing-box" ]; then
upsingbox
fi
cat > "$HOME/agsbx/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
if [ ! -f "$HOME/agsbx/SHA256.txt" ]; then
command -v openssl >/dev/null 2>&1 && openssl ecparam -genkey -name prime256v1 -out "$HOME/agsbx/private.key" >/dev/null 2>&1
command -v openssl >/dev/null 2>&1 && openssl req -new -x509 -days 36500 -key "$HOME/agsbx/private.key" -out "$HOME/agsbx/cert.crt" -subj "/CN=www.bing.com" >/dev/null 2>&1
if [ ! -f "$HOME/agsbx/private.key" ]; then
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/private.key"; out="$HOME/agsbx/private.key"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -q -O "$out" --tries=2 "$url")
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/cert.crt"; out="$HOME/agsbx/cert.crt"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -q -O "$out" --tries=2 "$url")
echo "fc6dca8cfc4081102aa9655d0d4805c27d7266f605541d242ad66ad00a284a35" > "$HOME/agsbx/SHA256.txt"
else
SHA256=$(openssl x509 -in $HOME/agsbx/cert.crt -outform DER | sha256sum | awk '{print $1}')
echo "$SHA256" > "$HOME/agsbx/SHA256.txt"
fi
fi
if [ -n "$hyp" ]; then
hyp=hypt
alloc_port port_hy2
 echo "Hysteria2端口：$port_hy2"
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "$HOME/agsbx/cert.crt",
            "key_path": "$HOME/agsbx/private.key"
        }
    },
EOF
else
hyp=hyptargo
fi
if [ -n "$tup" ]; then
tup=tupt
alloc_port port_tu
 echo "Tuic端口：$port_tu"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "$HOME/agsbx/cert.crt",
                "key_path": "$HOME/agsbx/private.key"
            }
        },
EOF
else
tup=tuptargo
fi
if [ -n "$anp" ]; then
anp=anpt
alloc_port port_an
 echo "Anytls端口：$port_an"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls":{
                "enabled": true,
                "certificate_path": "$HOME/agsbx/cert.crt",
                "key_path": "$HOME/agsbx/private.key"
            }
        },
EOF
else
anp=anptargo
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsbx/sbk"
if [ ! -e "$HOME/agsbx/sbk/private_key" ]; then
key_pair=$("$HOME/agsbx/sing-box" generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$("$HOME/agsbx/sing-box" generate rand --hex 4)
echo "$private_key" > "$HOME/agsbx/sbk/private_key"
echo "$public_key" > "$HOME/agsbx/sbk/public_key"
echo "$short_id" > "$HOME/agsbx/sbk/short_id"
fi
private_key_s=$(cat "$HOME/agsbx/sbk/private_key")
public_key_s=$(cat "$HOME/agsbx/sbk/public_key")
short_id_s=$(cat "$HOME/agsbx/sbk/short_id")
alloc_port port_ar
 echo "Any-Reality端口：$port_ar"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptargo
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/agsbx/sskey" ]; then
sskey=$("$HOME/agsbx/sing-box" generate rand 16 --base64)
echo "$sskey" > "$HOME/agsbx/sskey"
fi
alloc_port port_ss
 sskey=$(cat "$HOME/agsbx/sskey")
 echo "Shadowsocks-2022端口：$port_ss"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type": "shadowsocks",
            "tag":"ss-2022",
            "listen": "::",
            "listen_port": $port_ss,
            "method": "2022-blake3-aes-128-gcm",
            "password": "$sskey"
    },  
EOF
else
ssp=ssptargo
fi
if [ -n "$stp" ]; then
  stp=stpt
  if [ ! -e "$HOME/agsbx/stlspass" ]; then
    stlspass=$("$HOME/agsbx/sing-box" generate rand 16 --base64)
    echo "$stlspass" > "$HOME/agsbx/stlspass"
  fi
  if [ ! -e "$HOME/agsbx/ssintkey" ]; then
    ssintkey=$("$HOME/agsbx/sing-box" generate rand 32 --base64)
    echo "$ssintkey" > "$HOME/agsbx/ssintkey"
  fi
  stlspass=$(cat "$HOME/agsbx/stlspass")
  ssintkey=$(cat "$HOME/agsbx/ssintkey")
  [ -z "$stls_dest" ] && stls_dest=www.microsoft.com
  alloc_port port_st
  echo "ShadowTLS端口：$port_st (伪装目标: $stls_dest)"
  cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type": "shadowtls",
            "tag": "stls-in",
            "listen": "::",
            "listen_port": ${port_st},
            "version": 3,
            "password": "${stlspass}",
            "tls": {
                "server_name": "${stls_dest}"
            },
            "detour": "ss-internal-in"
        },
        {
            "type": "shadowsocks",
            "tag": "ss-internal-in",
            "listen": "127.0.0.1",
            "listen_port": 0,
            "method": "2022-blake3-aes-256-gcm",
            "password": "${ssintkey}"
        },
EOF
fi
if [ -n "$nap" ]; then
  nap=napt
  [ -z "$nap_user" ] && nap_user=$("$HOME/agsbx/sing-box" generate rand 8)
  echo "$nap_user" > "$HOME/agsbx/nap_user"
  alloc_port port_na
  echo "Naive端口：$port_na"
  cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type": "naive",
            "tag": "naive-in",
            "listen": "::",
            "listen_port": ${port_na},
            "users": [
                {
                    "username": "${nap_user}",
                    "password": "${uuid}"
                }
            ],
            "tls": {
                "enabled": true,
                "certificate_path": "$HOME/agsbx/cert.crt",
                "key_path": "$HOME/agsbx/private.key"
            },
            "network": "tcp,udp"
        },
EOF
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
gen_basepath
echo "Vmess-ws：xray模式→端口2083(CF固定) / singbox模式→随机端口"
alloc_port port_vm_ws
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": 2083,
            "protocol": "vmess",
            "settings": {
                "users": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "wsSettings": {
                  "path": "/${basepath}-vm"
                },
                "tlsSettings": {
                  "certificates": [{
                    "certificateFile": "/etc/argosbx/certs/cdnym.crt",
                    "keyFile": "/etc/argosbx/certs/cdnym.key"
                  }],
                  "alpn": ["h2", "http/1.1"]
                }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}"
            }
        ],
        "transport": {
            "type": "ws",
            "path": "/${basepath}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"
        }
    },
EOF
fi
else
vmp=vmptargo
fi
}

xrsbso(){
if [ -n "$sop" ]; then
sop=sopt
alloc_port port_so
 echo "Socks5端口：$port_so"
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
         "tag": "socks5-xr",
         "port": ${port_so},
         "listen": "::",
         "protocol": "socks",
         "settings": {
            "auth": "password",
             "accounts": [
               {
               "user": "${uuid}",
               "pass": "${uuid}"
               }
            ],
            "udp": true
          },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
      "tag": "socks5-sb",
      "type": "socks",
      "listen": "::",
      "listen_port": ${port_so},
      "users": [
      {
      "username": "${uuid}",
      "password": "${uuid}"
      }
     ]
    },
EOF
fi
else
sop=soptargo
fi
}

xrsbout(){
if [ -e "$HOME/agsbx/xr.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/xr.json"
cat >> "$HOME/agsbx/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xryx}"
     }
    },
    {
      "tag": "x-warp-out",
      "protocol": "wireguard",
      "settings": {
        "secretKey": "${pvk}",
        "address": [
          "172.16.0.2/32",
          "${wpv6}/128"
        ],
        "peers": [
          {
            "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
            "allowedIPs": [
              "0.0.0.0/0",
              "::/0"
            ],
            "endpoint": "${xendip}:2408"
          }
        ],
        "reserved": ${res}
        }
    },
    {
      "tag":"warp-out",
      "protocol":"freedom",
        "settings":{
        "domainStrategy":"${wxryx}"
       },
       "proxySettings":{
       "tag":"x-warp-out"
     }
}
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "ip": [ ${xip} ],
        "network": "tcp,udp",
        "outboundTag": "${x1outtag}"
      },
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "${x2outtag}"
      }
    ]
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/xr.service <<EOF
[Unit]
Description=xr service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/xray run -c /root/agsbx/xr.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xr >/dev/null 2>&1
systemctl start xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/xray <<EOF
#!/sbin/openrc-run
description="xr service"
command="/root/agsbx/xray"
command_args="run -c /root/agsbx/xr.json"
command_background=yes
pidfile="/run/xray.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/xray >/dev/null 2>&1
rc-update add xray default >/dev/null 2>&1
rc-service xray start >/dev/null 2>&1
else
nohup "$HOME/agsbx/xray" run -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 &
fi
fi
if [ -e "$HOME/agsbx/sb.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/sb.json"
cat >> "$HOME/agsbx/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "address": [
        "172.16.0.2/32",
        "${wpv6}/128"
      ],
      "private_key": "${pvk}",
      "peers": [
        {
          "address": "${sendip}",
          "port": 2408,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "reserved": $res
        }
      ]
    }
  ],
  "route": {
    "rules": [
       {
          "action": "sniff"
        },
       {
        "action": "resolve",
         "strategy": "${sbyx}"
       },
      {
        "ip_cidr": [ ${sip} ],         
        "outbound": "${s1outtag}"
      }
    ],
    "final": "${s2outtag}"
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/sb.service <<EOF
[Unit]
Description=sb service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/sing-box run -c /root/agsbx/sb.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sb >/dev/null 2>&1
systemctl start sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/sing-box <<EOF
#!/sbin/openrc-run
description="sb service"
command="/root/agsbx/sing-box"
command_args="run -c /root/agsbx/sb.json"
command_background=yes
pidfile="/run/sing-box.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/sing-box >/dev/null 2>&1
rc-update add sing-box default >/dev/null 2>&1
rc-service sing-box start >/dev/null 2>&1
else
nohup "$HOME/agsbx/sing-box" run -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 &
fi
fi
}
ins(){
# 证书签发(CDN协议需要cdnym证书, acme.sh + CF DNS API)
if [ -n "$cdnym" ] && [ -n "$cfapi" ] && { [ -n "$vxp" ] || [ -n "$vwp" ] || [ -n "$vup" ] || [ -n "$twp" ] || [ -n "$tuhp" ] || [ -n "$vmp" ] || [ -n "$mup" ] || [ -n "$txp" ] || [ -n "$mxp" ] || [ -n "$swp" ] || [ -n "$vwep" ]; }; then
  certsign "$cdnym" "cdnym" || echo "⚠️ CDN证书签发失败，CDN协议可能无法正常工作(CF Full Strict模式)"
fi
# 证书签发(直连TLS协议需要directnym证书)
if [ -n "$directnym" ] && [ -n "$cfapi" ] && { [ -n "$vtp" ] || [ -n "$ttp" ]; }; then
  certsign "$directnym" "directnym" || echo "⚠️ directnym证书签发失败，直连TLS协议可能无法正常工作"
fi
if [ "$hyp" != yes ] && [ "$tup" != yes ] && [ "$anp" != yes ] && [ "$arp" != yes ] && [ "$ssp" != yes ] && [ "$stp" != yes ] && [ "$nap" != yes ]; then
installxray
xrsbvm
xrsbso
warpsx
xrsbout
hyp="hyptargo"; tup="tuptargo"; anp="anptargo"; arp="arptargo"; ssp="ssptargo"; stp="stptargo"; nap="naptargo"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$vxp" != yes ] && [ "$vwp" != yes ] && [ "$vup" != yes ] && [ "$twp" != yes ] && [ "$tuhp" != yes ] && [ "$vgp" != yes ] && [ "$tgp" != yes ] && [ "$mgp" != yes ] && [ "$mup" != yes ] && [ "$txp" != yes ] && [ "$mxp" != yes ] && [ "$swp" != yes ] && [ "$vwep" != yes ] && [ "$trp" != yes ] && [ "$vtp" != yes ] && [ "$ttp" != yes ]; then
installsb
xrsbvm
xrsbso
warpsx
xrsbout
xhp="xhptargo"; vlp="vlptargo"; vxp="vxptargo"; vwp="vwptargo"; vup="vuptargo"; twp="twptargo"; tuhp="tuhptargo"; vgp="vgptargo"; tgp="tgptargo"; mgp="mgptargo"; mup="muptargo"; txp="txptargo"; mxp="mxptargo"; swp="swptargo"; vwep="vweptargo"; trp="trptargo"; vtp="vtptargo"; ttp="ttptargo"
else
installsb
installxray
xrsbvm
xrsbso
warpsx
xrsbout
fi
parse_argopro
argopro_setup
if [ -n "$vmag" ] && [ "$argo_count" -gt 0 ]; then
echo
echo "=========启用Cloudflared-argo内核========="
if [ ! -e "$HOME/agsbx/cloudflared" ]; then
upcloudflared
fi
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argoname='固定'
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/argo.service <<EOF
[Unit]
Description=argo service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}"
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable argo >/dev/null 2>&1
systemctl start argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/argo <<EOF
#!/sbin/openrc-run
description="argo service"
command="/root/agsbx/cloudflared tunnel"
command_args="--no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH}"
pidfile="/run/argo.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/argo >/dev/null 2>&1
rc-update add argo default >/dev/null 2>&1
rc-service argo start >/dev/null 2>&1
else
nohup "$HOME/agsbx/cloudflared" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}" >/dev/null 2>&1 &
fi
echo "${ARGO_DOMAIN}" > "$HOME/agsbx/sbargoym.log"
echo "${ARGO_AUTH}" > "$HOME/agsbx/sbargotoken.log"
else
argoname='临时'
nohup "$HOME/agsbx/cloudflared" tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
echo "申请Argo$argoname隧道中……请稍等"
sleep 15
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [ -n "${argodomain}" ]; then
echo "Argo$argoname隧道申请成功"
# 固定隧道多协议CF Dashboard配置指引
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ] && [ "$argo_count" -gt 0 ]; then
echo
echo "=========Cloudflare Tunnel Public Hostname配置指引========="
echo "请在CF Zero Trust → Networks → Tunnels → 选择您的隧道 → Public Hostname中配置以下${argo_count}条规则:"
echo
echo "  域名 | Path(Go正则) | 类型 | Service"
printf "$argo_cf_rules"
echo
echo "注: Path必须加^前缀实现精确前缀匹配，每个协议1条规则。"
echo "================================================================="
fi
else
echo "Argo$argoname隧道申请失败，请稍后再试"
fi
fi
sleep 5
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/agsbx/d' ~/.bashrc
SCRIPT_PATH="$HOME/bin/agsbx"
mkdir -p "$HOME/bin"
(command -v curl >/dev/null 2>&1 && curl -sL "$agsbxurl" -o "$SCRIPT_PATH") || (command -v wget >/dev/null 2>&1 && wget -qO "$SCRIPT_PATH" "$agsbxurl")
chmod +x "$SCRIPT_PATH"
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行Argosbx脚本的节点恢复操作，请稍等……'; sleep 6; export cfip=\"${cfip}\" hyjpt=\"${hyjpt}\" cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" argo=\"${argo}\" argopro=\"${argopro}\" uuid=\"${uuid}\" $wap=\"${warp}\" $xhp=\"${port_xh}\" $vxp=\"${port_vx}\" $ssp=\"${port_ss}\" $sop=\"${port_so}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $vwp=\"${port_vw}\" $vmp=\"${port_vm_ws}\" $hyp=\"${port_hy2}\" $tup=\"${port_tu}\" $stp=\"${port_st}\" $nap=\"${port_na}\" $trp=\"${port_tr}\" $vtp=\"${port_vtv}\" $ttp=\"${port_tt}\" reym=\"${ym_vl_re}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash "$HOME/bin/agsbx"; fi" >> ~/.bashrc
fi
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
if [ -n "$argo_count" ] && [ "$argo_count" -gt 0 ]; then
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
else
if command -v apk >/dev/null 2>&1; then
cat > /etc/local.d/alpineargosbx.start <<EOF
#!/bin/bash
sleep 10
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:\$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
sleep 10
HOME="$HOME" $HOME/bin/agsbx list >/dev/null 2>&1
EOF
chmod +x /etc/local.d/alpineargosbx.start
rc-update add local default >/dev/null 2>&1
else
echo '@reboot sleep 10 && /bin/bash -c "nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 & sleep 10 && bash $HOME/bin/agsbx list >/dev/null 2>&1"' >> /tmp/crontab.tmp
fi
fi
fi
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
echo "Argosbx脚本进程启动成功，安装完毕" && sleep 2
else
echo "Argosbx脚本进程未启动，安装失败" && exit
fi
if [ -n "$cfip" ]; then
set -- $cfip
cdnip1="$1"
cdnip2="$2"
echo "$cdnip1" > "$HOME/agsbx/cdnip1"
echo "$cdnip2" > "$HOME/agsbx/cdnip2"
else
if [ -f "$HOME/agsbx/cdnip1" ] && [ -f "$HOME/agsbx/cdnip2" ]; then
cdnip1=$(cat "$HOME/agsbx/cdnip1")
cdnip2=$(cat "$HOME/agsbx/cdnip2")
else
cdnip1="yg1.ygkkk.dpdns.org"
cdnip2="yg6.ygkkk.dpdns.org"
fi
fi
}
# ===== S7: 服务管理 =====

argosbxstatus(){
echo "=========当前三大内核运行状态========="
procs=$(find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null)
if echo "$procs" | grep -Eq 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1; then
echo "Sing-box (版本V$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}'))：运行中"
else
echo "Sing-box：未启用"
fi
if echo "$procs" | grep -Eq 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1; then
echo "Xray (版本V$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}'))：运行中"
else
echo "Xray：未启用"
fi
if echo "$procs" | grep -Eq 'agsbx/c' || pgrep -f 'agsbx/c' >/dev/null 2>&1; then
echo "Argo (版本V$("$HOME/agsbx/cloudflared" version 2>/dev/null | awk '{print $3}'))：运行中"
else
echo "Argo：未启用"
fi
}
# ===== S6: 订阅链接生成 =====

cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 -k "$v46url" 2>/dev/null || curl -s6m5 -k "$v46url" 2>/dev/null) ) || (command -v wget >/dev/null 2>&1 && (timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null || timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
location="$v6dq"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
location="$v4dq"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
location="$v4dq"
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
argosbxstatus
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo "服务器地区：$location"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
else
ipbest
fi
}
ipchange
rm -rf "$HOME/agsbx/jhsub.txt"
uuid=$(cat "$HOME/agsbx/uuid")
server_ip=$(cat "$HOME/agsbx/server_ip.log")
sxname=$(cat "$HOME/agsbx/name" 2>/dev/null)
xvvmcdnym=$(cat "$HOME/agsbx/cdnym" 2>/dev/null)
echo "*********************************************************"
echo "*********************************************************"
echo "Argosbx脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
ym_vl_re=$(cat "$HOME/agsbx/ym_vl_re" 2>/dev/null)
cfipsj() { echo $((RANDOM % 13 + 1)); }
if [ -e "$HOME/agsbx/xray" ]; then
private_key_x=$(cat "$HOME/agsbx/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/agsbx/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/agsbx/xrk/short_id" 2>/dev/null)
enkey=$(cat "$HOME/agsbx/xrk/enkey" 2>/dev/null)
fi
if [ -e "$HOME/agsbx/sing-box" ]; then
private_key_s=$(cat "$HOME/agsbx/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/agsbx/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/agsbx/sbk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/agsbx/sskey" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/agsbx/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xh_link"
echo
fi
basepath=$(cat "$HOME/agsbx/basepath" 2>/dev/null)
if grep vless-xhttp "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-enc 】支持ENC加密，节点信息如下："
vl_vx_link="vless://$uuid@$server_ip:2053?encryption=$enkey&type=xhttp&path=/${basepath}-vx&mode=packet-up&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-xhttp-enc-$hostname"
echo "$vl_vx_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vx_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Vless-xhttp-enc-cdn 】支持ENC加密，节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定2053端口+TLS"
 vl_vx_cdn_link="vless://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?encryption=$enkey&type=xhttp&host=$xvvmcdnym&path=/${basepath}-vx&mode=packet-up&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-xhttp-enc-cdn-$hostname"
echo "$vl_vx_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vx_cdn_link"
echo
fi
fi
if grep vless-ws "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-ws 】节点信息如下："
vl_vw_link="vless://$uuid@$server_ip:443?encryption=none&type=ws&path=/${basepath}-vw&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-ws-$hostname"
echo "$vl_vw_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vw_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Vless-ws-cdn 】节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
 vl_vw_cdn_link="vless://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?encryption=none&type=ws&host=$xvvmcdnym&path=/${basepath}-vw&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-ws-cdn-$hostname"
echo "$vl_vw_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vw_cdn_link"
echo
fi
fi
if grep vless-httpupgrade "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-httpupgrade-enc 】支持ENC加密，节点信息如下："
vl_vu_link="vless://$uuid@$server_ip:2087?encryption=$enkey&type=httpupgrade&path=/${basepath}-vu&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-httpupgrade-enc-$hostname"
echo "$vl_vu_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vu_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Vless-httpupgrade-enc-cdn 】支持ENC加密，节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
 vl_vu_cdn_link="vless://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?encryption=$enkey&type=httpupgrade&host=$xvvmcdnym&path=/${basepath}-vu&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-httpupgrade-enc-cdn-$hostname"
echo "$vl_vu_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vu_cdn_link"
echo
fi
fi
if grep trojan-ws "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Trojan-ws 】节点信息如下："
tr_tw_link="trojan://$uuid@$server_ip:2096?security=tls&type=ws&path=/${basepath}-tw&sni=$xvvmcdnym&fp=chrome#${sxname}tr-ws-$hostname"
echo "$tr_tw_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tw_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Trojan-ws-cdn 】节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
 tr_tw_cdn_link="trojan://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?security=tls&type=ws&host=$xvvmcdnym&path=/${basepath}-tw&sni=$xvvmcdnym&fp=chrome#${sxname}tr-ws-cdn-$hostname"
echo "$tr_tw_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tw_cdn_link"
echo
fi
fi
if grep trojan-httpupgrade "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Trojan-httpupgrade 】节点信息如下："
tr_tuh_link="trojan://$uuid@$server_ip:8443?security=tls&type=httpupgrade&path=/${basepath}-tuh&sni=$xvvmcdnym&fp=chrome#${sxname}tr-httpupgrade-$hostname"
echo "$tr_tuh_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tuh_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Trojan-httpupgrade-cdn 】节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
 tr_tuh_cdn_link="trojan://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?security=tls&type=httpupgrade&host=$xvvmcdnym&path=/${basepath}-tuh&sni=$xvvmcdnym&fp=chrome#${sxname}tr-httpupgrade-cdn-$hostname"
echo "$tr_tuh_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tuh_cdn_link"
echo
fi
fi
if grep vless-grpc "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-grpc-enc-cdn 】支持ENC加密，gRPC走443 fallbacks，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
echo "⚠️ gRPC需在CF Dashboard → Network → 开启gRPC开关"
vl_vg_cdn_link="vless://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?encryption=$enkey&type=grpc&serviceName=${basepath}-vg&authority=$xvvmcdnym&mode=gun&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-grpc-enc-cdn-$hostname"
echo "$vl_vg_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vg_cdn_link"
echo
fi
fi
if grep trojan-grpc "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Trojan-grpc-cdn 】gRPC走443 fallbacks，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
echo "⚠️ gRPC需在CF Dashboard → Network → 开启gRPC开关"
tr_tg_cdn_link="trojan://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?security=tls&type=grpc&serviceName=${basepath}-tg&authority=$xvvmcdnym&mode=gun&sni=$xvvmcdnym&fp=chrome#${sxname}tr-grpc-cdn-$hostname"
echo "$tr_tg_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tg_cdn_link"
echo
fi
fi
if grep vmess-httpupgrade "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 VMess-httpupgrade-cdn 】B组Origin Rules回源39000，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN走443端口+Origin Rules回源39000"
echo "⚠️ 需在CF Dashboard → Rules → Origin Rules 添加规则：URI Path starts with \"/${basepath}-mu\" → Rewrite to Port 39000"
vm_mu_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-httpupgrade-cdn-$hostname\", \"add\": \"yg$(cfipsj).ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"httpupgrade\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$basepath-mu\", \"tls\": \"tls\", \"sni\": \"$xvvmcdnym\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vm_mu_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_mu_cdn_link"
echo
fi
fi
if grep trojan-xhttp "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Trojan-xhttp-cdn 】B组Origin Rules回源39001，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN走443端口+Origin Rules回源39001"
echo "⚠️ 需在CF Dashboard → Rules → Origin Rules 添加规则：URI Path starts with \"/${basepath}-tx\" → Rewrite to Port 39001"
tr_tx_cdn_link="trojan://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?security=tls&type=xhttp&host=$xvvmcdnym&path=/${basepath}-tx&mode=packet-up&sni=$xvvmcdnym&fp=chrome#${sxname}tr-xhttp-cdn-$hostname"
echo "$tr_tx_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_tx_cdn_link"
echo
fi
fi
if grep vmess-xhttp "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 VMess-xhttp-cdn 】B组Origin Rules回源39002，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN走443端口+Origin Rules回源39002"
echo "⚠️ 需在CF Dashboard → Rules → Origin Rules 添加规则：URI Path starts with \"/${basepath}-mx\" → Rewrite to Port 39002"
echo "⚠️ net=xhttp 需要 v2rayN 6.x+ / xray-core 1.8.8+"
vm_mx_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-xhttp-cdn-$hostname\", \"add\": \"yg$(cfipsj).ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"xhttp\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$basepath-mx\", \"tls\": \"tls\", \"sni\": \"$xvvmcdnym\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vm_mx_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_mx_cdn_link"
echo
fi
fi
if grep ss-ws "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Shadowsocks-ws-cdn 】B组Origin Rules回源39003，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN走443端口+Origin Rules回源39003"
echo "⚠️ 需在CF Dashboard → Rules → Origin Rules 添加规则：URI Path starts with \"/${basepath}-sw\" → Rewrite to Port 39003"
sskey=$(cat "$HOME/agsbx/sskey" 2>/dev/null)
ss_sw_cdn_link="ss://2022-blake3-aes-128-gcm:${sskey}@yg$(cfipsj).ygkkk.dpdns.org:443/?type=ws&host=$xvvmcdnym&path=/${basepath}-sw&security=tls&sni=$xvvmcdnym#${sxname}ss-ws-cdn-$hostname"
echo "$ss_sw_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ss_sw_cdn_link"
echo
fi
fi
if grep vless-ws-enc "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-ws-enc-cdn 】B组Origin Rules回源39004，支持ENC加密，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN走443端口+Origin Rules回源39004"
echo "⚠️ 需在CF Dashboard → Rules → Origin Rules 添加规则：URI Path starts with \"/${basepath}-vwe\" → Rewrite to Port 39004"
vl_vwe_cdn_link="vless://$uuid@yg$(cfipsj).ygkkk.dpdns.org:443?encryption=$enkey&type=ws&host=$xvvmcdnym&path=/${basepath}-vwe&security=tls&sni=$xvvmcdnym&fp=chrome#${sxname}vl-ws-enc-cdn-$hostname"
echo "$vl_vwe_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vwe_cdn_link"
echo
fi
fi
if grep reality-vision "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-tcp-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_link"
echo
sbvlpt(){
cat <<EOF
    {
      "type": "vless",
      "tag": "${sxname}vless-$hostname",
      "server": "$server_ip",
      "server_port": $port_vl_re,
      "uuid": "$uuid",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_x",
          "short_id": "$short_id_x"
        }
      }
    },
EOF
}
sbvlpt1(){
echo "\"${sxname}vless-$hostname\","
}
clvlpt(){
cat <<EOF
- name: ${sxname}vless-reality-vision-$hostname               
  type: vless
  server: $server_ip                          
  port: $port_vl_re                                
  uuid: $uuid   
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $ym_vl_re                 
  reality-opts: 
    public-key: $public_key_x    
    short-id: $short_id_x                      
  client-fingerprint: chrome
EOF
}
clvlpt1(){
echo "- ${sxname}vless-reality-vision-$hostname"
}
fi
if grep ss-2022 "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Shadowsocks-2022 】节点信息如下："
port_ss=$(cat "$HOME/agsbx/port_ss")
ss_link="ss://$(echo -n "2022-blake3-aes-128-gcm:$sskey@$server_ip:$port_ss" | base64 -w0)#${sxname}Shadowsocks-2022-$hostname"
echo "$ss_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ss_link"
echo
sbsspt(){
cat <<EOF
{
       "type": "shadowsocks",
       "tag": "${sxname}Shadowsocks-2022-$hostname",
       "server": "$server_ip",
       "server_port": $port_ss,
       "method": "2022-blake3-aes-128-gcm",
       "password": "$sskey",
       "udp_over_tcp": {
        "enabled": true,
        "version": 2
      }
     },
EOF
}
sbsspt1(){
echo "\"${sxname}Shadowsocks-2022-$hostname\","
}
clsspt(){
cat <<EOF
- name: "${sxname}Shadowsocks-2022-$hostname"
  type: ss
  server: $server_ip
  port: $port_ss
  cipher: 2022-blake3-aes-128-gcm
  password: "$sskey"
  udp: true
  udp-over-tcp: true
  udp-over-tcp-version: 2
EOF
}
clsspt1(){
echo "- ${sxname}Shadowsocks-2022-$hostname"
}
fi
if grep vmess-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep vmess-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Vmess-ws 】节点信息如下："
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$basepath-vm\", \"tls\": \"tls\", \"sni\": \"$xvvmcdnym\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_link"
echo
sbvmpt(){
cat <<EOF
{
            "server": "$server_ip",
            "server_port": $port_vm_ws,
            "tag": "${sxname}vmess-$hostname",
            "tls": {
                "enabled": false,
                "server_name": "www.bing.com",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "packet_encoding": "packetaddr",
            "transport": {
                "headers": {
                    "Host": [
                        "www.bing.com"
                    ]
                },
                "path": "/$basepath-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$uuid"
        },
EOF
}
sbvmpt1(){
echo "\"${sxname}vmess-$hostname\","
}
clvmpt(){
cat <<EOF
- name: ${sxname}vmess-ws-$hostname                         
  type: vmess
  server: $server_ip                        
  port: $port_vm_ws                                     
  uuid: $uuid
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: www.bing.com                    
  ws-opts:
    path: "/$basepath-vm"                             
    headers:
      Host: www.bing.com
EOF
}
clvmpt1(){
echo "- ${sxname}vmess-ws-$hostname"
}
if [ -f "$HOME/agsbx/cdnym" ]; then
 echo "💣【 Vmess-ws-cdn 】节点信息如下："
 echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
 vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname\", \"add\": \"yg$(cfipsj).ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$basepath-vm\", \"tls\": \"tls\", \"sni\": \"$xvvmcdnym\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_cdn_link"
echo
fi
fi
if grep vmess-grpc "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vmess-grpc-cdn 】gRPC走443 fallbacks，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，CDN回源固定443端口+TLS"
echo "⚠️ gRPC需在CF Dashboard → Network → 开启gRPC开关"
vm_mg_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-grpc-cdn-$hostname\", \"add\": \"yg$(cfipsj).ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"grpc\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"$basepath-mg\", \"tls\": \"tls\", \"sni\": \"$xvvmcdnym\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vm_mg_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_mg_cdn_link"
echo
fi
fi
if grep anytls-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsbx/port_an")
an_link="anytls://$uuid@$server_ip:$port_an?insecure=1&allowInsecure=1#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsbx/jhsub.txt"
echo "$an_link"
echo
sbanpt(){
cat <<EOF
         {
            "type": "anytls",
            "tag": "${sxname}anytls-$hostname",
            "server": "$server_ip",
            "server_port": $port_an,
            "password": "$uuid",
            "idle_session_check_interval": "30s",
            "idle_session_timeout": "30s",
            "min_idle_session": 5,
            "tls": {
                "enabled": true,
                "insecure": true,
                "server_name": "www.bing.com"
            }
         },
EOF
}
sbanpt1(){
echo "\"${sxname}anytls-$hostname\","
}
clanpt(){
cat <<EOF
- name: ${sxname}anytls-$hostname
  type: anytls
  server: $server_ip
  port: $port_an
  password: $uuid
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  sni: www.bing.com
  skip-cert-verify: true
EOF
}
clanpt1(){
echo "- ${sxname}anytls-$hostname"
}
fi
if grep anyreality-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsbx/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ar_link"
echo
sbarpt(){
cat <<EOF
    {
        "type": "anytls",
        "tag": "${sxname}any-reality-$hostname",
        "server": "$server_ip",
        "server_port": $port_ar,
        "password": "$uuid",
        "idle_session_check_interval": "30s",
        "idle_session_timeout": "30s",
        "min_idle_session": 5,
        "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_s",
          "short_id": "$short_id_s"
        }
      }
         },
EOF
}
sbarpt1(){
echo "\"${sxname}any-reality-$hostname\","
}
fi
if grep hy2-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Hysteria2 】节点信息如下："
SHA256=$(cat "$HOME/agsbx/SHA256.txt")
port_hy2=$(cat "$HOME/agsbx/port_hy2")
hy2_ports=$(iptables -t nat -nL --line 2>/dev/null | grep -w "$port_hy2" | awk '{print $8}' | sed 's/dpts://; s/dpt://' | tr '\n' ',' | sed 's/,$//')
if [ -n "$hy2_ports" ] || [ -n "$hyjpt" ]; then
echo "Hysteria2跳跃端口已开启：$hy2_ports"
cmhy2pt=$(echo $hy2_ports | tr ':' '-')
hyps="&mport=$cmhy2pt"
sbhy2pt=$(echo "$hy2_ports" | grep -o '[0-9]\+:[0-9]\+' | sed 's/.*/"&"/' | paste -sd,)
sbhy2ports(){
    cat <<EOF
  "server_ports": [ $sbhy2pt ],
EOF
}
else
hyps=
fi
#hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&allowInsecure=1$hyps&sni=www.bing.com#${sxname}hy2-$hostname"
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=0&allowInsecure=0$hyps&sni=www.bing.com&pinSHA256=$SHA256#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$hy2_link"
echo
sbhypt(){
cat <<EOF
    {
        "type": "hysteria2",
        "tag": "${sxname}hy2-$hostname",
        "server": "$server_ip",
        "server_port": $port_hy2,
$(sbhy2ports 2>/dev/null)
        "password": "$uuid",
        "tls": {
            "enabled": true,
            "server_name": "www.bing.com",
            "insecure": true,
            "alpn": [
                "h3"
            ]
        }
    },
EOF
}
sbhypt1(){
echo "\"${sxname}hy2-$hostname\","
}
clhypt(){
cat <<EOF
- name: ${sxname}hysteria2-$hostname                            
  type: hysteria2                                      
  server: $server_ip                              
  port: $port_hy2
  ports: $cmhy2pt
  password: $uuid                          
  alpn:
    - h3
  sni: www.bing.com                               
  skip-cert-verify: true
  fast-open: true
EOF
}
clhypt1(){
echo "- ${sxname}hysteria2-$hostname"
}
fi
if grep tuic5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/agsbx/port_tu")
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&insecure=1&allowInsecure=1&allow_insecure=1#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tuic5_link"
echo
sbtupt(){
cat <<EOF
        {
            "type":"tuic",
            "tag": "${sxname}tuic5-$hostname",
            "server": "$server_ip",
            "server_port": $port_tu,
            "uuid": "$uuid",
            "password": "$uuid",
            "congestion_control": "bbr",
            "udp_relay_mode": "native",
            "udp_over_stream": false,
            "zero_rtt_handshake": false,
            "heartbeat": "10s",
            "tls":{
                "enabled": true,
                "server_name": "www.bing.com",
                "insecure": true,
                "alpn": [
                    "h3"
                ]
            }
        },
EOF
}
sbtupt1(){
echo "\"${sxname}tuic5-$hostname\","
}
cltupt(){
cat <<EOF
- name: ${sxname}tuic5-$hostname                            
  server: $server_ip                      
  port: $port_tu                                    
  type: tuic
  uuid: $uuid       
  password: $uuid   
  alpn: [h3]
  disable-sni: true
  reduce-rtt: true
  udp-relay-mode: native
  congestion-controller: bbr
  sni: www.bing.com                                
  skip-cert-verify: true
EOF
}
cltupt1(){
echo "- ${sxname}tuic5-$hostname"
}
fi
if grep socks5-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep socks5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Socks5 】客户端信息如下："
port_so=$(cat "$HOME/agsbx/port_so")
echo "请配合其他应用内置代理使用，勿做节点直接使用"
echo "客户端地址：$server_ip"
echo "客户端端口：$port_so"
echo "客户端用户名：$uuid"
echo "客户端密码：$uuid"
echo
fi
# C9 ShadowTLS v3+SS (无官方URI，仅输出连接参数)
if grep stls-in "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 ShadowTLS v3+SS 】节点信息如下："
port_st=$(cat "$HOME/agsbx/port_st")
stlspass=$(cat "$HOME/agsbx/stlspass")
ssintkey=$(cat "$HOME/agsbx/ssintkey")
stls_dest=${stls_dest:-www.microsoft.com}
echo "⚠️ ShadowTLS无官方URI格式，以下为手动配置参数："
echo "地址：$server_ip  端口：$port_st  ShadowTLS版本：v3"
echo "ShadowTLS密码：$stlspass  伪装域名：$stls_dest"
echo "内嵌SS加密：2022-blake3-aes-256-gcm  SS密码：$ssintkey"
echo
sbstpt(){
cat <<EOF
    {
      "type": "shadowtls",
      "tag": "${sxname}shadowtls-$hostname",
      "server": "$server_ip",
      "server_port": $port_st,
      "version": 3,
      "password": "$stlspass",
      "tls": {
        "enabled": true,
        "server_name": "$stls_dest",
        "utls": { "enabled": true, "fingerprint": "chrome" }
      },
      "detour": "${sxname}ss-internal-$hostname"
    },
    {
      "type": "shadowsocks",
      "tag": "${sxname}ss-internal-$hostname",
      "method": "2022-blake3-aes-256-gcm",
      "password": "$ssintkey"
    },
EOF
}
sbstpt1(){
echo "\"${sxname}shadowtls-$hostname\","
}
fi
# C10 Naive
if grep naive-in "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Naive 】节点信息如下："
port_na=$(cat "$HOME/agsbx/port_na")
nap_user=$(cat "$HOME/agsbx/nap_user")
nap_link="naive+https://${nap_user}:${uuid}@${server_ip}:${port_na}/#${sxname}naive-$hostname"
echo "$nap_link" >> "$HOME/agsbx/jhsub.txt"
echo "$nap_link"
echo
sbnapt(){
cat <<EOF
    {
      "type": "naive",
      "tag": "${sxname}naive-$hostname",
      "server": "$server_ip",
      "server_port": $port_na,
      "username": "$nap_user",
      "password": "$uuid",
      "tls": {
        "enabled": true,
        "server_name": "$server_ip",
        "insecure": true
      }
    },
EOF
}
sbnapt1(){
echo "\"${sxname}naive-$hostname\","
}
fi
# C11 Trojan+Reality
if grep trojan-reality "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Trojan+Reality 】节点信息如下："
port_tr=$(cat "$HOME/agsbx/port_tr")
tr_link="trojan://${uuid}@${server_ip}:${port_tr}?security=reality&sni=${ym_vl_re}&fp=chrome&pbk=${public_key_x}&sid=${short_id_x}&type=tcp#${sxname}trojan-reality-$hostname"
echo "$tr_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tr_link"
echo
sbtrpt(){
cat <<EOF
    {
      "type": "trojan",
      "tag": "${sxname}trojan-reality-$hostname",
      "server": "$server_ip",
      "server_port": $port_tr,
      "password": "$uuid",
      "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "reality": {
          "enabled": true,
          "public_key": "$public_key_x",
          "short_id": "$short_id_x"
        },
        "utls": { "enabled": true, "fingerprint": "chrome" }
      }
    },
EOF
}
sbtrpt1(){
echo "\"${sxname}trojan-reality-$hostname\","
}
cltrpt(){
cat <<EOF
- name: ${sxname}trojan-reality-$hostname
  type: trojan
  server: $server_ip
  port: $port_tr
  password: $uuid
  network: tcp
  udp: true
  tls: true
  servername: $ym_vl_re
  reality-opts:
    public-key: $public_key_x
    short-id: $short_id_x
  client-fingerprint: chrome
EOF
}
cltrpt1(){
echo "- ${sxname}trojan-reality-$hostname"
}
fi
# C12 VLESS+TLS+Vision
if grep vless-tls-vision "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 VLESS+TLS+Vision 】节点信息如下："
port_vtv=$(cat "$HOME/agsbx/port_vtv")
_vtp_host=${directnym:-$server_ip}
vtv_link="vless://${uuid}@${_vtp_host}:${port_vtv}?encryption=none&security=tls&type=tcp&flow=xtls-rprx-vision&sni=${_vtp_host}&fp=chrome#${sxname}vless-tls-vision-$hostname"
echo "$vtv_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vtv_link"
echo
sbvtpt(){
cat <<EOF
    {
      "type": "vless",
      "tag": "${sxname}vless-tls-vision-$hostname",
      "server": "$_vtp_host",
      "server_port": $port_vtv,
      "uuid": "$uuid",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$_vtp_host",
        "utls": { "enabled": true, "fingerprint": "chrome" }
      }
    },
EOF
}
sbvtpt1(){
echo "\"${sxname}vless-tls-vision-$hostname\","
}
clvtpt(){
cat <<EOF
- name: ${sxname}vless-tls-vision-$hostname
  type: vless
  server: $_vtp_host
  port: $port_vtv
  uuid: $uuid
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $_vtp_host
  client-fingerprint: chrome
EOF
}
clvtpt1(){
echo "- ${sxname}vless-tls-vision-$hostname"
}
fi
# C13 Trojan+TLS
if grep trojan-tls "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Trojan+TLS 】节点信息如下："
port_tt=$(cat "$HOME/agsbx/port_tt")
_ttp_host=${directnym:-$server_ip}
tt_link="trojan://${uuid}@${_ttp_host}:${port_tt}?security=tls&sni=${_ttp_host}&type=tcp&fp=chrome#${sxname}trojan-tls-$hostname"
echo "$tt_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tt_link"
echo
sbttpt(){
cat <<EOF
    {
      "type": "trojan",
      "tag": "${sxname}trojan-tls-$hostname",
      "server": "$_ttp_host",
      "server_port": $port_tt,
      "password": "$uuid",
      "tls": {
        "enabled": true,
        "server_name": "$_ttp_host",
        "utls": { "enabled": true, "fingerprint": "chrome" }
      }
    },
EOF
}
sbttpt1(){
echo "\"${sxname}trojan-tls-$hostname\","
}
clttpt(){
cat <<EOF
- name: ${sxname}trojan-tls-$hostname
  type: trojan
  server: $_ttp_host
  port: $port_tt
  password: $uuid
  network: tcp
  udp: true
  tls: true
  servername: $_ttp_host
  client-fingerprint: chrome
EOF
}
clttpt1(){
echo "- ${sxname}trojan-tls-$hostname"
}
fi
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
argo_sel=$(cat "$HOME/agsbx/argopro_sel.log" 2>/dev/null)
if [ -n "$argodomain" ] && [ -n "$argo_sel" ]; then
# 为每个选中Argo的协议生成分享链接(443+TLS, 80+无TLS)
for _p in $argo_sel; do
  case $_p in
    vw)
      echo "vless://${uuid}@${cdnip1}:443?encryption=none&security=tls&sni=${argodomain}&fp=chrome&type=ws&host=${argodomain}&path=/${basepath}-vw#${sxname}vless-ws-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "vless://${uuid}@${cdnip2}:80?encryption=none&type=ws&host=${argodomain}&path=/${basepath}-vw#${sxname}vless-ws-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    vx)
      echo "vless://${uuid}@${cdnip1}:443?encryption=none&security=tls&sni=${argodomain}&fp=chrome&type=xhttp&host=${argodomain}&path=/${basepath}-vx&mode=packet-up#${sxname}vless-xhttp-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "vless://${uuid}@${cdnip2}:80?encryption=none&type=xhttp&host=${argodomain}&path=/${basepath}-vx&mode=packet-up#${sxname}vless-xhttp-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    vm)
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-ws-tls-argo-$hostname-443\",\"add\":\"$cdnip1\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-vm\",\"tls\":\"tls\",\"sni\":\"$argodomain\",\"alpn\":\"\",\"fp\":\"chrome\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-ws-argo-$hostname-80\",\"add\":\"$cdnip2\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-vm\",\"tls\":\"\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      ;;
    vu)
      echo "vless://${uuid}@${cdnip1}:443?encryption=${enkey}&security=tls&sni=${argodomain}&fp=chrome&type=httpupgrade&host=${argodomain}&path=/${basepath}-vu#${sxname}vless-httpupgrade-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "vless://${uuid}@${cdnip2}:80?encryption=${enkey}&type=httpupgrade&host=${argodomain}&path=/${basepath}-vu#${sxname}vless-httpupgrade-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    tw)
      echo "trojan://${uuid}@${cdnip1}:443?security=tls&sni=${argodomain}&fp=chrome&type=ws&host=${argodomain}&path=/${basepath}-tw#${sxname}trojan-ws-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "trojan://${uuid}@${cdnip2}:80?type=ws&host=${argodomain}&path=/${basepath}-tw#${sxname}trojan-ws-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    tu)
      echo "trojan://${uuid}@${cdnip1}:443?security=tls&sni=${argodomain}&fp=chrome&type=httpupgrade&host=${argodomain}&path=/${basepath}-tu#${sxname}trojan-httpupgrade-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "trojan://${uuid}@${cdnip2}:80?type=httpupgrade&host=${argodomain}&path=/${basepath}-tu#${sxname}trojan-httpupgrade-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    mu)
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-httpupgrade-tls-argo-$hostname-443\",\"add\":\"$cdnip1\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"httpupgrade\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-mu\",\"tls\":\"tls\",\"sni\":\"$argodomain\",\"alpn\":\"\",\"fp\":\"chrome\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-httpupgrade-argo-$hostname-80\",\"add\":\"$cdnip2\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"httpupgrade\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-mu\",\"tls\":\"\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      ;;
    tx)
      echo "trojan://${uuid}@${cdnip1}:443?security=tls&sni=${argodomain}&fp=chrome&type=xhttp&host=${argodomain}&path=/${basepath}-tx&mode=packet-up#${sxname}trojan-xhttp-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "trojan://${uuid}@${cdnip2}:80?type=xhttp&host=${argodomain}&path=/${basepath}-tx&mode=packet-up#${sxname}trojan-xhttp-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
    mx)
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-xhttp-tls-argo-$hostname-443\",\"add\":\"$cdnip1\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"xhttp\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-mx\",\"tls\":\"tls\",\"sni\":\"$argodomain\",\"alpn\":\"\",\"fp\":\"chrome\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      echo "vmess://$(echo "{ \"v\":\"2\",\"ps\":\"${sxname}vmess-xhttp-argo-$hostname-80\",\"add\":\"$cdnip2\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"xhttp\",\"type\":\"none\",\"host\":\"$argodomain\",\"path\":\"/${basepath}-mx\",\"tls\":\"\"}" | base64 -w0)" >> "$HOME/agsbx/jhsub.txt"
      ;;
    sw)
      echo "ss://2022-blake3-aes-128-gcm:${sskey}@${cdnip1}:443/?type=ws&host=${argodomain}&path=/${basepath}-sw#${sxname}ss-ws-tls-argo-$hostname-443" >> "$HOME/agsbx/jhsub.txt"
      echo "ss://2022-blake3-aes-128-gcm:${sskey}@${cdnip2}:80/?type=ws&host=${argodomain}&path=/${basepath}-sw#${sxname}ss-ws-argo-$hostname-80" >> "$HOME/agsbx/jhsub.txt"
      ;;
  esac
done
sbvmargopt(){
case " $argo_sel " in *" vm "*)
cat <<EOF
{
    "server": "$cdnip1",
    "server_port": 443,
    "tag": "${sxname}vmess-ws-tls-argo-$hostname-443",
    "tls": { "enabled": true, "server_name": "$argodomain", "insecure": false, "utls": { "enabled": true, "fingerprint": "chrome" } },
    "packet_encoding": "packetaddr",
    "transport": { "headers": { "Host": ["$argodomain"] }, "path": "/$basepath-vm", "type": "ws" },
    "type": "vmess", "security": "auto", "uuid": "$uuid"
},
EOF
;; esac
}
sbvmargopt1(){
case " $argo_sel " in *" vm "*) echo "\"${sxname}vmess-ws-tls-argo-$hostname-443\"," ;; esac
}
clvmargopt(){
case " $argo_sel " in *" vm "*)
cat <<EOF
- name: ${sxname}vmess-ws-tls-argo-$hostname-443
  type: vmess
  server: "$cdnip1"
  port: 443
  uuid: $uuid
  cipher: auto
  udp: true
  tls: true
  network: ws
  servername: $argodomain
  ws-opts:
    path: "/$basepath-vm"
    headers:
      Host: $argodomain
EOF
;; esac
}
clvmargopt1(){
case " $argo_sel " in *" vm "*) echo "- ${sxname}vmess-ws-tls-argo-$hostname-443" ;; esac
}
sbtk=$(cat "$HOME/agsbx/sbargotoken.log" 2>/dev/null)
[ -n "$sbtk" ] && nametn="Argo固定隧道token：$sbtk"
argoshow=$(echo "Argo域名：$argodomain
$nametn
Argo选中协议: ${argo_sel}
Argo临时隧道端口(首协议): $(cat $HOME/agsbx/argoport.log 2>/dev/null)")
else
# 未启用Argo时定义空函数(避免调用报错)
sbvmargopt(){ :; }
sbvmargopt1(){ :; }
clvmargopt(){ :; }
clvmargopt1(){ :; }
fi

get_func() {
local f=$1
if type "$f" >/dev/null 2>&1; then
local out
out=$($f)
[ -n "$out" ] && printf "%s\n" "$out"
fi
}
  sbxy="$(get_func sbvlpt; get_func sbsspt; get_func sbanpt; get_func sbarpt; get_func sbvmpt; get_func sbhypt; get_func sbtupt; get_func sbvmargopt; get_func sbstpt; get_func sbnapt; get_func sbtrpt; get_func sbvtpt; get_func sbttpt)"
  clxy="$(get_func clvlpt; get_func clsspt; get_func clanpt; get_func clvmpt; get_func clhypt; get_func cltupt; get_func clvmargopt; get_func cltrpt; get_func clvtpt; get_func clttpt)"
  sbgz="$(get_func sbvlpt1; get_func sbsspt1; get_func sbanpt1; get_func sbarpt1; get_func sbvmpt1; get_func sbhypt1; get_func sbtupt1; get_func sbvmargopt1; get_func sbstpt1; get_func sbnapt1; get_func sbtrpt1; get_func sbvtpt1; get_func sbttpt1)"
  clgz="$({ get_func clvlpt1; get_func clsspt1; get_func clanpt1; get_func clvmpt1; get_func clhypt1; get_func cltupt1; get_func clvmargopt1; get_func cltrpt1; get_func clvtpt1; get_func clttpt1; } | sed '2,$s/^/    /')"
sbgz=$(printf "%s\n" "$sbgz" | sed '$ s/,$//')
cat > $HOME/agsbx/sbox.json <<EOF
{
    "log": {
        "disabled": false,
        "level": "info",
        "timestamp": true
    },
    "experimental": {
        "cache_file": {
            "enabled": true,
            "path": "./cache.db",
            "store_fakeip": true
        },
        "clash_api": {
            "external_controller": "127.0.0.1:9090",
            "external_ui": "ui",
            "default_mode": "Rule"
        }
    },
    "dns": {
        "servers": [
            {
                "tag": "aliDns",
                "type": "https",
                "server": "dns.alidns.com",
                "path": "/dns-query",
                "domain_resolver": "local"
            },
            {
                "tag": "local",
                "type": "udp",
                "server": "223.5.5.5"
            },
            {
                "tag": "proxyDns",
                "type": "https",
                "server": "dns.google",
                "path": "/dns-query",
	              "domain_resolver": "aliDns",
                "detour": "proxy"
            },
           {
        "type": "fakeip",
        "tag": "fakeip",
        "inet4_range": "198.18.0.0/15",
        "inet6_range": "fc00::/18"
      }
        ],
        "rules": [
            {
                "rule_set": "geosite-cn",
                "clash_mode": "Rule",
                "server": "aliDns"
            },
            {
                "clash_mode": "Direct",
                "server": "local"
            },
            {
                "clash_mode": "Global",
                "server": "proxyDns"
            },
            {
        "query_type": [
          "A",
          "AAAA"
        ],
        "server": "fakeip"
      }
        ],
        "final": "proxyDns",
        "strategy": "prefer_ipv4"
    },
    "inbounds": [
        {
            "type": "tun",
            "tag": "tun-in",
            "address": [
                "172.19.0.1/30",
                "fd00::1/126"
            ],
            "auto_route": true,
            "strict_route": true
        }
    ],
    "route": {
        "rules": [
            {
	 "inbound": "tun-in",
                "action": "sniff"
            },
            {
                "type": "logical",
                "mode": "or",
                "rules": [
                    {
                        "port": 53
                    },
                    {
                        "protocol": "dns"
                    }
                ],
                "action": "hijack-dns"
            },
         {
          "clash_mode": "Global",
          "outbound": "proxy"
         },
        {
        "rule_set": "geosite-cn",
        "clash_mode": "Rule",
        "outbound": "direct"
       },
     {
    "rule_set": "geoip-cn",
    "clash_mode": "Rule",
    "outbound": "direct"
      },
     {
    "ip_is_private": true,
    "clash_mode": "Rule",
    "outbound": "direct"
    },
     {
      "clash_mode": "Direct",
      "outbound": "direct"
     }		
        ],
        "rule_set": [
            {
                "tag": "geosite-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-cn.srs",
                "download_detour": "direct"
            },
            {
                "tag": "geoip-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs",
                "download_detour": "direct"
            }
        ],
        "final": "proxy",
        "auto_detect_interface": true,
        "default_domain_resolver": {
        "server": "aliDns"
        }
    },
  "outbounds": [
   $sbxy
        {
            "tag": "proxy",
            "type": "selector",
            "default": "auto",
            "outbounds": [
        "auto",
        $sbgz
            ]
        },
        {
            "tag": "auto",
            "type": "urltest",
            "outbounds": [
            $sbgz
            ],
            "url": "http://www.gstatic.com/generate_204",
            "interval": "10m",
            "tolerance": 50
        },
        {
            "type": "direct",
            "tag": "direct"
        }
    ]
}
EOF

cat > $HOME/agsbx/clmi.yaml <<EOF
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
dns:
  enable: true 
  listen: "0.0.0.0:1053"
  ipv6: true
  prefer-h3: false
  respect-rules: true
  use-system-hosts: false
  cache-algorithm: "arc"
  enhanced-mode: "fake-ip"
  fake-ip-range: "198.18.0.1/16"
  fake-ip-filter:
    - "+.lan"
    - "+.local"
    - "+.msftconnecttest.com"
    - "+.msftncsi.com"
    - "localhost.ptlogin2.qq.com"
    - "localhost.sec.qq.com"
    - "+.in-addr.arpa"
    - "+.ip6.arpa"
    - "time.*.com"
    - "time.*.gov"
    - "pool.ntp.org"
    - "localhost.work.weixin.qq.com"
  default-nameserver: ["223.5.5.5", "119.29.29.29"]
  nameserver:
    - "https://1.1.1.1/dns-query"
    - "https://8.8.8.8/dns-query"
  proxy-server-nameserver:
    - "https://223.5.5.5/dns-query"
    - "https://doh.pub/dns-query"
nameserver-policy:
  "geosite:cn":
     - "https://223.5.5.5/dns-query"
     - "https://doh.pub/dns-query"
proxies:
$clxy

proxy-groups:
- name: 负载均衡
  type: load-balance
  url: https://www.gstatic.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    $clgz
- name: 自动选择
  type: url-test
  url: https://www.gstatic.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    $clgz 
- name: 🌍选择代理节点
  type: select
  proxies:
    - 负载均衡                                         
    - 自动选择
    - DIRECT
    $clgz
rules:
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,🌍选择代理节点
EOF
echo "---------------------------------------------------------"
echo "$argoshow"
echo
if [ -s $HOME/agsbx/subport.log ]; then
showsubport=$(cat $HOME/agsbx/subport.log)
if ps -ef 2>/dev/null | grep "$showsubport" | grep -v grep >/dev/null; then
showsubtoken=$(cat $HOME/agsbx/subtoken.log 2>/dev/null)
subip=$(cat $HOME/agsbx/server_ip.log 2>/dev/null)
suburl="$subip:$showsubport/$showsubtoken"
echo "**********************************************************"
echo "Clash/Mihomo本地IP订阅地址：http://$suburl/clmi.yaml"
echo "Sing-box本地IP订阅地址：http://$suburl/sbox.json"
echo "聚合协议本地IP订阅地址：http://$suburl/jhsub.txt"
echo "**********************************************************"
fi
fi
echo
echo "---------------------------------------------------------"
echo "聚合节点信息，请进入 $HOME/agsbx/jhsub.txt 文件目录查看或者运行 cat $HOME/agsbx/jhsub.txt 查看"
echo "========================================================="
echo "相关快捷方式如下：(首次安装成功后需重连SSH，agsbx快捷方式才可生效；如未生效，请使用主脚本)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
sed -i '/agsbx/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
sed -i '/websbx/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
rm -rf  "$HOME/bin/agsbx"
if pidof systemd >/dev/null 2>&1; then
for svc in xr sb argo; do
systemctl stop "$svc" >/dev/null 2>&1
systemctl disable "$svc" >/dev/null 2>&1
done
rm -rf /etc/systemd/system/{xr.service,sb.service,argo.service}
elif command -v rc-service >/dev/null 2>&1; then
for svc in sing-box xray argo; do
rc-service "$svc" stop >/dev/null 2>&1
rc-update del "$svc" default >/dev/null 2>&1
done
rm -rf /etc/init.d/{sing-box,xray,argo} /etc/local.d/alpineargosbx.start /etc/local.d/alpinesubsbx.start
iptables -t nat -F PREROUTING >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
}
xrestart(){
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &
fi
}
# ===== S8: 命令入口 =====

if [ "$1" = "del" ]; then
cleandel
rm -rf sbx_update "$HOME/agsbx" "$HOME/websbx"
echo "卸载完成"
echo "欢迎继续使用甬哥侃侃侃ygkkk的Argosbx一键无交互小钢炮脚本💣" && sleep 2
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsbx"/{sb.json,xr.json,sbargoym.log,sbargotoken.log,argo.log,argoport.log,cdnym,name}
echo "Argosbx重置协议完成，开始更新相关协议变量……" && sleep 2
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "upx" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/x"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
upxray && xrestart && echo "Xray内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "ups" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/s"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
upsingbox && sbrestart && echo "Sing-box内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "upc" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/c"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/c' 2>/dev/null) >/dev/null 2>&1
upcloudflared && echo "Cloudflared内核更新完成" && sleep 2
if [ -e "$HOME/agsbx/sbargotoken.log" ]; then
if pidof systemd >/dev/null 2>&1; then
systemctl restart argo >/dev/null 2>&1
elif [ -f "/etc/init.d/argo" ]; then
/etc/init.d/argo restart >/dev/null 2>&1
fi
fi
cip
exit
elif [ "$1" = "res" ]; then
for P in /proc/[0-9]*; do
[ -L "$P/exe" ] || continue
TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue
case "$TARGET" in
*"/agsbx/s"*)
kill "$(basename "$P")" 2>/dev/null
sbrestart
;;
*"/agsbx/x"*)
kill "$(basename "$P")" 2>/dev/null
xrestart
;;
*"/agsbx/c"*)
kill "$(basename "$P")" 2>/dev/null
kill -15 $(pgrep -f 'agsbx/c' 2>/dev/null) >/dev/null 2>&1
if [ -e "$HOME/agsbx/sbargotoken.log" ]; then
if pidof systemd >/dev/null 2>&1; then
systemctl restart argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service argo restart >/dev/null 2>&1
else
nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
fi
else
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log 2>/dev/null) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
;;
esac
done
sleep 5 && echo "重启完成" && sleep 3 && cip
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
if [ -n "$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
sendip="2606:4700:d0::a29f:c001"
xendip="[2606:4700:d0::a29f:c001]"
else
sendip="162.159.192.1"
xendip="162.159.192.1"
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "Argosbx脚本未安装，开始安装…………" && sleep 1
if [ -n "$oap" ]; then
setenforce 0 >/dev/null 2>&1
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
echo
echo "iptables执行开放所有端口"
fi
ins
if [ -n "$sub" ]; then
subtokenipsub(){
if [ -z "$subid" ]; then
subtoken="$(cat "$HOME/agsbx/uuid")"
else
subtoken="$subid"
fi
rm -rf $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"
echo $subtoken > $HOME/agsbx/subtoken.log
}
subportipsub(){
if [ -z "$subpt" ]; then
if [ -n "$(cat "$HOME/agsbx/subport.log" 2>/dev/null)" ]; then
subport=$(cat $HOME/agsbx/subport.log)
else
subport=$(shuf -i 10000-65535 -n 1)
fi
else
subport="$subpt"
fi
echo $subport > $HOME/agsbx/subport.log
}
subtokenipsub && subportipsub
echo "请稍后…………"
kill -15 $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
mkdir -p $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"
ln -sf $HOME/agsbx/clmi.yaml $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/clmi.yaml
ln -sf $HOME/agsbx/sbox.json $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/sbox.json
ln -sf $HOME/agsbx/jhsub.txt $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/jhsub.txt
if command -v apk >/dev/null 2>&1; then
busybox-extras httpd -f -p "$(cat $HOME/agsbx/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
else
busybox httpd -f -p "$(cat $HOME/agsbx/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
fi
sleep 5
if command -v apk >/dev/null 2>&1; then
cat > /etc/local.d/alpinesubsbx.start <<EOF
#!/bin/bash
sleep 10
busybox-extras httpd -f -p \$(cat $HOME/agsbx/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &
EOF
chmod +x /etc/local.d/alpinesubsbx.start
rc-update add local default >/dev/null 2>&1
else
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i '/websbx/d' /tmp/crontab.tmp
echo '@reboot sleep 10 && /bin/bash -c "busybox httpd -f -p $(cat $HOME/agsbx/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &"' >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
fi
echo "本地IP订阅链接已更新完成"
fi
if [ -n "$hyjpt" ] && [ -n "$hyp" ]; then
echo
echo "设置Hysteria2协议的跳跃端口：$hyjpt"
iptables -t nat -F PREROUTING >/dev/null 2>&1
ip6tables -t nat -F PREROUTING >/dev/null 2>&1
hyport=$(cat "$HOME/agsbx/port_hy2")
for port in $hyjpt; do
iptables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
ip6tables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
done
netfilter-persistent save >/dev/null 2>&1
if command -v rc-service >/dev/null 2>&1 && command -v rc-update >/dev/null 2>&1; then
rc-update show default 2>/dev/null | grep -q 'iptables' || rc-update add iptables >/dev/null 2>&1
rc-update show default 2>/dev/null | grep -q 'ip6tables' || rc-update add ip6tables >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
fi
cip
echo
if grep -qE 'vmess-httpupgrade|trojan-xhttp|vmess-xhttp|ss-ws|vless-ws-enc' "$HOME/agsbx/xr.json" 2>/dev/null; then
basepath=$(cat "$HOME/agsbx/basepath" 2>/dev/null)
echo "=== CF Origin Rules 配置指引 ==="
echo "B组协议需在CF面板手动配置Origin Rules(客户端443→CF→path回源到39000-39004)"
echo "请在 Cloudflare Dashboard → Rules → Origin Rules 中添加以下规则："
echo
if grep -q 'vmess-httpupgrade' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: VMess+HTTPUpgrade"
echo "  条件: URI Path starts with \"/${basepath}-mu\""
echo "  操作: Rewrite to Destination Port → 39000"
fi
if grep -q 'trojan-xhttp' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: Trojan+XHTTP"
echo "  条件: URI Path starts with \"/${basepath}-tx\""
echo "  操作: Rewrite to Destination Port → 39001"
fi
if grep -q 'vmess-xhttp' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: VMess+XHTTP"
echo "  条件: URI Path starts with \"/${basepath}-mx\""
echo "  操作: Rewrite to Destination Port → 39002"
fi
if grep -q 'ss-ws' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: Shadowsocks+WS"
echo "  条件: URI Path starts with \"/${basepath}-sw\""
echo "  操作: Rewrite to Destination Port → 39003"
fi
if grep -q 'vless-ws-enc' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: VLESS+WS+ENC"
echo "  条件: URI Path starts with \"/${basepath}-vwe\""
echo "  操作: Rewrite to Destination Port → 39004"
fi
echo
echo "注意1: 使用\"starts with\"而非\"contains\"，避免子串误匹配"
echo "注意2: CF Free计划限10条规则，B组最多5条Origin Rules"
echo "注意3: gRPC协议(VLESS/Trojan/VMess gRPC)走A组443 fallbacks，不走Origin Rules"
echo "注意4: 使用gRPC前需在CF Dashboard → Network → 开启gRPC开关"
echo
fi
else
echo "Argosbx脚本已安装"
echo
argosbxstatus
echo
echo "相关快捷方式如下："
showmode
exit
fi
