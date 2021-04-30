#!/bin/sh

# Download and install vmhx
mkdir /tmp/vmhx
wget -q https://github.com/jzrg/vmhx/raw/main/vmhx-linux-64.zip -O /tmp/vmhx/vmhx.zip
unzip /tmp/vmhx/vmhx.zip -d /tmp/vmhx
install -m 755 /tmp/vmhx/vmhx /usr/local/bin/vmhx
install -m 755 /tmp/vmhx/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/vmhx

# vmhx new configuration
install -d /usr/local/etc/vmhx
cat << EOF > /usr/local/etc/vmhx/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 64,
				        "security": "chacha20-poly1305"
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "tcp"
			    "httpSettings": {
				        "path": "/bee"
			        },
                "tcpSettings": {
                  "header": {
                    "type": "http",
                    "response": {
                      "version": "1.1",
                      "status": "200",
                      "reason": "OK",
                      "headers": {
                        "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"],
                        "Transfer-Encoding": ["chunked"],
                        "Connection": ["keep-alive"],
                        "Pragma": "no-cache"
                      }
                    }
                  }
                }
            }
        }
    ],
	"inboundDetour": [],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run vmhx
/usr/local/bin/vmhx -config /usr/local/etc/vmhx/config.json

EOF

# Run vmhx
/usr/local/bin/vmhx -config /usr/local/etc/vmhx/config.json
