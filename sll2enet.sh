#!/bin/bash
# sll2enet Shell script by SyneArt <sa@syneart.com> 2022/06/28

usage () {
    echo "Usage: sll2enet.sh <pcap file>"
}

if [ "$1/" == "/" ]; then usage; exit; fi

sedi=(-i) && [ "$(uname)" == "Darwin" ] && sedi=(-i '')

TMP_FILE="$(mktemp /tmp/jed.sll2enet.XXXXXXXXX)" || exit 1
CHANGE_LOG_FILE="$(mktemp /tmp/jed.sll2enet.cl.XXXXXXXXX)" || exit 1
EXPORT_PCAP_FILE="${1%.[^.]*}_enet.pcap"

(tshark -v) >/dev/null 2>&1 && {
    tshark -x -r "$1" > ${TMP_FILE}
} || {
    echo "==> Warning: tshark not found, please install Wireshark first .."
    exit 1
}

sed "${sedi[@]}" -E "s/0000([0-9a-f ]){44}08 00/0000  00 00 00 00 00 00 00 00 00 00 00 00 08 00/g w ${CHANGE_LOG_FILE}" ${TMP_FILE}
[ ! -s ${CHANGE_LOG_FILE} ] && {
    echo Do Nothing, PCAP file is Ethernet header already! 
    rm ${TMP_FILE}
    rm ${CHANGE_LOG_FILE}
    exit 0
}

for i in {1..100};
do
    f_number=`printf '%02x\n' ${i}`
    a_number=`printf '%02x\n' $((i-1))`
    sed "${sedi[@]}" "s/0${f_number}0/0${a_number}e/g" ${TMP_FILE}
done

(text2pcap -v) >/dev/null 2>&1 && {
    text2pcap ${TMP_FILE} "${EXPORT_PCAP_FILE}" >/dev/null 2>&1
    echo NEW PCAP file is created at ${EXPORT_PCAP_FILE}
    echo Done
} || {
    echo "==> Warning: text2pcap not found, please install Wireshark first .."
}
rm ${TMP_FILE}
rm ${CHANGE_LOG_FILE}
