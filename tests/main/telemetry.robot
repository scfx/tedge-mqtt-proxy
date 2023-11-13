*** Settings ***
Resource        ../resources/common.robot
Library         RequestsLibrary
Library         Cumulocity

Suite Setup     Set Main Device


*** Test Cases ***
Measurements can be send via te topic
    POST
    ...    http://localhost:8020/te/device/main///m/test_te
    ...    data={"temperature": 25}
    ...    expected_status=201
    Device Should Have Measurements    type=test_te

Measurments can be send via the tedge topic
    POST
    ...    http://localhost:8020/tedge/measurements
    ...    data={"temperature": 25, "type": "test_tedge"}
    ...    expected_status=201
    Device Should Have Measurements    type=test_tedge

Events can be send via the te topic
    POST
    ...    http://localhost:8020/te/device/main///e/test_te
    ...    data={"text": "A user just logged in","someOtherCustomFragment": {"nested": {"value": "extra info"}}}
    ...    expected_status=201
    Device Should Have Event/s    type=test_te

Events can be send via the tedge topic
    POST
    ...    http://localhost:8020/tedge/events/test_tedge
    ...    data={"text": "A user just logged in","someOtherCustomFragment": {"nested": {"value": "extra info"}}}
    ...    expected_status=201
    Device Should Have Event/s    type=test_tedge

Alarms can be send via the te topic
    POST
    ...    http://localhost:8020/te/device/main///a/test_te
    ...    data={"text": "Temperature is very high","severity": "warning","someOtherCustomFragment":{"nested": {"value": "extra info"}}}
    ...    expected_status=201
    Device Should Have Alarm/s    type=test_te

Alarms can be send via the tedge topic
    POST
    ...    http://localhost:8020/tedge/alarms/warning/test_tedge
    ...    data={"text": "Temperature is very high","someOtherCustomFragment":{"nested": {"value": "extra info"}}}
    ...    expected_status=201
    Device Should Have Alarm/s    type=test_tedge
