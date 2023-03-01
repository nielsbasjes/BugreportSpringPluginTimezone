#!/bin/bash

TZ=Europe/Amsterdam  mvn clean package && cp target/timezone-1.0-SNAPSHOT.jar amsterdam.jar
TZ=Australia/Eucla   mvn clean package && cp target/timezone-1.0-SNAPSHOT.jar eucla.jar
TZ=US/Hawaii         mvn clean package && cp target/timezone-1.0-SNAPSHOT.jar hawaii.jar

#diffoscope eucla.jar hawaii.jar
#diffoscope eucla.jar amsterdam.jar

md5sum *jar
