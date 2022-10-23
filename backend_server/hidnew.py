import hid
import time
for device in hid.enumerate():
    print(f"0x{device['vendor_id']:04x}:0x{device['product_id']:04x} {device['product_string']}")
gamepad = hid.device()
#time.sleep(2)
gamepad.open(0x0810,0x0001)
gamepad.set_nonblocking(True)
while True:
    report = gamepad.read(64)
    if report:
#        time.sleep(0.5)
        print(report)
