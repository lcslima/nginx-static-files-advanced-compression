# Nginx Best Compression POC

This project demonstrates a proof of concept for configuring Nginx with optimal compression settings using Brotli and Gzip.

## Project Structure

- **Dockerfile**: Builds the Docker image with Nginx, Brotli, and Headers More module.
- **nginx.conf**: Nginx configuration file optimized for compression and resource usage.
- **compress.sh**: Script to pre-compress static files during the build process.
- **static/**: Directory containing static files to be served by Nginx.

## Prerequisites

- Docker installed on your machine.

## Building the Docker Image

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/nginx-best-compression-poc.git
   cd nginx-best-compression-poc
2. Build the Docker image:

   ```sh 
   docker build -t nginx-best-compression-poc .
## Building the Docker Image
1. Container Running
   ```sh
   docker run -p 80:80 nginx-best-compression-poc

## Nginx Configuration
The nginx.conf is configured to:

- Enable Brotli and Gzip compression.
- Optimize resource usage and performance.
- Key Configuration Settings:
- Worker Processes: Set to auto to automatically determine the optimal number of - worker processes based on available CPU cores.
- Worker Connections: Set to 1024 to handle a higher number of simultaneous connections.
- Compression: Brotli and Gzip are enabled with high compression levels and predefined MIME types.
- Caching: Configured to cache responses and bypass the cache based on query strings.
- Pre-compression Script
- The compress.sh script is used to pre-compress static files using Brotli and Gzip during the build process, reducing the load on the server.

## Troubleshooting
- If you encounter issues, check the error logs:
  ```sh
   docker run -p 80:80 nginx-best-compression-poc
# Contribution
Feel free to fork the repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

# License
This project is licensed under the MIT License.
