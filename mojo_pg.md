## Mojo::Pg Module


### Postgresql

**Reference:** https://www.tecmint.com/install-postgresql-and-pgadmin-in-ubuntu/

#### Installation

1. Install postgresql

You may need to update your ubuntu repos by doing the following:
```
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

Now you can install:

```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install postgresql
```

2. Check that the postgresql is active, running and enabled.

```bash
$ sudo systemctl is-active postgresql
$ sudo systemctl is-enabled postgresql
$ sudo systemctl status postgresql
```

After the last command, you should see something like this:

```bash
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
     Active: active (exited) since Sat 2021-10-09 07:45:07 MDT; 1 day 9h ago
   Main PID: 11409 (code=exited, status=0/SUCCESS)
      Tasks: 0 (limit: 18807)
     Memory: 0B
     CGroup: /system.slice/postgresql.service

Oct 09 07:45:07 X1Nano systemd[1]: Starting PostgreSQL RDBMS...
Oct 09 07:45:07 X1Nano systemd[1]: Finished PostgreSQL RDBMS.
```

```bash
$ sudo pg_isready
/var/run/postgresql:5432 - accepting connections
```

3. Install pgadmin4 [**Optional:** Do this only if you want a web browser interface to db server]

pgAdmin4 is not available in the Ubuntu repositories. We need to install it 
from the pgAdmin4 APT repository. Start by setting up the repository. Add the 
public key for the repository and create the repository configuration file.

```bash
$ curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
$ sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
```

The install pgadmin4.

```bash
$ sudo apt install pgadmin4
```

The above command will install numerous required packages including Apache2 
webserver to serve the pgadmin4-web application in web mode.

Once the installation is complete, run the web setup script which ships with 
the pgdmin4 binary package, to configure the system to run in web mode. You 
will be prompted to create a pgAdmin4 login email and password. This script 
will configure Apache2 to serve the pgAdmin4 web application which involves 
enabling the WSGI module and configuring the pgAdmin application to mount at 
pgadmin4 on the webserver so you can access it.

```bash
$ sudo /usr/pgadmin4/bin/setup-web.sh

Setting up pgAdmin 4 in web mode on a Debian based platform...
Creating configuration database...
NOTE: Configuring authentication for SERVER mode.

Enter the email address and password to use for the initial pgAdmin user 
account:

Email address: [enter email address]
Password: [enter password]
Retype password: [enter password]
pgAdmin 4 - Application Initialisation
======================================

Creating storage and log directories...
We can now configure the Apache Web server for you. This involves enabling the 
wsgi module and configuring the pgAdmin 4 application to mount at /pgadmin4. Do
you wish to continue (y/n)? y

The Apache web server is running and must be restarted for the pgAdmin 4 
installation to complete. Continue (y/n)? y

Apache successfully restarted. You can now start using pgAdmin 4 in web mode at
http://127.0.0.1/pgadmin4   
```

The server link http://127.0.0.1/pgadmin4 may defer if you are running on a 
server, but this is what you will see on a desktop application. For the
rest of the tutorial, we will write it as http://SERVER_IP/pgadmin4

3a. Test out postgresql and pgadmin.

Open a web browser and type:

```
http://SERVER_IP/pgadmin4
```

3b. You will see a login system in the web pgadmin. Enter the credentials that you
created in step 3 to login.

4. Go back to the command line. (Unsure about this step) You should have a user
called 'postgres' that was created from the earlier process. You can verify by
looking at the /etc/passwd file. If you do have this user, then run the command:

  $ sudo -u postgres psql

You will see the following prompt.

  postgres=# 

Set the password by typing \password.

  postgres=# \password



####Notes from discussion at irc

don't change defaults for user postgresql. Instead create a new user say 
'krismatrix', and set permissions and other details there.

Once a user is created, you can create a databases, a table and data for 
a minimialist dataset. Make sure the user password is complex and secure.

#### pg_hba.conf and postrgresql.conf settings

Before you can create roles/users/group with passwords, you need to modify 
postgres settings to require authentication. Other even if you add a password,
postgres will ignore it.

Make sure to login in to postgres as user postgres.
```
$ sudo -U postgres psql
```

The type:

```
postgres-# show hba_file; show config_file;
              hba_file
