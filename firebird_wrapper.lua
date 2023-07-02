-- firebird_wrapper: Choose server to connect to Firebird database
-- 
-- Copyright 2023 Leonardo Galves
--
package.path = package.path .. ";pgmoon/src/?.lua"

local pgmoon = require("pgmoon")
local pg = pgmoon.new({
  host = "postgres",
  port = "5432",
  database = "docker",
  user = "docker",
  password = "docker"
})
assert(pg:connect())

local function extract_database_from_tcp_data(line)
  local count = 1
  for word in string.gmatch(line, "([^H$ ]+)") do
    if count == 2 then
      return string.match(word, "/[%/%a%d%.]+")
    end
    count = count + 1
  end
end

local function get_database_host(name)
  local database = pg:query("SELECT host FROM databases WHERE name = " .. pg:escape_literal(name))

  if database[1] then
    return database[1].host
  end

  return nil
end

core.register_action("choose_backend", { "tcp-req" }, function(txn)
  local db_name = extract_database_from_tcp_data(txn.req:line())
  local db_host = get_database_host(db_name)

  if db_host == nil then
    core.Debug(db_name .. " database not found")
    txn:set_var('req.blocked', true)
    return
  end

  core.Debug("Sending to backend " .. db_host)
  txn:set_var("req.backend", db_host)
end)
