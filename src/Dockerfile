# Use a slim Python base image for a smaller footprint
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /workspace

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
# Using --no-cache-dir reduces the image size
RUN pip install --no-cache-dir -r requirements.txt

# Copy a sample notebook into the workspace
COPY sample-analysis.ipynb .

# Expose the JupyterLab port
EXPOSE 8888

# Command to run JupyterLab
# --ip=0.0.0.0 makes it accessible from outside the container
# --allow-root is necessary to run as the root user inside the container
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
