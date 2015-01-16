HXFLAGS_COMMON=-main Test -cp test -cp dheap/lib -cp jonas-haxe/src
PERF_EVENTS=task-clock,context-switches,cpu-migrations,page-faults,cpu-cycles,instructions,stalled-cycles-frontend,stalled-cycles-backend,cache-references,cache-misses,branches,branch-misses

all: exec .PHONY
exec: exec/testj.jar .PHONY
stat: dheap.perf.stat jheap.perf.stat .PHONY

exec/testj.jar: test/Test.hx
	haxe -java exec/java $(HXFLAGS_COMMON)
	cp exec/java/Test.jar exec/testj.jar

dheap.perf.stat jheap.perf.stat: %.perf.stat: exec/testj.jar
	perf stat -e $(PERF_EVENTS) -r30 -o $@ java -jar exec/testj.jar $* 1000000 30

clean: .PHONY
	rm -rf exec *.perf.stat

.PHONY:

