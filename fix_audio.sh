#!/bin/bash
# Fix the 3.5mm audio jack.
#
# Problem: the BIOS pin table for the Conexant SN6140 codec (on the "Ryzen HD
# Audio Controller", mislabeled as Realtek ALC1220) marks the headphone jack
# pin (node 0x18) as "not connected". The kernel therefore builds a
# capture-only sound card.
#
# Fix: override node 0x18's pin default to 0x04211020 ("headphone jack,
# 1/8-inch, external"). Applied live via sysfs, then persisted as an HDA
# patch file so it survives reboots and kernel updates.
#
# Run as your normal user (NOT with sudo); it uses sudo internally
# but must control your user-session PipeWire services.
#
# To undo: sudo rm /lib/firmware/hda-ms-a2.fw /etc/modprobe.d/msa2-audio.conf
# and reboot.
set -e

if [ "$(id -u)" -eq 0 ]; then
  echo "ERROR: run this as your normal user, not with sudo." >&2
  exit 1
fi

echo "==> Stopping PipeWire so the codec can be reconfigured..."
# Sockets first, else socket activation restarts the services mid-stop.
systemctl --user stop pipewire.socket pipewire-pulse.socket || true
systemctl --user stop wireplumber pipewire-pulse pipewire || true
sleep 1
if systemctl --user is-active --quiet pipewire; then
  echo "ERROR: pipewire is still running; aborting before reconfig." >&2
  exit 1
fi

echo "==> Applying pin override to node 0x18 (headphone jack)..."
echo '0x18 0x04211020' | sudo tee /sys/class/sound/hwC1D0/user_pin_configs
echo 1 | sudo tee /sys/class/sound/hwC1D0/reconfig

echo "==> Installing persistent HDA patch (survives reboots)..."
sudo tee /lib/firmware/hda-ms-a2.fw >/dev/null <<'EOF'
[codec]
0x14f11f87 0x1f4cb021 0

[pincfg]
0x18 0x04211020
EOF
sudo tee /etc/modprobe.d/msa2-audio.conf >/dev/null <<'EOF'
options snd-hda-intel patch=hda-ms-a2.fw,hda-ms-a2.fw
EOF

echo "==> Restarting PipeWire..."
systemctl --user start pipewire.socket pipewire-pulse.socket pipewire pipewire-pulse wireplumber
sleep 3

echo "==> Kernel's new view of the codec:"
journalctl -k -b | grep hdaudioC1D0 | tail -8
echo "==> ALSA playback devices on card 1:"
aplay -l | grep -A2 '^card 1' || echo "  (no card 1 playback yet)"
echo "==> PipeWire sinks:"
wpctl status | sed -n '/Sinks:/,/Sources:/p'
