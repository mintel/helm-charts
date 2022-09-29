from websocket import create_connection  # using websocket-client library
import requests
import time
import json

HOST = "https://gnpd-data-entry-api.svc.us-qa1.qa.mintel.cloud"
TOKEN = "Bearer eyJ0eXAiOiAiYXQrSldUIiwgImtpZCI6ICJwS3FQQTRaclptNlhzWlAzak5saUtNTGVBVTZNZXpKY2x4TWg3cGlLUzdzIiwgImFsZyI6ICJSUzI1NiJ9.eyJleHAiOiAxNjYwNzI2MzQ2LCAiYXVkIjogWyJHdWdaYkdNUWowUEtHN0owV1hlNllQZHJjSXRQY2dRMUd1dzBzcUl2IiwgIm1pbnRlbC5jb20iXSwgImlzcyI6ICJodHRwczovL29hdXRoLm1pbnRlbC5jb20iLCAiY2xpZW50X2lkIjogIkd1Z1piR01RajBQS0c3SjBXWGU2WVBkcmNJdFBjZ1ExR3V3MHNxSXYiLCAibmJmIjogMTY2MDcyMjc0NiwgImlhdCI6IDE2NjA3MjI3NDYsICJqdGkiOiAiOTBhYWIwNmItOWViZC00YzhjLTljZTItMTc2ZWMyOTY2MTI1IiwgInNjb3BlIjogIm9wZW5pZCBwcm9maWxlIGVtYWlsIGludGVyY29tIiwgInN1YiI6ICI0MzFAbWludGVsIiwgImdyb3VwIjogOSwgImdyb3VwcyI6IFs5LCAxMSwgMjM3LCAxMzU4MywgMTYwNDEsIDE2NDc3LCAyNzUzOSwgMjg2NzksIDMzMzk3LCAzODQ3MywgMzg0NzUsIDM4NDc3LCAzODkxOSwgNDIzNTksIDQ2MzYzLCA0NjM2NSwgNDc2NDcsIDQ5NzY5LCA0OTc3MywgNTEzNzAsIDUxNTAxLCA1MTUwNSwgNTQzMzVdLCAidmZ1IjogMTY2NDI3NDUwOX0.UIuheRpAxHctH3hB4Dqw58IDM1Z434XgZT58977VH3WjiCs1KcnpVfmvmOGhnO0y8qpnL2N742Dp45kzhrQDLgf5XVEc7ENQP-_J4EAZTnLSAqTVUeO-a9XNwvYl0W9ytz6FZssZhdP4pvE5gRN3psmhCPPaDBOOt9zcaBMt6gbCv8bLwzUq9BWKv-zVjJlog2fqa0GU_MAhhNEgDY0PM151HPSDjkdj8UfX1Mw2maAnsosJi4CkjzCQC2askHYt369CAIADNUuuLp8FcVEE3FZdblJ4nISC-t13m6dIPTS9Tby2wKE8FE6kL6Yc8hYIUYjMaBRXlOA-IwPeKVhwlQ" # your token here
HEADERS = {"Authorization": TOKEN}

def get_websocket_connection_url():
    """
    The initial connection requires you to generate a temporary token via a HTTP request,
    which you are then expected to pass as part of the url in the websocket connection request
    """
    websocket_connection_token = requests.get(f"{HOST}/api/image-capture/ws-token", headers=HEADERS).json()["token"]
    return  f"wss://gnpd-data-entry-api.svc.us-qa1.qa.mintel.cloud/api/image-capture/ws/{websocket_connection_token}"


websocket_connection_url = get_websocket_connection_url()

ws = create_connection(websocket_connection_url)
print(websocket_connection_url)
while True:
    ws.ping()    # uvicorn requires a ping at least once every 20 seconds to keep the connection alive
    print("HERE")
    ws.send(json.dumps({"message_type": "ping"}))    # we have a simple ping / pong system
    time.sleep(0.1)
    pong = ws.recv()
    print("GOT %s" % (pong))
