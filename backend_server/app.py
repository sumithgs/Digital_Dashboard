from fastapi import FastAPI, WebSocket
from fastapi.testclient import TestClient
from fastapi.websockets import WebSocket
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
import hid
import random
import time

app=FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:80","https://127.0.0.1:80","http://127.0.0.1:8000","*:*","*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# @app.websocket("/ws")
# async def training_status(websocket: WebSocket):
#     print("Connecting to the App...")
#     await websocket.accept()
#     try:
#         data={
#             "msg":"Hello WebSocket"
#         }
#         # data2= await websocket.receive_text()  #Can be used to receive data from App
#         # print(data2)
#         await websocket.send_json(data) #Can be used to return data to the App
#     except Exception as e:
#         print("Error: ",e)
#     print("Websocket connection closing...")

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}


@app.websocket_route("/ws")
async def websocket(websocket: WebSocket):
    await websocket.accept()
    await websocket.send_text("hello")
    await websocket.close()

@app.websocket_route("/ws1")
async def websocket(websocket: WebSocket):
    await websocket.accept()
    while True:
        data=await websocket.receive_text()
        print(data)
        data=random.randint(60,65)
        await websocket.send_text(str(data))
        if(str(data)=="no"):
            break
    await websocket.close()


@app.websocket_route("/ws2") # Working
async def websocket(websocket: WebSocket):
    await websocket.accept()
    while True:
        # data=await websocket.receive_text()
        # print(data)
        # if(str(data)=="no"):
        #     break
        #'MOSFET_TEMP' 'SPEED' 'BATTERY' 'DISTANCE' 'FAULT CODE'
        await websocket.send_json({
            "MOSFET_TEMP": random.randint(35,40),
            "SPEED": random.randint(40,44),
            "BATTERY": random.randint(90,95),
            "DISTANCE": random.randint(24,25),
            "TOTAL_DISTANCE": random.randint(3045,3046),
            "FAULT_VALUE": random.randint(0,1)
        })
    await websocket.close()


@app.websocket_route("/ws3") #Changed recently
async def websocket(websocket: WebSocket):
    await websocket.accept()
    gamepad = hid.device()
 #   time.sleep(2)
    # gamepad.open(0x0f0d, 0x00c1)
    gamepad.open(0x0810,0x0001)
    gamepad.set_nonblocking(True)
    while True:
        try:
            #'MOSFET_TEMP' 'SPEED' 'BATTERY' 'DISTANCE' 'FAULT CODE'
            report = gamepad.read(64)
            if report:
                #time.sleep(0.3)
                print(report)
                json_object={
                    "mode":report[6],
                    #"lights":report[1],
                    "battery_percentage":report[1],
                    "speedometer":report[3],
		"faults":report[5]                    
                }
                # yield json_object
                # yield str(json_object).encode()
                await websocket.send_json(json_object)
        except Exception as e:
            print("An Error Occured: ",e)
            # print(e)
            gamepad.close()
            break
    #     await websocket.send_json({
    #         "MOSFET_TEMP": random.randint(35,40),
    #         "SPEED": random.randint(40,44),
    #         "BATTERY": random.randint(90,95),
    #         "DISTANCE": random.randint(24,25),
    #         "TOTAL_DISTANCE": random.randint(3045,3046),
    #         "FAULT_VALUE": random.randint(0,1)
    #     })
    # await websocket.close()



def test_read_main():
    client = TestClient(app)
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}


def test_websocket():
    client = TestClient(app)
    with client.websocket_connect("/ws") as websocket:
        data = websocket.receive_json()
        print(data)
        assert data == {"msg": "Hello WebSocket"}


def generator_obj_val():
    for device in hid.enumerate():
        print(f"0x{device['vendor_id']:04x}:0x{device['product_id']:04x} {device['product_string']}")
    gamepad = hid.Device(0x0810,0x0001)
    time.sleep(1)
    # gamepad.open(0x0f0d, 0x00c1)
    #gamepad.open(0x0810,0x0001)
#    gamepad.set_nonblocking(True)
    while True:
        try:
            report = gamepad.read(64)
            if report:
                print(report)
                json_object={
                    "mode":report[6],
                    "faults":report[1],
                    "battery_percentage":report[5],
                    "speedometer":report[2]                    
                }
                # yield json_object
                yield str(json_object).encode()
        except Exception as e:
            print("An Error Occured: ",e)
            gamepad.close()
            break
    

@app.get("/test")
def test_endpoint():
    return StreamingResponse(generator_obj_val())

