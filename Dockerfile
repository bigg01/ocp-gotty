FROM openshift/base-centos7

# Install gotty
RUN yum install tmux zsh compdef -y && yum clean all && mkdir -p /opt/app-root/src/.kube
ENV GOTTY_VERSION=v1.0.1
RUN  (curl -L https://github.com/yudai/gotty/releases/download/${GOTTY_VERSION}/gotty_linux_amd64.tar.gz | \
        tar -xz -C /usr/local/bin/)
# install jq
ENV JQ_VERSION=1.6
RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq
# install yq
ENV YQ_VERSION=2.2.0
RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq
# Install helm
ENV HELM_VERSION=v2.12.1
RUN (curl -L "https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz" | \
        tar -xz -C /usr/local/bin/)
# install odo
ENV ODO_VERSION=v0.0.17
RUN curl -L "https://github.com/redhat-developer/odo/releases/download/${ODO_VERSION}/odo-linux-amd64" -o /usr/local/bin/odo && chmod +x /usr/local/bin/odo
# install kompose
ENV KOMPOSE_VERSION=v1.16.0
RUN curl -L "https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64" -o /usr/local/bin/kompose && chmod +x /usr/local/bin/kompose
# Install oc-client
ENV OCP_VERSION=v3.11.0 \
    OCP_CLIENT_HASH=0cbc58b
# Install oc-client
RUN (curl -L https://github.com/openshift/origin/releases/download/${OCP_VERSION}/openshift-origin-client-tools-${OCP_VERSION}-${OCP_CLIENT_HASH}-linux-64bit.tar.gz | \
       tar -xz -C /usr/local/bin/) && cd /usr/local/bin && mv linux-amd64/* .  && mv openshift-origin-client-tools-${OCP_VERSION}-${OCP_CLIENT_HASH}-linux-64bit/* . && \
       rm -rf linux-amd64 openshift-origin-client-tools-${OCP_VERSION}-${OCP_CLIENT_HASH}-linux-64bit/ && cd -


# oh my zsh
ENV TZ=Europe/Zurich \
    TERM=xterm \
    ZSH_THEME=agnoster \
    GOTTY_PORT=8080  \
    GOTTY_USER=dummyuser \
    GOTTY_PASS=dummypass \
    GOTTY_CONFIG_FILE=/tmp/windows.config \
    GOTTY_TERM=xterm

RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#RUN echo "source <(oc completion zsh)" >> ~/.zshrc && chown -R 1001:root /opt/app-root/src && fix-permissions /opt/app-root/src/
RUN echo "source <(oc completion zsh)" >> ~/.zshrc && chown -R 1001:root /opt/app-root/src

USER 1001
EXPOSE 8080
# Set the default CMD to print the usage of the language image

#CMD ["gotty","--title-format","tkggo-test","--permit-write","--port","${GOTTY_PORT}","--once","--credential","guo:12345678","zsh"]
#CMD ["sh","-c","gotty --title-format \"GoTTY - {{ .Command }} ({{ .Hostname }})\" --permit-write --port ${GOTTY_PORT} --once --credential ${GOTTY_USER}:${GOTTY_PASS} zsh"]

# without tmux
#CMD ["sh","-c","gotty --config ${GOTTY_CONFIG_FILE}  --permit-write --port ${GOTTY_PORT} --credential ${GOTTY_USER}:${GOTTY_PASS} zsh"]
CMD ["sh","-c","gotty --permit-write --port ${GOTTY_PORT} --credential ${GOTTY_USER}:${GOTTY_PASS} zsh"]
# tmux
#CMD ["sh","-c","gotty tmux new -A -s --config ${GOTTY_CONFIG_FILE}  --permit-write --port ${GOTTY_PORT} --credential ${GOTTY_USER}:${GOTTY_PASS} zsh"]
