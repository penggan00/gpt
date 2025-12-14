# syntax=docker/dockerfile:1.4

# 第一阶段：构建环境
FROM --platform=$BUILDPLATFORM python:3.10-alpine as builder

WORKDIR /app

# 安装编译依赖
RUN apk add --no-cache \
    openssl-dev \
    gcc \
    musl-dev \
    linux-headers

# 创建虚拟环境（更推荐的方式）
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 清理构建依赖（可选）
RUN apk del gcc musl-dev linux-headers openssl-dev

# 第二阶段：运行环境
FROM python:3.10-alpine

WORKDIR /app

# 安装运行时依赖
RUN apk add --no-cache libssl3 tzdata

# 复制虚拟环境（而不是整个/install）
COPY --from=builder /opt/venv /opt/venv

# 复制应用代码
COPY gpt.py .

# 环境优化
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=/app \
    TZ=Asia/Singapore

# 创建非root用户（安全最佳实践）
RUN addgroup -g 1000 appuser && \
    adduser -u 1000 -G appuser -D appuser && \
    chown -R appuser:appuser /app

USER appuser

# 清理缓存
RUN rm -rf /var/cache/apk/* /tmp/*

CMD ["python", "gpt.py"]