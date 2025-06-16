# syntax=docker/dockerfile:1.4
FROM python:3.10-slim

WORKDIR /app

# Use BuildKit secret
RUN --mount=type=secret,id=my-secret \
    sh -c 'echo "Build-time secret is: $(cat /run/secrets/my-secret)"'

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["python", "main.py"]

# To run this Dockerfile, you need to build it with the secret:
# docker build --secret id=my-secret,src=path/to/secret.txt -t my-python-app .
