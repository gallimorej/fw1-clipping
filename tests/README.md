# TestBox Testing Guide

This project uses TestBox for testing. Here are the different ways to run tests:

## 🚀 Quick Start

### 1. Basic Test Runner (Recommended)
Navigate to: `http://127.0.0.1:53559/tests/basic_runner.cfm`

This provides a clean interface to:
- View all available test files
- Run individual tests
- Run all tests at once (opens in new tabs)

### 2. Simple Test Runner
Navigate to: `http://127.0.0.1:53559/tests/simple_runner.cfm`

A basic interface for running tests.

### 3. Individual Test Files
You can run any test file directly by visiting:
`http://127.0.0.1:53559/tests/specs/[TestFileName].cfc?method=runRemote`

For example:
- `http://127.0.0.1:53559/tests/specs/Test_1_ExampleSpec.cfc?method=runRemote`

## 📁 Available Test Files

The following test files are available in the `specs/` directory:

- `Test_1_ExampleSpec.cfc` - Basic example tests
- `Test_2_ExampleFalseAndComparison.cfc` - Comparison tests
- `Test_3_UserDefinedFunctions.cfc` - UDF tests
- `Test_4_Services_and_Testing_Database.cfc` - Service and database tests
- `Test_5_Current_Database.cfc` - Current database tests
- `Test_6_Integration_Selenium.cfc` - Selenium integration tests
- `Test_7_Controllers.cfc` - Controller tests

## 🔧 Test Configuration

### Database Setup
Tests use a separate test database: `dtb_clipping_test`

Make sure this database exists and is accessible. You can create it using:
```sql
CREATE DATABASE `dtb_clipping_test` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### Test Environment
- **Framework**: FW/1 (Framework One)
- **Testing Framework**: TestBox 6.3.2+16
- **Server**: Lucee 5.4.6+9
- **Port**: 53559

## 🐛 Troubleshooting

### If you get a 500 error on `/tests/`
The main test index page has a configuration issue. Use the **Basic Test Runner** instead:
`http://127.0.0.1:53559/tests/basic_runner.cfm`

### If tests fail to connect to database
1. Ensure MySQL is running
2. Verify the test database `dtb_clipping_test` exists
3. Check database credentials in `Application.cfc`

### If TestBox is not found
Ensure the TestBox module is properly installed in your CommandBox installation.

## 📊 Understanding Test Results

TestBox provides detailed output including:
- **Pass**: Tests that passed successfully
- **Fail**: Tests that failed (with details)
- **Error**: Tests that encountered errors
- **Total**: Summary of all test results

## 🚀 Running Tests from Command Line

If you have CommandBox installed and accessible:

```bash
# Navigate to project directory
cd /path/to/fw1-clipping

# Run all tests
box testbox run

# Run specific test file
box testbox run specs/Test_1_ExampleSpec.cfc

# Run tests with verbose output
box testbox run --verbose
```

## 📝 Writing New Tests

1. Create a new `.cfc` file in the `specs/` directory
2. Extend `testbox.system.BaseSpec`
3. Use TestBox's BDD syntax:

```cfml
component extends="testbox.system.BaseSpec" {
    
    function run(testResults, testBox) {
        
        describe("My Test Suite", function() {
            
            it("should do something", function() {
                expect(true).toBeTrue();
            });
            
        });
        
    }
    
}
```

## 🔗 Useful Links

- [TestBox Documentation](https://testbox.ortusbooks.com/)
- [FW/1 Documentation](https://framework-one.github.io/)
- [Lucee Documentation](https://docs.lucee.org/)

## 📞 Support

If you encounter issues:
1. Check the server logs in CommandBox
2. Verify database connectivity
3. Ensure all dependencies are properly installed
4. Check that the Lucee server is running on port 53559

## 🎯 Current Status

✅ **Tests are working!** You can successfully run individual tests and view results.

✅ **Test runners are functional** - use the Basic Test Runner for the best experience.

✅ **Individual test execution** works perfectly via direct URLs.

⚠️ **Note**: The main `/tests/` index page has configuration issues, but all individual test functionality works correctly.
