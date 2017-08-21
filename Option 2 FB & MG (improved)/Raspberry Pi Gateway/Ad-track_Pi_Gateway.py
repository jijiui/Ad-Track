DEBUG = False


import os
import sys
import struct
import bluetooth._bluetooth as bluez
import re,urllib2
import geoip2.database
import requests
import uuid
import time

canIGetLocation=True
city="Initializing"

MAC_Record = {"ini":0}
timeOld= time.time()

LE_META_EVENT = 0x3e
LE_PUBLIC_ADDRESS=0x00
LE_RANDOM_ADDRESS=0x01
LE_SET_SCAN_PARAMETERS_CP_SIZE=7
OGF_LE_CTL=0x08
OCF_LE_SET_SCAN_PARAMETERS=0x000B
OCF_LE_SET_SCAN_ENABLE=0x000C
OCF_LE_CREATE_CONN=0x000D

LE_ROLE_MASTER = 0x00
LE_ROLE_SLAVE = 0x01

# these are actually subevents of LE_META_EVENT
EVT_LE_CONN_COMPLETE=0x01
EVT_LE_ADVERTISING_REPORT=0x02
EVT_LE_CONN_UPDATE_COMPLETE=0x03
EVT_LE_READ_REMOTE_USED_FEATURES_COMPLETE=0x04

# Advertisment event types
ADV_IND=0x00
ADV_DIRECT_IND=0x01
ADV_SCAN_IND=0x02
ADV_NONCONN_IND=0x03
ADV_SCAN_RSP=0x04


def returnnumberpacket(pkt):
    myInteger = 0
    multiple = 256
    for c in pkt:
        myInteger +=  struct.unpack("B",c)[0] * multiple
        multiple = 1
    return myInteger 

def returnstringpacket(pkt):
    myString = "";
    for c in pkt:
        myString +=  "%02x" %struct.unpack("B",c)[0]
    return myString 

def printpacket(pkt):
    for c in pkt:
        """if struct.unpack("B",c)[0]= """
        sys.stdout.write("%02x " % struct.unpack("B",c)[0])
        """print(struct.unpack("B",c)[0])"""

def get_packed_bdaddr(bdaddr_string):
    packable_addr = []
    addr = bdaddr_string.split(':')
    addr.reverse()
    for b in addr: 
        packable_addr.append(int(b, 16))
    return struct.pack("<BBBBBB", *packable_addr)

def packed_bdaddr_to_string(bdaddr_packed):
    return ':'.join('%02x'%i for i in struct.unpack("<BBBBBB", bdaddr_packed[::-1]))

def hci_enable_le_scan(sock):
    hci_toggle_le_scan(sock, 0x01)

def hci_disable_le_scan(sock):
    hci_toggle_le_scan(sock, 0x00)

def hci_toggle_le_scan(sock, enable):
# hci_le_set_scan_enable(dd, 0x01, filter_dup, 1000);
# memset(&scan_cp, 0, sizeof(scan_cp));
 #uint8_t         enable;
 #       uint8_t         filter_dup;
#        scan_cp.enable = enable;
#        scan_cp.filter_dup = filter_dup;
#
#        memset(&rq, 0, sizeof(rq));
#        rq.ogf = OGF_LE_CTL;
#        rq.ocf = OCF_LE_SET_SCAN_ENABLE;
#        rq.cparam = &scan_cp;
#        rq.clen = LE_SET_SCAN_ENABLE_CP_SIZE;
#        rq.rparam = &status;
#        rq.rlen = 1;

#        if (hci_send_req(dd, &rq, to) < 0)
#                return -1;
    cmd_pkt = struct.pack("<BB", enable, 0x00)
    bluez.hci_send_cmd(sock, OGF_LE_CTL, OCF_LE_SET_SCAN_ENABLE, cmd_pkt)


def hci_le_set_scan_parameters(sock):
    old_filter = sock.getsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, 14)

    SCAN_RANDOM = 0x01
    OWN_TYPE = SCAN_RANDOM
    SCAN_TYPE = 0x01

def getLocation():
    try:
       myip = visit("https://www.ipip.net/ip.html")
    except:
            try:
                myip = visit("https://www.whatismyip.com/")
            except:
                try:
                    myip = visit("http://www.ip138.com/")
                except:
                    myip = "So sorry!!!"
         
    reader = geoip2.database.Reader('/root/GeoLite2-City_20170606/GeoLite2-City.mmdb')
    response = reader.city(myip)
    #return str(.format(response.city.name))
    return  str(response.city.name)
  
def visit(url):
        opener = urllib2.urlopen(url)
        if url == opener.geturl():
            str = opener.read()
           
        return re.search('\d+\.\d+\.\d+\.\d+',str).group(0)
    
def sendData(dataToSend):
    requestBody = dataToSend
    r = requests.post("https://m8ncryslai.execute-api.eu-central-1.amazonaws.com/test/viewers", data=requestBody)
    print(r.status_code, r.reason)




    
