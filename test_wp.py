import requests
import json

url = 'https://blogsppheree.in/wp-json/ai-blog/v1/publish'
api_key = 'LQnNSaEBZyWrpIsRGLK98P@t'

headers = {
    'x-api-key': api_key,
    'Content-Type': 'application/json'
}

data = {
    'title': 'Test',
    'content': 'Test content',
    'status': 'publish',
    'slug': 'test-slug',
    'excerpt': 'Test excerpt',
    'meta': {}
}

response = requests.post(url, headers=headers, json=data)
print(f"Status Code: {response.status_code}")
print(f"Response: {response.text}")
