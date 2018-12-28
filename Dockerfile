FROM openshift/base-centos7

# Install gotty
RUN    (curl -L https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz | \
        tar -xz -C /usr/local/bin/)


USER 1001
EXPOSE 8080
# Set the default CMD to print the usage of the language image

CMD ["gotty","--title-format","tkggo-test","--permit-write","--port","8080","bash"]
