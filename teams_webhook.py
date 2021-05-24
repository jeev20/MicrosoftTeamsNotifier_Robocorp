# +
import requests
import json

def send_teams_message(WebhookURL, Payload):
    """
    This function sends a teams message to a given teams webhook.

    Parameters:
    @WebhookURL : The webhook URL to which the message needs to be sent
    @MessageText : The message text to be sent

    Returns:
    @success : The flag which confirms successfull execution
    """
    headers = {'Content-Type': 'application/json'}
    
    response = requests.post(WebhookURL, headers=headers, data=json.dumps(Payload))
    
    return  response.ok
