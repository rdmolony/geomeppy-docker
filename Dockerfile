FROM rdmolony/energyplus:9.1.0 AS builder
FROM python:3.7-slim

ENV ENERGYPLUS_INSTALL_VERSION=9-1-0
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION

RUN pip install notebook==6.1.5 geomeppy==0.11.8

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Add tk as geomeppy requires it
RUN apt update && apt install -y tk

CMD ["/bin/bash"]

RUN echo 'alias jnbook="jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root"' >> ~/.bashrc
