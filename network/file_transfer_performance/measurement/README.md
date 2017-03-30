# Material for checking basic network and storage performace

## Overview

More often than not it is hard to dertermine where there a bottlenecks in data transfers over a network. This
directory contains a few items that can be helpful for determining individual and collective performance of different 
elements involved in a transfer. These items can be used to help decide which (if any) parts of a system need to be upgraded
or modified in order to meet a data transfer bandwidth performance goal.

At a minimum for a file transfer to perform well it requires 

- the source storage system have adequate read performance
- the sending device that transmits data into the network needs to be adequately configured
- the network speed over the transfer network between the sending device and the receiving device needs to be sufficient
- the receiving device that consumes from the network needs to be adequately configured
- the sink storage system have adequare write performance

Files in this directory provide examples of how to measure performance for these pieces on a Linux system. The
files contain examples for measureing each piece in isolation and for measuring various sub-combinations of
the full end-to-end flow. 

## Basic model

The basic model that these examples were created for is a simple setup as shown below.

```

  Source                Sending          Transfer        Receiving                        Sink
  storage               device           network         device                           storage
   ---                                                                                     ----
 (     )             --------------                 ---------------------                (      )
  |   |  ---....----|              |  <===| |====> |                     |----.....----   |    |
  |   |              --------------                 ---------------------                 |    |
  -----                                                                                   ------
```

the examples show useful ways to check the transfer setup for each of the section ```Source storage -> Sending device```,
```Sending device -> Receving device```, ```Receving device -> Sink storage```.

## Source storage -> Sending device

For this pathway the Linux command dd can be used to test read transfers from the ```Source storage``` to memory in the ```Sending device``. A real example of this is

```
$ bash
$ dd if=tar000141.tar ibs=120M obs=12M count=100 | dd of=/dev/null bs=12M & pid=$!
```
wait a little time
```
$ kill -USR1 $pid
```
```
710+0 records in
710+0 records out
8933867520 bytes (8.9 GB) copied, 38.8305 s, 230 MB/s
```

etc...

Although trivial this is useful as it shows for this file system, a single threaded transfer
to the sending device memory has a maximum performance of 230MB/s or 1.8Gb/s. This suggests
that a faster system for transfering (for example parallel reads``` from the ```Source storage```)
would need to be in place in order saturate a modern 10Gb/s network (let alone a 100Gb/s network).

If there are multiple files to be transferred then creating a file, ```FOO``, with contents
```
dd if=tar000141.tar ibs=120M obs=12M count=100 | dd of=/dev/null bs=12M & pid1=$!
dd if=tar000140.tar ibs=120M obs=12M count=100 | dd of=/dev/null bs=12M & pid2=$!
```
for example and then invoking the commands together
```
$ source FOO
```
can test the effectiveness of parallel transfers. In the particular case tested, the
multi-transfer performance was a little lower in aggregate than a single transfer
```
12582912000 bytes (13 GB) copied, 119.012 s, 106 MB/s
12582912000 bytes (13 GB) copied, 118.999 s, 106 MB/s
```
The transfer performance is likely to be fairly variable on any shared system, but
nevertheless these numbers are useful on providing some guidance for expectations.

The end-to-end transfer speed is unlikely to be much faster than the transfer speed of
the slowest intermediate step. 

