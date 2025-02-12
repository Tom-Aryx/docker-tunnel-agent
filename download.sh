#!/usr/bin/env bash

CF_VERSION="$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"

wget -q https://github.com/cloudflare/cloudflared/releases/download/${CF_VERSION}/cloudflared-linux-amd64
mv cloudflared-linux-amd64 cloudflared && chmod +x cloudflared

#AGENT_VERSION="$(curl -s https://api.github.com/repos/nezhahq/agent/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"
AGENT_VERSION="v1.2.0"

wget -q https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_amd64.zip
unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip && mv nezha-agent agent && chmod +x agent
