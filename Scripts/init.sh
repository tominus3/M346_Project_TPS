#!/bin/bash
 
# Script:	init.sh
# Description:	Führt alle Skripts aus
# Author:	Paulo Capelos
# Date:		21.12.2025
  
./CreateInputBucket.sh
 
./CreateOutputBucket.sh
 
./CreateLambdaFunction.sh
 
./CreateS3Trigger.sh


