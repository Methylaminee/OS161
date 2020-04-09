add-auto-load-safe-path /home/methylamine/os161/src/kern/compile/FirstOS/.gdbinit
def dbos161
	dir ../../os161/src/kern/compile/FirstOS
	target remote unix:.sockets/gdb
end
def dbos161t
	dir ../../os161/src/kern/compile/THREADS
	target remote unix:.sockets/gdb
end
dbos161t