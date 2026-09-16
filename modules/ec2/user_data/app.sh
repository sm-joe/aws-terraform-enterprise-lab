#!/bin/bash

set -euxo pipefail

exec > >(tee /var/log/app-bootstrap.log | logger -t app-bootstrap -s 2>/dev/console) 2>&1

dnf install -y python3

mkdir -p /opt/app

cat > /opt/app/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>AWS Terraform Enterprise Lab</title>
</head>
<body>
  <h1>AWS Terraform Enterprise Lab</h1>
  <p>Application server is running successfully.</p>
  <p>Served from a private EC2 instance behind an Application Load Balancer.</p>
</body>
</html>
HTML

cat > /etc/systemd/system/app-server.service <<'SERVICE'
[Unit]
Description=Application HTTP Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/app
ExecStart=/usr/bin/python3 -m http.server 8080 --bind 0.0.0.0
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable app-server.service
systemctl start app-server.service

systemctl status app-server.service --no-pager
