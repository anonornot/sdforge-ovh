# Pinned Linux/AMD64 Forge image.
# The digest prevents the base image from changing unexpectedly.
FROM ghcr.io/jim60105/stable-diffusion-webui:forge@sha256:85a232e335f1a7066c2553103596dc598e9f6aa42933333559d771c7fe231ca3

USER 0

# OVH AI Deploy runs the application as 42420:42420.
# /workspace is the documented AI workload home directory.
RUN install -d -m 2775 -o 42420 -g 42420 \
      /workspace \
      /workspace/data \
      /workspace/data/models \
      /workspace/data/outputs \
      /workspace/data/config_states \
      /workspace/.cache \
      /tmp

COPY --chown=42420:42420 ovh-entrypoint.sh /usr/local/bin/ovh-entrypoint.sh
RUN chmod 0755 /usr/local/bin/ovh-entrypoint.sh

WORKDIR /workspace
ENV HOME=/workspace
ENV XDG_CACHE_HOME=/workspace/.cache
ENV TORCH_HOME=/workspace/.cache/torch
ENV HF_HOME=/workspace/.cache/huggingface
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# The parent image contains Forge's pre-built Python environment.
ENV PATH=/home/1001/.local/bin:/app:/usr/local/bin:/usr/bin:/bin
ENV PYTHONPATH=/app:/home/1001/.local/lib/python3.11/site-packages

EXPOSE 7860

USER 42420:42420
ENTRYPOINT ["/usr/local/bin/ovh-entrypoint.sh"]
CMD ["--api", "--skip-install", "--skip-python-version-check"]
