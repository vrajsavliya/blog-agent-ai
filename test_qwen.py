import os
import requests
import json
# pyrefly: ignore [missing-import]
from dotenv import load_dotenv

load_dotenv()
api_key = os.environ.get('QWEN_API_KEY')

def test_qwen(prompt):
    url = "https://integrate.api.nvidia.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    data = {
        "model": "qwen/qwen3-next-80b-a3b-instruct",
        "temperature": 0.6,
        "top_p": 0.7,
        "max_tokens": 4096,
        "messages": [{"role": "user", "content": prompt}]
    }
    r = requests.post(url, headers=headers, json=data)
    try:
        content = r.json()['choices'][0]['message']['content']
        print(content)
    except Exception as e:
        print("Error:", r.text)

prompt = """
You are an expert blog content strategist. Create a comprehensive article outline.

Topic: The Future of Quantum Computing
Primary Keyword: quantum computing

Return a JSON object with this exact field:
- sections: array of objects, each with:
  - title: string (the H2 or H3 heading)
  - description: string (a brief instruction of what to cover in this section)

Ensure you include an Introduction, 4-6 main body sections, and a Conclusion.
Only return valid JSON. No markdown wrapping. No explanation.
"""
test_qwen(prompt)
