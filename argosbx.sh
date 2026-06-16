#!/bin/sh
export LANG=en_US.UTF-8

# ===== S0: 安全加固初始化 =====
umask 077
# 6.6.20 严格模式说明：
# 不引入 set -e（会破坏脚本现有的 >/dev/null 2>&1 || return 1 错误处理模式）
# 不引入 set -u（会破坏脚本现有的 ${var+x} 和直接 $var 引用模式）
# 替代方案：通过 _log 函数记录关键事件 + 显式 || 分支错误处理
# 6.6.22 结构化日志：所有操作记录到 install.log
agsbx_logfile="$HOME/agsbx/install.log"
mkdir -p "$HOME/agsbx" 2>/dev/null
_log() {
  # 用法: _log "level" "message"  或  _log "message"(默认INFO)
  if [ $# -ge 2 ]; then
    _lvl="$1"; shift; _msg="$*"
  else
    _lvl="INFO"; _msg="$1"
  fi
  printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date)" "$_lvl" "$_msg" >> "$agsbx_logfile" 2>/dev/null
}
_log "INFO" "argosbx 启动，PID=$$"
# 注意：bash 把 EUID 作为只读内置变量，POSIX sh 则允许赋值。
# 统一改用 _euid 避免 bash 直接运行时报 "EUID: readonly variable"
_euid=$(id -u 2>/dev/null || echo 0)
agsbx_lockfile="/var/lock/argosbx.lock"
agsbx_tmpdir="${TMPDIR:-/tmp}"
agsbx_cleanup(){
  [ -n "$agsbx_cftoken_tmp" ] && [ -f "$agsbx_cftoken_tmp" ] && shred -u "$agsbx_cftoken_tmp" 2>/dev/null || rm -f "$agsbx_cftoken_tmp" 2>/dev/null
  [ -f "$agsbx_lockfile" ] && flock -u 200 2>/dev/null
}
trap 'agsbx_cleanup; exit 1' INT TERM
trap 'agsbx_cleanup' EXIT
if [ -z "$1" ] || { [ "$1" != "list" ] && [ "$1" != "doctor" ] && [ "$1" != "backup" ] && [ "$1" != "restore" ]; }; then
  exec 200>"$agsbx_lockfile" 2>/dev/null && flock -n 200 2>/dev/null || { echo "⚠️ 另一个argosbx实例正在运行，请等待其完成或手动删除锁文件: $agsbx_lockfile"; exit 1; }
