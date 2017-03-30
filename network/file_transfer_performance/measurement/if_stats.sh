#!/bin/bash
#
# Print stats for an interface at a regular interval.
#
# cat /proc/net/dev | grep p3p1
#
# Expected format:
# Inter-|   Receive                                                |  Transmit
#  face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
#   p3p1: 62532782890571 45637642358    0 676564   31     0          0   7623825 23685063868011 19807410698    0    0    0     0       0          0
#
# $1: - interface name
# $2  - bytes received
# $3  - pkts received
# $10 - pkts transmitted
# $11 - pkts transmitted
#
bold()          { ansi 1 "$@"; }
ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }

dfile=/proc/net/dev
ifname=p3p1
psecs=3
psecs=1

astring0=`cat ${dfile} | grep ${ifname} | awk '{print "rxb0="$2"; rxp0="$3"; txb0="$10"; txp0="$11"; secs0="systime()}'`
eval ${astring0}
echo "# t0 recv_bytes = "${rxb0}" @ "${secs0}" seconds since 1970-01-01 00:00:00 UTC"
echo "# t0 recv_pkts  = "${rxp0}" @ "${secs0}" seconds since 1970-01-01 00:00:00 UTC"
echo "# t0 tmit_bytes = "${txb0}" @ "${secs0}" seconds since 1970-01-01 00:00:00 UTC"
echo "# t0 tmit_pkts  = "${txp0}" @ "${secs0}" seconds since 1970-01-01 00:00:00 UTC"

echo "# Pausing for "${psecs}" seconds."
sleep ${psecs}

astring1=`cat ${dfile} | grep ${ifname} | awk '{print "rxb1="$2"; rxp1="$3"; txb1="$10"; txp1="$11"; secs1="systime()}'`
eval ${astring1}
echo "# t1 recv_bytes = "${rxb1}" @ "${secs1}" seconds since 1970-01-01 00:00:00 UTC."
echo "# t1 recv_pkts  = "${rxp1}" @ "${secs1}" seconds since 1970-01-01 00:00:00 UTC."
echo "# t1 tmit_bytes = "${txb1}" @ "${secs1}" seconds since 1970-01-01 00:00:00 UTC."
echo "# t1 tmit_pkts  = "${txp1}" @ "${secs1}" seconds since 1970-01-01 00:00:00 UTC."

drxb=`echo $rxb1" - "$rxb0 | bc -l`
drxp=`echo $rxp1" - "$rxp0 | bc -l`
dtxb=`echo $txb1" - "$txb0 | bc -l`
dtxp=`echo $txp1" - "$txp0 | bc -l`

brrxMiB=`echo ${drxb}"/("${psecs}"*1.*1024.*1024.)" | bc -l `; brrxMiB=`printf "%-10.3f" ${brrxMiB}`
prrxPPS=`echo ${drxp}"/("${psecs}"*1.)" | bc -l `; prrxPPS=`printf "%-10.1f" ${prrxPPS}`
bpprx=`echo ${drxb}"/"${drxp} | bc -l`;bpprx=`printf "%.1f" ${bpprx}`
brtxMiB=`echo ${dtxb}"/("${psecs}"*1.*1024.*1024.)" | bc -l `; brtxMiB=`printf "%-10.3f" ${brtxMiB}`
prtxPPS=`echo ${dtxp}"/("${psecs}"*1.)" | bc -l `; prtxPPS=`printf "%-10.1f" ${prtxPPS}`
bpptx=`echo ${dtxb}"/"${dtxp} | bc -l`;bpptx=`printf "%.1f" ${bpptx}`
echo ${ifname}","${psecs}"s," \
     $(bold 'RX')','${drxb}"b,"${drxp}"p,"$(bold ${brrxMiB}"MiB/s ")","${prrxPPS}"p/s,"${bpprx}"b/p," \
     $(bold 'TX')','${dtxb}"b,"${dtxp}"p,"$(bold ${brtxMiB}"MiB/s ")","${prtxPPS}"p/s,"${bpptx}"b/p" \
     ${secs0}","${secs1}