def parse_events(sock, loop_count=100):
    global timeOld
    global MAC_Record
    global city
    global canIGetLocation
    
    old_filter = sock.getsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, 14)

    # perform a device inquiry on bluetooth device #0
    # The inquiry should last 8 * 1.28 = 10.24 seconds
    # before the inquiry is performed, bluez should flush its cache of
    # previously discovered devices
    flt = bluez.hci_filter_new()
    bluez.hci_filter_all_events(flt)
    bluez.hci_filter_set_ptype(flt, bluez.HCI_EVENT_PKT)
    sock.setsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, flt )
    done = False
    results = []
    myFullList = []
    for i in range(0, loop_count):
        pkt = sock.recv(255)
        ptype, event, plen = struct.unpack("BBB", pkt[:3])
        #print "--------------" 
        if event == bluez.EVT_INQUIRY_RESULT_WITH_RSSI:
                i =0
        elif event == bluez.EVT_NUM_COMP_PKTS:
                i =0 
        elif event == bluez.EVT_DISCONN_COMPLETE:
                i =0 
        elif event == LE_META_EVENT:
            subevent, = struct.unpack("B", pkt[3])
            pkt = pkt[4:]
            if subevent == EVT_LE_CONN_COMPLETE:
                le_handle_connection_complete(pkt)
            elif subevent == EVT_LE_ADVERTISING_REPORT:
                #print "advertising report"
                num_reports = struct.unpack("B", pkt[0])[0]
                report_pkt_offset = 0
                for i in range(0, num_reports):
        
                    if (DEBUG == True):
                        print "-------------"
                        #print "\tfullpacket: ", printpacket(pkt)
               
                UDID = returnstringpacket(pkt[report_pkt_offset -22: report_pkt_offset - 6])
                MAC = returnstringpacket(pkt[report_pkt_offset + 3:report_pkt_offset + 9])
                rssi_string, = struct.unpack("b", pkt[report_pkt_offset -1])
                rssi_int = int(rssi_string)
                
                
                
                #if the distance is smaller than 3m(+/-2m)
                if rssi_int>-65:
                    if (canIGetLocation==True):
                        city=getLocation()
                        print city
                        if (city!="Initializing"):
                           canIGetLocation=False 
                    MAJOR=returnstringpacket(pkt[report_pkt_offset -6: report_pkt_offset - 4])
                    print "\tUDID: ", printpacket(pkt[report_pkt_offset -22: report_pkt_offset - 6])
                    print "\tMAJOR: ", printpacket(pkt[report_pkt_offset -6: report_pkt_offset - 4])
                    print "\tMINOR: ", printpacket(pkt[report_pkt_offset -4: report_pkt_offset - 2])
                    print "\tMAC address: ", packed_bdaddr_to_string(pkt[report_pkt_offset + 3:report_pkt_offset + 9])
                    # commented out - don't know what this byte is.  It's NOT TXPower
                    txpower, = struct.unpack("b", pkt[report_pkt_offset -2])
                    print "\t(Unknown):", txpower

                    rssi, = struct.unpack("b", pkt[report_pkt_offset -1])
                    print "\tRSSI:", rssi
                    advertisementBoardID=uuid.uuid1()
                    
                    
                    if MAC in MAC_Record:
                            if time.time()-MAC_Record[MAC] > 30:
                                timeN = time.strftime("%Y/%m/%d %H:%M:%S",time.localtime())
                                requestBody0="{\"operation\": \"create\",\"tableName\": \"Ad-track\",\"payload\": {\"Item\": {\"Date & Time\":\""+timeN+"\","
                                requestBody1="\"Mobile Phone ID\": \""+ str(MAC)+"\","
                                requestBody2="\"Adertisement Board ID\": \""+ str(advertisementBoardID)+"\","
                                requestBody3="\"City\": \""+ city+"\"}}}"
                                requestBody =requestBody0+requestBody1+requestBody2+requestBody3
                                r = requests.post("https://m8ncryslai.execute-api.eu-central-1.amazonaws.com/test/viewers", data=requestBody)
                                print(r.status_code, r.reason)
                    
                    else:
                        timeN = time.strftime("%Y/%m/%d %H:%M:%S",time.localtime())
                        requestBody0="{\"operation\": \"create\",\"tableName\": \"Ad-track\",\"payload\": {\"Item\": {\"Date & Time\":\""+timeN+"\","
                        requestBody1="\"Mobile Phone ID\": \""+ str(MAC)+"\","
                        requestBody2="\"Adertisement Board ID\": \""+ str(advertisementBoardID)+"\","
                        requestBody3="\"City\": \""+city+"\"}}}"
                        requestBody =requestBody0+requestBody1+requestBody2+requestBody3
                        r = requests.post("https://m8ncryslai.execute-api.eu-central-1.amazonaws.com/test/viewers", data=requestBody)
                        print(r.status_code, r.reason)
                    MAC_Record[MAC] = time.time()
                        
                    
                    timeNew = time.time()
                    
                    if (timeNew - timeOld > 35) :
                        print(MAC_Record)
                        MAC_Record.clear()
                        timeOld = timeNew
                        '''for i in MAC_Record.keys():
                            if timeNew - MAC_Record[i] > 11:
                                del MAC_Record[i]'''
                       
                    
                             
dev_id = 0
try:
    sock = bluez.hci_open_dev(dev_id)
    print "ble thread started"

except:
    print "error accessing bluetooth device..."
    sys.exit(1)

hci_le_set_scan_parameters(sock)
hci_enable_le_scan(sock)

while True:
    parse_events(sock, 10)
                    
                        
           
    



