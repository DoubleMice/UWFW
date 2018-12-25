PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE UNSAFE_LOG
(
    client_ip CHAR(128),
local_time data NOT NULL PRIMARY KEY,
server_name CHAR(128),
user_agent CHAR(256),
attack_method CHAR(128),
req_url CHAR(128),
req_data CHAR(128),
rule_tag CHAR(128)
);
COMMIT;