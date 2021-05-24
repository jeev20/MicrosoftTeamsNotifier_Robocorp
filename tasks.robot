# +
*** Settings ***
Documentation   This robot sends a message to the given Microsoft Teams webhook. 
...             The webhook and the message payload are the inputs required to run this robot.
...             The message format used in this example is saved as template in message_card.json.

Library   teams_webhook.py
Library   RPA.Dialogs
Library   RPA.JSON
Library   DateTime
# -


***Variables***
${TeamsWebhookInfo}   https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook
# Update the value of this variable and avoid the keyword User input from dialog
#${WebhookURL}   ""

# +
***Keywords***
User input from dialog
    # Get user input string for the input data CSV.
    Add heading       Send a Message to Teams Webhook
    Add text input    WebhookURL    label=Teams Webhook URL
    Add drop-down  name=ScenarioType 
    ...            label=Select scenario type
    ...            options=Success,Failure
    ...            default=Success
    Add link       ${TeamsWebhookInfo}    label=Creating an incoming webhook in Microsoft Teams

    ${result}=    Run dialog  title=Webhook User Inputs
    [Return]  ${result}

Read teams template
    # Read the message_card.json file and return the json content
    ${MessagePayload}=  Load JSON from file  ${CURDIR}${/}message_card.json
    [Return]  ${MessagePayload}
    
Prepare message payload
    [Arguments]  ${CardType}  ${ProcessName}   ${RobotName}   ${Message}
    # Let the developer specify the required Arguments and use them in building the message card payload
    # The two states here are Success and Failure but more can be defined by the developer
    ${MessagePayload}=  Read teams template
    ${Time} =	Get Current Date
    ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].facts[0].value    ${ProcessName}
    ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].facts[1].value    ${Time} 
    ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].facts[2].value    ${RobotName} 
    ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].activityTitle     ${CardType} 
    
    IF  "${CardType}"=="Success"
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.themeColor                "33FF3F"
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.title                     Robot Execution Successful
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.summary                   Status is SUCCESS
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].text          ${Message} <br> Success Message with line break
    ELSE
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.themeColor                "FF5733"
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.title                     Robot Execution Failed
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.summary                   Status is FAILED
        ${MessagePayload}=    Update value to JSON    ${MessagePayload}    $.sections[0].text          ${Message} <br> Failure Message with line break
    END
    [Return]    ${MessagePayload}

Send teams message to webook
    [Arguments]   ${WebhookURL}   ${MessageText}
    # Send the payload to the provided webhook in Teams
    ${Response}=  send_teams_message  ${WebhookURL}   ${MessageText}
    [Return]   ${Response}
    
Return payload 
    [Arguments]  ${Scenario}
    IF  "${Scenario}"=="Success"
        ${MessagePayload}=  Prepare message payload  CardType=Success  ProcessName=Send Message to Teams Webhook   
        ...                                          RobotName=Robocorp ABC  Message=The process was completed successfully
    ELSE  
        ${MessagePayload}=  Prepare message payload  CardType=Failure  ProcessName=Send Message to Teams Webhook   
        ...                                          RobotName=Robocorp ABC  Message=The process failed
    END
    [Return]  ${MessagePayload}
    
# -

*** Tasks ***
Send Webhook to Microsoft Teams
    # Get the user input
    ${Result}=  User Input from dialog

    # Lets prepare the message depending on the user input
    ${MessagePayload}=  Return payload  ${Result.ScenarioType}
    
    # Use the WebhookURL provided by the user and the generated MessagePayload
    ${Success}=  Send teams message to webook  ${Result.WebhookURL}    ${MessagePayload}    

    # Lets confirm that the message was sent successfully
    IF  ${Success}
        Log  "Message sent successfully"
    ELSE 
        Log  "Failed to send message"
    END


