#!/bin/sh -eu

self_dir=`dirname $0`
self_dir=`cd ${self_dir}; pwd`

tmp_dir="${self_dir}/tmp"
server_dir="${tmp_dir}/server"
client_dir="${tmp_dir}/client"
