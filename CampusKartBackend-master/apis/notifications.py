# from lib2to3.pgen2 import token
# from urllib import response
import firebase_admin
from firebase_admin import credentials, messaging
# import pathlib
from pathlib import Path
import os


BASE_DIR = Path(__file__).resolve().parent.parent

path = os.path.join(BASE_DIR,'campuskart-login-firebase-adminsdk-nxzzz-f814c7e7bc.json')
print(path)
service_file_path = path

cred = credentials.Certificate(service_file_path)
firebase_admin.initialize_app(cred)

# for push notifications
def sendPush(title, msg, registration_tokens):
    message = messaging.MulticastMessage(
        notification = messaging.Notification(title=title, body=msg),
        # data = dataObject,
        tokens = registration_tokens
    )
    
    response = messaging.send_multicast(message)
    print(f"Successfully sent the notifications {response}")