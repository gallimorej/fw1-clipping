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

Install the Lucee CFML engine through CommandBox:

```bash
box install lucee
```

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
box server start
```

## Step 12: Apply Configuration

Import the datasource configuration to Lucee:

```bash
box cfconfig import .cfconfig.json
```

## Step 13: Restart Server

Stop and restart the server to load the new configuration:

```bash
box server stop
box server start
```

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

  CF Engine: lucee 5.4.6+9
```

## Step 15: Access Your Application

Open your web browser and navigate to the URL shown in the server status (typically `http://127.0.0.1:XXXXX`).

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

### Useful Commands

```bash
# Check server status
box server status

# Stop server
box server stop

# Start server
box server start

# View server logs
box server log

# Check CommandBox packages
box list

# Update CommandBox
box update
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

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Check server logs: `box server log`
4. Ensure all dependencies are installed: `box list`

---

**Note**: This guide assumes a clean macOS installation. Adjust paths and commands for your specific operating system if needed.
