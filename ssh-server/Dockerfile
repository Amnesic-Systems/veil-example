# A Go base image is all we need to deterministically build a copy of veil.
# We use a specific instead of the latest image to ensure reproducibility.
FROM golang:1.23 as builder

WORKDIR /app

# Clone the repository and build the stand-alone veil executable.
RUN git clone https://github.com/Amnesic-Systems/veil.git
RUN make -C veil

COPY start.sh ./
RUN chmod 0755 ./start.sh

FROM alpine:3.20

# We need openrc for the rc-update tool.
RUN apk add --update --no-cache openssh openrc curl
RUN rc-update add sshd
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:root' | chpasswd

# Copy all our files to the final image.
COPY --from=builder \
    /app/veil/cmd/veil/veil \
    /app/start.sh /bin/

CMD ["start.sh"]
