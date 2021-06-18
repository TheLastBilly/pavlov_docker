#!/bin/bash

usermod -u $UID steam
groupmod -g $GID steam

chown -R steam:steam /steam
chown -R steam:steam /home/steam

su - steam -c "/steam/pavlovserver/PavlovServer.sh"