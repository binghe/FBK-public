set verbose_level 0
set input_file "Factory_BI_bool.smv"
go
go_msat
add_property -l -p "G (!s.fault)"
add_property -l -p "G ((s.bottle_present[2]) -> (s.bottle_ingr1[2] & s.bottle_ingr2[2]))"
build_monitor -x -k 50 -n 0
build_monitor -x -k 50 -n 1
read_trace trace1.xml
read_trace trace2.xml
read_trace trace3.xml
echo tests on trace 1
show_property -n 0
verify_property -x -n 0 1
show_property -n 1
verify_property -x -n 1 1
echo tests on trace 2
show_property -n 0
verify_property -x -n 0 2
show_property -n 1
verify_property -x -n 1 2

echo tests on trace 3
show_property -n 0
heartbeat -x -R -n 0 -s 3.1
heartbeat -x -n 0 -s 3.2
heartbeat -x -n 0 -s 3.3
heartbeat -x -n 0 -s 3.4
heartbeat -x -n 0 -s 3.5
heartbeat -x -r -n 0 -s 3.6
heartbeat -x -n 0 -s 3.7
heartbeat -x -n 0 -s 3.8
heartbeat -x -n 0 -s 3.9

show_property -n 1
heartbeat -x -R -n 1 -s 3.1
heartbeat -x -n 1 -s 3.2
heartbeat -x -n 1 -s 3.3
heartbeat -x -n 1 -s 3.4
heartbeat -x -n 1 -s 3.5
heartbeat -x -n 1 -s 3.6
heartbeat -x -r -n 1 -s 3.7
heartbeat -x -n 1 -s 3.8
heartbeat -x -n 1 -s 3.9

quit