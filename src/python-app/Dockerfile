FROM python:3.10-slim
WORKDIR /app
COPY index.html .
COPY server.py .
RUN pip install flask
CMD ["python", "server.py"]