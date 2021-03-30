FROM alpine:3.13

ENV TERRAFORM_VERSION 0.14.9

ENV PACKEGES \
  bash\
  git \
  tar \
  sshpass \
  curl \
  libc6-compat \
  openssh-client \
  py-pip \
  python3

RUN set -x && \ 
  \
  echo "==> Adding Packeges..."  && \
    apk --update --no-cache add ${PACKEGES} && \
  \
  echo "==> Install awscli..."  && \
    pip3 install awscli && \
  \
  echo "==> Install Terraform..."  && \
    cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip -o terraform_0.14.9_linux_amd64.zip && \
    unzip terraform_0.14.9_linux_amd64.zip && \
    rm terraform_0.14.9_linux_amd64.zip && \
  \
  echo "==> Adding terraform alias..."  && \
    alias init='terraform init' && \
    alias plan='terraform plan' && \
    alias apply='terraform apply'

ENV TERRAFORM_EC2 ~/test_task/terraform:/work
ENV SSH ~/.ssh_test:/root/.ssh:ro

WORKDIR /work

