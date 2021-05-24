# Microsoft Teams Notifier in Robocorp
This robot sends messages to an incoming webhook in Microsoft Teams using Robocorp.

## What does tasks.robot script do?
- The Robot promts the user for webhook URL for Microsoft Teams and the Success or Failure scenario.
- Depending on the scenario type provide by the user, the robot prepares the message payload.
- The message payload is built from json template string, which is of the format supported by Microsoft Teams (MessageCard)
- The teams_webhook.py uses the requests library to send the message payload to the provided webhook URL and returns the success or failure flag 
- Depending on the success or failure of the send_teams_message function in teams_webhook.py the robot logs the completion message


## Example messages as seen in Microsoft Teams

### Success message 
![SuccessImage](https://github.com/jeev20/MicrosoftTeamsNotifier_Robocorp/blob/main/images/Success.JPG)

### Failure message
![FailureImage](https://github.com/jeev20/MicrosoftTeamsNotifier_Robocorp/blob/main/images/Failure.JPG)


## Preconditions 
Ensure you setup your Robocorp Lab instance to be able to run this robot in attended mode or use the Robocorp assistant.  
Clone this repository and ensure your RCC in Robocorp lab is connected to your python instance. Robocorp Lab will parse the conda.yaml file to install all dependecies for this project using pip. 


## Running the script 

Step 1. Copy or Clone the contents of this repository OR  link this repository in Robocorp Cloud (support git folders and parses the tasks.robot)

Step 2. Open the project in Robcorp Lab and open the tasks.robot file OR setup and assistant with this robot

Step 3. Change the variables as and logic as required. This is just an example, you can edits the MessagePayload or Webhook url within the script and avoid getting the inputs from the dialog box. 

Step 4. Execute the tasks.robot file OR run the assistant

## Thanks to 
* [Robocorp](https://robocorp.com)
* [RobotFramework](https://robotframework.org/)

## Contributors
* [jeev20]("https://github.com/jeev20")
