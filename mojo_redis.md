## Mojo::Redis module

> Redis is an in-memory data structure store, used as a distributed, in-memory
> key–value database, cache and message broker, with optional durability. Redis
> supports different kinds of abstract data structures, such as strings, lists,
> maps, sets, sorted sets, HyperLogLogs, bitmaps, streams, and spatial indices.

Redis is a useful fast cache database. You probably don't want to use it for 
anything that is important or secure as it doesn't appear to have good policies
for security, but if you need a fast and usually temporary storage, it is 
convenient and excellent. 

While, this is not meant to be a detailed tutorial on Redis, and is meant to be
more of a tutorial for how to use the Mojo::Redis module, a brief introductory
tutorial might be wise. The following section are my notes from a course by
Andrew Negaoie from ZeroToMastery.io.

### Redis Tutorial

Use Redis if you want a fast database that is scalable.

#### Installation

Please refer to latest documentation from https://redis.io/download for latest
instructions, but install is simple:

**From the official Ubuntu PPA**
You can install the latest stable version of Redis from the redislabs/redis 
package repository. Add the repository to the apt index, update it and install:

```bash
$ sudo add-apt-repository ppa:redislabs/redis
$ sudo apt-get update
$ sudo apt-get install redis
```

**From Snapcraft**
You can install the latest stable version of Redis from the Snapcraft 
marketplace:

```bash
$ sudo snap install redis
```

#### Redis Commands

First get into the redis client. 

```bash
$ redis-cli
````

Then try these:

```redis
> SET name "Godzilla"
OK
> GET name
"Godzilla"
> Exists name
1
> DEL name
1
> Exists name
0
> Get name
(nil)
> SET session "Jenny"
OK
> EXPIRE session 10
1
> GET session
"Jenny"
> GET session
(nil)
> SET counter 1000
OK
> INCRBY counter 33
(integer) 1033
> GET counter
"1033"
> DECR counter
"1022"
```

#### Redis Data Type


Redis can handle 5 main data types:
a. Strings
b. Hashes
c. Lists
d. Sets
e. Sorted Sets

**String Data types**
MSET is multiple set
MGET is multiple get

```redis
> MSET a 2 b 5
OK
> GET a
"2"
> GET b
"5"
> MGET a b
1) "2"
2) "5"
```

**Hash Data types**
```redis
> MSET a 2 b 5
OK
> GET a
"2"
> GET b
"5"
> MGET a b
1) "2"
2) "5"
> HMSET user id 45 name "Jonny"   #create a hash with key:value
OK
> HGET user id
"45"
> HGET user name
"Jonny"
>HGETALL user
1) "id"
2) "45"
3) "name"
4) "Jonny"
```

**List Data types**
```redis
> LPUSH ourlist 10
(inter) 1
> RPUSH ourlist "hello"
(integer) 2
> LRANGE ourlist 0 1
1) "10"
2) "hello"
> LPUSH ourlist 55
(integer) 3
> LRANGE ourlist 0 1
1) "55"
2) "10"
> LRANGE ourlist 0 2
1) "55"
2) "10"
3) "hello"
> RPOP ourlist
"hello"
> LRANGE outlist 0 2
1) "55"
2) "10"
```

**Sets and Sorted Sets Data types**
Sets are unordered collection of strings.

Sets are similar to lists, but won't allow duplicate entries.

```redis
> SADD ourset 1 2 3 4 5
(integer) 5
> SMEMBERS ourset
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
> SADD ourset 1 2 3 4
(integer) 0
> SMEMBERS ourset
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
> SISMEMBER ourset 5        #5 is a member of ourset
(integer) 1
> SISMEMBER ourset 20       #20 is not a member of ourset
(integer) 0

                            #following are sorted sets.
> ZADD team 50 "Wizards"
(integer) 1
> ZADD team 40 "Cavaliers"
(integer) 1
> ZRANGE team 0 1
1) "Cavaliers"
2) "Wizards"
> ZADD team 1 "Bolts"
(integer) 1
> ZRANGE team 0 2
1) "Bolts"
2) "Cavaliers"
3) "Wizards"
```

#### UFW effort 

First, create a new profile for Redis:

```bash
$ sudo nano /etc/ufw/applications.d/redis
```

Add the following contents:

```redis
[Redis]
title=Persistent key-value database with network interface
description=Redis is a key-value database in a similar vein to memcache but the dataset is non-volatile.
ports=6379/tcp
```

After saving this file, the application profile should magically become available. We can verify it now exists:

```bash
$ sudo ufw app list | grep -i redis
Redis
```

If the application profile is not there, we can force an update:

```bash
$ sudo ufw app update Redis
```

Next, we can review the new Redis profile that was added:

```bash
$ sudo ufw app info Redis
Profile: Redis
Title: Persistent key-value database with network interface
Description: Redis is a key-value database in a similar vein to memcache
but the dataset is non-volatile.

Port:
  6379/tcp
```

Fabulous! We are ready to use our new Redis application profile:

```bash
$ sudo ufw allow from IPADDR to any app Redis
```

The IPADDR can be found by going to your machine (local or remote) and typing:

```bash
$ curl -4 icanhazip.com
```

In this document, we are using IPADDR = 192.168.0.0/16  (which is range of 16).

#### Redis.conf

Refer to digitalocean docs if needed:
https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04

After install of redis.

```bash
$ sudo vim /etc/redis/redis.conf
```

In that file change supervised auto to supervised systemd.

```bash
$ sudo systemctl enable redis-server

