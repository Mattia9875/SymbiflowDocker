FROM continuumio/miniconda3

#---

ARG DEVICE=xc7a50t
ARG FAMILY=xc7

ARG INST_DIR=/opt/symbiflow/${FAMILY}
ARG BASE_URL=https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs

#---

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    xc3sprog

RUN mkdir -p $INST_DIR \
 && wget -qO- ${BASE_URL}-install-7c1267b7.tar.xz        | tar -xJC ${INST_DIR} \
 && wget -qO- ${BASE_URL}-${DEVICE}_test-7c1267b7.tar.xz | tar -xJC ${INST_DIR}

ENV PATH=${INST_DIR}/bin:$PATH

#---

RUN git clone https://github.com/SymbiFlow/symbiflow-examples.git /tmp/symbiflow \
 && conda env create -f /tmp/symbiflow/${FAMILY}/environment.yml \
 && rm -fr /tmp/symbiflow

RUN echo "source activate ${FAMILY}" > ~/.bashrc
