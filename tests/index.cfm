<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>TestBox Test Runner</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; }
        .header h1 { margin: 0; font-size: 2.5em; }
        .header p { margin: 10px 0 0 0; opacity: 0.9; }
        .test-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .test-card { background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .test-card:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0,0,0,0.15); }
        .test-card h3 { margin: 0 0 15px 0; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .btn { display: inline-block; padding: 10px 20px; margin: 5px; text-decoration: none; border-radius: 5px; font-weight: bold; transition: all 0.3s; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5a6fd8; transform: translateY(-1px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        .actions { text-align: center; margin: 30px 0; }
        .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-top: 30px; }
        .summary h3 { color: #495057; margin-top: 0; }
        .footer { text-align: center; margin-top: 30px; padding: 20px; color: #6c757d; border-top: 1px solid #e0e0e0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 TestBox Test Runner</h1>
            <p>Run your tests with confidence</p>
        </div>
        
        <div class="actions">
            <a href="run_all.cfm" class="btn btn-success">🚀 Run All Tests</a>
            <a href="basic_runner.cfm" class="btn btn-success">📋 View All Tests</a>
            <a href="simple_runner.cfm" class="btn btn-secondary">⚡ Quick Runner</a>
        </div>
        
        <h2>Available Test Files</h2>
        
        <div class="test-grid">
            <cfdirectory action="list" directory="specs" name="testFiles" filter="*.cfc">
            
            <cfloop query="testFiles">
                <cfif testFiles.name neq "Application.cfc">
                    <cfoutput>
                    <div class="test-card">
                        <h3>#testFiles.name#</h3>
                        <p>Run this test file to check functionality.</p>
                        <a href="specs/#testFiles.name#?method=runRemote" target="_blank" class="btn btn-primary">▶️ Run Test</a>
                        <a href="specs/#testFiles.name#?method=runRemote&format=json" target="_blank" class="btn btn-secondary">📊 JSON Output</a>
                    </div>
                    </cfoutput>
                </cfif>
            </cfloop>
        </div>
        
        <div class="summary">
            <h3>📊 Test Summary</h3>
            <p><strong>Total Test Files:</strong> <cfoutput>#testFiles.recordCount#</cfoutput></p>
            <p><strong>Status:</strong> <span style="color: #28a745;">✅ Ready to run</span></p>
            <p>Click on any test file above to run it individually, or use the action buttons to access different test runners.</p>
        </div>
        
        <div class="footer">
            <p>Powered by TestBox | FW/1 Framework | Lucee Server</p>
            <p><small>Tests are running on port 53559</small></p>
        </div>
    </div>
</body>
</html>
