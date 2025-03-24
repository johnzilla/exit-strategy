// Exit Strategy API Integration

/**
 * API client for Exit Strategy backend
 */
class ExitStrategyAPI {
    /**
     * Initialize the API client
     * @param {string} baseUrl - Base URL for the API
     */
    constructor(baseUrl = '/api') {
        this.baseUrl = baseUrl;
    }

    /**
     * Send a rescue request
     * @param {Object} data - Rescue request data
     * @param {string} data.phone_number - User's phone number
     * @param {string} data.contact_name - Contact name to display
     * @param {string} data.message - Message content
     * @param {number} data.delay_minutes - Delay in minutes (0 for immediate)
     * @returns {Promise<Object>} - API response
     */
    async sendRescue(data) {
        try {
            const response = await fetch(`${this.baseUrl}/send-rescue`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });
            
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || 'Failed to send rescue');
            }
            
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    }

    /**
     * Check subscription status (for premium features)
     * @param {string} userId - User ID or phone number
     * @returns {Promise<Object>} - Subscription details
     */
    async checkSubscription(userId) {
        try {
            const response = await fetch(`${this.baseUrl}/subscription-status?userId=${encodeURIComponent(userId)}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || 'Failed to check subscription');
            }
            
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            // For demo purposes, return a default response
            return { isPremium: false };
        }
    }
}

// Create a global API instance using the configuration
const api = new ExitStrategyAPI(window.CONFIG?.api?.baseUrl || '/api');

// Export the API instance
if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
} else {
    // For browser usage
    window.api = api;
}