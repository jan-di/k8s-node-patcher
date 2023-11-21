FROM docker.io/python:3.12

RUN apt update && apt install -y jq && rm -rf /var/lib/apt/lists/*

RUN pip install ansible

RUN mkdir -p /k8s-node-patcher/playbooks

ENV ANSIBLE_LOCALHOST_WARNING=False \
    ANSIBLE_INVENTORY_UNPARSED_WARNING=False

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]