# Bitcion-mining-actors
By using actor model in Erlang generating bitcoins

***Submitted by:***

***Kartheek Reddy Gade (58842403)***

***Pavan Siva Sai Savaram (10899684)***

***Problem Definition***

Bitcoins (see http://en.wikipedia.org/wiki/Bitcoin) are the most popular crypto-currency in common use. At their heart, bitcoins use the hardness of cryptographic hashing (for a reference see http://en.wikipedia.org/wiki/Cryptographic Hash Function)to ensure a limited "supply" of coins. In particular, the key component in a bit-coin is an input that, when "hashed" produces an output smaller than a target value. In practice, the comparison values have leading 0's, thus the bitcoin is required to have a given number of leading 0's (to ensure 3 leading 0's, you look for hashes smaller than 0x001000_..._ or smaller or equal to _0x000ff..._.The hash you are required to use is SHA-256. You can check your version against this online hasher:http://www.xorbin.com/tools/sha256-hash-calculator. For example, when the text "COP5615 is a boring class" is hashed, the value fb4431b6a2df71b6cbad961e08fa06ee6fff47e3bc14e977f4b2ea57caee48a4 is obtained. For the coins, you find, check your answer with this calculator to ensure correctness. The goal of this first project is to use Erlang and the Actor Model to build a good solution to this problem that runs well on multi-core machines.

***Implementation :***

The master and worker nodes are first configured in the same network pool using a shared secure cookie. The worker nodes then ping the master node to establish a connection for message passing since they already know the master node's name and that of the master process. The master process is initiated after the connection has been made, and then the worker processes.
  
  ***Assumptions***

* All nodes should belong to the same network pool and also be aware of the specific cookie that is utilized for secure connections.
* For a successful match, the hash produced should have "K" leading zeros. 
* The number of options increases along with the actors' number, increasing hash generation and the probability of locating the Bitcoins. 
* The Masters has a preset custom time frame of 60,000 milliseconds.

***Size of the work unit***

The number of coins to be mined in this problem has no upper limits, and the employees receive a mining request. We launched 2*log proc worker processes/nodes for bitcoin mining, where logiproc is the total number of logical processors on the machine. To ensure that all worker processes continue to function, we also monitor each worker's process and restart it if necessary.

The work unit is 3 in size. A single worker does,

1. Produces a random worker
2. Performs SHA-256 encoding 
3. Checks the encoded string for number of reading zeroes.

***The result of running your program for input 4***

The below are the coins mined that contain 4 leading zeros.

<img
  src="/src/Images/Screenshot from 2022-09-24 11-34-25.png"
  alt="Master Server"
  title="Optional title"
  style="display: inline-block; margin: 0 auto; max-width: 300px">
  
<img
   src="/src/Images/Screenshot from 2022-09-24 11-34-57.png"
  alt="Master Server"
  title="Optional title"
  style="display: inline-block; margin: 0 auto; max-width: 300px">


***The ratio of CPU time to REAL TIME***

<img
  src="/src/Images/Screenshot from 2022-09-24 11-35-55.png"
  alt="Master Server"
  title="Optional title"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

CPU/Real-time ratio (i.e., CPU time/Real time) = 82.998/36.365=2.2 (\>1, therefore Parallelism exists).

***The coin with the most 0s you managed to find***

The coins with the most 0s we found were 7.

***The largest number of working machines you were able to run your code with.***

Since we only have three machines, we made it work on them. However, we can tweek this code to make it work on numerous machines.

***Conclusion:***

The CPU\_time/Real\_time ratio in the client-server architecture is 2, which is greater than the one obtained while running on a single machine for the same amount of computation. As a result, the introduced multi-system design has improved performance.

   
