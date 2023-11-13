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

Tedge-mqtt-proxy should be enabled
    Cumulocity.Should Have Services    name=tedge-mqtt-proxy    service_type=systemd    status=up

Fragments of Device can be updated
    POST
    ...    http://localhost:8020/te/device/main///twin/test_fragment
    ...    data={}
    ...    expected_status=201
    Device Should Have Fragments    test_fragment
