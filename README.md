# HAProxy Firebird Wrapper

Lua library for handle with Firebird database connections.

## Goals

- Encapsulate the logic of knowing **which server to connect to**

## Dependencies

- HAProxy must be compiled with Lua support.
- The lua pgmoon library must be installed.

## Instalation

Copy the `firebird_wrapper.lua` file to the server where you run HAProxy.

## Example

For example, `haproxy.cfg` and `docker-compose.yml` are used to run HAProxy and databases in containers.

1. Start docker test environment:
    ```bash
    docker-compose up -d
    ```

2. Run the following code on the postgreSQL database:
    ```sql
    CREATE TABLE databases (
        id integer NOT NULL,
        name character varying(125),
        host character varying(125)
    );

    INSERT INTO databases VALUES
    (1, '/firebird/data/db1.fdb', 'firebird1'),
    (2, '/firebird/data/db2.fdb', 'firebird2');
    ```

3. Connect to a firebird database through HAProxy:
    ```bash
    isql-fb 127.0.0.1/3050:/firebird/data/db1.fdb -u docker -p docker
    ```

The module will determine which host the database is on.