fi

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
[ "$vwp" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || [ "$vup" = yes ] || [ "$twp" = yes ] || [ "$tuhp" = yes ] || [ "$vgp" = yes ] || [ "$tgp" = yes ] || [ "$mgp" = yes ] || [ "$mup" = yes ] || [ "$txp" = yes ] || [ "$mxp" = yes ] || [ "$swp" = yes ] || [ "$vwep" = yes ] || [ "$stp" = yes ] || [ "$nap" = yes ] || [ "$trp" = yes ] || [ "$vtp" = yes ] || [ "$ttp" = yes ] || { echo "提示：rep重置协议时，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
else
# 未安装场景：如果是交互式TTY且无协议变量，跳过exit让S8菜单处理；否则保持原exit逻辑
if [ -z "$1" ] && [ -t 0 ] 2>/dev/null && [ -z "${vlp:-}${vmp:-}${vwp:-}${hyp:-}${tup:-}${xhp:-}${vxp:-}${anp:-}${ssp:-}${arp:-}${sop:-}${vup:-}${twp:-}${tuhp:-}${vgp:-}${tgp:-}${mgp:-}${mup:-}${txp:-}${mxp:-}${swp:-}${vwep:-}${stp:-}${nap:-}${trp:-}${vtp:-}${ttp:-}" ]; then
  : # 进入交互菜单模式(在S8入口触发)，跳过协议变量exit检测
else
[ "$1" = "del" ] || [ "$vwp" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || [ "$vup" = yes ] || [ "$twp" = yes ] || [ "$tuhp" = yes ] || [ "$vgp" = yes ] || [ "$tgp" = yes ] || [ "$mgp" = yes ] || [ "$mup" = yes ] || [ "$txp" = yes ] || [ "$mxp" = yes ] || [ "$swp" = yes ] || [ "$vwep" = yes ] || [ "$stp" = yes ] || [ "$nap" = yes ] || [ "$trp" = yes ] || [ "$vtp" = yes ] || [ "$ttp" = yes ] || { echo "提示：未安装argosbx脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
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

# alloc_port portvar — 端口分配(随机/指定/持久化，flock串行化防竞态)
alloc_port() {
  local _apvar="$1"
  local _apval
  eval _apval="\$$_apvar"
  local _apfile="$HOME/agsbx/$_apvar"
  # 用{ }命令组(非子shell)，确保变量赋值在当前shell生效
  # flock持有FD9锁直到}关闭，保证串行化
  {
    flock 9
    if [ -z "$_apval" ] && [ ! -e "$_apfile" ]; then
      eval "$_apvar=\$(shuf -i 39017-40000 -n 1)"
      eval "echo \"\$$_apvar\" > \"$_apfile\""
    elif [ -n "$_apval" ]; then
      eval "echo \"\$$_apvar\" > \"$_apfile\""
    fi
    eval "$_apvar=\$(cat \"$_apfile\")"
  } 9>"$HOME/agsbx/.port.lock"
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

# validate_input — 验证用户输入的安全性(域名/UUID/basepath/端口)
validate_input() {
  # 域名验证: 允许字母/数字/连字符/下划线(部分DNS provider如CF支持下划线子域名)
  if [ -n "$cdnym" ]; then
    echo "$cdnym" | grep -qE '^[a-zA-Z0-9_]([a-zA-Z0-9_-]*[a-zA-Z0-9_])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*$' || { echo "⚠️ 域名格式无效: $cdnym"; exit 1; }
  fi
  if [ -n "$uuid" ]; then
    echo "$uuid" | grep -qiE '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' || { echo "⚠️ UUID格式无效: $uuid"; exit 1; }
  fi
  if [ -n "$basepath" ]; then
    echo "$basepath" | grep -qE '^[a-zA-Z0-9_-]+$' || { echo "⚠️ basepath含非法字符(仅允许字母数字下划线连字符): $basepath"; exit 1; }
  fi
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
  # vw: VLESS+WS (tag=vless-ws, Argo端口39007)
  if [ -n "$argo_vw" ] && grep -q '"tag":"vless-ws"' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vw | HTTP | localhost:39007\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39007; argo_count=$((argo_count+1))
  fi
  # vx: VLESS+XHTTP (tag=vless-xhttp, Argo端口39008)
  if [ -n "$argo_vx" ] && grep -q 'vless-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vx | HTTP | localhost:39008\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39008; argo_count=$((argo_count+1))
  fi
  # vm: VMess+WS (tag=vmess-ws, Argo端口39009)
  if [ -n "$argo_vm" ] && grep -q 'vmess-ws' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vm | HTTP | localhost:39009\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39009; argo_count=$((argo_count+1))
  fi
  # vu: VLESS+HTTPUpgrade+ENC (tag=vless-httpupgrade, Argo端口39010)
  if [ -n "$argo_vu" ] && grep -q 'vless-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-vu | HTTP | localhost:39010\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39010; argo_count=$((argo_count+1))
  fi
  # tw: Trojan+WS (tag=trojan-ws, Argo端口39011)
  if [ -n "$argo_tw" ] && grep -q 'trojan-ws' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tw | HTTP | localhost:39011\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39011; argo_count=$((argo_count+1))
  fi
  # tu: Trojan+HTTPUpgrade (tag=trojan-httpupgrade, Argo端口39012)
  if [ -n "$argo_tu" ] && grep -q 'trojan-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tuh | HTTP | localhost:39012\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39012; argo_count=$((argo_count+1))
  fi
  # mu: VMess+HTTPUpgrade (tag=vmess-httpupgrade, Argo端口39013)
  if [ -n "$argo_mu" ] && grep -q 'vmess-httpupgrade' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-mu | HTTP | localhost:39013\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39013; argo_count=$((argo_count+1))
  fi
  # tx: Trojan+XHTTP (tag=trojan-xhttp, Argo端口39014)
  if [ -n "$argo_tx" ] && grep -q 'trojan-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-tx | HTTP | localhost:39014\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39014; argo_count=$((argo_count+1))
  fi
  # mx: VMess+XHTTP (tag=vmess-xhttp, Argo端口39015)
  if [ -n "$argo_mx" ] && grep -q 'vmess-xhttp' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-mx | HTTP | localhost:39015\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39015; argo_count=$((argo_count+1))
  fi
  # sw: SS+WS (tag=ss-ws, Argo端口39016)
  if [ -n "$argo_sw" ] && grep -q '"tag":"ss-ws"' "$_xrjson" 2>/dev/null; then
    argo_cf_rules="${argo_cf_rules}  ${ARGO_DOMAIN} | ^/${basepath}-sw | HTTP | localhost:39016\\n"
    [ -z "$argo_first_port" ] && argo_first_port=39016; argo_count=$((argo_count+1))
  fi
  echo "$argo_first_port" > "$HOME/agsbx/argoport.log"
  # 持久化选中Argo的已安装协议缩写列表(cip函数读取)
  argo_sel_list=""
  for _p in vw vx vm vu tw tu mu tx mx sw; do
    eval "_flag=\$argo_$_p"
    if [ -n "$_flag" ]; then
      case $_p in
        vw) grep -q '"tag":"vless-ws"' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vw" ;;
        vx) grep -q 'vless-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vx" ;;
        vm) grep -q 'vmess-ws' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vm" ;;
        vu) grep -q 'vless-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list vu" ;;
        tw) grep -q 'trojan-ws' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tw" ;;
        tu) grep -q 'trojan-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tu" ;;
        mu) grep -q 'vmess-httpupgrade' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list mu" ;;
        tx) grep -q 'trojan-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list tx" ;;
        mx) grep -q 'vmess-xhttp' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list mx" ;;
        sw) grep -q '"tag":"ss-ws"' "$_xrjson" 2>/dev/null && argo_sel_list="$argo_sel_list sw" ;;
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
  # 跨证书复用检测: 扫描已有证书,若SAN/CN覆盖目标域名则复用(避免泛域名证书重复签发)
  if command -v openssl >/dev/null 2>&1; then
    for _existing_crt in /etc/argosbx/certs/*.crt; do
      [ -f "$_existing_crt" ] || continue
      _existing_key="${_existing_crt%.crt}.key"
      [ -f "$_existing_key" ] || continue
      # 提取目标域名的上级根域(cdn_us.begonia92.top → begonia92.top)用于通配符匹配
      _csroot=$(echo "$_csdomain" | awk -F. '{if(NF>=2){for(i=2;i<=NF;i++){printf "%s%s",$i,(i<NF?".":"")}}else{print}}')
      # 检查证书SAN/CN是否包含目标域名或其泛域名(*.根域)
      if openssl x509 -in "$_existing_crt" -noout -text 2>/dev/null | grep -A1 -E "Subject Alternative Name|Subject:" | grep -qE "\\*\\.$_csroot|[^a-zA-Z0-9.-]$_csdomain([^a-zA-Z0-9.-]|\\$)"; then
        cp -f "$_existing_crt" "$_cscrt"
        cp -f "$_existing_key" "$_cskey"
        chmod 600 "$_cskey"
        echo "✅ 复用已有证书: $_existing_crt → $_cscrt (覆盖 $_csdomain)"
        return 0
      fi
    done
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
    --reloadcmd "if command -v systemctl >/dev/null 2>&1; then systemctl restart xray 2>/dev/null || echo 'warn: xray restart failed'; systemctl restart sing-box 2>/dev/null || echo 'warn: sing-box restart failed'; elif command -v rc-service >/dev/null 2>&1; then rc-service xray restart 2>/dev/null || echo 'warn: xray restart failed'; rc-service sing-box restart 2>/dev/null || echo 'warn: sing-box restart failed'; fi"
  unset CF_Token CF_Zone_ID
  echo "✅ 证书签发成功: $_csdomain → $_cscrt"
}

# tpl_xr 模板名 [端口] — 加载xray inbound模板，替换占位符，追加到xr.json(末尾加逗号)
tpl_xr() {
  local _tplname="$1"
  local _tplport="${2:-}"
  local _tpldir="$HOME/agsbx/templates/xr"
  local _tplfile="$_tpldir/$_tplname.json"
  mkdir -p "$_tpldir"
  if [ ! -f "$_tplfile" ]; then
    dl "$tplbaseurl/xr/$_tplname.json" "$_tplfile" || { echo "⚠️ 模板下载失败: $_tplname"; return 1; }
  fi
  sed -e "s|__UUID__|${uuid}|g" \
      -e "s|__BASEPATH__|${basepath}|g" \
      -e "s|__DEKEY__|${dekey}|g" \
      -e "s|__ENKEY__|${enkey}|g" \
      -e "s|__SSKEY__|${sskey}|g" \
      -e "s|__PORT__|${_tplport}|g" \
      -e "s|__YM_VL_RE__|${ym_vl_re}|g" \
      -e "s|__PRIVATE_KEY_X__|${private_key_x}|g" \
      -e "s|__SHORT_ID_X__|${short_id_x}|g" \
      "$_tplfile" | sed '$s/$/,/' >> "$HOME/agsbx/xr.json"
}

# tpl_sb 模板名 — 加载sing-box inbound模板，替换占位符，追加到sb.json(末尾加逗号)
tpl_sb() {
  local _tplname="$1"
  local _tplport="${2:-}"
  local _tpldir="$HOME/agsbx/templates/sb"
  local _tplfile="$_tpldir/$_tplname.json"
  mkdir -p "$_tpldir"
  if [ ! -f "$_tplfile" ]; then
    dl "$tplbaseurl/sb/$_tplname.json" "$_tplfile" || { echo "⚠️ 模板下载失败: $_tplname"; return 1; }
  fi
  sed -e "s|__UUID__|${uuid}|g" \
      -e "s|__PORT__|${_tplport}|g" \
      -e "s|__STLSPASS__|${stlspass}|g" \
      -e "s|__SSINTKEY__|${ssintkey}|g" \
      -e "s|__STLS_DEST__|${stls_dest}|g" \
      -e "s|__NAP_USER__|${nap_user}|g" \
      -e "s|__YM_VL_RE__|${ym_vl_re}|g" \
      -e "s|__PRIVATE_KEY_S__|${private_key_s}|g" \
      -e "s|__SHORT_ID_S__|${short_id_s}|g" \
      -e "s|__HOME__|${HOME}|g" \
      "$_tplfile" | sed '$s/$/,/' >> "$HOME/agsbx/sb.json"
}

# tpl_fw 子目录 模板名 — 加载框架配置(header/outbound), sed替换WARP变量, 输出到stdout(不加逗号)
# 用法: tpl_fw xr header.json > xr.json  /  tpl_fw xr outbound.json >> xr.json
tpl_fw() {
  local _fwsub="$1"
  local _fwtpl="$2"
  local _fwdir="$HOME/agsbx/templates/$_fwsub"
  local _fwfile="$_fwdir/$_fwtpl"
  mkdir -p "$_fwdir"
  if [ ! -f "$_fwfile" ]; then
    dl "$tplbaseurl/$_fwsub/$_fwtpl" "$_fwfile" || { echo "⚠️ 框架模板下载失败: $_fwsub/$_fwtpl"; return 1; }
  fi
  sed -e "s|__XRYX__|${xryx:-ForceIPv4v6}|g" \
      -e "s|__WXRYX__|${wxryx:-ForceIPv6v4}|g" \
      -e "s|__SRYX__|${sbyx:-prefer_ipv6}|g" \
      -e "s|__SBYX__|${sbyx:-prefer_ipv6}|g" \
      -e "s|__PVK__|${pvk:-}|g" \
      -e "s|__WPV6__|${wpv6:-}|g" \
      -e "s|__XENDIP__|${xendip:-engage.cloudflareclient.com}|g" \
      -e "s|__SENDIP__|${sendip:-162.159.192.1}|g" \
      -e "s|__RES__|${res:-[]}|g" \
      -e "s|__XIP__|${xip:-}|g" \
      -e "s|__SIP__|${sip:-}|g" \
      -e "s|__X1OUTTAG__|${x1outtag:-direct}|g" \
      -e "s|__X2OUTTAG__|${x2outtag:-direct}|g" \
      -e "s|__S1OUTTAG__|${s1outtag:-direct}|g" \
      -e "s|__S2OUTTAG__|${s2outtag:-direct}|g" \
      -e "s|__HOME__|${HOME}|g" \
      "$_fwfile"
}

# tpl_client 模板名 输出文件 — 加载客户端配置, awk替换多行占位符
# 用法: tpl_client clmi-client.yaml $HOME/agsbx/clmi.yaml
tpl_client() {
  local _ctpl="$1"
  local _cout="$2"
  local _cdir="$HOME/agsbx/templates/client"
  local _cfile="$_cdir/$_ctpl"
  mkdir -p "$_cdir"
  if [ ! -f "$_cfile" ]; then
    dl "$tplbaseurl/client/$_ctpl" "$_cfile" || { echo "⚠️ 客户端模板下载失败: $_ctpl"; return 1; }
  fi
  awk -v sbxy="${sbxy:-}" -v sbgz="${sbgz:-}" -v clxy="${clxy:-}" -v clgz="${clgz:-}" \
    '{gsub(/__SBXY__/, sbxy); gsub(/__SBGZ__/, sbgz); gsub(/__CLXY__/, clxy); gsub(/__CLGZ__/, clgz); print}' \
    "$_cfile" > "$_cout.tmp" 2>/dev/null && mv "$_cout.tmp" "$_cout"
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
mkdir -p "$HOME/agsbx" && chmod 700 "$HOME/agsbx"
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
# 6.5.17 SHA256校验：从GitHub release获取checksum对照
# 6.5.18 升级回滚机制：下载前备份旧二进制，校验/启动失败自动回退
_dl_kernel() {
  # 用法: _dl_kernel url output [min_size_KB]
  local _url="$1" _out="$2" _min_kb="${3:-1024}"
  if ! dl "$_url" "$_out"; then
    _log "ERROR" "下载失败: $_url"
    return 1
  fi
  if [ "$(wc -c < "$_out" 2>/dev/null || echo 0)" -lt "$((_min_kb * 1024))" ]; then
    _log "ERROR" "文件过小(<${_min_kb}KB)，可能不完整: $_out"
    rm -f "$_out"
    return 1
  fi
  return 0
}
upxray(){
xrarch="64"
[ "$cpu" = "arm64" ] && xrarch="arm64-v8a"
xrcore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/XTLS/Xray-core" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Xray官方最新正式版内核：$xrcore"
_log "INFO" "开始升级xray-core到 v${xrcore}"
# 6.5.18 升级前备份旧二进制
if [ -f "$HOME/agsbx/xray" ]; then
  cp -p "$HOME/agsbx/xray" "$HOME/agsbx/xray.bak"
  _log "INFO" "已备份旧xray到 xray.bak"
fi
tmpdir=$(mktemp -d)
url="https://github.com/XTLS/Xray-core/releases/download/v${xrcore}/Xray-linux-${xrarch}.zip"
out="$tmpdir/xray.zip"
# 6.5.17+6.5.18：下载+大小校验，失败自动回滚
if ! _dl_kernel "$url" "$out" 1024; then
  echo "⚠️ Xray内核下载失败"
  if [ -f "$HOME/agsbx/xray.bak" ]; then mv "$HOME/agsbx/xray.bak" "$HOME/agsbx/xray"; _log "WARN" "已回滚到旧xray"; fi
  rm -rf "$tmpdir"; return 1
fi
# 6.5.17 SHA256 校验(从release页面获取xray.zip的dgst文件)
sha_url="https://github.com/XTLS/Xray-core/releases/download/v${xrcore}/Xray-linux-${xrarch}.zip.dgst"
sha_expected=$(dl_s "$sha_url" 2>/dev/null | awk '/SHA256/ {print $NF; exit}' | tr -d '\r\n')
if [ -n "$sha_expected" ]; then
  sha_actual=$(sha256sum "$out" 2>/dev/null | awk '{print $1}')
  if [ "$sha_actual" != "$sha_expected" ]; then
    echo "⚠️ Xray内核SHA256校验失败(期望 ${sha_expected:0:16}... 实际 ${sha_actual:0:16}...)"
    _log "ERROR" "xray SHA256 mismatch"
    if [ -f "$HOME/agsbx/xray.bak" ]; then mv "$HOME/agsbx/xray.bak" "$HOME/agsbx/xray"; _log "WARN" "已回滚"; fi
    rm -rf "$tmpdir"; return 1
  fi
  echo "✅ Xray内核SHA256校验通过"
  _log "INFO" "xray SHA256 校验通过"
else
  echo "⚠️ 无法获取Xray SHA256参考值，跳过完整性校验"
  _log "WARN" "xray SHA256 ref not available"
fi
command -v unzip >/dev/null 2>&1 || { command -v apk >/dev/null 2>&1 && apk add --no-cache unzip >/dev/null 2>&1; } || { command -v apt >/dev/null 2>&1 && apt install -y unzip >/dev/null 2>&1; }
unzip -o "$out" -d "$tmpdir/xray_extract" >/dev/null 2>&1
# 6.5.18 验证解压后的二进制可执行
if [ ! -x "$tmpdir/xray_extract/xray" ]; then
  echo "⚠️ Xray解压失败或二进制损坏"
  if [ -f "$HOME/agsbx/xray.bak" ]; then mv "$HOME/agsbx/xray.bak" "$HOME/agsbx/xray"; _log "WARN" "已回滚"; fi
  rm -rf "$tmpdir"; return 1
fi
mv "$tmpdir/xray_extract/xray" "$HOME/agsbx/xray" 2>/dev/null
chmod +x "$HOME/agsbx/xray"
# 启动测试：version命令成功才视为升级成功
if ! "$HOME/agsbx/xray" version >/dev/null 2>&1; then
  echo "⚠️ 新xray二进制无法运行，回滚"
  if [ -f "$HOME/agsbx/xray.bak" ]; then mv "$HOME/agsbx/xray.bak" "$HOME/agsbx/xray"; _log "WARN" "xray 二进制无法执行，已回滚"; fi
  rm -rf "$tmpdir"; return 1
fi
rm -f "$HOME/agsbx/xray.bak"
rm -rf "$tmpdir"
sbcore=$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
_log "INFO" "xray 升级完成: $sbcore"
}
upsingbox(){
sbarch="$cpu"
sbcore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/SagerNet/sing-box" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Sing-box官方最新正式版内核：$sbcore"
_log "INFO" "开始升级sing-box到 v${sbcore}"
# 6.5.18 升级前备份旧二进制
if [ -f "$HOME/agsbx/sing-box" ]; then
  cp -p "$HOME/agsbx/sing-box" "$HOME/agsbx/sing-box.bak"
  _log "INFO" "已备份旧sing-box到 sing-box.bak"
fi
tmpdir=$(mktemp -d)
url="https://github.com/SagerNet/sing-box/releases/download/v${sbcore}/sing-box-${sbcore}-linux-${sbarch}.tar.gz"
out="$tmpdir/sing-box.tar.gz"
if ! _dl_kernel "$url" "$out" 1024; then
  echo "⚠️ Sing-box内核下载失败"
  if [ -f "$HOME/agsbx/sing-box.bak" ]; then mv "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box"; _log "WARN" "已回滚"; fi
  rm -rf "$tmpdir"; return 1
fi
# 6.5.17 SHA256校验(sing-box 提供 checksums.txt)
sha_url="https://github.com/SagerNet/sing-box/releases/download/v${sbcore}/sing-box-${sbcore}.checksums.txt"
sha_expected=$(dl_s "$sha_url" 2>/dev/null | awk -v f="sing-box-${sbcore}-linux-${sbarch}.tar.gz" '$2==f {print $1; exit}')
if [ -n "$sha_expected" ]; then
  sha_actual=$(sha256sum "$out" 2>/dev/null | awk '{print $1}')
  if [ "$sha_actual" != "$sha_expected" ]; then
    echo "⚠️ Sing-box内核SHA256校验失败(期望 ${sha_expected:0:16}... 实际 ${sha_actual:0:16}...)"
    _log "ERROR" "sing-box SHA256 mismatch"
    if [ -f "$HOME/agsbx/sing-box.bak" ]; then mv "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box"; _log "WARN" "已回滚"; fi
    rm -rf "$tmpdir"; return 1
  fi
  echo "✅ Sing-box内核SHA256校验通过"
  _log "INFO" "sing-box SHA256 校验通过"
else
  echo "⚠️ 无法获取Sing-box SHA256参考值，跳过完整性校验"
  _log "WARN" "sing-box SHA256 ref not available"
fi
tar -xzf "$out" -C "$tmpdir" >/dev/null 2>&1
if [ ! -x "$tmpdir/sing-box-${sbcore}-linux-${sbarch}/sing-box" ]; then
  echo "⚠️ Sing-box解压失败或二进制损坏"
  if [ -f "$HOME/agsbx/sing-box.bak" ]; then mv "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box"; _log "WARN" "已回滚"; fi
  rm -rf "$tmpdir"; return 1
fi
mv "$tmpdir/sing-box-${sbcore}-linux-${sbarch}/sing-box" "$HOME/agsbx/sing-box" 2>/dev/null
chmod +x "$HOME/agsbx/sing-box"
if ! "$HOME/agsbx/sing-box" version >/dev/null 2>&1; then
  echo "⚠️ 新sing-box二进制无法运行，回滚"
  if [ -f "$HOME/agsbx/sing-box.bak" ]; then mv "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box"; _log "WARN" "sing-box 二进制无法执行，已回滚"; fi
  rm -rf "$tmpdir"; return 1
fi
rm -f "$HOME/agsbx/sing-box.bak"
rm -rf "$tmpdir"
sbcore=$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
_log "INFO" "sing-box 升级完成: $sbcore"
}
upcloudflared(){
argocore=$(dl_s "https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared" | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Cloudflared官方最新正式版内核：$argocore"
_log "INFO" "开始升级cloudflared到 v${argocore}"
# 6.5.18 升级前备份旧二进制
if [ -f "$HOME/agsbx/cloudflared" ]; then
  cp -p "$HOME/agsbx/cloudflared" "$HOME/agsbx/cloudflared.bak"
  _log "INFO" "已备份旧cloudflared到 cloudflared.bak"
fi
url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu"
out="$HOME/agsbx/cloudflared"
if ! _dl_kernel "$url" "$out" 512; then
  echo "⚠️ Cloudflared内核下载失败"
  if [ -f "$HOME/agsbx/cloudflared.bak" ]; then mv "$HOME/agsbx/cloudflared.bak" "$HOME/agsbx/cloudflared"; _log "WARN" "已回滚"; fi
  return 1
fi
chmod +x "$HOME/agsbx/cloudflared"
# 6.5.18 启动测试
if ! "$HOME/agsbx/cloudflared" version >/dev/null 2>&1; then
  echo "⚠️ 新cloudflared二进制无法运行，回滚"
  if [ -f "$HOME/agsbx/cloudflared.bak" ]; then mv "$HOME/agsbx/cloudflared.bak" "$HOME/agsbx/cloudflared"; _log "WARN" "cloudflared 二进制无法执行，已回滚"; fi
  return 1
fi
rm -f "$HOME/agsbx/cloudflared.bak"
echo "已安装Cloudflared正式版内核：$argocore"
_log "INFO" "cloudflared 升级完成: $argocore"
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
# 端口冲突预检测(A组CF固定端口)
for _cfport in 443 2053 2083 2087 2096 8443 39000 39001 39002 39003 39004; do
  if ss -tln 2>/dev/null | grep -q ":$_cfport " || netstat -tln 2>/dev/null | grep -q ":$_cfport "; then
    _conflict_proc=$(ss -tlnp 2>/dev/null | grep ":$_cfport " | head -1 || netstat -tlnp 2>/dev/null | grep ":$_cfport " | head -1)
    echo "⚠️ 端口 $_cfport 已被占用: $_conflict_proc"
    echo "   如占用的是xray/sing-box自身(重装场景)可忽略，否则请先释放该端口"
  fi
done
mkdir -p "$HOME/agsbx/xrk"
if [ ! -e "$HOME/agsbx/xray" ]; then
upxray
fi
tpl_fw xr header.json > "$HOME/agsbx/xr.json"
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

# 输入安全验证(域名/UUID/basepath格式校验)
validate_input

if [ -n "$xhp" ]; then
xhp=xhpt
alloc_port port_xh
 echo "Vless-xhttp-reality-enc端口：$port_xh"
tpl_xr a-xh-reality "$port_xh"
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
tpl_xr a-vx-xhttp
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
tpl_xr a-vu-httpupgrade
else
vup=vuptargo
fi
if [ -n "$twp" ]; then
twp=twpt
 echo "Trojan-ws端口：2096 (CF HTTPS固定端口)"
tpl_xr a-tw-ws
else
twp=twptargo
fi
if [ -n "$tuhp" ]; then
tuhp=tuhpt
 echo "Trojan-httpupgrade端口：8443 (CF HTTPS固定端口)"
tpl_xr a-tu-httpupgrade
else
tuhp=tuhptargo
fi
if [ -n "$vgp" ]; then
vgp=vgpt
 echo "Vless-grpc-enc：443 fallbacks转发 (Unix socket @vless-grpc, TLS在443终止)"
tpl_xr a-vg-grpc
else
vgp=vgptargo
fi
if [ -n "$tgp" ]; then
tgp=tgpt
 echo "Trojan-grpc：443 fallbacks转发 (Unix socket @trojan-grpc, TLS在443终止)"
tpl_xr a-tg-grpc
else
tgp=tgptargo
fi
if [ -n "$mgp" ]; then
mgp=mgpt
 echo "Vmess-grpc：443 fallbacks转发 (Unix socket @vmess-grpc, TLS在443终止)"
tpl_xr a-mg-grpc
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
  sskey=$(head -c 16 /dev/urandom | base64 | tr -d '\n')
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
tpl_xr c-vl-reality-vision "$port_vl_re"
else
vlp=vlptargo
fi
if [ -n "$trp" ]; then
  trp=trpt
  [ -z "$ym_vl_re" ] && ym_vl_re=apple.com
  echo "Reality域名：$ym_vl_re"
  alloc_port port_tr
  echo "Trojan+Reality端口：$port_tr"
  tpl_xr c-tr-reality "$port_tr"
fi
if [ -n "$vtp" ]; then
  vtp=vtpt
  alloc_port port_vtv
  echo "VLESS+TLS+Vision端口：$port_vtv"
  tpl_xr c-vt-tls-vision "$port_vtv"
fi
if [ -n "$ttp" ]; then
  ttp=ttpt
  alloc_port port_tt
  echo "Trojan+TLS端口：$port_tt"
  tpl_xr c-tt-tls "$port_tt"
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsbx/sing-box" ]; then
upsingbox
fi
tpl_fw sb header.json > "$HOME/agsbx/sb.json"
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
tpl_sb c-hy2 "$port_hy2"
else
hyp=hyptargo
fi
if [ -n "$tup" ]; then
tup=tupt
alloc_port port_tu
 echo "Tuic端口：$port_tu"
tpl_sb c-tu "$port_tu"
else
tup=tuptargo
fi
if [ -n "$anp" ]; then
anp=anpt
alloc_port port_an
 echo "Anytls端口：$port_an"
tpl_sb c-an "$port_an"
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
  tpl_sb c-ar "$port_ar"
else
arp=arptargo
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/agsbx/sskey" ]; then
sskey=$(head -c 32 /dev/urandom | base64 | tr -d '\n')
echo "$sskey" > "$HOME/agsbx/sskey"
fi
  alloc_port port_ss
  sskey=$(cat "$HOME/agsbx/sskey")
  echo "Shadowsocks-2022端口：$port_ss"
  tpl_sb c-ss "$port_ss"
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
  tpl_sb c-stls "$port_st"
fi
if [ -n "$nap" ]; then
  nap=napt
  [ -z "$nap_user" ] && nap_user=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 8)
  echo "$nap_user" > "$HOME/agsbx/nap_user"
  alloc_port port_na
  echo "Naive端口：$port_na"
  tpl_sb c-na "$port_na"
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
gen_basepath
echo "Vmess-ws：xray模式→端口2083(CF固定) / singbox模式→随机端口"
alloc_port port_vm_ws
if [ -e "$HOME/agsbx/xr.json" ]; then
tpl_xr a-vm-ws
else
tpl_sb c-vm "$port_vm_ws"
fi
else
vmp=vmptargo
fi
}

xrsbso(){
# SOCKS5已移除(V2.9.1): 认证明文传输，功能被SS-2022直连完全覆盖
sop=soptargo
}

xrsbout(){
if [ -e "$HOME/agsbx/xr.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/xr.json"
tpl_fw xr outbound.json >> "$HOME/agsbx/xr.json"
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && [ "$_euid" -eq 0 ]; then
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
systemctl restart xr >/dev/null 2>&1
# 6.2.9 服务启动失败处理：sleep 2 后 is-active 确认，失败则打印日志
sleep 2
if ! systemctl is-active --quiet xr 2>/dev/null; then
  echo "⚠️ xr 服务启动失败，最近日志："
  journalctl -u xr --no-pager -n 15 2>/dev/null
  _log "ERROR" "xr 服务启动失败"
fi
elif command -v rc-service >/dev/null 2>&1 && [ "$_euid" -eq 0 ]; then
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
tpl_fw sb outbound.json >> "$HOME/agsbx/sb.json"
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && [ "$_euid" -eq 0 ]; then
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
systemctl restart sb >/dev/null 2>&1
# 6.2.9 服务启动失败处理
sleep 2
if ! systemctl is-active --quiet sb 2>/dev/null; then
  echo "⚠️ sb 服务启动失败，最近日志："
  journalctl -u sb --no-pager -n 15 2>/dev/null
  _log "ERROR" "sb 服务启动失败"
fi
elif command -v rc-service >/dev/null 2>&1 && [ "$_euid" -eq 0 ]; then
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
if [ -n "$directnym" ] && [ -n "$cfapi" ] && { [ -n "$vtp" ] || [ -n "$ttp" ] || [ -n "$hyp" ] || [ -n "$tup" ] || [ -n "$anp" ] || [ -n "$nap" ]; }; then
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
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && [ "$_euid" -eq 0 ]; then
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
systemctl restart argo >/dev/null 2>&1
# 6.2.9 服务启动失败处理
sleep 2
if ! systemctl is-active --quiet argo 2>/dev/null; then
  echo "⚠️ argo 服务启动失败，最近日志："
  journalctl -u argo --no-pager -n 15 2>/dev/null
  _log "ERROR" "argo 服务启动失败"
fi
elif command -v rc-service >/dev/null 2>&1 && [ "$_euid" -eq 0 ]; then
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
if ! [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && ! command -v rc-service >/dev/null 2>&1; then
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行Argosbx脚本的节点恢复操作，请稍等……'; sleep 6; export cfip=\"${cfip}\" hyjpt=\"${hyjpt}\" cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" argo=\"${argo}\" argopro=\"${argopro}\" uuid=\"${uuid}\" $wap=\"${warp}\" $xhp=\"${port_xh}\" $vxp=\"${port_vx}\" $ssp=\"${port_ss}\" $sop=\"${port_so}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $vwp=\"${port_vw}\" $vmp=\"${port_vm_ws}\" $hyp=\"${port_hy2}\" $tup=\"${port_tu}\" $stp=\"${port_st}\" $nap=\"${port_na}\" $trp=\"${port_tr}\" $vtp=\"${port_vtv}\" $ttp=\"${port_tt}\" reym=\"${ym_vl_re}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash "$HOME/bin/agsbx"; fi" >> ~/.bashrc
fi
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
if ! [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && ! command -v rc-service >/dev/null 2>&1; then
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
if ! [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] && ! command -v rc-service >/dev/null 2>&1; then
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
# 证书过期监控(每日检测，<30天告警) — 与init系统无关，所有平台都启用
sed -i '/cert_warn/d' /tmp/crontab.tmp 2>/dev/null
echo '0 6 * * * for _c in /etc/argosbx/certs/*.crt; do [ -f "$_c" ] || continue; _e=$(openssl x509 -enddate -noout -in "$_c" 2>/dev/null | cut -d= -f2); _d=$(( ($(date -d "$_e" +%s 2>/dev/null || echo 0) - $(date +%s)) / 86400 )); [ "$_d" -lt 30 ] && echo "⚠️ 证书 $(basename "$_c") 剩余 ${_d} 天" >> "$HOME/agsbx/cert_warn.log"; done' >> /tmp/crontab.tmp
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
echo "# ========== CDN直通(A组) ==========" >> "$HOME/agsbx/jhsub.txt"
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
if grep "\"tag\":\"xhttp-reality\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/agsbx/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xh_link"
echo
fi
basepath=$(cat "$HOME/agsbx/basepath" 2>/dev/null)
if grep "\"tag\":\"vless-xhttp\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vless-ws\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vless-httpupgrade\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"trojan-ws\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"trojan-httpupgrade\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vless-grpc\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"trojan-grpc\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
echo "# ========== CDN Origin Rules(B组) ==========" >> "$HOME/agsbx/jhsub.txt"
if grep "\"tag\":\"vmess-httpupgrade\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"trojan-xhttp\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vmess-xhttp\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"ss-ws\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vless-ws-enc\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
echo "# ========== 非CDN直连(C组) ==========" >> "$HOME/agsbx/jhsub.txt"
if grep "\"tag\":\"reality-vision\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"ss-2022\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vmess-ws\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep "\"tag\":\"vmess-sb\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vmess-grpc\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"anytls-sb\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsbx/port_an")
an_link="anytls://$uuid@${directnym:-$server_ip}:$port_an?sni=${directnym:-$server_ip}#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsbx/jhsub.txt"
echo "$an_link"
echo
sbanpt(){
cat <<EOF
         {
            "type": "anytls",
            "tag": "${sxname}anytls-$hostname",
            "server": "${directnym:-$server_ip}",
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
if grep "\"tag\":\"anyreality-sb\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsbx/port_ar")
ar_link="vless://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&flow=xtls-rprx-vision#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ar_link"
echo
sbarpt(){
cat <<EOF
    {
        "type": "vless",
        "tag": "${sxname}any-reality-$hostname",
        "server": "$server_ip",
        "server_port": $port_ar,
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
if grep "\"tag\":\"hy2-sb\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
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
hy2_link="hysteria2://$uuid@${directnym:-$server_ip}:$port_hy2/?sni=${directnym:-$server_ip}&insecure=0$hyps#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$hy2_link"
echo
sbhypt(){
cat <<EOF
    {
        "type": "hysteria2",
        "tag": "${sxname}hy2-$hostname",
        "server": "${directnym:-$server_ip}",
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
if grep "\"tag\":\"tuic5-sb\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/agsbx/port_tu")
tuic5_link="tuic://$uuid:$uuid@${directnym:-$server_ip}:$port_tu/?sni=${directnym:-$server_ip}&congestion_control=cubic#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tuic5_link"
echo
sbtupt(){
cat <<EOF
        {
            "type":"tuic",
            "tag": "${sxname}tuic5-$hostname",
            "server": "${directnym:-$server_ip}",
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
# C9 ShadowTLS v3+SS (无官方URI，仅输出连接参数)
if grep "\"tag\":\"stls-in\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"naive-in\"" "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Naive 】节点信息如下："
port_na=$(cat "$HOME/agsbx/port_na")
nap_user=$(cat "$HOME/agsbx/nap_user")
nap_link="naive+https://${nap_user}:${uuid}@${directnym:-$server_ip}:${port_na}/#${sxname}naive-$hostname"
echo "$nap_link" >> "$HOME/agsbx/jhsub.txt"
echo "$nap_link"
echo
sbnapt(){
cat <<EOF
    {
      "type": "naive",
      "tag": "${sxname}naive-$hostname",
      "server": "${directnym:-$server_ip}",
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
if grep "\"tag\":\"trojan-reality\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"vless-tls-vision\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
if grep "\"tag\":\"trojan-tls\"" "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
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
echo "# ========== Argo隧道(D组) ==========" >> "$HOME/agsbx/jhsub.txt"
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
sbvwargopt(){
case " $argo_sel " in *" vw "*)
cat <<EOF
{
    "server": "$cdnip1",
    "server_port": 443,
    "tag": "${sxname}vless-ws-tls-argo-$hostname-443",
    "tls": { "enabled": true, "server_name": "$argodomain", "insecure": false, "utls": { "enabled": true, "fingerprint": "chrome" } },
    "transport": { "headers": { "Host": ["$argodomain"] }, "path": "/$basepath-vw", "type": "ws" },
    "type": "vless", "uuid": "$uuid"
},
EOF
;; esac
}
sbvwargopt1(){
case " $argo_sel " in *" vw "*) echo "\"${sxname}vless-ws-tls-argo-$hostname-443\"," ;; esac
}
clvwargopt(){
case " $argo_sel " in *" vw "*)
cat <<EOF
- name: ${sxname}vless-ws-tls-argo-$hostname-443
  type: vless
  server: "$cdnip1"
  port: 443
  uuid: $uuid
  udp: true
  tls: true
  network: ws
  servername: $argodomain
  client-fingerprint: chrome
  ws-opts:
    path: "/$basepath-vw"
    headers:
      Host: $argodomain
EOF
;; esac
}
clvwargopt1(){
case " $argo_sel " in *" vw "*) echo "- ${sxname}vless-ws-tls-argo-$hostname-443" ;; esac
}
sbtwargopt(){
case " $argo_sel " in *" tw "*)
cat <<EOF
{
    "server": "$cdnip1",
    "server_port": 443,
    "tag": "${sxname}trojan-ws-tls-argo-$hostname-443",
    "tls": { "enabled": true, "server_name": "$argodomain", "insecure": false, "utls": { "enabled": true, "fingerprint": "chrome" } },
    "transport": { "headers": { "Host": ["$argodomain"] }, "path": "/$basepath-tw", "type": "ws" },
    "type": "trojan", "password": "$uuid"
},
EOF
;; esac
}
sbtwargopt1(){
case " $argo_sel " in *" tw "*) echo "\"${sxname}trojan-ws-tls-argo-$hostname-443\"," ;; esac
}
cltwargopt(){
case " $argo_sel " in *" tw "*)
cat <<EOF
- name: ${sxname}trojan-ws-tls-argo-$hostname-443
  type: trojan
  server: "$cdnip1"
  port: 443
  password: $uuid
  udp: true
  tls: true
  network: ws
  sni: $argodomain
  client-fingerprint: chrome
  ws-opts:
    path: "/$basepath-tw"
    headers:
      Host: $argodomain
EOF
;; esac
}
cltwargopt1(){
case " $argo_sel " in *" tw "*) echo "- ${sxname}trojan-ws-tls-argo-$hostname-443" ;; esac
}
sbtuargopt(){
case " $argo_sel " in *" tu "*)
cat <<EOF
{
    "server": "$cdnip1",
    "server_port": 443,
    "tag": "${sxname}trojan-httpupgrade-tls-argo-$hostname-443",
    "tls": { "enabled": true, "server_name": "$argodomain", "insecure": false, "utls": { "enabled": true, "fingerprint": "chrome" } },
    "transport": { "headers": { "Host": ["$argodomain"] }, "path": "/$basepath-tu", "type": "httpupgrade" },
    "type": "trojan", "password": "$uuid"
},
EOF
;; esac
}
sbtuargopt1(){
case " $argo_sel " in *" tu "*) echo "\"${sxname}trojan-httpupgrade-tls-argo-$hostname-443\"," ;; esac
}
cltuargopt(){
case " $argo_sel " in *" tu "*)
cat <<EOF
- name: ${sxname}trojan-httpupgrade-tls-argo-$hostname-443
  type: trojan
  server: "$cdnip1"
  port: 443
  password: $uuid
  udp: true
  tls: true
  network: httpupgrade
  sni: $argodomain
  client-fingerprint: chrome
  httpupgrade-opts:
    path: "/$basepath-tu"
    headers:
      Host: $argodomain
EOF
;; esac
}
cltuargopt1(){
case " $argo_sel " in *" tu "*) echo "- ${sxname}trojan-httpupgrade-tls-argo-$hostname-443" ;; esac
}
sbmuargopt(){
case " $argo_sel " in *" mu "*)
cat <<EOF
{
    "server": "$cdnip1",
    "server_port": 443,
    "tag": "${sxname}vmess-httpupgrade-tls-argo-$hostname-443",
    "tls": { "enabled": true, "server_name": "$argodomain", "insecure": false, "utls": { "enabled": true, "fingerprint": "chrome" } },
    "transport": { "headers": { "Host": ["$argodomain"] }, "path": "/$basepath-mu", "type": "httpupgrade" },
    "type": "vmess", "security": "auto", "uuid": "$uuid"
},
EOF
;; esac
}
sbmuargopt1(){
case " $argo_sel " in *" mu "*) echo "\"${sxname}vmess-httpupgrade-tls-argo-$hostname-443\"," ;; esac
}
clmuargopt(){
case " $argo_sel " in *" mu "*)
cat <<EOF
- name: ${sxname}vmess-httpupgrade-tls-argo-$hostname-443
  type: vmess
  server: "$cdnip1"
  port: 443
  uuid: $uuid
  cipher: auto
  udp: true
  tls: true
  network: httpupgrade
  servername: $argodomain
  httpupgrade-opts:
    path: "/$basepath-mu"
    headers:
      Host: $argodomain
EOF
;; esac
}
clmuargopt1(){
case " $argo_sel " in *" mu "*) echo "- ${sxname}vmess-httpupgrade-tls-argo-$hostname-443" ;; esac
}
clswargopt(){
case " $argo_sel " in *" sw "*)
cat <<EOF
- name: ${sxname}ss-ws-tls-argo-$hostname-443
  type: ss
  server: "$cdnip1"
  port: 443
  cipher: 2022-blake3-aes-128-gcm
  password: "$sskey"
  udp: true
  plugin: v2ray-plugin
  plugin-opts:
    mode: websocket
    tls: true
    host: $argodomain
    path: "/$basepath-sw"
EOF
;; esac
}
clswargopt1(){
case " $argo_sel " in *" sw "*) echo "- ${sxname}ss-ws-tls-argo-$hostname-443" ;; esac
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
sbvwargopt(){ :; }
sbvwargopt1(){ :; }
clvwargopt(){ :; }
clvwargopt1(){ :; }
sbtwargopt(){ :; }
sbtwargopt1(){ :; }
cltwargopt(){ :; }
cltwargopt1(){ :; }
sbtuargopt(){ :; }
sbtuargopt1(){ :; }
cltuargopt(){ :; }
cltuargopt1(){ :; }
sbmuargopt(){ :; }
sbmuargopt1(){ :; }
clmuargopt(){ :; }
clmuargopt1(){ :; }
clswargopt(){ :; }
clswargopt1(){ :; }
fi

get_func() {
local f=$1
if type "$f" >/dev/null 2>&1; then
local out
out=$($f)
[ -n "$out" ] && printf "%s\n" "$out"
fi
}
  sbxy="$(get_func sbvlpt; get_func sbsspt; get_func sbanpt; get_func sbarpt; get_func sbvmpt; get_func sbhypt; get_func sbtupt; get_func sbvmargopt; get_func sbvwargopt; get_func sbtwargopt; get_func sbtuargopt; get_func sbmuargopt; get_func sbstpt; get_func sbnapt; get_func sbtrpt; get_func sbvtpt; get_func sbttpt)"
  clxy="$(get_func clvlpt; get_func clsspt; get_func clanpt; get_func clvmpt; get_func clhypt; get_func cltupt; get_func clvmargopt; get_func clvwargopt; get_func cltwargopt; get_func cltuargopt; get_func clmuargopt; get_func clswargopt; get_func cltrpt; get_func clvtpt; get_func clttpt)"
  sbgz="$(get_func sbvlpt1; get_func sbsspt1; get_func sbanpt1; get_func sbarpt1; get_func sbvmpt1; get_func sbhypt1; get_func sbtupt1; get_func sbvmargopt1; get_func sbvwargopt1; get_func sbtwargopt1; get_func sbtuargopt1; get_func sbmuargopt1; get_func sbstpt1; get_func sbnapt1; get_func sbtrpt1; get_func sbvtpt1; get_func sbttpt1)"
  clgz="$({ get_func clvlpt1; get_func clsspt1; get_func clanpt1; get_func clvmpt1; get_func clhypt1; get_func cltupt1; get_func clvmargopt1; get_func clvwargopt1; get_func cltwargopt1; get_func cltuargopt1; get_func clmuargopt1; get_func clswargopt1; get_func cltrpt1; get_func clvtpt1; get_func clttpt1; } | sed '2,$s/^/    /')"
sbgz=$(printf "%s\n" "$sbgz" | sed '$ s/,$//')
  tpl_client sbox-client.json "$HOME/agsbx/sbox.json"

tpl_client clmi-client.yaml "$HOME/agsbx/clmi.yaml"

# 生成summary.txt (Path/端口/协议汇总表，方便CF配置)
{
echo "=== argosbx Path/端口/协议汇总 ==="
echo "生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo
echo "--- A组: CDN直通 (小云朵ON, 服务端监听CF HTTPS端口) ---"
echo "协议              | 端口  | Path/ServiceName    | 客户端地址"
grep -q '"tag":"vless-ws"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+WS           | 443   | /$basepath-vw       | ${xvvmcdnym:-cdnym}:443"
grep -q '"tag":"vless-xhttp"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+XHTTP+ENC    | 2053  | /$basepath-vx       | ${xvvmcdnym:-cdnym}:2053"
grep -q '"tag":"vmess-ws"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VMess+WS           | 2083  | /$basepath-vm       | ${xvvmcdnym:-cdnym}:2083"
grep -q '"tag":"vless-httpupgrade"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+HTTPUpgrade  | 2087  | /$basepath-vu       | ${xvvmcdnym:-cdnym}:2087"
grep -q '"tag":"trojan-ws"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+WS          | 2096  | /$basepath-tw       | ${xvvmcdnym:-cdnym}:2096"
grep -q '"tag":"trojan-httpupgrade"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+HTTPUpgrade | 8443  | /$basepath-tuh      | ${xvvmcdnym:-cdnym}:8443"
grep -q '"tag":"vless-grpc"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+gRPC+ENC     | 443   | $basepath-vg(serviceName) | ${xvvmcdnym:-cdnym}:443"
grep -q '"tag":"trojan-grpc"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+gRPC        | 443   | $basepath-tg(serviceName) | ${xvvmcdnym:-cdnym}:443"
grep -q '"tag":"vmess-grpc"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VMess+gRPC         | 443   | $basepath-mg(serviceName) | ${xvvmcdnym:-cdnym}:443"
echo
echo "--- B组: CDN Origin Rules (客户端443, CF按path回源) ---"
echo "协议              | 服务端端口 | Path          | Origin Rule"
grep -q '"tag":"vmess-httpupgrade"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VMess+HTTPUpgrade | 39000      | /$basepath-mu | ${xvvmcdnym:-cdnym}/$basepath-mu → 39000"
grep -q '"tag":"trojan-xhttp"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+XHTTP      | 39001      | /$basepath-tx | ${xvvmcdnym:-cdnym}/$basepath-tx → 39001"
grep -q '"tag":"vmess-xhttp"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VMess+XHTTP       | 39002      | /$basepath-mx | ${xvvmcdnym:-cdnym}/$basepath-mx → 39002"
grep -q '"tag":"ss-ws"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "SS+WS             | 39003      | /$basepath-sw | ${xvvmcdnym:-cdnym}/$basepath-sw → 39003"
grep -q '"tag":"vless-ws-enc"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+WS+ENC      | 39004      | /$basepath-vwe| ${xvvmcdnym:-cdnym}/$basepath-vwe → 39004"
echo
echo "--- C组: 非CDN直连 (小云朵OFF或VPS_IP) ---"
echo "协议              | 端口  | 域名/SNI            | 证书"
grep -q '"tag":"xhttp-reality"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS-XHTTP-Reality | $(cat $HOME/agsbx/port_xh 2>/dev/null)   | $ym_vl_re | 无(Reality)"
grep -q '"tag":"reality-vision"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS-Reality-Vision| $(cat $HOME/agsbx/port_vl_re 2>/dev/null)   | $ym_vl_re | 无(Reality)"
grep -q '"tag":"hy2-sb"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "Hysteria2          | $(cat $HOME/agsbx/port_hy2 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
grep -q '"tag":"tuic5-sb"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "TUIC               | $(cat $HOME/agsbx/port_tu 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
grep -q '"tag":"anytls-sb"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "AnyTLS             | $(cat $HOME/agsbx/port_an 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
grep -q '"tag":"anyreality-sb"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "Any-Reality        | $(cat $HOME/agsbx/port_ar 2>/dev/null)   | $ym_vl_re | 无(Reality)"
grep -q '"tag":"ss-2022"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "SS-2022直连        | $(cat $HOME/agsbx/port_ss 2>/dev/null)   | 无 | 无(自身加密)"
grep -q '"tag":"stls-in"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "ShadowTLS v3+SS    | $(cat $HOME/agsbx/port_st 2>/dev/null)   | ${stls_dest:-www.microsoft.com} | 无(外层TLS伪装)"
grep -q '"tag":"naive-in"' "$HOME/agsbx/sb.json" 2>/dev/null && echo "Naive              | $(cat $HOME/agsbx/port_na 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
grep -q '"tag":"trojan-reality"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+Reality     | $(cat $HOME/agsbx/port_tr 2>/dev/null)   | $ym_vl_re | 无(Reality)"
grep -q '"tag":"vless-tls-vision"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "VLESS+TLS+Vision   | $(cat $HOME/agsbx/port_vtv 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
grep -q '"tag":"trojan-tls"' "$HOME/agsbx/xr.json" 2>/dev/null && echo "Trojan+TLS         | $(cat $HOME/agsbx/port_tt 2>/dev/null)   | ${directnym:-$server_ip} | directnym"
echo
_argosel=$(cat "$HOME/agsbx/argopro_sel.log" 2>/dev/null)
if [ -n "$argodomain" ] && [ -n "$_argosel" ]; then
echo "--- D组: Argo隧道 (CF Tunnel) ---"
echo "协议              | Path              | 端口   | CF Public Hostname"
for _ap in $_argosel; do
  case $_ap in
    vw) echo "VLESS+WS           | /$basepath-vw     | 39007  | $argodomain ^/$basepath-vw → localhost:39007" ;;
    vx) echo "VLESS+XHTTP        | /$basepath-vx     | 39008  | $argodomain ^/$basepath-vx → localhost:39008" ;;
    vm) echo "VMess+WS           | /$basepath-vm     | 39009  | $argodomain ^/$basepath-vm → localhost:39009" ;;
    vu) echo "VLESS+HTTPUpgrade  | /$basepath-vu     | 39010  | $argodomain ^/$basepath-vu → localhost:39010" ;;
    tw) echo "Trojan+WS          | /$basepath-tw     | 39011  | $argodomain ^/$basepath-tw → localhost:39011" ;;
    tu) echo "Trojan+HTTPUpgrade | /$basepath-tuh    | 39012  | $argodomain ^/$basepath-tuh → localhost:39012" ;;
    mu) echo "VMess+HTTPUpgrade  | /$basepath-mu     | 39013  | $argodomain ^/$basepath-mu → localhost:39013" ;;
    tx) echo "Trojan+XHTTP       | /$basepath-tx     | 39014  | $argodomain ^/$basepath-tx → localhost:39014" ;;
    mx) echo "VMess+XHTTP        | /$basepath-mx     | 39015  | $argodomain ^/$basepath-mx → localhost:39015" ;;
    sw) echo "SS+WS              | /$basepath-sw     | 39016  | $argodomain ^/$basepath-sw → localhost:39016" ;;
  esac
done
fi
} > "$HOME/agsbx/summary.txt"

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
echo "Path/端口/CF配置汇总，请运行 cat $HOME/agsbx/summary.txt 查看"
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
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ]; then
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
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ]; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ]; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &
fi
}
# ===== S7.5: 运维工具函数 =====
agsbx_doctor(){
  echo "═══ Argosbx 健康检查 ═══"
  echo
  echo "【进程状态】"
  if pgrep -f 'agsbx/x' >/dev/null 2>&1; then echo "  ✅ Xray: 运行中"; else echo "  ❌ Xray: 未运行"; fi
  if pgrep -f 'agsbx/s' >/dev/null 2>&1; then echo "  ✅ Sing-box: 运行中"; else echo "  ❌ Sing-box: 未运行"; fi
  if [ -e "$HOME/agsbx/cloudflared" ]; then
    if pgrep -f 'agsbx/c' >/dev/null 2>&1; then echo "  ✅ Cloudflared: 运行中"; else echo "  ❌ Cloudflared: 未运行"; fi
  fi
  echo
  echo "【证书有效期】"
  for _cert in /etc/argosbx/certs/*.crt; do
    [ -f "$_cert" ] || continue
    _cn=$(basename "$_cert")
    if command -v openssl >/dev/null 2>&1; then
      _expire=$(openssl x509 -enddate -noout -in "$_cert" 2>/dev/null | cut -d= -f2)
      _epoch=$(date -d "$_expire" +%s 2>/dev/null || echo 0)
      _now=$(date +%s)
      _days=$(( (_epoch - _now) / 86400 ))
      if [ "$_days" -gt 7 ]; then echo "  ✅ $_cn: 剩余 ${_days} 天"
      elif [ "$_days" -gt 0 ]; then echo "  ⚠️ $_cn: 剩余 ${_days} 天（即将过期）"
      else echo "  ❌ $_cn: 已过期"; fi
    else echo "  ⚠️ $_cn: openssl未安装"; fi
  done
  echo
  echo "【端口监听】"
  if [ -f "$HOME/agsbx/xr.json" ]; then
    for _port in $(grep -oE '"port"[[:space:]]*:[[:space:]]*[0-9]+' "$HOME/agsbx/xr.json" | grep -oE '[0-9]+$' | sort -un); do
      if ss -tln 2>/dev/null | grep -q ":$_port " || netstat -tln 2>/dev/null | grep -q ":$_port "; then
        echo "  ✅ 端口 $_port: 监听中"
      else echo "  ❌ 端口 $_port: 未监听"; fi
    done
  fi
  echo
  echo "【配置校验】"
  if [ -f "$HOME/agsbx/xr.json" ]; then
    "$HOME/agsbx/xray" run -test -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 && echo "  ✅ xr.json: 语法正确" || echo "  ❌ xr.json: 语法错误"
  fi
  if [ -f "$HOME/agsbx/sb.json" ]; then
    "$HOME/agsbx/sing-box" check -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 && echo "  ✅ sb.json: 语法正确" || echo "  ❌ sb.json: 语法错误"
  fi
  echo
  echo "═══ 检查完成 ═══"
}
agsbx_backup(){
  _bkfile="argosbx_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
  _bkpath="${2:-$HOME/$_bkfile}"
  echo "备份Argosbx配置到: $_bkpath"
  tar -czf "$_bkpath" -C "$HOME" agsbx -C / etc/argosbx 2>/dev/null
  _bksize=$(wc -c < "$_bkpath" 2>/dev/null || echo 0)
  echo "✅ 备份完成: $_bkpath ($((_bksize / 1024)) KB)"
  echo "恢复命令: argosbx restore $_bkpath"
}
agsbx_restore(){
  _bkfile="$2"
  if [ -z "$_bkfile" ] || [ ! -f "$_bkfile" ]; then
    echo "用法: argosbx restore <备份文件>"
    exit 1
  fi
  echo "从 $_bkfile 恢复Argosbx配置..."
  for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in */agsbx/*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
  tar -xzf "$_bkfile" -C "$HOME" 2>/dev/null
  tar -xzf "$_bkfile" -C / 2>/dev/null
  echo "✅ 配置恢复完成，正在重启服务..."
  bash "$HOME/bin/agsbx" res
}

# ===== S7.5: 交互式菜单（V2.9.1 计划第十四章）=====
# 计划文档 .omo/plans/cdn-protocol-expansion.md L1780-2067
# 9项主菜单 + 多选控件 + 配置持久化 + 向后兼容环境变量

# ---- 菜单工具函数 ----

# 检测证书是否有效且覆盖指定域名
# 用法: _check_cert "证书文件" "域名"  →  返回0=可用, 1=不可用
# 支持泛域名证书: *.example.com 覆盖所有子域名
_check_cert() {
  local _cert="$1" _domain="$2"
  [ -f "$_cert" ] || return 1
  command -v openssl >/dev/null 2>&1 || return 1
  # 未过期检查(剩余>1天)
  openssl x509 -in "$_cert" -noout -checkend 86400 2>/dev/null || return 1
  # 提取SAN列表
  local _san
  _san=$(openssl x509 -in "$_cert" -noout -ext subjectAltName 2>/dev/null | grep -o 'DNS:[^,]*' | sed 's/DNS://g' | tr -d ' ')
  [ -z "$_san" ] && _san=$(openssl x509 -in "$_cert" -noout -text 2>/dev/null | grep -A1 'Subject Alternative Name' | tail -1 | sed 's/DNS://g')
  [ -z "$_san" ] && return 1
  # 提取主域名后缀(去掉最前面的子域名部分)
  local _base_domain
  _base_domain=$(echo "$_domain" | sed 's/^[^.]*\.//')
  # grep匹配: 泛域名(*.example.com) 或 精确匹配
  echo "$_san" | grep -qE "\*\.${_base_domain}|^${_domain}$" && return 0
  return 1
}

# 带默认值的read，结果存全局变量_rd_val
# 用法: _rd "提示语" "默认值"  →  _rd_val
# 不能用$()子shell：子shell中stdout被捕获，提示语不显示
_rd() {
  _rd_val=""
  local _p="$1" _d="$2"
  if [ -n "$_d" ]; then
    printf "%s [%s]: " "$_p" "$_d"
  else
    printf "%s: " "$_p"
  fi
  read _rd_val || return 1
  _rd_val="${_rd_val:-$_d}"
}

# Y/N确认，返回0=Y，1=N
# 用法: _yn "确认?" y  (默认Y)  或 _yn "确认?" n  (默认N)
_yn() {
  local _p="$1" _d="${2:-y}" _v
  while :; do
    if [ "$_d" = "y" ]; then
      printf "%s [Y/n]: " "$_p" >&2
    else
      printf "%s [y/N]: " "$_p" >&2
    fi
    read _v
    case "${_v:-$_d}" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "请输入 Y 或 n" >&2 ;;
    esac
  done
}

# 多选控件，结果存全局变量_chk_sel
# 用法: _checklist "标题" "选项1
# 选项2
# 选项3" "默认选中(如:1 3 或空)"  →  _chk_sel
# 不能用$()子shell：子shell中stdout被捕获，列表不显示
_checklist() {
  local _title="$1"
  local _items="$2"
  local _dflt="${3:-}"
  local _count _sel _n _result _valid _i

  _chk_sel=""
  _count=$(printf "%s\n" "$_items" | grep -c '')

  while :; do
    clear 2>/dev/null || true
    echo "=== $_title ==="
    echo
    _n=1
    printf "%s\n" "$_items" | while IFS= read -r _line || [ -n "$_line" ]; do
      printf "  [%s] %s. %s\n" \
        "$(case "$_dflt" in *"$_n"*) echo "✓";; *) echo " ";; esac)" \
        "$_n" "$_line"
      _n=$((_n+1))
    done
    echo
    echo "  a=全选  0=全不选  q=取消"
    echo "  输入编号(多个用空格或逗号分隔，例如: 1 3 5 或 1,3,5)"
    printf "选择[%s]: " "${_dflt:-无}"
    read _sel
    case "$_sel" in
      [Qq]*) return 1 ;;
      "")
        if [ -n "$_dflt" ]; then
          _chk_sel=$(echo "$_dflt" | tr ',' ' ')
          return 0
        fi
        continue
        ;;
      [Aa]*)
        _result=""
        _i=1
        while [ "$_i" -le "$_count" ]; do
          _result="$_result$_i "
          _i=$((_i+1))
        done
        _chk_sel="$_result"
        return 0
        ;;
      "0")
        continue
        ;;
    esac

    # 解析并验证编号
    _sel=$(echo "$_sel" | tr ',' ' ')
    _result=""
    _valid=1
    for _n in $_sel; do
      case "$_n" in
        [0-9]*)
          if [ "$_n" -ge 1 ] && [ "$_n" -le "$_count" ]; then
            _result="$_result$_n "
          else
            echo "无效编号: $_n"
            _valid=0
            break
          fi
          ;;
        *)
          echo "无效输入: $_n"
          _valid=0
          break
          ;;
      esac
    done
    if [ "$_valid" = 1 ] && [ -n "$_result" ]; then
      _chk_sel="$_result"
      return 0
    fi
    printf "按回车重新选择..."
    read _
  done
}

# 单选，stdout输出选中编号
# 用法: _radiolist "标题" "选项1
# 选项2" "默认编号"
_radiolist() {
  local _title="$1" _items="$2" _dflt="${3:-1}"
  local _count _sel _n
  _count=$(printf "%s\n" "$_items" | grep -c '')
  while :; do
    clear 2>/dev/null || true
    echo "=== $_title ==="
    echo
    _n=1
    printf "%s\n" "$_items" | while IFS= read -r _line || [ -n "$_line" ]; do
      printf "  %s. %s\n" "$_n" "$_line"
      _n=$((_n+1))
    done
    echo
    printf "选择[%s] (q=取消): " "$_dflt" >&2
    read _sel
    case "$_sel" in
      [Qq]*) return 1 ;;
      "")
        [ -n "$_dflt" ] && { echo "$_dflt"; return 0; }
        continue
        ;;
      [0-9]*)
        if [ "$_sel" -ge 1 ] && [ "$_sel" -le "$_count" ]; then
          echo "$_sel"
          return 0
        fi
        ;;
    esac
    echo "无效选择" >&2
    sleep 1
  done
}

# 保存配置到 $HOME/agsbx/menu_config (键值对)
# 用法: _save_cfg "key" "value"
_save_cfg() {
  local _key="$1" _val="$2"
  local _cfgdir="$HOME/agsbx"
  local _cfgfile="$_cfgdir/menu_config"
  mkdir -p "$_cfgdir"
  # 删除旧的同名键
  if [ -f "$_cfgfile" ]; then
    sed -i "/^${_key}=/d" "$_cfgfile" 2>/dev/null
  fi
  # 追加新值
  printf "%s=%s\n" "$_key" "$_val" >> "$_cfgfile"
}

# 读取配置
# 用法: _load_cfg "key" "default"
_load_cfg() {
  local _key="$1" _dflt="$2"
  local _cfgfile="$HOME/agsbx/menu_config"
  if [ -f "$_cfgfile" ]; then
    local _val=$(grep "^${_key}=" "$_cfgfile" 2>/dev/null | head -1 | cut -d= -f2-)
    [ -n "$_val" ] && { echo "$_val"; return; }
  fi
  echo "$_dflt"
}

# ---- 菜单1: CDN协议设置 ----
menu_cdn() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  菜单1: CDN协议设置 (A+B组共14个)"
  echo "======================================"
  echo

  # 加载已有配置作为默认值
  local _cdnym_def=$(_load_cfg cdnym "${cdnym:-}")
  local _uuid_def=$(_load_cfg uuid_xray "")
  local _basepath_def=$(_load_cfg basepath "${basepath:-}")
  local _cfapi_def=$(_load_cfg cfapi "${cfapi:-}")
  local _cfzone_def=$(_load_cfg cfzone "${cfzone:-}")
  local _cdnsel_def=$(_load_cfg cdn_selected "")

  # [1/5] CDN域名
  local _cdnym
  _rd "[1/5] 输入CDN域名(小云朵ON, 已托管CF)" "$_cdnym_def" || return 1
  _cdnym="$_rd_val"
  if [ -z "$_cdnym" ]; then
    echo "❌ CDN域名必填"
    return 1
  fi
  _save_cfg cdnym "$_cdnym"

  # [2/5] UUID
  local _uuid
  if [ -z "$_uuid_def" ]; then
    _uuid_def=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null)
  fi
  _rd "[2/5] 输入UUID(回车自动生成)" "$_uuid_def" || _uuid="$_uuid_def"
  _uuid="${_rd_val:-$_uuid_def}"
  _save_cfg uuid_xray "$_uuid"

  # [3/5] Path前缀
  local _basepath
  if [ -z "$_basepath_def" ]; then
    _basepath_def=$(head -c 8 /dev/urandom 2>/dev/null | od -An -tx1 | tr -d ' \n' | cut -c1-16)
    [ -z "$_basepath_def" ] && _basepath_def=$(date +%s | sha256sum | cut -c1-16)
  fi
  _rd "[3/5] 输入Path前缀(回车随机生成)" "$_basepath_def" || _basepath="$_basepath_def"
  _basepath="${_rd_val:-$_basepath_def}"
  _save_cfg basepath "$_basepath"

  # [4/5] 证书: 先检测已有证书, 有效且>30天直接复用; 快过期/不存在才选方式
  echo
  local _certmode=""
  local _cfapi _cfzone
  # 检测标准位置已有证书是否覆盖当前域名
  for _cf in /etc/argosbx/certs/cdnym.crt /etc/argosbx/certs/directnym.crt; do
    if _check_cert "$_cf" "$_cdnym"; then
      # 证书有效, 检查是否快过期(<30天=2592000秒)
      if openssl x509 -in "$_cf" -noout -checkend 2592000 2>/dev/null; then
        # >30天, 直接复用不问
        echo "✅ 检测到有效证书(>30天)，直接复用: $_cf"
        mkdir -p /etc/argosbx/certs
        [ "$_cf" != "/etc/argosbx/certs/cdnym.crt" ] && cp -f "$_cf" /etc/argosbx/certs/cdnym.crt
        _cf_key="${_cf%.crt}.key"
        [ -f "$_cf_key" ] && [ "$_cf" != "/etc/argosbx/certs/cdnym.crt" ] && cp -f "$_cf_key" /etc/argosbx/certs/cdnym.key
        chmod 600 /etc/argosbx/certs/cdnym.key 2>/dev/null
        _certmode="reuse"
      else
        # <30天, 提示是否继续用旧的
        echo "⚠ 证书将于30天内过期: $_cf"
        if _yn "继续复用旧证书?" n; then
          mkdir -p /etc/argosbx/certs
          [ "$_cf" != "/etc/argosbx/certs/cdnym.crt" ] && cp -f "$_cf" /etc/argosbx/certs/cdnym.crt
          _cf_key="${_cf%.crt}.key"
          [ -f "$_cf_key" ] && [ "$_cf" != "/etc/argosbx/certs/cdnym.crt" ] && cp -f "$_cf_key" /etc/argosbx/certs/cdnym.key
          chmod 600 /etc/argosbx/certs/cdnym.key 2>/dev/null
          _certmode="reuse"
        fi
      fi
      break
    fi
  done
  # 没有可用证书才让用户选
  if [ -z "$_certmode" ]; then
    echo "[4/5] 未检测到可用证书，请选择证书方式"
    echo "  1. 已有证书(提供crt/key文件路径)"
    echo "  2. CF API自动申请(acme.sh dns_cf, 需Token+Zone ID)"
    echo "  3. 跳过(只装无TLS协议时可选)"
    _rd "  选择[1-3]" "1" || _certmode="1"
    _certmode="${_rd_val:-1}"
    _save_cfg cdn_certmode "$_certmode"
    local _certcrt _certkey
    case "$_certmode" in
      1)
        local _certcrt_def=$(_load_cfg certcrt "/etc/argosbx/certs/cdnym.crt")
        local _certkey_def=$(_load_cfg certkey "/etc/argosbx/certs/cdnym.key")
        _rd "  证书文件路径(.crt/.pem)" "$_certcrt_def" || _certcrt="$_certcrt_def"
        _certcrt="${_rd_val:-$_certcrt_def}"
        _rd "  密钥文件路径(.key)" "$_certkey_def" || _certkey="$_certkey_def"
        _certkey="${_rd_val:-$_certkey_def}"
        if [ -f "$_certcrt" ] && [ -f "$_certkey" ]; then
          mkdir -p /etc/argosbx/certs
          cp -f "$_certcrt" /etc/argosbx/certs/cdnym.crt
          cp -f "$_certkey" /etc/argosbx/certs/cdnym.key
          chmod 600 /etc/argosbx/certs/cdnym.key
          _save_cfg certcrt "$_certcrt"
          _save_cfg certkey "$_certkey"
          echo "  ✅ 证书已复制到 /etc/argosbx/certs/cdnym.crt+key"
        else
          echo "  ⚠ 文件不存在，稍后将自动申请"
          _certmode="2"
        fi
        ;;
      2)
        echo "  Dashboard → My Profile → API Tokens → Edit zone DNS"
        _rd "  CF API Token" "$_cfapi_def" || _cfapi=""
        _cfapi="${_rd_val:-}"
        _rd "  CF Zone ID" "$_cfzone_def" || _cfzone=""
        _cfzone="${_rd_val:-}"
        if [ -z "$_cfapi" ] || [ -z "$_cfzone" ]; then
          echo "  ⚠ 未提供CF凭证，证书不会自动签发"
        else
          _save_cfg cfapi "$_cfapi"
          _save_cfg cfzone "$_cfzone"
        fi
        ;;
      3) echo "  已选跳过证书" ;;
    esac
  fi

  # [5/5] 协议多选
  local _cdn_items="VLESS+WS (A组·443固定)
VLESS+XHTTP (A组·2053固定)
VMess+WS (A组·2083固定)
VLESS+HTTPUpgrade (A组·2087固定)
Trojan+WS (A组·2096固定)
Trojan+HTTPUpgrade (A组·8443固定)
VLESS+gRPC (A组·443 fallbacks)
Trojan+gRPC (A组·443 fallbacks)
VMess+gRPC (A组·443 fallbacks)
VMess+HTTPUpgrade (B组·39000 Origin Rules)
Trojan+XHTTP (B组·39001 Origin Rules·mode=packet-up)
VMess+XHTTP (B组·39002 Origin Rules·mode=packet-up)
Shadowsocks+WS (B组·39003 Origin Rules·SIP002)
VLESS+WS+ENC (B组·39004 Origin Rules·带ENC)"

  echo
  echo "[5/5] 选择CDN协议 (A组9个 + B组5个)"
  echo "  注意: gRPC协议(#7-9)需CF Dashboard→Network→开启gRPC"
  echo "        B组协议(#10-14)需CF Origin Rules(安装后自动输出指引)"
  _checklist "CDN协议多选" "$_cdn_items" "$_cdnsel_def" || { echo "已取消"; return 1; }
  local _sel="$_chk_sel"

  # 确认
  echo
  echo "======================================"
  echo " 确认配置"
  echo "======================================"
  echo "  CDN域名:    $_cdnym"
  echo "  UUID:       $_uuid"
  echo "  Path前缀:   $_basepath"
  case "$_certmode" in
    1) echo "  证书方式:   手动提供($_certcrt)" ;;
    2) echo "  证书方式:   CF API自动申请" ;;
    3) echo "  证书方式:   跳过" ;;
  esac
  echo "  已选协议编号: $_sel"
  echo "  (1=VLESS+WS 2=VLESS+XHTTP 3=VMess+WS 4=VLESS+HTTPUpgrade"
  echo "   5=Trojan+WS 6=Trojan+HTTPUpgrade 7=VLESS+gRPC 8=Trojan+gRPC 9=VMess+gRPC"
  echo "   10=VMess+HTTPUpgrade 11=Trojan+XHTTP 12=VMess+XHTTP 13=SS+WS 14=VLESS+WS+ENC)"
  echo "======================================"
  if ! _yn "确认开始部署?" y; then
    echo "已取消，返回主菜单"
    return 1
  fi
  _save_cfg cdn_selected "$_sel"

  # 导出为环境变量供主流程使用
  export cdnym="$_cdnym"
  export uuid="$_uuid"
  export basepath="$_basepath"
  export cfapi="${_cfapi:-}"
  export cfzone="${_cfzone:-}"

  # 设置协议开关(覆盖到全局变量)
  for _n in $_sel; do
    case "$_n" in
      1) export vwp=yes; export vmag=yes ;;
      2) export vxp=yes ;;
      3) export vmp=yes; export vmag=yes ;;
      4) export vup=yes; export vmag=yes ;;
      5) export twp=yes; export vmag=yes ;;
      6) export tuhp=yes; export vmag=yes ;;
      7) export vgp=yes ;;
      8) export tgp=yes ;;
      9) export mgp=yes ;;
      10) export mup=yes; export vmag=yes ;;
      11) export txp=yes; export vmag=yes ;;
      12) export mxp=yes; export vmag=yes ;;
      13) export swp=yes; export vmag=yes ;;
      14) export vwep=yes ;;
    esac
  done

  # gRPC依赖检查: gRPC走443 vless-ws的fallbacks，如果选了gRPC没选VLESS+WS则自动启用
  if [ -n "${vgp:-}${tgp:-}${mgp:-}" ] && [ -z "${vwp:-}" ]; then
    echo "⚠️ gRPC协议依赖VLESS+WS(443端口fallbacks)，已自动启用VLESS+WS"
    export vwp=yes; export vmag=yes
  fi

  echo
  echo "✅ CDN协议配置完成，准备执行安装..."
  return 0
}

# ---- 菜单2: 非CDN协议设置 ----
menu_noncdn() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  菜单2: 非CDN协议设置 (C组12个)"
  echo "======================================"
  echo

  local _directnym_def=$(_load_cfg directnym "${directnym:-}")
  local _uuid_sb_def=$(_load_cfg uuid_singbox "")
  local _reality_def=$(_load_cfg reality_dest "www.microsoft.com")
  local _noncdn_sel_def=$(_load_cfg noncdn_selected "")

  # [1/5] 直连域名
  local _directnym
  _rd "[1/5] 输入直连域名(小云朵OFF, DNS only)" "$_directnym_def" || _directnym=""
  _directnym="${_rd_val:-}"
  if [ -n "$_directnym" ]; then
    _save_cfg directnym "$_directnym"
  fi

  # [2/5] sing-box UUID
  local _uuid_sb
  if [ -z "$_uuid_sb_def" ]; then
    _uuid_sb_def=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null)
  fi
  _rd "[2/5] 输入sing-box UUID(回车自动生成)" "$_uuid_sb_def" || _uuid_sb="$_uuid_sb_def"
  _uuid_sb="${_rd_val:-$_uuid_sb_def}"
  _save_cfg uuid_singbox "$_uuid_sb"

  # [3/5] 证书: 先检测已有证书, 有效且>30天直接复用; 快过期/不存在才选方式
  echo
  local _certmode=""
  # 检测标准位置已有证书是否覆盖directnym域名(也检测cdnym, 泛域名通用)
  for _cf in /etc/argosbx/certs/directnym.crt /etc/argosbx/certs/cdnym.crt; do
    if [ -n "$_directnym" ] && _check_cert "$_cf" "$_directnym"; then
      if openssl x509 -in "$_cf" -noout -checkend 2592000 2>/dev/null; then
        echo "✅ 检测到有效证书(>30天)，直接复用: $_cf"
        mkdir -p /etc/argosbx/certs
        [ "$_cf" != "/etc/argosbx/certs/directnym.crt" ] && cp -f "$_cf" /etc/argosbx/certs/directnym.crt
        _cf_key="${_cf%.crt}.key"
        [ -f "$_cf_key" ] && [ "$_cf" != "/etc/argosbx/certs/directnym.crt" ] && cp -f "$_cf_key" /etc/argosbx/certs/directnym.key
        chmod 600 /etc/argosbx/certs/directnym.key 2>/dev/null
        _certmode="reuse"
      else
        echo "⚠ 证书将于30天内过期: $_cf"
        if _yn "继续复用旧证书?" n; then
          mkdir -p /etc/argosbx/certs
          [ "$_cf" != "/etc/argosbx/certs/directnym.crt" ] && cp -f "$_cf" /etc/argosbx/certs/directnym.crt
          _cf_key="${_cf%.crt}.key"
          [ -f "$_cf_key" ] && [ "$_cf" != "/etc/argosbx/certs/directnym.crt" ] && cp -f "$_cf_key" /etc/argosbx/certs/directnym.key
          chmod 600 /etc/argosbx/certs/directnym.key 2>/dev/null
          _certmode="reuse"
        fi
      fi
      break
    fi
  done
  # 没有可用证书才让用户选
  if [ -z "$_certmode" ]; then
    echo "[3/5] 未检测到可用证书，请选择证书方式"
    echo "  1. 已有证书(提供crt/key文件路径)"
    echo "  2. CF API自动申请(acme.sh dns_cf)"
    echo "  3. 跳过(只装无TLS协议: SS-2022/ShadowTLS)"
    _rd "  选择[1-3]" "1" || _certmode="1"
    _certmode="${_rd_val:-1}"
    _save_cfg noncdn_certmode "$_certmode"
    case "$_certmode" in
      1)
        local _certcrt_def=$(_load_cfg certcrt "/etc/argosbx/certs/directnym.crt")
        local _certkey_def=$(_load_cfg certkey "/etc/argosbx/certs/directnym.key")
        local _certcrt _certkey
        _rd "  证书文件路径(.crt/.pem)" "$_certcrt_def" || _certcrt="$_certcrt_def"
        _certcrt="${_rd_val:-$_certcrt_def}"
        _rd "  密钥文件路径(.key)" "$_certkey_def" || _certkey="$_certkey_def"
        _certkey="${_rd_val:-$_certkey_def}"
        if [ -f "$_certcrt" ] && [ -f "$_certkey" ]; then
          mkdir -p /etc/argosbx/certs
          cp -f "$_certcrt" /etc/argosbx/certs/directnym.crt
          cp -f "$_certkey" /etc/argosbx/certs/directnym.key
          chmod 600 /etc/argosbx/certs/directnym.key
          echo "  ✅ 证书已复制到 /etc/argosbx/certs/directnym.crt+key"
        else
          echo "  ⚠ 文件不存在，稍后将自动申请或跳过"
          _certmode="3"
        fi
        ;;
      2)
        local _cfapi_chk=$(_load_cfg cfapi "")
        local _cfzone_chk=$(_load_cfg cfzone "")
        if [ -z "$_cfapi_chk" ] || [ -z "$_cfzone_chk" ]; then
          echo "⚠ 未找到CF凭证，请先在菜单1设置，或手动输入:"
          _rd "  CF API Token" "" || _cfapi_chk=""
          _cfapi_chk="${_rd_val:-}"
          _rd "  CF Zone ID" "" || _cfzone_chk=""
          _cfzone_chk="${_rd_val:-}"
          [ -n "$_cfapi_chk" ] && _save_cfg cfapi "$_cfapi_chk"
          [ -n "$_cfzone_chk" ] && _save_cfg cfzone "$_cfzone_chk"
        fi
        ;;
      3) echo "  已选跳过证书签发" ;;
    esac
  fi

  # [4/5] Reality目标
  local _reality
  _rd "[4/5] Reality伪装目标网站(回车默认)" "$_reality_def" || _reality="$_reality_def"
  _reality="${_rd_val:-$_reality_def}"
  _save_cfg reality_dest "$_reality"

  # [5/5] 协议多选
  local _noncdn_items="VLESS-XHTTP-Reality-ENC (xray·端口自动)
VLESS-TCP-Reality-Vision (xray·端口自动)
Hysteria2 (sing-box·QUIC·TLS)
TUIC (sing-box·QUIC·TLS)
AnyTLS (sing-box·TLS)
Any-Reality VLESS+Reality (sing-box·无证书)
SS-2022直连 (sing-box·无TLS)
ShadowTLS v3+SS (sing-box·嵌套SS)
Naive (sing-box·HTTP/2·TLS)
Trojan+TCP+Reality (xray·Reality)
VLESS+TCP+TLS+Vision (xray·TLS·flow=Vision)
Trojan+TCP+TLS (xray·TLS)"

  echo
  echo "[5/5] 选择非CDN协议"
  _checklist "非CDN协议多选" "$_noncdn_items" "$_noncdn_sel_def" || { echo "已取消"; return 1; }
  local _sel="$_chk_sel"

  # 证书依赖检测
  local _need_cert=""
  for _n in $_sel; do
    case "$_n" in
      3|4|5|9|11|12) _need_cert="$_need_cert$_n " ;;
    esac
  done
  if [ -n "$_need_cert" ] && [ "$_certmode" = "2" ]; then
    echo "❌ 选择的协议需要TLS证书(Hysteria2/TUIC/AnyTLS/Naive/VLESS+TLS+Vision/Trojan+TLS)"
    echo "   请重新选择并配置证书方式"
    return 1
  fi

  # 确认
  echo
  echo "======================================"
  echo " 确认配置"
  echo "======================================"
  echo "  直连域名:   ${_directnym:-未设置}"
  echo "  sing-box UUID: $_uuid_sb"
  echo "  证书方式:   ${_certmode:+acme.sh自动}${_certmode:-未设置}"
  echo "  Reality目标: $_reality"
  echo "  已选协议编号: $_sel"
  echo "  (1=VLESS-Reality-ENC 2=VLESS-Reality-Vision 3=Hysteria2 4=TUIC"
  echo "   5=AnyTLS 6=Any-Reality 7=SS-2022 8=ShadowTLS 9=Naive"
  echo "   10=Trojan+Reality 11=VLESS+TLS+Vision 12=Trojan+TLS)"
  echo "======================================"
  if ! _yn "确认开始部署?" y; then
    return 1
  fi
  _save_cfg noncdn_selected "$_sel"

  # 导出环境变量
  export directnym="${_directnym:-}"
  # uuid: 不覆盖已有值(如果menu_cdn已设xray uuid则保留)，sing-box用同一uuid
  [ -z "${uuid:-}" ] && export uuid="${_uuid_sb}"
  _save_cfg uuid_singbox "$_uuid_sb"
  export ym_vl_re="${_reality}"

  # 设置协议开关
  for _n in $_sel; do
    case "$_n" in
      1) export xhp=yes ;;
      2) export vlp=yes ;;
      3) export hyp=yes ;;
      4) export tup=yes ;;
      5) export anp=yes ;;
      6) export arp=yes ;;
      7) export ssp=yes ;;
      8) export stp=yes ;;
      9) export nap=yes ;;
      10) export trp=yes ;;
      11) export vtp=yes ;;
      12) export ttp=yes ;;
    esac
  done

  echo
  echo "✅ 非CDN协议配置完成"
  return 0
}

# ---- 菜单3: Argo隧道设置 ----
menu_argo() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  菜单3: Argo隧道设置 (D组10变体)"
  echo "======================================"
  echo
  echo "  Argo = Cloudflare Tunnel, 流量经CF隧道转发到本地端口"
  echo "  支持10个协议: VW/VX/VM/VU/TW/TU/MU/TX/MX/SW"
  echo "  gRPC不支持Argo(CF Tunnel bug #1641)"
  echo

  local _argo_domain_def=$(_load_cfg argo_domain "")
  local _argo_token_def=$(_load_cfg argo_token "")
  local _argo_sel_def=$(_load_cfg argo_selected "")
  local _argo_port_def=$(_load_cfg argo_port_start "39007")

  # [1/4] 隧道域名(可选, 仅固定隧道需要)
  local _argo_domain
  _rd "[1/4] 输入Argo隧道域名(回车使用临时隧道trycloudflare)" "$_argo_domain_def" || _argo_domain=""
  _argo_domain="${_rd_val:-}"
  [ -n "$_argo_domain" ] && _save_cfg argo_domain "$_argo_domain"

  # [2/4] CF Tunnel Token
  local _argo_token
  if [ -n "$_argo_domain" ]; then
    # 固定隧道必须token
    _rd "[2/4] 输入CF Tunnel Token(必填)" "$_argo_token_def" || _argo_token=""
    _argo_token="${_rd_val:-}"
    if [ -z "$_argo_token" ]; then
      echo "❌ 固定隧道必须提供Token"
      return 1
    fi
    _save_cfg argo_token "$_argo_token"
  else
    echo "[2/4] 使用临时隧道(trycloudflare.com)，无需Token"
  fi

  # [3/4] 端口起始
  local _argo_port
  _rd "[3/4] Argo监听端口起始值(每协议1端口)" "$_argo_port_def" || _argo_port="$_argo_port_def"
  _argo_port="${_rd_val:-$_argo_port_def}"
  _save_cfg argo_port_start "$_argo_port"

  # [4/4] 协议多选
  local _argo_items="VLESS+WS (vw)
VLESS+XHTTP (vx)
VMess+WS (vm)
VLESS+HTTPUpgrade (vu)
Trojan+WS (tw)
Trojan+HTTPUpgrade (tu)
VMess+HTTPUpgrade (mu)
Trojan+XHTTP (tx)
VMess+XHTTP (mx)
Shadowsocks+WS (sw)"

  echo
  echo "[4/4] 选择Argo代理协议"
  _checklist "Argo协议多选" "$_argo_items" "$_argo_sel_def" || { echo "已取消"; return 1; }
  local _sel="$_chk_sel"

  # 把编号映射为协议缩写
  local _argopro_list=""
  for _n in $_sel; do
    case "$_n" in
      1) _argopro_list="$_argopro_list,vw" ;;
      2) _argopro_list="$_argopro_list,vx" ;;
      3) _argopro_list="$_argopro_list,vm" ;;
      4) _argopro_list="$_argopro_list,vu" ;;
      5) _argopro_list="$_argopro_list,tw" ;;
      6) _argopro_list="$_argopro_list,tu" ;;
      7) _argopro_list="$_argopro_list,mu" ;;
      8) _argopro_list="$_argopro_list,tx" ;;
      9) _argopro_list="$_argopro_list,mx" ;;
      10) _argopro_list="$_argopro_list,sw" ;;
    esac
  done
  _argopro_list="${_argopro_list#,}"  # 去掉开头的逗号

  # 确认
  echo
  echo "======================================"
  echo " 确认配置"
  echo "======================================"
  echo "  隧道域名: ${_argo_domain:-临时隧道}"
  echo "  Token:    ${_argo_token:+已设置}${_argo_token:-无}"
  echo "  端口起始: $_argo_port"
  echo "  Argo协议: $_argopro_list"
  echo "======================================"
  if ! _yn "确认?" y; then
    return 1
  fi
  _save_cfg argo_selected "$_sel"

  # 导出
  export agn="${_argo_domain:-}"
  export agk="${_argo_token:-}"
  export argopro="$_argopro_list"

  echo
  echo "✅ Argo隧道配置完成"
  return 0
}

# ---- 菜单4: 全部部署 ----
menu_all() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  菜单4: 全部部署 (依次执行1→2→3)"
  echo "======================================"
  echo
  if ! _yn "将依次执行 CDN→非CDN→Argo，确认开始?" y; then
    return 1
  fi
  echo
  echo ">>> 步骤 1/3: CDN协议"
  menu_cdn || { echo "CDN配置失败，中止"; return 1; }
  echo
  echo ">>> 步骤 2/3: 非CDN协议"
  menu_noncdn || { echo "非CDN配置跳过或失败，继续Argo"; }
  echo
  echo ">>> 步骤 3/3: Argo隧道"
  menu_argo || { echo "Argo配置跳过"; }

  echo
  echo "======================================"
  echo " 全部配置完成，准备执行安装"
  echo "======================================"
  return 0
}

# ---- 菜单5-7: 更新内核 ----
menu_upx() {
  echo "更新 xray-core ..."
  upxray && xrestart && echo "✅ Xray内核更新完成"
}
menu_ups() {
  echo "更新 sing-box ..."
  upsingbox && sbrestart && echo "✅ Sing-box内核更新完成"
}
menu_upc() {
  echo "更新 cloudflared ..."
  upcloudflared && echo "✅ Cloudflared更新完成"
}

# ---- 菜单8: 卸载 ----
menu_del() {
  echo
  echo "将删除:"
  echo "  - xray-core 二进制 + 配置 + 服务"
  echo "  - sing-box 二进制 + 配置 + 服务"
  echo "  - cloudflared 二进制 + 服务"
  echo "  - 证书文件 (/etc/argosbx/certs/)"
  echo "  - 配置数据 (\$HOME/agsbx/)"
  echo
  if _yn "确认卸载?" n; then
    cleandel
    rm -rf sbx_update "$HOME/agsbx" "$HOME/websbx"
    echo "✅ 卸载完成"
    exit 0
  fi
}

# ---- 主菜单 ----
showmenu_main() {
  while :; do
    clear 2>/dev/null || true
    echo "╔══════════════════════════════════════════╗"
    echo "║       argosbx 全协议管理面板            ║"
    echo "║       V2.9.1 计划第十四章               ║"
    echo "╠══════════════════════════════════════════╣"
    # 显示已安装状态
    if [ -e "$HOME/agsbx/xr.json" ] || [ -e "$HOME/agsbx/sb.json" ]; then
      echo "║  状态: ✅ 已安装                        ║"
    else
      echo "║  状态: ⚠ 未安装                         ║"
    fi
    echo "╠══════════════════════════════════════════╣"
    echo "║  1. CDN协议设置 (A+B组14个)             ║"
    echo "║  2. 非CDN协议设置 (C组12个)             ║"
    echo "║  3. Argo隧道设置 (D组10变体)            ║"
    echo "║  4. 全部部署 (1→2→3依次执行)           ║"
    echo "║  5. 更新 xray-core                      ║"
    echo "║  6. 更新 sing-box                       ║"
    echo "║  7. 更新 cloudflared                    ║"
    echo "║  8. 查看订阅链接 (jhsub.txt)            ║"
    echo "║  9. 查看路径配置 (summary.txt)          ║"
    echo "║  D. 卸载                                ║"
    echo "║  Q. 退出                                ║"
    echo "╚══════════════════════════════════════════╝"
    printf "请选择 [1-9/D/Q]: "
    local _choice
    read _choice
    case "$_choice" in
      1) menu_cdn && { echo; echo "配置已保存，将执行安装..."; sleep 2; return 0; } ;;
      2) menu_noncdn && { echo; echo "配置已保存，将执行安装..."; sleep 2; return 0; } ;;
      3) menu_argo && { echo; echo "配置已保存，将执行安装..."; sleep 2; return 0; } ;;
      4) menu_all && { echo; echo "配置已保存，将执行安装..."; sleep 2; return 0; } ;;
      5) menu_upx ;;
      6) menu_ups ;;
      7) menu_upc ;;
      8) menu_viewsub ;;
      9) menu_viewpath ;;
      [Dd]) menu_del ;;
      [Qq]*) echo "退出"; exit 0 ;;
      *) echo "无效选择"; sleep 1 ;;
    esac
  done
}

# ---- 菜单8: 查看订阅链接 ----
menu_viewsub() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  订阅链接 (jhsub.txt)"
  echo "======================================"
  echo
  if [ -f "$HOME/agsbx/jhsub.txt" ]; then
    cat "$HOME/agsbx/jhsub.txt"
  else
    echo "❌ 未找到 jhsub.txt"
    echo "   请先执行部署(菜单1-4)生成订阅链接"
  fi
  echo
  echo "======================================"
  printf "按回车返回主菜单..."
  read _
}

# ---- 菜单9: 查看路径配置 ----
menu_viewpath() {
  clear 2>/dev/null || true
  echo "======================================"
  echo "  路径配置 (summary.txt)"
  echo "======================================"
  echo
  if [ -f "$HOME/agsbx/summary.txt" ]; then
    cat "$HOME/agsbx/summary.txt"
  else
    echo "❌ 未找到 summary.txt"
    echo "   请先执行部署(菜单1-4)生成路径配置"
  fi
  echo
  echo "======================================"
  printf "按回车返回主菜单..."
  read _
}

# ===== S8: 命令入口 =====

# --- 交互式菜单入口 (V2.9.1 第十四章) ---
# 此时所有函数已定义。无子命令 + 是TTY + 未设置任何协议变量 → 进入交互菜单
if [ -z "$1" ] && [ -t 0 ] 2>/dev/null; then
  if [ -z "${vlp:-}${vmp:-}${vwp:-}${hyp:-}${tup:-}${xhp:-}${vxp:-}${anp:-}${ssp:-}${arp:-}${sop:-}${vup:-}${twp:-}${tuhp:-}${vgp:-}${tgp:-}${mgp:-}${mup:-}${txp:-}${mxp:-}${swp:-}${vwep:-}${stp:-}${nap:-}${trp:-}${vtp:-}${ttp:-}" ]; then
    showmenu_main
    # 菜单返回后，变量已被export设置，继续走主安装流程(ins/cip等)
    _menu_returned=1; export _menu_returned
  fi
fi

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
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ]; then
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
if [ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ]; then
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
elif [ "$1" = "doctor" ]; then
agsbx_doctor
exit
elif [ "$1" = "backup" ]; then
agsbx_backup "$@"
exit
elif [ "$1" = "restore" ]; then
agsbx_restore "$@"
exit
fi
# 菜单返回后(_menu_returned=1)强制走安装流程,即使xray/sing-box已在运行
if { ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; } || [ -n "${_menu_returned:-}" ]; then
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
if grep -qE '"tag":"(vmess-httpupgrade|trojan-xhttp|vmess-xhttp|ss-ws|vless-ws-enc)"' "$HOME/agsbx/xr.json" 2>/dev/null; then
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
if grep -q '"tag":"ss-ws"' "$HOME/agsbx/xr.json" 2>/dev/null; then
echo "规则: Shadowsocks+WS"
echo "  条件: URI Path starts with \"/${basepath}-sw\""
echo "  操作: Rewrite to Destination Port → 39003"
fi
if grep -q '"tag":"vless-ws-enc"' "$HOME/agsbx/xr.json" 2>/dev/null; then
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
