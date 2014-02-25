# Jparallel #

Easy parallel processing for Jruby.

I like the interface of https://github.com/grosser/parallel , but their test suite doesn't pass on Jruby (Even though the functions seem to work fine on it).  I looked at https://github.com/bruceadams/pmap and I wanted to extend it to handle `each_with_index` for a task and couldn't figure out right away how to go about it.  This repo is the result of me just getting what I want working on jruby.

## Api ##

Jparallel currently supports processing over arrays and hashes.  It uses thread pools, and can be told the size of the pool.  If you don't specify a pool-size, then it uses all available processes (As determined by the JVM).

### Arrays ###

```ruby
Jparallel.map([1,2,3,4,5], optional_poolsize) { |x| x * 2 }
--> [2,4,6,8,10]
```

### Hashes ###
```ruby
Jparallel.hashmap({a: 1, b: 2}, optional_poolsize) {|x,y| "#{x} -> #{y}" }
--> {:a=>"a -> 1", :b=>"b -> 2"}
```

## Licence ##
This library is licenced under the GNU Lesser General Public Licence, version 3 or later.