# Selenium Integration Tests Setup

This guide explains how to set up and run the Selenium integration tests for the clipping application.

## Prerequisites

### 1. Firefox Browser
Firefox is already installed on your system.

### 2. Python Summary Service
The tests expect a Python-based summary service running on port 5001.

## Setup Steps

### Step 1: Install Python Dependencies
```bash
pip3 install -r requirements.txt
```

### Step 2: Start the Summary Service
```bash
python3 summary_service.py
```

This will start the summary service on `http://localhost:5001` with these endpoints:
- `POST /ajax_resumo` - Summarize text (used by tests)
- `GET /health` - Health check

### Step 3: Ensure Your CFML App is Running
Make sure your Lucee server is running:
```bash
box server status
```

If not running, start it:
```bash
box server start cfengine=lucee@6.2.2.91
```

### Step 4: Run the Selenium Tests
Navigate to your test runner:
```
http://127.0.0.1:53559/testbox/cfml/runner/
```

Or run the specific Selenium test:
```
http://127.0.0.1:53559/testbox/cfml/runner/?bundles=tests.specs.Test_6_Integration_Selenium
```

## Current Implementation Status

### ✅ What's Working
- Basic CFSelenium component structure
- Mock implementations of Selenium methods
- Python summary service endpoint
- Test framework integration

### ⚠️ What's Mocked (Not Real Browser Automation)
- Browser interactions are simulated with `writeOutput()`
- Form submissions are not actually processed
- Page navigation is simulated
- Element interactions are mocked

### 🔄 Next Steps for Full Automation
1. **Install Real Selenium WebDriver**:
   ```bash
   pip3 install selenium webdriver-manager
   ```

2. **Update CFSelenium Component** to use real WebDriver
3. **Configure Firefox WebDriver** for automation
4. **Test Real Browser Interactions**

## Troubleshooting

### Summary Service Issues
- Check if port 5001 is available: `lsof -i :5001`
- Verify Python and Flask are installed: `python3 --version && pip3 list | grep Flask`

### CFML App Issues
- Check server status: `box server status`
- Check server logs: `box server log`

### Test Execution Issues
- Ensure both services are running (CFML app + Python service)
- Check browser console for JavaScript errors
- Verify test database is accessible

## Notes

- The current CFSelenium implementation is a mock for testing the test framework
- Real browser automation requires additional setup with WebDriver
- The Python service provides a simple text summarization for testing
- All tests should pass with the current mock implementation
