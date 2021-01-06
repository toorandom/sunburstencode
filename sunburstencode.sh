#!/bin/bash

# sunburst Encoder
# Give me as arguments
# arg1 mac:  00:11:22:AA:BB:CC"
# arg2 domain:  domain.com
# arg3 guid:  aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
#
# arg1 must be the first UP interface after loopback in uppercase
# arg2 is the TLD of the machine
# arg3 is the contents of HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography
#
# This easy code is based on: https://www.netresec.com/?page=Blog&month=2020-12&post=Reassembling-Victim-Domain-Fragments-from-SUNBURST-DNS
#
# This has not been tested yet with real data so maybe this is just gibberish code.
# The output string should coincide with the output of the first column of the python script https://www.netresec.com/files/SunburstDomainDecoder.zip
# which is run against all the pDNS information of your environment.

# Eduardo Ruiz Duarte
# toorandom@gmail.com




mac="$1"
dom="$2"
guid="$3"

mac=$(echo $mac | sed 's/://g' | tr [:lower:] [:upper:])
s1Guid=$(echo -n $mac$dom$guid | md5sum | awk '{print $1}')
s1Guidlen=$[$(echo -n $s1Guid | wc -c)/2]
p1Guid=$(echo -n $s1Guid | cut -c 1-$s1Guidlen)
p2Guid=$(echo -n $s1Guid | cut -c $[$s1Guidlen+1]-$[$s1Guidlen*2])

t1Guid=$(echo $p1Guid | sed 's/\([a-z0-9][a-z0-9]\)/0x\1 /g')
t2Guid=$(echo $p2Guid | sed 's/\([a-z0-9][a-z0-9]\)/0x\1 /g')

declare -a x1=($t1Guid)
declare -a x2=($t2Guid)


echo $t1Guid
echo $t2Guid

echo "Find the following string in the output of SunburstDomainDecoder.zip from your environment pDNS queries:"

for i in $(seq 0 $[s1Guidlen/2 - 1])
do
        printf "%02X" "$((${x1[$i]} ^ ${x2[$i]}))"
done
printf "\nLet me know if it worked since this is maybe gibberish, toorandom@gmail.com\n"
