# Use an official Python runtime as the base image
FROM python:2.7-slim

# Set the maintainer label
LABEL maintainer="shea.andrews@ucsf.edu"

# Set environment variables
ENV LDSC_DIR /ldsc

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Navigate to the LDSC directory and install Python dependencies
WORKDIR $LDSC_DIR
RUN pip install \
    bitarray==0.8 \
    nose==1.3 \
    pybedtools==0.7 \
    numpy==1.11 \
    scipy==0.18 \
    pandas==0.20 \
    scikit-learn==0.18

# Clone the LDSC repository
RUN git clone https://github.com/bulik/ldsc.git $LDSC_DIR

# Make the LDSC scripts executable
RUN chmod +x *.py

# Set PATH to include LDSC scripts
ENV PATH $LDSC_DIR:$PATH

# Default command to run when starting the container
CMD ["ldsc.py", "--help"]
