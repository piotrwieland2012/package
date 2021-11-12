#!/bin/sh

name=$1
file=$2

extract() {
	line=$1
	PRK=$(echo "$line" | grep "PrivateKey" | tr " " ",")
	if [ ! -z "$PRK" ]; then
		PrivateKey=$(echo $PRK | cut -d, -f3)
	fi
	PRK=$(echo "$line" | grep "PublicKey" | tr " " ",")
	if [ ! -z "$PRK" ]; then
		PublicKey=$(echo $PRK | cut -d, -f3)
	fi
	PRK=$(echo "$line" | grep "PresharedKey" | tr " " ",")
	if [ ! -z "$PRK" ]; then
		PreSharedKey=$(echo $PRK | cut -d, -f3)
	fi
	PRK=$(echo "$line" | grep "Address" | tr " " "#")
	if [ ! -z "$PRK" ]; then
		Address=$(echo $PRK | cut -d# -f3)
	fi
	PRK=$(echo "$line" | grep "dns" | tr " " "#")
	if [ ! -z "$PRK" ]; then
		dns=$(echo $PRK | cut -d# -f3)
	fi
	PRK=$(echo "$line" | grep "DNS" | tr " " "#")
	if [ ! -z "$PRK" ]; then
		dns=$(echo $PRK | cut -d# -f3)
	fi
	PRK=$(echo "$line" | grep "ListenPort" | tr " " ",")
	if [ ! -z "$PRK" ]; then
		listenport=$(echo $PRK | cut -d, -f3)
	fi
	PRK=$(echo "$line" | grep "AllowedIPs" | tr " " "#")
	if [ ! -z "$PRK" ]; then
		allowedips=$(echo $PRK | cut -d# -f3)
	fi
	PRK=$(echo "$line" | grep "Endpoint" | tr " " ",")
	if [ ! -z "$PRK" ]; then
		endpoint=$(echo $PRK | cut -d, -f3)
	fi
	MTU=$(echo "$line" | grep "MTU" | tr " " ",")
	if [ ! -z "$MTU" ]; then
		mtu=$(echo $MTU | cut -d, -f3)
	fi
}

listenport="51280"
dns=""
while IFS= read -r linex
do
	extract "$linex"
done < $file
extract "$linex"
PRK=$(echo "$endpoint" | tr ":" ",")
endpoint=$(echo $PRK | cut -d, -f1)
sport=$(echo $PRK | cut -d, -f2)

uci set wireguard.$name=wireguard
uci set wireguard.$name.auto="0"
uci set wireguard.$name.client="1"
uci set wireguard.$name.active="0"
uci set wireguard.$name.privatekey="$PrivateKey"
uci set wireguard.$name.presharedkey="$PreSharedKey"
uci set wireguard.$name.port="$listenport"
uci set wireguard.$name.addresses="$Address"	
uci set wireguard.$name.dns="$dns"
uci set wireguard.$name.publickey="$PublicKey"
uci set wireguard.$name.endpoint_host="$endpoint"
uci set wireguard.$name.ips="$allowedips"
uci set wireguard.$name.name="$name"
uci set wireguard.$name.sport="$sport"
uci set wireguard.$name.mtu="$mtu"
uci commit wireguard

rm -f $file
		