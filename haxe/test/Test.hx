import Std.random;
import Sys.println;
import haxe.Timer.stamp;
import haxe.ds.Vector;
import Std.parseInt;

@:publicFields
class Item {
    var id : Int;
    var val : Int;
    var pos : Int;
    
    inline
    function new(id, val) {
        this.id = id;
        this.val = val;
    }
}

typedef Data = Vector<Item>;

class Test {
    static inline var UPDATE_INTERVAL = 2;

    static function checkProperty(parent : Item, child : Item)
    {
        return parent.val <= child.val;
    }

    static function execDheap(data:Data)
    {
        var heap = new elebeta.ds.DHeap<Item>({
            checkProperty : checkProperty.bind(_, _)
        });
        var n = data.length;
        for (i in 0...n)
            heap.insert(data[i]);
    }

    static function execJheap(data:Data)
    {
        var heap = new jonas.ds.DAryHeap<Item>(2);
        heap.predicate = checkProperty.bind(_, _);
        var n = data.length;
        for (i in 0...n)
            heap.put(data[i]);
    }

    static function execDummy(data) {}

    static function printResults(r:{ it:Int, time:Float })
    {
        println('------------------------------');
        println('Iterations: ${r.it}');
        println('Total time: ${r.time}s');
        println('Average time/iteration: ${r.time/r.it}s');
    }

    static function main()
    {
#if interp
        var args = "dheap,10000,10".split(",");
#else
        var args = Sys.args();
#end

        function getArg(idx, ?or)
        {
            return
                if (idx < args.length)
                    args[idx];
                else if (or != null)
                    or;
                else
                    throw 'Missing argument #${idx+1}';
        }

        var heap = getArg(0, "dheap").toLowerCase();
        var noElements = parseInt(getArg(1, "1000000"));
        var noIterations = parseInt(getArg(2, "-1"));
        println('==============================');
        println('Heap type: $heap');
        println('Number of elements: $noElements');
        println('Number of iterations: $noIterations');

        var exec = switch (heap) {
        case "dheap": execDheap.bind(_);
        case "jheap": execJheap.bind(_);
        case "empty", "none", "dummy": execDummy.bind(_);
        case _: throw 'No heap type: $heap';
        }

        var data = Vector.fromArrayCopy([for (i in 0...noElements) new Item(i, random(noElements))]);

        var lastPrint = stamp();
        var it = 0, time = 0.;
        while (noIterations < 0 || it < noIterations) {
            var t = stamp();
            exec(data);
            var nt = stamp();

            time += nt - t;
            it++;
            if (nt - lastPrint > UPDATE_INTERVAL) {
                printResults({ it : it, time : time });
                lastPrint = nt;
            }
        }
        printResults({ it : it, time : time });
    }
}

