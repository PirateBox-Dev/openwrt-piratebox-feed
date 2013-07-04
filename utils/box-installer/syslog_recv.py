# Server program
# UDP VERSION


from socket import *

# Set the socket parameters
host = "0.0.0.0"
port = 9999
buf = 1024
addr = (host,port)

# Create socket and bind to address
UDPSock = socket(AF_INET,SOCK_DGRAM)
UDPSock.bind(addr)

# Receive messages
while 1:
    data,addr = UDPSock.recvfrom(buf)
    if not data:
        print "Client has exited!"
        break
    else:
        print "Received message ", data,""

# Close socket
UDPSock.close()
