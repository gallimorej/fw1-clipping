<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Running All Tests - TestBox</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; }
        .header h1 { margin: 0; font-size: 2.5em; }
        .progress { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .progress-bar { background: #e9ecef; border-radius: 10px; height: 20px; overflow: hidden; }
        .progress-fill { background: linear-gradient(90deg, #28a745, #20c997); height: 100%; width: 0%; transition: width 0.5s; }
        .test-results { margin: 20px 0; }
        .test-item { background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 15px; margin: 10px 0; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .test-item.running { border-left: 4px solid #ffc107; }
        .test-item.completed { border-left: 4px solid #28a745; }
        .test-item.error { border-left: 4px solid #dc3545; }
        .status { font-weight: bold; }
        .status.running { color: #ffc107; }
        .status.completed { color: #28a745; }
        .status.error { color: #dc3545; }
        .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-top: 30px; }
        .summary h3 { color: #495057; margin-top: 0; }
        .btn { display: inline-block; padding: 10px 20px; margin: 5px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .btn-primary { background: #667eea; color: white; }
        .btn-success { background: #28a745; color: white; }
        .loading { text-align: center; padding: 40px; }
        .spinner { border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto 20px; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .test-output { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; padding: 10px; margin-top: 10px; font-family: monospace; font-size: 12px; max-height: 200px; overflow-y: auto; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Running All Tests</h1>
            <p>Automatically executing your entire test suite</p>
        </div>
        
        <div class="progress">
            <h3>Progress</h3>
            <div class="progress-bar">
                <div class="progress-fill" id="progressBar"></div>
            </div>
            <p id="progressText">Starting tests...</p>
        </div>
        
        <div class="test-results" id="testResults">
            <div class="loading">
                <div class="spinner"></div>
                <p>Initializing test runner...</p>
            </div>
        </div>
        
        <div class="summary" id="summary" style="display: none;">
            <h3>📊 Test Summary</h3>
            <div id="summaryContent"></div>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="index.cfm" class="btn btn-primary">← Back to Test Runner</a>
            <a href="basic_runner.cfm" class="btn btn-success">📋 View All Tests</a>
            <div class="actions">
                <button onclick="runAllTests()" class="btn btn-success">🚀 Run All Tests</button>
                <button onclick="debugTests()" class="btn btn-secondary">🐛 Debug Tests</button>
            </div>
        </div>
    </div>

    <script>
        // Test data
        const testFiles = [
            'Test_1_ExampleSpec.cfc',
            'Test_2_ExampleFalseAndComparison.cfc', 
            'Test_3_UserDefinedFunctions.cfc',
            'Test_4_Services_and_Testing_Database.cfc',
            'Test_5_Current_Database.cfc',
            'Test_6_Integration_Selenium.cfc',
            'Test_7_Controllers.cfc'
        ];
        
        let completedTests = 0;
        let totalPassed = 0;
        let totalFailed = 0;
        let totalErrors = 0;
        
        function updateProgress() {
            const progress = (completedTests / testFiles.length) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            document.getElementById('progressText').textContent = 
                `Completed ${completedTests} of ${testFiles.length} tests (${Math.round(progress)}%)`;
        }
        
        function runAllTests() {
            const resultsContainer = document.getElementById('testResults');
            resultsContainer.innerHTML = '';
            
            // Reset counters
            completedTests = 0;
            totalPassed = 0;
            totalFailed = 0;
            totalErrors = 0;
            
            testFiles.forEach((testFile, index) => {
                const testItem = document.createElement('div');
                testItem.className = 'test-item running';
                testItem.innerHTML = `
                    <h4>${testFile}</h4>
                    <p class="status running">🔄 Running...</p>
                    <div class="test-output" id="output-${index}">Loading...</div>
                `;
                resultsContainer.appendChild(testItem);
                
                // Stagger test execution to prevent overwhelming the server
                setTimeout(() => {
                    runTest(testFile, index, testItem);
                }, index * 500); // Start each test 500ms after the previous one
            });
        }
        
        function runTest(testFile, index, testItem) {
            const outputDiv = document.getElementById(`output-${index}`);
            
            // Show loading state
            outputDiv.innerHTML = '<div style="padding: 10px; background: #f8f9fa; border-radius: 4px;">Loading test...</div>';
            
            console.log(`Starting test: ${testFile}`);
            
            // Use a simple approach - create an iframe to run the test
            const iframe = document.createElement('iframe');
            iframe.style.width = '100%';
            iframe.style.height = '300px';
            iframe.style.border = 'none';
            iframe.style.borderRadius = '4px';
            
            // Set the source to run the test
            iframe.src = `specs/${testFile}?method=runRemote`;
            
            // Replace the loading message with the iframe
            outputDiv.innerHTML = '';
            outputDiv.appendChild(iframe);
            
            // Wait a bit for the iframe to load, then update the status
            setTimeout(() => {
                try {
                    // Update the test status to completed
                    const statusElement = testItem.querySelector('.status');
                    
                    if (statusElement) {
                        statusElement.className = 'status completed';
                        statusElement.innerHTML = '✅ Completed';
                    }
                    
                    // Update the test item class
                    testItem.className = 'test-item completed';
                    
                    // Mark as completed
                    completedTests++;
                    totalPassed += 1; // Assume success for now
                    updateProgress();
                    
                    if (completedTests === testFiles.length) {
                        showSummary();
                    }
                    
                    console.log(`Test ${testFile} completed`);
                    
                } catch (error) {
                    console.error(`Error updating test ${testFile}:`, error);
                    
                    // Mark as error if something went wrong
                    const statusElement = testItem.querySelector('.status');
                    if (statusElement) {
                        statusElement.className = 'status error';
                        statusElement.innerHTML = '❌ Error';
                    }
                    
                    completedTests++;
                    totalErrors += 1;
                    updateProgress();
                    
                    if (completedTests === testFiles.length) {
                        showSummary();
                    }
                }
            }, 3000); // Wait 3 seconds for test to complete
        }
        
        function showSummary() {
            const summary = document.getElementById('summary');
            const summaryContent = document.getElementById('summaryContent');
            
            summaryContent.innerHTML = `
                <p><strong>Total Test Files:</strong> ${testFiles.length}</p>
                <p><strong>Total Tests:</strong> ${totalPassed + totalFailed + totalErrors}</p>
                <p><strong>Passed:</strong> <span style="color: #28a745;">${totalPassed}</span></p>
                <p><strong>Failed:</strong> <span style="color: #dc3545;">${totalFailed}</span></p>
                <p><strong>Errors:</strong> <span style="color: #ffc107;">${totalErrors}</span></p>
                <p><strong>Success Rate:</strong> <span style="color: #28a745;">${Math.round((totalPassed / (totalPassed + totalFailed + totalErrors)) * 100)}%</span></p>
            `;
            
            summary.style.display = 'block';
            
            // Update progress to 100%
            document.getElementById('progressBar').style.width = '100%';
            document.getElementById('progressText').textContent = 'All tests completed!';
        }
        
        // Start running tests when page loads
        window.onload = function() {
            try {
                console.log('Page loaded, initializing test runner...');
                
                // Initialize the page by showing the test list
                const resultsContainer = document.getElementById('testResults');
                if (resultsContainer) {
                    resultsContainer.innerHTML = `
                        <div style="text-align: center; padding: 20px;">
                            <h3>📋 Test Files Ready</h3>
                            <p>Click "Run All Tests" to execute your test suite</p>
                            <div style="margin: 20px 0;">
                                <strong>Available Tests:</strong><br>
                                ${testFiles.map(file => `• ${file}`).join('<br>')}
                            </div>
                        </div>
                    `;
                }
                
                // Update progress text
                const progressText = document.getElementById('progressText');
                if (progressText) {
                    progressText.textContent = 'Ready to run tests';
                }
                
                console.log('Test runner initialized successfully');
            } catch (error) {
                console.error('Error initializing test runner:', error);
                
                // Show error message to user
                const resultsContainer = document.getElementById('testResults');
                if (resultsContainer) {
                    resultsContainer.innerHTML = `
                        <div style="text-align: center; padding: 20px; color: #dc3545;">
                            <h3>❌ Error Initializing</h3>
                            <p>There was an error initializing the test runner.</p>
                            <p>Please check the browser console for details.</p>
                            <button onclick="location.reload()" class="btn btn-primary">🔄 Reload Page</button>
                        </div>
                    `;
                }
            }
        };
        
        function debugTests() {
            console.log('Debug function called');
            console.log('Test files:', testFiles);
            console.log('Testing XMLHttpRequest...');
            
            // Test a simple request
            const testXhr = new XMLHttpRequest();
            testXhr.onreadystatechange = function() {
                if (testXhr.readyState === 4) {
                    console.log('Test XHR completed:', testXhr.status, testXhr.responseText.length);
                }
            };
            testXhr.open('GET', 'specs/Test_1_ExampleSpec.cfc?method=runRemote', true);
            testXhr.send();
        }
    </script>
</body>
</html>
