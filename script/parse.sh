#!/bin/bash

# parse a hosts file with awk and perform a query for each line,
# cycling through a list of DNS servers to avoid overloading them
# define multiple DNS servers to avoid overloading a single one
DNS_SERVERS_POOL="1.1.1.1 8.8.8.8 1.0.0.1 8.8.4.4 84.200.69.80 84.200.70.40 91.239.100.100 89.233.43.71"

### Main
awk -v DNS_SERVERS_POOL="$DNS_SERVERS_POOL" '
function dns_exists(host, dns_server) { 
    cmd = sprintf("nslookup -retry=0 -timeout=0 %s %s | grep -q -F Name", host, dns_server)
    return !system(cmd)
}

BEGIN { 
    # Store the DNS servers in array and keep num_of_servers variable to use in modulo operation
    num_of_servers = split(DNS_SERVERS_POOL, Dns_servers);
}
# Main loop
# Perform a query for each line using a different server each time
# also skip lines (domains) starting with "-"
!/^-/ && /^([a-zA-Z0-9-]*[a-zA-Z0-9]\.)+[a-zA-Z][a-zA-Z]+$/ { 
	# choose the server for this line
    selected_server = Dns_servers[NR % num_of_servers + 1]

	# if the query is successful print the domain
    if( dns_exists($1, selected_server) ) {
		print $1
    }
}'
