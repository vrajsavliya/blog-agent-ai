import os
import requests

url = "https://integrate.api.nvidia.com/v1/chat/completions"
headers = {
    "Authorization": "Bearer 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",
    "Content-Type": "application/json"
}
data = {
    "model": "deepseek-ai/deepseek-v4-pro",
    "messages": [{"role": "user", "content": "Return JSON {\"a\":1}"}]
}

response = requests.post(url, headers=headers, json=data)
print("Status:", response.status_code)
try:
    print(response.json())
except:
    pass
