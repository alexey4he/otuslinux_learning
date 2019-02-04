#!/bin/bash
nice -n -19 dd if=/dev/urandom of=/dev/null bs=1M count=5k 2>highpriority.log
