# --- STAGE 1: BUILDER --- #
FROM python:3.13-slim AS builder

# Install build-essential and headers for Python C-extensions (Required for libraries like psycopg2 (Postgres) or cryptography)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc=4:14* \
    python3-dev=3.13.* \
    libpq-dev=17.9-0* \
    libffi-dev=3.4.* \
    git=1:2.47* \
    && rm -rf /var/lib/apt/lists/*

# Setup Virtual Env
RUN python3 -m venv /opt/ansible-venv
ENV PATH="/opt/ansible-venv/bin:$PATH"

COPY build/requirements.txt /tmp/requirements.txt
COPY build/requirements.yml /tmp/requirements.yml

# Install Python dependencies and Collections directly into the venv folder for portability
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    ansible-galaxy collection install -r /tmp/requirements.yml \
    -p /opt/ansible-venv/collections

# --- STAGE 2: FINAL RUNTIME --- #
FROM python:3.13-slim

# Install ONLY the necessary runtime libraries (libpq is needed for Postgres tasks to run)
RUN apt-get update && apt-get install -y --no-install-recommends \
    sshpass=1.10-0.* \
    openssh-client=1:10.0p1* \
    git=1:2.47* \
    libpq5=17.9-0* \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire prepared virtual env
COPY --from=builder /opt/ansible-venv /opt/ansible-venv

# Environment Settings
ENV PATH="/opt/ansible-venv/bin:$PATH"
ENV ANSIBLE_COLLECTIONS_PATH=/opt/ansible-venv/collections
ENV ANSIBLE_LOCAL_TEMP=/tmp/ansible
ENV ANSIBLE_REMOTE_TEMP=/tmp/ansible

# Create temp directories
RUN mkdir -p /etc/ansible /tmp/ansible/cp && \
    chmod -R 1777 /tmp/ansible

WORKDIR /ansible
