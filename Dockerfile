FROM debian:bookworm-slim

WORKDIR /app

COPY . /app

# Install necessary packages for the script
RUN apt-get update && \
    apt-get install -y netcat-openbsd cowsay fortune-mod && \
    ln -s /usr/games/cowsay /usr/local/bin/cowsay && \
    ln -s /usr/games/fortune /usr/local/bin/fortune

# Make the script executable
RUN chmod +x wisecow.sh

# Expose the port the server runs on
EXPOSE 4499

# Start the script
CMD ["./wisecow.sh"]