-------------------------------------
 /etc/postgresql/14/main/pg_hba.conf
(1 row)

               config_file
-----------------------------------------
 /etc/postgresql/14/main/postgresql.conf
(1 row)

```

Open the pg_hba.conf file. You should see the following in the file:

```
# DO NOT DISABLE!
# If you change this first entry you will need to make sure that the
# database superuser can access the database using some other method.
# Noninteractive access to all databases is required during automatic
# maintenance (custom daily cronjobs, replication, and similar tasks).
#
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

We don't want the METHOD 'peer'. The options are 'peer', 'md5' and 
'scram-sha-256'. Change to 'scram-sha-256'. After you make the change, it
should look something like this:

```
# DO NOT DISABLE!
# If you change this first entry you will need to make sure that the
# database superuser can access the database using some other method.
# Noninteractive access to all databases is required during automatic
# maintenance (custom daily cronjobs, replication, and similar tasks).
#
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
#local   all             all                                     peer
local   all             all                                     scram-sha-256
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     all                                     peer
local   replication     all                                     scram-sha-256
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

Now go to postgresql.conf file. You should see the following line possibly
commented out.

```
#password_encryption = scram-sha-256     # scram-sha-256 or md5
```

Uncomment and makesure the right hand side is set to scram-sha-256.

Exit. You must now restart the postgresql server.

```
$ sudo service postgresql restart
```
#### What are Roles?

Roles can be an individual user or a group. Roles have the ability to grant 
membership to another role.

Roles have 'Attributes' and 'Priviliges'.
- Example Attributes can be SuperUser
- Example Priviliges are read privilege 

```
CREATE ROLE readonly with LOGIN ENCRYPTED PASSWORD 'readonly';
```

Always encrypt when storing a role that can log in.

You can view roles by typing ```\du```.

By default only the creator of the database and the superuser has access to
its objects.

**What are Users?**

Roles, Users and Groups are the same thing in postgres.

Therefore, you can create a role either with:
```
CREATE ROLE readonly with LOGIN ENCRYPTED PASSWORD 'readonly';
```

or 

```
CREATE USER readonly with LOGIN ENCRYPTED PASSWORD 'readonly';
```

You can also create a role/user/group interactively on the bash shell by:

```
$ createuser --interactive
Enter the name of role to add:
Shall the new role be a superuser? (y/n)
Shall the new role be allowed to create databases? (y/n)
Shall the new role be allowed to create more new roles ? (y/n)
```

Should you need to change the password, go into psql and run the query:

```
ALTER ROLE role_name WITH ENCRYPTED PASSWORD 'password';
```

You can test that you are able to login as user by running the following:

```
$ psql -U [user/role/group name] -d [dbname]
```

If it complains that you cannot connect, it is possible you forgot to
set the role to allow login. Go to postgres and run query:

```
ALTER ROLE [role/user/group name] login;
```

#### PRIVILEGES

```
GRANT ALL PRIVILEGES ON <table> TO <user>;
GRANT ALL ON ALL TABLES [IN SCHEMA <schema>] TO <user>;
GRANT [SELECT, UPDATE, INSERT, ... ] ON <table> [IN SCHEMA <schema>] TO <user>;
```

There is also the REVOKE command for removing privileges.

If you want to remove Superuser privileges to a user, do the following:
```
ALTER ROLE [user/role/group name] WITH NOSUPERUSER;
```

#### How to set up database server on production?

You can follow the same initial install stateup mentioned earlier for installing
postgresql. Don't bother with pgadmin. Then do the following:

1. Modify postgres.conf. 
   - Under CONNECTIONS AND AUTHENTICATION set ```listen_addresses = '*'```.
   - Under Authentication set ```password_encryption = scram-sha-256```.
2. Modify pg_hba.conf. 
```
# DO NOT DISABLE!
# If you change this first entry you will need to make sure that the
# database superuser can access the database using some other method.
# Noninteractive access to all databases is required during automatic
# maintenance (custom daily cronjobs, replication, and similar tasks).
#
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
#local   all             all                                     peer
local   all             all                                     scram-sha-256
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             xxx.xxx.xxx.xxx/32      scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     all                                     peer
local   replication     all                                     scram-sha-256
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

