#!/bin/bash

bash normalpriority1.sh & bash normalpriority2.sh

echo "Nice -n 0 (copies1) : " $(cat normalcopies1.log | grep GB | awk '{print $6 " s"}')
echo "Nice -n 0 (copies2): " $(cat normalcopies2.log | grep GB | awk '{print $6 " s"}')

