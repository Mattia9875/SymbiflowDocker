FROM continuumio/miniconda3

#taking the board model as build time argument
ARG BOARD_MODEL
WORKDIR /symb

#setting the enviroment variables
ENV INSTALL_DIR=/symb
ENV BOARD_MODEL=${BOARD_MODEL}
ENV FPGA_FAM=xc7

#additional variables
ENV MODE=null
ENV TOP_FILE=null
ENV PRJ_DIR=null

#installing the necessary tools
RUN apt update && \
    apt install -y git wget xz-utils xc3sprog

#cloning into symbiflow-examples
RUN git clone https://github.com/SymbiFlow/symbiflow-examples && \
    cd symbiflow-examples

#creating the conda enviroment
RUN conda env create -f ${INSTALL_DIR}/symbiflow-examples/${FPGA_FAM}/environment.yml

#setting the shell inside the enviroment (xc7 -> FAMILY)
SHELL ["conda", "run", "-n", "xc7", "/bin/bash", "-c"]

#installing pyFPGA    
RUN git clone --single-branch --branch symbiflow-support https://github.com/PyFPGA/pyfpga.git && \
    cd pyfpga && \
    git clone https://github.com/PyFPGA/resources.git && \
    pip install -e . && \
    cd ..

#installing the toolchain
RUN mkdir -p $INSTALL_DIR/${FPGA_FAM}/install && \
    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-install-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/${FPGA_FAM}/install       && \
    wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/112/20201208-080919/symbiflow-arch-defs-${BOARD_MODEL}_test-7c1267b7.tar.xz | tar -xJC $INSTALL_DIR/${FPGA_FAM}/install

#linking the toolchain commands
ENV PATH="$PATH:/symb/${FPGA_FAM}/install/bin"

#Copy runner script
COPY symbiflowrun.py /symb/

#Set entrypoint
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "xc7", "python3", "symbiflowrun.py"]