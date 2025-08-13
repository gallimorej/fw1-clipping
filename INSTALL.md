# Installation Guide: ColdFusion FW/1 App on Lucee

This guide will walk you through setting up this ColdFusion FW/1 application to run on Lucee from scratch.

## Prerequisites

- macOS (this guide is written for macOS, but can be adapted for other systems)
- Terminal access
- Internet connection

## Step 1: Install Homebrew (if not already installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Step 2: Install Java

```bash
brew install openjdk
```

## Step 3: Install CommandBox

CommandBox is a CFML package manager that makes it easy to install and manage Lucee and other CFML tools.

```bash
brew install commandbox
```

Verify installation:
```bash
box version
```

## Step 4: Install Lucee

Install the latest stable Lucee CFML engine through CommandBox:

```bash
box install lucee@6.2.2.91
```

**Note**: This application is configured to use Lucee 6.2.2.91, which is the latest stable version as of this installation guide. This version provides improved performance, security updates, and new features compared to previous versions.

## Step 5: Install FW/1 Framework

Install the FW/1 MVC framework that this application extends:

```bash
box install fw1
```

## Step 6: Install ORM Extension

Install the Hibernate ORM extension for Lucee (this provides the ORM engine that Lucee needs):

```bash
box install "D062D72F-F8A2-46F0-8CBC91325B2F067B"
```

**Note**: This installs the "Ortus ORM Extension" which is a Hibernate ORM wrapper for CFML. Your application uses Lucee's built-in ORM with MySQL dialect, but Lucee needs this extension to provide the ORM engine.

## Step 7: Install MySQL

Install MySQL database server:

```bash
brew install mysql
```

Start MySQL service:
```bash
brew services start mysql
```

## Step 8: Create Databases

Create the required databases using the provided SQL script:

```bash
mysql -u root < setup/create_databases.sql
```

Verify databases were created:
```bash
mysql -u root -e "SHOW DATABASES;"
```

You should see both `dtb_clipping` and `dtb_clipping_test` in the list.

## Step 9: Install CFConfig

Install CFConfig CLI for managing Lucee configuration:

```bash
box install commandbox-cfconfig
```

## Step 10: Configure Datasources

Create a `.cfconfig.json` file in your project root with the following content:

```json
{
  "datasources": {
    "dtb_clipping": {
      "dbdriver": "MySQL",
      "host": "localhost",
      "port": "3306",
      "database": "dtb_clipping",
      "username": "root",
      "password": "",
      "connectionLimit": 10,
      "connectionTimeout": 1,
      "maxPooledStatements": 100
    },
    "dtb_clipping_test": {
      "dbdriver": "MySQL",
      "host": "localhost",
      "port": "3306",
      "database": "dtb_clipping_test",
      "username": "root",
      "password": "",
      "connectionLimit": 10,
      "connectionTimeout": 1,
      "maxPooledStatements": 100
    }
  },
  "this": {
    "datasource": "dtb_clipping",
    "ormEnabled": true,
    "ormSettings": {
      "dbcreate": "update",
      "dialect": "MySQL",
      "eventhandling": false,
      "eventhandler": "root.home.model.beans.eventhandler",
      "logsql": true,
      "flushAtRequestEnd": false
    }
  }
}
```

## Step 11: Start Lucee Server

Navigate to your project directory and start the Lucee server:

```bash
cd /path/to/your/fw1-clipping-project
box server start cfengine=lucee@6.2.2.91
```

**Note**: The `cfengine` parameter ensures the server starts with the correct Lucee version. This is important for consistency across different development environments.

## Step 12: Apply Configuration

Import the datasource configuration to Lucee:

```bash
box cfconfig import .cfconfig.json
```

## Step 13: Restart Server

Stop and restart the server to load the new configuration:

```bash
box server stop
box server start cfengine=lucee@6.2.2.91
```

**Note**: Always specify the `cfengine` parameter when restarting to maintain the correct Lucee version.

## Step 14: Verify Installation

Check server status:
```bash
box server status
```

You should see output similar to:
```
fw1-clipping (running)  http://127.0.0.1:XXXXX
  Listeners:
    - HTTP
      - 127.0.0.1:XXXXX

  CF Engine: lucee 6.2.2+91
```

**Note**: The CF Engine should show `lucee 6.2.2+91` indicating you're running the latest stable version.

## Step 15: Access Your Application

Open your web browser and navigate to the URL shown in the server status (typically `http://127.0.0.1:XXXXX`).

## Step 16: Verify Lucee Version

You can also verify the Lucee version through the server configuration:

```bash
box server show
```

This will display detailed server information including the exact Lucee version and configuration.

## Troubleshooting

### Common Issues

1. **ORM Engine Not Installed**
   - Ensure you've installed the Hibernate ORM extension: `box install "D062D72F-F8A2-46F0-8CBC91325B2F067B"`
   - This provides the ORM engine that Lucee needs to run ORM-enabled applications

