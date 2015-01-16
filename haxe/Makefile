TARGET?=-java exec/java
HXFLAGS?=-main Test -cp test -cp dheap/lib -cp jonas-haxe/src

PERF_EVENTS?=task-clock,context-switches,cpu-migrations,page-faults,cpu-cycles,instructions,stalled-cycles-frontend,stalled-cycles-backend,cache-references,cache-misses,branches,branch-misses
EXEC?=java -jar exec/java/Test.jar
NELEM?=100000
NIT?=30
NREPEAT?=30

build: test/Test.hx .PHONY
	haxe $(TARGET) $(HXFLAGS)

stat: dheap.perf.stat jheap.perf.stat .PHONY

dheap.perf.stat jheap.perf.stat: %.perf.stat: build
	perf stat -e $(PERF_EVENTS) -r $(NREPEAT) -o $@ $(EXEC) $* $(NELEM) $(NIT)

clean: .PHONY
	rm -rf exec *.perf.stat

.PHONY:

