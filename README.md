# docker-tunnel-agent

agent over cloudflare tunnel

**still on testing**

**NOTICE**

> ONLY support x64 platform  
> if you have any nice idea, please ISSUE  

## DEMO

![demo](https://pic.2rmz.com/1734947847381.png)

## HOW TO USE

### 0 build

```bash
git clone https://github.com/Tom-Aryx/docker-tunnel-agent
cd docker-tunnel-agent
docker build -t your-tag .
```

### 1 run

**variables**
```env
# required
ARGO_DOMAIN='test.example.com'
ARGO_TOKEN='ey****J9'
CLIENT_HOST='nezha.example.com'
CLIENT_SECRET='zk****ol'

# optional
UUID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

**run in docker**
```bash
docker run -d \
  -e ARGO_DOMAIN="test.example.com" \
  -e ARGO_TOKEN="ey****J9" \
  -e CLIENT_HOST='nezha.example.com:443' \
  -e CLIENT_SECRET='zk****ol' \
  -e UUID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' \
  --name "webjs" \
  your-tag:latest
```

### 2 config

```yml
- name: TEST
  type: vless
  server: icook.hk
  port: 443
  uuid: UUID
  tls: true
  udp: true
  servername: ARGO_DOMAIN
  skip-cert-verify: false
  network: ws
  ws-opts:
    path: fetch?ed=2048
    headers:
      Host: ARGO_DOMAIN
```

## INSPIRATION

[nezhahq/nezha](https://github.com/nezhahq/nezha)  
[nezhahq/agent](https://github.com/nezhahq/agent)  
[fscarmen2/Argo-X-Container-PaaS](https://github.com/fscarmen2/Argo-X-Container-PaaS)  
[fscarmen2/Argo-Nezha-Service-Container](https://github.com/fscarmen2/Argo-Nezha-Service-Container)
