# sunburstencode
Encoder of MAC, Domain and MachineGUID to get the Sunburst GUID and compare against SunburstDomainDecoder.zip


## Usage (tested on Ubuntu/Cygwin: Bash):
```
$ ./sunburstEncoder.sh 00:11:22:AA:BB:CC microsoft.com aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
0x57 0xdd 0x0d 0x67 0x5d 0x25 0x7a 0x9b
0x0d 0x94 0xa8 0x0b 0x3d 0x2b 0x9d 0x17
Find the following string in the output of SunburstDomainDecoder.zip from your environment pDNS queries:
5A49A56C600EE78C
Let me know if it worked since this is maybe gibberish, toorandom@gmail.com
```
