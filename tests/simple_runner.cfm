<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Simple TestBox Test Runner</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-item { margin: 10px 0; padding: 10px; border: 1px solid #ccc; border-radius: 5px; }
        .test-item a { text-decoration: none; color: #0066cc; font-weight: bold; }
        .test-item a:hover { text-decoration: underline; }
        .run-all { background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin-bottom: 20px; }
        .run-all:hover { background: #45a049; }
    </style>
</head>
<body>
    <h1>TestBox Test Runner</h1>
    
    <button class="run-all" onclick="runAllTests()">Run All Tests</button>
    
    <div id="results"></div>
    
    <h2>Available Test Files:</h2>
    
    <cfdirectory action="list" directory="specs" name="testFiles" filter="*.cfc">
    
    <cfloop query="testFiles">
        <cfif testFiles.name neq "Application.cfc">
            <div class="test-item">
                <a href="specs/#testFiles.name#?method=runRemote" target="_blank">
                    #testFiles.name#
                </a>
                <br>
                <small>Click to run this test file individually</small>
            </div>
        </cfif>
    </cfloop>
    
    <script>
        function runAllTests() {
            const testLinks = document.querySelectorAll('.test-item a');
            const resultsDiv = document.getElementById('results');
            resultsDiv.innerHTML = '<h3>Running all tests...</h3>';
            
            testLinks.forEach((link, index) => {
                setTimeout(() => {
                    const iframe = document.createElement('iframe');
                    iframe.style.width = '100%';
                    iframe.style.height = '400px';
                    iframe.style.border = '1px solid #ccc';
                    iframe.style.marginBottom = '10px';
                    iframe.src = link.href;
                    
                    resultsDiv.appendChild(iframe);
                    
                    if (index === testLinks.length - 1) {
                        resultsDiv.innerHTML += '<h3>All tests completed!</h3>';
                    }
                }, index * 1000); // Run tests with 1 second delay between each
            });
        }
    </script>
</body>
</html>
