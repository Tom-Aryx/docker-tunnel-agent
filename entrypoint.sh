#!/usr/bin/env bash

DATA_DIR="$(pwd)/data"
WORK_DIR="$(pwd)"
UUID=${UUID:-"$(uuidgen)"}

# first run
if [ ! -s /etc/supervisor/conf.d/damon.conf ]; then

    if [ ! -e ${DATA_DIR}/clash.yml ]; then
        # copy clash yaml template
        cp ${DATA_DIR}/template/clash.yml ${DATA_DIR}/clash.yml
        # replace uuid, domain, path
        sed -e "s#-uuid-#$UUID#g" \
            -e "s#-argo-domain-#$ARGO_DOMAIN#g" \
            -i ${DATA_DIR}/clash.yml
    fi

    if [ ! -e ${DATA_DIR}/config.json ]; then
        # copy config.json template
        cp ${DATA_DIR}/template/config.json ${DATA_DIR}/config.json
        # replace uuid, path
        sed -e "s#-uuid-#$UUID#g" \
            -i ${DATA_DIR}/config.json
    fi
    # run args
    WEBJS_CMD="$WORK_DIR/web.js run -c=$DATA_DIR/config.json"

    if [ ! -e ${DATA_DIR}/config.agent.yml ]; then
        # copy agent yaml template
        cp ${DATA_DIR}/template/config.agent.yml ${DATA_DIR}/config.agent.yml
        # replace secret key
        sed -e "s#-uuid-#$UUID#" \
            -e "s#-secret-key-32-#$CLIENT_SECRET#" \
            -e "s#-server-host-#$CLIENT_HOST#" \
            -i ${DATA_DIR}/config.agent.yml
    fi
    # install agent
    ${WORK_DIR}/agent service -c ${DATA_DIR}/config.agent.yml install

    ## cloudflared
    CLOUDFLARED_CMD="$WORK_DIR/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token $ARGO_TOKEN"

    ## supervisor
    ### copy template
    cp ${DATA_DIR}/template/damon.conf /etc/supervisor/conf.d/damon.conf
    ### replace commands
    sed -e "s#-webjs-cmd-#$WEBJS_CMD#g" \
        -e "s#-cloudflared-cmd-#$CLOUDFLARED_CMD#g" \
        -i /etc/supervisor/conf.d/damon.conf
fi
# RUN agent
$WORK_DIR/agent service -c ${DATA_DIR}/config.agent.yml start
# RUN supervisor
supervisord -c /etc/supervisor/supervisord.conf
