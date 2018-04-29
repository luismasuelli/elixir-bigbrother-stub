# BigBrother

This one is just a stub of a project, and not a project itself.
This will support:
  - Users, authorization
  - Websockets
  - PostgreSQL

## Installation

Start making your life easier.

Install Docker.  
Create your PG instance:

    $ docker container create --name=chooseAName -p chooseAPort:5432 -it -v chooseAPath:/var/lib/postgresql/data postgres

Now, hands on dirt:

Copy the .env.sample file and use appropriate settings:

  * host: localhost
  * port: whatever you used as chooseAPort
  * user & pass: postgres
  * database: choose a name for your project's database

Then you will always invoke `./emix <args>` instead of `mix <args>`.

Now just run these commands:

    # open a shell, and keep it running
    $ docker container start -i chooseAName
    
    # open another shell
    $ ./emix ecto.create
    $ ./emix ecto.migrate