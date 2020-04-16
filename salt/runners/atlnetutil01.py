#!/usr/bin/python3
import json
import socket
#----------------------------------------------------------------------------------------------------

def send_data(data, runner_data):

    data['runner_data'] = runner_data
    socketclient = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_port = 5000
    server_address = '10.100.19.21'
    socketclient.connect((server_address, server_port))
    print('connecting to socket on tcp://{address}:{port}'.format(address=server_address,port=server_port))
    encoded_data = json.dumps(data).encode('utf-8')
    print('sending '+str(encoded_data))
    socketclient.sendall(encoded_data)
    socketclient.close()
