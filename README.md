# sll2enet
Transform the Linux cooked-mode capture(SLL) into Ethernet(enet) header

### In Unix (include MacOS)

You can use Terminal , and type (change directory to bash file location)

`$ bash ./sll2enet.sh <pcap file>`

for example,

`$ bash ./sll2enet.sh linux_cooked_mode_capture.pcap`

then it will created pcap file when success.

like,

`linux_cooked_mode_capture_enet.pcap`

## Requirement
Wireshark
