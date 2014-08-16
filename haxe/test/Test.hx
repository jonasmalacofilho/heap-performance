import haxe.ds.Vector;
import haxe.Timer.stamp;
import Sys.println;

class Test {

    static function insert(heaps : Heaps, no : Int) : Times {
        println("Inserting a MILLION itens");
        var elements = Vector.fromArrayCopy([for (i in 0...no) new Item(i, Std.random(no))]);
        // dheap 
        println("DHeap...");
        var start = stamp();
        var dheap = heaps.dheap;
        for (i in 0...no)
            dheap.insert(elements[i]);
        var dheapTime = stamp() - start;
        // jonas-haxe heap
        println("JHeap...");
        var start = stamp();
        var jheap = heaps.jheap;
        for (i in 0...no)
            jheap.put(elements[i]);
        var jheapTime = stamp() - start;
        // done
        println("Done");
        return {dheap : dheapTime, jheap : jheapTime};
    }

    static function checkProperty(parent : Item, child : Item) {
        return parent.val <= child.val;
    }

    static function buildDHeap() {
        return elebeta.ds.DHeapMacro.createClass( (_ : Test.Item), (_ : {
            override function checkProperty(parent:Test.Item, child:Test.Item):Bool
            {
                return parent.val <= child.val;
            }
        }));
    }

    static function buildJHeap() {
        var heap = new jonas.ds.DAryHeap<Item>(2);
        heap.predicate = checkProperty;
        return heap;
    }

    static function main() {
        //println("Waiting");
        //Sys.stdin().readByte();
        var heaps = {dheap : buildDHeap(), jheap : buildJHeap()};
        println('insertion: ${insert(heaps, MILLION)}');
        //println("Waiting");
        //Sys.stdin().readByte();
    }

    inline
    static var MILLION = 1000000;

}

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

typedef Heaps = {
    var dheap : Dynamic;
    var jheap : Dynamic;
}

typedef Times = {
    var dheap : Float;
    var jheap : Float;
}

