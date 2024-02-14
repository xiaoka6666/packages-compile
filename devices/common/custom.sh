#!/bin/bash

shopt -s extglob
rm -rf feeds/kiddin9/{diy,mt-drivers,shortcut-fe,luci-app-mtwifi,base-files,firewall,dnsmasq}

for ipk in $(find feeds/kiddin9/* -maxdepth 0 -type d);
do
	[[ "$(grep "KernelPackage" "$ipk/Makefile")" && ! "$(grep "BuildPackage" "$ipk/Makefile")" ]] && rm -rf $ipk || true
done



./scripts/feeds update -a
./scripts/feeds install -a -p kiddin9 -f
./scripts/feeds install -a


cp -f devices/common/.config .config

make defconfig

sed -i "/mediaurlbase/d" package/feeds/*/luci-theme*/root/etc/uci-defaults/*

sed -i '/WARNING: Makefile/d' scripts/package-metadata.pl


cp -f devices/common/po2lmo staging_dir/host/bin/po2lmo
chmod +x staging_dir/host/bin/po2lmo
