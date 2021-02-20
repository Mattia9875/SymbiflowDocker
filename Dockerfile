FROM continuumio/miniconda3

WORKDIR /symb
ENV INSTALL_DIR=/symb
ARG BOARD_MODEL
ENV BOARD_MODEL=${BOARD_MODEL}
ENV FPGA_FAM=xc7
RUN apt update && \
    apt install -y git wget picocom xz-utils xc3sprog
RUN git clone https://github.com/SymbiFlow/symbiflow-examples && \
    cd symbiflow-examples
RUN conda env create -f ${INSTALL_DIR}/symbiflow-examples/${FPGA_FAM}/environment.yml
RUN mkdir -p $INSTALL_DIR/xc7/install && \
    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-install-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install       && \
    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-${BOARD_MODEL}_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install

#    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-xc7a50t_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install  && \
#    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-xc7a100t_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install && \
#    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-xc7a200t_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install && \
#    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-xc7z010_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/xc7/install
RUN echo "source activate xc7" > ~/.bashrc
ENV PATH="$PATH:/symb/xc7/install/bin"