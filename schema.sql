CREATE TABLE cryptokeys (
 idINTEGER PRIMARY KEY,
 domain_id      INT NOT NULL,
 flagsINT NOT NULL,
 activeBOOL,
 contentTEXT
);
CREATE TABLE domainmetadata (
 id INTEGER PRIMARY KEY,
 domain_id       INT NOT NULL,
 kind VARCHAR(16) COLLATE NOCASE,
 contentTEXT
);
CREATE TABLE domains (
  id                INTEGER PRIMARY KEY,
  name              VARCHAR(255) NOT NULL COLLATE NOCASE,
  master            VARCHAR(128) DEFAULT NULL,
  last_check        INTEGER DEFAULT NULL,
  type              VARCHAR(6) NOT NULL,
  notified_serial   INTEGER DEFAULT NULL, 
  account           VARCHAR(40) DEFAULT NULL
);
CREATE TABLE "records" (
  id              INTEGER PRIMARY KEY,
  domain_id       INTEGER DEFAULT NULL,
  name            VARCHAR(255) DEFAULT NULL, 
  type            VARCHAR(10) DEFAULT NULL,
  content         VARCHAR(65535) DEFAULT NULL,
  ttl             INTEGER DEFAULT NULL,
  prio            INTEGER DEFAULT NULL,
  change_date     INTEGER DEFAULT NULL
, ordername      VARCHAR(255), auth bool);
CREATE TABLE supermasters (
  ip          VARCHAR(25) NOT NULL, 
  nameserver  VARCHAR(255) NOT NULL COLLATE NOCASE, 
  account     VARCHAR(40) DEFAULT NULL
);
CREATE TABLE tsigkeys (
 id     INTEGER PRIMARY KEY,
 name       VARCHAR(255) COLLATE NOCASE,
 algorithm  VARCHAR(50) COLLATE NOCASE,
 secret     VARCHAR(255)
);
CREATE TABLE updates (domain_id int not null, name varchar(255) not null, source varchar(255) not null);
CREATE INDEX domain_id ON "records"(domain_id);
CREATE INDEX domainidindex on cryptokeys(domain_id);
CREATE INDEX domainmetaidindex on domainmetadata(domain_id);
CREATE UNIQUE INDEX name_index ON domains(name);
CREATE UNIQUE INDEX namealgoindex on tsigkeys(name, algorithm);
CREATE INDEX nametype_index ON "records"(name,type);
CREATE INDEX orderindex on records(ordername);
CREATE INDEX rec_name_index ON "records"(name);
