#!/bin/sh
# One-shot installer: enable the DMZ policy-routing unit created by ZCode.
sudo install -m 755 /tmp/dmz-routing.sh /usr/local/sbin/dmz-routing.sh
sudo install -m 644 /tmp/dmz-routing.service /etc/systemd/system/dmz-routing.service
sudo systemctl daemon-reload
sudo systemctl enable dmz-routing.service
sudo systemctl restart dmz-routing.service
sudo systemctl is-active dmz-routing.service
