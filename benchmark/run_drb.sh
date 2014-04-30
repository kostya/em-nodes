#!/bin/sh

ruby drb_server.rb &
sleep 0.4
ruby drb_client.rb 0 &
ruby drb_client.rb 1 &
ruby drb_client.rb 2 &
ruby drb_client.rb 3 &
ruby drb_client.rb 4 &

