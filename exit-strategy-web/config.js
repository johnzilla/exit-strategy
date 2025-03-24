// Exit Strategy Configuration

const CONFIG = {
    // API configuration
    api: {
        // Base URL for the backend API
        // Change this to match your backend deployment
        baseUrl: '/api',
        
        // Endpoints
        endpoints: {
            sendRescue: '/send-rescue'
        }
    },
    
    // App configuration
    app: {
        // Default templates for rescue messages
        defaultTemplates: {
            emergency: "Emergency! Call me ASAP!",
            ride: "Can you pick me up? I need a ride.",
            reminder: "Don't forget our plans today!"
        },
        
        // Premium features configuration
        premium: {
            price: "$10/month",
            features: [
                "Custom rescue messages",
                "Delayed rescues (up to 60 minutes)",
                "Priority support"
            ]
        }
    }
};

// Export the configuration
if (typeof module !== 'undefined' && module.exports) {
    module.exports = CONFIG;
} else {
    // For browser usage
    window.CONFIG = CONFIG;
}