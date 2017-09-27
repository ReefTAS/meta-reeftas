#!/bin/bash
REEFTAS_PGDATA=$1
REEFTAS_USER=$2

#create directory for postgresql data
su ${REEFTAS_USER} -c "mkdir -p ${REEFTAS_PGDATA}"
su ${REEFTAS_USER} -c "/usr/bin/initdb -D ${REEFTAS_PGDATA}"
