# A Go base image is all we need to deterministically build a copy of veil.
# We use a specific instead of the latest image to ensure reproducibility.
FROM golang:1.23 as builder

WORKDIR /app

# Clone the repository and build the stand-alone veil executable.
RUN git clone --quiet https://github.com/Amnesic-Systems/veil.git
RUN make -C veil

# Use the intermediate builder image to add our files.  This is necessary to
# avoid intermediate layers that contain inconsistent file permissions.
COPY enclave-app.py ./
RUN chown root:root ./enclave-app.py
RUN chmod 0755      ./enclave-app.py

FROM python:3.12-slim-bullseye

# Copy all our files to the final image.
COPY --from=builder \
    /app/veil/cmd/veil/veil \
    /app/enclave-app.py /bin/

ENTRYPOINT ["veil", \
    "-fqdn", "example.com", \
    "-wait-for-app", \
    "-app-cmd", "enclave-app.py"]
