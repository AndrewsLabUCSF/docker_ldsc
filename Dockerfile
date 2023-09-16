# Use an official Python runtime as the base image
FROM python:2.7-slim

# Set the maintainer label
LABEL maintainer="shea.andrews@ucsf.edu"

# Set environment variables
ENV LDSC_DIR /ldsc

# Update and upgrade
RUN apt-get update && apt-get upgrade -y

# Install individual system dependencies and clean up
RUN apt-get update && apt-get install -y \
    build-essential \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get install -y git && apt-get clean
RUN apt-get install -y gcc && apt-get clean
RUN apt-get install -y g++ && apt-get clean
RUN apt-get install -y zlib1g-dev && apt-get clean
# RUN apt-get install -y libbedtools2-dev && apt-get clean
RUN apt-get install -y bedtools && apt-get clean
RUN apt-get install -y libbz2-dev && apt-get clean
RUN apt-get install -y liblzma-dev && apt-get clean

RUN apt-get update && apt-cache madison libbedtools2-dev

# Navigate to the LDSC directory and install Python dependencies
WORKDIR $LDSC_DIR

# Check pip version
RUN pip --version

# Install Python dependencies one by one
RUN pip install bitarray==0.8 && \
    pip show bitarray

RUN pip install nose==1.3 && \
    pip show nose

RUN pip install pybedtools==0.7 || (echo "Failed to install pybedtools" && exit 1)

# RUN pip install pybedtools==0.7 && \
#     pip show pybedtools

RUN pip install numpy==1.11 && \
    pip show numpy

RUN pip install scipy==0.18 && \
    pip show scipy

RUN pip install pandas==0.20 && \
    pip show pandas

RUN pip install scikit-learn==0.18 && \
    pip show scikit-learn

# Clone the LDSC repository
RUN git clone https://github.com/bulik/ldsc.git $LDSC_DIR

# Make the LDSC scripts executable
RUN chmod +x *.py

# Set PATH to include LDSC scripts
ENV PATH $LDSC_DIR:$PATH

# Default command to run when starting the container
CMD ["ldsc.py", "--help"]
