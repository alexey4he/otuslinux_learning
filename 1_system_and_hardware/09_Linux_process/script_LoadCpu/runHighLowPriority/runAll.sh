#!/bin/bash

bash highpriority.sh & bash lowpriority.sh

echo "Nice -n 20 (low priority) : " $(cat lowpriority.log | grep GB | awk '{print $6 " s"}')
echo "Nice -n -19 (high priority): " $(cat highpriority.log | grep GB | awk '{print $6 " s"}')

