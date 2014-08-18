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
        return new elebeta.ds.DHeap<Item>({checkProperty : checkProperty.bind(_, _)});
    }

    static function buildJHeap() {
        var heap = new jonas.ds.DAryHeap<Item>(2);
        heap.predicate = checkProperty.bind(_, _);
        return heap;
    }

    static function main() {
        trace("waiting");
        Sys.stdin().readByte();
        var heaps = {dheap : buildDHeap(), jheap : buildJHeap()};
        println('insertion: ${insert(heaps, MILLION)}');
        trace("waiting");
        Sys.stdin().readByte();
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
    var dheap : elebeta.ds.DHeap<Item>;
    var jheap : jonas.ds.DAryHeap<Item>;
}

typedef Times = {
    var dheap : Float;
    var jheap : Float;
}

