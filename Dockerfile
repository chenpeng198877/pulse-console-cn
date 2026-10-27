FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends adb ca-certificates curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY fleet.py heartbeat_scan.py ./
COPY devices.example.json ./
COPY static ./static
EXPOSE 8787
CMD ["python3", "/app/fleet.py"]
