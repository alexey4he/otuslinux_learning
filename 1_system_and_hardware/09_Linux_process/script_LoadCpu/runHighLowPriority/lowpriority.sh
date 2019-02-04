#!/bin/bash
nice -n 20 dd if=/dev/urandom of=/dev/null bs=1M count=5k 2>lowpriority.log
