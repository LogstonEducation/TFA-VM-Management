--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: paul; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    user_id integer,
    balance real
);


ALTER TABLE public.accounts OWNER TO paul;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: paul
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO paul;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: paul
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: paul; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    account_id integer,
    total real,
    merchant text
);


ALTER TABLE public.transactions OWNER TO paul;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: paul
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO paul;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: paul
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: paul; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name text,
    join_date date
);


ALTER TABLE public.users OWNER TO paul;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: paul
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO paul;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: paul
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: paul
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: paul
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: paul
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY accounts (id, user_id, balance) FROM stdin;
3	5	50
4	6	70
6	8	90
7	9	100
8	8	25
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('accounts_id_seq', 8, true);


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: paul
--

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


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('transactions_id_seq', 15, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY users (id, name, join_date) FROM stdin;
5	Paul	2017-11-01
6	Zhou	2016-01-25
7	Janet	2015-04-29
8	Urbi	2014-06-09
9	Mary	2013-08-10
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('users_id_seq', 9, true);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: paul; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: paul; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: paul; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: paul
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT account_id_fk FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: paul
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: paul
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM paul;
GRANT ALL ON SCHEMA public TO paul;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

