#!/bin/bash
nice -n 0 dd if=/dev/urandom of=/dev/null bs=1M count=5k 2>normalcopies2.log
