<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Basic TestBox Test Runner</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-item { margin: 10px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9; }
        .test-item h3 { margin: 0 0 10px 0; color: #333; }
        .test-item a { display: inline-block; background: #007cba; color: white; padding: 8px 16px; text-decoration: none; border-radius: 4px; margin-right: 10px; }
        .test-item a:hover { background: #005a87; }
        .run-all { background: #28a745; color: white; padding: 12px 24px; border: none; border-radius: 5px; cursor: pointer; margin-bottom: 20px; font-size: 16px; }
        .run-all:hover { background: #218838; }
        .header { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>TestBox Test Runner</h1>
        <p>This page provides access to all your TestBox tests. You can run individual tests or use the links below.</p>
    </div>
    
    <button class="run-all" onclick="runAllTests()">Run All Tests (Opens in new tabs)</button>
    
    <h2>Available Test Files</h2>
    
    <cfdirectory action="list" directory="specs" name="testFiles" filter="*.cfc">
    
    <cfloop query="testFiles">
        <cfif testFiles.name neq "Application.cfc">
            <div class="test-item">
                <h3>#testFiles.name#</h3>
                <p>Run this test file individually:</p>
                <a href="specs/#testFiles.name#?method=runRemote" target="_blank">Run Test</a>
                <a href="specs/#testFiles.name#?method=runRemote&format=json" target="_blank">Run as JSON</a>
            </div>
        </cfif>
    </cfloop>
    
    <script>
        function runAllTests() {
            // Get all test links and open them in new tabs
            var testLinks = document.querySelectorAll('a[href*="method=runRemote"]');
            testLinks.forEach(function(link, index) {
                if (index % 2 === 0) { // Only open every other link to avoid too many tabs
                    setTimeout(function() {
                        window.open(link.href, '_blank');
                    }, index * 500); // Stagger the opening
                }
            });
        }
    </script>
</body>
</html>
