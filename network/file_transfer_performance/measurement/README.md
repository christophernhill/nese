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

