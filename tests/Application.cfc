/**
 * Standalone Test Application.cfc - does not extend main app to avoid framework issues
 */
component {

    // sets datasource to a test database
    this.datasource = "dtb_clipping_test";
    this.test_datasource = "dtb_clipping_test"; // same as main Application.cfc
    this.name = "clipping_test_app";
    this.sessionManagement = false;
    this.ormEnabled = true;
    
    this.ormsettings = {
        dbcreate="update", // update database tables only
        cfclocation="../home/model/beans",
        dialect="MySQL8",         // MySQL 8.x dialect - change to MySQL5 if using MySQL 5.x
        logsql="true",
        flushAtRequestEnd = false
    };

    this.triggerDataMember = true; // so we can access properties directly (no need for getters and setters)

    // Basic mappings for tests
    this.mappings["/root"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/..";
    this.mappings["/testbox"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/../testbox";
    this.mappings["/lib"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/../lib";

    function onApplicationStart() {
        application.datasource = this.datasource;
        application.recordsPerPage = 12; // pagination setting, used in all services and tests
        
        // include UDF functions - same as main Application.cfc
        application.UDFs = createObject("component", "lib.functions");
        
        // settings used in tests - same as main Application.cfc
        application.test_datasource = this.test_datasource;
        // application.testsRootMapping = "/clipping/tests/specs";
        application.testsRootMapping = "/tests/specs";
        // application.testsBrowseURL = "http://" & CGI.HTTP_HOST & "/clipping";
        application.testsBrowseURL = "http://" & CGI.HTTP_HOST;
        
        return true;
    }

}
