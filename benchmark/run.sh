#!/bin/sh

ruby server.rb &
sleep 0.4
ruby client.rb &
ruby client.rb &
ruby client.rb &
ruby client.rb &
ruby client.rb &