2. **Datasource Not Found**
   - Verify MySQL is running: `brew services list | grep mysql`
   - Check database exists: `mysql -u root -e "SHOW DATABASES;"`
   - Ensure CFConfig was imported: `box cfconfig import .cfconfig.json`

3. **Port Already in Use**
   - Stop any existing servers: `box server stop`
   - Check for conflicting processes: `lsof -i :XXXXX`

4. **Java Version Issues**
   - Ensure Java 8+ is installed: `java -version`
   - Set JAVA_HOME if needed: `export JAVA_HOME=/usr/local/opt/openjdk`

5. **Test Application Variables Missing**
   - If you get "key [RECORDSPERPAGE] doesn't exist": Ensure `tests/Application.cfc` sets `application.recordsPerPage`
   - If you get "key [UDFS] doesn't exist": Ensure `tests/Application.cfc` sets `application.UDFs`
   - Verify the test Application.cfc has proper mappings for `/lib` and `/root` directories
   - Check that `tests/Application.cfc` includes all required application variables

6. **Test Database Issues**
   - Ensure the test database `dtb_clipping_test` exists
   - Verify the test Application.cfc uses the correct datasource
   - Check that ORM settings in test Application.cfc point to the correct bean location

### Useful Commands

```bash
# Check server status
box server status

# Stop server
box server stop

# Start server with specific Lucee version
box server start cfengine=lucee@6.2.2.91

# View server logs
box server log

# Check CommandBox packages
box list

# Update CommandBox
box update

# Show detailed server configuration
box server show
```

## File Structure

After installation, your project should have:

```
fw1-clipping/
├── .cfconfig.json          # Lucee configuration
├── Application.cfc          # Main application file
├── home/                    # FW/1 home subsystem
├── lib/                     # Utility functions
├── setup/                   # Database scripts
├── static/                  # CSS, JS, images
└── tests/                   # Test specifications
```

## Application Components

### Utility Functions (lib/functions.cfc)
The application includes a comprehensive set of utility functions accessible via `application.UDFs`:
- **stripHTML()** - Removes HTML tags from strings
- **safetext()** - Sanitizes HTML content for safe display
- **prepara_string()** - Prepares strings for database storage
- **abortOnCSRFAttack()** - CSRF protection for forms

### Application Variables
The main Application.cfc sets several critical variables:
- `application.recordsPerPage` - Pagination setting (default: 12)
- `application.UDFs` - Utility functions component
- `application.datasource` - Main database connection
- `application.test_datasource` - Test database connection

### Test Configuration
Tests use a separate Application.cfc (`tests/Application.cfc`) that:
- Inherits no framework dependencies to avoid conflicts
- Sets up test-specific database connections
- Initializes all required application variables
- Provides proper mappings for test components

## Database Configuration

- **Main Database**: `dtb_clipping`
- **Test Database**: `dtb_clipping_test`
- **Username**: `root`
- **Password**: (none set)
- **Host**: `localhost`
- **Port**: `3306`

## Next Steps

Once your application is running:

1. **Test the application** by navigating through different pages
2. **Run tests** using the TestBox framework included in the project
3. **Customize configuration** in `Application.cfc` as needed
4. **Add data** to your clipping database

## Running Tests

This project includes a comprehensive test suite using TestBox. To run tests:

### Test Configuration
The project uses a separate test Application.cfc (`tests/Application.cfc`) that:
- Uses the test database (`dtb_clipping_test`)
- Sets required application variables for testing
- Includes UDF functions and pagination settings

### Running Tests
Access the test runner through your browser:
```
http://127.0.0.1:XXXXX/testbox/cfml/runner/
```

Or run specific test bundles:
```
http://127.0.0.1:XXXXX/testbox/cfml/runner/?bundles=tests.specs.Test_4_Services_and_Testing_Database
```

### Test Requirements
Tests require the following application variables to be properly set:
- `application.recordsPerPage` - Pagination setting (default: 12)
- `application.UDFs` - Utility functions component
- `application.datasource` - Test database connection
- `application.test_datasource` - Test database reference

**Note**: If you encounter errors like "key [RECORDSPERPAGE] doesn't exist" or "key [UDFS] doesn't exist", ensure the test Application.cfc is properly configured with all required variables.

## Lucee 6.x Features

This application now runs on Lucee 6.2.2.91, which includes:

- **Improved Performance**: Better memory management and faster execution
- **Enhanced Security**: Latest security patches and improvements
- **Modern Java Support**: Compatible with Java 8+ (tested with Java 24)
- **Better ORM Support**: Enhanced Hibernate integration
- **Updated Language Features**: Latest CFML language enhancements

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Check server logs: `box server log`
4. Ensure all dependencies are installed: `box list`

---

**Note**: This guide assumes a clean macOS installation. Adjust paths and commands for your specific operating system if needed.

## Version History

- **2025-08-13**: Updated to Lucee 6.2.2.91 (latest stable version)
- **2025-08-13**: Fixed test configuration issues - added missing application variables and UDFs support
- **Previous**: Lucee 5.4.6.9
