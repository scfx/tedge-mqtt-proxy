*** Settings ***
Library     Cumulocity


*** Variables ***
# Cumulocity settings
&{C8Y_CONFIG}
...                 host=%{C8Y_BASEURL= }
...                 username=%{C8Y_USER= }
...                 password=%{C8Y_PASSWORD= }
...                 tenant=%{C8Y_TENANT= }
${DEVICE_ID}        %{DEVICE_ID=}


*** Keywords ***
Set Main Device
    Cumulocity.Set Device    ${DEVICE_ID}
