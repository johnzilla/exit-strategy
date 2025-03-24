FROM python:3.9-slim

WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Expose port
EXPOSE 8000

# Create a non-root user to run the app
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# Run the application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]