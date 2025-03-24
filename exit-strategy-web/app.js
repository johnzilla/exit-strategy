// Exit Strategy App - Main JavaScript

// Configuration will be loaded from config.js
const API_URL = window.CONFIG?.api?.baseUrl || '/api';
const DEFAULT_TEMPLATES = window.CONFIG?.app?.defaultTemplates || {
    emergency: "Emergency! Call me ASAP!",
    ride: "Can you pick me up? I need a ride.",
    reminder: "Don't forget our plans today!"
};

// DOM Elements
const setupForm = document.getElementById('setup-form');
const contactNameInput = document.getElementById('contact-name');
const phoneNumberInput = document.getElementById('phone-number');
const triggerRescueBtn = document.getElementById('trigger-rescue');
const upgradeBtn = document.getElementById('upgrade-btn');
const notification = document.getElementById('notification');
const notificationMessage = document.getElementById('notification-message');
const notificationClose = document.getElementById('notification-close');

// State Management
let appState = {
    contactName: localStorage.getItem('contactName') || '',
    phoneNumber: localStorage.getItem('phoneNumber') || '',
    isPremium: localStorage.getItem('isPremium') === 'true' || false,
    selectedTemplate: 'emergency'
};

// Initialize the app
function initApp() {
    // Load saved data
    if (appState.contactName && appState.phoneNumber) {
        contactNameInput.value = appState.contactName;
        phoneNumberInput.value = appState.phoneNumber;
    }

    // Set up event listeners
    setupForm.addEventListener('submit', handleSetupSubmit);
    triggerRescueBtn.addEventListener('click', handleRescueTrigger);
    upgradeBtn.addEventListener('click', handleUpgrade);
    notificationClose.addEventListener('click', hideNotification);

    // Set up template selection
    document.querySelectorAll('input[name="template"]').forEach(radio => {
        radio.addEventListener('change', (e) => {
            appState.selectedTemplate = e.target.value;
        });
    });

    // Update UI based on state
    updateUI();
}

// Update UI based on current state
function updateUI() {
    // Update rescue button state
    triggerRescueBtn.disabled = !(appState.contactName && appState.phoneNumber);
    
    // Update premium section
    if (appState.isPremium) {
        document.getElementById('premium-section').innerHTML = `
            <h2>Premium Features (Active)</h2>
            <div class="form-group">
                <label for="custom-message">Custom Message</label>
                <input type="text" id="custom-message" placeholder="Enter your custom rescue message">
            </div>
            <div class="form-group">
                <label for="delay-time">Delay (minutes)</label>
                <input type="number" id="delay-time" min="1" max="60" value="5">
            </div>
        `;
    }
}

// Handle setup form submission
function handleSetupSubmit(e) {
    e.preventDefault();
    
    const contactName = contactNameInput.value.trim();
    const phoneNumber = phoneNumberInput.value.trim();
    
    if (!contactName || !phoneNumber) {
        showNotification('Please fill in all fields', 'error');
        return;
    }
    
    // Validate phone number format
    if (!isValidPhoneNumber(phoneNumber)) {
        showNotification('Please enter a valid phone number (e.g., +1234567890)', 'error');
        return;
    }
    
    // Save to state and localStorage
    appState.contactName = contactName;
    appState.phoneNumber = phoneNumber;
    localStorage.setItem('contactName', contactName);
    localStorage.setItem('phoneNumber', phoneNumber);
    
    showNotification('Contact information saved!', 'success');
    updateUI();
}

// Handle rescue trigger
function handleRescueTrigger() {
    if (!appState.contactName || !appState.phoneNumber) {
        showNotification('Please set up your contact information first', 'error');
        return;
    }
    
    // Get message content
    let messageContent = DEFAULT_TEMPLATES[appState.selectedTemplate];
    let delayMinutes = 0;
    
    // For premium users, check for custom message and delay
    if (appState.isPremium) {
        const customMessageInput = document.getElementById('custom-message');
        const delayTimeInput = document.getElementById('delay-time');
        
        if (customMessageInput && customMessageInput.value.trim()) {
            messageContent = customMessageInput.value.trim();
        }
        
        if (delayTimeInput && !isNaN(delayTimeInput.value)) {
            delayMinutes = parseInt(delayTimeInput.value, 10);
        }
    }
    
    // Prepare request data
    const rescueData = {
        phone_number: appState.phoneNumber,
        contact_name: appState.contactName,
        message: messageContent,
        delay_minutes: delayMinutes
    };
    
    // Show loading state
    triggerRescueBtn.disabled = true;
    triggerRescueBtn.textContent = 'Sending...';
    
    // Send request to backend
    sendRescueRequest(rescueData)
        .then(response => {
            showNotification('Rescue triggered successfully!', 'success');
            triggerRescueBtn.textContent = 'Trigger Rescue Now';
            triggerRescueBtn.disabled = false;
        })
        .catch(error => {
            showNotification('Error: ' + (error.message || 'Failed to trigger rescue'), 'error');
            triggerRescueBtn.textContent = 'Trigger Rescue Now';
            triggerRescueBtn.disabled = false;
        });
}

// Handle premium upgrade
function handleUpgrade() {
    // In a real app, this would open a payment flow
    // For demo purposes, we'll just toggle the premium status
    appState.isPremium = !appState.isPremium;
    localStorage.setItem('isPremium', appState.isPremium);
    
    if (appState.isPremium) {
        showNotification('Upgraded to premium!', 'success');
    } else {
        showNotification('Downgraded to free tier', 'success');
    }
    
    updateUI();
}

// API Functions
async function sendRescueRequest(data) {
    try {
        // Use the API client from api.js
        return await window.api.sendRescue(data);
    } catch (error) {
        console.error('Error sending rescue:', error);
        throw error;
    }
}

// Utility Functions
function showNotification(message, type = 'success') {
    notificationMessage.textContent = message;
    notification.className = `notification ${type}`;
    
    // Auto-hide after 5 seconds
    setTimeout(hideNotification, 5000);
}

function hideNotification() {
    notification.className = 'notification hidden';
}

function isValidPhoneNumber(phoneNumber) {
    // Basic validation for international format: +[country code][number]
    return /^\+\d{1,3}\d{6,14}$/.test(phoneNumber);
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', initApp);