The xxx.xxx.xxx.xxx should be the ip of your local laptop or other remote 
machines from which you will connect to this production database server. I
recommended adding IP of your laptop from which you may connect for testing
purposes and add the IP of the web server remote machines. You will need to
add a line each for each ip. Like in other places, you can specify ranges if 
you wish.

3. Restart postgres.
  ``` $ sudo service postgresql restart```

4. Update your firewall to restrict connections from certain ips.

```
$ sudo ufw allow from xxx.xxx.xxx.xxx to any port 5432
```

Verify by typing:

```
$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
2222/tcp                   ALLOW       Anywhere                  
Redis                      ALLOW       38.80.149.51              
Redis                      ALLOW       168.235.80.254            
5432                       ALLOW       38.80.149.51              
5432                       ALLOW       168.235.80.254            
OpenSSH (v6)               ALLOW       Anywhere (v6)             
2222/tcp (v6)              ALLOW       Anywhere (v6)             

```
You should see something like above. Observe 5432 allows access from certain ip.

You are now ready to create new roles, databases, etc in the db server with 
auth.

#### Postgres Data Types

Numbers, Arrays, Character, Date/Time, Boolean, UUID, etc.

Boolean is TRUE and FALSE. Postgres is smart enough to convert 1/0, yes/no,
y/n, etc., to be TRUE or FALSE

Character types are CHAR(N), VARCHAR(N), TEXT. 
  - CHAR is fixed length with padding. 
  - VARCHAR is variable length with max length.
  - TEXT is variable length and unlimited length.

Integers types are SMALLINT, INT, BIGINT.

Floating point types are FLOAT4 or FLOAT8.

DECIMAL/NUMERIC are number types that allow decimal values.

Array is nothing more than a group of elements of the same type. An array is
denoted by a bracket syntax.

#### Naming conventions

Table names must be singular. I.e. name the table 'Employee' (singular) not 
'Employees' (plural).

Column names must be lowercase with underscores. Columns with mixed case are
acceptable. Column with uppercase are unacceptable.


#### Shortcuts

\l - lists databases
\du - lists users/roles/groups
\dn - lists schemas in the current database
\dt - lists tables in the current database
\c or \conninfo - show connection information.

**Rename Database**
```
ALTER DATABASE [dbname] RENAME TO [new dbname];
```

#### Backup and Restore

pgBackRest appears to be a recommended tool for doing backup and restoration.
However postgresql comes with some tools already.

**Backup**
```
$ pg_dump -U [user/role/group name] dbname > dump_file 
```
**Restore**
```
$ psql -U [user/role/group name] dbname < dump_file 
```

**Note:** Test and investigate that you have everything you need.

#### Transactions

BEGIN;  #in psql the start of a transactiona
SQL statements in after  BEGIN are temporary and do not become
permanent until you type END. If you made a mistake during
your transaction, you can ROLLBACK. This must be done before END
however.
END;    # end of a transaction. 

#### Views
Views allow you to store and query previous run queries. There are two types
of views - Materialized and Non-Materialized.

**Non-Materialized Views:** Query gets run each time the view is called on.

**Materialized Views:** Stores the data physically and periodically updates it
when tables change.

