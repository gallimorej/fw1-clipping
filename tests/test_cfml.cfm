<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html>
<head>
    <title>CFML Test</title>
</head>
<body>
    <h1>CFML Processing Test</h1>
    
    <p><strong>Current Time:</strong> #now()#</p>
    <p><strong>Server Software:</strong> #server.coldfusion.productname#</p>
    <p><strong>Server Version:</strong> #server.coldfusion.productversion#</p>
    
    <cfset testVar = "Hello from CFML!">
    <p><strong>Test Variable:</strong> #testVar#</p>
    
    <cfdirectory action="list" directory="." name="dirList" filter="*.cfc">
    <p><strong>Files in current directory:</strong></p>
    <ul>
        <cfloop query="dirList">
            <li>#dirList.name#</li>
        </cfloop>
    </ul>
</body>
</html>
