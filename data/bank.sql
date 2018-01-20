--
-- PostgreSQL database dump
--

CREATE TABLE accounts (
    id integer NOT NULL,
    user_id integer,
    balance real
);

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;

CREATE TABLE transactions (
    id integer NOT NULL,
    account_id integer,
    total real,
    merchant text
);

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;

CREATE TABLE users (
    id integer NOT NULL,
    name text,
    join_date date
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

COPY accounts (id, user_id, balance) FROM stdin;
2	5	50
3	6	50
4	6	70
6	8	90
7	9	100
8	8	25
\.

SELECT pg_catalog.setval('accounts_id_seq', 8, true);

COPY transactions (id, account_id, total, merchant) FROM stdin;
3	3	-45	H&M
4	3	-5	Subway
5	3	10	deposit
6	4	15	deposit
7	4	-7	Walgreens
8	4	-15	Trader Joes
10	6	-5	Trader Joes
11	6	-9	Kitty Corner Bodega
12	6	-3	Kitty Corner Bodega
13	7	11	deposit
14	7	8	deposit
15	8	25	deposit
\.

SELECT pg_catalog.setval('transactions_id_seq', 15, true);

COPY users (id, name, join_date) FROM stdin;
5	Paul	2017-11-01
6	Zhou	2016-01-25
7	Janet	2015-04-29
8	Urbi	2014-06-09
9	Mary	2013-08-10
\.

SELECT pg_catalog.setval('users_id_seq', 9, true);

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY transactions
    ADD CONSTRAINT account_id_fk FOREIGN KEY (account_id) REFERENCES accounts(id);

ALTER TABLE ONLY accounts
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);