Views act like tables and you can query them. Views take very little
space to store. We only store the definition of a view and not all the
data it returns.

```
CREATE OR REPLACE <view name> as query;
```

```
ALTER VIEW <view name> RENAME to <view name>;
```

```
DROP VIEW [IF EXISTS] <view name>;
```

#### Index

Index is like a table of contents or indexing in a book. It helps you find 
where a piece of data is.

There are many types of indexes:
- Single Column
- Multi-Column
- Unique
- Partial
- Implicit indexes

```
CREATE [UNIQUE] INDEX <name> on <table> (column1, column2, ...);
```

```
DROP INDEX <name>;
```

**When to use indexes?**

- Index foreign keys
- Index primary keys and unique columns
- Index on columns that end up in the order by/where clause often.

**When not to use indexes?**

- Don't add an index just to add an index
- Don't use indexes on small tables.
- Don't use tables that are updated frequently.
- Don't use columns that can contain null values.
- Don't use columns that have large values. 

Indexes can slow queries on a table. Use it only if necessary.

#### Subquery

A construct that allows you to build complex queries. It is also called an
inner query or inner select. It is a query within another SQL query mostly 
found in the WHERE clause.

```
SELECT * FROM <table>
WHERE <column>, <condition> (
  SELECT <column>, <column>, ...
  FROM <table>
  [WHERE | GROUP BY | ORDER BY | ...]
);
```

You can also use it in the SELECT, HAVING and FROM clauses.

```
SELECT (
  SELECT <column>, <column>, ...
  FROM <table>
  [WHERE | GROUP BY | ORDER BY | ...]
) -- must return a single record
FROM <table> AS <name>
```

```
SELECT * 
FROM (
  SELECT <column>, <column>, ...
  FROM <table>
  [WHERE | GROUP BY | ORDER BY | ...]
) AS <name>;
```
```
SELECT *
FROM <table> AS <name>
GROUP BY <column>
HAVING (
  SELECT <column>, <column>, ...
  FROM <table>
  [WHERE | GROUP BY | ORDER BY | ...]
) > X
```

Subqueries can return a single result or a row set. Subqueries are 
independent queries.

Join always return row sets. A joined table can be used in an outer join.

Rules around subqueries:
- Must be encapsulated with parentheses ()
- Must be placed on the RHS of comparison operation.
- Cannot manipulate their results internally (ORDER BY is ignored)
- Use single row operators with single row subqueries.
- Subquery that return null may not return results.

Types of Subqueries:
  - Single Row
  - Multiple Row
  - Multiple Column
  - Correlated
  - Nested

#### Additional Misc Notes;

schemas inside databases are like directories in a filesystem, you use them to sort stuff
<peerce> we used schemas when we had multiple apps sharing a database.   each app had its own app role/user,  and a schema with the same name.     each app's private tables were in its own schema, while shared stuff was in public

### Mojo::Pg module

Create a  database connection to postgresql.

```perl
my $db_host = "localhost";
my $db_port = 5432;
my $db_user = "someuser";
my $db_password = "somepassword";
my $dbname = "somedbname";

my $pg = Mojo::Pg->new("postgresql://$db_user:$db_password\@$db_host:$db_port/$dbname");

```

Delete table if it already exists in the database.

```perl

$db->query("DROP TABLE IF EXISTS episode_details;");

```

Create table in the database.

```perl

$db->query("
  CREATE TABLE IF NOT EXISTS episode_list (
    podcast_id serial PRIMARY KEY,    -- unique podcast identifier
    title TEXT UNIQUE NOT NULL,       -- the episode title
    season NUMERIC(5) NOT NULL,       -- season number
    pubDate INT NOT NULL,             -- publish date
    episode TEXT NOT NULL             -- episode number
  );
");

```

Mojo::Pg allows you run sql statements one by one or as a collection. Typically,
running as a collection is optimized for speed. You can run sql statements as 
follows:

