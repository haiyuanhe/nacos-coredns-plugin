#!/usr/bin/env bash
# cd GOPATH
cd $GOPATH/src/

# remove codes
rm -rf coredns
rm -rf nacos-coredns-plugin

# clone current codes
git clone --depth=1 https://github.com.cnpmjs.org/haiyuanhe/nacos-coredns-plugin.git
git clone --depth=1 -b v1.2.6 https://github.com.cnpmjs.org/coredns/coredns.git

# cd coredns directory
cd $GOPATH/src/coredns

# copy nacos plugin to coredns
cp -r ../nacos-coredns-plugin/nacos plugin/

# insert nacos into plugin
sed -i '/coredns\/core\/dnsserver/a\\t_ "coredns/plugin/nacos"' core/coredns.go
sed -i '/whoami/a\\t"nacos",' core/dnsserver/zdirectives.go
sed -i '/coredns\/plugin\/whoami/a\\t_ "coredns/plugin/nacos"' core/plugin/zplugin.go

# modify import
sed -i "s/github.com\/coredns\///g" `grep 'github.com/coredns/' -rl . | grep '.go'`

cat Makefile | grep -v 'presubmit core/zplugin.go core/dnsserver/zdirectives.go godeps' > /tmp/Makefile
mv /tmp/Makefile .

# build
make
