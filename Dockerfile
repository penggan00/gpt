FROM python:3.9.18-slim-bullseye
WORKDIR /app
COPY ./ /app/
RUN pip install --no-cache-dir -r requirements.txt
ENV TELEGRAM_GEMINI_KEY=""
ENV GEMINI_API_KEY=""
ENV GPT_ENGINE=""
ENV TELEGRAM_CHAT_ID=""
CMD ["sh", "-c", "python gpt.py ${TELEGRAM_GEMINI_KEY} ${GEMINI_API_KEY} ${GPT_ENGINE} ${TELEGRAM_CHAT_ID}"]