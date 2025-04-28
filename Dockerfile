# docker build -t lexatlas-frontend-chainlit .
# docker run -p 8000:8000 lexatlas-frontend-chainlit


# Use an official Python image as a base
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copy only the required files into the container
COPY app.py kernel.py .env /app/

# Install any needed packages specified in requirements.txt
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 8000

# Define environment variable
ENV CHAINLIT_PORT=8000

# Run the application using Chainlit
# CMD ["chainlit", "run", "app.py"]
# CMD ["tail", "-f", "/dev/null"]
CMD ["chainlit", "run", "app.py", "--host", "0.0.0.0", "--port", "8000"]