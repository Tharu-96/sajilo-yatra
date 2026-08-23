import requests
import uuid

base_url = "https://sajilo-yatra-api.onrender.com/api"

def test_feedback():
    # 1. Register a test user
    email = f"test_{uuid.uuid4().hex[:8]}@example.com"
    password = "testpassword123"
    
    print(f"Registering user {email}...")
    resp = requests.post(f"{base_url}/auth/register", json={
        "name": "Test User",
        "email": email,
        "password": password
    })
    
    if resp.status_code != 201:
        print("Registration failed:", resp.status_code, resp.text)
        return
        
    token = resp.json().get("access_token")
    print("User registered. Got token.")
    
    # 2. Send feedback
    print("Sending feedback...")
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    feedback_data = {
        "subject": "Test Feedback from AI Agent",
        "message": "This is a test to verify the feedback endpoint works."
    }
    
    resp2 = requests.post(f"{base_url}/feedback", json=feedback_data, headers=headers)
    
    print(f"Feedback response status: {resp2.status_code}")
    print(f"Feedback response body: {resp2.text}")

if __name__ == "__main__":
    test_feedback()
