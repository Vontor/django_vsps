# Use the official Python image from the Docker Hub
FROM python:3

# Install netcat-openbsd
#RUN apt-get update && \
#    apt-get install -y netcat-openbsd && \
#    apt-get clean

#COPY wait_for_db.sh /wait_for_db.sh
#RUN chmod +x /wait_for_db.sh

# Use the script as the entrypoint
#ENTRYPOINT ["/wait_for_db.sh"]


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /code

# Copy the requirements file and install dependencies
COPY requirements.txt .

RUN pip install -r requirements.txt



# Copy the project files
COPY . .

# Expose the port the app runs on
EXPOSE 8000

# Run Django setup commands
RUN python manage.py collectstatic --noinput
RUN python manage.py makemigrations --noinput
RUN python manage.py migrate --noinput

# Start the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_vsps.wsgi:application"]
