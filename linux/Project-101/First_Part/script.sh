#!/bin/bash

while true
do
  read -p 'Please write your file location: ' FILE 
  if [[ $FILE == '' ]]
  then
    echo "Please give a file"
  elif [[ ! -f $FILE ]]
  then
    echo "Please give an existing file"
  else
    break
  fi
done

cat $FILE | grep serdar | grep Terminate | grep -Eo "i-[a-zA-Z0-9]{17}" | sort | uniq > /tmp/result.txt 19  20 echo "Your result is ready under the /tmp/result.txt file"