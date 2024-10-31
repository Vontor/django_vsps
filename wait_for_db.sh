#!/bin/sh

# Wait for the database to be ready
while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
  echo "Waiting for database..."
  sleep 2
done

echo "Database is up - running migrations."

python manage.py makemigrations --noinput
python manage.py migrate --noinput

echo "Starting Django."
exec "$@"
