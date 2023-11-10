*** Settings ***
Resource        ../resources/common.robot
Library         RequestsLibrary
Library         Cumulocity

Suite Setup     Set Main Device


*** Test Cases ***
Measurements can be send via te topic
   
Measurments can be send via the tedge topic

Measurments can be send via the c8y topic

Events can be send via the te topic

Events can be send via the tedge topic

Events can be send via the c8y topic

Alarms can be send via the te topic

Alarms can be send via the tedge topic

Alarms can be send via the c8y topic