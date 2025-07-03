dockerd-rootless-setuptool.sh install
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during installing of rootless Docker"
    exit 1
fi

echo "[SCRIPT] Rootless docker installed"

systemctl --user enable docker
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during adding rootless Docker unit to load on boot"
    exit 1
fi
echo "[SCRIPT] Rootless Docker added to load on boot"
echo "[SCRIPT] Success"
