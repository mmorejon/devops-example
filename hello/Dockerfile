# Using official python runtime base image
FROM python:3.7.2-alpine

# Set the application directory
WORKDIR /app

# install dependencies
RUN apk add curl

# Install our requirements.txt
ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Copy our code from the current folder to /app inside the container
ADD . /app

# helthcheck
HEALTHCHECK --interval=5s --timeout=10s \
    CMD curl --fail http://localhost/hello/joe || exit 1

# Define our command to be run when launching the container
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]