```perl
my $db = $pg->db;      #database handler
my $tx = $db->begin;

...                    # sql statement calls.

$tx->commit();

```

When you do a ```$db->begin;```, it is noting that this is the start of a
collection of sql statements. It merely prepares the SQL statements but does
not commit them. When you are done preparing multiple sql statements, you can
then commit them to make changes into the database together. This allows for 
faster execution of code.

Here is a full example.

```perl
#!/usr/bin/perl
use warnings;
use strict;
use Mojo::Pg;

my $db_host = "localhost";
my $db_port = 5432;
my $db_user = "someuser";
my $db_password = "somepassword";
my $dbname = "somedbname";

my $pg = Mojo::Pg->new(
  "postgresql://$db_user:$db_password\@$dbserver_host:$db_port/$dbname");

my $db = $pg->db;      #database handler
my $tx = $db->begin;

# Delete Tables if they exist
$db->query("DROP TABLE IF EXISTS session_details;");
$db->query("DROP TABLE IF EXISTS subscription_details;");
$db->query("DROP TABLE IF EXISTS select_podcasts;");
$db->query("DROP TABLE IF EXISTS userdata;");
$db->query("DROP TABLE IF EXISTS episode_details;");    # must be deleted first
                                                        # because of dependency
                                                        # to episode_list
$db->query("DROP TABLE IF EXISTS episode_list;");

print "Deleted episode_list and episode_details\n";

# Create Table if they don't exist
# github markdown format:
#
#| podcast_id | title                               | season | pubDate    | episode |
#| ---------- | ----------------------------------- | ------ | ---------- | ------- |
#| 1          | Episode 1 - Kakudmi and Time Travel | 1      | 1597663600 | 1       |

$db->query("
  CREATE TABLE IF NOT EXISTS episode_list (
    podcast_id serial PRIMARY KEY,    -- unique podcast identifier
    title TEXT UNIQUE NOT NULL,       -- the episode title
    season NUMERIC(5) NOT NULL,       -- season number
    pubDate INT NOT NULL,             -- publish date
    episode TEXT NOT NULL             -- episode number
  );
");

print "Created episode_list\n";

$db->query("
  CREATE TABLE IF NOT EXISTS episode_details (
    podcast_details_id serial PRIMARY KEY,  -- unique identifier
    alt TEXT NOT NULL,              -- the alt value for podcast <img/>
    imgSrc TEXT NOT NULL,           -- the src value for podcast <img/>
    link2Page TEXT NOT NULL,        -- mojo route to podcast page
    audioSrc TEXT NOT NULL,         -- the src value for podcast <audio/>
    audioRoute TEXT NOT NULL,       -- mojo route to podcast audio
    summary TEXT NOT NULL,          -- a summary of the episode
    artist TEXT NOT NULL,           -- the name of artist (writer) 
    podcast_id INT,
    CONSTRAINT fk_episode_list
      FOREIGN KEY (podcast_id)
        REFERENCES episode_list(podcast_id) -- id that relates episode_details
                                          -- to episode_list
  );
");

$db->query("
  DROP TABLE IF EXISTS userdata;
");

$db->query("
  CREATE TABLE IF NOT EXISTS userdata (
    user_id serial PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    paiduser BOOLEAN,
    authuser BOOLEAN,
    authsecret TEXT
  );
");

print "Created userdata table\n";

$db->query("
  CREATE TABLE IF NOT EXISTS select_podcasts (
    select_podcasts_id serial PRIMARY KEY,
    podcast_id INT,
    FOREIGN KEY (podcast_id)
      REFERENCES episode_list(podcast_id) -- id that relates episode_list
  );
");

print "Created select_podcasts table\n";

$db->query("
  CREATE TABLE IF NOT EXISTS subscription_details (
    sub_details_id serial PRIMARY KEY,
    cs_id TEXT,
    cus_id TEXT,
    sub_id TEXT,
    created TEXT,
    started_at TEXT,
    canceled_at TEXT,
    cancel_at TEXT,
    invoice_id TEXT,
    price_id TEXT,
    amount INT,
    prod_id TEXT,
    subscription_status TEXT
  );
");

print "Created subscription_details table\n";

$db->query("
  CREATE TABLE IF NOT EXISTS session_details (
    session_details_id serial PRIMARY KEY,
    cs_id TEXT,
    user_id INT,
    FOREIGN KEY (user_id)
      REFERENCES userdata(user_id) -- id that relates episode_list
  );
");
print "Created session_details table\n";

$tx->commit;

print "Completed\n";

```

