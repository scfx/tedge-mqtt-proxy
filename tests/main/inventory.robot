*** Settings ***
Resource        ../resources/common.robot
Library         RequestsLibrary
Library         Cumulocity

Suite Setup     Set Main Device


*** Test Cases ***
Tedge Device should exsist
    Device Should Exist    ${DEVICE_ID}

Tedge-mqtt-proxy should be installed
    Device Should Have Installed Software    tedge-mqtt-proxy

Child Device can be created
    PUT
    ...    http://localhost:8020/te/device/child01//
    ...    data={"@type": "child-device","name":"child01","type": "test"}
    ...    expected_status=201
    Device Should Have A Child Devices    child01

Fragments of Device can be updated
    PUT
    ...    http://localhost:8020/te/device/main///twin/test_fragment
    ...    data={}
    ...    expected_status=201
    Device Should Have Fragments    test_fragment
