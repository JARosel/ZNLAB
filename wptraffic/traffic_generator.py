#!/usr/bin/env python3
import os
import time
import random
import requests
from faker import Faker
from wordpress_xmlrpc import Client, WordPressPost
from wordpress_xmlrpc.methods.posts import NewPost
from wordpress_xmlrpc.methods import taxonomies
from datetime import datetime

# Configuración desde variables de entorno
WP_URL = os.getenv('WP_URL', 'http://wordpress')
WP_USER = os.getenv('WP_USER', 'admin')
WP_PASSWORD = os.getenv('WP_PASSWORD', 'password')
TRAFFIC_INTERVAL = int(os.getenv('TRAFFIC_INTERVAL', '60'))
POST_INTERVAL = int(os.getenv('POST_INTERVAL', '300'))

fake = Faker(['es_ES', 'en_US'])

# Lista de páginas comunes en WordPress
WORDPRESS_PAGES = [
    '/',
    '/blog/',
    '/about/',
    '/contact/',
    '/category/general/',
    '/wp-admin/',
    '/feed/',
    '/sitemap.xml',
]

def log(message):
    """Imprime mensaje con timestamp"""
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {message}")

def generate_traffic():
    """Genera tráfico HTTP aleatorio al WordPress"""
    try:
        # Seleccionar página aleatoria
        page = random.choice(WORDPRESS_PAGES)
        url = f"{WP_URL}{page}"
        
        # Headers realistas
        headers = {
            'User-Agent': fake.user_agent(),
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': random.choice(['es-ES,es;q=0.9', 'en-US,en;q=0.9', 'es-ES,es;q=0.9,en;q=0.8']),
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
        }
        
        # Realizar petición
        response = requests.get(url, headers=headers, timeout=10, allow_redirects=True)
        log(f"✓ Tráfico generado: {url} - Status: {response.status_code}")
        
    except Exception as e:
        log(f"✗ Error generando tráfico: {str(e)}")

def create_wordpress_post():
    """Crea un post en WordPress con contenido aleatorio"""
    try:
        # Conectar a WordPress XML-RPC
        xmlrpc_url = f"{WP_URL}/xmlrpc.php"
        wp = Client(xmlrpc_url, WP_USER, WP_PASSWORD)
        
        # Generar contenido aleatorio
        post = WordPressPost()
        post.title = fake.sentence(nb_words=random.randint(4, 8)).rstrip('.')
        
        # Generar varios párrafos
        paragraphs = []
        num_paragraphs = random.randint(3, 6)
        for _ in range(num_paragraphs):
            paragraphs.append(fake.paragraph(nb_sentences=random.randint(3, 7)))
        
        post.content = '\n\n'.join([f"<p>{p}</p>" for p in paragraphs])
        
        # Metadatos
        post.post_status = 'publish'
        post.comment_status = 'open'
        
        # Publicar post
        post_id = wp.call(NewPost(post))
        log(f"✓ Post creado exitosamente: ID={post_id}, Título='{post.title}'")
        
        return post_id
        
    except Exception as e:
        log(f"✗ Error creando post: {str(e)}")
        return None

def test_wordpress_connection():
    """Prueba la conexión a WordPress"""
    try:
        response = requests.get(WP_URL, timeout=10)
        log(f"✓ Conexión a WordPress exitosa: {WP_URL} - Status: {response.status_code}")
        return True
    except Exception as e:
        log(f"✗ Error conectando a WordPress: {str(e)}")
        return False

def main():
    log("=== Iniciando Generador de Tráfico para WordPress ===")
    log(f"WordPress URL: {WP_URL}")
    log(f"Usuario: {WP_USER}")
    log(f"Intervalo de tráfico: {TRAFFIC_INTERVAL}s")
    log(f"Intervalo de posts: {POST_INTERVAL}s")
    
    # Esperar a que WordPress esté disponible
    log("Esperando a que WordPress esté disponible...")
    while not test_wordpress_connection():
        log("WordPress no disponible, reintentando en 10s...")
        time.sleep(10)
    
    log("✓ WordPress disponible, iniciando generación...")
    
    last_post_time = time.time()
    
    try:
        while True:
            # Generar tráfico
            generate_traffic()
            
            # Crear post si ha pasado el intervalo
            current_time = time.time()
            if current_time - last_post_time >= POST_INTERVAL:
                create_wordpress_post()
                last_post_time = current_time
            
            # Esperar antes de la siguiente petición
            time.sleep(TRAFFIC_INTERVAL)
            
    except KeyboardInterrupt:
        log("=== Deteniendo generador de tráfico ===")

if __name__ == "__main__":
    main()
