# Bitcion-mining-actors
By using actor model in Erlang generating bitcoins

**Submitted by:**

**Kartheek Reddy Gade (58842403)**

**Pavan Siva Sai Savaram (10899684)**

**Problem Definition**

Bitcoins (see http://en.wikipedia.org/wiki/Bitcoin) are the most popular crypto-currency in common use. At their heart, bitcoins use the hardness of cryptographic hashing (for a reference see http://en.wikipedia.org/wiki/Cryptographic Hash Function)to ensure a limited "supply" of coins. In particular, the key component in a bit-coin is an input that, when "hashed" produces an output smaller than a target value. In practice, the comparison values have leading 0's, thus the bitcoin is required to have a given number of leading 0's (to ensure 3 leading 0's, you look for hashes smaller than 0x001000_..._ or smaller or equal to _0x000ff..._.The hash you are required to use is SHA-256. You can check your version against this online hasher:http://www.xorbin.com/tools/sha256-hash-calculator. For example, when the text "COP5615 is a boring class" is hashed, the value fb4431b6a2df71b6cbad961e08fa06ee6fff47e3bc14e977f4b2ea57caee48a4 is obtained. For the coins, you find, check your answer with this calculator to ensure correctness. The goal of this first project is to use Erlang and the Actor Model to build a good solution to this problem that runs well on multi-core machines.

**Implementation :**

Initially the master and worker nodes are registered in the same network pool using shared secure cookie. 

After this the worker nodes who already know the master node and master process name, ping the master node to establish
 a connection for message passing.

Once the connection is established, first the master process is started followed by the worker processes.

**Master:**
