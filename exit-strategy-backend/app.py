from flask import Flask, request, jsonify
from twilio.rest import Client
import os
from datetime import datetime, timedelta
import time
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load environment variables
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.environ.get('TWILIO_AUTH_TOKEN')
TWILIO_PHONE_NUMBER = os.environ.get('TWILIO_PHONE_NUMBER')
API_KEY = os.environ.get('API_KEY')

# Default templates for free tier
DEFAULT_TEMPLATES = [
    {
        "id": "template_1",
        "title": "Emergency Call",
        "message": "I need you to come home right away. It's an emergency.",
        "isPremium": False,
        "isCustom": False
    },
    {
        "id": "template_2",
        "title": "Work Emergency",
        "message": "Your boss called. There's an urgent issue at work that needs your attention immediately.",
        "isPremium": False,
        "isCustom": False
    },
    {
        "id": "template_3",
        "title": "Family Emergency",
        "message": "Please call me as soon as possible. There's a family emergency.",
        "isPremium": False,
        "isCustom": False
    }
]

# Validate API key
def validate_api_key(request):
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return False
    
    try:
        # Extract token from "Bearer <token>"
        token = auth_header.split(' ')[1]
        return token == API_KEY
    except:
        return False

# Validate request data
def validate_request(data):
    if not data:
        return False, "No data provided"
    
    if 'message' not in data:
        return False, "No message provided"
    
    if 'user_phone' not in data:
        return False, "No user phone number provided"
    
    return True, ""

# Send SMS via Twilio
def send_sms(to_number, message, from_number=TWILIO_PHONE_NUMBER):
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        message = client.messages.create(
            body=message,
            from_=from_number,
            to=to_number
        )
        return True, message.sid
    except Exception as e:
        return False, str(e)

# Make call via Twilio
def make_call(to_number, message, from_number=TWILIO_PHONE_NUMBER):
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        # In a real implementation, we would use TwiML to create a voice message
        # For now, we'll just simulate a call
        call = client.calls.create(
            twiml=f'<Response><Say>{message}</Say></Response>',
            from_=from_number,
            to=to_number
        )
        return True, call.sid
    except Exception as e:
        return False, str(e)

@app.route('/send-rescue', methods=['POST'])
def send_rescue():
    # Validate API key
    if not validate_api_key(request):
        return jsonify({
            'success': False,
            'message': 'Unauthorized'
        }), 401
    
    # Get request data
    data = request.get_json()
    
    # Validate request data
    valid, error_message = validate_request(data)
    if not valid:
        return jsonify({
            'success': False,
            'message': error_message
        }), 400
    
    # Extract data
    message = data.get('message')
    user_phone = data.get('user_phone')
    delay_minutes = int(data.get('delay_minutes', 0))
    is_call = data.get('is_call', False)
    
    # Check if this is a premium feature (delayed rescue)
    is_premium_request = delay_minutes > 0
    is_premium_user = data.get('is_premium', False)
    
    if is_premium_request and not is_premium_user:
        return jsonify({
            'success': False,
            'message': 'Premium feature requested by non-premium user'
        }), 403
    
    # Handle delayed rescue
    if delay_minutes > 0:
        # In a real implementation, we would use a task queue
        # For this demo, we'll just return success
        return jsonify({
            'success': True,
            'message': f'Rescue scheduled in {delay_minutes} minutes',
            'rescue_id': f'scheduled_{int(time.time())}'
        })
    
    # Send immediate rescue
    if is_call:
        success, result = make_call(user_phone, message)
    else:
        success, result = send_sms(user_phone, message)
    
    if success:
        return jsonify({
            'success': True,
            'message': 'Rescue sent successfully',
            'rescue_id': result
        })
    else:
        return jsonify({
            'success': False,
            'message': f'Failed to send rescue: {result}'
        }), 500

@app.route('/templates', methods=['GET'])
def get_templates():
    # Validate API key
    if not validate_api_key(request):
        return jsonify({
            'success': False,
            'message': 'Unauthorized'
        }), 401
    
    # In a real implementation, we would fetch templates from a database
    # For this demo, we'll just return the default templates
    return jsonify({
        'success': True,
        'templates': DEFAULT_TEMPLATES
    })

@app.route('/verify-subscription', methods=['POST'])
def verify_subscription():
    # Validate API key
    if not validate_api_key(request):
        return jsonify({
            'success': False,
            'message': 'Unauthorized'
        }), 401
    
    # Get request data
    data = request.get_json()
    
    # In a real implementation, we would verify the subscription with a payment provider
    # For this demo, we'll just return success
    return jsonify({
        'success': True,
        'is_premium': data.get('subscription_id') == 'exit_strategy_premium',
        'expiration_date': (datetime.now() + timedelta(days=30)).isoformat()
    })

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat()
    })

# For local development
if __name__ == '__main__':
    app.run(debug=True)