You can also insert data into the database as follows:

```perl
#!/usr/bin/perl
use warnings;
use strict;
use Mojo::Pg;

open(my $fileH, "<", "episodeList.txt")
  or die "Could not open episodeList.txt\n";

###############################################################################
#The format of the data in episodeList.txt is as follows:
# title: This is what will be below the image, sort of like the caption.
# alt: Meant for the reader who uses screen readers.
# imgSrc: Ideally simply the URL of the images to display on top portion of card
# link2Page: The new page to navigate to when you click on the card.
# season: The season number
# pubDate: The date of publishing
# audioSrc: The location of the audio files in my_app/public/ directory.
# audioRoute: The route to the audio in MyApp.pm.
# episode: The pre-fix for the episodeScript files. It will be the same for 
#  references, amznAff, comments.
# summary: summary of the episode
# artist: name of podcast writer
#
#Note: We need both audioSrc and audioRoute, because audioSrc is for internal
# use where the app can grab the data. audioRoute is to create a route for
# people to get to audio files from browser url.
###############################################################################

my $id = 0;
my %record;

while (my $line = <$fileH>) {
  chomp $line;
  if ($line =~ m/^#/) {next}    #skip comment lines
      #For a given episode, the data is packed without blank lines and will be
      # in dictionary format.
  while ($line =~ m/^(\w+)\s*:\s*([^#]*)$/) {
    $record{$id}{$1} = $2;
    $line = <$fileH>;
    chomp $line;
  }
  $id++;
}
close($fileH);

my $db_host = "localhost";
my $db_port = 5432;
my $db_user = "someuser";
my $db_password = "somepassword";
my $dbname = "somedbname";

my $pg = Mojo::Pg->new(
  "postgresql://$db_user:$db_password\@$db_host:$db_port/$dbname");

my $size = keys %record;
print "size = ", $size, "\n";

print "Inserting data into episode_list and episode_details\n";

my $db = $pg->db;

eval {
  my $tx      = $db->begin;
  my $ep_size = keys %record;
  for (my $i = 1; $i <= $size; $i++) {
    $db->query('
      INSERT INTO episode_list (
        title, 
        season, 
        pubDate, 
        episode) 
      VALUES (?,?,?,?);', $record{$i}{title}, $record{$i}{season},
      $record{$i}{pubDate}, $record{$i}{episode});

    $db->query('
      INSERT INTO episode_details (
        alt, 
        imgSrc, 
        link2Page, 
        audioSrc, 
        audioRoute, 
        summary, 
        artist, 
        podcast_id
      ) VALUES (?,?,?,?,?,?,?,?);', $record{$i}{alt}, $record{$i}{imgSrc},
      $record{$i}{link2Page}, $record{$i}{audioSrc}, $record{$i}{audioRoute},
      $record{$i}{summary},   $record{$i}{artist},   $i,);
  }
  $tx->commit;
};

if ($@) {
  print "$@\n";
}

print "Inserting data into select_podcasts\n";
my $tx = $db->begin;
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 5);
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 10);
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 18);
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 6);
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 12);
$db->query('INSERT INTO select_podcasts (podcast_id) VALUES (?);', 11);
$tx->commit;

print "Complete\n";

```
