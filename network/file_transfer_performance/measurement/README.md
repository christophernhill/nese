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

The basic model that these examples were created for is a setup shown below.

```

  Source                Sending          Transfer        Receiving                        Sink
  storage               device           network         device                           storage
   ---                                                                                     ----
 (     )             --------------                 ---------------------                (      )
  |   |  ---....----|              |  <===| |====> |                     |----.....----   |    |
  |   |              --------------                 ---------------------                 |    |
  -----                                                                                   ------
```
