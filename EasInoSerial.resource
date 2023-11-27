*** Settings ***
Library     SerialFunctions.py
Library     String
Library     Collections
Library     Process


*** Variables ***
${PORT}             /dev/ttyUSB0
${DEVICE}           NANO

${ARDUINO-CLI}      arduino-cli
${ARDUINO-FQBN}     arduino:avr:nano:cpu\=atmega328old


*** Keywords ***
Setup
    ${system} =    Evaluate    platform.system()    platform
    Log to Console    \nRunning on ${system}
    IF    '${system}' == 'Windows'
        set global variable    ${ARDUINO-CLI}    arduino-cli.exe
    END
    IF    '${DEVICE}' == 'UNO'
        set global variable    ${ARDUINO-FQBN}    arduino:avr:uno
    ELSE IF    '${DEVICE}' == 'NANO'
        set global variable    ${ARDUINO-FQBN}    arduino:avr:nano:cpu\=atmega328old
    END
    Log to Console    Arduino CLI: ${ARDUINO-CLI}
    Log to Console    Port: ${PORT}
    Log to Console    Device: ${ARDUINO-FQBN}
    Open EasIno Serial    ${port}    115200

Program EasIno
    [Arguments]    ${port}    @{args}
    Check ArduinoCLI Version
    ${defines} =    Catenate    SEPARATOR=\" \"-D    @{args}
    ${defines} =    Set Variable    build.extra_flags\=-DTESTING \"-D${defines}\"
    Log To Console    \nDefines:${defines}
    ${result} =    Run Process    ${ARDUINO-CLI}    compile    -u    -p    ${port}    -v    --fqbn    ${ARDUINO-FQBN}
    ...    --build-property    ${defines}    EasInoTests    stderr=STDOUT
    Log    ${result.stdout}
    IF    ${result.rc}    Fatal Error

Check ArduinoCLI Version
    ${result} =    Run Process    ${ARDUINO-CLI}    version
    Should Match Regexp    ${result.stdout}    Version: 0.34.2

Open EasIno Serial
    [Arguments]    ${port}    ${baud}
    Open Serial    ${port}    ${baud}

Send EasIno Serial
    [Arguments]    ${operation}    @{args}
    ${body} =    Catenate    SEPARATOR=;    ${operation}    @{args}    ::END
    ${msg} =    Catenate    SEPARATOR=    EINO::    ${body}
    Write Serial    ${msg}

Receive EasIno Serial
    ${msg} =    Read Serial
    ${matches} =    Get Regexp Matches    ${msg}    EINO::(.*)::END    1
    ${result} =    Get From List    ${matches}    0
    Log To Console    ${result}
    RETURN    ${result}

Send EasIno Serial and receive
    [Arguments]    ${operation}    @{args}
    Send EasIno Serial    ${operation}    @{args}
    ${msg} =    Receive EasIno Serial
    RETURN    ${msg}

Restart EasIno Serial
    [Arguments]    ${baud}
    ${received} =    Send EasIno Serial and receive    RESTART    ${baud}
    ${result} =    Run Keyword And Return Status    Should Match Regexp    ${received}    RESTART;${baud};
    IF    not ${result}    Fatal Error

Close EasIno Serial
    Close Serial
