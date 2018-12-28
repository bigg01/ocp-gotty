FROM openshift/base-centos7

# Install gotty
RUN yum install zsh -y && yum clean all

RUN  (curl -L https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz | \
        tar -xz -C /usr/local/bin/)
# Install helm
RUN (curl -L https://storage.googleapis.com/kubernetes-helm/helm-v2.12.1-linux-amd64.tar.gz | \
        tar -xz -C /usr/local/bin/)

# Install oc-client
RUN (curl -L https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz | \
        tar -xz -C /usr/local/bin/)
RUN cd /usr/local/bin && mv linux-amd64/* .  && mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/* . && rm -rf linux-amd64 openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/ && cd -
# oh my zsh

ENV TZ=Europe/Zurich TERM=xterm ZSH_THEME=agnoster

RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN echo "source <(oc completion zsh)" >> ~/.zshrc && chown -R 1001:root /opt/app-root/src

USER 1001
EXPOSE 8080
# Set the default CMD to print the usage of the language image

CMD ["gotty","--title-format","tkggo-test","--permit-write","--port","8080","zsh"]
