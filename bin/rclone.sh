#!/bin/bash

killall rclone

rclone mount OneDrive-L3:Documentos ~/Documentos/l3 &

rclone mount OneDrive-Pessoal:Documentos/_documentos ~/Documentos/pessoal &

