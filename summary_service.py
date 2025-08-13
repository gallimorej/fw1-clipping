#!/usr/bin/env python3
"""
Simple Summary Service for Testing
This provides the /ajax_resumo endpoint that the Selenium tests expect
"""

from flask import Flask, request, jsonify
import re

app = Flask(__name__)

@app.route('/ajax_resumo', methods=['POST'])
def ajax_resumo():
    """Handle summary requests"""
    try:
        # Get the text from the form data
        texto = request.form.get('texto', '')
        
        if not texto:
            return jsonify({'error': 'No text provided'}), 400
        
        # Simple text summarization (just take first 100 characters)
        # In a real implementation, this would use NLP or AI summarization
        summary = texto[:100] + "..." if len(texto) > 100 else texto
        
        # Clean up HTML tags for summary
        summary = re.sub(r'<[^>]+>', '', summary)
        
        return jsonify({
            'summary': summary,
            'original_length': len(texto),
            'summary_length': len(summary)
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'service': 'summary-service'})

if __name__ == '__main__':
    print("Starting Summary Service on port 5001...")
    print("Available endpoints:")
    print("  POST /ajax_resumo - Summarize text")
    print("  GET  /health      - Health check")
    print("\nTo stop the service, press Ctrl+C")
    
    app.run(host='0.0.0.0', port=5001, debug=True)
