#!/bin/bash

echo -e $(cat certificate.pem) | tee new.pem
