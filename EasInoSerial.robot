*** Settings ***
Resource	EasInoSerial.resource
Test Setup       Setup


*** Variables ***
@{BAUDS}    115200    9600


*** Test Cases ***
Tests Serial
    [Template]    Tests Serial
    FOR    ${baud}    IN    @{BAUDS}
        ${PORT}    ${baud}
    END

*** Keywords ***
Tests Serial
    [Arguments]    ${port}    ${baud}
    Program EasIno    ${port}    COMTYPE\=\"SERIAL\"    BAUD\=${baud}
    Open EasIno Serial    ${port}    ${baud}
    Check Com Type    ${baud}
    Check EasIno Board Version
    Check Ping
    Build operation and arguments
    Close EasIno

Check Com Type
    [Arguments]    ${baud}
    ${received} =    Send EasIno Serial and receive    COMTYPE
    ${result} =    Run Keyword And Return Status    Should Match Regexp    ${received}    COMTYPE;SERIAL;${baud};
    Run Keyword If    not ${result}    Fatal Error

Check EasIno Board Version
	${received} =    Send EasIno Serial and receive    VERSION
    Should Match Regexp    ${received}    VERSION;v\\d+\.\\d+\.\\d+;;;;;

Check Ping
	${received} =    Send EasIno Serial and receive    PING
    Should Match Regexp    ${received}    PING;;;;;;

Build operation and arguments
	${received} =    Send EasIno Serial and receive    TEST001
    Should Match Regexp    ${received}    TEST001;T001_0ARG;T001_1ARG;T001_2ARG;;;
	${received} =    Send EasIno Serial and receive    TEST002
    Should Match Regexp    ${received}    TEST002_VERYLONGARG;T002_0VERYLONGARGUM;T002_1VERYLONGARGUM;T002_2VERYLONGARGUM;;;
	${received} =    Send EasIno Serial and receive    TEST003
    Should Match Regexp    ${received}    TEST003;T003_0ARG;T003_1ARG;T003_2ARG;;;
	${received} =    Send EasIno Serial and receive    TEST004
    Should Match Regexp    ${received}    TEST004;T004_0ARG;T004_1ARG;T004_2ARG;T004_3ARG;T004_4ARG;
	${received} =    Send EasIno Serial and receive    TEST005
    Should Match Regexp    ${received}    TEST005;T005_0ARG;;T005_2ARG;;;
	${received} =    Send EasIno Serial and receive    TEST006123456789123456789
    Should Match Regexp    ${received}    TEST006;T006_0ARG;T006_1ARG;T006_2ARG;;;
	${received} =    Send EasIno Serial and receive    TEST025
    Should Match Regexp    ${received}    TEST025;10;0;-10;0;1;
	${received} =    Send EasIno Serial and receive    TEST026
    Should Match Regexp    ${received}    26;1;T026_1VERYLONGARGUM;\\\(;;\\x01;
	${received} =    Send EasIno Serial and receive    TEST027
    Should Match Regexp    ${received}    27.00;1.000;-1;-575.12;99.0000000000000000;0.30;
	${received} =    Send EasIno Serial and receive    TEST028
    Should Match Regexp    ${received}    2.8;;99.1250000000000000;;;;

Close EasIno
    Close EasIno Serial
