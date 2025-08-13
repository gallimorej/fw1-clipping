﻿/**
 * This is just a suite containing two very simple tests
 */
component extends="testbox.system.BaseSpec"{

    // executes before all suites
    function beforeAll(){}

    // executes after all suites
    function afterAll(){}

    // All suites go in here
    function run( testResults, testBox ){

        describe("A suite", function(){
            it("contains a very simple spec", function(){
                expect( true ).toBeTrue();
            });

            it("makes sure we are running on Lucee Server", function(){
                expect( structKeyExists( server, "lucee" ) ).toBeTrue();
            });

        });


    }
}
