# Use the official Azure CLI image as the base image
FROM mcr.microsoft.com/azure-cli

# Copy your run.sh script into the container
COPY run.sh /usr/local/bin/run.sh

# Give execute permissions to your run.sh script
RUN chmod +x /usr/local/bin/run.sh

# Set your custom script as the entry point
ENTRYPOINT ["/usr/local/bin/run.sh"]