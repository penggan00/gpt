# 第一阶段：构建依赖
FROM python:3.10-slim as builder
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libssl-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# 第二阶段：运行环境
FROM python:3.10-slim
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/.local /root/.local
COPY gpt.py .

ENV PATH=/root/.local/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

CMD ["python", "gpt.py"]