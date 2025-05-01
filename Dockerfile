# Use an official Python image as a base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy only the requirements file first (to cache pip install)
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the application files
COPY app.py app_chat.py kernel.py kernel_chat.py agent_utils.py .env /app/

# Expose Chainlit's default port
EXPOSE 8000

# Set default app
ENV CHAINLIT_APP=app.py
 


# Run Chainlit using the chosen app file
CMD ["tail", "-f", "/dev/null"]

# CMD ["chainlit", "run", $CHAINLIT_APP, "--host", "0.0.0.0", "--port", "8000"]
