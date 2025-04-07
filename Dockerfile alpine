# syntax=docker/dockerfile:1.4

# 第一阶段：构建环境（使用最小化基础镜像）
FROM --platform=$BUILDPLATFORM python:3.10-alpine as builder

WORKDIR /app
# 安装编译依赖（Alpine包名与Debian不同）
RUN apk add --no-cache \
    openssl-dev \
    gcc \
    musl-dev \
    linux-headers

COPY requirements.txt .
RUN pip install --user --no-cache-dir --prefix=/install -r requirements.txt

# 第二阶段：运行环境（剥离所有构建工具）
FROM python:3.10-alpine

WORKDIR /app
# 仅复制必要的运行时依赖
RUN apk add --no-cache libssl3
COPY --from=builder /install /usr/local
COPY gpt.py .

# 环境优化
ENV PATH=/usr/local/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    # 防止Python生成.pyc文件
    PYTHONDONTWRITEBYTECODE=1 \
    # 时区配置
    TZ=Asia/Shanghai

# 清理缓存
RUN rm -rf /var/cache/apk/* /tmp/*

CMD ["python", "gpt.py"]