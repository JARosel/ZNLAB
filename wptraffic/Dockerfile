FROM python:3.11-slim

WORKDIR /app

# Instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar scripts
COPY traffic_generator.py .

# Ejecutar el script
CMD ["python", "-u", "traffic_generator.py"]