$ sudo systemctl restart redis.service
```

Step 2 - Testing Redis

```bash
$ sudo systemctl status redis

Output
● redis-server.service - Advanced key-value store
     Loaded: loaded (/lib/systemd/system/redis-server.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2020-04-30 23:26:54 UTC; 4s ago
       Docs: http://redis.io/documentation,
             man:redis-server(1)
    Process: 36552 ExecStart=/usr/bin/redis-server /etc/redis/redis.conf (code=exited, status=0/SUCCESS)
   Main PID: 36561 (redis-server)
      Tasks: 4 (limit: 2345)
     Memory: 1.8M
     CGroup: /system.slice/redis-server.service
             └─36561 /usr/bin/redis-server 127.0.0.1:6379
. . .
```

Here, you can see that Redis is running and is already enabled, meaning that it
is set to start up every time the server boots.

**Note:** This setting is desirable for many common use cases of Redis. If, 
however, you prefer to start up Redis manually every time your server boots,
you can configure this with the following command:

```bash
$ sudo systemctl disable redis
```

To test that Redis is functioning correctly, connect to the server using 
redis-cli, Redis’s command-line client:

```bash
$ redis-cli
```

In the prompt that follows, test connectivity with the ping command:
```
127.0.0.1:6379> ping
 
Output
PONG
```

This output confirms that the server connection is still alive. Next, check 
that you’re able to set keys by running:

```
127.0.0.1:6379> set test "It's working!"

Output
OK
```

Retrieve the value by typing:

```
127.0.0.1:6379> get test
```

Assuming everything is working, you will be able to retrieve the value you 
stored:
```
Output
"It's working!"
```

After confirming that you can fetch the value, exit the Redis prompt to get 
back to the shell:
```
127.0.0.1:6379> exit
```
As a final test, we will check whether Redis is able to persist data even 
after it’s been stopped or restarted. To do this, first restart the Redis 
instance:
```bash
$ sudo systemctl restart redis
```
Then connect with the command-line client again:
```
$ redis-cli
```
And confirm that your test value is still available
```
127.0.0.1:6379> get test
```
The value of your key should still be accessible:
```
Output
"It's working!"
```
Exit out into the shell again when you are finished:
```
127.0.0.1:6379> exit
```

#### Test Redis firewall connection

Let's review our complete firewall status using the verbose option to see the 
complete details:

```bash
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.0.0/16
80/tcp                     ALLOW IN    192.168.0.0/16
137,138/udp (Samba)        ALLOW IN    192.168.0.0/16
139,445/tcp (Samba)        ALLOW IN    192.168.0.0/16
6379/tcp (Redis)           ALLOW IN    192.168.0.0/16
```

Redis is in there and we are ready for our final test!

Finally, use the redis-cli to connect from a different machine (called host2 
in our example):

```bash
[host2]$ redis-cli -h 192.168.1.7
192.168.1.7:6379>
```

Hooray! We can connect to the Redis server from a different machine on our 
network!

**How to make additional changes**

If we need to make additional changes, we can review the rules by number and 
delete as needed:

```bash
$  sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    192.168.0.0/16
[ 2] 80/tcp                     ALLOW IN    192.168.0.0/16
[ 3] Samba                      ALLOW IN    192.168.0.0/16
[ 4] Redis                      ALLOW IN    192.168.0.0/16
```

For example, I can delete rule #4 for Redis:

```bash
$  sudo ufw delete 4
```

I can also add a new rule in position 2 for https traffic (port 443)

```bash
$ sudo ufw insert 2 allow from 192.168.0.0/16 to any port 443 proto tcp
```

...and review the result

```bash
$  sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    192.168.0.0/16
[ 2] 443/tcp                    ALLOW IN    192.168.0.0/16
[ 3] 80/tcp                     ALLOW IN    192.168.0.0/16
[ 4] Samba                      ALLOW IN    192.168.0.0/16
```

Let's take rule 2 back out and put Redis back in:

```bash
$ sudo ufw delete 2
$ sudo ufw allow from 192.168.0.0/16 to any app Redis
```
... and review the new results:

```bash
$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    192.168.0.0/16
[ 2] 80/tcp                     ALLOW IN    192.168.0.0/16
[ 3] Samba                      ALLOW IN    192.168.0.0/16
[ 4] Redis                      ALLOW IN    192.168.0.0/16
```

Everything looks great and we have victory!

### How to use Mojo::Redis?

Mojo::Redis is a module that you want to use as part of the Mojolicious Web
framework when you want your web app to use the Redis database.

As with most databases, you have the following steps:
1. Establish a connection to a dataase.

```perl
my $redis = Mojo::Redis->new("redis://localhost:6379/");  # port 6379 is the default port of redis. 

```
2. Add and store some data.

```perl
$redis->db->set("key" => "value);
```

3. Optionally, you can set the data to auto-expire.

```perl
$redis->db->expire("key" => 1800);
```

3. Get data from redis database.

```perl
$redis->db->get("key");
```

**Reference:** https://metacpan.org/pod/Mojo::Redis
