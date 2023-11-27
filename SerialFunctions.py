import serial
import time

global arduino

def open_serial(port, baud):
    global arduino
    arduino = serial.Serial()
    arduino.port = port
    arduino.baudrate = baud
    arduino.timeout = 2
    arduino.dtr = 0
    arduino.rts = 0
    arduino.open()
    time.sleep(2)

def write_serial(msg):
    arduino.write(bytes(msg, 'utf-8'))
    time.sleep(0.1)

def read_serial():
    buf=""
    while arduino.inWaiting():
        ret = arduino.readline()
        buf = buf + ret.decode()
    return buf
    
def close_serial():
    time.sleep(1)
    arduino.close()
