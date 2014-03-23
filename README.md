# Jparallel

Easy parallel processing.

So I like the interface of https://github.com/grosser/parallel , but their test suite doesn't pass on Jruby (Even though the functions seem to work fine on it).  I looked at https://github.com/bruceadams/pmap and I wanted to extend it to handle `each_with_index` for a task and couldn't figure out right away how to go about it.  This repo is the result of me just getting what I want working on jruby.

The implementation right now doesn't require JRuby since I'm using the [thread-pool library by meh](https://github.com/meh/ruby-thread).

Big-time thanks to https://github.com/mohamedhafez for his suggestions in the issue tracker and his [parallelizer](https://github.com/mohamedhafez/parallelizer) library that is implented partly in pure Java.

## How it works

Jparallel currently supports processing over arrays and hashes.  It uses thread pools, and must be told the size of the pool.  Create a new object of the JParallel class and send your input data and block to it

If something on the collection throws an error, that error object will be part of the final collection that is returned back.

```ruby
jp = Jparallel.new size_of_thread_pool
```

### Arrays

```ruby
jp.map([1,2,3,4,5]) { |x| x * 2 }
# -> [2,4,6,8,10]

jp.map([2,1,0]) { |x| 12 / x }
# -> [6, 12, #<ZeroDivisionError: divided by 0>]

jp.map_with_index(input_array) { |x, index| do_stuff_with_x_and_index }
# Mimics Array#each_with_index#map
```

### Hashes
Input a hash, and get back a hash.  Like it should be.  This method returns exceptions as part of the collection too.
```ruby
jp.hashmap({a: 1, b: 2}) {|x,y| "#{x} -> #{y}" }
# -> {:a=>"a -> 1", :b=>"b -> 2"}
```

## Licence
This library is licenced under the GNU Lesser General Public Licence, version 3 or later.