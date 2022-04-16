#!/bin/bash
#如果planet不存在，则创建文件
planetFile="/app/bin/planet"
if [ -f "$planetFile" ]; then
    echo "planet文件已经存在，不需要重新生成。"
    exit 0
fi
#获取服务器IP并更新文件
IP=$(curl http://ip.3322.net/)
cd /app/patch && sed -ri "s/([0-9]{1,3}\.){3}[0-9]{1,3}/$IP/g" patch.json
#生成planet文件
cd /var/lib/zerotier-one && zerotier-idtool initmoon identity.public > moon.json
cd /app/patch && python3 patch.py
cd /var/lib/zerotier-one && zerotier-idtool genmoon moon.json && mkdir -p moons.d && cp ./*.moon ./moons.d
cd /opt/ZeroTierOne/attic/world/ && sh build.sh
sleep 5s

cd /opt/ZeroTierOne/attic/world/ && ./mkworld
cp world.bin /var/lib/zerotier-one/planet && cp world.bin /app/bin/planet
