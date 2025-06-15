FROM Python:3.10-slim

WORKDIR /app

COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
CMD python ./main.py

# Build the Docker image with the command:
# docker build -t infrastructure-repo:latest .
