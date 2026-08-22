--
-- PostgreSQL database dump
--

\restrict brYgBapLIBUGavihiFdgheIY4l7SuA4lOYbR5XfpkYBB5f9Y8mQxTmkOc9Pi6fL

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.transfers DROP CONSTRAINT IF EXISTS transfers_to_stop_id_fkey;
ALTER TABLE IF EXISTS ONLY public.transfers DROP CONSTRAINT IF EXISTS transfers_from_stop_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routing_nodes DROP CONSTRAINT IF EXISTS routing_nodes_stop_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routing_nodes DROP CONSTRAINT IF EXISTS routing_nodes_route_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routing_edges DROP CONSTRAINT IF EXISTS routing_edges_target_fkey;
ALTER TABLE IF EXISTS ONLY public.routing_edges DROP CONSTRAINT IF EXISTS routing_edges_source_fkey;
ALTER TABLE IF EXISTS ONLY public.routing_edges DROP CONSTRAINT IF EXISTS routing_edges_route_id_fkey;
ALTER TABLE IF EXISTS ONLY public.route_stops DROP CONSTRAINT IF EXISTS route_stops_stop_id_fkey;
ALTER TABLE IF EXISTS ONLY public.route_stops DROP CONSTRAINT IF EXISTS route_stops_route_id_fkey;
DROP INDEX IF EXISTS public.ix_users_email;
DROP INDEX IF EXISTS public.idx_stops_name_lower;
DROP INDEX IF EXISTS public.idx_stops_geom;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.transfers DROP CONSTRAINT IF EXISTS transfers_pkey;
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_pkey;
ALTER TABLE IF EXISTS ONLY public.routing_nodes DROP CONSTRAINT IF EXISTS routing_nodes_pkey;
ALTER TABLE IF EXISTS ONLY public.routing_edges DROP CONSTRAINT IF EXISTS routing_edges_pkey;
ALTER TABLE IF EXISTS ONLY public.routes DROP CONSTRAINT IF EXISTS routes_pkey;
ALTER TABLE IF EXISTS ONLY public.route_stops DROP CONSTRAINT IF EXISTS route_stops_pkey;
ALTER TABLE IF EXISTS public.transfers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.routing_nodes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.routing_edges ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.route_stops ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.transfers_id_seq;
DROP TABLE IF EXISTS public.transfers;
DROP TABLE IF EXISTS public.stops;
DROP SEQUENCE IF EXISTS public.routing_nodes_id_seq;
DROP TABLE IF EXISTS public.routing_nodes;
DROP SEQUENCE IF EXISTS public.routing_edges_id_seq;
DROP TABLE IF EXISTS public.routing_edges;
DROP TABLE IF EXISTS public.routes;
DROP SEQUENCE IF EXISTS public.route_stops_id_seq;
DROP TABLE IF EXISTS public.route_stops;
DROP EXTENSION IF EXISTS pgrouting;
DROP EXTENSION IF EXISTS postgis;
--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: pgrouting; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrouting WITH SCHEMA public;


--
-- Name: EXTENSION pgrouting; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgrouting IS 'pgRouting Extension';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: route_stops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.route_stops (
    id integer NOT NULL,
    route_id character varying(100) NOT NULL,
    stop_id character varying(100) NOT NULL,
    stop_order integer NOT NULL,
    distance_from_prev_km double precision
);


--
-- Name: route_stops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.route_stops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: route_stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.route_stops_id_seq OWNED BY public.route_stops.id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routes (
    id character varying(100) NOT NULL,
    name text NOT NULL,
    operator text,
    vehicle_type character varying(20),
    color character varying(7)
);


--
-- Name: routing_edges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routing_edges (
    id integer NOT NULL,
    source integer NOT NULL,
    target integer NOT NULL,
    route_id character varying(100),
    cost_time double precision NOT NULL,
    cost_transfers double precision NOT NULL,
    distance_km double precision NOT NULL,
    is_transfer integer,
    reverse_cost double precision
);


--
-- Name: routing_edges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.routing_edges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routing_edges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.routing_edges_id_seq OWNED BY public.routing_edges.id;


--
-- Name: routing_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routing_nodes (
    id integer NOT NULL,
    stop_id character varying(100) NOT NULL,
    route_id character varying(100),
    lat double precision NOT NULL,
    lon double precision NOT NULL
);


--
-- Name: routing_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.routing_nodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routing_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.routing_nodes_id_seq OWNED BY public.routing_nodes.id;


--
-- Name: stops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stops (
    id character varying(100) NOT NULL,
    name text NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    geom public.geometry(Point,4326)
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfers (
    id integer NOT NULL,
    from_stop_id character varying(100) NOT NULL,
    to_stop_id character varying(100) NOT NULL,
    walking_time_min integer,
    walking_distance_m integer
);


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying(36) NOT NULL,
    name character varying(120) NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    reset_otp_hash character varying(255),
    reset_otp_expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    profile_image_filename character varying(255)
);


--
-- Name: route_stops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.route_stops ALTER COLUMN id SET DEFAULT nextval('public.route_stops_id_seq'::regclass);


--
-- Name: routing_edges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_edges ALTER COLUMN id SET DEFAULT nextval('public.routing_edges_id_seq'::regclass);


--
-- Name: routing_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_nodes ALTER COLUMN id SET DEFAULT nextval('public.routing_nodes_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Data for Name: route_stops; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.route_stops (id, route_id, stop_id, stop_order, distance_from_prev_km) FROM stdin;
1	Sajha_R1_Lagankhel_Gongabu	S1	1	0
2	Sajha_R1_Lagankhel_Gongabu	S2	2	0
3	Sajha_R1_Lagankhel_Gongabu	S3	3	0
4	Sajha_R1_Lagankhel_Gongabu	S4	4	0
5	Sajha_R1_Lagankhel_Gongabu	S5	5	0
6	Sajha_R1_Lagankhel_Gongabu	S6	6	0
7	Sajha_R1_Lagankhel_Gongabu	S7	7	0
8	Sajha_R1_Lagankhel_Gongabu	S8	8	0
9	Sajha_R1_Lagankhel_Gongabu	S9	9	0
10	Sajha_R1_Lagankhel_Gongabu	S10	10	0
11	Sajha_R1_Lagankhel_Gongabu	S11	11	0
12	Sajha_R1_Lagankhel_Gongabu	S12	12	0
13	Sajha_R1_Lagankhel_Gongabu	S13	13	0
14	Sajha_R1_Lagankhel_Gongabu	S14	14	0
15	Sajha_R1_Lagankhel_Gongabu	S15	15	0
16	Sajha_R1_Lagankhel_Gongabu	S16	16	0
17	Sajha_R1_Lagankhel_Gongabu	S17	17	0
18	Sajha_R1_Lagankhel_Gongabu	S18	18	0
19	Sajha_R1_Lagankhel_Gongabu	S19	19	0
20	Sajha_R1_Lagankhel_Gongabu	S20	20	0
21	Sajha_R1_Gongabu_Lagankhel	S20	1	0
22	Sajha_R1_Gongabu_Lagankhel	S19	2	0
23	Sajha_R1_Gongabu_Lagankhel	S18	3	0
24	Sajha_R1_Gongabu_Lagankhel	S17	4	0
25	Sajha_R1_Gongabu_Lagankhel	S16	5	0
26	Sajha_R1_Gongabu_Lagankhel	S15	6	0
27	Sajha_R1_Gongabu_Lagankhel	S14	7	0
28	Sajha_R1_Gongabu_Lagankhel	S13	8	0
29	Sajha_R1_Gongabu_Lagankhel	S12	9	0
30	Sajha_R1_Gongabu_Lagankhel	S11	10	0
31	Sajha_R1_Gongabu_Lagankhel	S10	11	0
32	Sajha_R1_Gongabu_Lagankhel	S9	12	0
33	Sajha_R1_Gongabu_Lagankhel	S21	13	0
34	Sajha_R1_Gongabu_Lagankhel	S22	14	0
35	Sajha_R1_Gongabu_Lagankhel	S23	15	0
36	Sajha_R1_Gongabu_Lagankhel	S7	16	0
37	Sajha_R1_Gongabu_Lagankhel	S6	17	0
38	Sajha_R1_Gongabu_Lagankhel	S5	18	0
39	Sajha_R1_Gongabu_Lagankhel	S4	19	0
40	Sajha_R1_Gongabu_Lagankhel	S3	20	0
41	Sajha_R1_Gongabu_Lagankhel	S2	21	0
42	Sajha_R1_Gongabu_Lagankhel	S1	22	0
43	Sajha_R2_Lagankhel_Budhanilkantha	S1	1	0
44	Sajha_R2_Lagankhel_Budhanilkantha	S2	2	0
45	Sajha_R2_Lagankhel_Budhanilkantha	S3	3	0
46	Sajha_R2_Lagankhel_Budhanilkantha	S4	4	0
47	Sajha_R2_Lagankhel_Budhanilkantha	S5	5	0
48	Sajha_R2_Lagankhel_Budhanilkantha	S6	6	0
49	Sajha_R2_Lagankhel_Budhanilkantha	S7	7	0
50	Sajha_R2_Lagankhel_Budhanilkantha	S8	8	0
51	Sajha_R2_Lagankhel_Budhanilkantha	S9	9	0
52	Sajha_R2_Lagankhel_Budhanilkantha	S10	10	0
53	Sajha_R2_Lagankhel_Budhanilkantha	S11	11	0
54	Sajha_R2_Lagankhel_Budhanilkantha	S12	12	0
55	Sajha_R2_Lagankhel_Budhanilkantha	S13	13	0
56	Sajha_R2_Lagankhel_Budhanilkantha	S14	14	0
57	Sajha_R2_Lagankhel_Budhanilkantha	S15	15	0
58	Sajha_R2_Lagankhel_Budhanilkantha	S24	16	0
59	Sajha_R2_Lagankhel_Budhanilkantha	S25	17	0
60	Sajha_R2_Lagankhel_Budhanilkantha	S26	18	0
61	Sajha_R2_Lagankhel_Budhanilkantha	S27	19	0
62	Sajha_R2_Lagankhel_Budhanilkantha	S28	20	0
63	Sajha_R2_Lagankhel_Budhanilkantha	S29	21	0
64	Sajha_R2_Lagankhel_Budhanilkantha	S30	22	0
65	Sajha_R2_Lagankhel_Budhanilkantha	S31	23	0
66	Sajha_R2_Lagankhel_Budhanilkantha	S32	24	0
67	Sajha_R2_Lagankhel_Budhanilkantha	S33	25	0
68	Sajha_R2_Budhanilkantha_Lagnakhel	S33	1	0
69	Sajha_R2_Budhanilkantha_Lagnakhel	S32	2	0
70	Sajha_R2_Budhanilkantha_Lagnakhel	S31	3	0
71	Sajha_R2_Budhanilkantha_Lagnakhel	S30	4	0
72	Sajha_R2_Budhanilkantha_Lagnakhel	S29	5	0
73	Sajha_R2_Budhanilkantha_Lagnakhel	S28	6	0
74	Sajha_R2_Budhanilkantha_Lagnakhel	S27	7	0
75	Sajha_R2_Budhanilkantha_Lagnakhel	S26	8	0
76	Sajha_R2_Budhanilkantha_Lagnakhel	S25	9	0
77	Sajha_R2_Budhanilkantha_Lagnakhel	S24	10	0
78	Sajha_R2_Budhanilkantha_Lagnakhel	S15	11	0
79	Sajha_R2_Budhanilkantha_Lagnakhel	S14	12	0
80	Sajha_R2_Budhanilkantha_Lagnakhel	S13	13	0
81	Sajha_R2_Budhanilkantha_Lagnakhel	S12	14	0
82	Sajha_R2_Budhanilkantha_Lagnakhel	S11	15	0
83	Sajha_R2_Budhanilkantha_Lagnakhel	S10	16	0
84	Sajha_R2_Budhanilkantha_Lagnakhel	S9	17	0
85	Sajha_R2_Budhanilkantha_Lagnakhel	S21	18	0
86	Sajha_R2_Budhanilkantha_Lagnakhel	S22	19	0
87	Sajha_R2_Budhanilkantha_Lagnakhel	S23	20	0
88	Sajha_R2_Budhanilkantha_Lagnakhel	S7	21	0
89	Sajha_R2_Budhanilkantha_Lagnakhel	S6	22	0
90	Sajha_R2_Budhanilkantha_Lagnakhel	S5	23	0
91	Sajha_R2_Budhanilkantha_Lagnakhel	S4	24	0
92	Sajha_R2_Budhanilkantha_Lagnakhel	S3	25	0
93	Sajha_R2_Budhanilkantha_Lagnakhel	S2	26	0
94	Sajha_R2_Budhanilkantha_Lagnakhel	S1	27	0
95	Sajha_R3_Godawari_RNAC	S34	1	0
96	Sajha_R3_Godawari_RNAC	S35	2	0
97	Sajha_R3_Godawari_RNAC	S36	3	0
98	Sajha_R3_Godawari_RNAC	S37	4	0
99	Sajha_R3_Godawari_RNAC	S38	5	0
100	Sajha_R3_Godawari_RNAC	S39	6	0
101	Sajha_R3_Godawari_RNAC	S40	7	0
102	Sajha_R3_Godawari_RNAC	S1	8	0
103	Sajha_R3_Godawari_RNAC	S2	9	0
104	Sajha_R3_Godawari_RNAC	S3	10	0
105	Sajha_R3_Godawari_RNAC	S4	11	0
106	Sajha_R3_Godawari_RNAC	S5	12	0
107	Sajha_R3_Godawari_RNAC	S6	13	0
108	Sajha_R3_Godawari_RNAC	S7	14	0
109	Sajha_R3_Godawari_RNAC	S8	15	0
110	Sajha_R3_RNAC_Godawari	S8	1	0
111	Sajha_R3_RNAC_Godawari	S21	2	0
112	Sajha_R3_RNAC_Godawari	S22	3	0
113	Sajha_R3_RNAC_Godawari	S23	4	0
114	Sajha_R3_RNAC_Godawari	S7	5	0
115	Sajha_R3_RNAC_Godawari	S6	6	0
116	Sajha_R3_RNAC_Godawari	S5	7	0
117	Sajha_R3_RNAC_Godawari	S4	8	0
118	Sajha_R3_RNAC_Godawari	S3	9	0
119	Sajha_R3_RNAC_Godawari	S2	10	0
120	Sajha_R3_RNAC_Godawari	S1	11	0
121	Sajha_R3_RNAC_Godawari	S40	12	0
122	Sajha_R3_RNAC_Godawari	S39	13	0
123	Sajha_R3_RNAC_Godawari	S38	14	0
124	Sajha_R3_RNAC_Godawari	S37	15	0
125	Sajha_R3_RNAC_Godawari	S36	16	0
126	Sajha_R3_RNAC_Godawari	S35	17	0
127	Sajha_R3_RNAC_Godawari	S34	18	0
128	Sajha_R4_Lamatar_RNAC	S41	1	0
129	Sajha_R4_Lamatar_RNAC	S42	2	0
130	Sajha_R4_Lamatar_RNAC	S43	3	0
131	Sajha_R4_Lamatar_RNAC	S44	4	0
132	Sajha_R4_Lamatar_RNAC	S45	5	0
133	Sajha_R4_Lamatar_RNAC	S46	6	0
134	Sajha_R4_Lamatar_RNAC	S47	7	0
135	Sajha_R4_Lamatar_RNAC	S48	8	0
136	Sajha_R4_Lamatar_RNAC	S49	9	0
137	Sajha_R4_Lamatar_RNAC	S50	10	0
138	Sajha_R4_Lamatar_RNAC	S51	11	0
139	Sajha_R4_Lamatar_RNAC	S52	12	0
140	Sajha_R4_Lamatar_RNAC	S53	13	0
141	Sajha_R4_Lamatar_RNAC	S54	14	0
142	Sajha_R4_Lamatar_RNAC	S55	15	0
143	Sajha_R4_Lamatar_RNAC	S56	16	0
144	Sajha_R4_Lamatar_RNAC	S57	17	0
145	Sajha_R4_Lamatar_RNAC	S58	18	0
146	Sajha_R4_Lamatar_RNAC	S59	19	0
147	Sajha_R4_Lamatar_RNAC	S40	20	0
148	Sajha_R4_Lamatar_RNAC	S1	21	0
149	Sajha_R4_Lamatar_RNAC	S2	22	0
150	Sajha_R4_Lamatar_RNAC	S3	23	0
151	Sajha_R4_Lamatar_RNAC	S4	24	0
152	Sajha_R4_Lamatar_RNAC	S5	25	0
153	Sajha_R4_Lamatar_RNAC	S6	26	0
154	Sajha_R4_Lamatar_RNAC	S7	27	0
155	Sajha_R4_Lamatar_RNAC	S8	28	0
156	Sajha_R4_RNAC_Lamatar	S8	1	0
157	Sajha_R4_RNAC_Lamatar	S21	2	0
158	Sajha_R4_RNAC_Lamatar	S22	3	0
159	Sajha_R4_RNAC_Lamatar	S23	4	0
160	Sajha_R4_RNAC_Lamatar	S7	5	0
161	Sajha_R4_RNAC_Lamatar	S6	6	0
162	Sajha_R4_RNAC_Lamatar	S5	7	0
163	Sajha_R4_RNAC_Lamatar	S4	8	0
164	Sajha_R4_RNAC_Lamatar	S3	9	0
165	Sajha_R4_RNAC_Lamatar	S2	10	0
166	Sajha_R4_RNAC_Lamatar	S1	11	0
167	Sajha_R4_RNAC_Lamatar	S40	12	0
168	Sajha_R4_RNAC_Lamatar	S60	13	0
169	Sajha_R4_RNAC_Lamatar	S61	14	0
170	Sajha_R4_RNAC_Lamatar	S58	15	0
171	Sajha_R4_RNAC_Lamatar	S57	16	0
172	Sajha_R4_RNAC_Lamatar	S56	17	0
173	Sajha_R4_RNAC_Lamatar	S55	18	0
174	Sajha_R4_RNAC_Lamatar	S54	19	0
175	Sajha_R4_RNAC_Lamatar	S53	20	0
176	Sajha_R4_RNAC_Lamatar	S52	21	0
177	Sajha_R4_RNAC_Lamatar	S51	22	0
178	Sajha_R4_RNAC_Lamatar	S50	23	0
179	Sajha_R4_RNAC_Lamatar	S49	24	0
180	Sajha_R4_RNAC_Lamatar	S48	25	0
181	Sajha_R4_RNAC_Lamatar	S47	26	0
182	Sajha_R4_RNAC_Lamatar	S46	27	0
183	Sajha_R4_RNAC_Lamatar	S45	28	0
184	Sajha_R4_RNAC_Lamatar	S44	29	0
185	Sajha_R4_RNAC_Lamatar	S43	30	0
186	Sajha_R4_RNAC_Lamatar	S42	31	0
187	Sajha_R4_RNAC_Lamatar	S41	32	0
188	Sajha_R5_Thankot_Airport	S62	1	0
189	Sajha_R5_Thankot_Airport	S63	2	0
190	Sajha_R5_Thankot_Airport	S64	3	0
191	Sajha_R5_Thankot_Airport	S65	4	0
192	Sajha_R5_Thankot_Airport	S66	5	0
193	Sajha_R5_Thankot_Airport	S67	6	0
194	Sajha_R5_Thankot_Airport	S68	7	0
195	Sajha_R5_Thankot_Airport	S69	8	0
196	Sajha_R5_Thankot_Airport	S70	9	0
197	Sajha_R5_Thankot_Airport	S71	10	0
198	Sajha_R5_Thankot_Airport	S72	11	0
199	Sajha_R5_Thankot_Airport	S73	12	0
200	Sajha_R5_Thankot_Airport	S74	13	0
201	Sajha_R5_Thankot_Airport	S75	14	0
202	Sajha_R5_Thankot_Airport	S76	15	0
203	Sajha_R5_Thankot_Airport	S77	16	0
204	Sajha_R5_Thankot_Airport	S7	17	0
205	Sajha_R5_Thankot_Airport	S8	18	0
206	Sajha_R5_Thankot_Airport	S78	19	0
207	Sajha_R5_Thankot_Airport	S22	20	0
208	Sajha_R5_Thankot_Airport	S79	21	0
209	Sajha_R5_Thankot_Airport	S80	22	0
210	Sajha_R5_Thankot_Airport	S81	23	0
211	Sajha_R5_Thankot_Airport	S82	24	0
212	Sajha_R5_Thankot_Airport	S83	25	0
213	Sajha_R5_Thankot_Airport	S84	26	0
214	Sajha_R5_Thankot_Airport	S85	27	0
215	Sajha_R5_Thankot_Airport	S86	28	0
216	Sajha_R5_Thankot_Airport	S87	29	0
217	Sajha_R5_Thankot_Airport	S88	30	0
218	Sajha_R5_Thankot_Airport	S89	31	0
219	Sajha_R5_Thankot_Airport	S90	32	0
220	Sajha_R5_Thankot_Airport	S91	33	0
221	Sajha_R5_Airport_Thankot	S91	1	0
222	Sajha_R5_Airport_Thankot	S90	2	0
223	Sajha_R5_Airport_Thankot	S89	3	0
224	Sajha_R5_Airport_Thankot	S88	4	0
225	Sajha_R5_Airport_Thankot	S87	5	0
226	Sajha_R5_Airport_Thankot	S86	6	0
227	Sajha_R5_Airport_Thankot	S92	7	0
228	Sajha_R5_Airport_Thankot	S93	8	0
229	Sajha_R5_Airport_Thankot	S94	9	0
230	Sajha_R5_Airport_Thankot	S95	10	0
231	Sajha_R5_Airport_Thankot	S96	11	0
232	Sajha_R5_Airport_Thankot	S97	12	0
233	Sajha_R5_Airport_Thankot	S98	13	0
234	Sajha_R5_Airport_Thankot	S23	14	0
235	Sajha_R5_Airport_Thankot	S7	15	0
236	Sajha_R5_Airport_Thankot	S99	16	0
237	Sajha_R5_Airport_Thankot	S100	17	0
238	Sajha_R5_Airport_Thankot	S75	18	0
239	Sajha_R5_Airport_Thankot	S74	19	0
240	Sajha_R5_Airport_Thankot	S73	20	0
241	Sajha_R5_Airport_Thankot	S72	21	0
242	Sajha_R5_Airport_Thankot	S71	22	0
243	Sajha_R5_Airport_Thankot	S70	23	0
244	Sajha_R5_Airport_Thankot	S69	24	0
245	Sajha_R5_Airport_Thankot	S68	25	0
246	Sajha_R5_Airport_Thankot	S67	26	0
247	Sajha_R5_Airport_Thankot	S66	27	0
248	Sajha_R5_Airport_Thankot	S65	28	0
249	Sajha_R5_Airport_Thankot	S64	29	0
250	Sajha_R5_Airport_Thankot	S63	30	0
251	Sajha_R5_Airport_Thankot	S62	31	0
252	Sajha_R6_Thankot_Budhanilkantha	S101	1	0
253	Sajha_R6_Thankot_Budhanilkantha	S62	2	0
254	Sajha_R6_Thankot_Budhanilkantha	S63	3	0
255	Sajha_R6_Thankot_Budhanilkantha	S64	4	0
256	Sajha_R6_Thankot_Budhanilkantha	S65	5	0
257	Sajha_R6_Thankot_Budhanilkantha	S66	6	0
258	Sajha_R6_Thankot_Budhanilkantha	S67	7	0
259	Sajha_R6_Thankot_Budhanilkantha	S68	8	0
260	Sajha_R6_Thankot_Budhanilkantha	S69	9	0
261	Sajha_R6_Thankot_Budhanilkantha	S70	10	0
262	Sajha_R6_Thankot_Budhanilkantha	S71	11	0
263	Sajha_R6_Thankot_Budhanilkantha	S102	12	0
264	Sajha_R6_Thankot_Budhanilkantha	S103	13	0
265	Sajha_R6_Thankot_Budhanilkantha	S104	14	0
266	Sajha_R6_Thankot_Budhanilkantha	S105	15	0
267	Sajha_R6_Thankot_Budhanilkantha	S106	16	0
268	Sajha_R6_Thankot_Budhanilkantha	S107	17	0
269	Sajha_R6_Thankot_Budhanilkantha	S108	18	0
270	Sajha_R6_Thankot_Budhanilkantha	S109	19	0
271	Sajha_R6_Thankot_Budhanilkantha	S110	20	0
272	Sajha_R6_Thankot_Budhanilkantha	S111	21	0
273	Sajha_R6_Thankot_Budhanilkantha	S19	22	0
274	Sajha_R6_Thankot_Budhanilkantha	S18	23	0
275	Sajha_R6_Thankot_Budhanilkantha	S17	24	0
276	Sajha_R6_Thankot_Budhanilkantha	S16	25	0
277	Sajha_R6_Thankot_Budhanilkantha	S15	26	0
278	Sajha_R6_Thankot_Budhanilkantha	S24	27	0
279	Sajha_R6_Thankot_Budhanilkantha	S25	28	0
280	Sajha_R6_Thankot_Budhanilkantha	S26	29	0
281	Sajha_R6_Thankot_Budhanilkantha	S27	30	0
282	Sajha_R6_Thankot_Budhanilkantha	S28	31	0
283	Sajha_R6_Thankot_Budhanilkantha	S29	32	0
284	Sajha_R6_Thankot_Budhanilkantha	S30	33	0
285	Sajha_R6_Thankot_Budhanilkantha	S31	34	0
286	Sajha_R6_Thankot_Budhanilkantha	S32	35	0
287	Sajha_R6_Thankot_Budhanilkantha	S33	36	0
288	Sajha_R6_Budhanilkantha_Thankot	S33	1	0
289	Sajha_R6_Budhanilkantha_Thankot	S32	2	0
290	Sajha_R6_Budhanilkantha_Thankot	S31	3	0
291	Sajha_R6_Budhanilkantha_Thankot	S30	4	0
292	Sajha_R6_Budhanilkantha_Thankot	S29	5	0
293	Sajha_R6_Budhanilkantha_Thankot	S28	6	0
294	Sajha_R6_Budhanilkantha_Thankot	S27	7	0
295	Sajha_R6_Budhanilkantha_Thankot	S26	8	0
296	Sajha_R6_Budhanilkantha_Thankot	S25	9	0
297	Sajha_R6_Budhanilkantha_Thankot	S24	10	0
298	Sajha_R6_Budhanilkantha_Thankot	S15	11	0
299	Sajha_R6_Budhanilkantha_Thankot	S16	12	0
300	Sajha_R6_Budhanilkantha_Thankot	S17	13	0
301	Sajha_R6_Budhanilkantha_Thankot	S18	14	0
302	Sajha_R6_Budhanilkantha_Thankot	S19	15	0
303	Sajha_R6_Budhanilkantha_Thankot	S111	16	0
304	Sajha_R6_Budhanilkantha_Thankot	S110	17	0
305	Sajha_R6_Budhanilkantha_Thankot	S109	18	0
306	Sajha_R6_Budhanilkantha_Thankot	S108	19	0
307	Sajha_R6_Budhanilkantha_Thankot	S107	20	0
308	Sajha_R6_Budhanilkantha_Thankot	S106	21	0
309	Sajha_R6_Budhanilkantha_Thankot	S105	22	0
310	Sajha_R6_Budhanilkantha_Thankot	S104	23	0
311	Sajha_R6_Budhanilkantha_Thankot	S103	24	0
312	Sajha_R6_Budhanilkantha_Thankot	S102	25	0
313	Sajha_R6_Budhanilkantha_Thankot	S71	26	0
314	Sajha_R6_Budhanilkantha_Thankot	S70	27	0
315	Sajha_R6_Budhanilkantha_Thankot	S69	28	0
316	Sajha_R6_Budhanilkantha_Thankot	S68	29	0
317	Sajha_R6_Budhanilkantha_Thankot	S67	30	0
318	Sajha_R6_Budhanilkantha_Thankot	S66	31	0
319	Sajha_R6_Budhanilkantha_Thankot	S65	32	0
320	Sajha_R6_Budhanilkantha_Thankot	S64	33	0
321	Sajha_R6_Budhanilkantha_Thankot	S63	34	0
322	Sajha_R6_Budhanilkantha_Thankot	S62	35	0
323	Sajha_R6_Budhanilkantha_Thankot	S101	36	0
324	Sajha_R7_Lele_Jamal	S112	1	0
325	Sajha_R7_Lele_Jamal	S113	2	0
326	Sajha_R7_Lele_Jamal	S114	3	0
327	Sajha_R7_Lele_Jamal	S115	4	0
328	Sajha_R7_Lele_Jamal	S116	5	0
329	Sajha_R7_Lele_Jamal	S117	6	0
330	Sajha_R7_Lele_Jamal	S118	7	0
331	Sajha_R7_Lele_Jamal	S119	8	0
332	Sajha_R7_Lele_Jamal	S120	9	0
333	Sajha_R7_Lele_Jamal	S121	10	0
334	Sajha_R7_Lele_Jamal	S122	11	0
335	Sajha_R7_Lele_Jamal	S123	12	0
336	Sajha_R7_Lele_Jamal	S40	13	0
337	Sajha_R7_Lele_Jamal	S1	14	0
338	Sajha_R7_Lele_Jamal	S2	15	0
339	Sajha_R7_Lele_Jamal	S3	16	0
340	Sajha_R7_Lele_Jamal	S4	17	0
341	Sajha_R7_Lele_Jamal	S5	18	0
342	Sajha_R7_Lele_Jamal	S6	19	0
343	Sajha_R7_Lele_Jamal	S7	20	0
344	Sajha_R7_Lele_Jamal	S8	21	0
345	Sajha_R7_Lele_Jamal	S21	22	0
346	Sajha_R7_Jamal_Lele	S21	1	0
347	Sajha_R7_Jamal_Lele	S22	2	0
348	Sajha_R7_Jamal_Lele	S23	3	0
349	Sajha_R7_Jamal_Lele	S7	4	0
350	Sajha_R7_Jamal_Lele	S6	5	0
351	Sajha_R7_Jamal_Lele	S5	6	0
352	Sajha_R7_Jamal_Lele	S4	7	0
353	Sajha_R7_Jamal_Lele	S3	8	0
354	Sajha_R7_Jamal_Lele	S2	9	0
355	Sajha_R7_Jamal_Lele	S1	10	0
356	Sajha_R7_Jamal_Lele	S40	11	0
357	Sajha_R7_Jamal_Lele	S123	12	0
358	Sajha_R7_Jamal_Lele	S122	13	0
359	Sajha_R7_Jamal_Lele	S121	14	0
360	Sajha_R7_Jamal_Lele	S120	15	0
361	Sajha_R7_Jamal_Lele	S119	16	0
362	Sajha_R7_Jamal_Lele	S118	17	0
363	Sajha_R7_Jamal_Lele	S117	18	0
364	Sajha_R7_Jamal_Lele	S116	19	0
365	Sajha_R7_Jamal_Lele	S115	20	0
366	Sajha_R7_Jamal_Lele	S114	21	0
367	Sajha_R7_Jamal_Lele	S113	22	0
368	Sajha_R7_Jamal_Lele	S112	23	0
369	Sajha_R8_Bungamati_Jamal	S124	1	0
370	Sajha_R8_Bungamati_Jamal	S125	2	0
371	Sajha_R8_Bungamati_Jamal	S125	3	0
372	Sajha_R8_Bungamati_Jamal	S126	4	0
373	Sajha_R8_Bungamati_Jamal	S127	5	0
374	Sajha_R8_Bungamati_Jamal	S128	6	0
375	Sajha_R8_Bungamati_Jamal	S129	7	0
376	Sajha_R8_Bungamati_Jamal	S130	8	0
377	Sajha_R8_Bungamati_Jamal	S131	9	0
378	Sajha_R8_Bungamati_Jamal	S132	10	0
379	Sajha_R8_Bungamati_Jamal	S133	11	0
380	Sajha_R8_Bungamati_Jamal	S134	12	0
381	Sajha_R8_Bungamati_Jamal	S135	13	0
382	Sajha_R8_Bungamati_Jamal	S136	14	0
383	Sajha_R8_Bungamati_Jamal	S4	15	0
384	Sajha_R8_Bungamati_Jamal	S5	16	0
385	Sajha_R8_Bungamati_Jamal	S6	17	0
386	Sajha_R8_Bungamati_Jamal	S7	18	0
387	Sajha_R8_Bungamati_Jamal	S8	19	0
388	Sajha_R8_Bungamati_Jamal	S21	20	0
389	Sajha_R8_Jamal_Bungamati	S21	1	0
390	Sajha_R8_Jamal_Bungamati	S22	2	0
391	Sajha_R8_Jamal_Bungamati	S23	3	0
392	Sajha_R8_Jamal_Bungamati	S7	4	0
393	Sajha_R8_Jamal_Bungamati	S6	5	0
394	Sajha_R8_Jamal_Bungamati	S5	6	0
395	Sajha_R8_Jamal_Bungamati	S4	7	0
396	Sajha_R8_Jamal_Bungamati	S3	8	0
397	Sajha_R8_Jamal_Bungamati	S135	9	0
398	Sajha_R8_Jamal_Bungamati	S134	10	0
399	Sajha_R8_Jamal_Bungamati	S133	11	0
400	Sajha_R8_Jamal_Bungamati	S132	12	0
401	Sajha_R8_Jamal_Bungamati	S131	13	0
402	Sajha_R8_Jamal_Bungamati	S130	14	0
403	Sajha_R8_Jamal_Bungamati	S129	15	0
404	Sajha_R8_Jamal_Bungamati	S128	16	0
405	Sajha_R8_Jamal_Bungamati	S127	17	0
406	Sajha_R8_Jamal_Bungamati	S126	18	0
407	Sajha_R8_Jamal_Bungamati	S125	19	0
408	Sajha_R8_Jamal_Bungamati	S125	20	0
409	Sajha_R8_Jamal_Bungamati	S124	21	0
410	Jharana_R1_Jamal_Ranibu	S21	1	0
411	Jharana_R1_Jamal_Ranibu	S22	2	0
412	Jharana_R1_Jamal_Ranibu	S23	3	0
413	Jharana_R1_Jamal_Ranibu	S7	4	0
414	Jharana_R1_Jamal_Ranibu	S6	5	0
415	Jharana_R1_Jamal_Ranibu	S5	6	0
416	Jharana_R1_Jamal_Ranibu	S4	7	0
417	Jharana_R1_Jamal_Ranibu	S3	8	0
418	Jharana_R1_Jamal_Ranibu	S2	9	0
419	Jharana_R1_Jamal_Ranibu	S1	10	0
420	Jharana_R1_Jamal_Ranibu	S137	11	0
421	Jharana_R1_Jamal_Ranibu	S138	12	0
422	Jharana_R1_Jamal_Ranibu	S139	13	0
423	Jharana_R1_Jamal_Ranibu	S140	14	0
424	Jharana_R1_Jamal_Ranibu	S141	15	0
425	Jharana_R1_Ranibu_Jamal	S141	1	0
426	Jharana_R1_Ranibu_Jamal	S140	2	0
427	Jharana_R1_Ranibu_Jamal	S139	3	0
428	Jharana_R1_Ranibu_Jamal	S138	4	0
429	Jharana_R1_Ranibu_Jamal	S137	5	0
430	Jharana_R1_Ranibu_Jamal	S1	6	0
431	Jharana_R1_Ranibu_Jamal	S2	7	0
432	Jharana_R1_Ranibu_Jamal	S3	8	0
433	Jharana_R1_Ranibu_Jamal	S4	9	0
434	Jharana_R1_Ranibu_Jamal	S5	10	0
435	Jharana_R1_Ranibu_Jamal	S6	11	0
436	Jharana_R1_Ranibu_Jamal	S142	12	0
437	Jharana_R1_Ranibu_Jamal	S98	13	0
438	Jharana_R1_Ranibu_Jamal	S8	14	0
439	Jharana_R1_Ranibu_Jamal	S21	15	0
440	Subhakamana_R1_Swayambhu_Biruwa	S143	1	0
441	Subhakamana_R1_Swayambhu_Biruwa	S144	2	0
442	Subhakamana_R1_Swayambhu_Biruwa	S145	3	0
443	Subhakamana_R1_Swayambhu_Biruwa	S146	4	0
444	Subhakamana_R1_Swayambhu_Biruwa	S147	5	0
445	Subhakamana_R1_Swayambhu_Biruwa	S148	6	0
446	Subhakamana_R1_Swayambhu_Biruwa	S149	7	0
447	Subhakamana_R1_Swayambhu_Biruwa	S150	8	0
448	Subhakamana_R1_Swayambhu_Biruwa	S151	9	0
449	Subhakamana_R1_Swayambhu_Biruwa	S152	10	0
450	Subhakamana_R1_Swayambhu_Biruwa	S142	11	0
451	Subhakamana_R1_Swayambhu_Biruwa	S81	12	0
452	Subhakamana_R1_Swayambhu_Biruwa	S82	13	0
453	Subhakamana_R1_Swayambhu_Biruwa	S83	14	0
454	Subhakamana_R1_Swayambhu_Biruwa	S84	15	0
455	Subhakamana_R1_Swayambhu_Biruwa	S85	16	0
456	Subhakamana_R1_Swayambhu_Biruwa	S86	17	0
457	Subhakamana_R1_Swayambhu_Biruwa	S87	18	0
458	Subhakamana_R1_Swayambhu_Biruwa	S153	19	0
459	Subhakamana_R1_Swayambhu_Biruwa	S154	20	0
460	Subhakamana_R1_Swayambhu_Biruwa	S155	21	0
461	Subhakamana_R1_Swayambhu_Biruwa	S156	22	0
462	Subhakamana_R1_Swayambhu_Biruwa	S157	23	0
463	Subhakamana_R1_Swayambhu_Biruwa	S158	24	0
464	Subhakamana_R1_Swayambhu_Biruwa	S159	25	0
465	Subhakamana_R1_Swayambhu_Biruwa	S160	26	0
466	Subhakamana_R1_Swayambhu_Biruwa	S161	27	0
467	Subhakamana_R1_Swayambhu_Biruwa	S162	28	0
468	Subhakamana_R1_Swayambhu_Biruwa	S163	29	0
469	Subhakamana_R1_Swayambhu_Biruwa	S164	30	0
470	Subhakamana_R1_Swayambhu_Biruwa	S165	31	0
471	Subhakamana_R1_Swayambhu_Biruwa	S166	32	0
472	Subhakamana_R1_Swayambhu_Biruwa	S167	33	0
473	Subhakamana_R1_Swayambhu_Biruwa	S168	34	0
474	Subhakamana_R1_Swayambhu_Biruwa	S169	35	0
475	Subhakamana_R1_Swayambhu_Biruwa	S170	36	0
476	Subhakamana_R1_Biruwa_Swayambhu	S170	1	0
477	Subhakamana_R1_Biruwa_Swayambhu	S169	2	0
478	Subhakamana_R1_Biruwa_Swayambhu	S168	3	0
479	Subhakamana_R1_Biruwa_Swayambhu	S167	4	0
480	Subhakamana_R1_Biruwa_Swayambhu	S166	5	0
481	Subhakamana_R1_Biruwa_Swayambhu	S165	6	0
482	Subhakamana_R1_Biruwa_Swayambhu	S164	7	0
483	Subhakamana_R1_Biruwa_Swayambhu	S163	8	0
484	Subhakamana_R1_Biruwa_Swayambhu	S162	9	0
485	Subhakamana_R1_Biruwa_Swayambhu	S161	10	0
486	Subhakamana_R1_Biruwa_Swayambhu	S160	11	0
487	Subhakamana_R1_Biruwa_Swayambhu	S159	12	0
488	Subhakamana_R1_Biruwa_Swayambhu	S158	13	0
489	Subhakamana_R1_Biruwa_Swayambhu	S157	14	0
490	Subhakamana_R1_Biruwa_Swayambhu	S171	15	0
491	Subhakamana_R1_Biruwa_Swayambhu	S172	16	0
492	Subhakamana_R1_Biruwa_Swayambhu	S173	17	0
493	Subhakamana_R1_Biruwa_Swayambhu	S174	18	0
494	Subhakamana_R1_Biruwa_Swayambhu	S175	19	0
495	Subhakamana_R1_Biruwa_Swayambhu	S176	20	0
496	Subhakamana_R1_Biruwa_Swayambhu	S92	21	0
497	Subhakamana_R1_Biruwa_Swayambhu	S93	22	0
498	Subhakamana_R1_Biruwa_Swayambhu	S94	23	0
499	Subhakamana_R1_Biruwa_Swayambhu	S95	24	0
500	Subhakamana_R1_Biruwa_Swayambhu	S96	25	0
501	Subhakamana_R1_Biruwa_Swayambhu	S97	26	0
502	Subhakamana_R1_Biruwa_Swayambhu	S177	27	0
503	Subhakamana_R1_Biruwa_Swayambhu	S178	28	0
504	Subhakamana_R1_Biruwa_Swayambhu	S99	29	0
505	Subhakamana_R1_Biruwa_Swayambhu	S100	30	0
506	Subhakamana_R1_Biruwa_Swayambhu	S179	31	0
507	Subhakamana_R1_Biruwa_Swayambhu	S180	32	0
508	Subhakamana_R1_Biruwa_Swayambhu	S181	33	0
509	Subhakamana_R1_Biruwa_Swayambhu	S182	34	0
510	Subhakamana_R1_Biruwa_Swayambhu	S183	35	0
511	Subhakamana_R1_Biruwa_Swayambhu	S184	36	0
512	Subhakamana_R1_Biruwa_Swayambhu	S185	37	0
513	Tempo_R1_Maitighar_Lagankhel	S1	1	0
514	Tempo_R1_Maitighar_Lagankhel	S2	2	0
515	Tempo_R1_Maitighar_Lagankhel	S3	3	0
516	Tempo_R1_Maitighar_Lagankhel	S4	4	0
517	Tempo_R1_Maitighar_Lagankhel	S5	5	0
518	Tempo_R1_Maitighar_Lagankhel	S6	6	0
519	Tempo_R1_Maitighar_Lagankhel	S142	7	0
520	Tempo_R1_Maitighar_Lagankhel	S81	8	0
521	Tempo_R1_Maitighar_Lagankhel	S82	9	0
522	Tempo_R1_Maitighar_Lagankhel	S83	10	0
523	Tempo_R1_Maitighar_Lagankhel	S84	11	0
524	Tempo_R1_Maitighar_Lagankhel	S85	12	0
525	Tempo_R1_Maitighar_Lagankhel	S86	13	0
526	Tempo_R1_Maitighar_Lagankhel	S87	14	0
527	Tempo_R1_Maitighar_Lagankhel	S153	15	0
528	Tempo_R1_Maitighar_Lagankhel	S186	16	0
529	Tempo_R1_Maitighar_Lagankhel	S187	17	0
530	Tempo_R1_Maitighar_Lagankhel	S188	18	0
531	Tempo_R1_Maitighar_Lagankhel	S189	19	0
532	Tempo_R1_Maitighar_Lagankhel	S190	20	0
533	Tempo_R1_Maitighar_Lagankhel	S191	21	0
534	Tempo_R1_Maitighar_Lagankhel	S192	22	0
535	Tempo_R1_Maitighar_Lagankhel	S193	23	0
536	Tempo_R1_Maitighar_Lagankhel	S194	24	0
537	Tempo_R1_lagankhel_maitighar	S1	1	0
538	Tempo_R1_lagankhel_maitighar	S194	2	0
539	Tempo_R1_lagankhel_maitighar	S60	3	0
540	Tempo_R1_lagankhel_maitighar	S61	4	0
541	Tempo_R1_lagankhel_maitighar	S58	5	0
542	Tempo_R1_lagankhel_maitighar	S190	6	0
543	Tempo_R1_lagankhel_maitighar	S189	7	0
544	Tempo_R1_lagankhel_maitighar	S188	8	0
545	Tempo_R1_lagankhel_maitighar	S187	9	0
546	Tempo_R1_lagankhel_maitighar	S195	10	0
547	Tempo_R1_lagankhel_maitighar	S196	11	0
548	Tempo_R1_lagankhel_maitighar	S176	12	0
549	Tempo_R1_lagankhel_maitighar	S92	13	0
550	Tempo_R1_lagankhel_maitighar	S93	14	0
551	Tempo_R1_lagankhel_maitighar	S94	15	0
552	Tempo_R1_lagankhel_maitighar	S95	16	0
553	Tempo_R1_lagankhel_maitighar	S96	17	0
554	Tempo_R1_lagankhel_maitighar	S97	18	0
555	Tempo_R1_lagankhel_maitighar	S177	19	0
556	Tempo_R1_lagankhel_maitighar	S6	20	0
557	Tempo_R1_lagankhel_maitighar	S5	21	0
558	Tempo_R1_lagankhel_maitighar	S4	22	0
559	Tempo_R1_lagankhel_maitighar	S3	23	0
560	Tempo_R1_lagankhel_maitighar	S2	24	0
561	Tempo_R2_RNAC_Sinamangal	S8	1	0
562	Tempo_R2_RNAC_Sinamangal	S197	2	0
563	Tempo_R2_RNAC_Sinamangal	S21	3	0
564	Tempo_R2_RNAC_Sinamangal	S198	4	0
565	Tempo_R2_RNAC_Sinamangal	S199	5	0
566	Tempo_R2_RNAC_Sinamangal	S200	6	0
567	Tempo_R2_RNAC_Sinamangal	S201	7	0
568	Tempo_R2_RNAC_Sinamangal	S202	8	0
569	Tempo_R2_RNAC_Sinamangal	S203	9	0
570	Tempo_R2_RNAC_Sinamangal	S204	10	0
571	Tempo_R2_RNAC_Sinamangal	S205	11	0
572	Tempo_R2_RNAC_Sinamangal	S206	12	0
573	Tempo_R2_RNAC_Sinamangal	S207	13	0
574	Tempo_R2_RNAC_Sinamangal	S208	14	0
575	Tempo_R2_RNAC_Sinamangal	S209	15	0
576	Tempo_R2_RNAC_Sinamangal	S210	16	0
577	Tempo_R2_Sinamangal_RNAC	S210	1	0
578	Tempo_R2_Sinamangal_RNAC	S209	2	0
579	Tempo_R2_Sinamangal_RNAC	S208	3	0
580	Tempo_R2_Sinamangal_RNAC	S207	4	0
581	Tempo_R2_Sinamangal_RNAC	S206	5	0
582	Tempo_R2_Sinamangal_RNAC	S205	6	0
583	Tempo_R2_Sinamangal_RNAC	S211	7	0
584	Tempo_R2_Sinamangal_RNAC	S212	8	0
585	Tempo_R2_Sinamangal_RNAC	S213	9	0
586	Tempo_R2_Sinamangal_RNAC	S214	10	0
587	Tempo_R2_Sinamangal_RNAC	S215	11	0
588	Tempo_R2_Sinamangal_RNAC	S22	12	0
589	Tempo_R2_Sinamangal_RNAC	S23	13	0
590	Tempo_R2_Sinamangal_RNAC	S8	14	0
591	Tempo_R3_RNAC_Tinchuli	S8	1	0
592	Tempo_R3_RNAC_Tinchuli	S197	2	0
593	Tempo_R3_RNAC_Tinchuli	S21	3	0
594	Tempo_R3_RNAC_Tinchuli	S198	4	0
595	Tempo_R3_RNAC_Tinchuli	S199	5	0
596	Tempo_R3_RNAC_Tinchuli	S200	6	0
597	Tempo_R3_RNAC_Tinchuli	S201	7	0
598	Tempo_R3_RNAC_Tinchuli	S202	8	0
599	Tempo_R3_RNAC_Tinchuli	S203	9	0
600	Tempo_R3_RNAC_Tinchuli	S204	10	0
601	Tempo_R3_RNAC_Tinchuli	S205	11	0
602	Tempo_R3_RNAC_Tinchuli	S206	12	0
603	Tempo_R3_RNAC_Tinchuli	S207	13	0
604	Tempo_R3_RNAC_Tinchuli	S216	14	0
605	Tempo_R3_RNAC_Tinchuli	S217	15	0
606	Tempo_R3_RNAC_Tinchuli	S218	16	0
607	Tempo_R3_RNAC_Tinchuli	S219	17	0
608	Tempo_R3_RNAC_Tinchuli	S220	18	0
609	Tempo_R3_RNAC_Tinchuli	S221	19	0
610	Tempo_R3_RNAC_Tinchuli	S222	20	0
611	Tempo_R3_RNAC_Tinchuli	S223	21	0
612	Tempo_R3_RNAC_Tinchuli	S224	22	0
613	Tempo_R3_RNAC_Tinchuli	S225	23	0
614	Tempo_R3_RNAC_Tinchuli	S226	24	0
615	Tempo_R3_Tinchuli_RNAC	S226	1	0
616	Tempo_R3_Tinchuli_RNAC	S225	2	0
617	Tempo_R3_Tinchuli_RNAC	S224	3	0
618	Tempo_R3_Tinchuli_RNAC	S223	4	0
619	Tempo_R3_Tinchuli_RNAC	S222	5	0
620	Tempo_R3_Tinchuli_RNAC	S227	6	0
621	Tempo_R3_Tinchuli_RNAC	S220	7	0
622	Tempo_R3_Tinchuli_RNAC	S219	8	0
623	Tempo_R3_Tinchuli_RNAC	S218	9	0
624	Tempo_R3_Tinchuli_RNAC	S217	10	0
625	Tempo_R3_Tinchuli_RNAC	S216	11	0
626	Tempo_R3_Tinchuli_RNAC	S207	12	0
627	Tempo_R3_Tinchuli_RNAC	S206	13	0
628	Tempo_R3_Tinchuli_RNAC	S205	14	0
629	Tempo_R3_Tinchuli_RNAC	S211	15	0
630	Tempo_R3_Tinchuli_RNAC	S212	16	0
631	Tempo_R3_Tinchuli_RNAC	S213	17	0
632	Tempo_R3_Tinchuli_RNAC	S214	18	0
633	Tempo_R3_Tinchuli_RNAC	S215	19	0
634	Tempo_R3_Tinchuli_RNAC	S22	20	0
635	Tempo_R3_Tinchuli_RNAC	S23	21	0
636	Tempo_R3_Tinchuli_RNAC	S8	22	0
637	Tempo_R4_Kapan _ Sankhamul	S228	1	0
638	Tempo_R4_Kapan _ Sankhamul	S229	2	0
639	Tempo_R4_Kapan _ Sankhamul	S230	3	0
640	Tempo_R4_Kapan _ Sankhamul	S231	4	0
641	Tempo_R4_Kapan _ Sankhamul	S232	5	0
642	Tempo_R4_Kapan _ Sankhamul	S233	6	0
643	Tempo_R4_Kapan _ Sankhamul	S234	7	0
644	Tempo_R4_Kapan _ Sankhamul	S235	8	0
645	Tempo_R4_Kapan _ Sankhamul	S236	9	0
646	Tempo_R4_Kapan _ Sankhamul	S221	10	0
647	Tempo_R4_Kapan _ Sankhamul	S220	11	0
648	Tempo_R4_Kapan _ Sankhamul	S219	12	0
649	Tempo_R4_Kapan _ Sankhamul	S218	13	0
650	Tempo_R4_Kapan _ Sankhamul	S217	14	0
651	Tempo_R4_Kapan _ Sankhamul	S216	15	0
652	Tempo_R4_Kapan _ Sankhamul	S237	16	0
653	Tempo_R4_Kapan _ Sankhamul	S238	17	0
654	Tempo_R4_Kapan _ Sankhamul	S239	18	0
655	Tempo_R4_Kapan _ Sankhamul	S240	19	0
656	Tempo_R4_Kapan _ Sankhamul	S241	20	0
657	Tempo_R4_Kapan _ Sankhamul	S242	21	0
658	Tempo_R4_Kapan _ Sankhamul	S243	22	0
659	Tempo_R4_Kapan _ Sankhamul	S244	23	0
660	Tempo_R4_Kapan _ Sankhamul	S245	24	0
661	Tempo_R4_Sankhamul_Kapan	S245	1	0
662	Tempo_R4_Sankhamul_Kapan	S244	2	0
663	Tempo_R4_Sankhamul_Kapan	S243	3	0
664	Tempo_R4_Sankhamul_Kapan	S242	4	0
665	Tempo_R4_Sankhamul_Kapan	S241	5	0
666	Tempo_R4_Sankhamul_Kapan	S240	6	0
667	Tempo_R4_Sankhamul_Kapan	S239	7	0
668	Tempo_R4_Sankhamul_Kapan	S238	8	0
669	Tempo_R4_Sankhamul_Kapan	S237	9	0
670	Tempo_R4_Sankhamul_Kapan	S216	10	0
671	Tempo_R4_Sankhamul_Kapan	S217	11	0
672	Tempo_R4_Sankhamul_Kapan	S218	12	0
673	Tempo_R4_Sankhamul_Kapan	S219	13	0
674	Tempo_R4_Sankhamul_Kapan	S220	14	0
675	Tempo_R4_Sankhamul_Kapan	S221	15	0
676	Tempo_R4_Sankhamul_Kapan	S236	16	0
677	Tempo_R4_Sankhamul_Kapan	S235	17	0
678	Tempo_R4_Sankhamul_Kapan	S234	18	0
679	Tempo_R4_Sankhamul_Kapan	S233	19	0
680	Tempo_R4_Sankhamul_Kapan	S232	20	0
681	Tempo_R4_Sankhamul_Kapan	S231	21	0
682	Tempo_R4_Sankhamul_Kapan	S230	22	0
683	Tempo_R4_Sankhamul_Kapan	S229	23	0
684	Tempo_R4_Sankhamul_Kapan	S228	24	0
685	Tempo_R5_Ratnapark_Imadol	S8	1	0
686	Tempo_R5_Ratnapark_Imadol	S78	2	0
687	Tempo_R5_Ratnapark_Imadol	S215	3	0
688	Tempo_R5_Ratnapark_Imadol	S22	4	0
689	Tempo_R5_Ratnapark_Imadol	S79	5	0
690	Tempo_R5_Ratnapark_Imadol	S80	6	0
691	Tempo_R5_Ratnapark_Imadol	S177	7	0
692	Tempo_R5_Ratnapark_Imadol	S6	8	0
693	Tempo_R5_Ratnapark_Imadol	S5	9	0
694	Tempo_R5_Ratnapark_Imadol	S4	10	0
695	Tempo_R5_Ratnapark_Imadol	S246	11	0
696	Tempo_R5_Ratnapark_Imadol	S247	12	0
697	Tempo_R5_Ratnapark_Imadol	S248	13	0
698	Tempo_R5_Ratnapark_Imadol	S249	14	0
699	Tempo_R5_Ratnapark_Imadol	S250	15	0
700	Tempo_R5_Ratnapark_Imadol	S57	16	0
701	Tempo_R5_Ratnapark_Imadol	S56	17	0
702	Tempo_R5_Ratnapark_Imadol	S55	18	0
703	Tempo_R5_Ratnapark_Imadol	S54	19	0
704	Tempo_R5_Ratnapark_Imadol	S53	20	0
705	Tempo_R5_Ratnapark_Imadol	S52	21	0
706	Tempo_R5_Ratnapark_Imadol	S51	22	0
707	Tempo_R5_Ratnapark_Imadol	S50	23	0
708	Tempo_R5_Ratnapark_Imadol	S251	24	0
709	Tempo_R5_Ratnapark_Imadol	S252	25	0
710	Tempo_R5_Ratnapark_Imadol	S253	26	0
711	Tempo_R5_Imadol_Ratnapark	S253	1	0
712	Tempo_R5_Imadol_Ratnapark	S252	2	0
713	Tempo_R5_Imadol_Ratnapark	S251	3	0
714	Tempo_R5_Imadol_Ratnapark	S50	4	0
715	Tempo_R5_Imadol_Ratnapark	S51	5	0
716	Tempo_R5_Imadol_Ratnapark	S52	6	0
717	Tempo_R5_Imadol_Ratnapark	S53	7	0
718	Tempo_R5_Imadol_Ratnapark	S54	8	0
719	Tempo_R5_Imadol_Ratnapark	S55	9	0
720	Tempo_R5_Imadol_Ratnapark	S56	10	0
721	Tempo_R5_Imadol_Ratnapark	S57	11	0
722	Tempo_R5_Imadol_Ratnapark	S250	12	0
723	Tempo_R5_Imadol_Ratnapark	S249	13	0
724	Tempo_R5_Imadol_Ratnapark	S248	14	0
725	Tempo_R5_Imadol_Ratnapark	S247	15	0
726	Tempo_R5_Imadol_Ratnapark	S246	16	0
727	Tempo_R5_Imadol_Ratnapark	S4	17	0
728	Tempo_R5_Imadol_Ratnapark	S5	18	0
729	Tempo_R5_Imadol_Ratnapark	S6	19	0
730	Tempo_R5_Imadol_Ratnapark	S7	20	0
731	Tempo_R5_Imadol_Ratnapark	S8	21	0
732	Nepal_R1_Balkhu_Harhar_Mahadev	S254	1	0
733	Nepal_R1_Balkhu_Harhar_Mahadev	S255	2	0
734	Nepal_R1_Balkhu_Harhar_Mahadev	S256	3	0
735	Nepal_R1_Balkhu_Harhar_Mahadev	S257	4	0
736	Nepal_R1_Balkhu_Harhar_Mahadev	S258	5	0
737	Nepal_R1_Balkhu_Harhar_Mahadev	S259	6	0
738	Nepal_R1_Balkhu_Harhar_Mahadev	S260	7	0
739	Nepal_R1_Balkhu_Harhar_Mahadev	S261	8	0
740	Nepal_R1_Balkhu_Harhar_Mahadev	S262	9	0
741	Nepal_R1_Balkhu_Harhar_Mahadev	S5	10	0
742	Nepal_R1_Balkhu_Harhar_Mahadev	S6	11	0
743	Nepal_R1_Balkhu_Harhar_Mahadev	S142	12	0
744	Nepal_R1_Balkhu_Harhar_Mahadev	S81	13	0
745	Nepal_R1_Balkhu_Harhar_Mahadev	S82	14	0
746	Nepal_R1_Balkhu_Harhar_Mahadev	S83	15	0
747	Nepal_R1_Balkhu_Harhar_Mahadev	S84	16	0
748	Nepal_R1_Balkhu_Harhar_Mahadev	S85	17	0
749	Nepal_R1_Balkhu_Harhar_Mahadev	S86	18	0
750	Nepal_R1_Balkhu_Harhar_Mahadev	S87	19	0
751	Nepal_R1_Balkhu_Harhar_Mahadev	S153	20	0
752	Nepal_R1_Balkhu_Harhar_Mahadev	S154	21	0
753	Nepal_R1_Balkhu_Harhar_Mahadev	S263	22	0
754	Nepal_R1_Balkhu_Harhar_Mahadev	S264	23	0
755	Nepal_R1_Balkhu_Harhar_Mahadev	S265	24	0
756	Nepal_R1_Balkhu_Harhar_Mahadev	S266	25	0
757	Nepal_R1_Balkhu_Harhar_Mahadev	S267	26	0
758	Nepal_R1_Balkhu_Harhar_Mahadev	S268	27	0
759	Nepal_R1_Balkhu_Harhar_Mahadev	S269	28	0
760	Nepal_R1_Balkhu_Harhar_Mahadev	S270	29	0
761	Nepal_R1_Harhar_Mahadev_Balkhu	S270	1	0
762	Nepal_R1_Harhar_Mahadev_Balkhu	S269	2	0
763	Nepal_R1_Harhar_Mahadev_Balkhu	S268	3	0
764	Nepal_R1_Harhar_Mahadev_Balkhu	S267	4	0
765	Nepal_R1_Harhar_Mahadev_Balkhu	S266	5	0
766	Nepal_R1_Harhar_Mahadev_Balkhu	S265	6	0
767	Nepal_R1_Harhar_Mahadev_Balkhu	S271	7	0
768	Nepal_R1_Harhar_Mahadev_Balkhu	S263	8	0
769	Nepal_R1_Harhar_Mahadev_Balkhu	S272	9	0
770	Nepal_R1_Harhar_Mahadev_Balkhu	S195	10	0
771	Nepal_R1_Harhar_Mahadev_Balkhu	S196	11	0
772	Nepal_R1_Harhar_Mahadev_Balkhu	S176	12	0
773	Nepal_R1_Harhar_Mahadev_Balkhu	S92	13	0
774	Nepal_R1_Harhar_Mahadev_Balkhu	S93	14	0
775	Nepal_R1_Harhar_Mahadev_Balkhu	S94	15	0
776	Nepal_R1_Harhar_Mahadev_Balkhu	S95	16	0
777	Nepal_R1_Harhar_Mahadev_Balkhu	S96	17	0
778	Nepal_R1_Harhar_Mahadev_Balkhu	S97	18	0
779	Nepal_R1_Harhar_Mahadev_Balkhu	S177	19	0
780	Nepal_R1_Harhar_Mahadev_Balkhu	S178	20	0
781	Nepal_R1_Harhar_Mahadev_Balkhu	S99	21	0
782	Nepal_R1_Harhar_Mahadev_Balkhu	S100	22	0
783	Nepal_R1_Harhar_Mahadev_Balkhu	S273	23	0
784	Nepal_R1_Harhar_Mahadev_Balkhu	S274	24	0
785	Nepal_R1_Harhar_Mahadev_Balkhu	S275	25	0
786	Nepal_R1_Harhar_Mahadev_Balkhu	S254	26	0
787	Nepal_R2_Mulpani_Ghantaghar	S276	1	0
788	Nepal_R2_Mulpani_Ghantaghar	S277	2	0
789	Nepal_R2_Mulpani_Ghantaghar	S278	3	0
790	Nepal_R2_Mulpani_Ghantaghar	S279	4	0
791	Nepal_R2_Mulpani_Ghantaghar	S280	5	0
792	Nepal_R2_Mulpani_Ghantaghar	S281	6	0
793	Nepal_R2_Mulpani_Ghantaghar	S282	7	0
794	Nepal_R2_Mulpani_Ghantaghar	S283	8	0
795	Nepal_R2_Mulpani_Ghantaghar	S284	9	0
796	Nepal_R2_Mulpani_Ghantaghar	S285	10	0
797	Nepal_R2_Mulpani_Ghantaghar	S286	11	0
798	Nepal_R2_Mulpani_Ghantaghar	S287	12	0
799	Nepal_R2_Mulpani_Ghantaghar	S271	13	0
800	Nepal_R2_Mulpani_Ghantaghar	S263	14	0
801	Nepal_R2_Mulpani_Ghantaghar	S272	15	0
802	Nepal_R2_Mulpani_Ghantaghar	S195	16	0
803	Nepal_R2_Mulpani_Ghantaghar	S196	17	0
804	Nepal_R2_Mulpani_Ghantaghar	S176	18	0
805	Nepal_R2_Mulpani_Ghantaghar	S92	19	0
806	Nepal_R2_Mulpani_Ghantaghar	S93	20	0
807	Nepal_R2_Mulpani_Ghantaghar	S94	21	0
808	Nepal_R2_Mulpani_Ghantaghar	S95	22	0
809	Nepal_R2_Mulpani_Ghantaghar	S96	23	0
810	Nepal_R2_Mulpani_Ghantaghar	S97	24	0
811	Nepal_R2_Mulpani_Ghantaghar	S80	25	0
812	Nepal_R2_Mulpani_Ghantaghar	S79	26	0
813	Nepal_R2_Mulpani_Ghantaghar	S288	27	0
814	Nepal_R2_Mulpani_Ghantaghar	S289	28	0
815	Nepal_R2_Mulpani_Ghantaghar	S290	29	0
816	Nepal_R2_Ghantaghar_Mulpani	S290	1	0
817	Nepal_R2_Ghantaghar_Mulpani	S291	2	0
818	Nepal_R2_Ghantaghar_Mulpani	S292	3	0
819	Nepal_R2_Ghantaghar_Mulpani	S178	4	0
820	Nepal_R2_Ghantaghar_Mulpani	S142	5	0
821	Nepal_R2_Ghantaghar_Mulpani	S81	6	0
822	Nepal_R2_Ghantaghar_Mulpani	S82	7	0
823	Nepal_R2_Ghantaghar_Mulpani	S83	8	0
824	Nepal_R2_Ghantaghar_Mulpani	S84	9	0
825	Nepal_R2_Ghantaghar_Mulpani	S85	10	0
826	Nepal_R2_Ghantaghar_Mulpani	S86	11	0
827	Nepal_R2_Ghantaghar_Mulpani	S87	12	0
828	Nepal_R2_Ghantaghar_Mulpani	S153	13	0
829	Nepal_R2_Ghantaghar_Mulpani	S154	14	0
830	Nepal_R2_Ghantaghar_Mulpani	S263	15	0
831	Nepal_R2_Ghantaghar_Mulpani	S264	16	0
832	Nepal_R2_Ghantaghar_Mulpani	S287	17	0
833	Nepal_R2_Ghantaghar_Mulpani	S286	18	0
834	Nepal_R2_Ghantaghar_Mulpani	S285	19	0
835	Nepal_R2_Ghantaghar_Mulpani	S284	20	0
836	Nepal_R2_Ghantaghar_Mulpani	S283	21	0
837	Nepal_R2_Ghantaghar_Mulpani	S282	22	0
838	Nepal_R2_Ghantaghar_Mulpani	S281	23	0
839	Nepal_R2_Ghantaghar_Mulpani	S280	24	0
840	Nepal_R2_Ghantaghar_Mulpani	S279	25	0
841	Nepal_R2_Ghantaghar_Mulpani	S278	26	0
842	Nepal_R2_Ghantaghar_Mulpani	S277	27	0
843	Nepal_R3_Kapan_Tikathali	S293	1	0
844	Nepal_R3_Kapan_Tikathali	S294	2	0
845	Nepal_R3_Kapan_Tikathali	S295	3	0
846	Nepal_R3_Kapan_Tikathali	S296	4	0
847	Nepal_R3_Kapan_Tikathali	S297	5	0
848	Nepal_R3_Kapan_Tikathali	S298	6	0
849	Nepal_R3_Kapan_Tikathali	S299	7	0
850	Nepal_R3_Kapan_Tikathali	S300	8	0
851	Nepal_R3_Kapan_Tikathali	S301	9	0
852	Nepal_R3_Kapan_Tikathali	S302	10	0
853	Nepal_R3_Kapan_Tikathali	S225	11	0
854	Nepal_R3_Kapan_Tikathali	S224	12	0
855	Nepal_R3_Kapan_Tikathali	S223	13	0
856	Nepal_R3_Kapan_Tikathali	S222	14	0
857	Nepal_R3_Kapan_Tikathali	S227	15	0
858	Nepal_R3_Kapan_Tikathali	S303	16	0
859	Nepal_R3_Kapan_Tikathali	S304	17	0
860	Nepal_R3_Kapan_Tikathali	S305	18	0
861	Nepal_R3_Kapan_Tikathali	S15	19	0
862	Nepal_R3_Kapan_Tikathali	S14	20	0
863	Nepal_R3_Kapan_Tikathali	S13	21	0
864	Nepal_R3_Kapan_Tikathali	S306	22	0
865	Nepal_R3_Kapan_Tikathali	S307	23	0
866	Nepal_R3_Kapan_Tikathali	S308	24	0
867	Nepal_R3_Kapan_Tikathali	S309	25	0
868	Nepal_R3_Kapan_Tikathali	S310	26	0
869	Nepal_R3_Kapan_Tikathali	S311	27	0
870	Nepal_R3_Kapan_Tikathali	S312	28	0
871	Nepal_R3_Kapan_Tikathali	S313	29	0
872	Nepal_R3_Kapan_Tikathali	S314	30	0
873	Nepal_R3_Kapan_Tikathali	S315	31	0
874	Nepal_R3_Kapan_Tikathali	S316	32	0
875	Nepal_R3_Kapan_Tikathali	S317	33	0
876	Nepal_R3_Kapan_Tikathali	S318	34	0
877	Nepal_R3_Kapan_Tikathali	S319	35	0
878	Nepal_R3_Kapan_Tikathali	S320	36	0
879	Nepal_R3_Kapan_Tikathali	S321	37	0
880	Nepal_R3_Kapan_Tikathali	S322	38	0
881	Nepal_R3_Kapan_Tikathali	S323	39	0
882	Nepal_R3_Kapan_Tikathali	S85	40	0
883	Nepal_R3_Kapan_Tikathali	S86	41	0
884	Nepal_R3_Kapan_Tikathali	S87	42	0
885	Nepal_R3_Kapan_Tikathali	S153	43	0
886	Nepal_R3_Kapan_Tikathali	S186	44	0
887	Nepal_R3_Kapan_Tikathali	S187	45	0
888	Nepal_R3_Kapan_Tikathali	S188	46	0
889	Nepal_R3_Kapan_Tikathali	S324	47	0
890	Nepal_R3_Kapan_Tikathali	S325	48	0
891	Nepal_R3_Kapan_Tikathali	S326	49	0
892	Nepal_R3_Kapan_Tikathali	S327	50	0
893	Nepal_R3_Kapan_Tikathali	S328	51	0
894	Nepal_R3_Kapan_Tikathali	S329	52	0
895	Nepal_R3_Kapan_Tikathali	S330	53	0
896	Nepal_R3_Kapan_Tikathali	S331	54	0
897	Nepal_R3_Tikathali_Kapan	S331	1	0
898	Nepal_R3_Tikathali_Kapan	S330	2	0
899	Nepal_R3_Tikathali_Kapan	S329	3	0
900	Nepal_R3_Tikathali_Kapan	S328	4	0
901	Nepal_R3_Tikathali_Kapan	S327	5	0
902	Nepal_R3_Tikathali_Kapan	S326	6	0
903	Nepal_R3_Tikathali_Kapan	S325	7	0
904	Nepal_R3_Tikathali_Kapan	S324	8	0
905	Nepal_R3_Tikathali_Kapan	S188	9	0
906	Nepal_R3_Tikathali_Kapan	S187	10	0
907	Nepal_R3_Tikathali_Kapan	S195	11	0
908	Nepal_R3_Tikathali_Kapan	S196	12	0
909	Nepal_R3_Tikathali_Kapan	S176	13	0
910	Nepal_R3_Tikathali_Kapan	S92	14	0
911	Nepal_R3_Tikathali_Kapan	S240	15	0
912	Nepal_R3_Tikathali_Kapan	S322	16	0
913	Nepal_R3_Tikathali_Kapan	S321	17	0
914	Nepal_R3_Tikathali_Kapan	S320	18	0
915	Nepal_R3_Tikathali_Kapan	S319	19	0
916	Nepal_R3_Tikathali_Kapan	S319	20	0
917	Nepal_R3_Tikathali_Kapan	S317	21	0
918	Nepal_R3_Tikathali_Kapan	S316	22	0
919	Nepal_R3_Tikathali_Kapan	S315	23	0
920	Nepal_R3_Tikathali_Kapan	S313	24	0
921	Nepal_R3_Tikathali_Kapan	S312	25	0
922	Nepal_R3_Tikathali_Kapan	S311	26	0
923	Nepal_R3_Tikathali_Kapan	S310	27	0
924	Nepal_R3_Tikathali_Kapan	S309	28	0
925	Nepal_R3_Tikathali_Kapan	S308	29	0
926	Nepal_R3_Tikathali_Kapan	S307	30	0
927	Nepal_R3_Tikathali_Kapan	S306	31	0
928	Nepal_R3_Tikathali_Kapan	S12	32	0
929	Nepal_R3_Tikathali_Kapan	S13	33	0
930	Nepal_R3_Tikathali_Kapan	S14	34	0
931	Nepal_R3_Tikathali_Kapan	S15	35	0
932	Nepal_R3_Tikathali_Kapan	S305	36	0
933	Nepal_R3_Tikathali_Kapan	S304	37	0
934	Nepal_R3_Tikathali_Kapan	S303	38	0
935	Nepal_R3_Tikathali_Kapan	S227	39	0
936	Nepal_R3_Tikathali_Kapan	S222	40	0
937	Nepal_R3_Tikathali_Kapan	S223	41	0
938	Nepal_R3_Tikathali_Kapan	S224	42	0
939	Nepal_R3_Tikathali_Kapan	S225	43	0
940	Nepal_R3_Tikathali_Kapan	S302	44	0
941	Nepal_R3_Tikathali_Kapan	S301	45	0
942	Nepal_R3_Tikathali_Kapan	S300	46	0
943	Nepal_R3_Tikathali_Kapan	S299	47	0
944	Nepal_R3_Tikathali_Kapan	S298	48	0
945	Nepal_R3_Tikathali_Kapan	S297	49	0
946	Nepal_R3_Tikathali_Kapan	S296	50	0
947	Nepal_R3_Tikathali_Kapan	S295	51	0
948	Nepal_R3_Tikathali_Kapan	S294	52	0
949	Nepal_R3_Tikathali_Kapan	S293	53	0
950	Mahanagar_R1_Clockwise	S193	1	0
951	Mahanagar_R1_Clockwise	S194	2	0
952	Mahanagar_R1_Clockwise	S332	3	0
953	Mahanagar_R1_Clockwise	S333	4	0
954	Mahanagar_R1_Clockwise	S334	5	0
955	Mahanagar_R1_Clockwise	S335	6	0
956	Mahanagar_R1_Clockwise	S336	7	0
957	Mahanagar_R1_Clockwise	S337	8	0
958	Mahanagar_R1_Clockwise	S338	9	0
959	Mahanagar_R1_Clockwise	S339	10	0
960	Mahanagar_R1_Clockwise	S340	11	0
961	Mahanagar_R1_Clockwise	S341	12	0
962	Mahanagar_R1_Clockwise	S342	13	0
963	Mahanagar_R1_Clockwise	S343	14	0
964	Mahanagar_R1_Clockwise	S102	15	0
965	Mahanagar_R1_Clockwise	S103	16	0
966	Mahanagar_R1_Clockwise	S104	17	0
967	Mahanagar_R1_Clockwise	S105	18	0
968	Mahanagar_R1_Clockwise	S106	19	0
969	Mahanagar_R1_Clockwise	S107	20	0
970	Mahanagar_R1_Clockwise	S108	21	0
971	Mahanagar_R1_Clockwise	S109	22	0
972	Mahanagar_R1_Clockwise	S110	23	0
973	Mahanagar_R1_Clockwise	S111	24	0
974	Mahanagar_R1_Clockwise	S19	25	0
975	Mahanagar_R1_Clockwise	S18	26	0
976	Mahanagar_R1_Clockwise	S17	27	0
977	Mahanagar_R1_Clockwise	S16	28	0
978	Mahanagar_R1_Clockwise	S15	29	0
979	Mahanagar_R1_Clockwise	S305	30	0
980	Mahanagar_R1_Clockwise	S304	31	0
981	Mahanagar_R1_Clockwise	S303	32	0
982	Mahanagar_R1_Clockwise	S344	33	0
983	Mahanagar_R1_Clockwise	S220	34	0
984	Mahanagar_R1_Clockwise	S219	35	0
985	Mahanagar_R1_Clockwise	S345	36	0
986	Mahanagar_R1_Clockwise	S346	37	0
987	Mahanagar_R1_Clockwise	S347	38	0
988	Mahanagar_R1_Clockwise	S348	39	0
989	Mahanagar_R1_Clockwise	S90	40	0
990	Mahanagar_R1_Clockwise	S89	41	0
991	Mahanagar_R1_Clockwise	S349	42	0
992	Mahanagar_R1_Clockwise	S153	43	0
993	Mahanagar_R1_Clockwise	S186	44	0
994	Mahanagar_R1_Clockwise	S187	45	0
995	Mahanagar_R1_Clockwise	S188	46	0
996	Mahanagar_R1_Clockwise	S189	47	0
997	Mahanagar_R1_Clockwise	S190	48	0
998	Mahanagar_R1_Clockwise	S191	49	0
999	Mahanagar_R1_Clockwise	S192	50	0
1000	Mahanagar_R1_Anti-Clockwise	S190	1	0
1001	Mahanagar_R1_Anti-Clockwise	S189	2	0
1002	Mahanagar_R1_Anti-Clockwise	S188	3	0
1003	Mahanagar_R1_Anti-Clockwise	S187	4	0
1004	Mahanagar_R1_Anti-Clockwise	S195	5	0
1005	Mahanagar_R1_Anti-Clockwise	S88	6	0
1006	Mahanagar_R1_Anti-Clockwise	S89	7	0
1007	Mahanagar_R1_Anti-Clockwise	S90	8	0
1008	Mahanagar_R1_Anti-Clockwise	S91	9	0
1009	Mahanagar_R1_Anti-Clockwise	S347	10	0
1010	Mahanagar_R1_Anti-Clockwise	S346	11	0
1011	Mahanagar_R1_Anti-Clockwise	S345	12	0
1012	Mahanagar_R1_Anti-Clockwise	S219	13	0
1013	Mahanagar_R1_Anti-Clockwise	S220	14	0
1014	Mahanagar_R1_Anti-Clockwise	S221	15	0
1015	Mahanagar_R1_Anti-Clockwise	S303	16	0
1016	Mahanagar_R1_Anti-Clockwise	S304	17	0
1017	Mahanagar_R1_Anti-Clockwise	S305	18	0
1018	Mahanagar_R1_Anti-Clockwise	S15	19	0
1019	Mahanagar_R1_Anti-Clockwise	S16	20	0
1020	Mahanagar_R1_Anti-Clockwise	S17	21	0
1021	Mahanagar_R1_Anti-Clockwise	S18	22	0
1022	Mahanagar_R1_Anti-Clockwise	S19	23	0
1023	Mahanagar_R1_Anti-Clockwise	S111	24	0
1024	Mahanagar_R1_Anti-Clockwise	S110	25	0
1025	Mahanagar_R1_Anti-Clockwise	S109	26	0
1026	Mahanagar_R1_Anti-Clockwise	S108	27	0
1027	Mahanagar_R1_Anti-Clockwise	S107	28	0
1028	Mahanagar_R1_Anti-Clockwise	S106	29	0
1029	Mahanagar_R1_Anti-Clockwise	S105	30	0
1030	Mahanagar_R1_Anti-Clockwise	S104	31	0
1031	Mahanagar_R1_Anti-Clockwise	S103	32	0
1032	Mahanagar_R1_Anti-Clockwise	S102	33	0
1033	Mahanagar_R1_Anti-Clockwise	S343	34	0
1034	Mahanagar_R1_Anti-Clockwise	S342	35	0
1035	Mahanagar_R1_Anti-Clockwise	S254	36	0
1036	Mahanagar_R1_Anti-Clockwise	S255	37	0
1037	Mahanagar_R1_Anti-Clockwise	S256	38	0
1038	Mahanagar_R1_Anti-Clockwise	S257	39	0
1039	Mahanagar_R1_Anti-Clockwise	S258	40	0
1040	Mahanagar_R1_Anti-Clockwise	S336	41	0
1041	Mahanagar_R1_Anti-Clockwise	S335	42	0
1042	Mahanagar_R1_Anti-Clockwise	S334	43	0
1043	Mahanagar_R1_Anti-Clockwise	S333	44	0
1044	Mahanagar_R1_Anti-Clockwise	S332	45	0
1045	Mahanagar_R1_Anti-Clockwise	S194	46	0
1046	Mahanagar_R1_Anti-Clockwise	S60	47	0
1047	Mahanagar_R1_Anti-Clockwise	S61	48	0
1048	Mahanagar_R1_Anti-Clockwise	S58	49	0
1049	Riddhi_Siddhi_R1_Thankot_Mulpani	S62	1	0
1050	Riddhi_Siddhi_R1_Thankot_Mulpani	S63	2	0
1051	Riddhi_Siddhi_R1_Thankot_Mulpani	S64	3	0
1052	Riddhi_Siddhi_R1_Thankot_Mulpani	S65	4	0
1053	Riddhi_Siddhi_R1_Thankot_Mulpani	S66	5	0
1054	Riddhi_Siddhi_R1_Thankot_Mulpani	S67	6	0
1055	Riddhi_Siddhi_R1_Thankot_Mulpani	S68	7	0
1056	Riddhi_Siddhi_R1_Thankot_Mulpani	S69	8	0
1057	Riddhi_Siddhi_R1_Thankot_Mulpani	S70	9	0
1058	Riddhi_Siddhi_R1_Thankot_Mulpani	S71	10	0
1059	Riddhi_Siddhi_R1_Thankot_Mulpani	S72	11	0
1060	Riddhi_Siddhi_R1_Thankot_Mulpani	S73	12	0
1061	Riddhi_Siddhi_R1_Thankot_Mulpani	S74	13	0
1062	Riddhi_Siddhi_R1_Thankot_Mulpani	S75	14	0
1063	Riddhi_Siddhi_R1_Thankot_Mulpani	S76	15	0
1064	Riddhi_Siddhi_R1_Thankot_Mulpani	S77	16	0
1065	Riddhi_Siddhi_R1_Thankot_Mulpani	S7	17	0
1066	Riddhi_Siddhi_R1_Thankot_Mulpani	S142	18	0
1067	Riddhi_Siddhi_R1_Thankot_Mulpani	S81	19	0
1068	Riddhi_Siddhi_R1_Thankot_Mulpani	S82	20	0
1069	Riddhi_Siddhi_R1_Thankot_Mulpani	S83	21	0
1070	Riddhi_Siddhi_R1_Thankot_Mulpani	S84	22	0
1071	Riddhi_Siddhi_R1_Thankot_Mulpani	S85	23	0
1072	Riddhi_Siddhi_R1_Thankot_Mulpani	S86	24	0
1073	Riddhi_Siddhi_R1_Thankot_Mulpani	S87	25	0
1074	Riddhi_Siddhi_R1_Thankot_Mulpani	S153	26	0
1075	Riddhi_Siddhi_R1_Thankot_Mulpani	S154	27	0
1076	Riddhi_Siddhi_R1_Thankot_Mulpani	S263	28	0
1077	Riddhi_Siddhi_R1_Thankot_Mulpani	S264	29	0
1078	Riddhi_Siddhi_R1_Thankot_Mulpani	S265	30	0
1079	Riddhi_Siddhi_R1_Thankot_Mulpani	S266	31	0
1080	Riddhi_Siddhi_R1_Thankot_Mulpani	S267	32	0
1081	Riddhi_Siddhi_R1_Thankot_Mulpani	S268	33	0
1082	Riddhi_Siddhi_R1_Thankot_Mulpani	S269	34	0
1083	Riddhi_Siddhi_R1_Thankot_Mulpani	S350	35	0
1084	Riddhi_Siddhi_R1_Thankot_Mulpani	S351	36	0
1085	Riddhi_Siddhi_R1_Thankot_Mulpani	S352	37	0
1086	Riddhi_Siddhi_R1_Thankot_Mulpani	S353	38	0
1087	Riddhi_Siddhi_R1_Thankot_Mulpani	S354	39	0
1088	Riddhi_Siddhi_R1_Thankot_Mulpani	S355	40	0
1089	Riddhi_Siddhi_R1_Thankot_Mulpani	S356	41	0
1090	Riddhi_Siddhi_R1_Mulpani_Thankot	S356	1	0
1091	Riddhi_Siddhi_R1_Mulpani_Thankot	S355	2	0
1092	Riddhi_Siddhi_R1_Mulpani_Thankot	S354	3	0
1093	Riddhi_Siddhi_R1_Mulpani_Thankot	S353	4	0
1094	Riddhi_Siddhi_R1_Mulpani_Thankot	S352	5	0
1095	Riddhi_Siddhi_R1_Mulpani_Thankot	S351	6	0
1096	Riddhi_Siddhi_R1_Mulpani_Thankot	S350	7	0
1097	Riddhi_Siddhi_R1_Mulpani_Thankot	S269	8	0
1098	Riddhi_Siddhi_R1_Mulpani_Thankot	S268	9	0
1099	Riddhi_Siddhi_R1_Mulpani_Thankot	S267	10	0
1100	Riddhi_Siddhi_R1_Mulpani_Thankot	S266	11	0
1101	Riddhi_Siddhi_R1_Mulpani_Thankot	S265	12	0
1102	Riddhi_Siddhi_R1_Mulpani_Thankot	S271	13	0
1103	Riddhi_Siddhi_R1_Mulpani_Thankot	S263	14	0
1104	Riddhi_Siddhi_R1_Mulpani_Thankot	S272	15	0
1105	Riddhi_Siddhi_R1_Mulpani_Thankot	S195	16	0
1106	Riddhi_Siddhi_R1_Mulpani_Thankot	S87	17	0
1107	Riddhi_Siddhi_R1_Mulpani_Thankot	S86	18	0
1108	Riddhi_Siddhi_R1_Mulpani_Thankot	S92	19	0
1109	Riddhi_Siddhi_R1_Mulpani_Thankot	S93	20	0
1110	Riddhi_Siddhi_R1_Mulpani_Thankot	S94	21	0
1111	Riddhi_Siddhi_R1_Mulpani_Thankot	S95	22	0
1112	Riddhi_Siddhi_R1_Mulpani_Thankot	S96	23	0
1113	Riddhi_Siddhi_R1_Mulpani_Thankot	S97	24	0
1114	Riddhi_Siddhi_R1_Mulpani_Thankot	S98	25	0
1115	Riddhi_Siddhi_R1_Mulpani_Thankot	S23	26	0
1116	Riddhi_Siddhi_R1_Mulpani_Thankot	S7	27	0
1117	Riddhi_Siddhi_R1_Mulpani_Thankot	S99	28	0
1118	Riddhi_Siddhi_R1_Mulpani_Thankot	S100	29	0
1119	Riddhi_Siddhi_R1_Mulpani_Thankot	S75	30	0
1120	Riddhi_Siddhi_R1_Mulpani_Thankot	S74	31	0
1121	Riddhi_Siddhi_R1_Mulpani_Thankot	S73	32	0
1122	Riddhi_Siddhi_R1_Mulpani_Thankot	S72	33	0
1123	Riddhi_Siddhi_R1_Mulpani_Thankot	S71	34	0
1124	Riddhi_Siddhi_R1_Mulpani_Thankot	S70	35	0
1125	Riddhi_Siddhi_R1_Mulpani_Thankot	S69	36	0
1126	Riddhi_Siddhi_R1_Mulpani_Thankot	S68	37	0
1127	Riddhi_Siddhi_R1_Mulpani_Thankot	S67	38	0
1128	Riddhi_Siddhi_R1_Mulpani_Thankot	S66	39	0
1129	Riddhi_Siddhi_R1_Mulpani_Thankot	S65	40	0
1130	Riddhi_Siddhi_R1_Mulpani_Thankot	S64	41	0
1131	Riddhi_Siddhi_R1_Mulpani_Thankot	S63	42	0
1132	Riddhi_Siddhi_R1_Mulpani_Thankot	S62	43	0
1133	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S8	1	0
1134	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S78	2	0
1135	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S22	3	0
1136	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S79	4	0
1137	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S80	5	0
1138	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S81	6	0
1139	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S82	7	0
1140	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S83	8	0
1141	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S84	9	0
1142	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S85	10	0
1143	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S86	11	0
1144	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S87	12	0
1145	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S153	13	0
1146	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S186	14	0
1147	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S187	15	0
1148	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S188	16	0
1149	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S189	17	0
1150	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S190	18	0
1151	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S191	19	0
1152	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S192	20	0
1153	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S250	21	0
1154	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S57	22	0
1155	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S56	23	0
1156	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S55	24	0
1157	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S54	25	0
1158	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S53	26	0
1159	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S52	27	0
1160	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S51	28	0
1161	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S50	29	0
1162	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S357	30	0
1163	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S358	31	0
1164	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S359	32	0
1165	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S360	33	0
1166	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S361	34	0
1167	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S362	35	0
1168	Riddhi_Siddhi_R2_RNAC_Harisiddhi	S363	36	0
1169	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S363	1	0
1170	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S362	2	0
1171	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S361	3	0
1172	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S360	4	0
1173	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S359	5	0
1174	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S358	6	0
1175	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S357	7	0
1176	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S50	8	0
1177	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S51	9	0
1178	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S52	10	0
1179	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S53	11	0
1180	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S54	12	0
1181	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S55	13	0
1182	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S56	14	0
1183	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S57	15	0
1184	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S250	16	0
1185	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S192	17	0
1186	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S190	18	0
1187	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S189	19	0
1188	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S188	20	0
1189	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S187	21	0
1190	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S195	22	0
1191	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S87	23	0
1192	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S86	24	0
1193	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S92	25	0
1194	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S93	26	0
1195	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S94	27	0
1196	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S95	28	0
1197	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S96	29	0
1198	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S97	30	0
1199	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S98	31	0
1200	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S23	32	0
1201	Riddhi_Siddhi_R2_Harisiddhi_RNAC	S8	33	0
1202	Bhaktapur_R1_Bhaktapur_Kalanki	S364	1	0
1203	Bhaktapur_R1_Bhaktapur_Kalanki	S365	2	0
1204	Bhaktapur_R1_Bhaktapur_Kalanki	S365	3	0
1205	Bhaktapur_R1_Bhaktapur_Kalanki	S366	4	0
1206	Bhaktapur_R1_Bhaktapur_Kalanki	S367	5	0
1207	Bhaktapur_R1_Bhaktapur_Kalanki	S368	6	0
1208	Bhaktapur_R1_Bhaktapur_Kalanki	S369	7	0
1209	Bhaktapur_R1_Bhaktapur_Kalanki	S370	8	0
1210	Bhaktapur_R1_Bhaktapur_Kalanki	S371	9	0
1211	Bhaktapur_R1_Bhaktapur_Kalanki	S372	10	0
1212	Bhaktapur_R1_Bhaktapur_Kalanki	S373	11	0
1213	Bhaktapur_R1_Bhaktapur_Kalanki	S374	12	0
1214	Bhaktapur_R1_Bhaktapur_Kalanki	S171	13	0
1215	Bhaktapur_R1_Bhaktapur_Kalanki	S172	14	0
1216	Bhaktapur_R1_Bhaktapur_Kalanki	S173	15	0
1217	Bhaktapur_R1_Bhaktapur_Kalanki	S186	16	0
1218	Bhaktapur_R1_Bhaktapur_Kalanki	S187	17	0
1219	Bhaktapur_R1_Bhaktapur_Kalanki	S188	18	0
1220	Bhaktapur_R1_Bhaktapur_Kalanki	S189	19	0
1221	Bhaktapur_R1_Bhaktapur_Kalanki	S190	20	0
1222	Bhaktapur_R1_Bhaktapur_Kalanki	S191	21	0
1223	Bhaktapur_R1_Bhaktapur_Kalanki	S192	22	0
1224	Bhaktapur_R1_Bhaktapur_Kalanki	S193	23	0
1225	Bhaktapur_R1_Bhaktapur_Kalanki	S194	24	0
1226	Bhaktapur_R1_Bhaktapur_Kalanki	S332	25	0
1227	Bhaktapur_R1_Bhaktapur_Kalanki	S333	26	0
1228	Bhaktapur_R1_Bhaktapur_Kalanki	S334	27	0
1229	Bhaktapur_R1_Bhaktapur_Kalanki	S335	28	0
1230	Bhaktapur_R1_Bhaktapur_Kalanki	S336	29	0
1231	Bhaktapur_R1_Bhaktapur_Kalanki	S337	30	0
1232	Bhaktapur_R1_Bhaktapur_Kalanki	S338	31	0
1233	Bhaktapur_R1_Bhaktapur_Kalanki	S339	32	0
1234	Bhaktapur_R1_Bhaktapur_Kalanki	S340	33	0
1235	Bhaktapur_R1_Bhaktapur_Kalanki	S341	34	0
1236	Bhaktapur_R1_Bhaktapur_Kalanki	S342	35	0
1237	Bhaktapur_R1_Bhaktapur_Kalanki	S343	36	0
1238	Bhaktapur_R1_Bhaktapur_Kalanki	S102	37	0
1239	Bhaktapur_R1_Kalanki_Bhaktapur	S102	1	0
1240	Bhaktapur_R1_Kalanki_Bhaktapur	S343	2	0
1241	Bhaktapur_R1_Kalanki_Bhaktapur	S342	3	0
1242	Bhaktapur_R1_Kalanki_Bhaktapur	S254	4	0
1243	Bhaktapur_R1_Kalanki_Bhaktapur	S255	5	0
1244	Bhaktapur_R1_Kalanki_Bhaktapur	S256	6	0
1245	Bhaktapur_R1_Kalanki_Bhaktapur	S257	7	0
1246	Bhaktapur_R1_Kalanki_Bhaktapur	S258	8	0
1247	Bhaktapur_R1_Kalanki_Bhaktapur	S336	9	0
1248	Bhaktapur_R1_Kalanki_Bhaktapur	S335	10	0
1249	Bhaktapur_R1_Kalanki_Bhaktapur	S334	11	0
1250	Bhaktapur_R1_Kalanki_Bhaktapur	S333	12	0
1251	Bhaktapur_R1_Kalanki_Bhaktapur	S332	13	0
1252	Bhaktapur_R1_Kalanki_Bhaktapur	S194	14	0
1253	Bhaktapur_R1_Kalanki_Bhaktapur	S60	15	0
1254	Bhaktapur_R1_Kalanki_Bhaktapur	S61	16	0
1255	Bhaktapur_R1_Kalanki_Bhaktapur	S58	17	0
1256	Bhaktapur_R1_Kalanki_Bhaktapur	S190	18	0
1257	Bhaktapur_R1_Kalanki_Bhaktapur	S189	19	0
1258	Bhaktapur_R1_Kalanki_Bhaktapur	S188	20	0
1259	Bhaktapur_R1_Kalanki_Bhaktapur	S187	21	0
1260	Bhaktapur_R1_Kalanki_Bhaktapur	S153	22	0
1261	Bhaktapur_R1_Kalanki_Bhaktapur	S154	23	0
1262	Bhaktapur_R1_Kalanki_Bhaktapur	S155	24	0
1263	Bhaktapur_R1_Kalanki_Bhaktapur	S156	25	0
1264	Bhaktapur_R1_Kalanki_Bhaktapur	S374	26	0
1265	Bhaktapur_R1_Kalanki_Bhaktapur	S373	27	0
1266	Bhaktapur_R1_Kalanki_Bhaktapur	S372	28	0
1267	Bhaktapur_R1_Kalanki_Bhaktapur	S371	29	0
1268	Bhaktapur_R1_Kalanki_Bhaktapur	S370	30	0
1269	Bhaktapur_R1_Kalanki_Bhaktapur	S369	31	0
1270	Bhaktapur_R1_Kalanki_Bhaktapur	S368	32	0
1271	Bhaktapur_R1_Kalanki_Bhaktapur	S367	33	0
1272	Bhaktapur_R1_Kalanki_Bhaktapur	S366	34	0
1273	Bhaktapur_R1_Kalanki_Bhaktapur	S365	35	0
1274	Bhaktapur_R1_Kalanki_Bhaktapur	S365	36	0
1275	Bhaktapur_R1_Kalanki_Bhaktapur	S364	37	0
1276	Bhaktapur_R2_Bhaktapur_Lagankhel	S364	1	0
1277	Bhaktapur_R2_Bhaktapur_Lagankhel	S365	2	0
1278	Bhaktapur_R2_Bhaktapur_Lagankhel	S365	3	0
1279	Bhaktapur_R2_Bhaktapur_Lagankhel	S366	4	0
1280	Bhaktapur_R2_Bhaktapur_Lagankhel	S367	5	0
1281	Bhaktapur_R2_Bhaktapur_Lagankhel	S368	6	0
1282	Bhaktapur_R2_Bhaktapur_Lagankhel	S369	7	0
1283	Bhaktapur_R2_Bhaktapur_Lagankhel	S370	8	0
1284	Bhaktapur_R2_Bhaktapur_Lagankhel	S371	9	0
1285	Bhaktapur_R2_Bhaktapur_Lagankhel	S372	10	0
1286	Bhaktapur_R2_Bhaktapur_Lagankhel	S373	11	0
1287	Bhaktapur_R2_Bhaktapur_Lagankhel	S374	12	0
1288	Bhaktapur_R2_Bhaktapur_Lagankhel	S171	13	0
1289	Bhaktapur_R2_Bhaktapur_Lagankhel	S172	14	0
1290	Bhaktapur_R2_Bhaktapur_Lagankhel	S173	15	0
1291	Bhaktapur_R2_Bhaktapur_Lagankhel	S186	16	0
1292	Bhaktapur_R2_Bhaktapur_Lagankhel	S187	17	0
1293	Bhaktapur_R2_Bhaktapur_Lagankhel	S188	18	0
1294	Bhaktapur_R2_Bhaktapur_Lagankhel	S189	19	0
1295	Bhaktapur_R2_Bhaktapur_Lagankhel	S190	20	0
1296	Bhaktapur_R2_Bhaktapur_Lagankhel	S191	21	0
1297	Bhaktapur_R2_Bhaktapur_Lagankhel	S192	22	0
1298	Bhaktapur_R2_Bhaktapur_Lagankhel	S193	23	0
1299	Bhaktapur_R2_Bhaktapur_Lagankhel	S194	24	0
1300	Bhaktapur_R2_Bhaktapur_Lagankhel	S1	25	0
1301	Bhaktapur_R2_Lagankhel_Bhaktapur	S1	1	0
1302	Bhaktapur_R2_Lagankhel_Bhaktapur	S194	2	0
1303	Bhaktapur_R2_Lagankhel_Bhaktapur	S60	3	0
1304	Bhaktapur_R2_Lagankhel_Bhaktapur	S61	4	0
1305	Bhaktapur_R2_Lagankhel_Bhaktapur	S58	5	0
1306	Bhaktapur_R2_Lagankhel_Bhaktapur	S190	6	0
1307	Bhaktapur_R2_Lagankhel_Bhaktapur	S189	7	0
1308	Bhaktapur_R2_Lagankhel_Bhaktapur	S188	8	0
1309	Bhaktapur_R2_Lagankhel_Bhaktapur	S187	9	0
1310	Bhaktapur_R2_Lagankhel_Bhaktapur	S153	10	0
1311	Bhaktapur_R2_Lagankhel_Bhaktapur	S154	11	0
1312	Bhaktapur_R2_Lagankhel_Bhaktapur	S155	12	0
1313	Bhaktapur_R2_Lagankhel_Bhaktapur	S156	13	0
1314	Bhaktapur_R2_Lagankhel_Bhaktapur	S374	14	0
1315	Bhaktapur_R2_Lagankhel_Bhaktapur	S373	15	0
1316	Bhaktapur_R2_Lagankhel_Bhaktapur	S372	16	0
1317	Bhaktapur_R2_Lagankhel_Bhaktapur	S371	17	0
1318	Bhaktapur_R2_Lagankhel_Bhaktapur	S370	18	0
1319	Bhaktapur_R2_Lagankhel_Bhaktapur	S369	19	0
1320	Bhaktapur_R2_Lagankhel_Bhaktapur	S368	20	0
1321	Bhaktapur_R2_Lagankhel_Bhaktapur	S367	21	0
1322	Bhaktapur_R2_Lagankhel_Bhaktapur	S366	22	0
1323	Bhaktapur_R2_Lagankhel_Bhaktapur	S365	23	0
1324	Bhaktapur_R2_Lagankhel_Bhaktapur	S365	24	0
1325	Bhaktapur_R2_Lagankhel_Bhaktapur	S364	25	0
1326	Bhaktapur_R3_Bhaktapur_RNAC	S364	1	0
1327	Bhaktapur_R3_Bhaktapur_RNAC	S365	2	0
1328	Bhaktapur_R3_Bhaktapur_RNAC	S365	3	0
1329	Bhaktapur_R3_Bhaktapur_RNAC	S366	4	0
1330	Bhaktapur_R3_Bhaktapur_RNAC	S367	5	0
1331	Bhaktapur_R3_Bhaktapur_RNAC	S368	6	0
1332	Bhaktapur_R3_Bhaktapur_RNAC	S369	7	0
1333	Bhaktapur_R3_Bhaktapur_RNAC	S370	8	0
1334	Bhaktapur_R3_Bhaktapur_RNAC	S371	9	0
1335	Bhaktapur_R3_Bhaktapur_RNAC	S372	10	0
1336	Bhaktapur_R3_Bhaktapur_RNAC	S373	11	0
1337	Bhaktapur_R3_Bhaktapur_RNAC	S374	12	0
1338	Bhaktapur_R3_Bhaktapur_RNAC	S171	13	0
1339	Bhaktapur_R3_Bhaktapur_RNAC	S172	14	0
1340	Bhaktapur_R3_Bhaktapur_RNAC	S173	15	0
1341	Bhaktapur_R3_Bhaktapur_RNAC	S195	16	0
1342	Bhaktapur_R3_Bhaktapur_RNAC	S87	17	0
1343	Bhaktapur_R3_Bhaktapur_RNAC	S86	18	0
1344	Bhaktapur_R3_Bhaktapur_RNAC	S92	19	0
1345	Bhaktapur_R3_Bhaktapur_RNAC	S93	20	0
1346	Bhaktapur_R3_Bhaktapur_RNAC	S94	21	0
1347	Bhaktapur_R3_Bhaktapur_RNAC	S95	22	0
1348	Bhaktapur_R3_Bhaktapur_RNAC	S96	23	0
1349	Bhaktapur_R3_Bhaktapur_RNAC	S97	24	0
1350	Bhaktapur_R3_Bhaktapur_RNAC	S98	25	0
1351	Bhaktapur_R3_Bhaktapur_RNAC	S23	26	0
1352	Bhaktapur_R3_Bhaktapur_RNAC	S8	27	0
1353	Bhaktapur_R3_RNAC_Bhaktapur	S8	1	0
1354	Bhaktapur_R3_RNAC_Bhaktapur	S78	2	0
1355	Bhaktapur_R3_RNAC_Bhaktapur	S22	3	0
1356	Bhaktapur_R3_RNAC_Bhaktapur	S79	4	0
1357	Bhaktapur_R3_RNAC_Bhaktapur	S80	5	0
1358	Bhaktapur_R3_RNAC_Bhaktapur	S81	6	0
1359	Bhaktapur_R3_RNAC_Bhaktapur	S82	7	0
1360	Bhaktapur_R3_RNAC_Bhaktapur	S83	8	0
1361	Bhaktapur_R3_RNAC_Bhaktapur	S84	9	0
1362	Bhaktapur_R3_RNAC_Bhaktapur	S85	10	0
1363	Bhaktapur_R3_RNAC_Bhaktapur	S86	11	0
1364	Bhaktapur_R3_RNAC_Bhaktapur	S87	12	0
1365	Bhaktapur_R3_RNAC_Bhaktapur	S153	13	0
1366	Bhaktapur_R3_RNAC_Bhaktapur	S154	14	0
1367	Bhaktapur_R3_RNAC_Bhaktapur	S155	15	0
1368	Bhaktapur_R3_RNAC_Bhaktapur	S156	16	0
1369	Bhaktapur_R3_RNAC_Bhaktapur	S374	17	0
1370	Bhaktapur_R3_RNAC_Bhaktapur	S373	18	0
1371	Bhaktapur_R3_RNAC_Bhaktapur	S372	19	0
1372	Bhaktapur_R3_RNAC_Bhaktapur	S371	20	0
1373	Bhaktapur_R3_RNAC_Bhaktapur	S370	21	0
1374	Bhaktapur_R3_RNAC_Bhaktapur	S369	22	0
1375	Bhaktapur_R3_RNAC_Bhaktapur	S368	23	0
1376	Bhaktapur_R3_RNAC_Bhaktapur	S367	24	0
1377	Bhaktapur_R3_RNAC_Bhaktapur	S366	25	0
1378	Bhaktapur_R3_RNAC_Bhaktapur	S365	26	0
1379	Bhaktapur_R3_RNAC_Bhaktapur	S365	27	0
1380	Bhaktapur_R3_RNAC_Bhaktapur	S364	28	0
1381	Micro_R1_RNAC_Kritipur	S8	1	0
1382	Micro_R1_RNAC_Kritipur	S78	2	0
1383	Micro_R1_RNAC_Kritipur	S22	3	0
1384	Micro_R1_RNAC_Kritipur	S23	4	0
1385	Micro_R1_RNAC_Kritipur	S7	5	0
1386	Micro_R1_RNAC_Kritipur	S99	6	0
1387	Micro_R1_RNAC_Kritipur	S100	7	0
1388	Micro_R1_RNAC_Kritipur	S273	8	0
1389	Micro_R1_RNAC_Kritipur	S274	9	0
1390	Micro_R1_RNAC_Kritipur	S275	10	0
1391	Micro_R1_RNAC_Kritipur	S254	11	0
1392	Micro_R1_RNAC_Kritipur	S375	12	0
1393	Micro_R1_RNAC_Kritipur	S376	13	0
1394	Micro_R1_RNAC_Kritipur	S377	14	0
1395	Micro_R1_RNAC_Kritipur	S378	15	0
1396	Micro_R1_RNAC_Kritipur	S379	16	0
1397	Micro_R1_RNAC_Kritipur	S380	17	0
1398	Micro_R1_Kritipur_RNAC	S380	1	0
1399	Micro_R1_Kritipur_RNAC	S379	2	0
1400	Micro_R1_Kritipur_RNAC	S378	3	0
1401	Micro_R1_Kritipur_RNAC	S377	4	0
1402	Micro_R1_Kritipur_RNAC	S376	5	0
1403	Micro_R1_Kritipur_RNAC	S375	6	0
1404	Micro_R1_Kritipur_RNAC	S254	9	0
1405	Micro_R1_Kritipur_RNAC	S275	10	0
1406	Micro_R1_Kritipur_RNAC	S274	11	0
1407	Micro_R1_Kritipur_RNAC	S273	12	0
1408	Micro_R1_Kritipur_RNAC	S100	13	0
1409	Micro_R1_Kritipur_RNAC	S99	14	0
1410	Micro_R1_Kritipur_RNAC	S7	15	0
1411	Micro_R1_Kritipur_RNAC	S8	16	0
1412	Local_R1_Lagankhel_Tikathali	S1	1	0
1413	Local_R1_Lagankhel_Tikathali	S194	2	0
1414	Local_R1_Lagankhel_Tikathali	S60	3	0
1415	Local_R1_Lagankhel_Tikathali	S61	4	0
1416	Local_R1_Lagankhel_Tikathali	S192	5	0
1417	Local_R1_Lagankhel_Tikathali	S250	6	0
1418	Local_R1_Lagankhel_Tikathali	S57	7	0
1419	Local_R1_Lagankhel_Tikathali	S56	8	0
1420	Local_R1_Lagankhel_Tikathali	S55	9	0
1421	Local_R1_Lagankhel_Tikathali	S54	10	0
1422	Local_R1_Lagankhel_Tikathali	S381	11	0
1423	Local_R1_Lagankhel_Tikathali	S382	12	0
1424	Local_R1_Lagankhel_Tikathali	S383	13	0
1425	Local_R1_Lagankhel_Tikathali	S384	14	0
1426	Local_R1_Lagankhel_Tikathali	S385	15	0
1427	Local_R1_Lagankhel_Tikathali	S386	16	0
1428	Local_R1_Tikathali_Lagankhel	S386	1	0
1429	Local_R1_Tikathali_Lagankhel	S385	2	0
1430	Local_R1_Tikathali_Lagankhel	S384	3	0
1431	Local_R1_Tikathali_Lagankhel	S383	4	0
1432	Local_R1_Tikathali_Lagankhel	S382	5	0
1433	Local_R1_Tikathali_Lagankhel	S381	6	0
1434	Local_R1_Tikathali_Lagankhel	S54	7	0
1435	Local_R1_Tikathali_Lagankhel	S55	8	0
1436	Local_R1_Tikathali_Lagankhel	S56	9	0
1437	Local_R1_Tikathali_Lagankhel	S57	10	0
1438	Local_R1_Tikathali_Lagankhel	S250	11	0
1439	Local_R1_Tikathali_Lagankhel	S192	12	0
1440	Local_R1_Tikathali_Lagankhel	S61	13	0
1441	Local_R1_Tikathali_Lagankhel	S60	14	0
1442	Local_R1_Tikathali_Lagankhel	S194	15	0
1443	Local_R1_Tikathali_Lagankhel	S1	16	0
1444	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S387	1	0
1445	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S388	2	0
1446	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S389	3	0
1447	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S390	4	0
1448	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S391	5	0
1449	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S392	6	0
1450	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S393	7	0
1451	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S394	8	0
1452	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S344	9	0
1453	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S220	10	0
1454	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S219	11	0
1455	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S345	12	0
1456	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S346	13	0
1457	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S347	14	0
1458	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S348	15	0
1459	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S90	16	0
1460	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S89	17	0
1461	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S349	18	0
1462	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S153	19	0
1463	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S186	20	0
1464	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S187	21	0
1465	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S188	22	0
1466	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S189	23	0
1467	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S190	24	0
1468	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S191	25	0
1469	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S192	26	0
1470	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S193	27	0
1471	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S194	28	0
1472	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S332	29	0
1473	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S333	30	0
1474	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S334	31	0
1475	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S335	32	0
1476	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S336	33	0
1477	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S337	34	0
1478	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S338	35	0
1479	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S339	36	0
1480	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S340	37	0
1481	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S341	38	0
1482	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S342	39	0
1483	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S343	40	0
1484	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S102	41	0
1485	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S103	42	0
1486	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S104	43	0
1487	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S105	44	0
1488	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S106	45	0
1489	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S107	46	0
1490	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S108	47	0
1491	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S109	48	0
1492	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S110	49	0
1493	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S111	50	0
1494	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S19	51	0
1495	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S18	52	0
1496	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S17	53	0
1497	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S16	54	0
1498	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S15	55	0
1499	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S305	56	0
1500	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S304	57	0
1501	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	S303	58	0
1502	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S303	1	0
1503	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S304	2	0
1504	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S305	3	0
1505	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S15	4	0
1506	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S16	5	0
1507	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S17	6	0
1508	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S18	7	0
1509	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S19	8	0
1510	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S111	9	0
1511	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S110	10	0
1512	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S109	11	0
1513	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S108	12	0
1514	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S107	13	0
1515	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S106	14	0
1516	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S105	15	0
1517	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S104	16	0
1518	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S103	17	0
1519	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S102	18	0
1520	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S343	19	0
1521	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S342	20	0
1522	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S254	21	0
1523	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S255	22	0
1524	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S256	23	0
1525	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S257	24	0
1526	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S258	25	0
1527	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S336	26	0
1528	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S335	27	0
1529	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S334	28	0
1530	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S333	29	0
1531	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S332	30	0
1532	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S194	31	0
1533	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S60	32	0
1534	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S61	33	0
1535	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S58	34	0
1536	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S190	35	0
1537	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S189	36	0
1538	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S188	37	0
1539	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S187	38	0
1540	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S195	39	0
1541	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S88	40	0
1542	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S89	41	0
1543	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S90	42	0
1544	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S91	43	0
1545	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S347	44	0
1546	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S346	45	0
1547	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S345	46	0
1548	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S219	47	0
1549	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S220	48	0
1550	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S221	49	0
1551	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S222	50	0
1552	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S223	51	0
1553	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S393	52	0
1554	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S392	53	0
1555	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S391	54	0
1556	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S390	55	0
1557	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S389	56	0
1558	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S388	57	0
1559	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	S387	58	0
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routes (id, name, operator, vehicle_type, color) FROM stdin;
Sajha_R1_Lagankhel_Gongabu	Sajha_R1_Lagankhel_Gongabu	Sajha	bus	\N
Sajha_R1_Gongabu_Lagankhel	Sajha_R1_Gongabu_Lagankhel	Sajha	bus	\N
Sajha_R2_Lagankhel_Budhanilkantha	Sajha_R2_Lagankhel_Budhanilkantha	Sajha	bus	\N
Sajha_R2_Budhanilkantha_Lagnakhel	Sajha_R2_Budhanilkantha_Lagnakhel	Sajha	bus	\N
Sajha_R3_Godawari_RNAC	Sajha_R3_Godawari_RNAC	Sajha	bus	\N
Sajha_R3_RNAC_Godawari	Sajha_R3_RNAC_Godawari	Sajha	bus	\N
Sajha_R4_Lamatar_RNAC	Sajha_R4_Lamatar_RNAC	Sajha	bus	\N
Sajha_R4_RNAC_Lamatar	Sajha_R4_RNAC_Lamatar	Sajha	bus	\N
Sajha_R5_Thankot_Airport	Sajha_R5_Thankot_Airport	Sajha	bus	\N
Sajha_R5_Airport_Thankot	Sajha_R5_Airport_Thankot	Sajha	bus	\N
Sajha_R6_Thankot_Budhanilkantha	Sajha_R6_Thankot_Budhanilkantha	Sajha	bus	\N
Sajha_R6_Budhanilkantha_Thankot	Sajha_R6_Budhanilkantha_Thankot	Sajha	bus	\N
Sajha_R7_Lele_Jamal	Sajha_R7_Lele_Jamal	Sajha	bus	\N
Sajha_R7_Jamal_Lele	Sajha_R7_Jamal_Lele	Sajha	bus	\N
Sajha_R8_Bungamati_Jamal	Sajha_R8_Bungamati_Jamal	Sajha	bus	\N
Sajha_R8_Jamal_Bungamati	Sajha_R8_Jamal_Bungamati	Sajha	bus	\N
Jharana_R1_Jamal_Ranibu	Jharana_R1_Jamal_Ranibu	Jharana	bus	\N
Jharana_R1_Ranibu_Jamal	Jharana_R1_Ranibu_Jamal	Jharana	bus	\N
Subhakamana_R1_Swayambhu_Biruwa	Subhakamana_R1_Swayambhu_Biruwa	Subhakamana	bus	\N
Subhakamana_R1_Biruwa_Swayambhu	Subhakamana_R1_Biruwa_Swayambhu	Subhakamana	bus	\N
Tempo_R1_Maitighar_Lagankhel	Tempo_R1_Maitighar_Lagankhel	Tempo	bus	\N
Tempo_R1_lagankhel_maitighar	Tempo_R1_lagankhel_maitighar	Tempo	bus	\N
Tempo_R2_RNAC_Sinamangal	Tempo_R2_RNAC_Sinamangal	Tempo	bus	\N
Tempo_R2_Sinamangal_RNAC	Tempo_R2_Sinamangal_RNAC	Tempo	bus	\N
Tempo_R3_RNAC_Tinchuli	Tempo_R3_RNAC_Tinchuli	Tempo	bus	\N
Tempo_R3_Tinchuli_RNAC	Tempo_R3_Tinchuli_RNAC	Tempo	bus	\N
Tempo_R4_Kapan _ Sankhamul	Tempo_R4_Kapan _ Sankhamul	Tempo	bus	\N
Tempo_R4_Sankhamul_Kapan	Tempo_R4_Sankhamul_Kapan	Tempo	bus	\N
Tempo_R5_Ratnapark_Imadol	Tempo_R5_Ratnapark_Imadol	Tempo	bus	\N
Tempo_R5_Imadol_Ratnapark	Tempo_R5_Imadol_Ratnapark	Tempo	bus	\N
Nepal_R1_Balkhu_Harhar_Mahadev	Nepal_R1_Balkhu_Harhar_Mahadev	Nepal	bus	\N
Nepal_R1_Harhar_Mahadev_Balkhu	Nepal_R1_Harhar_Mahadev_Balkhu	Nepal	bus	\N
Nepal_R2_Mulpani_Ghantaghar	Nepal_R2_Mulpani_Ghantaghar	Nepal	bus	\N
Nepal_R2_Ghantaghar_Mulpani	Nepal_R2_Ghantaghar_Mulpani	Nepal	bus	\N
Nepal_R3_Kapan_Tikathali	Nepal_R3_Kapan_Tikathali	Nepal	bus	\N
Nepal_R3_Tikathali_Kapan	Nepal_R3_Tikathali_Kapan	Nepal	bus	\N
Mahanagar_R1_Clockwise	Mahanagar_R1_Clockwise	Mahanagar	bus	\N
Mahanagar_R1_Anti-Clockwise	Mahanagar_R1_Anti-Clockwise	Mahanagar	bus	\N
Riddhi_Siddhi_R1_Thankot_Mulpani	Riddhi_Siddhi_R1_Thankot_Mulpani	Riddhi	bus	\N
Riddhi_Siddhi_R1_Mulpani_Thankot	Riddhi_Siddhi_R1_Mulpani_Thankot	Riddhi	bus	\N
Riddhi_Siddhi_R2_RNAC_Harisiddhi	Riddhi_Siddhi_R2_RNAC_Harisiddhi	Riddhi	bus	\N
Riddhi_Siddhi_R2_Harisiddhi_RNAC	Riddhi_Siddhi_R2_Harisiddhi_RNAC	Riddhi	bus	\N
Bhaktapur_R1_Bhaktapur_Kalanki	Bhaktapur_R1_Bhaktapur_Kalanki	Bhaktapur	bus	\N
Bhaktapur_R1_Kalanki_Bhaktapur	Bhaktapur_R1_Kalanki_Bhaktapur	Bhaktapur	bus	\N
Bhaktapur_R2_Bhaktapur_Lagankhel	Bhaktapur_R2_Bhaktapur_Lagankhel	Bhaktapur	bus	\N
Bhaktapur_R2_Lagankhel_Bhaktapur	Bhaktapur_R2_Lagankhel_Bhaktapur	Bhaktapur	bus	\N
Bhaktapur_R3_Bhaktapur_RNAC	Bhaktapur_R3_Bhaktapur_RNAC	Bhaktapur	bus	\N
Bhaktapur_R3_RNAC_Bhaktapur	Bhaktapur_R3_RNAC_Bhaktapur	Bhaktapur	bus	\N
Micro_R1_RNAC_Kritipur	Micro_R1_RNAC_Kritipur	Micro	bus	\N
Micro_R1_Kritipur_RNAC	Micro_R1_Kritipur_RNAC	Micro	bus	\N
Local_R1_Lagankhel_Tikathali	Local_R1_Lagankhel_Tikathali	Local	bus	\N
Local_R1_Tikathali_Lagankhel	Local_R1_Tikathali_Lagankhel	Local	bus	\N
Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	Gokarneshwor	bus	\N
Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	Gokarneshwor	bus	\N
\.


--
-- Data for Name: routing_edges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routing_edges (id, source, target, route_id, cost_time, cost_transfers, distance_km, is_transfer, reverse_cost) FROM stdin;
1	1	2	Sajha_R1_Lagankhel_Gongabu	1.401638361168241	0	0.4672127870560804	0	-1
2	2	3	Sajha_R1_Lagankhel_Gongabu	2.013963059285668	0	0.6713210197618893	0	-1
3	3	4	Sajha_R1_Lagankhel_Gongabu	1.3185723702654397	0	0.43952412342181324	0	-1
4	4	5	Sajha_R1_Lagankhel_Gongabu	1.6030493302447857	0	0.5343497767482619	0	-1
5	5	6	Sajha_R1_Lagankhel_Gongabu	2.4191092093965567	0	0.806369736465519	0	-1
6	6	7	Sajha_R1_Lagankhel_Gongabu	1.8541164585969423	0	0.6180388195323141	0	-1
7	7	8	Sajha_R1_Lagankhel_Gongabu	2.6369476097657105	0	0.8789825365885702	0	-1
8	8	9	Sajha_R1_Lagankhel_Gongabu	5.426721390448877	0	1.8089071301496258	0	-1
9	9	10	Sajha_R1_Lagankhel_Gongabu	1.9329923165959015	0	0.6443307721986338	0	-1
10	10	11	Sajha_R1_Lagankhel_Gongabu	2.6816870441983682	0	0.8938956813994562	0	-1
11	11	12	Sajha_R1_Lagankhel_Gongabu	1.8977617763041934	0	0.6325872587680644	0	-1
12	12	13	Sajha_R1_Lagankhel_Gongabu	0.9684214932415179	0	0.3228071644138393	0	-1
13	13	14	Sajha_R1_Lagankhel_Gongabu	1.7202528367352408	0	0.5734176122450803	0	-1
14	14	15	Sajha_R1_Lagankhel_Gongabu	0.64592466254204	0	0.21530822084734666	0	-1
15	15	16	Sajha_R1_Lagankhel_Gongabu	1.0883210921535043	0	0.36277369738450144	0	-1
16	16	17	Sajha_R1_Lagankhel_Gongabu	2.7957488391181737	0	0.9319162797060578	0	-1
17	17	18	Sajha_R1_Lagankhel_Gongabu	1.4999174232372166	0	0.4999724744124055	0	-1
18	18	19	Sajha_R1_Lagankhel_Gongabu	1.9521431823395705	0	0.6507143941131901	0	-1
19	19	20	Sajha_R1_Lagankhel_Gongabu	1.4558739103122404	0	0.4852913034374135	0	-1
20	21	22	Sajha_R1_Gongabu_Lagankhel	1.4558739103122404	0	0.4852913034374135	0	-1
21	22	23	Sajha_R1_Gongabu_Lagankhel	1.9521431823395705	0	0.6507143941131901	0	-1
22	23	24	Sajha_R1_Gongabu_Lagankhel	1.4999174232372166	0	0.4999724744124055	0	-1
23	24	25	Sajha_R1_Gongabu_Lagankhel	2.7957488391181737	0	0.9319162797060578	0	-1
24	25	26	Sajha_R1_Gongabu_Lagankhel	1.0883210921535043	0	0.36277369738450144	0	-1
25	26	27	Sajha_R1_Gongabu_Lagankhel	0.64592466254204	0	0.21530822084734666	0	-1
26	27	28	Sajha_R1_Gongabu_Lagankhel	1.7202528367352408	0	0.5734176122450803	0	-1
27	28	29	Sajha_R1_Gongabu_Lagankhel	0.9684214932415179	0	0.3228071644138393	0	-1
28	29	30	Sajha_R1_Gongabu_Lagankhel	1.8977617763041934	0	0.6325872587680644	0	-1
29	30	31	Sajha_R1_Gongabu_Lagankhel	2.6816870441983682	0	0.8938956813994562	0	-1
30	31	32	Sajha_R1_Gongabu_Lagankhel	1.9329923165959015	0	0.6443307721986338	0	-1
31	32	33	Sajha_R1_Gongabu_Lagankhel	2.8113237326327942	0	0.9371079108775981	0	-1
32	33	34	Sajha_R1_Gongabu_Lagankhel	2.1091627025321253	0	0.7030542341773751	0	-1
33	34	35	Sajha_R1_Gongabu_Lagankhel	1.207244747740107	0	0.40241491591336903	0	-1
34	35	36	Sajha_R1_Gongabu_Lagankhel	2.1485344139653257	0	0.7161781379884419	0	-1
35	36	37	Sajha_R1_Gongabu_Lagankhel	1.8541164585969423	0	0.6180388195323141	0	-1
36	37	38	Sajha_R1_Gongabu_Lagankhel	2.4191092093965567	0	0.806369736465519	0	-1
37	38	39	Sajha_R1_Gongabu_Lagankhel	1.6030493302447857	0	0.5343497767482619	0	-1
38	39	40	Sajha_R1_Gongabu_Lagankhel	1.3185723702654397	0	0.43952412342181324	0	-1
39	40	41	Sajha_R1_Gongabu_Lagankhel	2.013963059285668	0	0.6713210197618893	0	-1
40	41	42	Sajha_R1_Gongabu_Lagankhel	1.401638361168241	0	0.4672127870560804	0	-1
41	43	44	Sajha_R2_Lagankhel_Budhanilkantha	1.401638361168241	0	0.4672127870560804	0	-1
42	44	45	Sajha_R2_Lagankhel_Budhanilkantha	2.013963059285668	0	0.6713210197618893	0	-1
43	45	46	Sajha_R2_Lagankhel_Budhanilkantha	1.3185723702654397	0	0.43952412342181324	0	-1
44	46	47	Sajha_R2_Lagankhel_Budhanilkantha	1.6030493302447857	0	0.5343497767482619	0	-1
45	47	48	Sajha_R2_Lagankhel_Budhanilkantha	2.4191092093965567	0	0.806369736465519	0	-1
46	48	49	Sajha_R2_Lagankhel_Budhanilkantha	1.8541164585969423	0	0.6180388195323141	0	-1
47	49	50	Sajha_R2_Lagankhel_Budhanilkantha	2.6369476097657105	0	0.8789825365885702	0	-1
48	50	51	Sajha_R2_Lagankhel_Budhanilkantha	5.426721390448877	0	1.8089071301496258	0	-1
49	51	52	Sajha_R2_Lagankhel_Budhanilkantha	1.9329923165959015	0	0.6443307721986338	0	-1
50	52	53	Sajha_R2_Lagankhel_Budhanilkantha	2.6816870441983682	0	0.8938956813994562	0	-1
51	53	54	Sajha_R2_Lagankhel_Budhanilkantha	1.8977617763041934	0	0.6325872587680644	0	-1
52	54	55	Sajha_R2_Lagankhel_Budhanilkantha	0.9684214932415179	0	0.3228071644138393	0	-1
53	55	56	Sajha_R2_Lagankhel_Budhanilkantha	1.7202528367352408	0	0.5734176122450803	0	-1
54	56	57	Sajha_R2_Lagankhel_Budhanilkantha	0.64592466254204	0	0.21530822084734666	0	-1
55	57	58	Sajha_R2_Lagankhel_Budhanilkantha	1.3500412496670846	0	0.45001374988902815	0	-1
56	58	59	Sajha_R2_Lagankhel_Budhanilkantha	0.9015002232940228	0	0.3005000744313409	0	-1
57	59	60	Sajha_R2_Lagankhel_Budhanilkantha	1.4697352026210422	0	0.48991173420701406	0	-1
58	60	61	Sajha_R2_Lagankhel_Budhanilkantha	1.022469362810793	0	0.34082312093693096	0	-1
59	61	62	Sajha_R2_Lagankhel_Budhanilkantha	2.1262567765928098	0	0.7087522588642698	0	-1
60	62	63	Sajha_R2_Lagankhel_Budhanilkantha	1.475785966530148	0	0.49192865551004933	0	-1
61	63	64	Sajha_R2_Lagankhel_Budhanilkantha	2.214532488272049	0	0.7381774960906831	0	-1
62	64	65	Sajha_R2_Lagankhel_Budhanilkantha	1.9026135959294785	0	0.6342045319764928	0	-1
63	65	66	Sajha_R2_Lagankhel_Budhanilkantha	1.3323152689673186	0	0.44410508965577283	0	-1
64	66	67	Sajha_R2_Lagankhel_Budhanilkantha	1.2323189634165626	0	0.41077298780552085	0	-1
65	68	69	Sajha_R2_Budhanilkantha_Lagnakhel	1.2323189634165626	0	0.41077298780552085	0	-1
66	69	70	Sajha_R2_Budhanilkantha_Lagnakhel	1.3323152689673186	0	0.44410508965577283	0	-1
67	70	71	Sajha_R2_Budhanilkantha_Lagnakhel	1.9026135959294785	0	0.6342045319764928	0	-1
68	71	72	Sajha_R2_Budhanilkantha_Lagnakhel	2.214532488272049	0	0.7381774960906831	0	-1
69	72	73	Sajha_R2_Budhanilkantha_Lagnakhel	1.475785966530148	0	0.49192865551004933	0	-1
70	73	74	Sajha_R2_Budhanilkantha_Lagnakhel	2.1262567765928098	0	0.7087522588642698	0	-1
71	74	75	Sajha_R2_Budhanilkantha_Lagnakhel	1.022469362810793	0	0.34082312093693096	0	-1
72	75	76	Sajha_R2_Budhanilkantha_Lagnakhel	1.4697352026210422	0	0.48991173420701406	0	-1
73	76	77	Sajha_R2_Budhanilkantha_Lagnakhel	0.9015002232940228	0	0.3005000744313409	0	-1
74	77	78	Sajha_R2_Budhanilkantha_Lagnakhel	1.3500412496670846	0	0.45001374988902815	0	-1
75	78	79	Sajha_R2_Budhanilkantha_Lagnakhel	0.64592466254204	0	0.21530822084734666	0	-1
76	79	80	Sajha_R2_Budhanilkantha_Lagnakhel	1.7202528367352408	0	0.5734176122450803	0	-1
77	80	81	Sajha_R2_Budhanilkantha_Lagnakhel	0.9684214932415179	0	0.3228071644138393	0	-1
78	81	82	Sajha_R2_Budhanilkantha_Lagnakhel	1.8977617763041934	0	0.6325872587680644	0	-1
79	82	83	Sajha_R2_Budhanilkantha_Lagnakhel	2.6816870441983682	0	0.8938956813994562	0	-1
80	83	84	Sajha_R2_Budhanilkantha_Lagnakhel	1.9329923165959015	0	0.6443307721986338	0	-1
81	84	85	Sajha_R2_Budhanilkantha_Lagnakhel	2.8113237326327942	0	0.9371079108775981	0	-1
82	85	86	Sajha_R2_Budhanilkantha_Lagnakhel	2.1091627025321253	0	0.7030542341773751	0	-1
83	86	87	Sajha_R2_Budhanilkantha_Lagnakhel	1.207244747740107	0	0.40241491591336903	0	-1
84	87	88	Sajha_R2_Budhanilkantha_Lagnakhel	2.1485344139653257	0	0.7161781379884419	0	-1
85	88	89	Sajha_R2_Budhanilkantha_Lagnakhel	1.8541164585969423	0	0.6180388195323141	0	-1
86	89	90	Sajha_R2_Budhanilkantha_Lagnakhel	2.4191092093965567	0	0.806369736465519	0	-1
87	90	91	Sajha_R2_Budhanilkantha_Lagnakhel	1.6030493302447857	0	0.5343497767482619	0	-1
88	91	92	Sajha_R2_Budhanilkantha_Lagnakhel	1.3185723702654397	0	0.43952412342181324	0	-1
89	92	93	Sajha_R2_Budhanilkantha_Lagnakhel	2.013963059285668	0	0.6713210197618893	0	-1
90	93	94	Sajha_R2_Budhanilkantha_Lagnakhel	1.401638361168241	0	0.4672127870560804	0	-1
91	95	96	Sajha_R3_Godawari_RNAC	8.1997805589229	0	2.7332601863076333	0	-1
92	96	97	Sajha_R3_Godawari_RNAC	4.678006160132719	0	1.5593353867109063	0	-1
93	97	98	Sajha_R3_Godawari_RNAC	5.179920917420437	0	1.7266403058068123	0	-1
94	98	99	Sajha_R3_Godawari_RNAC	3.9496667242134813	0	1.3165555747378272	0	-1
95	99	100	Sajha_R3_Godawari_RNAC	4.067746535746951	0	1.3559155119156505	0	-1
96	100	101	Sajha_R3_Godawari_RNAC	0.8317462324909549	0	0.27724874416365164	0	-1
97	101	102	Sajha_R3_Godawari_RNAC	2.7582735123140454	0	0.9194245041046818	0	-1
98	102	103	Sajha_R3_Godawari_RNAC	1.401638361168241	0	0.4672127870560804	0	-1
99	103	104	Sajha_R3_Godawari_RNAC	2.013963059285668	0	0.6713210197618893	0	-1
100	104	105	Sajha_R3_Godawari_RNAC	1.3185723702654397	0	0.43952412342181324	0	-1
101	105	106	Sajha_R3_Godawari_RNAC	1.6030493302447857	0	0.5343497767482619	0	-1
102	106	107	Sajha_R3_Godawari_RNAC	2.4191092093965567	0	0.806369736465519	0	-1
103	107	108	Sajha_R3_Godawari_RNAC	1.8541164585969423	0	0.6180388195323141	0	-1
104	108	109	Sajha_R3_Godawari_RNAC	2.6369476097657105	0	0.8789825365885702	0	-1
105	110	111	Sajha_R3_RNAC_Godawari	2.6284744690278123	0	0.8761581563426041	0	-1
106	111	112	Sajha_R3_RNAC_Godawari	2.1091627025321253	0	0.7030542341773751	0	-1
107	112	113	Sajha_R3_RNAC_Godawari	1.207244747740107	0	0.40241491591336903	0	-1
108	113	114	Sajha_R3_RNAC_Godawari	2.1485344139653257	0	0.7161781379884419	0	-1
109	114	115	Sajha_R3_RNAC_Godawari	1.8541164585969423	0	0.6180388195323141	0	-1
110	115	116	Sajha_R3_RNAC_Godawari	2.4191092093965567	0	0.806369736465519	0	-1
111	116	117	Sajha_R3_RNAC_Godawari	1.6030493302447857	0	0.5343497767482619	0	-1
112	117	118	Sajha_R3_RNAC_Godawari	1.3185723702654397	0	0.43952412342181324	0	-1
113	118	119	Sajha_R3_RNAC_Godawari	2.013963059285668	0	0.6713210197618893	0	-1
114	119	120	Sajha_R3_RNAC_Godawari	1.401638361168241	0	0.4672127870560804	0	-1
115	120	121	Sajha_R3_RNAC_Godawari	2.7582735123140454	0	0.9194245041046818	0	-1
116	121	122	Sajha_R3_RNAC_Godawari	0.8317462324909549	0	0.27724874416365164	0	-1
117	122	123	Sajha_R3_RNAC_Godawari	4.067746535746951	0	1.3559155119156505	0	-1
118	123	124	Sajha_R3_RNAC_Godawari	3.9496667242134813	0	1.3165555747378272	0	-1
119	124	125	Sajha_R3_RNAC_Godawari	5.179920917420437	0	1.7266403058068123	0	-1
120	125	126	Sajha_R3_RNAC_Godawari	4.678006160132719	0	1.5593353867109063	0	-1
121	126	127	Sajha_R3_RNAC_Godawari	8.1997805589229	0	2.7332601863076333	0	-1
122	128	129	Sajha_R4_Lamatar_RNAC	2.0995063660150253	0	0.6998354553383418	0	-1
123	129	130	Sajha_R4_Lamatar_RNAC	4.52625966998528	0	1.5087532233284269	0	-1
124	130	131	Sajha_R4_Lamatar_RNAC	1.7657454655958975	0	0.5885818218652992	0	-1
125	131	132	Sajha_R4_Lamatar_RNAC	0.44023473440199035	0	0.14674491146733012	0	-1
126	132	133	Sajha_R4_Lamatar_RNAC	2.045768509862905	0	0.6819228366209683	0	-1
127	133	134	Sajha_R4_Lamatar_RNAC	2.4009487522053683	0	0.8003162507351227	0	-1
128	134	135	Sajha_R4_Lamatar_RNAC	1.0422398992850048	0	0.3474132997616683	0	-1
129	135	136	Sajha_R4_Lamatar_RNAC	1.2437359288140855	0	0.4145786429380285	0	-1
130	136	137	Sajha_R4_Lamatar_RNAC	0.9711549248741903	0	0.3237183082913968	0	-1
131	137	138	Sajha_R4_Lamatar_RNAC	0.6271019376065164	0	0.20903397920217215	0	-1
132	138	139	Sajha_R4_Lamatar_RNAC	0.3850802155887433	0	0.12836007186291443	0	-1
133	139	140	Sajha_R4_Lamatar_RNAC	1.2092274652511998	0	0.40307582175039997	0	-1
134	140	141	Sajha_R4_Lamatar_RNAC	0.9218860342688245	0	0.30729534475627485	0	-1
135	141	142	Sajha_R4_Lamatar_RNAC	0.7234464230500146	0	0.2411488076833382	0	-1
136	142	143	Sajha_R4_Lamatar_RNAC	0.29471057882795904	0	0.09823685960931969	0	-1
137	143	144	Sajha_R4_Lamatar_RNAC	1.5341022541468088	0	0.5113674180489363	0	-1
138	144	145	Sajha_R4_Lamatar_RNAC	0.9680474575881455	0	0.3226824858627152	0	-1
139	145	146	Sajha_R4_Lamatar_RNAC	1.6353340552405873	0	0.5451113517468624	0	-1
140	146	147	Sajha_R4_Lamatar_RNAC	1.7505180966685887	0	0.5835060322228629	0	-1
141	147	148	Sajha_R4_Lamatar_RNAC	2.7582735123140454	0	0.9194245041046818	0	-1
142	148	149	Sajha_R4_Lamatar_RNAC	1.401638361168241	0	0.4672127870560804	0	-1
143	149	150	Sajha_R4_Lamatar_RNAC	2.013963059285668	0	0.6713210197618893	0	-1
144	150	151	Sajha_R4_Lamatar_RNAC	1.3185723702654397	0	0.43952412342181324	0	-1
145	151	152	Sajha_R4_Lamatar_RNAC	1.6030493302447857	0	0.5343497767482619	0	-1
146	152	153	Sajha_R4_Lamatar_RNAC	2.4191092093965567	0	0.806369736465519	0	-1
147	153	154	Sajha_R4_Lamatar_RNAC	1.8541164585969423	0	0.6180388195323141	0	-1
148	154	155	Sajha_R4_Lamatar_RNAC	2.6369476097657105	0	0.8789825365885702	0	-1
149	156	157	Sajha_R4_RNAC_Lamatar	2.6284744690278123	0	0.8761581563426041	0	-1
150	157	158	Sajha_R4_RNAC_Lamatar	2.1091627025321253	0	0.7030542341773751	0	-1
151	158	159	Sajha_R4_RNAC_Lamatar	1.207244747740107	0	0.40241491591336903	0	-1
152	159	160	Sajha_R4_RNAC_Lamatar	2.1485344139653257	0	0.7161781379884419	0	-1
153	160	161	Sajha_R4_RNAC_Lamatar	1.8541164585969423	0	0.6180388195323141	0	-1
154	161	162	Sajha_R4_RNAC_Lamatar	2.4191092093965567	0	0.806369736465519	0	-1
155	162	163	Sajha_R4_RNAC_Lamatar	1.6030493302447857	0	0.5343497767482619	0	-1
156	163	164	Sajha_R4_RNAC_Lamatar	1.3185723702654397	0	0.43952412342181324	0	-1
157	164	165	Sajha_R4_RNAC_Lamatar	2.013963059285668	0	0.6713210197618893	0	-1
158	165	166	Sajha_R4_RNAC_Lamatar	1.401638361168241	0	0.4672127870560804	0	-1
159	166	167	Sajha_R4_RNAC_Lamatar	2.7582735123140454	0	0.9194245041046818	0	-1
160	167	168	Sajha_R4_RNAC_Lamatar	0.8448365559009172	0	0.28161218530030574	0	-1
161	168	169	Sajha_R4_RNAC_Lamatar	1.6657614017466142	0	0.5552538005822047	0	-1
162	169	170	Sajha_R4_RNAC_Lamatar	0.8814549142962684	0	0.2938183047654228	0	-1
163	170	171	Sajha_R4_RNAC_Lamatar	0.9680474575881455	0	0.3226824858627152	0	-1
164	171	172	Sajha_R4_RNAC_Lamatar	1.5341022541468088	0	0.5113674180489363	0	-1
165	172	173	Sajha_R4_RNAC_Lamatar	0.29471057882795904	0	0.09823685960931969	0	-1
166	173	174	Sajha_R4_RNAC_Lamatar	0.7234464230500146	0	0.2411488076833382	0	-1
167	174	175	Sajha_R4_RNAC_Lamatar	0.9218860342688245	0	0.30729534475627485	0	-1
168	175	176	Sajha_R4_RNAC_Lamatar	1.2092274652511998	0	0.40307582175039997	0	-1
169	176	177	Sajha_R4_RNAC_Lamatar	0.3850802155887433	0	0.12836007186291443	0	-1
170	177	178	Sajha_R4_RNAC_Lamatar	0.6271019376065164	0	0.20903397920217215	0	-1
171	178	179	Sajha_R4_RNAC_Lamatar	0.9711549248741903	0	0.3237183082913968	0	-1
172	179	180	Sajha_R4_RNAC_Lamatar	1.2437359288140855	0	0.4145786429380285	0	-1
173	180	181	Sajha_R4_RNAC_Lamatar	1.0422398992850048	0	0.3474132997616683	0	-1
174	181	182	Sajha_R4_RNAC_Lamatar	2.4009487522053683	0	0.8003162507351227	0	-1
175	182	183	Sajha_R4_RNAC_Lamatar	2.045768509862905	0	0.6819228366209683	0	-1
176	183	184	Sajha_R4_RNAC_Lamatar	0.44023473440199035	0	0.14674491146733012	0	-1
177	184	185	Sajha_R4_RNAC_Lamatar	1.7657454655958975	0	0.5885818218652992	0	-1
178	185	186	Sajha_R4_RNAC_Lamatar	4.52625966998528	0	1.5087532233284269	0	-1
179	186	187	Sajha_R4_RNAC_Lamatar	2.0995063660150253	0	0.6998354553383418	0	-1
180	188	189	Sajha_R5_Thankot_Airport	3.655283891416824	0	1.2184279638056081	0	-1
181	189	190	Sajha_R5_Thankot_Airport	1.2981404039633448	0	0.43271346798778165	0	-1
182	190	191	Sajha_R5_Thankot_Airport	1.6143965728487524	0	0.5381321909495841	0	-1
183	191	192	Sajha_R5_Thankot_Airport	4.416024748384868	0	1.4720082494616227	0	-1
184	192	193	Sajha_R5_Thankot_Airport	2.7172883313046965	0	0.9057627771015656	0	-1
185	193	194	Sajha_R5_Thankot_Airport	2.5948932757639747	0	0.8649644252546581	0	-1
186	194	195	Sajha_R5_Thankot_Airport	1.4608702583475068	0	0.4869567527825023	0	-1
187	195	196	Sajha_R5_Thankot_Airport	1.5374189555920206	0	0.5124729851973402	0	-1
188	196	197	Sajha_R5_Thankot_Airport	2.0042032411672683	0	0.6680677470557561	0	-1
189	197	198	Sajha_R5_Thankot_Airport	1.9797635320407356	0	0.6599211773469118	0	-1
190	198	199	Sajha_R5_Thankot_Airport	0.9707403453781139	0	0.323580115126038	0	-1
191	199	200	Sajha_R5_Thankot_Airport	1.8219036746628254	0	0.6073012248876085	0	-1
192	200	201	Sajha_R5_Thankot_Airport	1.0549719075765507	0	0.35165730252551686	0	-1
193	201	202	Sajha_R5_Thankot_Airport	1.6438071274801913	0	0.5479357091600637	0	-1
194	202	203	Sajha_R5_Thankot_Airport	1.0796869676716054	0	0.3598956558905351	0	-1
195	203	204	Sajha_R5_Thankot_Airport	3.6585681746022263	0	1.2195227248674088	0	-1
196	204	205	Sajha_R5_Thankot_Airport	2.6369476097657105	0	0.8789825365885702	0	-1
197	205	206	Sajha_R5_Thankot_Airport	1.8970059458867343	0	0.6323353152955781	0	-1
198	206	207	Sajha_R5_Thankot_Airport	1.452119100004997	0	0.48403970000166574	0	-1
199	207	208	Sajha_R5_Thankot_Airport	2.1125904390702797	0	0.7041968130234266	0	-1
200	208	209	Sajha_R5_Thankot_Airport	0.5141356220617795	0	0.17137854068725983	0	-1
201	209	210	Sajha_R5_Thankot_Airport	0.9644961016231957	0	0.3214987005410652	0	-1
202	210	211	Sajha_R5_Thankot_Airport	0.9620549520263462	0	0.32068498400878204	0	-1
203	211	212	Sajha_R5_Thankot_Airport	1.1519156005967761	0	0.38397186686559204	0	-1
204	212	213	Sajha_R5_Thankot_Airport	2.1951709515871007	0	0.7317236505290335	0	-1
205	213	214	Sajha_R5_Thankot_Airport	1.1581870501084677	0	0.3860623500361559	0	-1
206	214	215	Sajha_R5_Thankot_Airport	1.2142052580277205	0	0.4047350860092402	0	-1
207	215	216	Sajha_R5_Thankot_Airport	0.8685123125445595	0	0.28950410418151984	0	-1
208	216	217	Sajha_R5_Thankot_Airport	1.1028175377421576	0	0.3676058459140526	0	-1
209	217	218	Sajha_R5_Thankot_Airport	1.9704465316766524	0	0.6568155105588841	0	-1
210	218	219	Sajha_R5_Thankot_Airport	1.4410413829084208	0	0.4803471276361403	0	-1
211	219	220	Sajha_R5_Thankot_Airport	1.8233813635545788	0	0.6077937878515263	0	-1
212	221	222	Sajha_R5_Airport_Thankot	1.8233813635545788	0	0.6077937878515263	0	-1
213	222	223	Sajha_R5_Airport_Thankot	1.4410413829084208	0	0.4803471276361403	0	-1
214	223	224	Sajha_R5_Airport_Thankot	1.9704465316766524	0	0.6568155105588841	0	-1
215	224	225	Sajha_R5_Airport_Thankot	1.1028175377421576	0	0.3676058459140526	0	-1
216	225	226	Sajha_R5_Airport_Thankot	0.8685123125445595	0	0.28950410418151984	0	-1
217	226	227	Sajha_R5_Airport_Thankot	1.3996637665372451	0	0.46655458884574835	0	-1
218	227	228	Sajha_R5_Airport_Thankot	0.9707884579254817	0	0.3235961526418273	0	-1
219	228	229	Sajha_R5_Airport_Thankot	1.1746375725862386	0	0.3915458575287462	0	-1
220	229	230	Sajha_R5_Airport_Thankot	1.096632297132387	0	0.365544099044129	0	-1
221	230	231	Sajha_R5_Airport_Thankot	1.1828635221093418	0	0.3942878407031139	0	-1
222	231	232	Sajha_R5_Airport_Thankot	1.10092119351441	0	0.36697373117147003	0	-1
223	232	233	Sajha_R5_Airport_Thankot	2.0658891096285643	0	0.6886297032095214	0	-1
224	233	234	Sajha_R5_Airport_Thankot	0.9514595405290251	0	0.3171531801763417	0	-1
225	234	235	Sajha_R5_Airport_Thankot	2.1485344139653257	0	0.7161781379884419	0	-1
226	235	236	Sajha_R5_Airport_Thankot	2.5916809701827064	0	0.8638936567275688	0	-1
227	236	237	Sajha_R5_Airport_Thankot	1.54890296816104	0	0.5163009893870133	0	-1
228	237	238	Sajha_R5_Airport_Thankot	2.1853155707872576	0	0.7284385235957526	0	-1
229	238	239	Sajha_R5_Airport_Thankot	1.0549719075765507	0	0.35165730252551686	0	-1
230	239	240	Sajha_R5_Airport_Thankot	1.8219036746628254	0	0.6073012248876085	0	-1
231	240	241	Sajha_R5_Airport_Thankot	0.9707403453781139	0	0.323580115126038	0	-1
232	241	242	Sajha_R5_Airport_Thankot	1.9797635320407356	0	0.6599211773469118	0	-1
233	242	243	Sajha_R5_Airport_Thankot	2.0042032411672683	0	0.6680677470557561	0	-1
234	243	244	Sajha_R5_Airport_Thankot	1.5374189555920206	0	0.5124729851973402	0	-1
235	244	245	Sajha_R5_Airport_Thankot	1.4608702583475068	0	0.4869567527825023	0	-1
236	245	246	Sajha_R5_Airport_Thankot	2.5948932757639747	0	0.8649644252546581	0	-1
237	246	247	Sajha_R5_Airport_Thankot	2.7172883313046965	0	0.9057627771015656	0	-1
238	247	248	Sajha_R5_Airport_Thankot	4.416024748384868	0	1.4720082494616227	0	-1
239	248	249	Sajha_R5_Airport_Thankot	1.6143965728487524	0	0.5381321909495841	0	-1
240	249	250	Sajha_R5_Airport_Thankot	1.2981404039633448	0	0.43271346798778165	0	-1
241	250	251	Sajha_R5_Airport_Thankot	3.655283891416824	0	1.2184279638056081	0	-1
242	252	253	Sajha_R6_Thankot_Budhanilkantha	2.543024208906929	0	0.8476747363023097	0	-1
243	253	254	Sajha_R6_Thankot_Budhanilkantha	3.655283891416824	0	1.2184279638056081	0	-1
244	254	255	Sajha_R6_Thankot_Budhanilkantha	1.2981404039633448	0	0.43271346798778165	0	-1
245	255	256	Sajha_R6_Thankot_Budhanilkantha	1.6143965728487524	0	0.5381321909495841	0	-1
246	256	257	Sajha_R6_Thankot_Budhanilkantha	4.416024748384868	0	1.4720082494616227	0	-1
247	257	258	Sajha_R6_Thankot_Budhanilkantha	2.7172883313046965	0	0.9057627771015656	0	-1
248	258	259	Sajha_R6_Thankot_Budhanilkantha	2.5948932757639747	0	0.8649644252546581	0	-1
249	259	260	Sajha_R6_Thankot_Budhanilkantha	1.4608702583475068	0	0.4869567527825023	0	-1
250	260	261	Sajha_R6_Thankot_Budhanilkantha	1.5374189555920206	0	0.5124729851973402	0	-1
251	261	262	Sajha_R6_Thankot_Budhanilkantha	2.0042032411672683	0	0.6680677470557561	0	-1
252	262	263	Sajha_R6_Thankot_Budhanilkantha	2.1678903130324207	0	0.7226301043441402	0	-1
253	263	264	Sajha_R6_Thankot_Budhanilkantha	2.242296442868612	0	0.7474321476228707	0	-1
254	264	265	Sajha_R6_Thankot_Budhanilkantha	1.8459989820447158	0	0.6153329940149053	0	-1
255	265	266	Sajha_R6_Thankot_Budhanilkantha	2.825848771415228	0	0.9419495904717425	0	-1
256	266	267	Sajha_R6_Thankot_Budhanilkantha	1.583318410570072	0	0.5277728035233573	0	-1
257	267	268	Sajha_R6_Thankot_Budhanilkantha	1.1721191958984787	0	0.39070639863282625	0	-1
258	268	269	Sajha_R6_Thankot_Budhanilkantha	1.4072191829845333	0	0.4690730609948444	0	-1
259	269	270	Sajha_R6_Thankot_Budhanilkantha	1.0288518975776622	0	0.34295063252588737	0	-1
260	270	271	Sajha_R6_Thankot_Budhanilkantha	2.257232355188933	0	0.7524107850629776	0	-1
261	271	272	Sajha_R6_Thankot_Budhanilkantha	2.678265952251483	0	0.8927553174171611	0	-1
262	272	273	Sajha_R6_Thankot_Budhanilkantha	2.632789063006577	0	0.8775963543355257	0	-1
263	273	274	Sajha_R6_Thankot_Budhanilkantha	1.9521431823395705	0	0.6507143941131901	0	-1
264	274	275	Sajha_R6_Thankot_Budhanilkantha	1.4999174232372166	0	0.4999724744124055	0	-1
265	275	276	Sajha_R6_Thankot_Budhanilkantha	2.7957488391181737	0	0.9319162797060578	0	-1
266	276	277	Sajha_R6_Thankot_Budhanilkantha	1.0883210921535043	0	0.36277369738450144	0	-1
267	277	278	Sajha_R6_Thankot_Budhanilkantha	1.3500412496670846	0	0.45001374988902815	0	-1
268	278	279	Sajha_R6_Thankot_Budhanilkantha	0.9015002232940228	0	0.3005000744313409	0	-1
269	279	280	Sajha_R6_Thankot_Budhanilkantha	1.4697352026210422	0	0.48991173420701406	0	-1
270	280	281	Sajha_R6_Thankot_Budhanilkantha	1.022469362810793	0	0.34082312093693096	0	-1
271	281	282	Sajha_R6_Thankot_Budhanilkantha	2.1262567765928098	0	0.7087522588642698	0	-1
272	282	283	Sajha_R6_Thankot_Budhanilkantha	1.475785966530148	0	0.49192865551004933	0	-1
273	283	284	Sajha_R6_Thankot_Budhanilkantha	2.214532488272049	0	0.7381774960906831	0	-1
274	284	285	Sajha_R6_Thankot_Budhanilkantha	1.9026135959294785	0	0.6342045319764928	0	-1
275	285	286	Sajha_R6_Thankot_Budhanilkantha	1.3323152689673186	0	0.44410508965577283	0	-1
276	286	287	Sajha_R6_Thankot_Budhanilkantha	1.2323189634165626	0	0.41077298780552085	0	-1
277	288	289	Sajha_R6_Budhanilkantha_Thankot	1.2323189634165626	0	0.41077298780552085	0	-1
278	289	290	Sajha_R6_Budhanilkantha_Thankot	1.3323152689673186	0	0.44410508965577283	0	-1
279	290	291	Sajha_R6_Budhanilkantha_Thankot	1.9026135959294785	0	0.6342045319764928	0	-1
280	291	292	Sajha_R6_Budhanilkantha_Thankot	2.214532488272049	0	0.7381774960906831	0	-1
281	292	293	Sajha_R6_Budhanilkantha_Thankot	1.475785966530148	0	0.49192865551004933	0	-1
282	293	294	Sajha_R6_Budhanilkantha_Thankot	2.1262567765928098	0	0.7087522588642698	0	-1
283	294	295	Sajha_R6_Budhanilkantha_Thankot	1.022469362810793	0	0.34082312093693096	0	-1
284	295	296	Sajha_R6_Budhanilkantha_Thankot	1.4697352026210422	0	0.48991173420701406	0	-1
285	296	297	Sajha_R6_Budhanilkantha_Thankot	0.9015002232940228	0	0.3005000744313409	0	-1
286	297	298	Sajha_R6_Budhanilkantha_Thankot	1.3500412496670846	0	0.45001374988902815	0	-1
287	298	299	Sajha_R6_Budhanilkantha_Thankot	1.0883210921535043	0	0.36277369738450144	0	-1
288	299	300	Sajha_R6_Budhanilkantha_Thankot	2.7957488391181737	0	0.9319162797060578	0	-1
289	300	301	Sajha_R6_Budhanilkantha_Thankot	1.4999174232372166	0	0.4999724744124055	0	-1
290	301	302	Sajha_R6_Budhanilkantha_Thankot	1.9521431823395705	0	0.6507143941131901	0	-1
291	302	303	Sajha_R6_Budhanilkantha_Thankot	2.632789063006577	0	0.8775963543355257	0	-1
292	303	304	Sajha_R6_Budhanilkantha_Thankot	2.678265952251483	0	0.8927553174171611	0	-1
293	304	305	Sajha_R6_Budhanilkantha_Thankot	2.257232355188933	0	0.7524107850629776	0	-1
294	305	306	Sajha_R6_Budhanilkantha_Thankot	1.0288518975776622	0	0.34295063252588737	0	-1
295	306	307	Sajha_R6_Budhanilkantha_Thankot	1.4072191829845333	0	0.4690730609948444	0	-1
296	307	308	Sajha_R6_Budhanilkantha_Thankot	1.1721191958984787	0	0.39070639863282625	0	-1
297	308	309	Sajha_R6_Budhanilkantha_Thankot	1.583318410570072	0	0.5277728035233573	0	-1
298	309	310	Sajha_R6_Budhanilkantha_Thankot	2.825848771415228	0	0.9419495904717425	0	-1
299	310	311	Sajha_R6_Budhanilkantha_Thankot	1.8459989820447158	0	0.6153329940149053	0	-1
300	311	312	Sajha_R6_Budhanilkantha_Thankot	2.242296442868612	0	0.7474321476228707	0	-1
301	312	313	Sajha_R6_Budhanilkantha_Thankot	2.1678903130324207	0	0.7226301043441402	0	-1
302	313	314	Sajha_R6_Budhanilkantha_Thankot	2.0042032411672683	0	0.6680677470557561	0	-1
303	314	315	Sajha_R6_Budhanilkantha_Thankot	1.5374189555920206	0	0.5124729851973402	0	-1
304	315	316	Sajha_R6_Budhanilkantha_Thankot	1.4608702583475068	0	0.4869567527825023	0	-1
305	316	317	Sajha_R6_Budhanilkantha_Thankot	2.5948932757639747	0	0.8649644252546581	0	-1
306	317	318	Sajha_R6_Budhanilkantha_Thankot	2.7172883313046965	0	0.9057627771015656	0	-1
307	318	319	Sajha_R6_Budhanilkantha_Thankot	4.416024748384868	0	1.4720082494616227	0	-1
308	319	320	Sajha_R6_Budhanilkantha_Thankot	1.6143965728487524	0	0.5381321909495841	0	-1
309	320	321	Sajha_R6_Budhanilkantha_Thankot	1.2981404039633448	0	0.43271346798778165	0	-1
310	321	322	Sajha_R6_Budhanilkantha_Thankot	3.655283891416824	0	1.2184279638056081	0	-1
311	322	323	Sajha_R6_Budhanilkantha_Thankot	2.543024208906929	0	0.8476747363023097	0	-1
312	324	325	Sajha_R7_Lele_Jamal	2.1327220765780344	0	0.7109073588593449	0	-1
313	325	326	Sajha_R7_Lele_Jamal	6.460975012901891	0	2.1536583376339635	0	-1
314	326	327	Sajha_R7_Lele_Jamal	4.777374127934997	0	1.5924580426449988	0	-1
315	327	328	Sajha_R7_Lele_Jamal	3.139583394998445	0	1.046527798332815	0	-1
316	328	329	Sajha_R7_Lele_Jamal	2.1488737298676965	0	0.7162912432892322	0	-1
317	329	330	Sajha_R7_Lele_Jamal	4.17393780002219	0	1.3913126000073968	0	-1
318	330	331	Sajha_R7_Lele_Jamal	2.6021644077832504	0	0.8673881359277501	0	-1
319	331	332	Sajha_R7_Lele_Jamal	3.211938181914996	0	1.070646060638332	0	-1
320	332	333	Sajha_R7_Lele_Jamal	2.4083468305353426	0	0.8027822768451142	0	-1
321	333	334	Sajha_R7_Lele_Jamal	3.105529641094429	0	1.0351765470314762	0	-1
322	334	335	Sajha_R7_Lele_Jamal	2.8335954984112486	0	0.9445318328037495	0	-1
323	335	336	Sajha_R7_Lele_Jamal	0.7642322391129687	0	0.2547440797043229	0	-1
324	336	337	Sajha_R7_Lele_Jamal	2.7582735123140454	0	0.9194245041046818	0	-1
325	337	338	Sajha_R7_Lele_Jamal	1.401638361168241	0	0.4672127870560804	0	-1
326	338	339	Sajha_R7_Lele_Jamal	2.013963059285668	0	0.6713210197618893	0	-1
327	339	340	Sajha_R7_Lele_Jamal	1.3185723702654397	0	0.43952412342181324	0	-1
328	340	341	Sajha_R7_Lele_Jamal	1.6030493302447857	0	0.5343497767482619	0	-1
329	341	342	Sajha_R7_Lele_Jamal	2.4191092093965567	0	0.806369736465519	0	-1
330	342	343	Sajha_R7_Lele_Jamal	1.8541164585969423	0	0.6180388195323141	0	-1
331	343	344	Sajha_R7_Lele_Jamal	2.6369476097657105	0	0.8789825365885702	0	-1
332	344	345	Sajha_R7_Lele_Jamal	2.6284744690278123	0	0.8761581563426041	0	-1
333	346	347	Sajha_R7_Jamal_Lele	2.1091627025321253	0	0.7030542341773751	0	-1
334	347	348	Sajha_R7_Jamal_Lele	1.207244747740107	0	0.40241491591336903	0	-1
335	348	349	Sajha_R7_Jamal_Lele	2.1485344139653257	0	0.7161781379884419	0	-1
336	349	350	Sajha_R7_Jamal_Lele	1.8541164585969423	0	0.6180388195323141	0	-1
337	350	351	Sajha_R7_Jamal_Lele	2.4191092093965567	0	0.806369736465519	0	-1
338	351	352	Sajha_R7_Jamal_Lele	1.6030493302447857	0	0.5343497767482619	0	-1
339	352	353	Sajha_R7_Jamal_Lele	1.3185723702654397	0	0.43952412342181324	0	-1
340	353	354	Sajha_R7_Jamal_Lele	2.013963059285668	0	0.6713210197618893	0	-1
341	354	355	Sajha_R7_Jamal_Lele	1.401638361168241	0	0.4672127870560804	0	-1
342	355	356	Sajha_R7_Jamal_Lele	2.7582735123140454	0	0.9194245041046818	0	-1
343	356	357	Sajha_R7_Jamal_Lele	0.7642322391129687	0	0.2547440797043229	0	-1
344	357	358	Sajha_R7_Jamal_Lele	2.8335954984112486	0	0.9445318328037495	0	-1
345	358	359	Sajha_R7_Jamal_Lele	3.105529641094429	0	1.0351765470314762	0	-1
346	359	360	Sajha_R7_Jamal_Lele	2.4083468305353426	0	0.8027822768451142	0	-1
347	360	361	Sajha_R7_Jamal_Lele	3.211938181914996	0	1.070646060638332	0	-1
348	361	362	Sajha_R7_Jamal_Lele	2.6021644077832504	0	0.8673881359277501	0	-1
349	362	363	Sajha_R7_Jamal_Lele	4.17393780002219	0	1.3913126000073968	0	-1
350	363	364	Sajha_R7_Jamal_Lele	2.1488737298676965	0	0.7162912432892322	0	-1
351	364	365	Sajha_R7_Jamal_Lele	3.139583394998445	0	1.046527798332815	0	-1
352	365	366	Sajha_R7_Jamal_Lele	4.777374127934997	0	1.5924580426449988	0	-1
353	366	367	Sajha_R7_Jamal_Lele	6.460975012901891	0	2.1536583376339635	0	-1
354	367	368	Sajha_R7_Jamal_Lele	2.1327220765780344	0	0.7109073588593449	0	-1
355	369	370	Sajha_R8_Bungamati_Jamal	3.5866600442502774	0	1.1955533480834257	0	-1
356	370	371	Sajha_R8_Bungamati_Jamal	1.0080620950862555	0	0.3360206983620852	0	-1
357	371	372	Sajha_R8_Bungamati_Jamal	1.3228981527687418	0	0.44096605092291397	0	-1
358	372	373	Sajha_R8_Bungamati_Jamal	0.9838323388403762	0	0.32794411294679204	0	-1
359	373	374	Sajha_R8_Bungamati_Jamal	1.0011076278055628	0	0.33370254260185434	0	-1
360	374	375	Sajha_R8_Bungamati_Jamal	1.3718909317865395	0	0.4572969772621798	0	-1
361	375	376	Sajha_R8_Bungamati_Jamal	1.16583952409194	0	0.3886131746973133	0	-1
362	376	377	Sajha_R8_Bungamati_Jamal	0.6670010927085083	0	0.22233369756950275	0	-1
363	377	378	Sajha_R8_Bungamati_Jamal	1.2666178773919514	0	0.42220595913065045	0	-1
364	378	379	Sajha_R8_Bungamati_Jamal	0.6247324666644946	0	0.2082441555548315	0	-1
365	379	380	Sajha_R8_Bungamati_Jamal	0.24470562950440133	0	0.08156854316813378	0	-1
366	380	381	Sajha_R8_Bungamati_Jamal	2.398652845670769	0	0.7995509485569231	0	-1
367	381	382	Sajha_R8_Bungamati_Jamal	1.4003672671971825	0	0.4667890890657275	0	-1
368	382	383	Sajha_R8_Bungamati_Jamal	1.6030493302447857	0	0.5343497767482619	0	-1
369	383	384	Sajha_R8_Bungamati_Jamal	2.4191092093965567	0	0.806369736465519	0	-1
370	384	385	Sajha_R8_Bungamati_Jamal	1.8541164585969423	0	0.6180388195323141	0	-1
371	385	386	Sajha_R8_Bungamati_Jamal	2.6369476097657105	0	0.8789825365885702	0	-1
372	386	387	Sajha_R8_Bungamati_Jamal	2.6284744690278123	0	0.8761581563426041	0	-1
373	388	389	Sajha_R8_Jamal_Bungamati	2.1091627025321253	0	0.7030542341773751	0	-1
374	389	390	Sajha_R8_Jamal_Bungamati	1.207244747740107	0	0.40241491591336903	0	-1
375	390	391	Sajha_R8_Jamal_Bungamati	2.1485344139653257	0	0.7161781379884419	0	-1
376	391	392	Sajha_R8_Jamal_Bungamati	1.8541164585969423	0	0.6180388195323141	0	-1
377	392	393	Sajha_R8_Jamal_Bungamati	2.4191092093965567	0	0.806369736465519	0	-1
378	393	394	Sajha_R8_Jamal_Bungamati	1.6030493302447857	0	0.5343497767482619	0	-1
379	394	395	Sajha_R8_Jamal_Bungamati	1.3185723702654397	0	0.43952412342181324	0	-1
380	395	396	Sajha_R8_Jamal_Bungamati	2.52264960645496	0	0.8408832021516534	0	-1
381	396	397	Sajha_R8_Jamal_Bungamati	0.24470562950440133	0	0.08156854316813378	0	-1
382	397	398	Sajha_R8_Jamal_Bungamati	0.6247324666644946	0	0.2082441555548315	0	-1
383	398	399	Sajha_R8_Jamal_Bungamati	1.2666178773919514	0	0.42220595913065045	0	-1
384	399	400	Sajha_R8_Jamal_Bungamati	0.6670010927085083	0	0.22233369756950275	0	-1
385	400	401	Sajha_R8_Jamal_Bungamati	1.16583952409194	0	0.3886131746973133	0	-1
386	401	402	Sajha_R8_Jamal_Bungamati	1.3718909317865395	0	0.4572969772621798	0	-1
387	402	403	Sajha_R8_Jamal_Bungamati	1.0011076278055628	0	0.33370254260185434	0	-1
388	403	404	Sajha_R8_Jamal_Bungamati	0.9838323388403762	0	0.32794411294679204	0	-1
389	404	405	Sajha_R8_Jamal_Bungamati	1.3228981527687418	0	0.44096605092291397	0	-1
390	405	406	Sajha_R8_Jamal_Bungamati	1.0080620950862555	0	0.3360206983620852	0	-1
391	406	407	Sajha_R8_Jamal_Bungamati	3.5866600442502774	0	1.1955533480834257	0	-1
392	408	409	Jharana_R1_Jamal_Ranibu	2.1091627025321253	0	0.7030542341773751	0	-1
393	409	410	Jharana_R1_Jamal_Ranibu	1.207244747740107	0	0.40241491591336903	0	-1
394	410	411	Jharana_R1_Jamal_Ranibu	2.1485344139653257	0	0.7161781379884419	0	-1
395	411	412	Jharana_R1_Jamal_Ranibu	1.8541164585969423	0	0.6180388195323141	0	-1
396	412	413	Jharana_R1_Jamal_Ranibu	2.4191092093965567	0	0.806369736465519	0	-1
397	413	414	Jharana_R1_Jamal_Ranibu	1.6030493302447857	0	0.5343497767482619	0	-1
398	414	415	Jharana_R1_Jamal_Ranibu	1.3185723702654397	0	0.43952412342181324	0	-1
399	415	416	Jharana_R1_Jamal_Ranibu	2.013963059285668	0	0.6713210197618893	0	-1
400	416	417	Jharana_R1_Jamal_Ranibu	1.401638361168241	0	0.4672127870560804	0	-1
401	417	418	Jharana_R1_Jamal_Ranibu	2.2114311689953032	0	0.7371437229984344	0	-1
402	418	419	Jharana_R1_Jamal_Ranibu	0.23141906681778548	0	0.07713968893926183	0	-1
403	419	420	Jharana_R1_Jamal_Ranibu	0.5642965476758093	0	0.18809884922526976	0	-1
404	420	421	Jharana_R1_Jamal_Ranibu	1.044246668541326	0	0.34808222284710866	0	-1
405	421	422	Jharana_R1_Jamal_Ranibu	0.699235178398794	0	0.233078392799598	0	-1
406	423	424	Jharana_R1_Ranibu_Jamal	0.699235178398794	0	0.233078392799598	0	-1
407	424	425	Jharana_R1_Ranibu_Jamal	1.044246668541326	0	0.34808222284710866	0	-1
408	425	426	Jharana_R1_Ranibu_Jamal	0.5642965476758093	0	0.18809884922526976	0	-1
409	426	427	Jharana_R1_Ranibu_Jamal	0.23141906681778548	0	0.07713968893926183	0	-1
410	427	428	Jharana_R1_Ranibu_Jamal	2.2114311689953032	0	0.7371437229984344	0	-1
411	428	429	Jharana_R1_Ranibu_Jamal	1.401638361168241	0	0.4672127870560804	0	-1
412	429	430	Jharana_R1_Ranibu_Jamal	2.013963059285668	0	0.6713210197618893	0	-1
413	430	431	Jharana_R1_Ranibu_Jamal	1.3185723702654397	0	0.43952412342181324	0	-1
414	431	432	Jharana_R1_Ranibu_Jamal	1.6030493302447857	0	0.5343497767482619	0	-1
415	432	433	Jharana_R1_Ranibu_Jamal	2.4191092093965567	0	0.806369736465519	0	-1
416	433	434	Jharana_R1_Ranibu_Jamal	1.829621175715983	0	0.609873725238661	0	-1
417	434	435	Jharana_R1_Ranibu_Jamal	2.0448012562800977	0	0.6816004187600326	0	-1
418	435	436	Jharana_R1_Ranibu_Jamal	1.2929750264097197	0	0.4309916754699066	0	-1
419	436	437	Jharana_R1_Ranibu_Jamal	2.6284744690278123	0	0.8761581563426041	0	-1
420	438	439	Subhakamana_R1_Swayambhu_Biruwa	2.875589579385653	0	0.9585298597952177	0	-1
421	439	440	Subhakamana_R1_Swayambhu_Biruwa	2.4145284048341065	0	0.8048428016113689	0	-1
422	440	441	Subhakamana_R1_Swayambhu_Biruwa	0.41976756680730726	0	0.13992252226910243	0	-1
423	441	442	Subhakamana_R1_Swayambhu_Biruwa	1.867913525979258	0	0.622637841993086	0	-1
424	442	443	Subhakamana_R1_Swayambhu_Biruwa	0.8519143990902842	0	0.28397146636342807	0	-1
425	443	444	Subhakamana_R1_Swayambhu_Biruwa	2.6548802441420896	0	0.8849600813806966	0	-1
426	444	445	Subhakamana_R1_Swayambhu_Biruwa	1.7395677389775877	0	0.5798559129925293	0	-1
427	445	446	Subhakamana_R1_Swayambhu_Biruwa	1.9065813640362999	0	0.6355271213454333	0	-1
428	446	447	Subhakamana_R1_Swayambhu_Biruwa	2.9611186531374947	0	0.9870395510458315	0	-1
429	447	448	Subhakamana_R1_Swayambhu_Biruwa	1.1930965040168722	0	0.3976988346722907	0	-1
430	448	449	Subhakamana_R1_Swayambhu_Biruwa	0.9086004713832502	0	0.3028668237944167	0	-1
431	449	450	Subhakamana_R1_Swayambhu_Biruwa	0.9620549520263462	0	0.32068498400878204	0	-1
432	450	451	Subhakamana_R1_Swayambhu_Biruwa	1.1519156005967761	0	0.38397186686559204	0	-1
433	451	452	Subhakamana_R1_Swayambhu_Biruwa	2.1951709515871007	0	0.7317236505290335	0	-1
434	452	453	Subhakamana_R1_Swayambhu_Biruwa	1.1581870501084677	0	0.3860623500361559	0	-1
435	453	454	Subhakamana_R1_Swayambhu_Biruwa	1.2142052580277205	0	0.4047350860092402	0	-1
436	454	455	Subhakamana_R1_Swayambhu_Biruwa	0.8685123125445595	0	0.28950410418151984	0	-1
437	455	456	Subhakamana_R1_Swayambhu_Biruwa	2.6603517071954776	0	0.8867839023984926	0	-1
438	456	457	Subhakamana_R1_Swayambhu_Biruwa	1.2879133653665091	0	0.4293044551221697	0	-1
439	457	458	Subhakamana_R1_Swayambhu_Biruwa	2.472757918686367	0	0.8242526395621224	0	-1
440	458	459	Subhakamana_R1_Swayambhu_Biruwa	1.3275256384829246	0	0.44250854616097485	0	-1
441	459	460	Subhakamana_R1_Swayambhu_Biruwa	1.8073527748456741	0	0.602450924948558	0	-1
442	460	461	Subhakamana_R1_Swayambhu_Biruwa	0.841975801793217	0	0.280658600597739	0	-1
443	461	462	Subhakamana_R1_Swayambhu_Biruwa	0.613287086870945	0	0.20442902895698167	0	-1
444	462	463	Subhakamana_R1_Swayambhu_Biruwa	1.3501600998723338	0	0.4500533666241113	0	-1
445	463	464	Subhakamana_R1_Swayambhu_Biruwa	0.31740098470883693	0	0.10580032823627898	0	-1
446	464	465	Subhakamana_R1_Swayambhu_Biruwa	0.4415813727007441	0	0.14719379090024803	0	-1
447	465	466	Subhakamana_R1_Swayambhu_Biruwa	2.31368685213904	0	0.7712289507130133	0	-1
448	466	467	Subhakamana_R1_Swayambhu_Biruwa	0.601523961418001	0	0.20050798713933365	0	-1
449	467	468	Subhakamana_R1_Swayambhu_Biruwa	1.9834807288707166	0	0.6611602429569055	0	-1
450	468	469	Subhakamana_R1_Swayambhu_Biruwa	1.0593513328352278	0	0.3531171109450759	0	-1
451	469	470	Subhakamana_R1_Swayambhu_Biruwa	0.34189310352789926	0	0.11396436784263309	0	-1
452	470	471	Subhakamana_R1_Swayambhu_Biruwa	0.7217363157972797	0	0.24057877193242655	0	-1
453	471	472	Subhakamana_R1_Swayambhu_Biruwa	2.208295699137624	0	0.736098566379208	0	-1
454	472	473	Subhakamana_R1_Swayambhu_Biruwa	1.3335733458015993	0	0.4445244486005331	0	-1
455	474	475	Subhakamana_R1_Biruwa_Swayambhu	1.3335733458015993	0	0.4445244486005331	0	-1
456	475	476	Subhakamana_R1_Biruwa_Swayambhu	2.208295699137624	0	0.736098566379208	0	-1
457	476	477	Subhakamana_R1_Biruwa_Swayambhu	0.7217363157972797	0	0.24057877193242655	0	-1
458	477	478	Subhakamana_R1_Biruwa_Swayambhu	0.34189310352789926	0	0.11396436784263309	0	-1
459	478	479	Subhakamana_R1_Biruwa_Swayambhu	1.0593513328352278	0	0.3531171109450759	0	-1
460	479	480	Subhakamana_R1_Biruwa_Swayambhu	1.9834807288707166	0	0.6611602429569055	0	-1
461	480	481	Subhakamana_R1_Biruwa_Swayambhu	0.601523961418001	0	0.20050798713933365	0	-1
462	481	482	Subhakamana_R1_Biruwa_Swayambhu	2.31368685213904	0	0.7712289507130133	0	-1
463	482	483	Subhakamana_R1_Biruwa_Swayambhu	0.4415813727007441	0	0.14719379090024803	0	-1
464	483	484	Subhakamana_R1_Biruwa_Swayambhu	0.31740098470883693	0	0.10580032823627898	0	-1
465	484	485	Subhakamana_R1_Biruwa_Swayambhu	1.3501600998723338	0	0.4500533666241113	0	-1
466	485	486	Subhakamana_R1_Biruwa_Swayambhu	0.613287086870945	0	0.20442902895698167	0	-1
467	486	487	Subhakamana_R1_Biruwa_Swayambhu	0.841975801793217	0	0.280658600597739	0	-1
468	487	488	Subhakamana_R1_Biruwa_Swayambhu	1.7716811384924314	0	0.5905603794974771	0	-1
469	488	489	Subhakamana_R1_Biruwa_Swayambhu	1.2903259425495543	0	0.4301086475165181	0	-1
470	489	490	Subhakamana_R1_Biruwa_Swayambhu	1.7097984969239512	0	0.5699328323079837	0	-1
471	490	491	Subhakamana_R1_Biruwa_Swayambhu	2.1304542897232976	0	0.7101514299077659	0	-1
472	491	492	Subhakamana_R1_Biruwa_Swayambhu	2.3412633983131563	0	0.7804211327710521	0	-1
473	492	493	Subhakamana_R1_Biruwa_Swayambhu	1.152300961613893	0	0.3841003205379644	0	-1
474	493	494	Subhakamana_R1_Biruwa_Swayambhu	1.1143774332704695	0	0.3714591444234898	0	-1
475	494	495	Subhakamana_R1_Biruwa_Swayambhu	0.9707884579254817	0	0.3235961526418273	0	-1
476	495	496	Subhakamana_R1_Biruwa_Swayambhu	1.1746375725862386	0	0.3915458575287462	0	-1
477	496	497	Subhakamana_R1_Biruwa_Swayambhu	1.096632297132387	0	0.365544099044129	0	-1
478	497	498	Subhakamana_R1_Biruwa_Swayambhu	1.1828635221093418	0	0.3942878407031139	0	-1
479	498	499	Subhakamana_R1_Biruwa_Swayambhu	1.10092119351441	0	0.36697373117147003	0	-1
480	499	500	Subhakamana_R1_Biruwa_Swayambhu	0.4398094292060252	0	0.14660314306867508	0	-1
481	500	501	Subhakamana_R1_Biruwa_Swayambhu	1.8108688578443417	0	0.6036229526147806	0	-1
482	501	502	Subhakamana_R1_Biruwa_Swayambhu	2.191563234227445	0	0.7305210780758149	0	-1
483	502	503	Subhakamana_R1_Biruwa_Swayambhu	1.54890296816104	0	0.5163009893870133	0	-1
484	503	504	Subhakamana_R1_Biruwa_Swayambhu	2.412530933123794	0	0.8041769777079313	0	-1
485	504	505	Subhakamana_R1_Biruwa_Swayambhu	2.616264735049504	0	0.8720882450165014	0	-1
486	505	506	Subhakamana_R1_Biruwa_Swayambhu	0.8764567444802871	0	0.2921522481600957	0	-1
487	506	507	Subhakamana_R1_Biruwa_Swayambhu	1.9014017317003091	0	0.6338005772334364	0	-1
488	507	508	Subhakamana_R1_Biruwa_Swayambhu	1.8339996746717815	0	0.6113332248905938	0	-1
489	508	509	Subhakamana_R1_Biruwa_Swayambhu	1.0087272623643833	0	0.33624242078812777	0	-1
490	509	510	Subhakamana_R1_Biruwa_Swayambhu	2.8535212644896846	0	0.9511737548298949	0	-1
491	511	512	Tempo_R1_Maitighar_Lagankhel	1.401638361168241	0	0.4672127870560804	0	-1
492	512	513	Tempo_R1_Maitighar_Lagankhel	2.013963059285668	0	0.6713210197618893	0	-1
493	513	514	Tempo_R1_Maitighar_Lagankhel	1.3185723702654397	0	0.43952412342181324	0	-1
494	514	515	Tempo_R1_Maitighar_Lagankhel	1.6030493302447857	0	0.5343497767482619	0	-1
495	515	516	Tempo_R1_Maitighar_Lagankhel	2.4191092093965567	0	0.806369736465519	0	-1
496	516	517	Tempo_R1_Maitighar_Lagankhel	1.829621175715983	0	0.609873725238661	0	-1
497	517	518	Tempo_R1_Maitighar_Lagankhel	0.9086004713832502	0	0.3028668237944167	0	-1
498	518	519	Tempo_R1_Maitighar_Lagankhel	0.9620549520263462	0	0.32068498400878204	0	-1
499	519	520	Tempo_R1_Maitighar_Lagankhel	1.1519156005967761	0	0.38397186686559204	0	-1
500	520	521	Tempo_R1_Maitighar_Lagankhel	2.1951709515871007	0	0.7317236505290335	0	-1
501	521	522	Tempo_R1_Maitighar_Lagankhel	1.1581870501084677	0	0.3860623500361559	0	-1
502	522	523	Tempo_R1_Maitighar_Lagankhel	1.2142052580277205	0	0.4047350860092402	0	-1
503	523	524	Tempo_R1_Maitighar_Lagankhel	0.8685123125445595	0	0.28950410418151984	0	-1
504	524	525	Tempo_R1_Maitighar_Lagankhel	2.6603517071954776	0	0.8867839023984926	0	-1
505	525	526	Tempo_R1_Maitighar_Lagankhel	0.3931520212676437	0	0.13105067375588123	0	-1
506	526	527	Tempo_R1_Maitighar_Lagankhel	1.5577493389818544	0	0.5192497796606181	0	-1
507	527	528	Tempo_R1_Maitighar_Lagankhel	0.8451132960058757	0	0.28170443200195855	0	-1
508	528	529	Tempo_R1_Maitighar_Lagankhel	0.957192253631234	0	0.31906408454374463	0	-1
509	529	530	Tempo_R1_Maitighar_Lagankhel	0.7864199906766958	0	0.26213999689223194	0	-1
510	530	531	Tempo_R1_Maitighar_Lagankhel	1.3831071685216432	0	0.4610357228405478	0	-1
511	531	532	Tempo_R1_Maitighar_Lagankhel	0.7813870103209245	0	0.2604623367736415	0	-1
512	532	533	Tempo_R1_Maitighar_Lagankhel	2.6238952863506295	0	0.8746317621168764	0	-1
513	533	534	Tempo_R1_Maitighar_Lagankhel	0.8086381176025322	0	0.2695460392008441	0	-1
514	535	536	Tempo_R1_lagankhel_maitighar	2.7719284991200768	0	0.9239761663733589	0	-1
515	536	537	Tempo_R1_lagankhel_maitighar	0.8506949783251555	0	0.2835649927750518	0	-1
516	537	538	Tempo_R1_lagankhel_maitighar	1.6657614017466142	0	0.5552538005822047	0	-1
517	538	539	Tempo_R1_lagankhel_maitighar	0.8814549142962684	0	0.2938183047654228	0	-1
518	539	540	Tempo_R1_lagankhel_maitighar	2.169957163335033	0	0.7233190544450111	0	-1
519	540	541	Tempo_R1_lagankhel_maitighar	0.7864199906766958	0	0.26213999689223194	0	-1
520	541	542	Tempo_R1_lagankhel_maitighar	0.957192253631234	0	0.31906408454374463	0	-1
521	542	543	Tempo_R1_lagankhel_maitighar	0.8451132960058757	0	0.28170443200195855	0	-1
522	543	544	Tempo_R1_lagankhel_maitighar	2.0624263651942214	0	0.6874754550647405	0	-1
523	544	545	Tempo_R1_lagankhel_maitighar	2.22347034034637	0	0.7411567801154567	0	-1
524	545	546	Tempo_R1_lagankhel_maitighar	1.3433312155257353	0	0.44777707184191173	0	-1
525	546	547	Tempo_R1_lagankhel_maitighar	1.1143774332704695	0	0.3714591444234898	0	-1
526	547	548	Tempo_R1_lagankhel_maitighar	0.9707884579254817	0	0.3235961526418273	0	-1
527	548	549	Tempo_R1_lagankhel_maitighar	1.1746375725862386	0	0.3915458575287462	0	-1
528	549	550	Tempo_R1_lagankhel_maitighar	1.096632297132387	0	0.365544099044129	0	-1
529	550	551	Tempo_R1_lagankhel_maitighar	1.1828635221093418	0	0.3942878407031139	0	-1
530	551	552	Tempo_R1_lagankhel_maitighar	1.10092119351441	0	0.36697373117147003	0	-1
531	552	553	Tempo_R1_lagankhel_maitighar	0.4398094292060252	0	0.14660314306867508	0	-1
532	553	554	Tempo_R1_lagankhel_maitighar	2.2114765839260824	0	0.737158861308694	0	-1
533	554	555	Tempo_R1_lagankhel_maitighar	2.4191092093965567	0	0.806369736465519	0	-1
534	555	556	Tempo_R1_lagankhel_maitighar	1.6030493302447857	0	0.5343497767482619	0	-1
535	556	557	Tempo_R1_lagankhel_maitighar	1.3185723702654397	0	0.43952412342181324	0	-1
536	557	558	Tempo_R1_lagankhel_maitighar	2.013963059285668	0	0.6713210197618893	0	-1
537	559	560	Tempo_R2_RNAC_Sinamangal	1.5307614474830005	0	0.5102538158276668	0	-1
538	560	561	Tempo_R2_RNAC_Sinamangal	1.1187107073369813	0	0.37290356911232714	0	-1
539	561	562	Tempo_R2_RNAC_Sinamangal	0.9725450448340499	0	0.32418168161134997	0	-1
540	562	563	Tempo_R2_RNAC_Sinamangal	0.9657881362102259	0	0.32192937873674193	0	-1
541	563	564	Tempo_R2_RNAC_Sinamangal	0.7961269393185981	0	0.2653756464395327	0	-1
542	564	565	Tempo_R2_RNAC_Sinamangal	0.9823049417914693	0	0.3274349805971564	0	-1
543	565	566	Tempo_R2_RNAC_Sinamangal	0.6945061364855074	0	0.23150204549516912	0	-1
544	566	567	Tempo_R2_RNAC_Sinamangal	1.3540163683889064	0	0.45133878946296874	0	-1
545	567	568	Tempo_R2_RNAC_Sinamangal	0.8963273860466506	0	0.29877579534888354	0	-1
546	568	569	Tempo_R2_RNAC_Sinamangal	0.7843186539325944	0	0.26143955131086477	0	-1
547	569	570	Tempo_R2_RNAC_Sinamangal	0.9054084122124149	0	0.30180280407080495	0	-1
548	570	571	Tempo_R2_RNAC_Sinamangal	1.3799784962006587	0	0.45999283206688624	0	-1
549	571	572	Tempo_R2_RNAC_Sinamangal	1.8999993974520744	0	0.6333331324840248	0	-1
550	572	573	Tempo_R2_RNAC_Sinamangal	1.5590679912132355	0	0.5196893304044118	0	-1
551	573	574	Tempo_R2_RNAC_Sinamangal	0.9265002034498445	0	0.3088334011499482	0	-1
552	575	576	Tempo_R2_Sinamangal_RNAC	0.9265002034498445	0	0.3088334011499482	0	-1
553	576	577	Tempo_R2_Sinamangal_RNAC	1.5590679912132355	0	0.5196893304044118	0	-1
554	577	578	Tempo_R2_Sinamangal_RNAC	1.8999993974520744	0	0.6333331324840248	0	-1
555	578	579	Tempo_R2_Sinamangal_RNAC	1.3799784962006587	0	0.45999283206688624	0	-1
556	579	580	Tempo_R2_Sinamangal_RNAC	0.9054084122124149	0	0.30180280407080495	0	-1
557	580	581	Tempo_R2_Sinamangal_RNAC	1.2794177037197223	0	0.42647256790657406	0	-1
558	581	582	Tempo_R2_Sinamangal_RNAC	1.4445263943084812	0	0.48150879810282704	0	-1
559	582	583	Tempo_R2_Sinamangal_RNAC	0.8937569756937834	0	0.2979189918979278	0	-1
560	583	584	Tempo_R2_Sinamangal_RNAC	0.8016366373358006	0	0.2672122124452669	0	-1
561	584	585	Tempo_R2_Sinamangal_RNAC	0.985363620965488	0	0.3284545403218293	0	-1
562	585	586	Tempo_R2_Sinamangal_RNAC	0.1559401619919941	0	0.05198005399733137	0	-1
563	586	587	Tempo_R2_Sinamangal_RNAC	1.207244747740107	0	0.40241491591336903	0	-1
564	587	588	Tempo_R2_Sinamangal_RNAC	0.502053620515694	0	0.16735120683856466	0	-1
565	589	590	Tempo_R3_RNAC_Tinchuli	1.5307614474830005	0	0.5102538158276668	0	-1
566	590	591	Tempo_R3_RNAC_Tinchuli	1.1187107073369813	0	0.37290356911232714	0	-1
567	591	592	Tempo_R3_RNAC_Tinchuli	0.9725450448340499	0	0.32418168161134997	0	-1
568	592	593	Tempo_R3_RNAC_Tinchuli	0.9657881362102259	0	0.32192937873674193	0	-1
569	593	594	Tempo_R3_RNAC_Tinchuli	0.7961269393185981	0	0.2653756464395327	0	-1
570	594	595	Tempo_R3_RNAC_Tinchuli	0.9823049417914693	0	0.3274349805971564	0	-1
571	595	596	Tempo_R3_RNAC_Tinchuli	0.6945061364855074	0	0.23150204549516912	0	-1
572	596	597	Tempo_R3_RNAC_Tinchuli	1.3540163683889064	0	0.45133878946296874	0	-1
573	597	598	Tempo_R3_RNAC_Tinchuli	0.8963273860466506	0	0.29877579534888354	0	-1
574	598	599	Tempo_R3_RNAC_Tinchuli	0.7843186539325944	0	0.26143955131086477	0	-1
575	599	600	Tempo_R3_RNAC_Tinchuli	0.9054084122124149	0	0.30180280407080495	0	-1
576	600	601	Tempo_R3_RNAC_Tinchuli	1.3799784962006587	0	0.45999283206688624	0	-1
577	601	602	Tempo_R3_RNAC_Tinchuli	0.12695124294722868	0	0.04231708098240956	0	-1
578	602	603	Tempo_R3_RNAC_Tinchuli	1.1996261097566243	0	0.3998753699188748	0	-1
579	603	604	Tempo_R3_RNAC_Tinchuli	0.9257328123345402	0	0.3085776041115134	0	-1
580	604	605	Tempo_R3_RNAC_Tinchuli	0.9755456253199225	0	0.3251818751066408	0	-1
581	605	606	Tempo_R3_RNAC_Tinchuli	1.0127204997555643	0	0.3375734999185214	0	-1
582	606	607	Tempo_R3_RNAC_Tinchuli	1.3395044076378675	0	0.44650146921262246	0	-1
583	607	608	Tempo_R3_RNAC_Tinchuli	0.7013614915062687	0	0.2337871638354229	0	-1
584	608	609	Tempo_R3_RNAC_Tinchuli	0.9517622656754756	0	0.31725408855849185	0	-1
585	609	610	Tempo_R3_RNAC_Tinchuli	2.235575856481688	0	0.7451919521605627	0	-1
586	610	611	Tempo_R3_RNAC_Tinchuli	2.1155511121992046	0	0.7051837040664015	0	-1
1525	42	511	\N	3	1	0	1	-1
587	611	612	Tempo_R3_RNAC_Tinchuli	1.4788096311799335	0	0.49293654372664447	0	-1
588	613	614	Tempo_R3_Tinchuli_RNAC	1.4788096311799335	0	0.49293654372664447	0	-1
589	614	615	Tempo_R3_Tinchuli_RNAC	2.1155511121992046	0	0.7051837040664015	0	-1
590	615	616	Tempo_R3_Tinchuli_RNAC	2.235575856481688	0	0.7451919521605627	0	-1
591	616	617	Tempo_R3_Tinchuli_RNAC	0.9517622656754756	0	0.31725408855849185	0	-1
592	617	618	Tempo_R3_Tinchuli_RNAC	0.6224625113895998	0	0.2074875037965333	0	-1
593	618	619	Tempo_R3_Tinchuli_RNAC	1.4974203646741095	0	0.4991401215580365	0	-1
594	619	620	Tempo_R3_Tinchuli_RNAC	1.0127204997555643	0	0.3375734999185214	0	-1
595	620	621	Tempo_R3_Tinchuli_RNAC	0.9755456253199225	0	0.3251818751066408	0	-1
596	621	622	Tempo_R3_Tinchuli_RNAC	0.9257328123345402	0	0.3085776041115134	0	-1
597	622	623	Tempo_R3_Tinchuli_RNAC	1.1996261097566243	0	0.3998753699188748	0	-1
598	623	624	Tempo_R3_Tinchuli_RNAC	0.12695124294722868	0	0.04231708098240956	0	-1
599	624	625	Tempo_R3_Tinchuli_RNAC	1.3799784962006587	0	0.45999283206688624	0	-1
600	625	626	Tempo_R3_Tinchuli_RNAC	0.9054084122124149	0	0.30180280407080495	0	-1
601	626	627	Tempo_R3_Tinchuli_RNAC	1.2794177037197223	0	0.42647256790657406	0	-1
602	627	628	Tempo_R3_Tinchuli_RNAC	1.4445263943084812	0	0.48150879810282704	0	-1
603	628	629	Tempo_R3_Tinchuli_RNAC	0.8937569756937834	0	0.2979189918979278	0	-1
604	629	630	Tempo_R3_Tinchuli_RNAC	0.8016366373358006	0	0.2672122124452669	0	-1
605	630	631	Tempo_R3_Tinchuli_RNAC	0.985363620965488	0	0.3284545403218293	0	-1
606	631	632	Tempo_R3_Tinchuli_RNAC	0.1559401619919941	0	0.05198005399733137	0	-1
607	632	633	Tempo_R3_Tinchuli_RNAC	1.207244747740107	0	0.40241491591336903	0	-1
608	633	634	Tempo_R3_Tinchuli_RNAC	0.502053620515694	0	0.16735120683856466	0	-1
609	635	636	Tempo_R4_Kapan _ Sankhamul	1.8052966199590672	0	0.6017655399863557	0	-1
610	636	637	Tempo_R4_Kapan _ Sankhamul	0.8695993225633895	0	0.28986644085446317	0	-1
611	637	638	Tempo_R4_Kapan _ Sankhamul	1.1421543994518526	0	0.3807181331506175	0	-1
612	638	639	Tempo_R4_Kapan _ Sankhamul	1.2250175351546964	0	0.4083391783848988	0	-1
613	639	640	Tempo_R4_Kapan _ Sankhamul	1.5042832611350243	0	0.5014277537116748	0	-1
614	640	641	Tempo_R4_Kapan _ Sankhamul	0.7638429472025654	0	0.25461431573418847	0	-1
615	641	642	Tempo_R4_Kapan _ Sankhamul	1.6984786377821026	0	0.5661595459273675	0	-1
616	642	643	Tempo_R4_Kapan _ Sankhamul	1.9354262306412502	0	0.6451420768804167	0	-1
617	643	644	Tempo_R4_Kapan _ Sankhamul	1.6257410432293522	0	0.5419136810764508	0	-1
618	644	645	Tempo_R4_Kapan _ Sankhamul	1.3395044076378675	0	0.44650146921262246	0	-1
619	645	646	Tempo_R4_Kapan _ Sankhamul	1.0127204997555643	0	0.3375734999185214	0	-1
620	646	647	Tempo_R4_Kapan _ Sankhamul	0.9755456253199225	0	0.3251818751066408	0	-1
621	647	648	Tempo_R4_Kapan _ Sankhamul	0.9257328123345402	0	0.3085776041115134	0	-1
622	648	649	Tempo_R4_Kapan _ Sankhamul	1.1996261097566243	0	0.3998753699188748	0	-1
623	649	650	Tempo_R4_Kapan _ Sankhamul	0.5838089467693728	0	0.19460298225645759	0	-1
624	650	651	Tempo_R4_Kapan _ Sankhamul	1.14170432042132	0	0.3805681068071066	0	-1
625	651	652	Tempo_R4_Kapan _ Sankhamul	1.5297307518420227	0	0.5099102506140075	0	-1
626	652	653	Tempo_R4_Kapan _ Sankhamul	0.8092746847776667	0	0.26975822825922224	0	-1
627	653	654	Tempo_R4_Kapan _ Sankhamul	0.8124928035796608	0	0.2708309345265536	0	-1
628	654	655	Tempo_R4_Kapan _ Sankhamul	0.7734125392151773	0	0.2578041797383924	0	-1
629	655	656	Tempo_R4_Kapan _ Sankhamul	0.544030573032581	0	0.18134352434419365	0	-1
630	656	657	Tempo_R4_Kapan _ Sankhamul	0.3805399041927587	0	0.12684663473091956	0	-1
631	657	658	Tempo_R4_Kapan _ Sankhamul	0.9279198960293786	0	0.30930663200979286	0	-1
632	659	660	Tempo_R4_Sankhamul_Kapan	0.9279198960293786	0	0.30930663200979286	0	-1
633	660	661	Tempo_R4_Sankhamul_Kapan	0.3805399041927587	0	0.12684663473091956	0	-1
634	661	662	Tempo_R4_Sankhamul_Kapan	0.544030573032581	0	0.18134352434419365	0	-1
635	662	663	Tempo_R4_Sankhamul_Kapan	0.7734125392151773	0	0.2578041797383924	0	-1
636	663	664	Tempo_R4_Sankhamul_Kapan	0.8124928035796608	0	0.2708309345265536	0	-1
637	664	665	Tempo_R4_Sankhamul_Kapan	0.8092746847776667	0	0.26975822825922224	0	-1
638	665	666	Tempo_R4_Sankhamul_Kapan	1.5297307518420227	0	0.5099102506140075	0	-1
639	666	667	Tempo_R4_Sankhamul_Kapan	1.14170432042132	0	0.3805681068071066	0	-1
640	667	668	Tempo_R4_Sankhamul_Kapan	0.5838089467693728	0	0.19460298225645759	0	-1
641	668	669	Tempo_R4_Sankhamul_Kapan	1.1996261097566243	0	0.3998753699188748	0	-1
642	669	670	Tempo_R4_Sankhamul_Kapan	0.9257328123345402	0	0.3085776041115134	0	-1
643	670	671	Tempo_R4_Sankhamul_Kapan	0.9755456253199225	0	0.3251818751066408	0	-1
644	671	672	Tempo_R4_Sankhamul_Kapan	1.0127204997555643	0	0.3375734999185214	0	-1
645	672	673	Tempo_R4_Sankhamul_Kapan	1.3395044076378675	0	0.44650146921262246	0	-1
646	673	674	Tempo_R4_Sankhamul_Kapan	1.6257410432293522	0	0.5419136810764508	0	-1
647	674	675	Tempo_R4_Sankhamul_Kapan	1.9354262306412502	0	0.6451420768804167	0	-1
648	675	676	Tempo_R4_Sankhamul_Kapan	1.6984786377821026	0	0.5661595459273675	0	-1
649	676	677	Tempo_R4_Sankhamul_Kapan	0.7638429472025654	0	0.25461431573418847	0	-1
650	677	678	Tempo_R4_Sankhamul_Kapan	1.5042832611350243	0	0.5014277537116748	0	-1
651	678	679	Tempo_R4_Sankhamul_Kapan	1.2250175351546964	0	0.4083391783848988	0	-1
652	679	680	Tempo_R4_Sankhamul_Kapan	1.1421543994518526	0	0.3807181331506175	0	-1
653	680	681	Tempo_R4_Sankhamul_Kapan	0.8695993225633895	0	0.28986644085446317	0	-1
654	681	682	Tempo_R4_Sankhamul_Kapan	1.8052966199590672	0	0.6017655399863557	0	-1
655	683	684	Tempo_R5_Ratnapark_Imadol	1.8970059458867343	0	0.6323353152955781	0	-1
656	684	685	Tempo_R5_Ratnapark_Imadol	1.5975080013174248	0	0.5325026671058083	0	-1
657	685	686	Tempo_R5_Ratnapark_Imadol	0.1559401619919941	0	0.05198005399733137	0	-1
658	686	687	Tempo_R5_Ratnapark_Imadol	2.1125904390702797	0	0.7041968130234266	0	-1
659	687	688	Tempo_R5_Ratnapark_Imadol	0.5141356220617795	0	0.17137854068725983	0	-1
660	688	689	Tempo_R5_Ratnapark_Imadol	0.9804255205830735	0	0.3268085068610245	0	-1
661	689	690	Tempo_R5_Ratnapark_Imadol	2.2114765839260824	0	0.737158861308694	0	-1
662	690	691	Tempo_R5_Ratnapark_Imadol	2.4191092093965567	0	0.806369736465519	0	-1
663	691	692	Tempo_R5_Ratnapark_Imadol	1.6030493302447857	0	0.5343497767482619	0	-1
664	692	693	Tempo_R5_Ratnapark_Imadol	0.39299320440643976	0	0.13099773480214658	0	-1
665	693	694	Tempo_R5_Ratnapark_Imadol	1.4353415538118597	0	0.4784471846039532	0	-1
666	694	695	Tempo_R5_Ratnapark_Imadol	1.0308912767699616	0	0.3436304255899872	0	-1
667	695	696	Tempo_R5_Ratnapark_Imadol	2.417651837842676	0	0.8058839459475586	0	-1
668	696	697	Tempo_R5_Ratnapark_Imadol	0.9449578623711727	0	0.31498595412372427	0	-1
669	697	698	Tempo_R5_Ratnapark_Imadol	0.8892353063799123	0	0.2964117687933041	0	-1
670	698	699	Tempo_R5_Ratnapark_Imadol	1.5341022541468088	0	0.5113674180489363	0	-1
671	699	700	Tempo_R5_Ratnapark_Imadol	0.29471057882795904	0	0.09823685960931969	0	-1
672	700	701	Tempo_R5_Ratnapark_Imadol	0.7234464230500146	0	0.2411488076833382	0	-1
673	701	702	Tempo_R5_Ratnapark_Imadol	0.9218860342688245	0	0.30729534475627485	0	-1
674	702	703	Tempo_R5_Ratnapark_Imadol	1.2092274652511998	0	0.40307582175039997	0	-1
675	703	704	Tempo_R5_Ratnapark_Imadol	0.3850802155887433	0	0.12836007186291443	0	-1
676	704	705	Tempo_R5_Ratnapark_Imadol	0.6271019376065164	0	0.20903397920217215	0	-1
677	705	706	Tempo_R5_Ratnapark_Imadol	0.5802052981849987	0	0.1934017660616662	0	-1
678	706	707	Tempo_R5_Ratnapark_Imadol	0.9156651317927262	0	0.3052217105975754	0	-1
679	707	708	Tempo_R5_Ratnapark_Imadol	0.8164633686950038	0	0.27215445623166795	0	-1
680	709	710	Tempo_R5_Imadol_Ratnapark	0.8164633686950038	0	0.27215445623166795	0	-1
681	710	711	Tempo_R5_Imadol_Ratnapark	0.9156651317927262	0	0.3052217105975754	0	-1
682	711	712	Tempo_R5_Imadol_Ratnapark	0.5802052981849987	0	0.1934017660616662	0	-1
683	712	713	Tempo_R5_Imadol_Ratnapark	0.6271019376065164	0	0.20903397920217215	0	-1
684	713	714	Tempo_R5_Imadol_Ratnapark	0.3850802155887433	0	0.12836007186291443	0	-1
685	714	715	Tempo_R5_Imadol_Ratnapark	1.2092274652511998	0	0.40307582175039997	0	-1
686	715	716	Tempo_R5_Imadol_Ratnapark	0.9218860342688245	0	0.30729534475627485	0	-1
687	716	717	Tempo_R5_Imadol_Ratnapark	0.7234464230500146	0	0.2411488076833382	0	-1
688	717	718	Tempo_R5_Imadol_Ratnapark	0.29471057882795904	0	0.09823685960931969	0	-1
689	718	719	Tempo_R5_Imadol_Ratnapark	1.5341022541468088	0	0.5113674180489363	0	-1
690	719	720	Tempo_R5_Imadol_Ratnapark	0.8892353063799123	0	0.2964117687933041	0	-1
691	720	721	Tempo_R5_Imadol_Ratnapark	0.9449578623711727	0	0.31498595412372427	0	-1
692	721	722	Tempo_R5_Imadol_Ratnapark	2.417651837842676	0	0.8058839459475586	0	-1
693	722	723	Tempo_R5_Imadol_Ratnapark	1.0308912767699616	0	0.3436304255899872	0	-1
694	723	724	Tempo_R5_Imadol_Ratnapark	1.4353415538118597	0	0.4784471846039532	0	-1
695	724	725	Tempo_R5_Imadol_Ratnapark	0.39299320440643976	0	0.13099773480214658	0	-1
696	725	726	Tempo_R5_Imadol_Ratnapark	1.6030493302447857	0	0.5343497767482619	0	-1
697	726	727	Tempo_R5_Imadol_Ratnapark	2.4191092093965567	0	0.806369736465519	0	-1
698	727	728	Tempo_R5_Imadol_Ratnapark	1.8541164585969423	0	0.6180388195323141	0	-1
699	728	729	Tempo_R5_Imadol_Ratnapark	2.6369476097657105	0	0.8789825365885702	0	-1
700	730	731	Nepal_R1_Balkhu_Harhar_Mahadev	0.9476527249523403	0	0.3158842416507801	0	-1
701	731	732	Nepal_R1_Balkhu_Harhar_Mahadev	1.072690778733672	0	0.35756359291122397	0	-1
702	732	733	Nepal_R1_Balkhu_Harhar_Mahadev	2.1230979891528485	0	0.7076993297176162	0	-1
703	733	734	Nepal_R1_Balkhu_Harhar_Mahadev	1.2245028119341383	0	0.4081676039780461	0	-1
704	734	735	Nepal_R1_Balkhu_Harhar_Mahadev	1.9688210369125103	0	0.6562736789708368	0	-1
705	735	736	Nepal_R1_Balkhu_Harhar_Mahadev	1.1720333026981762	0	0.3906777675660587	0	-1
706	736	737	Nepal_R1_Balkhu_Harhar_Mahadev	1.2461112094463997	0	0.41537040314879997	0	-1
707	737	738	Nepal_R1_Balkhu_Harhar_Mahadev	1.3894399908715518	0	0.46314666362385054	0	-1
708	738	739	Nepal_R1_Balkhu_Harhar_Mahadev	1.6123353068415636	0	0.5374451022805212	0	-1
709	739	740	Nepal_R1_Balkhu_Harhar_Mahadev	2.4191092093965567	0	0.806369736465519	0	-1
710	740	741	Nepal_R1_Balkhu_Harhar_Mahadev	1.829621175715983	0	0.609873725238661	0	-1
711	741	742	Nepal_R1_Balkhu_Harhar_Mahadev	0.9086004713832502	0	0.3028668237944167	0	-1
712	742	743	Nepal_R1_Balkhu_Harhar_Mahadev	0.9620549520263462	0	0.32068498400878204	0	-1
713	743	744	Nepal_R1_Balkhu_Harhar_Mahadev	1.1519156005967761	0	0.38397186686559204	0	-1
714	744	745	Nepal_R1_Balkhu_Harhar_Mahadev	2.1951709515871007	0	0.7317236505290335	0	-1
715	745	746	Nepal_R1_Balkhu_Harhar_Mahadev	1.1581870501084677	0	0.3860623500361559	0	-1
716	746	747	Nepal_R1_Balkhu_Harhar_Mahadev	1.2142052580277205	0	0.4047350860092402	0	-1
717	747	748	Nepal_R1_Balkhu_Harhar_Mahadev	0.8685123125445595	0	0.28950410418151984	0	-1
718	748	749	Nepal_R1_Balkhu_Harhar_Mahadev	2.6603517071954776	0	0.8867839023984926	0	-1
719	749	750	Nepal_R1_Balkhu_Harhar_Mahadev	1.2879133653665091	0	0.4293044551221697	0	-1
720	750	751	Nepal_R1_Balkhu_Harhar_Mahadev	3.4147929366308234	0	1.1382643122102745	0	-1
721	751	752	Nepal_R1_Balkhu_Harhar_Mahadev	1.7622937851595037	0	0.5874312617198346	0	-1
722	752	753	Nepal_R1_Balkhu_Harhar_Mahadev	1.2054408140409665	0	0.4018136046803222	0	-1
723	753	754	Nepal_R1_Balkhu_Harhar_Mahadev	1.4709559452407457	0	0.49031864841358186	0	-1
724	754	755	Nepal_R1_Balkhu_Harhar_Mahadev	1.0808412412274728	0	0.3602804137424909	0	-1
725	755	756	Nepal_R1_Balkhu_Harhar_Mahadev	1.7181319561966808	0	0.5727106520655603	0	-1
726	756	757	Nepal_R1_Balkhu_Harhar_Mahadev	2.979928086550782	0	0.9933093621835939	0	-1
727	757	758	Nepal_R1_Balkhu_Harhar_Mahadev	2.32823477864664	0	0.7760782595488801	0	-1
728	759	760	Nepal_R1_Harhar_Mahadev_Balkhu	2.32823477864664	0	0.7760782595488801	0	-1
729	760	761	Nepal_R1_Harhar_Mahadev_Balkhu	2.979928086550782	0	0.9933093621835939	0	-1
730	761	762	Nepal_R1_Harhar_Mahadev_Balkhu	1.7181319561966808	0	0.5727106520655603	0	-1
731	762	763	Nepal_R1_Harhar_Mahadev_Balkhu	1.0808412412274728	0	0.3602804137424909	0	-1
732	763	764	Nepal_R1_Harhar_Mahadev_Balkhu	1.4709559452407457	0	0.49031864841358186	0	-1
733	764	765	Nepal_R1_Harhar_Mahadev_Balkhu	1.1857989072511155	0	0.39526630241703853	0	-1
734	765	766	Nepal_R1_Harhar_Mahadev_Balkhu	1.7634074192359468	0	0.587802473078649	0	-1
735	766	767	Nepal_R1_Harhar_Mahadev_Balkhu	2.945876989883069	0	0.9819589966276897	0	-1
736	767	768	Nepal_R1_Harhar_Mahadev_Balkhu	1.5020494929531132	0	0.5006831643177044	0	-1
737	768	769	Nepal_R1_Harhar_Mahadev_Balkhu	2.22347034034637	0	0.7411567801154567	0	-1
738	769	770	Nepal_R1_Harhar_Mahadev_Balkhu	1.3433312155257353	0	0.44777707184191173	0	-1
739	770	771	Nepal_R1_Harhar_Mahadev_Balkhu	1.1143774332704695	0	0.3714591444234898	0	-1
740	771	772	Nepal_R1_Harhar_Mahadev_Balkhu	0.9707884579254817	0	0.3235961526418273	0	-1
741	772	773	Nepal_R1_Harhar_Mahadev_Balkhu	1.1746375725862386	0	0.3915458575287462	0	-1
742	773	774	Nepal_R1_Harhar_Mahadev_Balkhu	1.096632297132387	0	0.365544099044129	0	-1
743	774	775	Nepal_R1_Harhar_Mahadev_Balkhu	1.1828635221093418	0	0.3942878407031139	0	-1
744	775	776	Nepal_R1_Harhar_Mahadev_Balkhu	1.10092119351441	0	0.36697373117147003	0	-1
745	776	777	Nepal_R1_Harhar_Mahadev_Balkhu	0.4398094292060252	0	0.14660314306867508	0	-1
746	777	778	Nepal_R1_Harhar_Mahadev_Balkhu	1.8108688578443417	0	0.6036229526147806	0	-1
747	778	779	Nepal_R1_Harhar_Mahadev_Balkhu	2.191563234227445	0	0.7305210780758149	0	-1
748	779	780	Nepal_R1_Harhar_Mahadev_Balkhu	1.54890296816104	0	0.5163009893870133	0	-1
749	780	781	Nepal_R1_Harhar_Mahadev_Balkhu	1.205079938147499	0	0.40169331271583303	0	-1
750	781	782	Nepal_R1_Harhar_Mahadev_Balkhu	1.392180137065417	0	0.4640600456884723	0	-1
751	782	783	Nepal_R1_Harhar_Mahadev_Balkhu	1.1193536879335355	0	0.37311789597784517	0	-1
752	783	784	Nepal_R1_Harhar_Mahadev_Balkhu	1.09211416934293	0	0.3640380564476433	0	-1
753	785	786	Nepal_R2_Mulpani_Ghantaghar	0.7012545332403898	0	0.2337515110801299	0	-1
754	786	787	Nepal_R2_Mulpani_Ghantaghar	1.9572470006455869	0	0.6524156668818624	0	-1
755	787	788	Nepal_R2_Mulpani_Ghantaghar	3.2820693913994847	0	1.094023130466495	0	-1
756	788	789	Nepal_R2_Mulpani_Ghantaghar	1.737931853077982	0	0.5793106176926607	0	-1
757	789	790	Nepal_R2_Mulpani_Ghantaghar	1.9473415577108224	0	0.6491138525702742	0	-1
758	790	791	Nepal_R2_Mulpani_Ghantaghar	1.450924108127409	0	0.48364136937580293	0	-1
759	791	792	Nepal_R2_Mulpani_Ghantaghar	0.6735338616552974	0	0.22451128721843247	0	-1
760	792	793	Nepal_R2_Mulpani_Ghantaghar	0.6178756143436963	0	0.20595853811456546	0	-1
761	793	794	Nepal_R2_Mulpani_Ghantaghar	0.5525831986711416	0	0.1841943995570472	0	-1
762	794	795	Nepal_R2_Mulpani_Ghantaghar	0.24277112038629917	0	0.08092370679543305	0	-1
763	795	796	Nepal_R2_Mulpani_Ghantaghar	0.7294242368652873	0	0.24314141228842912	0	-1
764	796	797	Nepal_R2_Mulpani_Ghantaghar	2.54814476686862	0	0.8493815889562066	0	-1
765	797	798	Nepal_R2_Mulpani_Ghantaghar	1.7634074192359468	0	0.587802473078649	0	-1
766	798	799	Nepal_R2_Mulpani_Ghantaghar	2.945876989883069	0	0.9819589966276897	0	-1
767	799	800	Nepal_R2_Mulpani_Ghantaghar	1.5020494929531132	0	0.5006831643177044	0	-1
768	800	801	Nepal_R2_Mulpani_Ghantaghar	2.22347034034637	0	0.7411567801154567	0	-1
769	801	802	Nepal_R2_Mulpani_Ghantaghar	1.3433312155257353	0	0.44777707184191173	0	-1
770	802	803	Nepal_R2_Mulpani_Ghantaghar	1.1143774332704695	0	0.3714591444234898	0	-1
771	803	804	Nepal_R2_Mulpani_Ghantaghar	0.9707884579254817	0	0.3235961526418273	0	-1
772	804	805	Nepal_R2_Mulpani_Ghantaghar	1.1746375725862386	0	0.3915458575287462	0	-1
773	805	806	Nepal_R2_Mulpani_Ghantaghar	1.096632297132387	0	0.365544099044129	0	-1
774	806	807	Nepal_R2_Mulpani_Ghantaghar	1.1828635221093418	0	0.3942878407031139	0	-1
775	807	808	Nepal_R2_Mulpani_Ghantaghar	1.10092119351441	0	0.36697373117147003	0	-1
776	808	809	Nepal_R2_Mulpani_Ghantaghar	0.9192581972253921	0	0.3064193990751307	0	-1
777	809	810	Nepal_R2_Mulpani_Ghantaghar	0.5141356220617795	0	0.17137854068725983	0	-1
778	810	811	Nepal_R2_Mulpani_Ghantaghar	2.6205085550571456	0	0.8735028516857152	0	-1
779	811	812	Nepal_R2_Mulpani_Ghantaghar	1.3483522288996597	0	0.4494507429665532	0	-1
780	812	813	Nepal_R2_Mulpani_Ghantaghar	0.6414267058572491	0	0.2138089019524164	0	-1
781	814	815	Nepal_R2_Ghantaghar_Mulpani	1.7603742515445522	0	0.5867914171815174	0	-1
782	815	816	Nepal_R2_Ghantaghar_Mulpani	1.227619607531096	0	0.40920653584369865	0	-1
783	816	817	Nepal_R2_Ghantaghar_Mulpani	1.9481126887936027	0	0.6493708962645343	0	-1
784	817	818	Nepal_R2_Ghantaghar_Mulpani	1.6089741543142466	0	0.5363247181047489	0	-1
785	818	819	Nepal_R2_Ghantaghar_Mulpani	0.9086004713832502	0	0.3028668237944167	0	-1
786	819	820	Nepal_R2_Ghantaghar_Mulpani	0.9620549520263462	0	0.32068498400878204	0	-1
787	820	821	Nepal_R2_Ghantaghar_Mulpani	1.1519156005967761	0	0.38397186686559204	0	-1
788	821	822	Nepal_R2_Ghantaghar_Mulpani	2.1951709515871007	0	0.7317236505290335	0	-1
789	822	823	Nepal_R2_Ghantaghar_Mulpani	1.1581870501084677	0	0.3860623500361559	0	-1
790	823	824	Nepal_R2_Ghantaghar_Mulpani	1.2142052580277205	0	0.4047350860092402	0	-1
791	824	825	Nepal_R2_Ghantaghar_Mulpani	0.8685123125445595	0	0.28950410418151984	0	-1
792	825	826	Nepal_R2_Ghantaghar_Mulpani	2.6603517071954776	0	0.8867839023984926	0	-1
793	826	827	Nepal_R2_Ghantaghar_Mulpani	1.2879133653665091	0	0.4293044551221697	0	-1
794	827	828	Nepal_R2_Ghantaghar_Mulpani	3.4147929366308234	0	1.1382643122102745	0	-1
795	828	829	Nepal_R2_Ghantaghar_Mulpani	1.7622937851595037	0	0.5874312617198346	0	-1
796	829	830	Nepal_R2_Ghantaghar_Mulpani	2.5440295000624884	0	0.8480098333541628	0	-1
797	830	831	Nepal_R2_Ghantaghar_Mulpani	0.7294242368652873	0	0.24314141228842912	0	-1
798	831	832	Nepal_R2_Ghantaghar_Mulpani	0.24277112038629917	0	0.08092370679543305	0	-1
799	832	833	Nepal_R2_Ghantaghar_Mulpani	0.5525831986711416	0	0.1841943995570472	0	-1
800	833	834	Nepal_R2_Ghantaghar_Mulpani	0.6178756143436963	0	0.20595853811456546	0	-1
801	834	835	Nepal_R2_Ghantaghar_Mulpani	0.6735338616552974	0	0.22451128721843247	0	-1
802	835	836	Nepal_R2_Ghantaghar_Mulpani	1.450924108127409	0	0.48364136937580293	0	-1
803	836	837	Nepal_R2_Ghantaghar_Mulpani	1.9473415577108224	0	0.6491138525702742	0	-1
804	837	838	Nepal_R2_Ghantaghar_Mulpani	1.737931853077982	0	0.5793106176926607	0	-1
805	838	839	Nepal_R2_Ghantaghar_Mulpani	3.2820693913994847	0	1.094023130466495	0	-1
806	839	840	Nepal_R2_Ghantaghar_Mulpani	1.9572470006455869	0	0.6524156668818624	0	-1
807	841	842	Nepal_R3_Kapan_Tikathali	0.6162954241500362	0	0.2054318080500121	0	-1
808	842	843	Nepal_R3_Kapan_Tikathali	0.40874809431960757	0	0.1362493647732025	0	-1
809	843	844	Nepal_R3_Kapan_Tikathali	0.34472384506667336	0	0.1149079483555578	0	-1
810	844	845	Nepal_R3_Kapan_Tikathali	0.7347412793631678	0	0.2449137597877226	0	-1
811	845	846	Nepal_R3_Kapan_Tikathali	0.6642877758763193	0	0.22142925862543975	0	-1
812	846	847	Nepal_R3_Kapan_Tikathali	0.617728862806152	0	0.205909620935384	0	-1
813	847	848	Nepal_R3_Kapan_Tikathali	0.45095676120355815	0	0.15031892040118605	0	-1
814	848	849	Nepal_R3_Kapan_Tikathali	0.5244080530204422	0	0.1748026843401474	0	-1
815	849	850	Nepal_R3_Kapan_Tikathali	0.8241666360206242	0	0.27472221200687474	0	-1
816	850	851	Nepal_R3_Kapan_Tikathali	0.3419233237555954	0	0.11397444125186514	0	-1
817	851	852	Nepal_R3_Kapan_Tikathali	2.1155511121992046	0	0.7051837040664015	0	-1
818	852	853	Nepal_R3_Kapan_Tikathali	2.235575856481688	0	0.7451919521605627	0	-1
819	853	854	Nepal_R3_Kapan_Tikathali	0.9517622656754756	0	0.31725408855849185	0	-1
820	854	855	Nepal_R3_Kapan_Tikathali	0.6224625113895998	0	0.2074875037965333	0	-1
821	855	856	Nepal_R3_Kapan_Tikathali	1.3958651951168992	0	0.46528839837229974	0	-1
822	856	857	Nepal_R3_Kapan_Tikathali	3.3174188919675207	0	1.105806297322507	0	-1
823	857	858	Nepal_R3_Kapan_Tikathali	1.3520909440999402	0	0.45069698136664677	0	-1
824	858	859	Nepal_R3_Kapan_Tikathali	2.1609955772240093	0	0.7203318590746698	0	-1
825	859	860	Nepal_R3_Kapan_Tikathali	0.64592466254204	0	0.21530822084734666	0	-1
826	860	861	Nepal_R3_Kapan_Tikathali	1.7202528367352408	0	0.5734176122450803	0	-1
827	861	862	Nepal_R3_Kapan_Tikathali	1.4319289969517368	0	0.477309665650579	0	-1
828	862	863	Nepal_R3_Kapan_Tikathali	1.2442958614337913	0	0.4147652871445971	0	-1
829	863	864	Nepal_R3_Kapan_Tikathali	1.1176065378287006	0	0.3725355126095668	0	-1
830	864	865	Nepal_R3_Kapan_Tikathali	1.7099542370051033	0	0.5699847456683678	0	-1
831	865	866	Nepal_R3_Kapan_Tikathali	0.8764106197345403	0	0.2921368732448468	0	-1
832	866	867	Nepal_R3_Kapan_Tikathali	0.8950403351618259	0	0.2983467783872753	0	-1
833	867	868	Nepal_R3_Kapan_Tikathali	0.7872257552478488	0	0.2624085850826163	0	-1
834	868	869	Nepal_R3_Kapan_Tikathali	0.3226690059330716	0	0.10755633531102385	0	-1
835	869	870	Nepal_R3_Kapan_Tikathali	0.5046067320102493	0	0.16820224400341643	0	-1
836	870	871	Nepal_R3_Kapan_Tikathali	1.008436811832242	0	0.3361456039440806	0	-1
837	871	872	Nepal_R3_Kapan_Tikathali	1.773797099917449	0	0.591265699972483	0	-1
838	872	873	Nepal_R3_Kapan_Tikathali	0.8526120411907218	0	0.28420401373024057	0	-1
839	873	874	Nepal_R3_Kapan_Tikathali	0.8860814685768983	0	0.29536048952563276	0	-1
840	874	875	Nepal_R3_Kapan_Tikathali	1.71004835343797	0	0.5700161178126567	0	-1
841	875	876	Nepal_R3_Kapan_Tikathali	1.814553301399355	0	0.6048511004664516	0	-1
842	876	877	Nepal_R3_Kapan_Tikathali	0.9133820368192938	0	0.3044606789397646	0	-1
843	877	878	Nepal_R3_Kapan_Tikathali	0.7980263657355076	0	0.2660087885785025	0	-1
844	878	879	Nepal_R3_Kapan_Tikathali	1.0926496112771282	0	0.3642165370923761	0	-1
845	879	880	Nepal_R3_Kapan_Tikathali	1.1337455539423502	0	0.3779151846474501	0	-1
846	880	881	Nepal_R3_Kapan_Tikathali	1.2142052580277205	0	0.4047350860092402	0	-1
847	881	882	Nepal_R3_Kapan_Tikathali	0.8685123125445595	0	0.28950410418151984	0	-1
848	882	883	Nepal_R3_Kapan_Tikathali	2.6603517071954776	0	0.8867839023984926	0	-1
849	883	884	Nepal_R3_Kapan_Tikathali	0.3931520212676437	0	0.13105067375588123	0	-1
850	884	885	Nepal_R3_Kapan_Tikathali	1.5577493389818544	0	0.5192497796606181	0	-1
851	885	886	Nepal_R3_Kapan_Tikathali	0.8451132960058757	0	0.28170443200195855	0	-1
852	886	887	Nepal_R3_Kapan_Tikathali	0.18869015316944468	0	0.06289671772314823	0	-1
853	887	888	Nepal_R3_Kapan_Tikathali	1.515049732391902	0	0.5050165774639673	0	-1
854	888	889	Nepal_R3_Kapan_Tikathali	1.0497854777898863	0	0.3499284925966287	0	-1
855	889	890	Nepal_R3_Kapan_Tikathali	0.3748735277771351	0	0.12495784259237837	0	-1
856	890	891	Nepal_R3_Kapan_Tikathali	0.8194473813551839	0	0.2731491271183946	0	-1
857	891	892	Nepal_R3_Kapan_Tikathali	0.7678615723970375	0	0.25595385746567917	0	-1
858	892	893	Nepal_R3_Kapan_Tikathali	0.6904809379838658	0	0.23016031266128859	0	-1
859	893	894	Nepal_R3_Kapan_Tikathali	1.270577460627166	0	0.4235258202090553	0	-1
860	895	896	Nepal_R3_Tikathali_Kapan	1.270577460627166	0	0.4235258202090553	0	-1
861	896	897	Nepal_R3_Tikathali_Kapan	0.6904809379838658	0	0.23016031266128859	0	-1
862	897	898	Nepal_R3_Tikathali_Kapan	0.7678615723970375	0	0.25595385746567917	0	-1
863	898	899	Nepal_R3_Tikathali_Kapan	0.8194473813551839	0	0.2731491271183946	0	-1
864	899	900	Nepal_R3_Tikathali_Kapan	0.3748735277771351	0	0.12495784259237837	0	-1
865	900	901	Nepal_R3_Tikathali_Kapan	1.0497854777898863	0	0.3499284925966287	0	-1
866	901	902	Nepal_R3_Tikathali_Kapan	1.515049732391902	0	0.5050165774639673	0	-1
867	902	903	Nepal_R3_Tikathali_Kapan	0.18869015316944468	0	0.06289671772314823	0	-1
868	903	904	Nepal_R3_Tikathali_Kapan	0.8451132960058757	0	0.28170443200195855	0	-1
869	904	905	Nepal_R3_Tikathali_Kapan	2.0624263651942214	0	0.6874754550647405	0	-1
870	905	906	Nepal_R3_Tikathali_Kapan	2.22347034034637	0	0.7411567801154567	0	-1
871	906	907	Nepal_R3_Tikathali_Kapan	1.3433312155257353	0	0.44777707184191173	0	-1
872	907	908	Nepal_R3_Tikathali_Kapan	1.1143774332704695	0	0.3714591444234898	0	-1
873	908	909	Nepal_R3_Tikathali_Kapan	1.118753156251382	0	0.37291771875046065	0	-1
874	909	910	Nepal_R3_Tikathali_Kapan	1.0552177937934542	0	0.351739264597818	0	-1
875	910	911	Nepal_R3_Tikathali_Kapan	0.7980263657355076	0	0.2660087885785025	0	-1
876	911	912	Nepal_R3_Tikathali_Kapan	0.9133820368192938	0	0.3044606789397646	0	-1
877	912	913	Nepal_R3_Tikathali_Kapan	1.814553301399355	0	0.6048511004664516	0	-1
878	913	914	Nepal_R3_Tikathali_Kapan	2.309916548761285	0	0.7699721829204285	0	-1
879	914	915	Nepal_R3_Tikathali_Kapan	0.8526120411907218	0	0.28420401373024057	0	-1
880	915	916	Nepal_R3_Tikathali_Kapan	1.773797099917449	0	0.591265699972483	0	-1
881	916	917	Nepal_R3_Tikathali_Kapan	1.5129253737077828	0	0.5043084579025943	0	-1
882	917	918	Nepal_R3_Tikathali_Kapan	0.3226690059330716	0	0.10755633531102385	0	-1
883	918	919	Nepal_R3_Tikathali_Kapan	0.7872257552478488	0	0.2624085850826163	0	-1
884	919	920	Nepal_R3_Tikathali_Kapan	0.8950403351618259	0	0.2983467783872753	0	-1
885	920	921	Nepal_R3_Tikathali_Kapan	0.8764106197345403	0	0.2921368732448468	0	-1
886	921	922	Nepal_R3_Tikathali_Kapan	1.7099542370051033	0	0.5699847456683678	0	-1
887	922	923	Nepal_R3_Tikathali_Kapan	1.1176065378287006	0	0.3725355126095668	0	-1
888	923	924	Nepal_R3_Tikathali_Kapan	1.2442958614337913	0	0.4147652871445971	0	-1
889	924	925	Nepal_R3_Tikathali_Kapan	0.6042503303614122	0	0.20141677678713737	0	-1
890	925	926	Nepal_R3_Tikathali_Kapan	0.9684214932415179	0	0.3228071644138393	0	-1
891	926	927	Nepal_R3_Tikathali_Kapan	1.7202528367352408	0	0.5734176122450803	0	-1
892	927	928	Nepal_R3_Tikathali_Kapan	0.64592466254204	0	0.21530822084734666	0	-1
893	928	929	Nepal_R3_Tikathali_Kapan	2.1609955772240093	0	0.7203318590746698	0	-1
894	929	930	Nepal_R3_Tikathali_Kapan	1.3520909440999402	0	0.45069698136664677	0	-1
895	930	931	Nepal_R3_Tikathali_Kapan	3.3174188919675207	0	1.105806297322507	0	-1
896	931	932	Nepal_R3_Tikathali_Kapan	1.3958651951168992	0	0.46528839837229974	0	-1
897	932	933	Nepal_R3_Tikathali_Kapan	0.6224625113895998	0	0.2074875037965333	0	-1
898	933	934	Nepal_R3_Tikathali_Kapan	0.9517622656754756	0	0.31725408855849185	0	-1
899	934	935	Nepal_R3_Tikathali_Kapan	2.235575856481688	0	0.7451919521605627	0	-1
900	935	936	Nepal_R3_Tikathali_Kapan	2.1155511121992046	0	0.7051837040664015	0	-1
901	936	937	Nepal_R3_Tikathali_Kapan	0.3419233237555954	0	0.11397444125186514	0	-1
902	937	938	Nepal_R3_Tikathali_Kapan	0.8241666360206242	0	0.27472221200687474	0	-1
903	938	939	Nepal_R3_Tikathali_Kapan	0.5244080530204422	0	0.1748026843401474	0	-1
904	939	940	Nepal_R3_Tikathali_Kapan	0.45095676120355815	0	0.15031892040118605	0	-1
905	940	941	Nepal_R3_Tikathali_Kapan	0.617728862806152	0	0.205909620935384	0	-1
906	941	942	Nepal_R3_Tikathali_Kapan	0.6642877758763193	0	0.22142925862543975	0	-1
907	942	943	Nepal_R3_Tikathali_Kapan	0.7347412793631678	0	0.2449137597877226	0	-1
908	943	944	Nepal_R3_Tikathali_Kapan	0.34472384506667336	0	0.1149079483555578	0	-1
909	944	945	Nepal_R3_Tikathali_Kapan	0.40874809431960757	0	0.1362493647732025	0	-1
910	945	946	Nepal_R3_Tikathali_Kapan	0.6162954241500362	0	0.2054318080500121	0	-1
911	947	948	Mahanagar_R1_Clockwise	0.8086381176025322	0	0.2695460392008441	0	-1
912	948	949	Mahanagar_R1_Clockwise	0.7272817800045253	0	0.24242726000150844	0	-1
913	949	950	Mahanagar_R1_Clockwise	0.6458764968515702	0	0.21529216561719008	0	-1
914	950	951	Mahanagar_R1_Clockwise	1.7009495622702826	0	0.5669831874234276	0	-1
915	951	952	Mahanagar_R1_Clockwise	0.8541993105794696	0	0.2847331035264899	0	-1
916	952	953	Mahanagar_R1_Clockwise	1.9586560065605265	0	0.6528853355201756	0	-1
917	953	954	Mahanagar_R1_Clockwise	2.3020714250241907	0	0.7673571416747302	0	-1
918	954	955	Mahanagar_R1_Clockwise	1.1281756246642458	0	0.3760585415547486	0	-1
919	955	956	Mahanagar_R1_Clockwise	2.176659322298097	0	0.7255531074326991	0	-1
920	956	957	Mahanagar_R1_Clockwise	0.8895095984563332	0	0.2965031994854444	0	-1
921	957	958	Mahanagar_R1_Clockwise	1.3250505978671065	0	0.44168353262236887	0	-1
922	958	959	Mahanagar_R1_Clockwise	1.1982603584453808	0	0.3994201194817936	0	-1
923	959	960	Mahanagar_R1_Clockwise	2.9388703720227825	0	0.9796234573409275	0	-1
924	960	961	Mahanagar_R1_Clockwise	2.188664149069179	0	0.729554716356393	0	-1
925	961	962	Mahanagar_R1_Clockwise	2.242296442868612	0	0.7474321476228707	0	-1
926	962	963	Mahanagar_R1_Clockwise	1.8459989820447158	0	0.6153329940149053	0	-1
927	963	964	Mahanagar_R1_Clockwise	2.825848771415228	0	0.9419495904717425	0	-1
928	964	965	Mahanagar_R1_Clockwise	1.583318410570072	0	0.5277728035233573	0	-1
929	965	966	Mahanagar_R1_Clockwise	1.1721191958984787	0	0.39070639863282625	0	-1
930	966	967	Mahanagar_R1_Clockwise	1.4072191829845333	0	0.4690730609948444	0	-1
931	967	968	Mahanagar_R1_Clockwise	1.0288518975776622	0	0.34295063252588737	0	-1
932	968	969	Mahanagar_R1_Clockwise	2.257232355188933	0	0.7524107850629776	0	-1
933	969	970	Mahanagar_R1_Clockwise	2.678265952251483	0	0.8927553174171611	0	-1
934	970	971	Mahanagar_R1_Clockwise	2.632789063006577	0	0.8775963543355257	0	-1
935	971	972	Mahanagar_R1_Clockwise	1.9521431823395705	0	0.6507143941131901	0	-1
936	972	973	Mahanagar_R1_Clockwise	1.4999174232372166	0	0.4999724744124055	0	-1
937	973	974	Mahanagar_R1_Clockwise	2.7957488391181737	0	0.9319162797060578	0	-1
938	974	975	Mahanagar_R1_Clockwise	1.0883210921535043	0	0.36277369738450144	0	-1
939	975	976	Mahanagar_R1_Clockwise	2.1609955772240093	0	0.7203318590746698	0	-1
940	976	977	Mahanagar_R1_Clockwise	1.3520909440999402	0	0.45069698136664677	0	-1
941	977	978	Mahanagar_R1_Clockwise	3.3174188919675207	0	1.105806297322507	0	-1
942	978	979	Mahanagar_R1_Clockwise	1.546472321885482	0	0.5154907739618273	0	-1
943	979	980	Mahanagar_R1_Clockwise	1.3635934930010865	0	0.4545311643336955	0	-1
944	980	981	Mahanagar_R1_Clockwise	1.0127204997555643	0	0.3375734999185214	0	-1
945	981	982	Mahanagar_R1_Clockwise	0.8892726271462428	0	0.2964242090487476	0	-1
946	982	983	Mahanagar_R1_Clockwise	1.5218035603779854	0	0.5072678534593285	0	-1
947	983	984	Mahanagar_R1_Clockwise	0.6282307605439337	0	0.20941025351464457	0	-1
948	984	985	Mahanagar_R1_Clockwise	2.1407419145804067	0	0.713580638193469	0	-1
949	985	986	Mahanagar_R1_Clockwise	1.8320533809582722	0	0.610684460319424	0	-1
950	986	987	Mahanagar_R1_Clockwise	1.4410413829084208	0	0.4803471276361403	0	-1
951	987	988	Mahanagar_R1_Clockwise	1.8591091313946022	0	0.6197030437982007	0	-1
952	988	989	Mahanagar_R1_Clockwise	2.4309555223763013	0	0.8103185074587671	0	-1
953	989	990	Mahanagar_R1_Clockwise	0.3931520212676437	0	0.13105067375588123	0	-1
954	990	991	Mahanagar_R1_Clockwise	1.5577493389818544	0	0.5192497796606181	0	-1
955	991	992	Mahanagar_R1_Clockwise	0.8451132960058757	0	0.28170443200195855	0	-1
956	992	993	Mahanagar_R1_Clockwise	0.957192253631234	0	0.31906408454374463	0	-1
957	993	994	Mahanagar_R1_Clockwise	0.7864199906766958	0	0.26213999689223194	0	-1
958	994	995	Mahanagar_R1_Clockwise	1.3831071685216432	0	0.4610357228405478	0	-1
959	995	996	Mahanagar_R1_Clockwise	0.7813870103209245	0	0.2604623367736415	0	-1
960	997	998	Mahanagar_R1_Anti-Clockwise	0.7864199906766958	0	0.26213999689223194	0	-1
961	998	999	Mahanagar_R1_Anti-Clockwise	0.957192253631234	0	0.31906408454374463	0	-1
962	999	1000	Mahanagar_R1_Anti-Clockwise	0.8451132960058757	0	0.28170443200195855	0	-1
963	1000	1001	Mahanagar_R1_Anti-Clockwise	2.0624263651942214	0	0.6874754550647405	0	-1
964	1001	1002	Mahanagar_R1_Anti-Clockwise	2.1893706181433172	0	0.7297902060477724	0	-1
965	1002	1003	Mahanagar_R1_Anti-Clockwise	1.9704465316766524	0	0.6568155105588841	0	-1
966	1003	1004	Mahanagar_R1_Anti-Clockwise	1.4410413829084208	0	0.4803471276361403	0	-1
967	1004	1005	Mahanagar_R1_Anti-Clockwise	1.8233813635545788	0	0.6077937878515263	0	-1
968	1005	1006	Mahanagar_R1_Anti-Clockwise	2.14654986498125	0	0.7155166216604167	0	-1
969	1006	1007	Mahanagar_R1_Anti-Clockwise	0.6282307605439337	0	0.20941025351464457	0	-1
970	1007	1008	Mahanagar_R1_Anti-Clockwise	1.5218035603779854	0	0.5072678534593285	0	-1
971	1008	1009	Mahanagar_R1_Anti-Clockwise	0.8892726271462428	0	0.2964242090487476	0	-1
972	1009	1010	Mahanagar_R1_Anti-Clockwise	1.0127204997555643	0	0.3375734999185214	0	-1
973	1010	1011	Mahanagar_R1_Anti-Clockwise	1.3395044076378675	0	0.44650146921262246	0	-1
974	1011	1012	Mahanagar_R1_Anti-Clockwise	1.552861467866603	0	0.5176204892888677	0	-1
975	1012	1013	Mahanagar_R1_Anti-Clockwise	3.3174188919675207	0	1.105806297322507	0	-1
976	1013	1014	Mahanagar_R1_Anti-Clockwise	1.3520909440999402	0	0.45069698136664677	0	-1
977	1014	1015	Mahanagar_R1_Anti-Clockwise	2.1609955772240093	0	0.7203318590746698	0	-1
978	1015	1016	Mahanagar_R1_Anti-Clockwise	1.0883210921535043	0	0.36277369738450144	0	-1
979	1016	1017	Mahanagar_R1_Anti-Clockwise	2.7957488391181737	0	0.9319162797060578	0	-1
980	1017	1018	Mahanagar_R1_Anti-Clockwise	1.4999174232372166	0	0.4999724744124055	0	-1
981	1018	1019	Mahanagar_R1_Anti-Clockwise	1.9521431823395705	0	0.6507143941131901	0	-1
982	1019	1020	Mahanagar_R1_Anti-Clockwise	2.632789063006577	0	0.8775963543355257	0	-1
983	1020	1021	Mahanagar_R1_Anti-Clockwise	2.678265952251483	0	0.8927553174171611	0	-1
984	1021	1022	Mahanagar_R1_Anti-Clockwise	2.257232355188933	0	0.7524107850629776	0	-1
985	1022	1023	Mahanagar_R1_Anti-Clockwise	1.0288518975776622	0	0.34295063252588737	0	-1
986	1023	1024	Mahanagar_R1_Anti-Clockwise	1.4072191829845333	0	0.4690730609948444	0	-1
987	1024	1025	Mahanagar_R1_Anti-Clockwise	1.1721191958984787	0	0.39070639863282625	0	-1
988	1025	1026	Mahanagar_R1_Anti-Clockwise	1.583318410570072	0	0.5277728035233573	0	-1
989	1026	1027	Mahanagar_R1_Anti-Clockwise	2.825848771415228	0	0.9419495904717425	0	-1
990	1027	1028	Mahanagar_R1_Anti-Clockwise	1.8459989820447158	0	0.6153329940149053	0	-1
991	1028	1029	Mahanagar_R1_Anti-Clockwise	2.242296442868612	0	0.7474321476228707	0	-1
992	1029	1030	Mahanagar_R1_Anti-Clockwise	2.188664149069179	0	0.729554716356393	0	-1
993	1030	1031	Mahanagar_R1_Anti-Clockwise	2.9388703720227825	0	0.9796234573409275	0	-1
994	1031	1032	Mahanagar_R1_Anti-Clockwise	1.6117089658079498	0	0.5372363219359833	0	-1
995	1032	1033	Mahanagar_R1_Anti-Clockwise	0.9476527249523403	0	0.3158842416507801	0	-1
996	1033	1034	Mahanagar_R1_Anti-Clockwise	1.072690778733672	0	0.35756359291122397	0	-1
997	1034	1035	Mahanagar_R1_Anti-Clockwise	2.1230979891528485	0	0.7076993297176162	0	-1
998	1035	1036	Mahanagar_R1_Anti-Clockwise	1.2245028119341383	0	0.4081676039780461	0	-1
999	1036	1037	Mahanagar_R1_Anti-Clockwise	2.074147757964719	0	0.6913825859882398	0	-1
1000	1037	1038	Mahanagar_R1_Anti-Clockwise	1.9586560065605265	0	0.6528853355201756	0	-1
1001	1038	1039	Mahanagar_R1_Anti-Clockwise	0.8541993105794696	0	0.2847331035264899	0	-1
1002	1039	1040	Mahanagar_R1_Anti-Clockwise	1.7009495622702826	0	0.5669831874234276	0	-1
1003	1040	1041	Mahanagar_R1_Anti-Clockwise	0.6458764968515702	0	0.21529216561719008	0	-1
1004	1041	1042	Mahanagar_R1_Anti-Clockwise	0.7272817800045253	0	0.24242726000150844	0	-1
1005	1042	1043	Mahanagar_R1_Anti-Clockwise	0.8506949783251555	0	0.2835649927750518	0	-1
1006	1043	1044	Mahanagar_R1_Anti-Clockwise	1.6657614017466142	0	0.5552538005822047	0	-1
1007	1044	1045	Mahanagar_R1_Anti-Clockwise	0.8814549142962684	0	0.2938183047654228	0	-1
1008	1046	1047	Riddhi_Siddhi_R1_Thankot_Mulpani	3.655283891416824	0	1.2184279638056081	0	-1
1009	1047	1048	Riddhi_Siddhi_R1_Thankot_Mulpani	1.2981404039633448	0	0.43271346798778165	0	-1
1010	1048	1049	Riddhi_Siddhi_R1_Thankot_Mulpani	1.6143965728487524	0	0.5381321909495841	0	-1
1011	1049	1050	Riddhi_Siddhi_R1_Thankot_Mulpani	4.416024748384868	0	1.4720082494616227	0	-1
1012	1050	1051	Riddhi_Siddhi_R1_Thankot_Mulpani	2.7172883313046965	0	0.9057627771015656	0	-1
1013	1051	1052	Riddhi_Siddhi_R1_Thankot_Mulpani	2.5948932757639747	0	0.8649644252546581	0	-1
1014	1052	1053	Riddhi_Siddhi_R1_Thankot_Mulpani	1.4608702583475068	0	0.4869567527825023	0	-1
1015	1053	1054	Riddhi_Siddhi_R1_Thankot_Mulpani	1.5374189555920206	0	0.5124729851973402	0	-1
1016	1054	1055	Riddhi_Siddhi_R1_Thankot_Mulpani	2.0042032411672683	0	0.6680677470557561	0	-1
1017	1055	1056	Riddhi_Siddhi_R1_Thankot_Mulpani	1.9797635320407356	0	0.6599211773469118	0	-1
1018	1056	1057	Riddhi_Siddhi_R1_Thankot_Mulpani	0.9707403453781139	0	0.323580115126038	0	-1
1019	1057	1058	Riddhi_Siddhi_R1_Thankot_Mulpani	1.8219036746628254	0	0.6073012248876085	0	-1
1020	1058	1059	Riddhi_Siddhi_R1_Thankot_Mulpani	1.0549719075765507	0	0.35165730252551686	0	-1
1021	1059	1060	Riddhi_Siddhi_R1_Thankot_Mulpani	1.6438071274801913	0	0.5479357091600637	0	-1
1022	1060	1061	Riddhi_Siddhi_R1_Thankot_Mulpani	1.0796869676716054	0	0.3598956558905351	0	-1
1023	1061	1062	Riddhi_Siddhi_R1_Thankot_Mulpani	3.6585681746022263	0	1.2195227248674088	0	-1
1024	1062	1063	Riddhi_Siddhi_R1_Thankot_Mulpani	1.234991560444238	0	0.4116638534814127	0	-1
1025	1063	1064	Riddhi_Siddhi_R1_Thankot_Mulpani	0.9086004713832502	0	0.3028668237944167	0	-1
1026	1064	1065	Riddhi_Siddhi_R1_Thankot_Mulpani	0.9620549520263462	0	0.32068498400878204	0	-1
1027	1065	1066	Riddhi_Siddhi_R1_Thankot_Mulpani	1.1519156005967761	0	0.38397186686559204	0	-1
1028	1066	1067	Riddhi_Siddhi_R1_Thankot_Mulpani	2.1951709515871007	0	0.7317236505290335	0	-1
1029	1067	1068	Riddhi_Siddhi_R1_Thankot_Mulpani	1.1581870501084677	0	0.3860623500361559	0	-1
1030	1068	1069	Riddhi_Siddhi_R1_Thankot_Mulpani	1.2142052580277205	0	0.4047350860092402	0	-1
1031	1069	1070	Riddhi_Siddhi_R1_Thankot_Mulpani	0.8685123125445595	0	0.28950410418151984	0	-1
1032	1070	1071	Riddhi_Siddhi_R1_Thankot_Mulpani	2.6603517071954776	0	0.8867839023984926	0	-1
1033	1071	1072	Riddhi_Siddhi_R1_Thankot_Mulpani	1.2879133653665091	0	0.4293044551221697	0	-1
1034	1072	1073	Riddhi_Siddhi_R1_Thankot_Mulpani	3.4147929366308234	0	1.1382643122102745	0	-1
1035	1073	1074	Riddhi_Siddhi_R1_Thankot_Mulpani	1.7622937851595037	0	0.5874312617198346	0	-1
1036	1074	1075	Riddhi_Siddhi_R1_Thankot_Mulpani	1.2054408140409665	0	0.4018136046803222	0	-1
1037	1075	1076	Riddhi_Siddhi_R1_Thankot_Mulpani	1.4709559452407457	0	0.49031864841358186	0	-1
1038	1076	1077	Riddhi_Siddhi_R1_Thankot_Mulpani	1.0808412412274728	0	0.3602804137424909	0	-1
1039	1077	1078	Riddhi_Siddhi_R1_Thankot_Mulpani	1.7181319561966808	0	0.5727106520655603	0	-1
1040	1078	1079	Riddhi_Siddhi_R1_Thankot_Mulpani	2.979928086550782	0	0.9933093621835939	0	-1
1041	1079	1080	Riddhi_Siddhi_R1_Thankot_Mulpani	0.7518500076955195	0	0.25061666923183984	0	-1
1042	1080	1081	Riddhi_Siddhi_R1_Thankot_Mulpani	1.5184666420340003	0	0.5061555473446667	0	-1
1043	1081	1082	Riddhi_Siddhi_R1_Thankot_Mulpani	1.2113713038639087	0	0.4037904346213029	0	-1
1044	1082	1083	Riddhi_Siddhi_R1_Thankot_Mulpani	2.9259499536421707	0	0.975316651214057	0	-1
1045	1083	1084	Riddhi_Siddhi_R1_Thankot_Mulpani	1.6458079320720675	0	0.5486026440240225	0	-1
1046	1084	1085	Riddhi_Siddhi_R1_Thankot_Mulpani	3.319538699182664	0	1.1065128997275546	0	-1
1047	1085	1086	Riddhi_Siddhi_R1_Thankot_Mulpani	0.8317742826222376	0	0.27725809420741254	0	-1
1048	1087	1088	Riddhi_Siddhi_R1_Mulpani_Thankot	0.8317742826222376	0	0.27725809420741254	0	-1
1049	1088	1089	Riddhi_Siddhi_R1_Mulpani_Thankot	3.319538699182664	0	1.1065128997275546	0	-1
1050	1089	1090	Riddhi_Siddhi_R1_Mulpani_Thankot	1.6458079320720675	0	0.5486026440240225	0	-1
1051	1090	1091	Riddhi_Siddhi_R1_Mulpani_Thankot	2.9259499536421707	0	0.975316651214057	0	-1
1052	1091	1092	Riddhi_Siddhi_R1_Mulpani_Thankot	1.2113713038639087	0	0.4037904346213029	0	-1
1053	1092	1093	Riddhi_Siddhi_R1_Mulpani_Thankot	1.5184666420340003	0	0.5061555473446667	0	-1
1054	1093	1094	Riddhi_Siddhi_R1_Mulpani_Thankot	0.7518500076955195	0	0.25061666923183984	0	-1
1055	1094	1095	Riddhi_Siddhi_R1_Mulpani_Thankot	2.979928086550782	0	0.9933093621835939	0	-1
1056	1095	1096	Riddhi_Siddhi_R1_Mulpani_Thankot	1.7181319561966808	0	0.5727106520655603	0	-1
1057	1096	1097	Riddhi_Siddhi_R1_Mulpani_Thankot	1.0808412412274728	0	0.3602804137424909	0	-1
1058	1097	1098	Riddhi_Siddhi_R1_Mulpani_Thankot	1.4709559452407457	0	0.49031864841358186	0	-1
1059	1098	1099	Riddhi_Siddhi_R1_Mulpani_Thankot	1.1857989072511155	0	0.39526630241703853	0	-1
1060	1099	1100	Riddhi_Siddhi_R1_Mulpani_Thankot	1.7634074192359468	0	0.587802473078649	0	-1
1061	1100	1101	Riddhi_Siddhi_R1_Mulpani_Thankot	2.945876989883069	0	0.9819589966276897	0	-1
1062	1101	1102	Riddhi_Siddhi_R1_Mulpani_Thankot	1.5020494929531132	0	0.5006831643177044	0	-1
1063	1102	1103	Riddhi_Siddhi_R1_Mulpani_Thankot	2.397947089600225	0	0.7993156965334083	0	-1
1064	1103	1104	Riddhi_Siddhi_R1_Mulpani_Thankot	0.8685123125445595	0	0.28950410418151984	0	-1
1065	1104	1105	Riddhi_Siddhi_R1_Mulpani_Thankot	1.3996637665372451	0	0.46655458884574835	0	-1
1066	1105	1106	Riddhi_Siddhi_R1_Mulpani_Thankot	0.9707884579254817	0	0.3235961526418273	0	-1
1067	1106	1107	Riddhi_Siddhi_R1_Mulpani_Thankot	1.1746375725862386	0	0.3915458575287462	0	-1
1068	1107	1108	Riddhi_Siddhi_R1_Mulpani_Thankot	1.096632297132387	0	0.365544099044129	0	-1
1069	1108	1109	Riddhi_Siddhi_R1_Mulpani_Thankot	1.1828635221093418	0	0.3942878407031139	0	-1
1070	1109	1110	Riddhi_Siddhi_R1_Mulpani_Thankot	1.10092119351441	0	0.36697373117147003	0	-1
1071	1110	1111	Riddhi_Siddhi_R1_Mulpani_Thankot	2.0658891096285643	0	0.6886297032095214	0	-1
1072	1111	1112	Riddhi_Siddhi_R1_Mulpani_Thankot	0.9514595405290251	0	0.3171531801763417	0	-1
1073	1112	1113	Riddhi_Siddhi_R1_Mulpani_Thankot	2.1485344139653257	0	0.7161781379884419	0	-1
1074	1113	1114	Riddhi_Siddhi_R1_Mulpani_Thankot	2.5916809701827064	0	0.8638936567275688	0	-1
1075	1114	1115	Riddhi_Siddhi_R1_Mulpani_Thankot	1.54890296816104	0	0.5163009893870133	0	-1
1076	1115	1116	Riddhi_Siddhi_R1_Mulpani_Thankot	2.1853155707872576	0	0.7284385235957526	0	-1
1077	1116	1117	Riddhi_Siddhi_R1_Mulpani_Thankot	1.0549719075765507	0	0.35165730252551686	0	-1
1078	1117	1118	Riddhi_Siddhi_R1_Mulpani_Thankot	1.8219036746628254	0	0.6073012248876085	0	-1
1079	1118	1119	Riddhi_Siddhi_R1_Mulpani_Thankot	0.9707403453781139	0	0.323580115126038	0	-1
1080	1119	1120	Riddhi_Siddhi_R1_Mulpani_Thankot	1.9797635320407356	0	0.6599211773469118	0	-1
1081	1120	1121	Riddhi_Siddhi_R1_Mulpani_Thankot	2.0042032411672683	0	0.6680677470557561	0	-1
1082	1121	1122	Riddhi_Siddhi_R1_Mulpani_Thankot	1.5374189555920206	0	0.5124729851973402	0	-1
1083	1122	1123	Riddhi_Siddhi_R1_Mulpani_Thankot	1.4608702583475068	0	0.4869567527825023	0	-1
1084	1123	1124	Riddhi_Siddhi_R1_Mulpani_Thankot	2.5948932757639747	0	0.8649644252546581	0	-1
1085	1124	1125	Riddhi_Siddhi_R1_Mulpani_Thankot	2.7172883313046965	0	0.9057627771015656	0	-1
1086	1125	1126	Riddhi_Siddhi_R1_Mulpani_Thankot	4.416024748384868	0	1.4720082494616227	0	-1
1087	1126	1127	Riddhi_Siddhi_R1_Mulpani_Thankot	1.6143965728487524	0	0.5381321909495841	0	-1
1088	1127	1128	Riddhi_Siddhi_R1_Mulpani_Thankot	1.2981404039633448	0	0.43271346798778165	0	-1
1089	1128	1129	Riddhi_Siddhi_R1_Mulpani_Thankot	3.655283891416824	0	1.2184279638056081	0	-1
1090	1130	1131	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.8970059458867343	0	0.6323353152955781	0	-1
1091	1131	1132	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.452119100004997	0	0.48403970000166574	0	-1
1092	1132	1133	Riddhi_Siddhi_R2_RNAC_Harisiddhi	2.1125904390702797	0	0.7041968130234266	0	-1
1093	1133	1134	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.5141356220617795	0	0.17137854068725983	0	-1
1094	1134	1135	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.9644961016231957	0	0.3214987005410652	0	-1
1095	1135	1136	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.9620549520263462	0	0.32068498400878204	0	-1
1096	1136	1137	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.1519156005967761	0	0.38397186686559204	0	-1
1097	1137	1138	Riddhi_Siddhi_R2_RNAC_Harisiddhi	2.1951709515871007	0	0.7317236505290335	0	-1
1098	1138	1139	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.1581870501084677	0	0.3860623500361559	0	-1
1099	1139	1140	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.2142052580277205	0	0.4047350860092402	0	-1
1100	1140	1141	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.8685123125445595	0	0.28950410418151984	0	-1
1101	1141	1142	Riddhi_Siddhi_R2_RNAC_Harisiddhi	2.6603517071954776	0	0.8867839023984926	0	-1
1102	1142	1143	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.3931520212676437	0	0.13105067375588123	0	-1
1103	1143	1144	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.5577493389818544	0	0.5192497796606181	0	-1
1104	1144	1145	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.8451132960058757	0	0.28170443200195855	0	-1
1105	1145	1146	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.957192253631234	0	0.31906408454374463	0	-1
1106	1146	1147	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.7864199906766958	0	0.26213999689223194	0	-1
1107	1147	1148	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.3831071685216432	0	0.4610357228405478	0	-1
1108	1148	1149	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.7813870103209245	0	0.2604623367736415	0	-1
1109	1149	1150	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.07688797318646517	0	0.02562932439548839	0	-1
1110	1150	1151	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.8892353063799123	0	0.2964117687933041	0	-1
1111	1151	1152	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.5341022541468088	0	0.5113674180489363	0	-1
1112	1152	1153	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.29471057882795904	0	0.09823685960931969	0	-1
1113	1153	1154	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.7234464230500146	0	0.2411488076833382	0	-1
1114	1154	1155	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.9218860342688245	0	0.30729534475627485	0	-1
1115	1155	1156	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.2092274652511998	0	0.40307582175039997	0	-1
1116	1156	1157	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.3850802155887433	0	0.12836007186291443	0	-1
1117	1157	1158	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.6271019376065164	0	0.20903397920217215	0	-1
1118	1158	1159	Riddhi_Siddhi_R2_RNAC_Harisiddhi	2.2365028974534247	0	0.7455009658178083	0	-1
1119	1159	1160	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.8492935485843652	0	0.2830978495281217	0	-1
1120	1160	1161	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.4163766249238514	0	0.47212554164128384	0	-1
1121	1161	1162	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.7061148459719703	0	0.23537161532399006	0	-1
1122	1162	1163	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.4913113654357433	0	0.4971037884785811	0	-1
1123	1163	1164	Riddhi_Siddhi_R2_RNAC_Harisiddhi	1.3974256028501637	0	0.4658085342833879	0	-1
1124	1164	1165	Riddhi_Siddhi_R2_RNAC_Harisiddhi	0.9552584476223211	0	0.31841948254077374	0	-1
1125	1166	1167	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.9552584476223211	0	0.31841948254077374	0	-1
1126	1167	1168	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.3974256028501637	0	0.4658085342833879	0	-1
1127	1168	1169	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.4913113654357433	0	0.4971037884785811	0	-1
1128	1169	1170	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.7061148459719703	0	0.23537161532399006	0	-1
1129	1170	1171	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.4163766249238514	0	0.47212554164128384	0	-1
1130	1171	1172	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.8492935485843652	0	0.2830978495281217	0	-1
1131	1172	1173	Riddhi_Siddhi_R2_Harisiddhi_RNAC	2.2365028974534247	0	0.7455009658178083	0	-1
1132	1173	1174	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.6271019376065164	0	0.20903397920217215	0	-1
1133	1174	1175	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.3850802155887433	0	0.12836007186291443	0	-1
1134	1175	1176	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.2092274652511998	0	0.40307582175039997	0	-1
1135	1176	1177	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.9218860342688245	0	0.30729534475627485	0	-1
1136	1177	1178	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.7234464230500146	0	0.2411488076833382	0	-1
1137	1178	1179	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.29471057882795904	0	0.09823685960931969	0	-1
1138	1179	1180	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.5341022541468088	0	0.5113674180489363	0	-1
1139	1180	1181	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.8892353063799123	0	0.2964117687933041	0	-1
1140	1181	1182	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.07688797318646517	0	0.02562932439548839	0	-1
1141	1182	1183	Riddhi_Siddhi_R2_Harisiddhi_RNAC	2.158881509602132	0	0.7196271698673773	0	-1
1142	1183	1184	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.7864199906766958	0	0.26213999689223194	0	-1
1143	1184	1185	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.957192253631234	0	0.31906408454374463	0	-1
1144	1185	1186	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.8451132960058757	0	0.28170443200195855	0	-1
1145	1186	1187	Riddhi_Siddhi_R2_Harisiddhi_RNAC	2.0624263651942214	0	0.6874754550647405	0	-1
1146	1187	1188	Riddhi_Siddhi_R2_Harisiddhi_RNAC	2.397947089600225	0	0.7993156965334083	0	-1
1147	1188	1189	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.8685123125445595	0	0.28950410418151984	0	-1
1148	1189	1190	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.3996637665372451	0	0.46655458884574835	0	-1
1149	1190	1191	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.9707884579254817	0	0.3235961526418273	0	-1
1150	1191	1192	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.1746375725862386	0	0.3915458575287462	0	-1
1151	1192	1193	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.096632297132387	0	0.365544099044129	0	-1
1152	1193	1194	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.1828635221093418	0	0.3942878407031139	0	-1
1153	1194	1195	Riddhi_Siddhi_R2_Harisiddhi_RNAC	1.10092119351441	0	0.36697373117147003	0	-1
1154	1195	1196	Riddhi_Siddhi_R2_Harisiddhi_RNAC	2.0658891096285643	0	0.6886297032095214	0	-1
1155	1196	1197	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.9514595405290251	0	0.3171531801763417	0	-1
1156	1197	1198	Riddhi_Siddhi_R2_Harisiddhi_RNAC	0.502053620515694	0	0.16735120683856466	0	-1
1157	1199	1200	Bhaktapur_R1_Bhaktapur_Kalanki	1.3143793250084619	0	0.4381264416694873	0	-1
1158	1200	1201	Bhaktapur_R1_Bhaktapur_Kalanki	2.37822055761781	0	0.7927401858726032	0	-1
1159	1201	1202	Bhaktapur_R1_Bhaktapur_Kalanki	2.727673346579407	0	0.9092244488598024	0	-1
1160	1202	1203	Bhaktapur_R1_Bhaktapur_Kalanki	3.085542051802588	0	1.0285140172675293	0	-1
1161	1203	1204	Bhaktapur_R1_Bhaktapur_Kalanki	2.78242164412552	0	0.9274738813751733	0	-1
1162	1204	1205	Bhaktapur_R1_Bhaktapur_Kalanki	3.491038750644507	0	1.163679583548169	0	-1
1163	1205	1206	Bhaktapur_R1_Bhaktapur_Kalanki	3.3362149584554146	0	1.1120716528184715	0	-1
1164	1206	1207	Bhaktapur_R1_Bhaktapur_Kalanki	1.391472765793549	0	0.46382425526451637	0	-1
1165	1207	1208	Bhaktapur_R1_Bhaktapur_Kalanki	0.7899783907140547	0	0.26332613023801826	0	-1
1166	1208	1209	Bhaktapur_R1_Bhaktapur_Kalanki	1.9781053946845317	0	0.6593684648948439	0	-1
1167	1209	1210	Bhaktapur_R1_Bhaktapur_Kalanki	2.3869492860391293	0	0.795649762013043	0	-1
1168	1210	1211	Bhaktapur_R1_Bhaktapur_Kalanki	1.2903259425495543	0	0.4301086475165181	0	-1
1169	1211	1212	Bhaktapur_R1_Bhaktapur_Kalanki	1.7097984969239512	0	0.5699328323079837	0	-1
1170	1212	1213	Bhaktapur_R1_Bhaktapur_Kalanki	1.8862612622687076	0	0.6287537540895692	0	-1
1171	1213	1214	Bhaktapur_R1_Bhaktapur_Kalanki	1.5577493389818544	0	0.5192497796606181	0	-1
1172	1214	1215	Bhaktapur_R1_Bhaktapur_Kalanki	0.8451132960058757	0	0.28170443200195855	0	-1
1173	1215	1216	Bhaktapur_R1_Bhaktapur_Kalanki	0.957192253631234	0	0.31906408454374463	0	-1
1174	1216	1217	Bhaktapur_R1_Bhaktapur_Kalanki	0.7864199906766958	0	0.26213999689223194	0	-1
1175	1217	1218	Bhaktapur_R1_Bhaktapur_Kalanki	1.3831071685216432	0	0.4610357228405478	0	-1
1176	1218	1219	Bhaktapur_R1_Bhaktapur_Kalanki	0.7813870103209245	0	0.2604623367736415	0	-1
1177	1219	1220	Bhaktapur_R1_Bhaktapur_Kalanki	2.6238952863506295	0	0.8746317621168764	0	-1
1178	1220	1221	Bhaktapur_R1_Bhaktapur_Kalanki	0.8086381176025322	0	0.2695460392008441	0	-1
1179	1221	1222	Bhaktapur_R1_Bhaktapur_Kalanki	0.7272817800045253	0	0.24242726000150844	0	-1
1180	1222	1223	Bhaktapur_R1_Bhaktapur_Kalanki	0.6458764968515702	0	0.21529216561719008	0	-1
1181	1223	1224	Bhaktapur_R1_Bhaktapur_Kalanki	1.7009495622702826	0	0.5669831874234276	0	-1
1182	1224	1225	Bhaktapur_R1_Bhaktapur_Kalanki	0.8541993105794696	0	0.2847331035264899	0	-1
1183	1225	1226	Bhaktapur_R1_Bhaktapur_Kalanki	1.9586560065605265	0	0.6528853355201756	0	-1
1184	1226	1227	Bhaktapur_R1_Bhaktapur_Kalanki	2.3020714250241907	0	0.7673571416747302	0	-1
1185	1227	1228	Bhaktapur_R1_Bhaktapur_Kalanki	1.1281756246642458	0	0.3760585415547486	0	-1
1186	1228	1229	Bhaktapur_R1_Bhaktapur_Kalanki	2.176659322298097	0	0.7255531074326991	0	-1
1187	1229	1230	Bhaktapur_R1_Bhaktapur_Kalanki	0.8895095984563332	0	0.2965031994854444	0	-1
1188	1230	1231	Bhaktapur_R1_Bhaktapur_Kalanki	1.3250505978671065	0	0.44168353262236887	0	-1
1189	1231	1232	Bhaktapur_R1_Bhaktapur_Kalanki	1.1982603584453808	0	0.3994201194817936	0	-1
1190	1232	1233	Bhaktapur_R1_Bhaktapur_Kalanki	2.9388703720227825	0	0.9796234573409275	0	-1
1191	1233	1234	Bhaktapur_R1_Bhaktapur_Kalanki	2.188664149069179	0	0.729554716356393	0	-1
1192	1235	1236	Bhaktapur_R1_Kalanki_Bhaktapur	2.188664149069179	0	0.729554716356393	0	-1
1193	1236	1237	Bhaktapur_R1_Kalanki_Bhaktapur	2.9388703720227825	0	0.9796234573409275	0	-1
1194	1237	1238	Bhaktapur_R1_Kalanki_Bhaktapur	1.6117089658079498	0	0.5372363219359833	0	-1
1195	1238	1239	Bhaktapur_R1_Kalanki_Bhaktapur	0.9476527249523403	0	0.3158842416507801	0	-1
1196	1239	1240	Bhaktapur_R1_Kalanki_Bhaktapur	1.072690778733672	0	0.35756359291122397	0	-1
1197	1240	1241	Bhaktapur_R1_Kalanki_Bhaktapur	2.1230979891528485	0	0.7076993297176162	0	-1
1198	1241	1242	Bhaktapur_R1_Kalanki_Bhaktapur	1.2245028119341383	0	0.4081676039780461	0	-1
1199	1242	1243	Bhaktapur_R1_Kalanki_Bhaktapur	2.074147757964719	0	0.6913825859882398	0	-1
1200	1243	1244	Bhaktapur_R1_Kalanki_Bhaktapur	1.9586560065605265	0	0.6528853355201756	0	-1
1201	1244	1245	Bhaktapur_R1_Kalanki_Bhaktapur	0.8541993105794696	0	0.2847331035264899	0	-1
1202	1245	1246	Bhaktapur_R1_Kalanki_Bhaktapur	1.7009495622702826	0	0.5669831874234276	0	-1
1203	1246	1247	Bhaktapur_R1_Kalanki_Bhaktapur	0.6458764968515702	0	0.21529216561719008	0	-1
1204	1247	1248	Bhaktapur_R1_Kalanki_Bhaktapur	0.7272817800045253	0	0.24242726000150844	0	-1
1205	1248	1249	Bhaktapur_R1_Kalanki_Bhaktapur	0.8506949783251555	0	0.2835649927750518	0	-1
1206	1249	1250	Bhaktapur_R1_Kalanki_Bhaktapur	1.6657614017466142	0	0.5552538005822047	0	-1
1207	1250	1251	Bhaktapur_R1_Kalanki_Bhaktapur	0.8814549142962684	0	0.2938183047654228	0	-1
1208	1251	1252	Bhaktapur_R1_Kalanki_Bhaktapur	2.169957163335033	0	0.7233190544450111	0	-1
1209	1252	1253	Bhaktapur_R1_Kalanki_Bhaktapur	0.7864199906766958	0	0.26213999689223194	0	-1
1210	1253	1254	Bhaktapur_R1_Kalanki_Bhaktapur	0.957192253631234	0	0.31906408454374463	0	-1
1211	1254	1255	Bhaktapur_R1_Kalanki_Bhaktapur	0.8451132960058757	0	0.28170443200195855	0	-1
1212	1255	1256	Bhaktapur_R1_Kalanki_Bhaktapur	1.9461065992935331	0	0.648702199764511	0	-1
1213	1256	1257	Bhaktapur_R1_Kalanki_Bhaktapur	1.2879133653665091	0	0.4293044551221697	0	-1
1214	1257	1258	Bhaktapur_R1_Kalanki_Bhaktapur	2.472757918686367	0	0.8242526395621224	0	-1
1215	1258	1259	Bhaktapur_R1_Kalanki_Bhaktapur	1.3275256384829246	0	0.44250854616097485	0	-1
1216	1259	1260	Bhaktapur_R1_Kalanki_Bhaktapur	2.3897925281700867	0	0.7965975093900289	0	-1
1217	1260	1261	Bhaktapur_R1_Kalanki_Bhaktapur	1.9781053946845317	0	0.6593684648948439	0	-1
1218	1261	1262	Bhaktapur_R1_Kalanki_Bhaktapur	0.7899783907140547	0	0.26332613023801826	0	-1
1219	1262	1263	Bhaktapur_R1_Kalanki_Bhaktapur	1.391472765793549	0	0.46382425526451637	0	-1
1220	1263	1264	Bhaktapur_R1_Kalanki_Bhaktapur	3.3362149584554146	0	1.1120716528184715	0	-1
1221	1264	1265	Bhaktapur_R1_Kalanki_Bhaktapur	3.491038750644507	0	1.163679583548169	0	-1
1222	1265	1266	Bhaktapur_R1_Kalanki_Bhaktapur	2.78242164412552	0	0.9274738813751733	0	-1
1223	1266	1267	Bhaktapur_R1_Kalanki_Bhaktapur	3.085542051802588	0	1.0285140172675293	0	-1
1224	1267	1268	Bhaktapur_R1_Kalanki_Bhaktapur	2.727673346579407	0	0.9092244488598024	0	-1
1225	1268	1269	Bhaktapur_R1_Kalanki_Bhaktapur	2.37822055761781	0	0.7927401858726032	0	-1
1226	1269	1270	Bhaktapur_R1_Kalanki_Bhaktapur	1.3143793250084619	0	0.4381264416694873	0	-1
1227	1271	1272	Bhaktapur_R2_Bhaktapur_Lagankhel	1.3143793250084619	0	0.4381264416694873	0	-1
1228	1272	1273	Bhaktapur_R2_Bhaktapur_Lagankhel	2.37822055761781	0	0.7927401858726032	0	-1
1229	1273	1274	Bhaktapur_R2_Bhaktapur_Lagankhel	2.727673346579407	0	0.9092244488598024	0	-1
1230	1274	1275	Bhaktapur_R2_Bhaktapur_Lagankhel	3.085542051802588	0	1.0285140172675293	0	-1
1231	1275	1276	Bhaktapur_R2_Bhaktapur_Lagankhel	2.78242164412552	0	0.9274738813751733	0	-1
1232	1276	1277	Bhaktapur_R2_Bhaktapur_Lagankhel	3.491038750644507	0	1.163679583548169	0	-1
1233	1277	1278	Bhaktapur_R2_Bhaktapur_Lagankhel	3.3362149584554146	0	1.1120716528184715	0	-1
1234	1278	1279	Bhaktapur_R2_Bhaktapur_Lagankhel	1.391472765793549	0	0.46382425526451637	0	-1
1235	1279	1280	Bhaktapur_R2_Bhaktapur_Lagankhel	0.7899783907140547	0	0.26332613023801826	0	-1
1236	1280	1281	Bhaktapur_R2_Bhaktapur_Lagankhel	1.9781053946845317	0	0.6593684648948439	0	-1
1237	1281	1282	Bhaktapur_R2_Bhaktapur_Lagankhel	2.3869492860391293	0	0.795649762013043	0	-1
1238	1282	1283	Bhaktapur_R2_Bhaktapur_Lagankhel	1.2903259425495543	0	0.4301086475165181	0	-1
1239	1283	1284	Bhaktapur_R2_Bhaktapur_Lagankhel	1.7097984969239512	0	0.5699328323079837	0	-1
1240	1284	1285	Bhaktapur_R2_Bhaktapur_Lagankhel	1.8862612622687076	0	0.6287537540895692	0	-1
1241	1285	1286	Bhaktapur_R2_Bhaktapur_Lagankhel	1.5577493389818544	0	0.5192497796606181	0	-1
1242	1286	1287	Bhaktapur_R2_Bhaktapur_Lagankhel	0.8451132960058757	0	0.28170443200195855	0	-1
1243	1287	1288	Bhaktapur_R2_Bhaktapur_Lagankhel	0.957192253631234	0	0.31906408454374463	0	-1
1244	1288	1289	Bhaktapur_R2_Bhaktapur_Lagankhel	0.7864199906766958	0	0.26213999689223194	0	-1
1245	1289	1290	Bhaktapur_R2_Bhaktapur_Lagankhel	1.3831071685216432	0	0.4610357228405478	0	-1
1246	1290	1291	Bhaktapur_R2_Bhaktapur_Lagankhel	0.7813870103209245	0	0.2604623367736415	0	-1
1247	1291	1292	Bhaktapur_R2_Bhaktapur_Lagankhel	2.6238952863506295	0	0.8746317621168764	0	-1
1248	1292	1293	Bhaktapur_R2_Bhaktapur_Lagankhel	0.8086381176025322	0	0.2695460392008441	0	-1
1249	1293	1294	Bhaktapur_R2_Bhaktapur_Lagankhel	2.7719284991200768	0	0.9239761663733589	0	-1
1250	1295	1296	Bhaktapur_R2_Lagankhel_Bhaktapur	2.7719284991200768	0	0.9239761663733589	0	-1
1251	1296	1297	Bhaktapur_R2_Lagankhel_Bhaktapur	0.8506949783251555	0	0.2835649927750518	0	-1
1252	1297	1298	Bhaktapur_R2_Lagankhel_Bhaktapur	1.6657614017466142	0	0.5552538005822047	0	-1
1253	1298	1299	Bhaktapur_R2_Lagankhel_Bhaktapur	0.8814549142962684	0	0.2938183047654228	0	-1
1254	1299	1300	Bhaktapur_R2_Lagankhel_Bhaktapur	2.169957163335033	0	0.7233190544450111	0	-1
1255	1300	1301	Bhaktapur_R2_Lagankhel_Bhaktapur	0.7864199906766958	0	0.26213999689223194	0	-1
1256	1301	1302	Bhaktapur_R2_Lagankhel_Bhaktapur	0.957192253631234	0	0.31906408454374463	0	-1
1257	1302	1303	Bhaktapur_R2_Lagankhel_Bhaktapur	0.8451132960058757	0	0.28170443200195855	0	-1
1258	1303	1304	Bhaktapur_R2_Lagankhel_Bhaktapur	1.9461065992935331	0	0.648702199764511	0	-1
1259	1304	1305	Bhaktapur_R2_Lagankhel_Bhaktapur	1.2879133653665091	0	0.4293044551221697	0	-1
1260	1305	1306	Bhaktapur_R2_Lagankhel_Bhaktapur	2.472757918686367	0	0.8242526395621224	0	-1
1261	1306	1307	Bhaktapur_R2_Lagankhel_Bhaktapur	1.3275256384829246	0	0.44250854616097485	0	-1
1262	1307	1308	Bhaktapur_R2_Lagankhel_Bhaktapur	2.3897925281700867	0	0.7965975093900289	0	-1
1263	1308	1309	Bhaktapur_R2_Lagankhel_Bhaktapur	1.9781053946845317	0	0.6593684648948439	0	-1
1264	1309	1310	Bhaktapur_R2_Lagankhel_Bhaktapur	0.7899783907140547	0	0.26332613023801826	0	-1
1265	1310	1311	Bhaktapur_R2_Lagankhel_Bhaktapur	1.391472765793549	0	0.46382425526451637	0	-1
1266	1311	1312	Bhaktapur_R2_Lagankhel_Bhaktapur	3.3362149584554146	0	1.1120716528184715	0	-1
1267	1312	1313	Bhaktapur_R2_Lagankhel_Bhaktapur	3.491038750644507	0	1.163679583548169	0	-1
1268	1313	1314	Bhaktapur_R2_Lagankhel_Bhaktapur	2.78242164412552	0	0.9274738813751733	0	-1
1269	1314	1315	Bhaktapur_R2_Lagankhel_Bhaktapur	3.085542051802588	0	1.0285140172675293	0	-1
1270	1315	1316	Bhaktapur_R2_Lagankhel_Bhaktapur	2.727673346579407	0	0.9092244488598024	0	-1
1271	1316	1317	Bhaktapur_R2_Lagankhel_Bhaktapur	2.37822055761781	0	0.7927401858726032	0	-1
1272	1317	1318	Bhaktapur_R2_Lagankhel_Bhaktapur	1.3143793250084619	0	0.4381264416694873	0	-1
1273	1319	1320	Bhaktapur_R3_Bhaktapur_RNAC	1.3143793250084619	0	0.4381264416694873	0	-1
1274	1320	1321	Bhaktapur_R3_Bhaktapur_RNAC	2.37822055761781	0	0.7927401858726032	0	-1
1275	1321	1322	Bhaktapur_R3_Bhaktapur_RNAC	2.727673346579407	0	0.9092244488598024	0	-1
1276	1322	1323	Bhaktapur_R3_Bhaktapur_RNAC	3.085542051802588	0	1.0285140172675293	0	-1
1277	1323	1324	Bhaktapur_R3_Bhaktapur_RNAC	2.78242164412552	0	0.9274738813751733	0	-1
1278	1324	1325	Bhaktapur_R3_Bhaktapur_RNAC	3.491038750644507	0	1.163679583548169	0	-1
1279	1325	1326	Bhaktapur_R3_Bhaktapur_RNAC	3.3362149584554146	0	1.1120716528184715	0	-1
1280	1326	1327	Bhaktapur_R3_Bhaktapur_RNAC	1.391472765793549	0	0.46382425526451637	0	-1
1281	1327	1328	Bhaktapur_R3_Bhaktapur_RNAC	0.7899783907140547	0	0.26332613023801826	0	-1
1282	1328	1329	Bhaktapur_R3_Bhaktapur_RNAC	1.9781053946845317	0	0.6593684648948439	0	-1
1283	1329	1330	Bhaktapur_R3_Bhaktapur_RNAC	2.3869492860391293	0	0.795649762013043	0	-1
1284	1330	1331	Bhaktapur_R3_Bhaktapur_RNAC	1.2903259425495543	0	0.4301086475165181	0	-1
1285	1331	1332	Bhaktapur_R3_Bhaktapur_RNAC	1.7097984969239512	0	0.5699328323079837	0	-1
1286	1332	1333	Bhaktapur_R3_Bhaktapur_RNAC	2.099816234009818	0	0.6999387446699392	0	-1
1287	1333	1334	Bhaktapur_R3_Bhaktapur_RNAC	2.397947089600225	0	0.7993156965334083	0	-1
1288	1334	1335	Bhaktapur_R3_Bhaktapur_RNAC	0.8685123125445595	0	0.28950410418151984	0	-1
1289	1335	1336	Bhaktapur_R3_Bhaktapur_RNAC	1.3996637665372451	0	0.46655458884574835	0	-1
1290	1336	1337	Bhaktapur_R3_Bhaktapur_RNAC	0.9707884579254817	0	0.3235961526418273	0	-1
1291	1337	1338	Bhaktapur_R3_Bhaktapur_RNAC	1.1746375725862386	0	0.3915458575287462	0	-1
1292	1338	1339	Bhaktapur_R3_Bhaktapur_RNAC	1.096632297132387	0	0.365544099044129	0	-1
1293	1339	1340	Bhaktapur_R3_Bhaktapur_RNAC	1.1828635221093418	0	0.3942878407031139	0	-1
1294	1340	1341	Bhaktapur_R3_Bhaktapur_RNAC	1.10092119351441	0	0.36697373117147003	0	-1
1295	1341	1342	Bhaktapur_R3_Bhaktapur_RNAC	2.0658891096285643	0	0.6886297032095214	0	-1
1296	1342	1343	Bhaktapur_R3_Bhaktapur_RNAC	0.9514595405290251	0	0.3171531801763417	0	-1
1297	1343	1344	Bhaktapur_R3_Bhaktapur_RNAC	0.502053620515694	0	0.16735120683856466	0	-1
1298	1345	1346	Bhaktapur_R3_RNAC_Bhaktapur	1.8970059458867343	0	0.6323353152955781	0	-1
1299	1346	1347	Bhaktapur_R3_RNAC_Bhaktapur	1.452119100004997	0	0.48403970000166574	0	-1
1300	1347	1348	Bhaktapur_R3_RNAC_Bhaktapur	2.1125904390702797	0	0.7041968130234266	0	-1
1301	1348	1349	Bhaktapur_R3_RNAC_Bhaktapur	0.5141356220617795	0	0.17137854068725983	0	-1
1302	1349	1350	Bhaktapur_R3_RNAC_Bhaktapur	0.9644961016231957	0	0.3214987005410652	0	-1
1303	1350	1351	Bhaktapur_R3_RNAC_Bhaktapur	0.9620549520263462	0	0.32068498400878204	0	-1
1304	1351	1352	Bhaktapur_R3_RNAC_Bhaktapur	1.1519156005967761	0	0.38397186686559204	0	-1
1305	1352	1353	Bhaktapur_R3_RNAC_Bhaktapur	2.1951709515871007	0	0.7317236505290335	0	-1
1306	1353	1354	Bhaktapur_R3_RNAC_Bhaktapur	1.1581870501084677	0	0.3860623500361559	0	-1
1307	1354	1355	Bhaktapur_R3_RNAC_Bhaktapur	1.2142052580277205	0	0.4047350860092402	0	-1
1308	1355	1356	Bhaktapur_R3_RNAC_Bhaktapur	0.8685123125445595	0	0.28950410418151984	0	-1
1309	1356	1357	Bhaktapur_R3_RNAC_Bhaktapur	2.6603517071954776	0	0.8867839023984926	0	-1
1310	1357	1358	Bhaktapur_R3_RNAC_Bhaktapur	1.2879133653665091	0	0.4293044551221697	0	-1
1311	1358	1359	Bhaktapur_R3_RNAC_Bhaktapur	2.472757918686367	0	0.8242526395621224	0	-1
1312	1359	1360	Bhaktapur_R3_RNAC_Bhaktapur	1.3275256384829246	0	0.44250854616097485	0	-1
1313	1360	1361	Bhaktapur_R3_RNAC_Bhaktapur	2.3897925281700867	0	0.7965975093900289	0	-1
1314	1361	1362	Bhaktapur_R3_RNAC_Bhaktapur	1.9781053946845317	0	0.6593684648948439	0	-1
1315	1362	1363	Bhaktapur_R3_RNAC_Bhaktapur	0.7899783907140547	0	0.26332613023801826	0	-1
1316	1363	1364	Bhaktapur_R3_RNAC_Bhaktapur	1.391472765793549	0	0.46382425526451637	0	-1
1317	1364	1365	Bhaktapur_R3_RNAC_Bhaktapur	3.3362149584554146	0	1.1120716528184715	0	-1
1318	1365	1366	Bhaktapur_R3_RNAC_Bhaktapur	3.491038750644507	0	1.163679583548169	0	-1
1319	1366	1367	Bhaktapur_R3_RNAC_Bhaktapur	2.78242164412552	0	0.9274738813751733	0	-1
1320	1367	1368	Bhaktapur_R3_RNAC_Bhaktapur	3.085542051802588	0	1.0285140172675293	0	-1
1321	1368	1369	Bhaktapur_R3_RNAC_Bhaktapur	2.727673346579407	0	0.9092244488598024	0	-1
1322	1369	1370	Bhaktapur_R3_RNAC_Bhaktapur	2.37822055761781	0	0.7927401858726032	0	-1
1323	1370	1371	Bhaktapur_R3_RNAC_Bhaktapur	1.3143793250084619	0	0.4381264416694873	0	-1
1324	1372	1373	Micro_R1_RNAC_Kritipur	1.8970059458867343	0	0.6323353152955781	0	-1
1325	1373	1374	Micro_R1_RNAC_Kritipur	1.452119100004997	0	0.48403970000166574	0	-1
1326	1374	1375	Micro_R1_RNAC_Kritipur	1.207244747740107	0	0.40241491591336903	0	-1
1327	1375	1376	Micro_R1_RNAC_Kritipur	2.1485344139653257	0	0.7161781379884419	0	-1
1328	1376	1377	Micro_R1_RNAC_Kritipur	2.5916809701827064	0	0.8638936567275688	0	-1
1329	1377	1378	Micro_R1_RNAC_Kritipur	1.54890296816104	0	0.5163009893870133	0	-1
1330	1378	1379	Micro_R1_RNAC_Kritipur	1.205079938147499	0	0.40169331271583303	0	-1
1331	1379	1380	Micro_R1_RNAC_Kritipur	1.392180137065417	0	0.4640600456884723	0	-1
1332	1380	1381	Micro_R1_RNAC_Kritipur	1.1193536879335355	0	0.37311789597784517	0	-1
1333	1381	1382	Micro_R1_RNAC_Kritipur	1.09211416934293	0	0.3640380564476433	0	-1
1334	1382	1383	Micro_R1_RNAC_Kritipur	0.40795968251405035	0	0.13598656083801677	0	-1
1335	1383	1384	Micro_R1_RNAC_Kritipur	0.6755429391720794	0	0.22518097972402648	0	-1
1336	1384	1385	Micro_R1_RNAC_Kritipur	1.3439206120346319	0	0.44797353734487727	0	-1
1337	1385	1386	Micro_R1_RNAC_Kritipur	2.188484509158932	0	0.7294948363863106	0	-1
1338	1386	1387	Micro_R1_RNAC_Kritipur	1.440803236900419	0	0.4802677456334729	0	-1
1339	1387	1388	Micro_R1_RNAC_Kritipur	1.0065443139698622	0	0.33551477132328744	0	-1
1340	1389	1390	Micro_R1_Kritipur_RNAC	1.0065443139698622	0	0.33551477132328744	0	-1
1341	1390	1391	Micro_R1_Kritipur_RNAC	1.440803236900419	0	0.4802677456334729	0	-1
1342	1391	1392	Micro_R1_Kritipur_RNAC	2.188484509158932	0	0.7294948363863106	0	-1
1343	1392	1393	Micro_R1_Kritipur_RNAC	1.3439206120346319	0	0.44797353734487727	0	-1
1344	1393	1394	Micro_R1_Kritipur_RNAC	0.6755429391720794	0	0.22518097972402648	0	-1
1345	1394	1395	Micro_R1_Kritipur_RNAC	0.40795968251405035	0	0.13598656083801677	0	-1
1346	1395	1396	Micro_R1_Kritipur_RNAC	1.09211416934293	0	0.3640380564476433	0	-1
1347	1396	1397	Micro_R1_Kritipur_RNAC	1.1193536879335355	0	0.37311789597784517	0	-1
1348	1397	1398	Micro_R1_Kritipur_RNAC	1.392180137065417	0	0.4640600456884723	0	-1
1349	1398	1399	Micro_R1_Kritipur_RNAC	1.205079938147499	0	0.40169331271583303	0	-1
1350	1399	1400	Micro_R1_Kritipur_RNAC	1.54890296816104	0	0.5163009893870133	0	-1
1351	1400	1401	Micro_R1_Kritipur_RNAC	2.5916809701827064	0	0.8638936567275688	0	-1
1352	1401	1402	Micro_R1_Kritipur_RNAC	2.6369476097657105	0	0.8789825365885702	0	-1
1353	1403	1404	Local_R1_Lagankhel_Tikathali	2.7719284991200768	0	0.9239761663733589	0	-1
1354	1404	1405	Local_R1_Lagankhel_Tikathali	0.8506949783251555	0	0.2835649927750518	0	-1
1355	1405	1406	Local_R1_Lagankhel_Tikathali	1.6657614017466142	0	0.5552538005822047	0	-1
1356	1406	1407	Local_R1_Lagankhel_Tikathali	0.892177617109588	0	0.29739253903652935	0	-1
1357	1407	1408	Local_R1_Lagankhel_Tikathali	0.07688797318646517	0	0.02562932439548839	0	-1
1358	1408	1409	Local_R1_Lagankhel_Tikathali	0.8892353063799123	0	0.2964117687933041	0	-1
1359	1409	1410	Local_R1_Lagankhel_Tikathali	1.5341022541468088	0	0.5113674180489363	0	-1
1360	1410	1411	Local_R1_Lagankhel_Tikathali	0.29471057882795904	0	0.09823685960931969	0	-1
1361	1411	1412	Local_R1_Lagankhel_Tikathali	0.7234464230500146	0	0.2411488076833382	0	-1
1362	1412	1413	Local_R1_Lagankhel_Tikathali	1.2705054282556785	0	0.42350180941855947	0	-1
1363	1413	1414	Local_R1_Lagankhel_Tikathali	0.3128034396902553	0	0.1042678132300851	0	-1
1364	1414	1415	Local_R1_Lagankhel_Tikathali	0.747107284255727	0	0.24903576141857567	0	-1
1365	1415	1416	Local_R1_Lagankhel_Tikathali	1.1915629879883292	0	0.3971876626627764	0	-1
1366	1416	1417	Local_R1_Lagankhel_Tikathali	0.8417183873171546	0	0.28057279577238486	0	-1
1367	1417	1418	Local_R1_Lagankhel_Tikathali	0.3060640224871113	0	0.1020213408290371	0	-1
1368	1419	1420	Local_R1_Tikathali_Lagankhel	0.3060640224871113	0	0.1020213408290371	0	-1
1369	1420	1421	Local_R1_Tikathali_Lagankhel	0.8417183873171546	0	0.28057279577238486	0	-1
1370	1421	1422	Local_R1_Tikathali_Lagankhel	1.1915629879883292	0	0.3971876626627764	0	-1
1371	1422	1423	Local_R1_Tikathali_Lagankhel	0.747107284255727	0	0.24903576141857567	0	-1
1372	1423	1424	Local_R1_Tikathali_Lagankhel	0.3128034396902553	0	0.1042678132300851	0	-1
1373	1424	1425	Local_R1_Tikathali_Lagankhel	1.2705054282556785	0	0.42350180941855947	0	-1
1374	1425	1426	Local_R1_Tikathali_Lagankhel	0.7234464230500146	0	0.2411488076833382	0	-1
1375	1426	1427	Local_R1_Tikathali_Lagankhel	0.29471057882795904	0	0.09823685960931969	0	-1
1376	1427	1428	Local_R1_Tikathali_Lagankhel	1.5341022541468088	0	0.5113674180489363	0	-1
1377	1428	1429	Local_R1_Tikathali_Lagankhel	0.8892353063799123	0	0.2964117687933041	0	-1
1378	1429	1430	Local_R1_Tikathali_Lagankhel	0.07688797318646517	0	0.02562932439548839	0	-1
1379	1430	1431	Local_R1_Tikathali_Lagankhel	0.892177617109588	0	0.29739253903652935	0	-1
1380	1431	1432	Local_R1_Tikathali_Lagankhel	1.6657614017466142	0	0.5552538005822047	0	-1
1381	1432	1433	Local_R1_Tikathali_Lagankhel	0.8506949783251555	0	0.2835649927750518	0	-1
1382	1433	1434	Local_R1_Tikathali_Lagankhel	2.7719284991200768	0	0.9239761663733589	0	-1
1383	1435	1436	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.2105246019441323	0	0.7368415339813774	0	-1
1384	1436	1437	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8977450094976238	0	0.29924833649920796	0	-1
1385	1437	1438	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.2080552072697297	0	0.7360184024232432	0	-1
1386	1438	1439	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.0792187123406431	0	0.3597395707802144	0	-1
1387	1439	1440	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.8186396505045688	0	0.6062132168348563	0	-1
1388	1440	1441	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	3.6624808136561535	0	1.2208269378853844	0	-1
1389	1441	1442	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.8936479656673324	0	0.9645493218891108	0	-1
1390	1442	1443	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.4899559234281934	0	0.49665197447606446	0	-1
1391	1443	1444	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.3635934930010865	0	0.4545311643336955	0	-1
1392	1444	1445	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.0127204997555643	0	0.3375734999185214	0	-1
1393	1445	1446	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8892726271462428	0	0.2964242090487476	0	-1
1394	1446	1447	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.5218035603779854	0	0.5072678534593285	0	-1
1395	1447	1448	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.6282307605439337	0	0.20941025351464457	0	-1
1396	1448	1449	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.1407419145804067	0	0.713580638193469	0	-1
1397	1449	1450	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.8320533809582722	0	0.610684460319424	0	-1
1398	1450	1451	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.4410413829084208	0	0.4803471276361403	0	-1
1399	1451	1452	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.8591091313946022	0	0.6197030437982007	0	-1
1400	1452	1453	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.4309555223763013	0	0.8103185074587671	0	-1
1401	1453	1454	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.3931520212676437	0	0.13105067375588123	0	-1
1402	1454	1455	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.5577493389818544	0	0.5192497796606181	0	-1
1403	1455	1456	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8451132960058757	0	0.28170443200195855	0	-1
1404	1456	1457	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.957192253631234	0	0.31906408454374463	0	-1
1405	1457	1458	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.7864199906766958	0	0.26213999689223194	0	-1
1406	1458	1459	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.3831071685216432	0	0.4610357228405478	0	-1
1407	1459	1460	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.7813870103209245	0	0.2604623367736415	0	-1
1408	1460	1461	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.6238952863506295	0	0.8746317621168764	0	-1
1409	1461	1462	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8086381176025322	0	0.2695460392008441	0	-1
1410	1462	1463	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.7272817800045253	0	0.24242726000150844	0	-1
1411	1463	1464	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.6458764968515702	0	0.21529216561719008	0	-1
1412	1464	1465	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.7009495622702826	0	0.5669831874234276	0	-1
1413	1465	1466	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8541993105794696	0	0.2847331035264899	0	-1
1414	1466	1467	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.9586560065605265	0	0.6528853355201756	0	-1
1415	1467	1468	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.3020714250241907	0	0.7673571416747302	0	-1
1416	1468	1469	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.1281756246642458	0	0.3760585415547486	0	-1
1417	1469	1470	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.176659322298097	0	0.7255531074326991	0	-1
1418	1470	1471	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	0.8895095984563332	0	0.2965031994854444	0	-1
1419	1471	1472	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.3250505978671065	0	0.44168353262236887	0	-1
1420	1472	1473	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.1982603584453808	0	0.3994201194817936	0	-1
1421	1473	1474	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.9388703720227825	0	0.9796234573409275	0	-1
1422	1474	1475	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.188664149069179	0	0.729554716356393	0	-1
1423	1475	1476	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.242296442868612	0	0.7474321476228707	0	-1
1424	1476	1477	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.8459989820447158	0	0.6153329940149053	0	-1
1425	1477	1478	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.825848771415228	0	0.9419495904717425	0	-1
1426	1478	1479	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.583318410570072	0	0.5277728035233573	0	-1
1427	1479	1480	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.1721191958984787	0	0.39070639863282625	0	-1
1428	1480	1481	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.4072191829845333	0	0.4690730609948444	0	-1
1429	1481	1482	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.0288518975776622	0	0.34295063252588737	0	-1
1430	1482	1483	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.257232355188933	0	0.7524107850629776	0	-1
1431	1483	1484	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.678265952251483	0	0.8927553174171611	0	-1
1432	1484	1485	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.632789063006577	0	0.8775963543355257	0	-1
1433	1485	1486	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.9521431823395705	0	0.6507143941131901	0	-1
1434	1486	1487	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.4999174232372166	0	0.4999724744124055	0	-1
1435	1487	1488	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.7957488391181737	0	0.9319162797060578	0	-1
1436	1488	1489	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.0883210921535043	0	0.36277369738450144	0	-1
1437	1489	1490	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	2.1609955772240093	0	0.7203318590746698	0	-1
1438	1490	1491	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	1.3520909440999402	0	0.45069698136664677	0	-1
1439	1491	1492	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	3.3174188919675207	0	1.105806297322507	0	-1
1440	1493	1494	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	3.3174188919675207	0	1.105806297322507	0	-1
1441	1494	1495	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.3520909440999402	0	0.45069698136664677	0	-1
1442	1495	1496	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.1609955772240093	0	0.7203318590746698	0	-1
1443	1496	1497	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.0883210921535043	0	0.36277369738450144	0	-1
1444	1497	1498	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.7957488391181737	0	0.9319162797060578	0	-1
1445	1498	1499	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.4999174232372166	0	0.4999724744124055	0	-1
1446	1499	1500	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.9521431823395705	0	0.6507143941131901	0	-1
1447	1500	1501	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.632789063006577	0	0.8775963543355257	0	-1
1448	1501	1502	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.678265952251483	0	0.8927553174171611	0	-1
1449	1502	1503	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.257232355188933	0	0.7524107850629776	0	-1
1450	1503	1504	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.0288518975776622	0	0.34295063252588737	0	-1
1451	1504	1505	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.4072191829845333	0	0.4690730609948444	0	-1
1526	42	535	\N	3	1	0	1	-1
1452	1505	1506	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.1721191958984787	0	0.39070639863282625	0	-1
1453	1506	1507	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.583318410570072	0	0.5277728035233573	0	-1
1454	1507	1508	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.825848771415228	0	0.9419495904717425	0	-1
1455	1508	1509	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.8459989820447158	0	0.6153329940149053	0	-1
1456	1509	1510	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.242296442868612	0	0.7474321476228707	0	-1
1457	1510	1511	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.188664149069179	0	0.729554716356393	0	-1
1458	1511	1512	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.9388703720227825	0	0.9796234573409275	0	-1
1459	1512	1513	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.6117089658079498	0	0.5372363219359833	0	-1
1460	1513	1514	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.9476527249523403	0	0.3158842416507801	0	-1
1461	1514	1515	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.072690778733672	0	0.35756359291122397	0	-1
1462	1515	1516	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.1230979891528485	0	0.7076993297176162	0	-1
1463	1516	1517	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.2245028119341383	0	0.4081676039780461	0	-1
1464	1517	1518	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.074147757964719	0	0.6913825859882398	0	-1
1465	1518	1519	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.9586560065605265	0	0.6528853355201756	0	-1
1466	1519	1520	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8541993105794696	0	0.2847331035264899	0	-1
1467	1520	1521	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.7009495622702826	0	0.5669831874234276	0	-1
1468	1521	1522	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.6458764968515702	0	0.21529216561719008	0	-1
1469	1522	1523	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.7272817800045253	0	0.24242726000150844	0	-1
1470	1523	1524	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8506949783251555	0	0.2835649927750518	0	-1
1471	1524	1525	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.6657614017466142	0	0.5552538005822047	0	-1
1472	1525	1526	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8814549142962684	0	0.2938183047654228	0	-1
1473	1526	1527	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.169957163335033	0	0.7233190544450111	0	-1
1474	1527	1528	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.7864199906766958	0	0.26213999689223194	0	-1
1475	1528	1529	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.957192253631234	0	0.31906408454374463	0	-1
1476	1529	1530	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8451132960058757	0	0.28170443200195855	0	-1
1477	1530	1531	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.0624263651942214	0	0.6874754550647405	0	-1
1478	1531	1532	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.1893706181433172	0	0.7297902060477724	0	-1
1479	1532	1533	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.9704465316766524	0	0.6568155105588841	0	-1
1480	1533	1534	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.4410413829084208	0	0.4803471276361403	0	-1
1481	1534	1535	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.8233813635545788	0	0.6077937878515263	0	-1
1482	1535	1536	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.14654986498125	0	0.7155166216604167	0	-1
1483	1536	1537	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.6282307605439337	0	0.20941025351464457	0	-1
1484	1537	1538	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.5218035603779854	0	0.5072678534593285	0	-1
1485	1538	1539	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8892726271462428	0	0.2964242090487476	0	-1
1486	1539	1540	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.0127204997555643	0	0.3375734999185214	0	-1
1487	1540	1541	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.3395044076378675	0	0.44650146921262246	0	-1
1488	1541	1542	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.7013614915062687	0	0.2337871638354229	0	-1
1489	1542	1543	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.9517622656754756	0	0.31725408855849185	0	-1
1490	1543	1544	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.8627839925935934	0	0.9542613308645312	0	-1
1491	1544	1545	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	3.6624808136561535	0	1.2208269378853844	0	-1
1492	1545	1546	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.8186396505045688	0	0.6062132168348563	0	-1
1493	1546	1547	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	1.0792187123406431	0	0.3597395707802144	0	-1
1494	1547	1548	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.2080552072697297	0	0.7360184024232432	0	-1
1495	1548	1549	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	0.8977450094976238	0	0.29924833649920796	0	-1
1496	1549	1550	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	2.2105246019441323	0	0.7368415339813774	0	-1
1497	1	42	\N	3	1	0	1	-1
1498	1	43	\N	3	1	0	1	-1
1499	1	94	\N	3	1	0	1	-1
1500	1	102	\N	3	1	0	1	-1
1501	1	120	\N	3	1	0	1	-1
1502	1	148	\N	3	1	0	1	-1
1503	1	166	\N	3	1	0	1	-1
1504	1	337	\N	3	1	0	1	-1
1505	1	355	\N	3	1	0	1	-1
1506	1	417	\N	3	1	0	1	-1
1507	1	428	\N	3	1	0	1	-1
1508	1	511	\N	3	1	0	1	-1
1509	1	535	\N	3	1	0	1	-1
1510	1	1294	\N	3	1	0	1	-1
1511	1	1295	\N	3	1	0	1	-1
1512	1	1403	\N	3	1	0	1	-1
1513	1	1434	\N	3	1	0	1	-1
1514	42	1	\N	3	1	0	1	-1
1515	42	43	\N	3	1	0	1	-1
1516	42	94	\N	3	1	0	1	-1
1517	42	102	\N	3	1	0	1	-1
1518	42	120	\N	3	1	0	1	-1
1519	42	148	\N	3	1	0	1	-1
1520	42	166	\N	3	1	0	1	-1
1521	42	337	\N	3	1	0	1	-1
1522	42	355	\N	3	1	0	1	-1
1523	42	417	\N	3	1	0	1	-1
1524	42	428	\N	3	1	0	1	-1
1527	42	1294	\N	3	1	0	1	-1
1528	42	1295	\N	3	1	0	1	-1
1529	42	1403	\N	3	1	0	1	-1
1530	42	1434	\N	3	1	0	1	-1
1531	43	1	\N	3	1	0	1	-1
1532	43	42	\N	3	1	0	1	-1
1533	43	94	\N	3	1	0	1	-1
1534	43	102	\N	3	1	0	1	-1
1535	43	120	\N	3	1	0	1	-1
1536	43	148	\N	3	1	0	1	-1
1537	43	166	\N	3	1	0	1	-1
1538	43	337	\N	3	1	0	1	-1
1539	43	355	\N	3	1	0	1	-1
1540	43	417	\N	3	1	0	1	-1
1541	43	428	\N	3	1	0	1	-1
1542	43	511	\N	3	1	0	1	-1
1543	43	535	\N	3	1	0	1	-1
1544	43	1294	\N	3	1	0	1	-1
1545	43	1295	\N	3	1	0	1	-1
1546	43	1403	\N	3	1	0	1	-1
1547	43	1434	\N	3	1	0	1	-1
1548	94	1	\N	3	1	0	1	-1
1549	94	42	\N	3	1	0	1	-1
1550	94	43	\N	3	1	0	1	-1
1551	94	102	\N	3	1	0	1	-1
1552	94	120	\N	3	1	0	1	-1
1553	94	148	\N	3	1	0	1	-1
1554	94	166	\N	3	1	0	1	-1
1555	94	337	\N	3	1	0	1	-1
1556	94	355	\N	3	1	0	1	-1
1557	94	417	\N	3	1	0	1	-1
1558	94	428	\N	3	1	0	1	-1
1559	94	511	\N	3	1	0	1	-1
1560	94	535	\N	3	1	0	1	-1
1561	94	1294	\N	3	1	0	1	-1
1562	94	1295	\N	3	1	0	1	-1
1563	94	1403	\N	3	1	0	1	-1
1564	94	1434	\N	3	1	0	1	-1
1565	102	1	\N	3	1	0	1	-1
1566	102	42	\N	3	1	0	1	-1
1567	102	43	\N	3	1	0	1	-1
1568	102	94	\N	3	1	0	1	-1
1569	102	120	\N	3	1	0	1	-1
1570	102	148	\N	3	1	0	1	-1
1571	102	166	\N	3	1	0	1	-1
1572	102	337	\N	3	1	0	1	-1
1573	102	355	\N	3	1	0	1	-1
1574	102	417	\N	3	1	0	1	-1
1575	102	428	\N	3	1	0	1	-1
1576	102	511	\N	3	1	0	1	-1
1577	102	535	\N	3	1	0	1	-1
1578	102	1294	\N	3	1	0	1	-1
1579	102	1295	\N	3	1	0	1	-1
1580	102	1403	\N	3	1	0	1	-1
1581	102	1434	\N	3	1	0	1	-1
1582	120	1	\N	3	1	0	1	-1
1583	120	42	\N	3	1	0	1	-1
1584	120	43	\N	3	1	0	1	-1
1585	120	94	\N	3	1	0	1	-1
1586	120	102	\N	3	1	0	1	-1
1587	120	148	\N	3	1	0	1	-1
1588	120	166	\N	3	1	0	1	-1
1589	120	337	\N	3	1	0	1	-1
1590	120	355	\N	3	1	0	1	-1
1591	120	417	\N	3	1	0	1	-1
1592	120	428	\N	3	1	0	1	-1
1593	120	511	\N	3	1	0	1	-1
1594	120	535	\N	3	1	0	1	-1
1595	120	1294	\N	3	1	0	1	-1
1596	120	1295	\N	3	1	0	1	-1
1597	120	1403	\N	3	1	0	1	-1
1598	120	1434	\N	3	1	0	1	-1
1599	148	1	\N	3	1	0	1	-1
1600	148	42	\N	3	1	0	1	-1
1601	148	43	\N	3	1	0	1	-1
1602	148	94	\N	3	1	0	1	-1
1603	148	102	\N	3	1	0	1	-1
1604	148	120	\N	3	1	0	1	-1
1605	148	166	\N	3	1	0	1	-1
1606	148	337	\N	3	1	0	1	-1
1607	148	355	\N	3	1	0	1	-1
1608	148	417	\N	3	1	0	1	-1
1609	148	428	\N	3	1	0	1	-1
1610	148	511	\N	3	1	0	1	-1
1611	148	535	\N	3	1	0	1	-1
1612	148	1294	\N	3	1	0	1	-1
1613	148	1295	\N	3	1	0	1	-1
1614	148	1403	\N	3	1	0	1	-1
1615	148	1434	\N	3	1	0	1	-1
1616	166	1	\N	3	1	0	1	-1
1617	166	42	\N	3	1	0	1	-1
1618	166	43	\N	3	1	0	1	-1
1619	166	94	\N	3	1	0	1	-1
1620	166	102	\N	3	1	0	1	-1
1621	166	120	\N	3	1	0	1	-1
1622	166	148	\N	3	1	0	1	-1
1623	166	337	\N	3	1	0	1	-1
1624	166	355	\N	3	1	0	1	-1
1625	166	417	\N	3	1	0	1	-1
1626	166	428	\N	3	1	0	1	-1
1627	166	511	\N	3	1	0	1	-1
1628	166	535	\N	3	1	0	1	-1
1629	166	1294	\N	3	1	0	1	-1
1630	166	1295	\N	3	1	0	1	-1
1631	166	1403	\N	3	1	0	1	-1
1632	166	1434	\N	3	1	0	1	-1
1633	337	1	\N	3	1	0	1	-1
1634	337	42	\N	3	1	0	1	-1
1635	337	43	\N	3	1	0	1	-1
1636	337	94	\N	3	1	0	1	-1
1637	337	102	\N	3	1	0	1	-1
1638	337	120	\N	3	1	0	1	-1
1639	337	148	\N	3	1	0	1	-1
1640	337	166	\N	3	1	0	1	-1
1641	337	355	\N	3	1	0	1	-1
1642	337	417	\N	3	1	0	1	-1
1643	337	428	\N	3	1	0	1	-1
1644	337	511	\N	3	1	0	1	-1
1645	337	535	\N	3	1	0	1	-1
1646	337	1294	\N	3	1	0	1	-1
1647	337	1295	\N	3	1	0	1	-1
1648	337	1403	\N	3	1	0	1	-1
1649	337	1434	\N	3	1	0	1	-1
1650	355	1	\N	3	1	0	1	-1
1651	355	42	\N	3	1	0	1	-1
1652	355	43	\N	3	1	0	1	-1
1653	355	94	\N	3	1	0	1	-1
1654	355	102	\N	3	1	0	1	-1
1655	355	120	\N	3	1	0	1	-1
1656	355	148	\N	3	1	0	1	-1
1657	355	166	\N	3	1	0	1	-1
1658	355	337	\N	3	1	0	1	-1
1659	355	417	\N	3	1	0	1	-1
1660	355	428	\N	3	1	0	1	-1
1661	355	511	\N	3	1	0	1	-1
1662	355	535	\N	3	1	0	1	-1
1663	355	1294	\N	3	1	0	1	-1
1664	355	1295	\N	3	1	0	1	-1
1665	355	1403	\N	3	1	0	1	-1
1666	355	1434	\N	3	1	0	1	-1
1667	417	1	\N	3	1	0	1	-1
1668	417	42	\N	3	1	0	1	-1
1669	417	43	\N	3	1	0	1	-1
1670	417	94	\N	3	1	0	1	-1
1671	417	102	\N	3	1	0	1	-1
1672	417	120	\N	3	1	0	1	-1
1673	417	148	\N	3	1	0	1	-1
1674	417	166	\N	3	1	0	1	-1
1675	417	337	\N	3	1	0	1	-1
1676	417	355	\N	3	1	0	1	-1
1677	417	428	\N	3	1	0	1	-1
1678	417	511	\N	3	1	0	1	-1
1679	417	535	\N	3	1	0	1	-1
1680	417	1294	\N	3	1	0	1	-1
1681	417	1295	\N	3	1	0	1	-1
1682	417	1403	\N	3	1	0	1	-1
1683	417	1434	\N	3	1	0	1	-1
1684	428	1	\N	3	1	0	1	-1
1685	428	42	\N	3	1	0	1	-1
1686	428	43	\N	3	1	0	1	-1
1687	428	94	\N	3	1	0	1	-1
1688	428	102	\N	3	1	0	1	-1
1689	428	120	\N	3	1	0	1	-1
1690	428	148	\N	3	1	0	1	-1
1691	428	166	\N	3	1	0	1	-1
1692	428	337	\N	3	1	0	1	-1
1693	428	355	\N	3	1	0	1	-1
1694	428	417	\N	3	1	0	1	-1
1695	428	511	\N	3	1	0	1	-1
1696	428	535	\N	3	1	0	1	-1
1697	428	1294	\N	3	1	0	1	-1
1698	428	1295	\N	3	1	0	1	-1
1699	428	1403	\N	3	1	0	1	-1
1700	428	1434	\N	3	1	0	1	-1
1701	511	1	\N	3	1	0	1	-1
1702	511	42	\N	3	1	0	1	-1
1703	511	43	\N	3	1	0	1	-1
1704	511	94	\N	3	1	0	1	-1
1705	511	102	\N	3	1	0	1	-1
1706	511	120	\N	3	1	0	1	-1
1707	511	148	\N	3	1	0	1	-1
1708	511	166	\N	3	1	0	1	-1
1709	511	337	\N	3	1	0	1	-1
1710	511	355	\N	3	1	0	1	-1
1711	511	417	\N	3	1	0	1	-1
1712	511	428	\N	3	1	0	1	-1
1713	511	535	\N	3	1	0	1	-1
1714	511	1294	\N	3	1	0	1	-1
1715	511	1295	\N	3	1	0	1	-1
1716	511	1403	\N	3	1	0	1	-1
1717	511	1434	\N	3	1	0	1	-1
1718	535	1	\N	3	1	0	1	-1
1719	535	42	\N	3	1	0	1	-1
1720	535	43	\N	3	1	0	1	-1
1721	535	94	\N	3	1	0	1	-1
1722	535	102	\N	3	1	0	1	-1
1723	535	120	\N	3	1	0	1	-1
1724	535	148	\N	3	1	0	1	-1
1725	535	166	\N	3	1	0	1	-1
1726	535	337	\N	3	1	0	1	-1
1727	535	355	\N	3	1	0	1	-1
1728	535	417	\N	3	1	0	1	-1
1729	535	428	\N	3	1	0	1	-1
1730	535	511	\N	3	1	0	1	-1
1731	535	1294	\N	3	1	0	1	-1
1732	535	1295	\N	3	1	0	1	-1
1733	535	1403	\N	3	1	0	1	-1
1734	535	1434	\N	3	1	0	1	-1
1735	1294	1	\N	3	1	0	1	-1
1736	1294	42	\N	3	1	0	1	-1
1737	1294	43	\N	3	1	0	1	-1
1738	1294	94	\N	3	1	0	1	-1
1739	1294	102	\N	3	1	0	1	-1
1740	1294	120	\N	3	1	0	1	-1
1741	1294	148	\N	3	1	0	1	-1
1742	1294	166	\N	3	1	0	1	-1
1743	1294	337	\N	3	1	0	1	-1
1744	1294	355	\N	3	1	0	1	-1
1745	1294	417	\N	3	1	0	1	-1
1746	1294	428	\N	3	1	0	1	-1
1747	1294	511	\N	3	1	0	1	-1
1748	1294	535	\N	3	1	0	1	-1
1749	1294	1295	\N	3	1	0	1	-1
1750	1294	1403	\N	3	1	0	1	-1
1751	1294	1434	\N	3	1	0	1	-1
1752	1295	1	\N	3	1	0	1	-1
1753	1295	42	\N	3	1	0	1	-1
1754	1295	43	\N	3	1	0	1	-1
1755	1295	94	\N	3	1	0	1	-1
1756	1295	102	\N	3	1	0	1	-1
1757	1295	120	\N	3	1	0	1	-1
1758	1295	148	\N	3	1	0	1	-1
1759	1295	166	\N	3	1	0	1	-1
1760	1295	337	\N	3	1	0	1	-1
1761	1295	355	\N	3	1	0	1	-1
1762	1295	417	\N	3	1	0	1	-1
1763	1295	428	\N	3	1	0	1	-1
1764	1295	511	\N	3	1	0	1	-1
1765	1295	535	\N	3	1	0	1	-1
1766	1295	1294	\N	3	1	0	1	-1
1767	1295	1403	\N	3	1	0	1	-1
1768	1295	1434	\N	3	1	0	1	-1
1769	1403	1	\N	3	1	0	1	-1
1770	1403	42	\N	3	1	0	1	-1
1771	1403	43	\N	3	1	0	1	-1
1772	1403	94	\N	3	1	0	1	-1
1773	1403	102	\N	3	1	0	1	-1
1774	1403	120	\N	3	1	0	1	-1
1775	1403	148	\N	3	1	0	1	-1
1776	1403	166	\N	3	1	0	1	-1
1777	1403	337	\N	3	1	0	1	-1
1778	1403	355	\N	3	1	0	1	-1
1779	1403	417	\N	3	1	0	1	-1
1780	1403	428	\N	3	1	0	1	-1
1781	1403	511	\N	3	1	0	1	-1
1782	1403	535	\N	3	1	0	1	-1
1783	1403	1294	\N	3	1	0	1	-1
1784	1403	1295	\N	3	1	0	1	-1
1785	1403	1434	\N	3	1	0	1	-1
1786	1434	1	\N	3	1	0	1	-1
1787	1434	42	\N	3	1	0	1	-1
1788	1434	43	\N	3	1	0	1	-1
1789	1434	94	\N	3	1	0	1	-1
1790	1434	102	\N	3	1	0	1	-1
1791	1434	120	\N	3	1	0	1	-1
1792	1434	148	\N	3	1	0	1	-1
1793	1434	166	\N	3	1	0	1	-1
1794	1434	337	\N	3	1	0	1	-1
1795	1434	355	\N	3	1	0	1	-1
1796	1434	417	\N	3	1	0	1	-1
1797	1434	428	\N	3	1	0	1	-1
1798	1434	511	\N	3	1	0	1	-1
1799	1434	535	\N	3	1	0	1	-1
1800	1434	1294	\N	3	1	0	1	-1
1801	1434	1295	\N	3	1	0	1	-1
1802	1434	1403	\N	3	1	0	1	-1
1803	2	41	\N	3	1	0	1	-1
1804	2	44	\N	3	1	0	1	-1
1805	2	93	\N	3	1	0	1	-1
1806	2	103	\N	3	1	0	1	-1
1807	2	119	\N	3	1	0	1	-1
1808	2	149	\N	3	1	0	1	-1
1809	2	165	\N	3	1	0	1	-1
1810	2	338	\N	3	1	0	1	-1
1811	2	354	\N	3	1	0	1	-1
1812	2	416	\N	3	1	0	1	-1
1813	2	429	\N	3	1	0	1	-1
1814	2	512	\N	3	1	0	1	-1
1815	2	558	\N	3	1	0	1	-1
1816	41	2	\N	3	1	0	1	-1
1817	41	44	\N	3	1	0	1	-1
1818	41	93	\N	3	1	0	1	-1
1819	41	103	\N	3	1	0	1	-1
1820	41	119	\N	3	1	0	1	-1
1821	41	149	\N	3	1	0	1	-1
1822	41	165	\N	3	1	0	1	-1
1823	41	338	\N	3	1	0	1	-1
1824	41	354	\N	3	1	0	1	-1
1825	41	416	\N	3	1	0	1	-1
1826	41	429	\N	3	1	0	1	-1
1827	41	512	\N	3	1	0	1	-1
1828	41	558	\N	3	1	0	1	-1
1829	44	2	\N	3	1	0	1	-1
1830	44	41	\N	3	1	0	1	-1
1831	44	93	\N	3	1	0	1	-1
1832	44	103	\N	3	1	0	1	-1
1833	44	119	\N	3	1	0	1	-1
1834	44	149	\N	3	1	0	1	-1
1835	44	165	\N	3	1	0	1	-1
1836	44	338	\N	3	1	0	1	-1
1837	44	354	\N	3	1	0	1	-1
1838	44	416	\N	3	1	0	1	-1
1839	44	429	\N	3	1	0	1	-1
1840	44	512	\N	3	1	0	1	-1
1841	44	558	\N	3	1	0	1	-1
1842	93	2	\N	3	1	0	1	-1
1843	93	41	\N	3	1	0	1	-1
1844	93	44	\N	3	1	0	1	-1
1845	93	103	\N	3	1	0	1	-1
1846	93	119	\N	3	1	0	1	-1
1847	93	149	\N	3	1	0	1	-1
1848	93	165	\N	3	1	0	1	-1
1849	93	338	\N	3	1	0	1	-1
1850	93	354	\N	3	1	0	1	-1
1851	93	416	\N	3	1	0	1	-1
1852	93	429	\N	3	1	0	1	-1
1853	93	512	\N	3	1	0	1	-1
1854	93	558	\N	3	1	0	1	-1
1855	103	2	\N	3	1	0	1	-1
1856	103	41	\N	3	1	0	1	-1
1857	103	44	\N	3	1	0	1	-1
1858	103	93	\N	3	1	0	1	-1
1859	103	119	\N	3	1	0	1	-1
1860	103	149	\N	3	1	0	1	-1
1861	103	165	\N	3	1	0	1	-1
1862	103	338	\N	3	1	0	1	-1
1863	103	354	\N	3	1	0	1	-1
1864	103	416	\N	3	1	0	1	-1
1865	103	429	\N	3	1	0	1	-1
1866	103	512	\N	3	1	0	1	-1
1867	103	558	\N	3	1	0	1	-1
1868	119	2	\N	3	1	0	1	-1
1869	119	41	\N	3	1	0	1	-1
1870	119	44	\N	3	1	0	1	-1
1871	119	93	\N	3	1	0	1	-1
1872	119	103	\N	3	1	0	1	-1
1873	119	149	\N	3	1	0	1	-1
1874	119	165	\N	3	1	0	1	-1
1875	119	338	\N	3	1	0	1	-1
1876	119	354	\N	3	1	0	1	-1
1877	119	416	\N	3	1	0	1	-1
1878	119	429	\N	3	1	0	1	-1
1879	119	512	\N	3	1	0	1	-1
1880	119	558	\N	3	1	0	1	-1
1881	149	2	\N	3	1	0	1	-1
1882	149	41	\N	3	1	0	1	-1
1883	149	44	\N	3	1	0	1	-1
1884	149	93	\N	3	1	0	1	-1
1885	149	103	\N	3	1	0	1	-1
1886	149	119	\N	3	1	0	1	-1
1887	149	165	\N	3	1	0	1	-1
1888	149	338	\N	3	1	0	1	-1
1889	149	354	\N	3	1	0	1	-1
1890	149	416	\N	3	1	0	1	-1
1891	149	429	\N	3	1	0	1	-1
1892	149	512	\N	3	1	0	1	-1
1893	149	558	\N	3	1	0	1	-1
1894	165	2	\N	3	1	0	1	-1
1895	165	41	\N	3	1	0	1	-1
1896	165	44	\N	3	1	0	1	-1
1897	165	93	\N	3	1	0	1	-1
1898	165	103	\N	3	1	0	1	-1
1899	165	119	\N	3	1	0	1	-1
1900	165	149	\N	3	1	0	1	-1
1901	165	338	\N	3	1	0	1	-1
1902	165	354	\N	3	1	0	1	-1
1903	165	416	\N	3	1	0	1	-1
1904	165	429	\N	3	1	0	1	-1
1905	165	512	\N	3	1	0	1	-1
1906	165	558	\N	3	1	0	1	-1
1907	338	2	\N	3	1	0	1	-1
1908	338	41	\N	3	1	0	1	-1
1909	338	44	\N	3	1	0	1	-1
1910	338	93	\N	3	1	0	1	-1
1911	338	103	\N	3	1	0	1	-1
1912	338	119	\N	3	1	0	1	-1
1913	338	149	\N	3	1	0	1	-1
1914	338	165	\N	3	1	0	1	-1
1915	338	354	\N	3	1	0	1	-1
1916	338	416	\N	3	1	0	1	-1
1917	338	429	\N	3	1	0	1	-1
1918	338	512	\N	3	1	0	1	-1
1919	338	558	\N	3	1	0	1	-1
1920	354	2	\N	3	1	0	1	-1
1921	354	41	\N	3	1	0	1	-1
1922	354	44	\N	3	1	0	1	-1
1923	354	93	\N	3	1	0	1	-1
1924	354	103	\N	3	1	0	1	-1
1925	354	119	\N	3	1	0	1	-1
1926	354	149	\N	3	1	0	1	-1
1927	354	165	\N	3	1	0	1	-1
1928	354	338	\N	3	1	0	1	-1
1929	354	416	\N	3	1	0	1	-1
1930	354	429	\N	3	1	0	1	-1
1931	354	512	\N	3	1	0	1	-1
1932	354	558	\N	3	1	0	1	-1
1933	416	2	\N	3	1	0	1	-1
1934	416	41	\N	3	1	0	1	-1
1935	416	44	\N	3	1	0	1	-1
1936	416	93	\N	3	1	0	1	-1
1937	416	103	\N	3	1	0	1	-1
1938	416	119	\N	3	1	0	1	-1
1939	416	149	\N	3	1	0	1	-1
1940	416	165	\N	3	1	0	1	-1
1941	416	338	\N	3	1	0	1	-1
1942	416	354	\N	3	1	0	1	-1
1943	416	429	\N	3	1	0	1	-1
1944	416	512	\N	3	1	0	1	-1
1945	416	558	\N	3	1	0	1	-1
1946	429	2	\N	3	1	0	1	-1
1947	429	41	\N	3	1	0	1	-1
1948	429	44	\N	3	1	0	1	-1
1949	429	93	\N	3	1	0	1	-1
1950	429	103	\N	3	1	0	1	-1
1951	429	119	\N	3	1	0	1	-1
1952	429	149	\N	3	1	0	1	-1
1953	429	165	\N	3	1	0	1	-1
1954	429	338	\N	3	1	0	1	-1
1955	429	354	\N	3	1	0	1	-1
1956	429	416	\N	3	1	0	1	-1
1957	429	512	\N	3	1	0	1	-1
1958	429	558	\N	3	1	0	1	-1
1959	512	2	\N	3	1	0	1	-1
1960	512	41	\N	3	1	0	1	-1
1961	512	44	\N	3	1	0	1	-1
1962	512	93	\N	3	1	0	1	-1
1963	512	103	\N	3	1	0	1	-1
1964	512	119	\N	3	1	0	1	-1
1965	512	149	\N	3	1	0	1	-1
1966	512	165	\N	3	1	0	1	-1
1967	512	338	\N	3	1	0	1	-1
1968	512	354	\N	3	1	0	1	-1
1969	512	416	\N	3	1	0	1	-1
1970	512	429	\N	3	1	0	1	-1
1971	512	558	\N	3	1	0	1	-1
1972	558	2	\N	3	1	0	1	-1
1973	558	41	\N	3	1	0	1	-1
1974	558	44	\N	3	1	0	1	-1
1975	558	93	\N	3	1	0	1	-1
1976	558	103	\N	3	1	0	1	-1
1977	558	119	\N	3	1	0	1	-1
1978	558	149	\N	3	1	0	1	-1
1979	558	165	\N	3	1	0	1	-1
1980	558	338	\N	3	1	0	1	-1
1981	558	354	\N	3	1	0	1	-1
1982	558	416	\N	3	1	0	1	-1
1983	558	429	\N	3	1	0	1	-1
1984	558	512	\N	3	1	0	1	-1
1985	3	40	\N	3	1	0	1	-1
1986	3	45	\N	3	1	0	1	-1
1987	3	92	\N	3	1	0	1	-1
1988	3	104	\N	3	1	0	1	-1
1989	3	118	\N	3	1	0	1	-1
1990	3	150	\N	3	1	0	1	-1
1991	3	164	\N	3	1	0	1	-1
1992	3	339	\N	3	1	0	1	-1
1993	3	353	\N	3	1	0	1	-1
1994	3	395	\N	3	1	0	1	-1
1995	3	415	\N	3	1	0	1	-1
1996	3	430	\N	3	1	0	1	-1
1997	3	513	\N	3	1	0	1	-1
1998	3	557	\N	3	1	0	1	-1
1999	40	3	\N	3	1	0	1	-1
2000	40	45	\N	3	1	0	1	-1
2001	40	92	\N	3	1	0	1	-1
2002	40	104	\N	3	1	0	1	-1
2003	40	118	\N	3	1	0	1	-1
2004	40	150	\N	3	1	0	1	-1
2005	40	164	\N	3	1	0	1	-1
2006	40	339	\N	3	1	0	1	-1
2007	40	353	\N	3	1	0	1	-1
2008	40	395	\N	3	1	0	1	-1
2009	40	415	\N	3	1	0	1	-1
2010	40	430	\N	3	1	0	1	-1
2011	40	513	\N	3	1	0	1	-1
2012	40	557	\N	3	1	0	1	-1
2013	45	3	\N	3	1	0	1	-1
2014	45	40	\N	3	1	0	1	-1
2015	45	92	\N	3	1	0	1	-1
2016	45	104	\N	3	1	0	1	-1
2017	45	118	\N	3	1	0	1	-1
2018	45	150	\N	3	1	0	1	-1
2019	45	164	\N	3	1	0	1	-1
2020	45	339	\N	3	1	0	1	-1
2021	45	353	\N	3	1	0	1	-1
2022	45	395	\N	3	1	0	1	-1
2023	45	415	\N	3	1	0	1	-1
2024	45	430	\N	3	1	0	1	-1
2025	45	513	\N	3	1	0	1	-1
2026	45	557	\N	3	1	0	1	-1
2027	92	3	\N	3	1	0	1	-1
2028	92	40	\N	3	1	0	1	-1
2029	92	45	\N	3	1	0	1	-1
2030	92	104	\N	3	1	0	1	-1
2031	92	118	\N	3	1	0	1	-1
2032	92	150	\N	3	1	0	1	-1
2033	92	164	\N	3	1	0	1	-1
2034	92	339	\N	3	1	0	1	-1
2035	92	353	\N	3	1	0	1	-1
2036	92	395	\N	3	1	0	1	-1
2037	92	415	\N	3	1	0	1	-1
2038	92	430	\N	3	1	0	1	-1
2039	92	513	\N	3	1	0	1	-1
2040	92	557	\N	3	1	0	1	-1
2041	104	3	\N	3	1	0	1	-1
2042	104	40	\N	3	1	0	1	-1
2043	104	45	\N	3	1	0	1	-1
2044	104	92	\N	3	1	0	1	-1
2045	104	118	\N	3	1	0	1	-1
2046	104	150	\N	3	1	0	1	-1
2047	104	164	\N	3	1	0	1	-1
2048	104	339	\N	3	1	0	1	-1
2049	104	353	\N	3	1	0	1	-1
2050	104	395	\N	3	1	0	1	-1
2051	104	415	\N	3	1	0	1	-1
2052	104	430	\N	3	1	0	1	-1
2053	104	513	\N	3	1	0	1	-1
2054	104	557	\N	3	1	0	1	-1
2055	118	3	\N	3	1	0	1	-1
2056	118	40	\N	3	1	0	1	-1
2057	118	45	\N	3	1	0	1	-1
2058	118	92	\N	3	1	0	1	-1
2059	118	104	\N	3	1	0	1	-1
2060	118	150	\N	3	1	0	1	-1
2061	118	164	\N	3	1	0	1	-1
2062	118	339	\N	3	1	0	1	-1
2063	118	353	\N	3	1	0	1	-1
2064	118	395	\N	3	1	0	1	-1
2065	118	415	\N	3	1	0	1	-1
2066	118	430	\N	3	1	0	1	-1
2067	118	513	\N	3	1	0	1	-1
2068	118	557	\N	3	1	0	1	-1
2069	150	3	\N	3	1	0	1	-1
2070	150	40	\N	3	1	0	1	-1
2071	150	45	\N	3	1	0	1	-1
2072	150	92	\N	3	1	0	1	-1
2073	150	104	\N	3	1	0	1	-1
2074	150	118	\N	3	1	0	1	-1
2075	150	164	\N	3	1	0	1	-1
2076	150	339	\N	3	1	0	1	-1
2077	150	353	\N	3	1	0	1	-1
2078	150	395	\N	3	1	0	1	-1
2079	150	415	\N	3	1	0	1	-1
2080	150	430	\N	3	1	0	1	-1
2081	150	513	\N	3	1	0	1	-1
2082	150	557	\N	3	1	0	1	-1
2083	164	3	\N	3	1	0	1	-1
2084	164	40	\N	3	1	0	1	-1
2085	164	45	\N	3	1	0	1	-1
2086	164	92	\N	3	1	0	1	-1
2087	164	104	\N	3	1	0	1	-1
2088	164	118	\N	3	1	0	1	-1
2089	164	150	\N	3	1	0	1	-1
2090	164	339	\N	3	1	0	1	-1
2091	164	353	\N	3	1	0	1	-1
2092	164	395	\N	3	1	0	1	-1
2093	164	415	\N	3	1	0	1	-1
2094	164	430	\N	3	1	0	1	-1
2095	164	513	\N	3	1	0	1	-1
2096	164	557	\N	3	1	0	1	-1
2097	339	3	\N	3	1	0	1	-1
2098	339	40	\N	3	1	0	1	-1
2099	339	45	\N	3	1	0	1	-1
2100	339	92	\N	3	1	0	1	-1
2101	339	104	\N	3	1	0	1	-1
2102	339	118	\N	3	1	0	1	-1
2103	339	150	\N	3	1	0	1	-1
2104	339	164	\N	3	1	0	1	-1
2105	339	353	\N	3	1	0	1	-1
2106	339	395	\N	3	1	0	1	-1
2107	339	415	\N	3	1	0	1	-1
2108	339	430	\N	3	1	0	1	-1
2109	339	513	\N	3	1	0	1	-1
2110	339	557	\N	3	1	0	1	-1
2111	353	3	\N	3	1	0	1	-1
2112	353	40	\N	3	1	0	1	-1
2113	353	45	\N	3	1	0	1	-1
2114	353	92	\N	3	1	0	1	-1
2115	353	104	\N	3	1	0	1	-1
2116	353	118	\N	3	1	0	1	-1
2117	353	150	\N	3	1	0	1	-1
2118	353	164	\N	3	1	0	1	-1
2119	353	339	\N	3	1	0	1	-1
2120	353	395	\N	3	1	0	1	-1
2121	353	415	\N	3	1	0	1	-1
2122	353	430	\N	3	1	0	1	-1
2123	353	513	\N	3	1	0	1	-1
2124	353	557	\N	3	1	0	1	-1
2125	395	3	\N	3	1	0	1	-1
2126	395	40	\N	3	1	0	1	-1
2127	395	45	\N	3	1	0	1	-1
2128	395	92	\N	3	1	0	1	-1
2129	395	104	\N	3	1	0	1	-1
2130	395	118	\N	3	1	0	1	-1
2131	395	150	\N	3	1	0	1	-1
2132	395	164	\N	3	1	0	1	-1
2133	395	339	\N	3	1	0	1	-1
2134	395	353	\N	3	1	0	1	-1
2135	395	415	\N	3	1	0	1	-1
2136	395	430	\N	3	1	0	1	-1
2137	395	513	\N	3	1	0	1	-1
2138	395	557	\N	3	1	0	1	-1
2139	415	3	\N	3	1	0	1	-1
2140	415	40	\N	3	1	0	1	-1
2141	415	45	\N	3	1	0	1	-1
2142	415	92	\N	3	1	0	1	-1
2143	415	104	\N	3	1	0	1	-1
2144	415	118	\N	3	1	0	1	-1
2145	415	150	\N	3	1	0	1	-1
2146	415	164	\N	3	1	0	1	-1
2147	415	339	\N	3	1	0	1	-1
2148	415	353	\N	3	1	0	1	-1
2149	415	395	\N	3	1	0	1	-1
2150	415	430	\N	3	1	0	1	-1
2151	415	513	\N	3	1	0	1	-1
2152	415	557	\N	3	1	0	1	-1
2153	430	3	\N	3	1	0	1	-1
2154	430	40	\N	3	1	0	1	-1
2155	430	45	\N	3	1	0	1	-1
2156	430	92	\N	3	1	0	1	-1
2157	430	104	\N	3	1	0	1	-1
2158	430	118	\N	3	1	0	1	-1
2159	430	150	\N	3	1	0	1	-1
2160	430	164	\N	3	1	0	1	-1
2161	430	339	\N	3	1	0	1	-1
2162	430	353	\N	3	1	0	1	-1
2163	430	395	\N	3	1	0	1	-1
2164	430	415	\N	3	1	0	1	-1
2165	430	513	\N	3	1	0	1	-1
2166	430	557	\N	3	1	0	1	-1
2167	513	3	\N	3	1	0	1	-1
2168	513	40	\N	3	1	0	1	-1
2169	513	45	\N	3	1	0	1	-1
2170	513	92	\N	3	1	0	1	-1
2171	513	104	\N	3	1	0	1	-1
2172	513	118	\N	3	1	0	1	-1
2173	513	150	\N	3	1	0	1	-1
2174	513	164	\N	3	1	0	1	-1
2175	513	339	\N	3	1	0	1	-1
2176	513	353	\N	3	1	0	1	-1
2177	513	395	\N	3	1	0	1	-1
2178	513	415	\N	3	1	0	1	-1
2179	513	430	\N	3	1	0	1	-1
2180	513	557	\N	3	1	0	1	-1
2181	557	3	\N	3	1	0	1	-1
2182	557	40	\N	3	1	0	1	-1
2183	557	45	\N	3	1	0	1	-1
2184	557	92	\N	3	1	0	1	-1
2185	557	104	\N	3	1	0	1	-1
2186	557	118	\N	3	1	0	1	-1
2187	557	150	\N	3	1	0	1	-1
2188	557	164	\N	3	1	0	1	-1
2189	557	339	\N	3	1	0	1	-1
2190	557	353	\N	3	1	0	1	-1
2191	557	395	\N	3	1	0	1	-1
2192	557	415	\N	3	1	0	1	-1
2193	557	430	\N	3	1	0	1	-1
2194	557	513	\N	3	1	0	1	-1
2195	4	39	\N	3	1	0	1	-1
2196	4	46	\N	3	1	0	1	-1
2197	4	91	\N	3	1	0	1	-1
2198	4	105	\N	3	1	0	1	-1
2199	4	117	\N	3	1	0	1	-1
2200	4	151	\N	3	1	0	1	-1
2201	4	163	\N	3	1	0	1	-1
2202	4	340	\N	3	1	0	1	-1
2203	4	352	\N	3	1	0	1	-1
2204	4	382	\N	3	1	0	1	-1
2205	4	394	\N	3	1	0	1	-1
2206	4	414	\N	3	1	0	1	-1
2207	4	431	\N	3	1	0	1	-1
2208	4	514	\N	3	1	0	1	-1
2209	4	556	\N	3	1	0	1	-1
2210	4	692	\N	3	1	0	1	-1
2211	4	725	\N	3	1	0	1	-1
2212	39	4	\N	3	1	0	1	-1
2213	39	46	\N	3	1	0	1	-1
2214	39	91	\N	3	1	0	1	-1
2215	39	105	\N	3	1	0	1	-1
2216	39	117	\N	3	1	0	1	-1
2217	39	151	\N	3	1	0	1	-1
2218	39	163	\N	3	1	0	1	-1
2219	39	340	\N	3	1	0	1	-1
2220	39	352	\N	3	1	0	1	-1
2221	39	382	\N	3	1	0	1	-1
2222	39	394	\N	3	1	0	1	-1
2223	39	414	\N	3	1	0	1	-1
2224	39	431	\N	3	1	0	1	-1
2225	39	514	\N	3	1	0	1	-1
2226	39	556	\N	3	1	0	1	-1
2227	39	692	\N	3	1	0	1	-1
2228	39	725	\N	3	1	0	1	-1
2229	46	4	\N	3	1	0	1	-1
2230	46	39	\N	3	1	0	1	-1
2231	46	91	\N	3	1	0	1	-1
2232	46	105	\N	3	1	0	1	-1
2233	46	117	\N	3	1	0	1	-1
2234	46	151	\N	3	1	0	1	-1
2235	46	163	\N	3	1	0	1	-1
2236	46	340	\N	3	1	0	1	-1
2237	46	352	\N	3	1	0	1	-1
2238	46	382	\N	3	1	0	1	-1
2239	46	394	\N	3	1	0	1	-1
2240	46	414	\N	3	1	0	1	-1
2241	46	431	\N	3	1	0	1	-1
2242	46	514	\N	3	1	0	1	-1
2243	46	556	\N	3	1	0	1	-1
2244	46	692	\N	3	1	0	1	-1
2245	46	725	\N	3	1	0	1	-1
2246	91	4	\N	3	1	0	1	-1
2247	91	39	\N	3	1	0	1	-1
2248	91	46	\N	3	1	0	1	-1
2249	91	105	\N	3	1	0	1	-1
2250	91	117	\N	3	1	0	1	-1
2251	91	151	\N	3	1	0	1	-1
2252	91	163	\N	3	1	0	1	-1
2253	91	340	\N	3	1	0	1	-1
2254	91	352	\N	3	1	0	1	-1
2255	91	382	\N	3	1	0	1	-1
2256	91	394	\N	3	1	0	1	-1
2257	91	414	\N	3	1	0	1	-1
2258	91	431	\N	3	1	0	1	-1
2259	91	514	\N	3	1	0	1	-1
2260	91	556	\N	3	1	0	1	-1
2261	91	692	\N	3	1	0	1	-1
2262	91	725	\N	3	1	0	1	-1
2263	105	4	\N	3	1	0	1	-1
2264	105	39	\N	3	1	0	1	-1
2265	105	46	\N	3	1	0	1	-1
2266	105	91	\N	3	1	0	1	-1
2267	105	117	\N	3	1	0	1	-1
2268	105	151	\N	3	1	0	1	-1
2269	105	163	\N	3	1	0	1	-1
2270	105	340	\N	3	1	0	1	-1
2271	105	352	\N	3	1	0	1	-1
2272	105	382	\N	3	1	0	1	-1
2273	105	394	\N	3	1	0	1	-1
2274	105	414	\N	3	1	0	1	-1
2275	105	431	\N	3	1	0	1	-1
2276	105	514	\N	3	1	0	1	-1
2277	105	556	\N	3	1	0	1	-1
2278	105	692	\N	3	1	0	1	-1
2279	105	725	\N	3	1	0	1	-1
2280	117	4	\N	3	1	0	1	-1
2281	117	39	\N	3	1	0	1	-1
2282	117	46	\N	3	1	0	1	-1
2283	117	91	\N	3	1	0	1	-1
2284	117	105	\N	3	1	0	1	-1
2285	117	151	\N	3	1	0	1	-1
2286	117	163	\N	3	1	0	1	-1
2287	117	340	\N	3	1	0	1	-1
2288	117	352	\N	3	1	0	1	-1
2289	117	382	\N	3	1	0	1	-1
2290	117	394	\N	3	1	0	1	-1
2291	117	414	\N	3	1	0	1	-1
2292	117	431	\N	3	1	0	1	-1
2293	117	514	\N	3	1	0	1	-1
2294	117	556	\N	3	1	0	1	-1
2295	117	692	\N	3	1	0	1	-1
2296	117	725	\N	3	1	0	1	-1
2297	151	4	\N	3	1	0	1	-1
2298	151	39	\N	3	1	0	1	-1
2299	151	46	\N	3	1	0	1	-1
2300	151	91	\N	3	1	0	1	-1
2301	151	105	\N	3	1	0	1	-1
2302	151	117	\N	3	1	0	1	-1
2303	151	163	\N	3	1	0	1	-1
2304	151	340	\N	3	1	0	1	-1
2305	151	352	\N	3	1	0	1	-1
2306	151	382	\N	3	1	0	1	-1
2307	151	394	\N	3	1	0	1	-1
2308	151	414	\N	3	1	0	1	-1
2309	151	431	\N	3	1	0	1	-1
2310	151	514	\N	3	1	0	1	-1
2311	151	556	\N	3	1	0	1	-1
2312	151	692	\N	3	1	0	1	-1
2313	151	725	\N	3	1	0	1	-1
2314	163	4	\N	3	1	0	1	-1
2315	163	39	\N	3	1	0	1	-1
2316	163	46	\N	3	1	0	1	-1
2317	163	91	\N	3	1	0	1	-1
2318	163	105	\N	3	1	0	1	-1
2319	163	117	\N	3	1	0	1	-1
2320	163	151	\N	3	1	0	1	-1
2321	163	340	\N	3	1	0	1	-1
2322	163	352	\N	3	1	0	1	-1
2323	163	382	\N	3	1	0	1	-1
2324	163	394	\N	3	1	0	1	-1
2325	163	414	\N	3	1	0	1	-1
2326	163	431	\N	3	1	0	1	-1
2327	163	514	\N	3	1	0	1	-1
2328	163	556	\N	3	1	0	1	-1
2329	163	692	\N	3	1	0	1	-1
2330	163	725	\N	3	1	0	1	-1
2331	340	4	\N	3	1	0	1	-1
2332	340	39	\N	3	1	0	1	-1
2333	340	46	\N	3	1	0	1	-1
2334	340	91	\N	3	1	0	1	-1
2335	340	105	\N	3	1	0	1	-1
2336	340	117	\N	3	1	0	1	-1
2337	340	151	\N	3	1	0	1	-1
2338	340	163	\N	3	1	0	1	-1
2339	340	352	\N	3	1	0	1	-1
2340	340	382	\N	3	1	0	1	-1
2341	340	394	\N	3	1	0	1	-1
2342	340	414	\N	3	1	0	1	-1
2343	340	431	\N	3	1	0	1	-1
2344	340	514	\N	3	1	0	1	-1
2345	340	556	\N	3	1	0	1	-1
2346	340	692	\N	3	1	0	1	-1
2347	340	725	\N	3	1	0	1	-1
2348	352	4	\N	3	1	0	1	-1
2349	352	39	\N	3	1	0	1	-1
2350	352	46	\N	3	1	0	1	-1
2351	352	91	\N	3	1	0	1	-1
2352	352	105	\N	3	1	0	1	-1
2353	352	117	\N	3	1	0	1	-1
2354	352	151	\N	3	1	0	1	-1
2355	352	163	\N	3	1	0	1	-1
2356	352	340	\N	3	1	0	1	-1
2357	352	382	\N	3	1	0	1	-1
2358	352	394	\N	3	1	0	1	-1
2359	352	414	\N	3	1	0	1	-1
2360	352	431	\N	3	1	0	1	-1
2361	352	514	\N	3	1	0	1	-1
2362	352	556	\N	3	1	0	1	-1
2363	352	692	\N	3	1	0	1	-1
2364	352	725	\N	3	1	0	1	-1
2365	382	4	\N	3	1	0	1	-1
2366	382	39	\N	3	1	0	1	-1
2367	382	46	\N	3	1	0	1	-1
2368	382	91	\N	3	1	0	1	-1
2369	382	105	\N	3	1	0	1	-1
2370	382	117	\N	3	1	0	1	-1
2371	382	151	\N	3	1	0	1	-1
2372	382	163	\N	3	1	0	1	-1
2373	382	340	\N	3	1	0	1	-1
2374	382	352	\N	3	1	0	1	-1
2375	382	394	\N	3	1	0	1	-1
2376	382	414	\N	3	1	0	1	-1
2377	382	431	\N	3	1	0	1	-1
2378	382	514	\N	3	1	0	1	-1
2379	382	556	\N	3	1	0	1	-1
2380	382	692	\N	3	1	0	1	-1
2381	382	725	\N	3	1	0	1	-1
2382	394	4	\N	3	1	0	1	-1
2383	394	39	\N	3	1	0	1	-1
2384	394	46	\N	3	1	0	1	-1
2385	394	91	\N	3	1	0	1	-1
2386	394	105	\N	3	1	0	1	-1
2387	394	117	\N	3	1	0	1	-1
2388	394	151	\N	3	1	0	1	-1
2389	394	163	\N	3	1	0	1	-1
2390	394	340	\N	3	1	0	1	-1
2391	394	352	\N	3	1	0	1	-1
2392	394	382	\N	3	1	0	1	-1
2393	394	414	\N	3	1	0	1	-1
2394	394	431	\N	3	1	0	1	-1
2395	394	514	\N	3	1	0	1	-1
2396	394	556	\N	3	1	0	1	-1
2397	394	692	\N	3	1	0	1	-1
2398	394	725	\N	3	1	0	1	-1
2399	414	4	\N	3	1	0	1	-1
2400	414	39	\N	3	1	0	1	-1
2401	414	46	\N	3	1	0	1	-1
2402	414	91	\N	3	1	0	1	-1
2403	414	105	\N	3	1	0	1	-1
2404	414	117	\N	3	1	0	1	-1
2405	414	151	\N	3	1	0	1	-1
2406	414	163	\N	3	1	0	1	-1
2407	414	340	\N	3	1	0	1	-1
2408	414	352	\N	3	1	0	1	-1
2409	414	382	\N	3	1	0	1	-1
2410	414	394	\N	3	1	0	1	-1
2411	414	431	\N	3	1	0	1	-1
2412	414	514	\N	3	1	0	1	-1
2413	414	556	\N	3	1	0	1	-1
2414	414	692	\N	3	1	0	1	-1
2415	414	725	\N	3	1	0	1	-1
2416	431	4	\N	3	1	0	1	-1
2417	431	39	\N	3	1	0	1	-1
2418	431	46	\N	3	1	0	1	-1
2419	431	91	\N	3	1	0	1	-1
2420	431	105	\N	3	1	0	1	-1
2421	431	117	\N	3	1	0	1	-1
2422	431	151	\N	3	1	0	1	-1
2423	431	163	\N	3	1	0	1	-1
2424	431	340	\N	3	1	0	1	-1
2425	431	352	\N	3	1	0	1	-1
2426	431	382	\N	3	1	0	1	-1
2427	431	394	\N	3	1	0	1	-1
2428	431	414	\N	3	1	0	1	-1
2429	431	514	\N	3	1	0	1	-1
2430	431	556	\N	3	1	0	1	-1
2431	431	692	\N	3	1	0	1	-1
2432	431	725	\N	3	1	0	1	-1
2433	514	4	\N	3	1	0	1	-1
2434	514	39	\N	3	1	0	1	-1
2435	514	46	\N	3	1	0	1	-1
2436	514	91	\N	3	1	0	1	-1
2437	514	105	\N	3	1	0	1	-1
2438	514	117	\N	3	1	0	1	-1
2439	514	151	\N	3	1	0	1	-1
2440	514	163	\N	3	1	0	1	-1
2441	514	340	\N	3	1	0	1	-1
2442	514	352	\N	3	1	0	1	-1
2443	514	382	\N	3	1	0	1	-1
2444	514	394	\N	3	1	0	1	-1
2445	514	414	\N	3	1	0	1	-1
2446	514	431	\N	3	1	0	1	-1
2447	514	556	\N	3	1	0	1	-1
2448	514	692	\N	3	1	0	1	-1
2449	514	725	\N	3	1	0	1	-1
2450	556	4	\N	3	1	0	1	-1
2451	556	39	\N	3	1	0	1	-1
2452	556	46	\N	3	1	0	1	-1
2453	556	91	\N	3	1	0	1	-1
2454	556	105	\N	3	1	0	1	-1
2455	556	117	\N	3	1	0	1	-1
2456	556	151	\N	3	1	0	1	-1
2457	556	163	\N	3	1	0	1	-1
2458	556	340	\N	3	1	0	1	-1
2459	556	352	\N	3	1	0	1	-1
2460	556	382	\N	3	1	0	1	-1
2461	556	394	\N	3	1	0	1	-1
2462	556	414	\N	3	1	0	1	-1
2463	556	431	\N	3	1	0	1	-1
2464	556	514	\N	3	1	0	1	-1
2465	556	692	\N	3	1	0	1	-1
2466	556	725	\N	3	1	0	1	-1
2467	692	4	\N	3	1	0	1	-1
2468	692	39	\N	3	1	0	1	-1
2469	692	46	\N	3	1	0	1	-1
2470	692	91	\N	3	1	0	1	-1
2471	692	105	\N	3	1	0	1	-1
2472	692	117	\N	3	1	0	1	-1
2473	692	151	\N	3	1	0	1	-1
2474	692	163	\N	3	1	0	1	-1
2475	692	340	\N	3	1	0	1	-1
2476	692	352	\N	3	1	0	1	-1
2477	692	382	\N	3	1	0	1	-1
2478	692	394	\N	3	1	0	1	-1
2479	692	414	\N	3	1	0	1	-1
2480	692	431	\N	3	1	0	1	-1
2481	692	514	\N	3	1	0	1	-1
2482	692	556	\N	3	1	0	1	-1
2483	692	725	\N	3	1	0	1	-1
2484	725	4	\N	3	1	0	1	-1
2485	725	39	\N	3	1	0	1	-1
2486	725	46	\N	3	1	0	1	-1
2487	725	91	\N	3	1	0	1	-1
2488	725	105	\N	3	1	0	1	-1
2489	725	117	\N	3	1	0	1	-1
2490	725	151	\N	3	1	0	1	-1
2491	725	163	\N	3	1	0	1	-1
2492	725	340	\N	3	1	0	1	-1
2493	725	352	\N	3	1	0	1	-1
2494	725	382	\N	3	1	0	1	-1
2495	725	394	\N	3	1	0	1	-1
2496	725	414	\N	3	1	0	1	-1
2497	725	431	\N	3	1	0	1	-1
2498	725	514	\N	3	1	0	1	-1
2499	725	556	\N	3	1	0	1	-1
2500	725	692	\N	3	1	0	1	-1
2501	5	38	\N	3	1	0	1	-1
2502	5	47	\N	3	1	0	1	-1
2503	5	90	\N	3	1	0	1	-1
2504	5	106	\N	3	1	0	1	-1
2505	5	116	\N	3	1	0	1	-1
2506	5	152	\N	3	1	0	1	-1
2507	5	162	\N	3	1	0	1	-1
2508	5	341	\N	3	1	0	1	-1
2509	5	351	\N	3	1	0	1	-1
2510	5	383	\N	3	1	0	1	-1
2511	5	393	\N	3	1	0	1	-1
2512	5	413	\N	3	1	0	1	-1
2513	5	432	\N	3	1	0	1	-1
2514	5	515	\N	3	1	0	1	-1
2515	5	555	\N	3	1	0	1	-1
2516	5	691	\N	3	1	0	1	-1
2517	5	726	\N	3	1	0	1	-1
2518	5	739	\N	3	1	0	1	-1
2519	38	5	\N	3	1	0	1	-1
2520	38	47	\N	3	1	0	1	-1
2521	38	90	\N	3	1	0	1	-1
2522	38	106	\N	3	1	0	1	-1
2523	38	116	\N	3	1	0	1	-1
2524	38	152	\N	3	1	0	1	-1
2525	38	162	\N	3	1	0	1	-1
2526	38	341	\N	3	1	0	1	-1
2527	38	351	\N	3	1	0	1	-1
2528	38	383	\N	3	1	0	1	-1
2529	38	393	\N	3	1	0	1	-1
2530	38	413	\N	3	1	0	1	-1
2531	38	432	\N	3	1	0	1	-1
2532	38	515	\N	3	1	0	1	-1
2533	38	555	\N	3	1	0	1	-1
2534	38	691	\N	3	1	0	1	-1
2535	38	726	\N	3	1	0	1	-1
2536	38	739	\N	3	1	0	1	-1
2537	47	5	\N	3	1	0	1	-1
2538	47	38	\N	3	1	0	1	-1
2539	47	90	\N	3	1	0	1	-1
2540	47	106	\N	3	1	0	1	-1
2541	47	116	\N	3	1	0	1	-1
2542	47	152	\N	3	1	0	1	-1
2543	47	162	\N	3	1	0	1	-1
2544	47	341	\N	3	1	0	1	-1
2545	47	351	\N	3	1	0	1	-1
2546	47	383	\N	3	1	0	1	-1
2547	47	393	\N	3	1	0	1	-1
2548	47	413	\N	3	1	0	1	-1
2549	47	432	\N	3	1	0	1	-1
2550	47	515	\N	3	1	0	1	-1
2551	47	555	\N	3	1	0	1	-1
2552	47	691	\N	3	1	0	1	-1
2553	47	726	\N	3	1	0	1	-1
2554	47	739	\N	3	1	0	1	-1
2555	90	5	\N	3	1	0	1	-1
2556	90	38	\N	3	1	0	1	-1
2557	90	47	\N	3	1	0	1	-1
2558	90	106	\N	3	1	0	1	-1
2559	90	116	\N	3	1	0	1	-1
2560	90	152	\N	3	1	0	1	-1
2561	90	162	\N	3	1	0	1	-1
2562	90	341	\N	3	1	0	1	-1
2563	90	351	\N	3	1	0	1	-1
2564	90	383	\N	3	1	0	1	-1
2565	90	393	\N	3	1	0	1	-1
2566	90	413	\N	3	1	0	1	-1
2567	90	432	\N	3	1	0	1	-1
2568	90	515	\N	3	1	0	1	-1
2569	90	555	\N	3	1	0	1	-1
2570	90	691	\N	3	1	0	1	-1
2571	90	726	\N	3	1	0	1	-1
2572	90	739	\N	3	1	0	1	-1
2573	106	5	\N	3	1	0	1	-1
2574	106	38	\N	3	1	0	1	-1
2575	106	47	\N	3	1	0	1	-1
2576	106	90	\N	3	1	0	1	-1
2577	106	116	\N	3	1	0	1	-1
2578	106	152	\N	3	1	0	1	-1
2579	106	162	\N	3	1	0	1	-1
2580	106	341	\N	3	1	0	1	-1
2581	106	351	\N	3	1	0	1	-1
2582	106	383	\N	3	1	0	1	-1
2583	106	393	\N	3	1	0	1	-1
2584	106	413	\N	3	1	0	1	-1
2585	106	432	\N	3	1	0	1	-1
2586	106	515	\N	3	1	0	1	-1
2587	106	555	\N	3	1	0	1	-1
2588	106	691	\N	3	1	0	1	-1
2589	106	726	\N	3	1	0	1	-1
2590	106	739	\N	3	1	0	1	-1
2591	116	5	\N	3	1	0	1	-1
2592	116	38	\N	3	1	0	1	-1
2593	116	47	\N	3	1	0	1	-1
2594	116	90	\N	3	1	0	1	-1
2595	116	106	\N	3	1	0	1	-1
2596	116	152	\N	3	1	0	1	-1
2597	116	162	\N	3	1	0	1	-1
2598	116	341	\N	3	1	0	1	-1
2599	116	351	\N	3	1	0	1	-1
2600	116	383	\N	3	1	0	1	-1
2601	116	393	\N	3	1	0	1	-1
2602	116	413	\N	3	1	0	1	-1
2603	116	432	\N	3	1	0	1	-1
2604	116	515	\N	3	1	0	1	-1
2605	116	555	\N	3	1	0	1	-1
2606	116	691	\N	3	1	0	1	-1
2607	116	726	\N	3	1	0	1	-1
2608	116	739	\N	3	1	0	1	-1
2609	152	5	\N	3	1	0	1	-1
2610	152	38	\N	3	1	0	1	-1
2611	152	47	\N	3	1	0	1	-1
2612	152	90	\N	3	1	0	1	-1
2613	152	106	\N	3	1	0	1	-1
2614	152	116	\N	3	1	0	1	-1
2615	152	162	\N	3	1	0	1	-1
2616	152	341	\N	3	1	0	1	-1
2617	152	351	\N	3	1	0	1	-1
2618	152	383	\N	3	1	0	1	-1
2619	152	393	\N	3	1	0	1	-1
2620	152	413	\N	3	1	0	1	-1
2621	152	432	\N	3	1	0	1	-1
2622	152	515	\N	3	1	0	1	-1
2623	152	555	\N	3	1	0	1	-1
2624	152	691	\N	3	1	0	1	-1
2625	152	726	\N	3	1	0	1	-1
2626	152	739	\N	3	1	0	1	-1
2627	162	5	\N	3	1	0	1	-1
2628	162	38	\N	3	1	0	1	-1
2629	162	47	\N	3	1	0	1	-1
2630	162	90	\N	3	1	0	1	-1
2631	162	106	\N	3	1	0	1	-1
2632	162	116	\N	3	1	0	1	-1
2633	162	152	\N	3	1	0	1	-1
2634	162	341	\N	3	1	0	1	-1
2635	162	351	\N	3	1	0	1	-1
2636	162	383	\N	3	1	0	1	-1
2637	162	393	\N	3	1	0	1	-1
2638	162	413	\N	3	1	0	1	-1
2639	162	432	\N	3	1	0	1	-1
2640	162	515	\N	3	1	0	1	-1
2641	162	555	\N	3	1	0	1	-1
2642	162	691	\N	3	1	0	1	-1
2643	162	726	\N	3	1	0	1	-1
2644	162	739	\N	3	1	0	1	-1
2645	341	5	\N	3	1	0	1	-1
2646	341	38	\N	3	1	0	1	-1
2647	341	47	\N	3	1	0	1	-1
2648	341	90	\N	3	1	0	1	-1
2649	341	106	\N	3	1	0	1	-1
2650	341	116	\N	3	1	0	1	-1
2651	341	152	\N	3	1	0	1	-1
2652	341	162	\N	3	1	0	1	-1
2653	341	351	\N	3	1	0	1	-1
2654	341	383	\N	3	1	0	1	-1
2655	341	393	\N	3	1	0	1	-1
2656	341	413	\N	3	1	0	1	-1
2657	341	432	\N	3	1	0	1	-1
2658	341	515	\N	3	1	0	1	-1
2659	341	555	\N	3	1	0	1	-1
2660	341	691	\N	3	1	0	1	-1
2661	341	726	\N	3	1	0	1	-1
2662	341	739	\N	3	1	0	1	-1
2663	351	5	\N	3	1	0	1	-1
2664	351	38	\N	3	1	0	1	-1
2665	351	47	\N	3	1	0	1	-1
2666	351	90	\N	3	1	0	1	-1
2667	351	106	\N	3	1	0	1	-1
2668	351	116	\N	3	1	0	1	-1
2669	351	152	\N	3	1	0	1	-1
2670	351	162	\N	3	1	0	1	-1
2671	351	341	\N	3	1	0	1	-1
2672	351	383	\N	3	1	0	1	-1
2673	351	393	\N	3	1	0	1	-1
2674	351	413	\N	3	1	0	1	-1
2675	351	432	\N	3	1	0	1	-1
2676	351	515	\N	3	1	0	1	-1
2677	351	555	\N	3	1	0	1	-1
2678	351	691	\N	3	1	0	1	-1
2679	351	726	\N	3	1	0	1	-1
2680	351	739	\N	3	1	0	1	-1
2681	383	5	\N	3	1	0	1	-1
2682	383	38	\N	3	1	0	1	-1
2683	383	47	\N	3	1	0	1	-1
2684	383	90	\N	3	1	0	1	-1
2685	383	106	\N	3	1	0	1	-1
2686	383	116	\N	3	1	0	1	-1
2687	383	152	\N	3	1	0	1	-1
2688	383	162	\N	3	1	0	1	-1
2689	383	341	\N	3	1	0	1	-1
2690	383	351	\N	3	1	0	1	-1
2691	383	393	\N	3	1	0	1	-1
2692	383	413	\N	3	1	0	1	-1
2693	383	432	\N	3	1	0	1	-1
2694	383	515	\N	3	1	0	1	-1
2695	383	555	\N	3	1	0	1	-1
2696	383	691	\N	3	1	0	1	-1
2697	383	726	\N	3	1	0	1	-1
2698	383	739	\N	3	1	0	1	-1
2699	393	5	\N	3	1	0	1	-1
2700	393	38	\N	3	1	0	1	-1
2701	393	47	\N	3	1	0	1	-1
2702	393	90	\N	3	1	0	1	-1
2703	393	106	\N	3	1	0	1	-1
2704	393	116	\N	3	1	0	1	-1
2705	393	152	\N	3	1	0	1	-1
2706	393	162	\N	3	1	0	1	-1
2707	393	341	\N	3	1	0	1	-1
2708	393	351	\N	3	1	0	1	-1
2709	393	383	\N	3	1	0	1	-1
2710	393	413	\N	3	1	0	1	-1
2711	393	432	\N	3	1	0	1	-1
2712	393	515	\N	3	1	0	1	-1
2713	393	555	\N	3	1	0	1	-1
2714	393	691	\N	3	1	0	1	-1
2715	393	726	\N	3	1	0	1	-1
2716	393	739	\N	3	1	0	1	-1
2717	413	5	\N	3	1	0	1	-1
2718	413	38	\N	3	1	0	1	-1
2719	413	47	\N	3	1	0	1	-1
2720	413	90	\N	3	1	0	1	-1
2721	413	106	\N	3	1	0	1	-1
2722	413	116	\N	3	1	0	1	-1
2723	413	152	\N	3	1	0	1	-1
2724	413	162	\N	3	1	0	1	-1
2725	413	341	\N	3	1	0	1	-1
2726	413	351	\N	3	1	0	1	-1
2727	413	383	\N	3	1	0	1	-1
2728	413	393	\N	3	1	0	1	-1
2729	413	432	\N	3	1	0	1	-1
2730	413	515	\N	3	1	0	1	-1
2731	413	555	\N	3	1	0	1	-1
2732	413	691	\N	3	1	0	1	-1
2733	413	726	\N	3	1	0	1	-1
2734	413	739	\N	3	1	0	1	-1
2735	432	5	\N	3	1	0	1	-1
2736	432	38	\N	3	1	0	1	-1
2737	432	47	\N	3	1	0	1	-1
2738	432	90	\N	3	1	0	1	-1
2739	432	106	\N	3	1	0	1	-1
2740	432	116	\N	3	1	0	1	-1
2741	432	152	\N	3	1	0	1	-1
2742	432	162	\N	3	1	0	1	-1
2743	432	341	\N	3	1	0	1	-1
2744	432	351	\N	3	1	0	1	-1
2745	432	383	\N	3	1	0	1	-1
2746	432	393	\N	3	1	0	1	-1
2747	432	413	\N	3	1	0	1	-1
2748	432	515	\N	3	1	0	1	-1
2749	432	555	\N	3	1	0	1	-1
2750	432	691	\N	3	1	0	1	-1
2751	432	726	\N	3	1	0	1	-1
2752	432	739	\N	3	1	0	1	-1
2753	515	5	\N	3	1	0	1	-1
2754	515	38	\N	3	1	0	1	-1
2755	515	47	\N	3	1	0	1	-1
2756	515	90	\N	3	1	0	1	-1
2757	515	106	\N	3	1	0	1	-1
2758	515	116	\N	3	1	0	1	-1
2759	515	152	\N	3	1	0	1	-1
2760	515	162	\N	3	1	0	1	-1
2761	515	341	\N	3	1	0	1	-1
2762	515	351	\N	3	1	0	1	-1
2763	515	383	\N	3	1	0	1	-1
2764	515	393	\N	3	1	0	1	-1
2765	515	413	\N	3	1	0	1	-1
2766	515	432	\N	3	1	0	1	-1
2767	515	555	\N	3	1	0	1	-1
2768	515	691	\N	3	1	0	1	-1
2769	515	726	\N	3	1	0	1	-1
2770	515	739	\N	3	1	0	1	-1
2771	555	5	\N	3	1	0	1	-1
2772	555	38	\N	3	1	0	1	-1
2773	555	47	\N	3	1	0	1	-1
2774	555	90	\N	3	1	0	1	-1
2775	555	106	\N	3	1	0	1	-1
2776	555	116	\N	3	1	0	1	-1
2777	555	152	\N	3	1	0	1	-1
2778	555	162	\N	3	1	0	1	-1
2779	555	341	\N	3	1	0	1	-1
2780	555	351	\N	3	1	0	1	-1
2781	555	383	\N	3	1	0	1	-1
2782	555	393	\N	3	1	0	1	-1
2783	555	413	\N	3	1	0	1	-1
2784	555	432	\N	3	1	0	1	-1
2785	555	515	\N	3	1	0	1	-1
2786	555	691	\N	3	1	0	1	-1
2787	555	726	\N	3	1	0	1	-1
2788	555	739	\N	3	1	0	1	-1
2789	691	5	\N	3	1	0	1	-1
2790	691	38	\N	3	1	0	1	-1
2791	691	47	\N	3	1	0	1	-1
2792	691	90	\N	3	1	0	1	-1
2793	691	106	\N	3	1	0	1	-1
2794	691	116	\N	3	1	0	1	-1
2795	691	152	\N	3	1	0	1	-1
2796	691	162	\N	3	1	0	1	-1
2797	691	341	\N	3	1	0	1	-1
2798	691	351	\N	3	1	0	1	-1
2799	691	383	\N	3	1	0	1	-1
2800	691	393	\N	3	1	0	1	-1
2801	691	413	\N	3	1	0	1	-1
2802	691	432	\N	3	1	0	1	-1
2803	691	515	\N	3	1	0	1	-1
2804	691	555	\N	3	1	0	1	-1
2805	691	726	\N	3	1	0	1	-1
2806	691	739	\N	3	1	0	1	-1
2807	726	5	\N	3	1	0	1	-1
2808	726	38	\N	3	1	0	1	-1
2809	726	47	\N	3	1	0	1	-1
2810	726	90	\N	3	1	0	1	-1
2811	726	106	\N	3	1	0	1	-1
2812	726	116	\N	3	1	0	1	-1
2813	726	152	\N	3	1	0	1	-1
2814	726	162	\N	3	1	0	1	-1
2815	726	341	\N	3	1	0	1	-1
2816	726	351	\N	3	1	0	1	-1
2817	726	383	\N	3	1	0	1	-1
2818	726	393	\N	3	1	0	1	-1
2819	726	413	\N	3	1	0	1	-1
2820	726	432	\N	3	1	0	1	-1
2821	726	515	\N	3	1	0	1	-1
2822	726	555	\N	3	1	0	1	-1
2823	726	691	\N	3	1	0	1	-1
2824	726	739	\N	3	1	0	1	-1
2825	739	5	\N	3	1	0	1	-1
2826	739	38	\N	3	1	0	1	-1
2827	739	47	\N	3	1	0	1	-1
2828	739	90	\N	3	1	0	1	-1
2829	739	106	\N	3	1	0	1	-1
2830	739	116	\N	3	1	0	1	-1
2831	739	152	\N	3	1	0	1	-1
2832	739	162	\N	3	1	0	1	-1
2833	739	341	\N	3	1	0	1	-1
2834	739	351	\N	3	1	0	1	-1
2835	739	383	\N	3	1	0	1	-1
2836	739	393	\N	3	1	0	1	-1
2837	739	413	\N	3	1	0	1	-1
2838	739	432	\N	3	1	0	1	-1
2839	739	515	\N	3	1	0	1	-1
2840	739	555	\N	3	1	0	1	-1
2841	739	691	\N	3	1	0	1	-1
2842	739	726	\N	3	1	0	1	-1
2843	6	37	\N	3	1	0	1	-1
2844	6	48	\N	3	1	0	1	-1
2845	6	89	\N	3	1	0	1	-1
2846	6	107	\N	3	1	0	1	-1
2847	6	115	\N	3	1	0	1	-1
2848	6	153	\N	3	1	0	1	-1
2849	6	161	\N	3	1	0	1	-1
2850	6	342	\N	3	1	0	1	-1
2851	6	350	\N	3	1	0	1	-1
2852	6	384	\N	3	1	0	1	-1
2853	6	392	\N	3	1	0	1	-1
2854	6	412	\N	3	1	0	1	-1
2855	6	433	\N	3	1	0	1	-1
2856	6	516	\N	3	1	0	1	-1
2857	6	554	\N	3	1	0	1	-1
2858	6	690	\N	3	1	0	1	-1
2859	6	727	\N	3	1	0	1	-1
2860	6	740	\N	3	1	0	1	-1
2861	37	6	\N	3	1	0	1	-1
2862	37	48	\N	3	1	0	1	-1
2863	37	89	\N	3	1	0	1	-1
2864	37	107	\N	3	1	0	1	-1
2865	37	115	\N	3	1	0	1	-1
2866	37	153	\N	3	1	0	1	-1
2867	37	161	\N	3	1	0	1	-1
2868	37	342	\N	3	1	0	1	-1
2869	37	350	\N	3	1	0	1	-1
2870	37	384	\N	3	1	0	1	-1
2871	37	392	\N	3	1	0	1	-1
2872	37	412	\N	3	1	0	1	-1
2873	37	433	\N	3	1	0	1	-1
2874	37	516	\N	3	1	0	1	-1
2875	37	554	\N	3	1	0	1	-1
2876	37	690	\N	3	1	0	1	-1
2877	37	727	\N	3	1	0	1	-1
2878	37	740	\N	3	1	0	1	-1
2879	48	6	\N	3	1	0	1	-1
2880	48	37	\N	3	1	0	1	-1
2881	48	89	\N	3	1	0	1	-1
2882	48	107	\N	3	1	0	1	-1
2883	48	115	\N	3	1	0	1	-1
2884	48	153	\N	3	1	0	1	-1
2885	48	161	\N	3	1	0	1	-1
2886	48	342	\N	3	1	0	1	-1
2887	48	350	\N	3	1	0	1	-1
2888	48	384	\N	3	1	0	1	-1
2889	48	392	\N	3	1	0	1	-1
2890	48	412	\N	3	1	0	1	-1
2891	48	433	\N	3	1	0	1	-1
2892	48	516	\N	3	1	0	1	-1
2893	48	554	\N	3	1	0	1	-1
2894	48	690	\N	3	1	0	1	-1
2895	48	727	\N	3	1	0	1	-1
2896	48	740	\N	3	1	0	1	-1
2897	89	6	\N	3	1	0	1	-1
2898	89	37	\N	3	1	0	1	-1
2899	89	48	\N	3	1	0	1	-1
2900	89	107	\N	3	1	0	1	-1
2901	89	115	\N	3	1	0	1	-1
2902	89	153	\N	3	1	0	1	-1
2903	89	161	\N	3	1	0	1	-1
2904	89	342	\N	3	1	0	1	-1
2905	89	350	\N	3	1	0	1	-1
2906	89	384	\N	3	1	0	1	-1
2907	89	392	\N	3	1	0	1	-1
2908	89	412	\N	3	1	0	1	-1
2909	89	433	\N	3	1	0	1	-1
2910	89	516	\N	3	1	0	1	-1
2911	89	554	\N	3	1	0	1	-1
2912	89	690	\N	3	1	0	1	-1
2913	89	727	\N	3	1	0	1	-1
2914	89	740	\N	3	1	0	1	-1
2915	107	6	\N	3	1	0	1	-1
2916	107	37	\N	3	1	0	1	-1
2917	107	48	\N	3	1	0	1	-1
2918	107	89	\N	3	1	0	1	-1
2919	107	115	\N	3	1	0	1	-1
2920	107	153	\N	3	1	0	1	-1
2921	107	161	\N	3	1	0	1	-1
2922	107	342	\N	3	1	0	1	-1
2923	107	350	\N	3	1	0	1	-1
2924	107	384	\N	3	1	0	1	-1
2925	107	392	\N	3	1	0	1	-1
2926	107	412	\N	3	1	0	1	-1
2927	107	433	\N	3	1	0	1	-1
2928	107	516	\N	3	1	0	1	-1
2929	107	554	\N	3	1	0	1	-1
2930	107	690	\N	3	1	0	1	-1
2931	107	727	\N	3	1	0	1	-1
2932	107	740	\N	3	1	0	1	-1
2933	115	6	\N	3	1	0	1	-1
2934	115	37	\N	3	1	0	1	-1
2935	115	48	\N	3	1	0	1	-1
2936	115	89	\N	3	1	0	1	-1
2937	115	107	\N	3	1	0	1	-1
2938	115	153	\N	3	1	0	1	-1
2939	115	161	\N	3	1	0	1	-1
2940	115	342	\N	3	1	0	1	-1
2941	115	350	\N	3	1	0	1	-1
2942	115	384	\N	3	1	0	1	-1
2943	115	392	\N	3	1	0	1	-1
2944	115	412	\N	3	1	0	1	-1
2945	115	433	\N	3	1	0	1	-1
2946	115	516	\N	3	1	0	1	-1
2947	115	554	\N	3	1	0	1	-1
2948	115	690	\N	3	1	0	1	-1
2949	115	727	\N	3	1	0	1	-1
2950	115	740	\N	3	1	0	1	-1
2951	153	6	\N	3	1	0	1	-1
2952	153	37	\N	3	1	0	1	-1
2953	153	48	\N	3	1	0	1	-1
2954	153	89	\N	3	1	0	1	-1
2955	153	107	\N	3	1	0	1	-1
2956	153	115	\N	3	1	0	1	-1
2957	153	161	\N	3	1	0	1	-1
2958	153	342	\N	3	1	0	1	-1
2959	153	350	\N	3	1	0	1	-1
2960	153	384	\N	3	1	0	1	-1
2961	153	392	\N	3	1	0	1	-1
2962	153	412	\N	3	1	0	1	-1
2963	153	433	\N	3	1	0	1	-1
2964	153	516	\N	3	1	0	1	-1
2965	153	554	\N	3	1	0	1	-1
2966	153	690	\N	3	1	0	1	-1
2967	153	727	\N	3	1	0	1	-1
2968	153	740	\N	3	1	0	1	-1
2969	161	6	\N	3	1	0	1	-1
2970	161	37	\N	3	1	0	1	-1
2971	161	48	\N	3	1	0	1	-1
2972	161	89	\N	3	1	0	1	-1
2973	161	107	\N	3	1	0	1	-1
2974	161	115	\N	3	1	0	1	-1
2975	161	153	\N	3	1	0	1	-1
2976	161	342	\N	3	1	0	1	-1
2977	161	350	\N	3	1	0	1	-1
2978	161	384	\N	3	1	0	1	-1
2979	161	392	\N	3	1	0	1	-1
2980	161	412	\N	3	1	0	1	-1
2981	161	433	\N	3	1	0	1	-1
2982	161	516	\N	3	1	0	1	-1
2983	161	554	\N	3	1	0	1	-1
2984	161	690	\N	3	1	0	1	-1
2985	161	727	\N	3	1	0	1	-1
2986	161	740	\N	3	1	0	1	-1
2987	342	6	\N	3	1	0	1	-1
2988	342	37	\N	3	1	0	1	-1
2989	342	48	\N	3	1	0	1	-1
2990	342	89	\N	3	1	0	1	-1
2991	342	107	\N	3	1	0	1	-1
2992	342	115	\N	3	1	0	1	-1
2993	342	153	\N	3	1	0	1	-1
2994	342	161	\N	3	1	0	1	-1
2995	342	350	\N	3	1	0	1	-1
2996	342	384	\N	3	1	0	1	-1
2997	342	392	\N	3	1	0	1	-1
2998	342	412	\N	3	1	0	1	-1
2999	342	433	\N	3	1	0	1	-1
3000	342	516	\N	3	1	0	1	-1
3001	342	554	\N	3	1	0	1	-1
3002	342	690	\N	3	1	0	1	-1
3003	342	727	\N	3	1	0	1	-1
3004	342	740	\N	3	1	0	1	-1
3005	350	6	\N	3	1	0	1	-1
3006	350	37	\N	3	1	0	1	-1
3007	350	48	\N	3	1	0	1	-1
3008	350	89	\N	3	1	0	1	-1
3009	350	107	\N	3	1	0	1	-1
3010	350	115	\N	3	1	0	1	-1
3011	350	153	\N	3	1	0	1	-1
3012	350	161	\N	3	1	0	1	-1
3013	350	342	\N	3	1	0	1	-1
3014	350	384	\N	3	1	0	1	-1
3015	350	392	\N	3	1	0	1	-1
3016	350	412	\N	3	1	0	1	-1
3017	350	433	\N	3	1	0	1	-1
3018	350	516	\N	3	1	0	1	-1
3019	350	554	\N	3	1	0	1	-1
3020	350	690	\N	3	1	0	1	-1
3021	350	727	\N	3	1	0	1	-1
3022	350	740	\N	3	1	0	1	-1
3023	384	6	\N	3	1	0	1	-1
3024	384	37	\N	3	1	0	1	-1
3025	384	48	\N	3	1	0	1	-1
3026	384	89	\N	3	1	0	1	-1
3027	384	107	\N	3	1	0	1	-1
3028	384	115	\N	3	1	0	1	-1
3029	384	153	\N	3	1	0	1	-1
3030	384	161	\N	3	1	0	1	-1
3031	384	342	\N	3	1	0	1	-1
3032	384	350	\N	3	1	0	1	-1
3033	384	392	\N	3	1	0	1	-1
3034	384	412	\N	3	1	0	1	-1
3035	384	433	\N	3	1	0	1	-1
3036	384	516	\N	3	1	0	1	-1
3037	384	554	\N	3	1	0	1	-1
3038	384	690	\N	3	1	0	1	-1
3039	384	727	\N	3	1	0	1	-1
3040	384	740	\N	3	1	0	1	-1
3041	392	6	\N	3	1	0	1	-1
3042	392	37	\N	3	1	0	1	-1
3043	392	48	\N	3	1	0	1	-1
3044	392	89	\N	3	1	0	1	-1
3045	392	107	\N	3	1	0	1	-1
3046	392	115	\N	3	1	0	1	-1
3047	392	153	\N	3	1	0	1	-1
3048	392	161	\N	3	1	0	1	-1
3049	392	342	\N	3	1	0	1	-1
3050	392	350	\N	3	1	0	1	-1
3051	392	384	\N	3	1	0	1	-1
3052	392	412	\N	3	1	0	1	-1
3053	392	433	\N	3	1	0	1	-1
3054	392	516	\N	3	1	0	1	-1
3055	392	554	\N	3	1	0	1	-1
3056	392	690	\N	3	1	0	1	-1
3057	392	727	\N	3	1	0	1	-1
3058	392	740	\N	3	1	0	1	-1
3059	412	6	\N	3	1	0	1	-1
3060	412	37	\N	3	1	0	1	-1
3061	412	48	\N	3	1	0	1	-1
3062	412	89	\N	3	1	0	1	-1
3063	412	107	\N	3	1	0	1	-1
3064	412	115	\N	3	1	0	1	-1
3065	412	153	\N	3	1	0	1	-1
3066	412	161	\N	3	1	0	1	-1
3067	412	342	\N	3	1	0	1	-1
3068	412	350	\N	3	1	0	1	-1
3069	412	384	\N	3	1	0	1	-1
3070	412	392	\N	3	1	0	1	-1
3071	412	433	\N	3	1	0	1	-1
3072	412	516	\N	3	1	0	1	-1
3073	412	554	\N	3	1	0	1	-1
3074	412	690	\N	3	1	0	1	-1
3075	412	727	\N	3	1	0	1	-1
3076	412	740	\N	3	1	0	1	-1
3077	433	6	\N	3	1	0	1	-1
3078	433	37	\N	3	1	0	1	-1
3079	433	48	\N	3	1	0	1	-1
3080	433	89	\N	3	1	0	1	-1
3081	433	107	\N	3	1	0	1	-1
3082	433	115	\N	3	1	0	1	-1
3083	433	153	\N	3	1	0	1	-1
3084	433	161	\N	3	1	0	1	-1
3085	433	342	\N	3	1	0	1	-1
3086	433	350	\N	3	1	0	1	-1
3087	433	384	\N	3	1	0	1	-1
3088	433	392	\N	3	1	0	1	-1
3089	433	412	\N	3	1	0	1	-1
3090	433	516	\N	3	1	0	1	-1
3091	433	554	\N	3	1	0	1	-1
3092	433	690	\N	3	1	0	1	-1
3093	433	727	\N	3	1	0	1	-1
3094	433	740	\N	3	1	0	1	-1
3095	516	6	\N	3	1	0	1	-1
3096	516	37	\N	3	1	0	1	-1
3097	516	48	\N	3	1	0	1	-1
3098	516	89	\N	3	1	0	1	-1
3099	516	107	\N	3	1	0	1	-1
3100	516	115	\N	3	1	0	1	-1
3101	516	153	\N	3	1	0	1	-1
3102	516	161	\N	3	1	0	1	-1
3103	516	342	\N	3	1	0	1	-1
3104	516	350	\N	3	1	0	1	-1
3105	516	384	\N	3	1	0	1	-1
3106	516	392	\N	3	1	0	1	-1
3107	516	412	\N	3	1	0	1	-1
3108	516	433	\N	3	1	0	1	-1
3109	516	554	\N	3	1	0	1	-1
3110	516	690	\N	3	1	0	1	-1
3111	516	727	\N	3	1	0	1	-1
3112	516	740	\N	3	1	0	1	-1
3113	554	6	\N	3	1	0	1	-1
3114	554	37	\N	3	1	0	1	-1
3115	554	48	\N	3	1	0	1	-1
3116	554	89	\N	3	1	0	1	-1
3117	554	107	\N	3	1	0	1	-1
3118	554	115	\N	3	1	0	1	-1
3119	554	153	\N	3	1	0	1	-1
3120	554	161	\N	3	1	0	1	-1
3121	554	342	\N	3	1	0	1	-1
3122	554	350	\N	3	1	0	1	-1
3123	554	384	\N	3	1	0	1	-1
3124	554	392	\N	3	1	0	1	-1
3125	554	412	\N	3	1	0	1	-1
3126	554	433	\N	3	1	0	1	-1
3127	554	516	\N	3	1	0	1	-1
3128	554	690	\N	3	1	0	1	-1
3129	554	727	\N	3	1	0	1	-1
3130	554	740	\N	3	1	0	1	-1
3131	690	6	\N	3	1	0	1	-1
3132	690	37	\N	3	1	0	1	-1
3133	690	48	\N	3	1	0	1	-1
3134	690	89	\N	3	1	0	1	-1
3135	690	107	\N	3	1	0	1	-1
3136	690	115	\N	3	1	0	1	-1
3137	690	153	\N	3	1	0	1	-1
3138	690	161	\N	3	1	0	1	-1
3139	690	342	\N	3	1	0	1	-1
3140	690	350	\N	3	1	0	1	-1
3141	690	384	\N	3	1	0	1	-1
3142	690	392	\N	3	1	0	1	-1
3143	690	412	\N	3	1	0	1	-1
3144	690	433	\N	3	1	0	1	-1
3145	690	516	\N	3	1	0	1	-1
3146	690	554	\N	3	1	0	1	-1
3147	690	727	\N	3	1	0	1	-1
3148	690	740	\N	3	1	0	1	-1
3149	727	6	\N	3	1	0	1	-1
3150	727	37	\N	3	1	0	1	-1
3151	727	48	\N	3	1	0	1	-1
3152	727	89	\N	3	1	0	1	-1
3153	727	107	\N	3	1	0	1	-1
3154	727	115	\N	3	1	0	1	-1
3155	727	153	\N	3	1	0	1	-1
3156	727	161	\N	3	1	0	1	-1
3157	727	342	\N	3	1	0	1	-1
3158	727	350	\N	3	1	0	1	-1
3159	727	384	\N	3	1	0	1	-1
3160	727	392	\N	3	1	0	1	-1
3161	727	412	\N	3	1	0	1	-1
3162	727	433	\N	3	1	0	1	-1
3163	727	516	\N	3	1	0	1	-1
3164	727	554	\N	3	1	0	1	-1
3165	727	690	\N	3	1	0	1	-1
3166	727	740	\N	3	1	0	1	-1
3167	740	6	\N	3	1	0	1	-1
3168	740	37	\N	3	1	0	1	-1
3169	740	48	\N	3	1	0	1	-1
3170	740	89	\N	3	1	0	1	-1
3171	740	107	\N	3	1	0	1	-1
3172	740	115	\N	3	1	0	1	-1
3173	740	153	\N	3	1	0	1	-1
3174	740	161	\N	3	1	0	1	-1
3175	740	342	\N	3	1	0	1	-1
3176	740	350	\N	3	1	0	1	-1
3177	740	384	\N	3	1	0	1	-1
3178	740	392	\N	3	1	0	1	-1
3179	740	412	\N	3	1	0	1	-1
3180	740	433	\N	3	1	0	1	-1
3181	740	516	\N	3	1	0	1	-1
3182	740	554	\N	3	1	0	1	-1
3183	740	690	\N	3	1	0	1	-1
3184	740	727	\N	3	1	0	1	-1
3185	7	36	\N	3	1	0	1	-1
3186	7	49	\N	3	1	0	1	-1
3187	7	88	\N	3	1	0	1	-1
3188	7	108	\N	3	1	0	1	-1
3189	7	114	\N	3	1	0	1	-1
3190	7	154	\N	3	1	0	1	-1
3191	7	160	\N	3	1	0	1	-1
3192	7	204	\N	3	1	0	1	-1
3193	7	235	\N	3	1	0	1	-1
3194	7	343	\N	3	1	0	1	-1
3195	7	349	\N	3	1	0	1	-1
3196	7	385	\N	3	1	0	1	-1
3197	7	391	\N	3	1	0	1	-1
3198	7	411	\N	3	1	0	1	-1
3199	7	728	\N	3	1	0	1	-1
3200	7	1062	\N	3	1	0	1	-1
3201	7	1113	\N	3	1	0	1	-1
3202	7	1376	\N	3	1	0	1	-1
3203	7	1401	\N	3	1	0	1	-1
3204	36	7	\N	3	1	0	1	-1
3205	36	49	\N	3	1	0	1	-1
3206	36	88	\N	3	1	0	1	-1
3207	36	108	\N	3	1	0	1	-1
3208	36	114	\N	3	1	0	1	-1
3209	36	154	\N	3	1	0	1	-1
3210	36	160	\N	3	1	0	1	-1
3211	36	204	\N	3	1	0	1	-1
3212	36	235	\N	3	1	0	1	-1
3213	36	343	\N	3	1	0	1	-1
3214	36	349	\N	3	1	0	1	-1
3215	36	385	\N	3	1	0	1	-1
3216	36	391	\N	3	1	0	1	-1
3217	36	411	\N	3	1	0	1	-1
3218	36	728	\N	3	1	0	1	-1
3219	36	1062	\N	3	1	0	1	-1
3220	36	1113	\N	3	1	0	1	-1
3221	36	1376	\N	3	1	0	1	-1
3222	36	1401	\N	3	1	0	1	-1
3223	49	7	\N	3	1	0	1	-1
3224	49	36	\N	3	1	0	1	-1
3225	49	88	\N	3	1	0	1	-1
3226	49	108	\N	3	1	0	1	-1
3227	49	114	\N	3	1	0	1	-1
3228	49	154	\N	3	1	0	1	-1
3229	49	160	\N	3	1	0	1	-1
3230	49	204	\N	3	1	0	1	-1
3231	49	235	\N	3	1	0	1	-1
3232	49	343	\N	3	1	0	1	-1
3233	49	349	\N	3	1	0	1	-1
3234	49	385	\N	3	1	0	1	-1
3235	49	391	\N	3	1	0	1	-1
3236	49	411	\N	3	1	0	1	-1
3237	49	728	\N	3	1	0	1	-1
3238	49	1062	\N	3	1	0	1	-1
3239	49	1113	\N	3	1	0	1	-1
3240	49	1376	\N	3	1	0	1	-1
3241	49	1401	\N	3	1	0	1	-1
3242	88	7	\N	3	1	0	1	-1
3243	88	36	\N	3	1	0	1	-1
3244	88	49	\N	3	1	0	1	-1
3245	88	108	\N	3	1	0	1	-1
3246	88	114	\N	3	1	0	1	-1
3247	88	154	\N	3	1	0	1	-1
3248	88	160	\N	3	1	0	1	-1
3249	88	204	\N	3	1	0	1	-1
3250	88	235	\N	3	1	0	1	-1
3251	88	343	\N	3	1	0	1	-1
3252	88	349	\N	3	1	0	1	-1
3253	88	385	\N	3	1	0	1	-1
3254	88	391	\N	3	1	0	1	-1
3255	88	411	\N	3	1	0	1	-1
3256	88	728	\N	3	1	0	1	-1
3257	88	1062	\N	3	1	0	1	-1
3258	88	1113	\N	3	1	0	1	-1
3259	88	1376	\N	3	1	0	1	-1
3260	88	1401	\N	3	1	0	1	-1
3261	108	7	\N	3	1	0	1	-1
3262	108	36	\N	3	1	0	1	-1
3263	108	49	\N	3	1	0	1	-1
3264	108	88	\N	3	1	0	1	-1
3265	108	114	\N	3	1	0	1	-1
3266	108	154	\N	3	1	0	1	-1
3267	108	160	\N	3	1	0	1	-1
3268	108	204	\N	3	1	0	1	-1
3269	108	235	\N	3	1	0	1	-1
3270	108	343	\N	3	1	0	1	-1
3271	108	349	\N	3	1	0	1	-1
3272	108	385	\N	3	1	0	1	-1
3273	108	391	\N	3	1	0	1	-1
3274	108	411	\N	3	1	0	1	-1
3275	108	728	\N	3	1	0	1	-1
3276	108	1062	\N	3	1	0	1	-1
3277	108	1113	\N	3	1	0	1	-1
3278	108	1376	\N	3	1	0	1	-1
3279	108	1401	\N	3	1	0	1	-1
3280	114	7	\N	3	1	0	1	-1
3281	114	36	\N	3	1	0	1	-1
3282	114	49	\N	3	1	0	1	-1
3283	114	88	\N	3	1	0	1	-1
3284	114	108	\N	3	1	0	1	-1
3285	114	154	\N	3	1	0	1	-1
3286	114	160	\N	3	1	0	1	-1
3287	114	204	\N	3	1	0	1	-1
3288	114	235	\N	3	1	0	1	-1
3289	114	343	\N	3	1	0	1	-1
3290	114	349	\N	3	1	0	1	-1
3291	114	385	\N	3	1	0	1	-1
3292	114	391	\N	3	1	0	1	-1
3293	114	411	\N	3	1	0	1	-1
3294	114	728	\N	3	1	0	1	-1
3295	114	1062	\N	3	1	0	1	-1
3296	114	1113	\N	3	1	0	1	-1
3297	114	1376	\N	3	1	0	1	-1
3298	114	1401	\N	3	1	0	1	-1
3299	154	7	\N	3	1	0	1	-1
3300	154	36	\N	3	1	0	1	-1
3301	154	49	\N	3	1	0	1	-1
3302	154	88	\N	3	1	0	1	-1
3303	154	108	\N	3	1	0	1	-1
3304	154	114	\N	3	1	0	1	-1
3305	154	160	\N	3	1	0	1	-1
3306	154	204	\N	3	1	0	1	-1
3307	154	235	\N	3	1	0	1	-1
3308	154	343	\N	3	1	0	1	-1
3309	154	349	\N	3	1	0	1	-1
3310	154	385	\N	3	1	0	1	-1
3311	154	391	\N	3	1	0	1	-1
3312	154	411	\N	3	1	0	1	-1
3313	154	728	\N	3	1	0	1	-1
3314	154	1062	\N	3	1	0	1	-1
3315	154	1113	\N	3	1	0	1	-1
3316	154	1376	\N	3	1	0	1	-1
3317	154	1401	\N	3	1	0	1	-1
3318	160	7	\N	3	1	0	1	-1
3319	160	36	\N	3	1	0	1	-1
3320	160	49	\N	3	1	0	1	-1
3321	160	88	\N	3	1	0	1	-1
3322	160	108	\N	3	1	0	1	-1
3323	160	114	\N	3	1	0	1	-1
3324	160	154	\N	3	1	0	1	-1
3325	160	204	\N	3	1	0	1	-1
3326	160	235	\N	3	1	0	1	-1
3327	160	343	\N	3	1	0	1	-1
3328	160	349	\N	3	1	0	1	-1
3329	160	385	\N	3	1	0	1	-1
3330	160	391	\N	3	1	0	1	-1
3331	160	411	\N	3	1	0	1	-1
3332	160	728	\N	3	1	0	1	-1
3333	160	1062	\N	3	1	0	1	-1
3334	160	1113	\N	3	1	0	1	-1
3335	160	1376	\N	3	1	0	1	-1
3336	160	1401	\N	3	1	0	1	-1
3337	204	7	\N	3	1	0	1	-1
3338	204	36	\N	3	1	0	1	-1
3339	204	49	\N	3	1	0	1	-1
3340	204	88	\N	3	1	0	1	-1
3341	204	108	\N	3	1	0	1	-1
3342	204	114	\N	3	1	0	1	-1
3343	204	154	\N	3	1	0	1	-1
3344	204	160	\N	3	1	0	1	-1
3345	204	235	\N	3	1	0	1	-1
3346	204	343	\N	3	1	0	1	-1
3347	204	349	\N	3	1	0	1	-1
3348	204	385	\N	3	1	0	1	-1
3349	204	391	\N	3	1	0	1	-1
3350	204	411	\N	3	1	0	1	-1
3351	204	728	\N	3	1	0	1	-1
3352	204	1062	\N	3	1	0	1	-1
3353	204	1113	\N	3	1	0	1	-1
3354	204	1376	\N	3	1	0	1	-1
3355	204	1401	\N	3	1	0	1	-1
3356	235	7	\N	3	1	0	1	-1
3357	235	36	\N	3	1	0	1	-1
3358	235	49	\N	3	1	0	1	-1
3359	235	88	\N	3	1	0	1	-1
3360	235	108	\N	3	1	0	1	-1
3361	235	114	\N	3	1	0	1	-1
3362	235	154	\N	3	1	0	1	-1
3363	235	160	\N	3	1	0	1	-1
3364	235	204	\N	3	1	0	1	-1
3365	235	343	\N	3	1	0	1	-1
3366	235	349	\N	3	1	0	1	-1
3367	235	385	\N	3	1	0	1	-1
3368	235	391	\N	3	1	0	1	-1
3369	235	411	\N	3	1	0	1	-1
3370	235	728	\N	3	1	0	1	-1
3371	235	1062	\N	3	1	0	1	-1
3372	235	1113	\N	3	1	0	1	-1
3373	235	1376	\N	3	1	0	1	-1
3374	235	1401	\N	3	1	0	1	-1
3375	343	7	\N	3	1	0	1	-1
3376	343	36	\N	3	1	0	1	-1
3377	343	49	\N	3	1	0	1	-1
3378	343	88	\N	3	1	0	1	-1
3379	343	108	\N	3	1	0	1	-1
3380	343	114	\N	3	1	0	1	-1
3381	343	154	\N	3	1	0	1	-1
3382	343	160	\N	3	1	0	1	-1
3383	343	204	\N	3	1	0	1	-1
3384	343	235	\N	3	1	0	1	-1
3385	343	349	\N	3	1	0	1	-1
3386	343	385	\N	3	1	0	1	-1
3387	343	391	\N	3	1	0	1	-1
3388	343	411	\N	3	1	0	1	-1
3389	343	728	\N	3	1	0	1	-1
3390	343	1062	\N	3	1	0	1	-1
3391	343	1113	\N	3	1	0	1	-1
3392	343	1376	\N	3	1	0	1	-1
3393	343	1401	\N	3	1	0	1	-1
3394	349	7	\N	3	1	0	1	-1
3395	349	36	\N	3	1	0	1	-1
3396	349	49	\N	3	1	0	1	-1
3397	349	88	\N	3	1	0	1	-1
3398	349	108	\N	3	1	0	1	-1
3399	349	114	\N	3	1	0	1	-1
3400	349	154	\N	3	1	0	1	-1
3401	349	160	\N	3	1	0	1	-1
3402	349	204	\N	3	1	0	1	-1
3403	349	235	\N	3	1	0	1	-1
3404	349	343	\N	3	1	0	1	-1
3405	349	385	\N	3	1	0	1	-1
3406	349	391	\N	3	1	0	1	-1
3407	349	411	\N	3	1	0	1	-1
3408	349	728	\N	3	1	0	1	-1
3409	349	1062	\N	3	1	0	1	-1
3410	349	1113	\N	3	1	0	1	-1
3411	349	1376	\N	3	1	0	1	-1
3412	349	1401	\N	3	1	0	1	-1
3413	385	7	\N	3	1	0	1	-1
3414	385	36	\N	3	1	0	1	-1
3415	385	49	\N	3	1	0	1	-1
3416	385	88	\N	3	1	0	1	-1
3417	385	108	\N	3	1	0	1	-1
3418	385	114	\N	3	1	0	1	-1
3419	385	154	\N	3	1	0	1	-1
3420	385	160	\N	3	1	0	1	-1
3421	385	204	\N	3	1	0	1	-1
3422	385	235	\N	3	1	0	1	-1
3423	385	343	\N	3	1	0	1	-1
3424	385	349	\N	3	1	0	1	-1
3425	385	391	\N	3	1	0	1	-1
3426	385	411	\N	3	1	0	1	-1
3427	385	728	\N	3	1	0	1	-1
3428	385	1062	\N	3	1	0	1	-1
3429	385	1113	\N	3	1	0	1	-1
3430	385	1376	\N	3	1	0	1	-1
3431	385	1401	\N	3	1	0	1	-1
3432	391	7	\N	3	1	0	1	-1
3433	391	36	\N	3	1	0	1	-1
3434	391	49	\N	3	1	0	1	-1
3435	391	88	\N	3	1	0	1	-1
3436	391	108	\N	3	1	0	1	-1
3437	391	114	\N	3	1	0	1	-1
3438	391	154	\N	3	1	0	1	-1
3439	391	160	\N	3	1	0	1	-1
3440	391	204	\N	3	1	0	1	-1
3441	391	235	\N	3	1	0	1	-1
3442	391	343	\N	3	1	0	1	-1
3443	391	349	\N	3	1	0	1	-1
3444	391	385	\N	3	1	0	1	-1
3445	391	411	\N	3	1	0	1	-1
3446	391	728	\N	3	1	0	1	-1
3447	391	1062	\N	3	1	0	1	-1
3448	391	1113	\N	3	1	0	1	-1
3449	391	1376	\N	3	1	0	1	-1
3450	391	1401	\N	3	1	0	1	-1
3451	411	7	\N	3	1	0	1	-1
3452	411	36	\N	3	1	0	1	-1
3453	411	49	\N	3	1	0	1	-1
3454	411	88	\N	3	1	0	1	-1
3455	411	108	\N	3	1	0	1	-1
3456	411	114	\N	3	1	0	1	-1
3457	411	154	\N	3	1	0	1	-1
3458	411	160	\N	3	1	0	1	-1
3459	411	204	\N	3	1	0	1	-1
3460	411	235	\N	3	1	0	1	-1
3461	411	343	\N	3	1	0	1	-1
3462	411	349	\N	3	1	0	1	-1
3463	411	385	\N	3	1	0	1	-1
3464	411	391	\N	3	1	0	1	-1
3465	411	728	\N	3	1	0	1	-1
3466	411	1062	\N	3	1	0	1	-1
3467	411	1113	\N	3	1	0	1	-1
3468	411	1376	\N	3	1	0	1	-1
3469	411	1401	\N	3	1	0	1	-1
3470	728	7	\N	3	1	0	1	-1
3471	728	36	\N	3	1	0	1	-1
3472	728	49	\N	3	1	0	1	-1
3473	728	88	\N	3	1	0	1	-1
3474	728	108	\N	3	1	0	1	-1
3475	728	114	\N	3	1	0	1	-1
3476	728	154	\N	3	1	0	1	-1
3477	728	160	\N	3	1	0	1	-1
3478	728	204	\N	3	1	0	1	-1
3479	728	235	\N	3	1	0	1	-1
3480	728	343	\N	3	1	0	1	-1
3481	728	349	\N	3	1	0	1	-1
3482	728	385	\N	3	1	0	1	-1
3483	728	391	\N	3	1	0	1	-1
3484	728	411	\N	3	1	0	1	-1
3485	728	1062	\N	3	1	0	1	-1
3486	728	1113	\N	3	1	0	1	-1
3487	728	1376	\N	3	1	0	1	-1
3488	728	1401	\N	3	1	0	1	-1
3489	1062	7	\N	3	1	0	1	-1
3490	1062	36	\N	3	1	0	1	-1
3491	1062	49	\N	3	1	0	1	-1
3492	1062	88	\N	3	1	0	1	-1
3493	1062	108	\N	3	1	0	1	-1
3494	1062	114	\N	3	1	0	1	-1
3495	1062	154	\N	3	1	0	1	-1
3496	1062	160	\N	3	1	0	1	-1
3497	1062	204	\N	3	1	0	1	-1
3498	1062	235	\N	3	1	0	1	-1
3499	1062	343	\N	3	1	0	1	-1
3500	1062	349	\N	3	1	0	1	-1
3501	1062	385	\N	3	1	0	1	-1
3502	1062	391	\N	3	1	0	1	-1
3503	1062	411	\N	3	1	0	1	-1
3504	1062	728	\N	3	1	0	1	-1
3505	1062	1113	\N	3	1	0	1	-1
3506	1062	1376	\N	3	1	0	1	-1
3507	1062	1401	\N	3	1	0	1	-1
3508	1113	7	\N	3	1	0	1	-1
3509	1113	36	\N	3	1	0	1	-1
3510	1113	49	\N	3	1	0	1	-1
3511	1113	88	\N	3	1	0	1	-1
3512	1113	108	\N	3	1	0	1	-1
3513	1113	114	\N	3	1	0	1	-1
3514	1113	154	\N	3	1	0	1	-1
3515	1113	160	\N	3	1	0	1	-1
3516	1113	204	\N	3	1	0	1	-1
3517	1113	235	\N	3	1	0	1	-1
3518	1113	343	\N	3	1	0	1	-1
3519	1113	349	\N	3	1	0	1	-1
3520	1113	385	\N	3	1	0	1	-1
3521	1113	391	\N	3	1	0	1	-1
3522	1113	411	\N	3	1	0	1	-1
3523	1113	728	\N	3	1	0	1	-1
3524	1113	1062	\N	3	1	0	1	-1
3525	1113	1376	\N	3	1	0	1	-1
3526	1113	1401	\N	3	1	0	1	-1
3527	1376	7	\N	3	1	0	1	-1
3528	1376	36	\N	3	1	0	1	-1
3529	1376	49	\N	3	1	0	1	-1
3530	1376	88	\N	3	1	0	1	-1
3531	1376	108	\N	3	1	0	1	-1
3532	1376	114	\N	3	1	0	1	-1
3533	1376	154	\N	3	1	0	1	-1
3534	1376	160	\N	3	1	0	1	-1
3535	1376	204	\N	3	1	0	1	-1
3536	1376	235	\N	3	1	0	1	-1
3537	1376	343	\N	3	1	0	1	-1
3538	1376	349	\N	3	1	0	1	-1
3539	1376	385	\N	3	1	0	1	-1
3540	1376	391	\N	3	1	0	1	-1
3541	1376	411	\N	3	1	0	1	-1
3542	1376	728	\N	3	1	0	1	-1
3543	1376	1062	\N	3	1	0	1	-1
3544	1376	1113	\N	3	1	0	1	-1
3545	1376	1401	\N	3	1	0	1	-1
3546	1401	7	\N	3	1	0	1	-1
3547	1401	36	\N	3	1	0	1	-1
3548	1401	49	\N	3	1	0	1	-1
3549	1401	88	\N	3	1	0	1	-1
3550	1401	108	\N	3	1	0	1	-1
3551	1401	114	\N	3	1	0	1	-1
3552	1401	154	\N	3	1	0	1	-1
3553	1401	160	\N	3	1	0	1	-1
3554	1401	204	\N	3	1	0	1	-1
3555	1401	235	\N	3	1	0	1	-1
3556	1401	343	\N	3	1	0	1	-1
3557	1401	349	\N	3	1	0	1	-1
3558	1401	385	\N	3	1	0	1	-1
3559	1401	391	\N	3	1	0	1	-1
3560	1401	411	\N	3	1	0	1	-1
3561	1401	728	\N	3	1	0	1	-1
3562	1401	1062	\N	3	1	0	1	-1
3563	1401	1113	\N	3	1	0	1	-1
3564	1401	1376	\N	3	1	0	1	-1
3565	8	50	\N	3	1	0	1	-1
3566	8	109	\N	3	1	0	1	-1
3567	8	110	\N	3	1	0	1	-1
3568	8	155	\N	3	1	0	1	-1
3569	8	156	\N	3	1	0	1	-1
3570	8	205	\N	3	1	0	1	-1
3571	8	344	\N	3	1	0	1	-1
3572	8	386	\N	3	1	0	1	-1
3573	8	436	\N	3	1	0	1	-1
3574	8	559	\N	3	1	0	1	-1
3575	8	588	\N	3	1	0	1	-1
3576	8	589	\N	3	1	0	1	-1
3577	8	634	\N	3	1	0	1	-1
3578	8	683	\N	3	1	0	1	-1
3579	8	729	\N	3	1	0	1	-1
3580	8	1130	\N	3	1	0	1	-1
3581	8	1198	\N	3	1	0	1	-1
3582	8	1344	\N	3	1	0	1	-1
3583	8	1345	\N	3	1	0	1	-1
3584	8	1372	\N	3	1	0	1	-1
3585	8	1402	\N	3	1	0	1	-1
3586	50	8	\N	3	1	0	1	-1
3587	50	109	\N	3	1	0	1	-1
3588	50	110	\N	3	1	0	1	-1
3589	50	155	\N	3	1	0	1	-1
3590	50	156	\N	3	1	0	1	-1
3591	50	205	\N	3	1	0	1	-1
3592	50	344	\N	3	1	0	1	-1
3593	50	386	\N	3	1	0	1	-1
3594	50	436	\N	3	1	0	1	-1
3595	50	559	\N	3	1	0	1	-1
3596	50	588	\N	3	1	0	1	-1
3597	50	589	\N	3	1	0	1	-1
3598	50	634	\N	3	1	0	1	-1
3599	50	683	\N	3	1	0	1	-1
3600	50	729	\N	3	1	0	1	-1
3601	50	1130	\N	3	1	0	1	-1
3602	50	1198	\N	3	1	0	1	-1
3603	50	1344	\N	3	1	0	1	-1
3604	50	1345	\N	3	1	0	1	-1
3605	50	1372	\N	3	1	0	1	-1
3606	50	1402	\N	3	1	0	1	-1
3607	109	8	\N	3	1	0	1	-1
3608	109	50	\N	3	1	0	1	-1
3609	109	110	\N	3	1	0	1	-1
3610	109	155	\N	3	1	0	1	-1
3611	109	156	\N	3	1	0	1	-1
3612	109	205	\N	3	1	0	1	-1
3613	109	344	\N	3	1	0	1	-1
3614	109	386	\N	3	1	0	1	-1
3615	109	436	\N	3	1	0	1	-1
3616	109	559	\N	3	1	0	1	-1
3617	109	588	\N	3	1	0	1	-1
3618	109	589	\N	3	1	0	1	-1
3619	109	634	\N	3	1	0	1	-1
3620	109	683	\N	3	1	0	1	-1
3621	109	729	\N	3	1	0	1	-1
3622	109	1130	\N	3	1	0	1	-1
3623	109	1198	\N	3	1	0	1	-1
3624	109	1344	\N	3	1	0	1	-1
3625	109	1345	\N	3	1	0	1	-1
3626	109	1372	\N	3	1	0	1	-1
3627	109	1402	\N	3	1	0	1	-1
3628	110	8	\N	3	1	0	1	-1
3629	110	50	\N	3	1	0	1	-1
3630	110	109	\N	3	1	0	1	-1
3631	110	155	\N	3	1	0	1	-1
3632	110	156	\N	3	1	0	1	-1
3633	110	205	\N	3	1	0	1	-1
3634	110	344	\N	3	1	0	1	-1
3635	110	386	\N	3	1	0	1	-1
3636	110	436	\N	3	1	0	1	-1
3637	110	559	\N	3	1	0	1	-1
3638	110	588	\N	3	1	0	1	-1
3639	110	589	\N	3	1	0	1	-1
3640	110	634	\N	3	1	0	1	-1
3641	110	683	\N	3	1	0	1	-1
3642	110	729	\N	3	1	0	1	-1
3643	110	1130	\N	3	1	0	1	-1
3644	110	1198	\N	3	1	0	1	-1
3645	110	1344	\N	3	1	0	1	-1
3646	110	1345	\N	3	1	0	1	-1
3647	110	1372	\N	3	1	0	1	-1
3648	110	1402	\N	3	1	0	1	-1
3649	155	8	\N	3	1	0	1	-1
3650	155	50	\N	3	1	0	1	-1
3651	155	109	\N	3	1	0	1	-1
3652	155	110	\N	3	1	0	1	-1
3653	155	156	\N	3	1	0	1	-1
3654	155	205	\N	3	1	0	1	-1
3655	155	344	\N	3	1	0	1	-1
3656	155	386	\N	3	1	0	1	-1
3657	155	436	\N	3	1	0	1	-1
3658	155	559	\N	3	1	0	1	-1
3659	155	588	\N	3	1	0	1	-1
3660	155	589	\N	3	1	0	1	-1
3661	155	634	\N	3	1	0	1	-1
3662	155	683	\N	3	1	0	1	-1
3663	155	729	\N	3	1	0	1	-1
3664	155	1130	\N	3	1	0	1	-1
3665	155	1198	\N	3	1	0	1	-1
3666	155	1344	\N	3	1	0	1	-1
3667	155	1345	\N	3	1	0	1	-1
3668	155	1372	\N	3	1	0	1	-1
3669	155	1402	\N	3	1	0	1	-1
3670	156	8	\N	3	1	0	1	-1
3671	156	50	\N	3	1	0	1	-1
3672	156	109	\N	3	1	0	1	-1
3673	156	110	\N	3	1	0	1	-1
3674	156	155	\N	3	1	0	1	-1
3675	156	205	\N	3	1	0	1	-1
3676	156	344	\N	3	1	0	1	-1
3677	156	386	\N	3	1	0	1	-1
3678	156	436	\N	3	1	0	1	-1
3679	156	559	\N	3	1	0	1	-1
3680	156	588	\N	3	1	0	1	-1
3681	156	589	\N	3	1	0	1	-1
3682	156	634	\N	3	1	0	1	-1
3683	156	683	\N	3	1	0	1	-1
3684	156	729	\N	3	1	0	1	-1
3685	156	1130	\N	3	1	0	1	-1
3686	156	1198	\N	3	1	0	1	-1
3687	156	1344	\N	3	1	0	1	-1
3688	156	1345	\N	3	1	0	1	-1
3689	156	1372	\N	3	1	0	1	-1
3690	156	1402	\N	3	1	0	1	-1
3691	205	8	\N	3	1	0	1	-1
3692	205	50	\N	3	1	0	1	-1
3693	205	109	\N	3	1	0	1	-1
3694	205	110	\N	3	1	0	1	-1
3695	205	155	\N	3	1	0	1	-1
3696	205	156	\N	3	1	0	1	-1
3697	205	344	\N	3	1	0	1	-1
3698	205	386	\N	3	1	0	1	-1
3699	205	436	\N	3	1	0	1	-1
3700	205	559	\N	3	1	0	1	-1
3701	205	588	\N	3	1	0	1	-1
3702	205	589	\N	3	1	0	1	-1
3703	205	634	\N	3	1	0	1	-1
3704	205	683	\N	3	1	0	1	-1
3705	205	729	\N	3	1	0	1	-1
3706	205	1130	\N	3	1	0	1	-1
3707	205	1198	\N	3	1	0	1	-1
3708	205	1344	\N	3	1	0	1	-1
3709	205	1345	\N	3	1	0	1	-1
3710	205	1372	\N	3	1	0	1	-1
3711	205	1402	\N	3	1	0	1	-1
3712	344	8	\N	3	1	0	1	-1
3713	344	50	\N	3	1	0	1	-1
3714	344	109	\N	3	1	0	1	-1
3715	344	110	\N	3	1	0	1	-1
3716	344	155	\N	3	1	0	1	-1
3717	344	156	\N	3	1	0	1	-1
3718	344	205	\N	3	1	0	1	-1
3719	344	386	\N	3	1	0	1	-1
3720	344	436	\N	3	1	0	1	-1
3721	344	559	\N	3	1	0	1	-1
3722	344	588	\N	3	1	0	1	-1
3723	344	589	\N	3	1	0	1	-1
3724	344	634	\N	3	1	0	1	-1
3725	344	683	\N	3	1	0	1	-1
3726	344	729	\N	3	1	0	1	-1
3727	344	1130	\N	3	1	0	1	-1
3728	344	1198	\N	3	1	0	1	-1
3729	344	1344	\N	3	1	0	1	-1
3730	344	1345	\N	3	1	0	1	-1
3731	344	1372	\N	3	1	0	1	-1
3732	344	1402	\N	3	1	0	1	-1
3733	386	8	\N	3	1	0	1	-1
3734	386	50	\N	3	1	0	1	-1
3735	386	109	\N	3	1	0	1	-1
3736	386	110	\N	3	1	0	1	-1
3737	386	155	\N	3	1	0	1	-1
3738	386	156	\N	3	1	0	1	-1
3739	386	205	\N	3	1	0	1	-1
3740	386	344	\N	3	1	0	1	-1
3741	386	436	\N	3	1	0	1	-1
3742	386	559	\N	3	1	0	1	-1
3743	386	588	\N	3	1	0	1	-1
3744	386	589	\N	3	1	0	1	-1
3745	386	634	\N	3	1	0	1	-1
3746	386	683	\N	3	1	0	1	-1
3747	386	729	\N	3	1	0	1	-1
3748	386	1130	\N	3	1	0	1	-1
3749	386	1198	\N	3	1	0	1	-1
3750	386	1344	\N	3	1	0	1	-1
3751	386	1345	\N	3	1	0	1	-1
3752	386	1372	\N	3	1	0	1	-1
3753	386	1402	\N	3	1	0	1	-1
3754	436	8	\N	3	1	0	1	-1
3755	436	50	\N	3	1	0	1	-1
3756	436	109	\N	3	1	0	1	-1
3757	436	110	\N	3	1	0	1	-1
3758	436	155	\N	3	1	0	1	-1
3759	436	156	\N	3	1	0	1	-1
3760	436	205	\N	3	1	0	1	-1
3761	436	344	\N	3	1	0	1	-1
3762	436	386	\N	3	1	0	1	-1
3763	436	559	\N	3	1	0	1	-1
3764	436	588	\N	3	1	0	1	-1
3765	436	589	\N	3	1	0	1	-1
3766	436	634	\N	3	1	0	1	-1
3767	436	683	\N	3	1	0	1	-1
3768	436	729	\N	3	1	0	1	-1
3769	436	1130	\N	3	1	0	1	-1
3770	436	1198	\N	3	1	0	1	-1
3771	436	1344	\N	3	1	0	1	-1
3772	436	1345	\N	3	1	0	1	-1
3773	436	1372	\N	3	1	0	1	-1
3774	436	1402	\N	3	1	0	1	-1
3775	559	8	\N	3	1	0	1	-1
3776	559	50	\N	3	1	0	1	-1
3777	559	109	\N	3	1	0	1	-1
3778	559	110	\N	3	1	0	1	-1
3779	559	155	\N	3	1	0	1	-1
3780	559	156	\N	3	1	0	1	-1
3781	559	205	\N	3	1	0	1	-1
3782	559	344	\N	3	1	0	1	-1
3783	559	386	\N	3	1	0	1	-1
3784	559	436	\N	3	1	0	1	-1
3785	559	588	\N	3	1	0	1	-1
3786	559	589	\N	3	1	0	1	-1
3787	559	634	\N	3	1	0	1	-1
3788	559	683	\N	3	1	0	1	-1
3789	559	729	\N	3	1	0	1	-1
3790	559	1130	\N	3	1	0	1	-1
3791	559	1198	\N	3	1	0	1	-1
3792	559	1344	\N	3	1	0	1	-1
3793	559	1345	\N	3	1	0	1	-1
3794	559	1372	\N	3	1	0	1	-1
3795	559	1402	\N	3	1	0	1	-1
3796	588	8	\N	3	1	0	1	-1
3797	588	50	\N	3	1	0	1	-1
3798	588	109	\N	3	1	0	1	-1
3799	588	110	\N	3	1	0	1	-1
3800	588	155	\N	3	1	0	1	-1
3801	588	156	\N	3	1	0	1	-1
3802	588	205	\N	3	1	0	1	-1
3803	588	344	\N	3	1	0	1	-1
3804	588	386	\N	3	1	0	1	-1
3805	588	436	\N	3	1	0	1	-1
3806	588	559	\N	3	1	0	1	-1
3807	588	589	\N	3	1	0	1	-1
3808	588	634	\N	3	1	0	1	-1
3809	588	683	\N	3	1	0	1	-1
3810	588	729	\N	3	1	0	1	-1
3811	588	1130	\N	3	1	0	1	-1
3812	588	1198	\N	3	1	0	1	-1
3813	588	1344	\N	3	1	0	1	-1
3814	588	1345	\N	3	1	0	1	-1
3815	588	1372	\N	3	1	0	1	-1
3816	588	1402	\N	3	1	0	1	-1
3817	589	8	\N	3	1	0	1	-1
3818	589	50	\N	3	1	0	1	-1
3819	589	109	\N	3	1	0	1	-1
3820	589	110	\N	3	1	0	1	-1
3821	589	155	\N	3	1	0	1	-1
3822	589	156	\N	3	1	0	1	-1
3823	589	205	\N	3	1	0	1	-1
3824	589	344	\N	3	1	0	1	-1
3825	589	386	\N	3	1	0	1	-1
3826	589	436	\N	3	1	0	1	-1
3827	589	559	\N	3	1	0	1	-1
3828	589	588	\N	3	1	0	1	-1
3829	589	634	\N	3	1	0	1	-1
3830	589	683	\N	3	1	0	1	-1
3831	589	729	\N	3	1	0	1	-1
3832	589	1130	\N	3	1	0	1	-1
3833	589	1198	\N	3	1	0	1	-1
3834	589	1344	\N	3	1	0	1	-1
3835	589	1345	\N	3	1	0	1	-1
3836	589	1372	\N	3	1	0	1	-1
3837	589	1402	\N	3	1	0	1	-1
3838	634	8	\N	3	1	0	1	-1
3839	634	50	\N	3	1	0	1	-1
3840	634	109	\N	3	1	0	1	-1
3841	634	110	\N	3	1	0	1	-1
3842	634	155	\N	3	1	0	1	-1
3843	634	156	\N	3	1	0	1	-1
3844	634	205	\N	3	1	0	1	-1
3845	634	344	\N	3	1	0	1	-1
3846	634	386	\N	3	1	0	1	-1
3847	634	436	\N	3	1	0	1	-1
3848	634	559	\N	3	1	0	1	-1
3849	634	588	\N	3	1	0	1	-1
3850	634	589	\N	3	1	0	1	-1
3851	634	683	\N	3	1	0	1	-1
3852	634	729	\N	3	1	0	1	-1
3853	634	1130	\N	3	1	0	1	-1
3854	634	1198	\N	3	1	0	1	-1
3855	634	1344	\N	3	1	0	1	-1
3856	634	1345	\N	3	1	0	1	-1
3857	634	1372	\N	3	1	0	1	-1
3858	634	1402	\N	3	1	0	1	-1
3859	683	8	\N	3	1	0	1	-1
3860	683	50	\N	3	1	0	1	-1
3861	683	109	\N	3	1	0	1	-1
3862	683	110	\N	3	1	0	1	-1
3863	683	155	\N	3	1	0	1	-1
3864	683	156	\N	3	1	0	1	-1
3865	683	205	\N	3	1	0	1	-1
3866	683	344	\N	3	1	0	1	-1
3867	683	386	\N	3	1	0	1	-1
3868	683	436	\N	3	1	0	1	-1
3869	683	559	\N	3	1	0	1	-1
3870	683	588	\N	3	1	0	1	-1
3871	683	589	\N	3	1	0	1	-1
3872	683	634	\N	3	1	0	1	-1
3873	683	729	\N	3	1	0	1	-1
3874	683	1130	\N	3	1	0	1	-1
3875	683	1198	\N	3	1	0	1	-1
3876	683	1344	\N	3	1	0	1	-1
3877	683	1345	\N	3	1	0	1	-1
3878	683	1372	\N	3	1	0	1	-1
3879	683	1402	\N	3	1	0	1	-1
3880	729	8	\N	3	1	0	1	-1
3881	729	50	\N	3	1	0	1	-1
3882	729	109	\N	3	1	0	1	-1
3883	729	110	\N	3	1	0	1	-1
3884	729	155	\N	3	1	0	1	-1
3885	729	156	\N	3	1	0	1	-1
3886	729	205	\N	3	1	0	1	-1
3887	729	344	\N	3	1	0	1	-1
3888	729	386	\N	3	1	0	1	-1
3889	729	436	\N	3	1	0	1	-1
3890	729	559	\N	3	1	0	1	-1
3891	729	588	\N	3	1	0	1	-1
3892	729	589	\N	3	1	0	1	-1
3893	729	634	\N	3	1	0	1	-1
3894	729	683	\N	3	1	0	1	-1
3895	729	1130	\N	3	1	0	1	-1
3896	729	1198	\N	3	1	0	1	-1
3897	729	1344	\N	3	1	0	1	-1
3898	729	1345	\N	3	1	0	1	-1
3899	729	1372	\N	3	1	0	1	-1
3900	729	1402	\N	3	1	0	1	-1
3901	1130	8	\N	3	1	0	1	-1
3902	1130	50	\N	3	1	0	1	-1
3903	1130	109	\N	3	1	0	1	-1
3904	1130	110	\N	3	1	0	1	-1
3905	1130	155	\N	3	1	0	1	-1
3906	1130	156	\N	3	1	0	1	-1
3907	1130	205	\N	3	1	0	1	-1
3908	1130	344	\N	3	1	0	1	-1
3909	1130	386	\N	3	1	0	1	-1
3910	1130	436	\N	3	1	0	1	-1
3911	1130	559	\N	3	1	0	1	-1
3912	1130	588	\N	3	1	0	1	-1
3913	1130	589	\N	3	1	0	1	-1
3914	1130	634	\N	3	1	0	1	-1
3915	1130	683	\N	3	1	0	1	-1
3916	1130	729	\N	3	1	0	1	-1
3917	1130	1198	\N	3	1	0	1	-1
3918	1130	1344	\N	3	1	0	1	-1
3919	1130	1345	\N	3	1	0	1	-1
3920	1130	1372	\N	3	1	0	1	-1
3921	1130	1402	\N	3	1	0	1	-1
3922	1198	8	\N	3	1	0	1	-1
3923	1198	50	\N	3	1	0	1	-1
3924	1198	109	\N	3	1	0	1	-1
3925	1198	110	\N	3	1	0	1	-1
3926	1198	155	\N	3	1	0	1	-1
3927	1198	156	\N	3	1	0	1	-1
3928	1198	205	\N	3	1	0	1	-1
3929	1198	344	\N	3	1	0	1	-1
3930	1198	386	\N	3	1	0	1	-1
3931	1198	436	\N	3	1	0	1	-1
3932	1198	559	\N	3	1	0	1	-1
3933	1198	588	\N	3	1	0	1	-1
3934	1198	589	\N	3	1	0	1	-1
3935	1198	634	\N	3	1	0	1	-1
3936	1198	683	\N	3	1	0	1	-1
3937	1198	729	\N	3	1	0	1	-1
3938	1198	1130	\N	3	1	0	1	-1
3939	1198	1344	\N	3	1	0	1	-1
3940	1198	1345	\N	3	1	0	1	-1
3941	1198	1372	\N	3	1	0	1	-1
3942	1198	1402	\N	3	1	0	1	-1
3943	1344	8	\N	3	1	0	1	-1
3944	1344	50	\N	3	1	0	1	-1
3945	1344	109	\N	3	1	0	1	-1
3946	1344	110	\N	3	1	0	1	-1
3947	1344	155	\N	3	1	0	1	-1
3948	1344	156	\N	3	1	0	1	-1
3949	1344	205	\N	3	1	0	1	-1
3950	1344	344	\N	3	1	0	1	-1
3951	1344	386	\N	3	1	0	1	-1
3952	1344	436	\N	3	1	0	1	-1
3953	1344	559	\N	3	1	0	1	-1
3954	1344	588	\N	3	1	0	1	-1
3955	1344	589	\N	3	1	0	1	-1
3956	1344	634	\N	3	1	0	1	-1
3957	1344	683	\N	3	1	0	1	-1
3958	1344	729	\N	3	1	0	1	-1
3959	1344	1130	\N	3	1	0	1	-1
3960	1344	1198	\N	3	1	0	1	-1
3961	1344	1345	\N	3	1	0	1	-1
3962	1344	1372	\N	3	1	0	1	-1
3963	1344	1402	\N	3	1	0	1	-1
3964	1345	8	\N	3	1	0	1	-1
3965	1345	50	\N	3	1	0	1	-1
3966	1345	109	\N	3	1	0	1	-1
3967	1345	110	\N	3	1	0	1	-1
3968	1345	155	\N	3	1	0	1	-1
3969	1345	156	\N	3	1	0	1	-1
3970	1345	205	\N	3	1	0	1	-1
3971	1345	344	\N	3	1	0	1	-1
3972	1345	386	\N	3	1	0	1	-1
3973	1345	436	\N	3	1	0	1	-1
3974	1345	559	\N	3	1	0	1	-1
3975	1345	588	\N	3	1	0	1	-1
3976	1345	589	\N	3	1	0	1	-1
3977	1345	634	\N	3	1	0	1	-1
3978	1345	683	\N	3	1	0	1	-1
3979	1345	729	\N	3	1	0	1	-1
3980	1345	1130	\N	3	1	0	1	-1
3981	1345	1198	\N	3	1	0	1	-1
3982	1345	1344	\N	3	1	0	1	-1
3983	1345	1372	\N	3	1	0	1	-1
3984	1345	1402	\N	3	1	0	1	-1
3985	1372	8	\N	3	1	0	1	-1
3986	1372	50	\N	3	1	0	1	-1
3987	1372	109	\N	3	1	0	1	-1
3988	1372	110	\N	3	1	0	1	-1
3989	1372	155	\N	3	1	0	1	-1
3990	1372	156	\N	3	1	0	1	-1
3991	1372	205	\N	3	1	0	1	-1
3992	1372	344	\N	3	1	0	1	-1
3993	1372	386	\N	3	1	0	1	-1
3994	1372	436	\N	3	1	0	1	-1
3995	1372	559	\N	3	1	0	1	-1
3996	1372	588	\N	3	1	0	1	-1
3997	1372	589	\N	3	1	0	1	-1
3998	1372	634	\N	3	1	0	1	-1
3999	1372	683	\N	3	1	0	1	-1
4000	1372	729	\N	3	1	0	1	-1
4001	1372	1130	\N	3	1	0	1	-1
4002	1372	1198	\N	3	1	0	1	-1
4003	1372	1344	\N	3	1	0	1	-1
4004	1372	1345	\N	3	1	0	1	-1
4005	1372	1402	\N	3	1	0	1	-1
4006	1402	8	\N	3	1	0	1	-1
4007	1402	50	\N	3	1	0	1	-1
4008	1402	109	\N	3	1	0	1	-1
4009	1402	110	\N	3	1	0	1	-1
4010	1402	155	\N	3	1	0	1	-1
4011	1402	156	\N	3	1	0	1	-1
4012	1402	205	\N	3	1	0	1	-1
4013	1402	344	\N	3	1	0	1	-1
4014	1402	386	\N	3	1	0	1	-1
4015	1402	436	\N	3	1	0	1	-1
4016	1402	559	\N	3	1	0	1	-1
4017	1402	588	\N	3	1	0	1	-1
4018	1402	589	\N	3	1	0	1	-1
4019	1402	634	\N	3	1	0	1	-1
4020	1402	683	\N	3	1	0	1	-1
4021	1402	729	\N	3	1	0	1	-1
4022	1402	1130	\N	3	1	0	1	-1
4023	1402	1198	\N	3	1	0	1	-1
4024	1402	1344	\N	3	1	0	1	-1
4025	1402	1345	\N	3	1	0	1	-1
4026	1402	1372	\N	3	1	0	1	-1
4027	9	32	\N	3	1	0	1	-1
4028	9	51	\N	3	1	0	1	-1
4029	9	84	\N	3	1	0	1	-1
4030	32	9	\N	3	1	0	1	-1
4031	32	51	\N	3	1	0	1	-1
4032	32	84	\N	3	1	0	1	-1
4033	51	9	\N	3	1	0	1	-1
4034	51	32	\N	3	1	0	1	-1
4035	51	84	\N	3	1	0	1	-1
4036	84	9	\N	3	1	0	1	-1
4037	84	32	\N	3	1	0	1	-1
4038	84	51	\N	3	1	0	1	-1
4039	10	31	\N	3	1	0	1	-1
4040	10	52	\N	3	1	0	1	-1
4041	10	83	\N	3	1	0	1	-1
4042	31	10	\N	3	1	0	1	-1
4043	31	52	\N	3	1	0	1	-1
4044	31	83	\N	3	1	0	1	-1
4045	52	10	\N	3	1	0	1	-1
4046	52	31	\N	3	1	0	1	-1
4047	52	83	\N	3	1	0	1	-1
4048	83	10	\N	3	1	0	1	-1
4049	83	31	\N	3	1	0	1	-1
4050	83	52	\N	3	1	0	1	-1
4051	11	30	\N	3	1	0	1	-1
4052	11	53	\N	3	1	0	1	-1
4053	11	82	\N	3	1	0	1	-1
4054	30	11	\N	3	1	0	1	-1
4055	30	53	\N	3	1	0	1	-1
4056	30	82	\N	3	1	0	1	-1
4057	53	11	\N	3	1	0	1	-1
4058	53	30	\N	3	1	0	1	-1
4059	53	82	\N	3	1	0	1	-1
4060	82	11	\N	3	1	0	1	-1
4061	82	30	\N	3	1	0	1	-1
4062	82	53	\N	3	1	0	1	-1
4063	12	29	\N	3	1	0	1	-1
4064	12	54	\N	3	1	0	1	-1
4065	12	81	\N	3	1	0	1	-1
4066	12	925	\N	3	1	0	1	-1
4067	29	12	\N	3	1	0	1	-1
4068	29	54	\N	3	1	0	1	-1
4069	29	81	\N	3	1	0	1	-1
4070	29	925	\N	3	1	0	1	-1
4071	54	12	\N	3	1	0	1	-1
4072	54	29	\N	3	1	0	1	-1
4073	54	81	\N	3	1	0	1	-1
4074	54	925	\N	3	1	0	1	-1
4075	81	12	\N	3	1	0	1	-1
4076	81	29	\N	3	1	0	1	-1
4077	81	54	\N	3	1	0	1	-1
4078	81	925	\N	3	1	0	1	-1
4079	925	12	\N	3	1	0	1	-1
4080	925	29	\N	3	1	0	1	-1
4081	925	54	\N	3	1	0	1	-1
4082	925	81	\N	3	1	0	1	-1
4083	13	28	\N	3	1	0	1	-1
4084	13	55	\N	3	1	0	1	-1
4085	13	80	\N	3	1	0	1	-1
4086	13	861	\N	3	1	0	1	-1
4087	13	926	\N	3	1	0	1	-1
4088	28	13	\N	3	1	0	1	-1
4089	28	55	\N	3	1	0	1	-1
4090	28	80	\N	3	1	0	1	-1
4091	28	861	\N	3	1	0	1	-1
4092	28	926	\N	3	1	0	1	-1
4093	55	13	\N	3	1	0	1	-1
4094	55	28	\N	3	1	0	1	-1
4095	55	80	\N	3	1	0	1	-1
4096	55	861	\N	3	1	0	1	-1
4097	55	926	\N	3	1	0	1	-1
4098	80	13	\N	3	1	0	1	-1
4099	80	28	\N	3	1	0	1	-1
4100	80	55	\N	3	1	0	1	-1
4101	80	861	\N	3	1	0	1	-1
4102	80	926	\N	3	1	0	1	-1
4103	861	13	\N	3	1	0	1	-1
4104	861	28	\N	3	1	0	1	-1
4105	861	55	\N	3	1	0	1	-1
4106	861	80	\N	3	1	0	1	-1
4107	861	926	\N	3	1	0	1	-1
4108	926	13	\N	3	1	0	1	-1
4109	926	28	\N	3	1	0	1	-1
4110	926	55	\N	3	1	0	1	-1
4111	926	80	\N	3	1	0	1	-1
4112	926	861	\N	3	1	0	1	-1
4113	14	27	\N	3	1	0	1	-1
4114	14	56	\N	3	1	0	1	-1
4115	14	79	\N	3	1	0	1	-1
4116	14	860	\N	3	1	0	1	-1
4117	14	927	\N	3	1	0	1	-1
4118	27	14	\N	3	1	0	1	-1
4119	27	56	\N	3	1	0	1	-1
4120	27	79	\N	3	1	0	1	-1
4121	27	860	\N	3	1	0	1	-1
4122	27	927	\N	3	1	0	1	-1
4123	56	14	\N	3	1	0	1	-1
4124	56	27	\N	3	1	0	1	-1
4125	56	79	\N	3	1	0	1	-1
4126	56	860	\N	3	1	0	1	-1
4127	56	927	\N	3	1	0	1	-1
4128	79	14	\N	3	1	0	1	-1
4129	79	27	\N	3	1	0	1	-1
4130	79	56	\N	3	1	0	1	-1
4131	79	860	\N	3	1	0	1	-1
4132	79	927	\N	3	1	0	1	-1
4133	860	14	\N	3	1	0	1	-1
4134	860	27	\N	3	1	0	1	-1
4135	860	56	\N	3	1	0	1	-1
4136	860	79	\N	3	1	0	1	-1
4137	860	927	\N	3	1	0	1	-1
4138	927	14	\N	3	1	0	1	-1
4139	927	27	\N	3	1	0	1	-1
4140	927	56	\N	3	1	0	1	-1
4141	927	79	\N	3	1	0	1	-1
4142	927	860	\N	3	1	0	1	-1
4143	15	26	\N	3	1	0	1	-1
4144	15	57	\N	3	1	0	1	-1
4145	15	78	\N	3	1	0	1	-1
4146	15	277	\N	3	1	0	1	-1
4147	15	298	\N	3	1	0	1	-1
4148	15	859	\N	3	1	0	1	-1
4149	15	928	\N	3	1	0	1	-1
4150	15	975	\N	3	1	0	1	-1
4151	15	1015	\N	3	1	0	1	-1
4152	15	1489	\N	3	1	0	1	-1
4153	15	1496	\N	3	1	0	1	-1
4154	26	15	\N	3	1	0	1	-1
4155	26	57	\N	3	1	0	1	-1
4156	26	78	\N	3	1	0	1	-1
4157	26	277	\N	3	1	0	1	-1
4158	26	298	\N	3	1	0	1	-1
4159	26	859	\N	3	1	0	1	-1
4160	26	928	\N	3	1	0	1	-1
4161	26	975	\N	3	1	0	1	-1
4162	26	1015	\N	3	1	0	1	-1
4163	26	1489	\N	3	1	0	1	-1
4164	26	1496	\N	3	1	0	1	-1
4165	57	15	\N	3	1	0	1	-1
4166	57	26	\N	3	1	0	1	-1
4167	57	78	\N	3	1	0	1	-1
4168	57	277	\N	3	1	0	1	-1
4169	57	298	\N	3	1	0	1	-1
4170	57	859	\N	3	1	0	1	-1
4171	57	928	\N	3	1	0	1	-1
4172	57	975	\N	3	1	0	1	-1
4173	57	1015	\N	3	1	0	1	-1
4174	57	1489	\N	3	1	0	1	-1
4175	57	1496	\N	3	1	0	1	-1
4176	78	15	\N	3	1	0	1	-1
4177	78	26	\N	3	1	0	1	-1
4178	78	57	\N	3	1	0	1	-1
4179	78	277	\N	3	1	0	1	-1
4180	78	298	\N	3	1	0	1	-1
4181	78	859	\N	3	1	0	1	-1
4182	78	928	\N	3	1	0	1	-1
4183	78	975	\N	3	1	0	1	-1
4184	78	1015	\N	3	1	0	1	-1
4185	78	1489	\N	3	1	0	1	-1
4186	78	1496	\N	3	1	0	1	-1
4187	277	15	\N	3	1	0	1	-1
4188	277	26	\N	3	1	0	1	-1
4189	277	57	\N	3	1	0	1	-1
4190	277	78	\N	3	1	0	1	-1
4191	277	298	\N	3	1	0	1	-1
4192	277	859	\N	3	1	0	1	-1
4193	277	928	\N	3	1	0	1	-1
4194	277	975	\N	3	1	0	1	-1
4195	277	1015	\N	3	1	0	1	-1
4196	277	1489	\N	3	1	0	1	-1
4197	277	1496	\N	3	1	0	1	-1
4198	298	15	\N	3	1	0	1	-1
4199	298	26	\N	3	1	0	1	-1
4200	298	57	\N	3	1	0	1	-1
4201	298	78	\N	3	1	0	1	-1
4202	298	277	\N	3	1	0	1	-1
4203	298	859	\N	3	1	0	1	-1
4204	298	928	\N	3	1	0	1	-1
4205	298	975	\N	3	1	0	1	-1
4206	298	1015	\N	3	1	0	1	-1
4207	298	1489	\N	3	1	0	1	-1
4208	298	1496	\N	3	1	0	1	-1
4209	859	15	\N	3	1	0	1	-1
4210	859	26	\N	3	1	0	1	-1
4211	859	57	\N	3	1	0	1	-1
4212	859	78	\N	3	1	0	1	-1
4213	859	277	\N	3	1	0	1	-1
4214	859	298	\N	3	1	0	1	-1
4215	859	928	\N	3	1	0	1	-1
4216	859	975	\N	3	1	0	1	-1
4217	859	1015	\N	3	1	0	1	-1
4218	859	1489	\N	3	1	0	1	-1
4219	859	1496	\N	3	1	0	1	-1
4220	928	15	\N	3	1	0	1	-1
4221	928	26	\N	3	1	0	1	-1
4222	928	57	\N	3	1	0	1	-1
4223	928	78	\N	3	1	0	1	-1
4224	928	277	\N	3	1	0	1	-1
4225	928	298	\N	3	1	0	1	-1
4226	928	859	\N	3	1	0	1	-1
4227	928	975	\N	3	1	0	1	-1
4228	928	1015	\N	3	1	0	1	-1
4229	928	1489	\N	3	1	0	1	-1
4230	928	1496	\N	3	1	0	1	-1
4231	975	15	\N	3	1	0	1	-1
4232	975	26	\N	3	1	0	1	-1
4233	975	57	\N	3	1	0	1	-1
4234	975	78	\N	3	1	0	1	-1
4235	975	277	\N	3	1	0	1	-1
4236	975	298	\N	3	1	0	1	-1
4237	975	859	\N	3	1	0	1	-1
4238	975	928	\N	3	1	0	1	-1
4239	975	1015	\N	3	1	0	1	-1
4240	975	1489	\N	3	1	0	1	-1
4241	975	1496	\N	3	1	0	1	-1
4242	1015	15	\N	3	1	0	1	-1
4243	1015	26	\N	3	1	0	1	-1
4244	1015	57	\N	3	1	0	1	-1
4245	1015	78	\N	3	1	0	1	-1
4246	1015	277	\N	3	1	0	1	-1
4247	1015	298	\N	3	1	0	1	-1
4248	1015	859	\N	3	1	0	1	-1
4249	1015	928	\N	3	1	0	1	-1
4250	1015	975	\N	3	1	0	1	-1
4251	1015	1489	\N	3	1	0	1	-1
4252	1015	1496	\N	3	1	0	1	-1
4253	1489	15	\N	3	1	0	1	-1
4254	1489	26	\N	3	1	0	1	-1
4255	1489	57	\N	3	1	0	1	-1
4256	1489	78	\N	3	1	0	1	-1
4257	1489	277	\N	3	1	0	1	-1
4258	1489	298	\N	3	1	0	1	-1
4259	1489	859	\N	3	1	0	1	-1
4260	1489	928	\N	3	1	0	1	-1
4261	1489	975	\N	3	1	0	1	-1
4262	1489	1015	\N	3	1	0	1	-1
4263	1489	1496	\N	3	1	0	1	-1
4264	1496	15	\N	3	1	0	1	-1
4265	1496	26	\N	3	1	0	1	-1
4266	1496	57	\N	3	1	0	1	-1
4267	1496	78	\N	3	1	0	1	-1
4268	1496	277	\N	3	1	0	1	-1
4269	1496	298	\N	3	1	0	1	-1
4270	1496	859	\N	3	1	0	1	-1
4271	1496	928	\N	3	1	0	1	-1
4272	1496	975	\N	3	1	0	1	-1
4273	1496	1015	\N	3	1	0	1	-1
4274	1496	1489	\N	3	1	0	1	-1
4275	16	25	\N	3	1	0	1	-1
4276	16	276	\N	3	1	0	1	-1
4277	16	299	\N	3	1	0	1	-1
4278	16	974	\N	3	1	0	1	-1
4279	16	1016	\N	3	1	0	1	-1
4280	16	1488	\N	3	1	0	1	-1
4281	16	1497	\N	3	1	0	1	-1
4282	25	16	\N	3	1	0	1	-1
4283	25	276	\N	3	1	0	1	-1
4284	25	299	\N	3	1	0	1	-1
4285	25	974	\N	3	1	0	1	-1
4286	25	1016	\N	3	1	0	1	-1
4287	25	1488	\N	3	1	0	1	-1
4288	25	1497	\N	3	1	0	1	-1
4289	276	16	\N	3	1	0	1	-1
4290	276	25	\N	3	1	0	1	-1
4291	276	299	\N	3	1	0	1	-1
4292	276	974	\N	3	1	0	1	-1
4293	276	1016	\N	3	1	0	1	-1
4294	276	1488	\N	3	1	0	1	-1
4295	276	1497	\N	3	1	0	1	-1
4296	299	16	\N	3	1	0	1	-1
4297	299	25	\N	3	1	0	1	-1
4298	299	276	\N	3	1	0	1	-1
4299	299	974	\N	3	1	0	1	-1
4300	299	1016	\N	3	1	0	1	-1
4301	299	1488	\N	3	1	0	1	-1
4302	299	1497	\N	3	1	0	1	-1
4303	974	16	\N	3	1	0	1	-1
4304	974	25	\N	3	1	0	1	-1
4305	974	276	\N	3	1	0	1	-1
4306	974	299	\N	3	1	0	1	-1
4307	974	1016	\N	3	1	0	1	-1
4308	974	1488	\N	3	1	0	1	-1
4309	974	1497	\N	3	1	0	1	-1
4310	1016	16	\N	3	1	0	1	-1
4311	1016	25	\N	3	1	0	1	-1
4312	1016	276	\N	3	1	0	1	-1
4313	1016	299	\N	3	1	0	1	-1
4314	1016	974	\N	3	1	0	1	-1
4315	1016	1488	\N	3	1	0	1	-1
4316	1016	1497	\N	3	1	0	1	-1
4317	1488	16	\N	3	1	0	1	-1
4318	1488	25	\N	3	1	0	1	-1
4319	1488	276	\N	3	1	0	1	-1
4320	1488	299	\N	3	1	0	1	-1
4321	1488	974	\N	3	1	0	1	-1
4322	1488	1016	\N	3	1	0	1	-1
4323	1488	1497	\N	3	1	0	1	-1
4324	1497	16	\N	3	1	0	1	-1
4325	1497	25	\N	3	1	0	1	-1
4326	1497	276	\N	3	1	0	1	-1
4327	1497	299	\N	3	1	0	1	-1
4328	1497	974	\N	3	1	0	1	-1
4329	1497	1016	\N	3	1	0	1	-1
4330	1497	1488	\N	3	1	0	1	-1
4331	17	24	\N	3	1	0	1	-1
4332	17	275	\N	3	1	0	1	-1
4333	17	300	\N	3	1	0	1	-1
4334	17	973	\N	3	1	0	1	-1
4335	17	1017	\N	3	1	0	1	-1
4336	17	1487	\N	3	1	0	1	-1
4337	17	1498	\N	3	1	0	1	-1
4338	24	17	\N	3	1	0	1	-1
4339	24	275	\N	3	1	0	1	-1
4340	24	300	\N	3	1	0	1	-1
4341	24	973	\N	3	1	0	1	-1
4342	24	1017	\N	3	1	0	1	-1
4343	24	1487	\N	3	1	0	1	-1
4344	24	1498	\N	3	1	0	1	-1
4345	275	17	\N	3	1	0	1	-1
4346	275	24	\N	3	1	0	1	-1
4347	275	300	\N	3	1	0	1	-1
4348	275	973	\N	3	1	0	1	-1
4349	275	1017	\N	3	1	0	1	-1
4350	275	1487	\N	3	1	0	1	-1
4351	275	1498	\N	3	1	0	1	-1
4352	300	17	\N	3	1	0	1	-1
4353	300	24	\N	3	1	0	1	-1
4354	300	275	\N	3	1	0	1	-1
4355	300	973	\N	3	1	0	1	-1
4356	300	1017	\N	3	1	0	1	-1
4357	300	1487	\N	3	1	0	1	-1
4358	300	1498	\N	3	1	0	1	-1
4359	973	17	\N	3	1	0	1	-1
4360	973	24	\N	3	1	0	1	-1
4361	973	275	\N	3	1	0	1	-1
4362	973	300	\N	3	1	0	1	-1
4363	973	1017	\N	3	1	0	1	-1
4364	973	1487	\N	3	1	0	1	-1
4365	973	1498	\N	3	1	0	1	-1
4366	1017	17	\N	3	1	0	1	-1
4367	1017	24	\N	3	1	0	1	-1
4368	1017	275	\N	3	1	0	1	-1
4369	1017	300	\N	3	1	0	1	-1
4370	1017	973	\N	3	1	0	1	-1
4371	1017	1487	\N	3	1	0	1	-1
4372	1017	1498	\N	3	1	0	1	-1
4373	1487	17	\N	3	1	0	1	-1
4374	1487	24	\N	3	1	0	1	-1
4375	1487	275	\N	3	1	0	1	-1
4376	1487	300	\N	3	1	0	1	-1
4377	1487	973	\N	3	1	0	1	-1
4378	1487	1017	\N	3	1	0	1	-1
4379	1487	1498	\N	3	1	0	1	-1
4380	1498	17	\N	3	1	0	1	-1
4381	1498	24	\N	3	1	0	1	-1
4382	1498	275	\N	3	1	0	1	-1
4383	1498	300	\N	3	1	0	1	-1
4384	1498	973	\N	3	1	0	1	-1
4385	1498	1017	\N	3	1	0	1	-1
4386	1498	1487	\N	3	1	0	1	-1
4387	18	23	\N	3	1	0	1	-1
4388	18	274	\N	3	1	0	1	-1
4389	18	301	\N	3	1	0	1	-1
4390	18	972	\N	3	1	0	1	-1
4391	18	1018	\N	3	1	0	1	-1
4392	18	1486	\N	3	1	0	1	-1
4393	18	1499	\N	3	1	0	1	-1
4394	23	18	\N	3	1	0	1	-1
4395	23	274	\N	3	1	0	1	-1
4396	23	301	\N	3	1	0	1	-1
4397	23	972	\N	3	1	0	1	-1
4398	23	1018	\N	3	1	0	1	-1
4399	23	1486	\N	3	1	0	1	-1
4400	23	1499	\N	3	1	0	1	-1
4401	274	18	\N	3	1	0	1	-1
4402	274	23	\N	3	1	0	1	-1
4403	274	301	\N	3	1	0	1	-1
4404	274	972	\N	3	1	0	1	-1
4405	274	1018	\N	3	1	0	1	-1
4406	274	1486	\N	3	1	0	1	-1
4407	274	1499	\N	3	1	0	1	-1
4408	301	18	\N	3	1	0	1	-1
4409	301	23	\N	3	1	0	1	-1
4410	301	274	\N	3	1	0	1	-1
4411	301	972	\N	3	1	0	1	-1
4412	301	1018	\N	3	1	0	1	-1
4413	301	1486	\N	3	1	0	1	-1
4414	301	1499	\N	3	1	0	1	-1
4415	972	18	\N	3	1	0	1	-1
4416	972	23	\N	3	1	0	1	-1
4417	972	274	\N	3	1	0	1	-1
4418	972	301	\N	3	1	0	1	-1
4419	972	1018	\N	3	1	0	1	-1
4420	972	1486	\N	3	1	0	1	-1
4421	972	1499	\N	3	1	0	1	-1
4422	1018	18	\N	3	1	0	1	-1
4423	1018	23	\N	3	1	0	1	-1
4424	1018	274	\N	3	1	0	1	-1
4425	1018	301	\N	3	1	0	1	-1
4426	1018	972	\N	3	1	0	1	-1
4427	1018	1486	\N	3	1	0	1	-1
4428	1018	1499	\N	3	1	0	1	-1
4429	1486	18	\N	3	1	0	1	-1
4430	1486	23	\N	3	1	0	1	-1
4431	1486	274	\N	3	1	0	1	-1
4432	1486	301	\N	3	1	0	1	-1
4433	1486	972	\N	3	1	0	1	-1
4434	1486	1018	\N	3	1	0	1	-1
4435	1486	1499	\N	3	1	0	1	-1
4436	1499	18	\N	3	1	0	1	-1
4437	1499	23	\N	3	1	0	1	-1
4438	1499	274	\N	3	1	0	1	-1
4439	1499	301	\N	3	1	0	1	-1
4440	1499	972	\N	3	1	0	1	-1
4441	1499	1018	\N	3	1	0	1	-1
4442	1499	1486	\N	3	1	0	1	-1
4443	19	22	\N	3	1	0	1	-1
4444	19	273	\N	3	1	0	1	-1
4445	19	302	\N	3	1	0	1	-1
4446	19	971	\N	3	1	0	1	-1
4447	19	1019	\N	3	1	0	1	-1
4448	19	1485	\N	3	1	0	1	-1
4449	19	1500	\N	3	1	0	1	-1
4450	22	19	\N	3	1	0	1	-1
4451	22	273	\N	3	1	0	1	-1
4452	22	302	\N	3	1	0	1	-1
4453	22	971	\N	3	1	0	1	-1
4454	22	1019	\N	3	1	0	1	-1
4455	22	1485	\N	3	1	0	1	-1
4456	22	1500	\N	3	1	0	1	-1
4457	273	19	\N	3	1	0	1	-1
4458	273	22	\N	3	1	0	1	-1
4459	273	302	\N	3	1	0	1	-1
4460	273	971	\N	3	1	0	1	-1
4461	273	1019	\N	3	1	0	1	-1
4462	273	1485	\N	3	1	0	1	-1
4463	273	1500	\N	3	1	0	1	-1
4464	302	19	\N	3	1	0	1	-1
4465	302	22	\N	3	1	0	1	-1
4466	302	273	\N	3	1	0	1	-1
4467	302	971	\N	3	1	0	1	-1
4468	302	1019	\N	3	1	0	1	-1
4469	302	1485	\N	3	1	0	1	-1
4470	302	1500	\N	3	1	0	1	-1
4471	971	19	\N	3	1	0	1	-1
4472	971	22	\N	3	1	0	1	-1
4473	971	273	\N	3	1	0	1	-1
4474	971	302	\N	3	1	0	1	-1
4475	971	1019	\N	3	1	0	1	-1
4476	971	1485	\N	3	1	0	1	-1
4477	971	1500	\N	3	1	0	1	-1
4478	1019	19	\N	3	1	0	1	-1
4479	1019	22	\N	3	1	0	1	-1
4480	1019	273	\N	3	1	0	1	-1
4481	1019	302	\N	3	1	0	1	-1
4482	1019	971	\N	3	1	0	1	-1
4483	1019	1485	\N	3	1	0	1	-1
4484	1019	1500	\N	3	1	0	1	-1
4485	1485	19	\N	3	1	0	1	-1
4486	1485	22	\N	3	1	0	1	-1
4487	1485	273	\N	3	1	0	1	-1
4488	1485	302	\N	3	1	0	1	-1
4489	1485	971	\N	3	1	0	1	-1
4490	1485	1019	\N	3	1	0	1	-1
4491	1485	1500	\N	3	1	0	1	-1
4492	1500	19	\N	3	1	0	1	-1
4493	1500	22	\N	3	1	0	1	-1
4494	1500	273	\N	3	1	0	1	-1
4495	1500	302	\N	3	1	0	1	-1
4496	1500	971	\N	3	1	0	1	-1
4497	1500	1019	\N	3	1	0	1	-1
4498	1500	1485	\N	3	1	0	1	-1
4499	20	21	\N	3	1	0	1	-1
4500	21	20	\N	3	1	0	1	-1
4501	33	85	\N	3	1	0	1	-1
4502	33	111	\N	3	1	0	1	-1
4503	33	157	\N	3	1	0	1	-1
4504	33	345	\N	3	1	0	1	-1
4505	33	346	\N	3	1	0	1	-1
4506	33	387	\N	3	1	0	1	-1
4507	33	388	\N	3	1	0	1	-1
4508	33	408	\N	3	1	0	1	-1
4509	33	437	\N	3	1	0	1	-1
4510	33	561	\N	3	1	0	1	-1
4511	33	591	\N	3	1	0	1	-1
4512	85	33	\N	3	1	0	1	-1
4513	85	111	\N	3	1	0	1	-1
4514	85	157	\N	3	1	0	1	-1
4515	85	345	\N	3	1	0	1	-1
4516	85	346	\N	3	1	0	1	-1
4517	85	387	\N	3	1	0	1	-1
4518	85	388	\N	3	1	0	1	-1
4519	85	408	\N	3	1	0	1	-1
4520	85	437	\N	3	1	0	1	-1
4521	85	561	\N	3	1	0	1	-1
4522	85	591	\N	3	1	0	1	-1
4523	111	33	\N	3	1	0	1	-1
4524	111	85	\N	3	1	0	1	-1
4525	111	157	\N	3	1	0	1	-1
4526	111	345	\N	3	1	0	1	-1
4527	111	346	\N	3	1	0	1	-1
4528	111	387	\N	3	1	0	1	-1
4529	111	388	\N	3	1	0	1	-1
4530	111	408	\N	3	1	0	1	-1
4531	111	437	\N	3	1	0	1	-1
4532	111	561	\N	3	1	0	1	-1
4533	111	591	\N	3	1	0	1	-1
4534	157	33	\N	3	1	0	1	-1
4535	157	85	\N	3	1	0	1	-1
4536	157	111	\N	3	1	0	1	-1
4537	157	345	\N	3	1	0	1	-1
4538	157	346	\N	3	1	0	1	-1
4539	157	387	\N	3	1	0	1	-1
4540	157	388	\N	3	1	0	1	-1
4541	157	408	\N	3	1	0	1	-1
4542	157	437	\N	3	1	0	1	-1
4543	157	561	\N	3	1	0	1	-1
4544	157	591	\N	3	1	0	1	-1
4545	345	33	\N	3	1	0	1	-1
4546	345	85	\N	3	1	0	1	-1
4547	345	111	\N	3	1	0	1	-1
4548	345	157	\N	3	1	0	1	-1
4549	345	346	\N	3	1	0	1	-1
4550	345	387	\N	3	1	0	1	-1
4551	345	388	\N	3	1	0	1	-1
4552	345	408	\N	3	1	0	1	-1
4553	345	437	\N	3	1	0	1	-1
4554	345	561	\N	3	1	0	1	-1
4555	345	591	\N	3	1	0	1	-1
4556	346	33	\N	3	1	0	1	-1
4557	346	85	\N	3	1	0	1	-1
4558	346	111	\N	3	1	0	1	-1
4559	346	157	\N	3	1	0	1	-1
4560	346	345	\N	3	1	0	1	-1
4561	346	387	\N	3	1	0	1	-1
4562	346	388	\N	3	1	0	1	-1
4563	346	408	\N	3	1	0	1	-1
4564	346	437	\N	3	1	0	1	-1
4565	346	561	\N	3	1	0	1	-1
4566	346	591	\N	3	1	0	1	-1
4567	387	33	\N	3	1	0	1	-1
4568	387	85	\N	3	1	0	1	-1
4569	387	111	\N	3	1	0	1	-1
4570	387	157	\N	3	1	0	1	-1
4571	387	345	\N	3	1	0	1	-1
4572	387	346	\N	3	1	0	1	-1
4573	387	388	\N	3	1	0	1	-1
4574	387	408	\N	3	1	0	1	-1
4575	387	437	\N	3	1	0	1	-1
4576	387	561	\N	3	1	0	1	-1
4577	387	591	\N	3	1	0	1	-1
4578	388	33	\N	3	1	0	1	-1
4579	388	85	\N	3	1	0	1	-1
4580	388	111	\N	3	1	0	1	-1
4581	388	157	\N	3	1	0	1	-1
4582	388	345	\N	3	1	0	1	-1
4583	388	346	\N	3	1	0	1	-1
4584	388	387	\N	3	1	0	1	-1
4585	388	408	\N	3	1	0	1	-1
4586	388	437	\N	3	1	0	1	-1
4587	388	561	\N	3	1	0	1	-1
4588	388	591	\N	3	1	0	1	-1
4589	408	33	\N	3	1	0	1	-1
4590	408	85	\N	3	1	0	1	-1
4591	408	111	\N	3	1	0	1	-1
4592	408	157	\N	3	1	0	1	-1
4593	408	345	\N	3	1	0	1	-1
4594	408	346	\N	3	1	0	1	-1
4595	408	387	\N	3	1	0	1	-1
4596	408	388	\N	3	1	0	1	-1
4597	408	437	\N	3	1	0	1	-1
4598	408	561	\N	3	1	0	1	-1
4599	408	591	\N	3	1	0	1	-1
4600	437	33	\N	3	1	0	1	-1
4601	437	85	\N	3	1	0	1	-1
4602	437	111	\N	3	1	0	1	-1
4603	437	157	\N	3	1	0	1	-1
4604	437	345	\N	3	1	0	1	-1
4605	437	346	\N	3	1	0	1	-1
4606	437	387	\N	3	1	0	1	-1
4607	437	388	\N	3	1	0	1	-1
4608	437	408	\N	3	1	0	1	-1
4609	437	561	\N	3	1	0	1	-1
4610	437	591	\N	3	1	0	1	-1
4611	561	33	\N	3	1	0	1	-1
4612	561	85	\N	3	1	0	1	-1
4613	561	111	\N	3	1	0	1	-1
4614	561	157	\N	3	1	0	1	-1
4615	561	345	\N	3	1	0	1	-1
4616	561	346	\N	3	1	0	1	-1
4617	561	387	\N	3	1	0	1	-1
4618	561	388	\N	3	1	0	1	-1
4619	561	408	\N	3	1	0	1	-1
4620	561	437	\N	3	1	0	1	-1
4621	561	591	\N	3	1	0	1	-1
4622	591	33	\N	3	1	0	1	-1
4623	591	85	\N	3	1	0	1	-1
4624	591	111	\N	3	1	0	1	-1
4625	591	157	\N	3	1	0	1	-1
4626	591	345	\N	3	1	0	1	-1
4627	591	346	\N	3	1	0	1	-1
4628	591	387	\N	3	1	0	1	-1
4629	591	388	\N	3	1	0	1	-1
4630	591	408	\N	3	1	0	1	-1
4631	591	437	\N	3	1	0	1	-1
4632	591	561	\N	3	1	0	1	-1
4633	34	86	\N	3	1	0	1	-1
4634	34	112	\N	3	1	0	1	-1
4635	34	158	\N	3	1	0	1	-1
4636	34	207	\N	3	1	0	1	-1
4637	34	347	\N	3	1	0	1	-1
4638	34	389	\N	3	1	0	1	-1
4639	34	409	\N	3	1	0	1	-1
4640	34	586	\N	3	1	0	1	-1
4641	34	632	\N	3	1	0	1	-1
4642	34	686	\N	3	1	0	1	-1
4643	34	1132	\N	3	1	0	1	-1
4644	34	1347	\N	3	1	0	1	-1
4645	34	1374	\N	3	1	0	1	-1
4646	86	34	\N	3	1	0	1	-1
4647	86	112	\N	3	1	0	1	-1
4648	86	158	\N	3	1	0	1	-1
4649	86	207	\N	3	1	0	1	-1
4650	86	347	\N	3	1	0	1	-1
4651	86	389	\N	3	1	0	1	-1
4652	86	409	\N	3	1	0	1	-1
4653	86	586	\N	3	1	0	1	-1
4654	86	632	\N	3	1	0	1	-1
4655	86	686	\N	3	1	0	1	-1
4656	86	1132	\N	3	1	0	1	-1
4657	86	1347	\N	3	1	0	1	-1
4658	86	1374	\N	3	1	0	1	-1
4659	112	34	\N	3	1	0	1	-1
4660	112	86	\N	3	1	0	1	-1
4661	112	158	\N	3	1	0	1	-1
4662	112	207	\N	3	1	0	1	-1
4663	112	347	\N	3	1	0	1	-1
4664	112	389	\N	3	1	0	1	-1
4665	112	409	\N	3	1	0	1	-1
4666	112	586	\N	3	1	0	1	-1
4667	112	632	\N	3	1	0	1	-1
4668	112	686	\N	3	1	0	1	-1
4669	112	1132	\N	3	1	0	1	-1
4670	112	1347	\N	3	1	0	1	-1
4671	112	1374	\N	3	1	0	1	-1
4672	158	34	\N	3	1	0	1	-1
4673	158	86	\N	3	1	0	1	-1
4674	158	112	\N	3	1	0	1	-1
4675	158	207	\N	3	1	0	1	-1
4676	158	347	\N	3	1	0	1	-1
4677	158	389	\N	3	1	0	1	-1
4678	158	409	\N	3	1	0	1	-1
4679	158	586	\N	3	1	0	1	-1
4680	158	632	\N	3	1	0	1	-1
4681	158	686	\N	3	1	0	1	-1
4682	158	1132	\N	3	1	0	1	-1
4683	158	1347	\N	3	1	0	1	-1
4684	158	1374	\N	3	1	0	1	-1
4685	207	34	\N	3	1	0	1	-1
4686	207	86	\N	3	1	0	1	-1
4687	207	112	\N	3	1	0	1	-1
4688	207	158	\N	3	1	0	1	-1
4689	207	347	\N	3	1	0	1	-1
4690	207	389	\N	3	1	0	1	-1
4691	207	409	\N	3	1	0	1	-1
4692	207	586	\N	3	1	0	1	-1
4693	207	632	\N	3	1	0	1	-1
4694	207	686	\N	3	1	0	1	-1
4695	207	1132	\N	3	1	0	1	-1
4696	207	1347	\N	3	1	0	1	-1
4697	207	1374	\N	3	1	0	1	-1
4698	347	34	\N	3	1	0	1	-1
4699	347	86	\N	3	1	0	1	-1
4700	347	112	\N	3	1	0	1	-1
4701	347	158	\N	3	1	0	1	-1
4702	347	207	\N	3	1	0	1	-1
4703	347	389	\N	3	1	0	1	-1
4704	347	409	\N	3	1	0	1	-1
4705	347	586	\N	3	1	0	1	-1
4706	347	632	\N	3	1	0	1	-1
4707	347	686	\N	3	1	0	1	-1
4708	347	1132	\N	3	1	0	1	-1
4709	347	1347	\N	3	1	0	1	-1
4710	347	1374	\N	3	1	0	1	-1
4711	389	34	\N	3	1	0	1	-1
4712	389	86	\N	3	1	0	1	-1
4713	389	112	\N	3	1	0	1	-1
4714	389	158	\N	3	1	0	1	-1
4715	389	207	\N	3	1	0	1	-1
4716	389	347	\N	3	1	0	1	-1
4717	389	409	\N	3	1	0	1	-1
4718	389	586	\N	3	1	0	1	-1
4719	389	632	\N	3	1	0	1	-1
4720	389	686	\N	3	1	0	1	-1
4721	389	1132	\N	3	1	0	1	-1
4722	389	1347	\N	3	1	0	1	-1
4723	389	1374	\N	3	1	0	1	-1
4724	409	34	\N	3	1	0	1	-1
4725	409	86	\N	3	1	0	1	-1
4726	409	112	\N	3	1	0	1	-1
4727	409	158	\N	3	1	0	1	-1
4728	409	207	\N	3	1	0	1	-1
4729	409	347	\N	3	1	0	1	-1
4730	409	389	\N	3	1	0	1	-1
4731	409	586	\N	3	1	0	1	-1
4732	409	632	\N	3	1	0	1	-1
4733	409	686	\N	3	1	0	1	-1
4734	409	1132	\N	3	1	0	1	-1
4735	409	1347	\N	3	1	0	1	-1
4736	409	1374	\N	3	1	0	1	-1
4737	586	34	\N	3	1	0	1	-1
4738	586	86	\N	3	1	0	1	-1
4739	586	112	\N	3	1	0	1	-1
4740	586	158	\N	3	1	0	1	-1
4741	586	207	\N	3	1	0	1	-1
4742	586	347	\N	3	1	0	1	-1
4743	586	389	\N	3	1	0	1	-1
4744	586	409	\N	3	1	0	1	-1
4745	586	632	\N	3	1	0	1	-1
4746	586	686	\N	3	1	0	1	-1
4747	586	1132	\N	3	1	0	1	-1
4748	586	1347	\N	3	1	0	1	-1
4749	586	1374	\N	3	1	0	1	-1
4750	632	34	\N	3	1	0	1	-1
4751	632	86	\N	3	1	0	1	-1
4752	632	112	\N	3	1	0	1	-1
4753	632	158	\N	3	1	0	1	-1
4754	632	207	\N	3	1	0	1	-1
4755	632	347	\N	3	1	0	1	-1
4756	632	389	\N	3	1	0	1	-1
4757	632	409	\N	3	1	0	1	-1
4758	632	586	\N	3	1	0	1	-1
4759	632	686	\N	3	1	0	1	-1
4760	632	1132	\N	3	1	0	1	-1
4761	632	1347	\N	3	1	0	1	-1
4762	632	1374	\N	3	1	0	1	-1
4763	686	34	\N	3	1	0	1	-1
4764	686	86	\N	3	1	0	1	-1
4765	686	112	\N	3	1	0	1	-1
4766	686	158	\N	3	1	0	1	-1
4767	686	207	\N	3	1	0	1	-1
4768	686	347	\N	3	1	0	1	-1
4769	686	389	\N	3	1	0	1	-1
4770	686	409	\N	3	1	0	1	-1
4771	686	586	\N	3	1	0	1	-1
4772	686	632	\N	3	1	0	1	-1
4773	686	1132	\N	3	1	0	1	-1
4774	686	1347	\N	3	1	0	1	-1
4775	686	1374	\N	3	1	0	1	-1
4776	1132	34	\N	3	1	0	1	-1
4777	1132	86	\N	3	1	0	1	-1
4778	1132	112	\N	3	1	0	1	-1
4779	1132	158	\N	3	1	0	1	-1
4780	1132	207	\N	3	1	0	1	-1
4781	1132	347	\N	3	1	0	1	-1
4782	1132	389	\N	3	1	0	1	-1
4783	1132	409	\N	3	1	0	1	-1
4784	1132	586	\N	3	1	0	1	-1
4785	1132	632	\N	3	1	0	1	-1
4786	1132	686	\N	3	1	0	1	-1
4787	1132	1347	\N	3	1	0	1	-1
4788	1132	1374	\N	3	1	0	1	-1
4789	1347	34	\N	3	1	0	1	-1
4790	1347	86	\N	3	1	0	1	-1
4791	1347	112	\N	3	1	0	1	-1
4792	1347	158	\N	3	1	0	1	-1
4793	1347	207	\N	3	1	0	1	-1
4794	1347	347	\N	3	1	0	1	-1
4795	1347	389	\N	3	1	0	1	-1
4796	1347	409	\N	3	1	0	1	-1
4797	1347	586	\N	3	1	0	1	-1
4798	1347	632	\N	3	1	0	1	-1
4799	1347	686	\N	3	1	0	1	-1
4800	1347	1132	\N	3	1	0	1	-1
4801	1347	1374	\N	3	1	0	1	-1
4802	1374	34	\N	3	1	0	1	-1
4803	1374	86	\N	3	1	0	1	-1
4804	1374	112	\N	3	1	0	1	-1
4805	1374	158	\N	3	1	0	1	-1
4806	1374	207	\N	3	1	0	1	-1
4807	1374	347	\N	3	1	0	1	-1
4808	1374	389	\N	3	1	0	1	-1
4809	1374	409	\N	3	1	0	1	-1
4810	1374	586	\N	3	1	0	1	-1
4811	1374	632	\N	3	1	0	1	-1
4812	1374	686	\N	3	1	0	1	-1
4813	1374	1132	\N	3	1	0	1	-1
4814	1374	1347	\N	3	1	0	1	-1
4815	35	87	\N	3	1	0	1	-1
4816	35	113	\N	3	1	0	1	-1
4817	35	159	\N	3	1	0	1	-1
4818	35	234	\N	3	1	0	1	-1
4819	35	348	\N	3	1	0	1	-1
4820	35	390	\N	3	1	0	1	-1
4821	35	410	\N	3	1	0	1	-1
4822	35	587	\N	3	1	0	1	-1
4823	35	633	\N	3	1	0	1	-1
4824	35	1112	\N	3	1	0	1	-1
4825	35	1197	\N	3	1	0	1	-1
4826	35	1343	\N	3	1	0	1	-1
4827	35	1375	\N	3	1	0	1	-1
4828	87	35	\N	3	1	0	1	-1
4829	87	113	\N	3	1	0	1	-1
4830	87	159	\N	3	1	0	1	-1
4831	87	234	\N	3	1	0	1	-1
4832	87	348	\N	3	1	0	1	-1
4833	87	390	\N	3	1	0	1	-1
4834	87	410	\N	3	1	0	1	-1
4835	87	587	\N	3	1	0	1	-1
4836	87	633	\N	3	1	0	1	-1
4837	87	1112	\N	3	1	0	1	-1
4838	87	1197	\N	3	1	0	1	-1
4839	87	1343	\N	3	1	0	1	-1
4840	87	1375	\N	3	1	0	1	-1
4841	113	35	\N	3	1	0	1	-1
4842	113	87	\N	3	1	0	1	-1
4843	113	159	\N	3	1	0	1	-1
4844	113	234	\N	3	1	0	1	-1
4845	113	348	\N	3	1	0	1	-1
4846	113	390	\N	3	1	0	1	-1
4847	113	410	\N	3	1	0	1	-1
4848	113	587	\N	3	1	0	1	-1
4849	113	633	\N	3	1	0	1	-1
4850	113	1112	\N	3	1	0	1	-1
4851	113	1197	\N	3	1	0	1	-1
4852	113	1343	\N	3	1	0	1	-1
4853	113	1375	\N	3	1	0	1	-1
4854	159	35	\N	3	1	0	1	-1
4855	159	87	\N	3	1	0	1	-1
4856	159	113	\N	3	1	0	1	-1
4857	159	234	\N	3	1	0	1	-1
4858	159	348	\N	3	1	0	1	-1
4859	159	390	\N	3	1	0	1	-1
4860	159	410	\N	3	1	0	1	-1
4861	159	587	\N	3	1	0	1	-1
4862	159	633	\N	3	1	0	1	-1
4863	159	1112	\N	3	1	0	1	-1
4864	159	1197	\N	3	1	0	1	-1
4865	159	1343	\N	3	1	0	1	-1
4866	159	1375	\N	3	1	0	1	-1
4867	234	35	\N	3	1	0	1	-1
4868	234	87	\N	3	1	0	1	-1
4869	234	113	\N	3	1	0	1	-1
4870	234	159	\N	3	1	0	1	-1
4871	234	348	\N	3	1	0	1	-1
4872	234	390	\N	3	1	0	1	-1
4873	234	410	\N	3	1	0	1	-1
4874	234	587	\N	3	1	0	1	-1
4875	234	633	\N	3	1	0	1	-1
4876	234	1112	\N	3	1	0	1	-1
4877	234	1197	\N	3	1	0	1	-1
4878	234	1343	\N	3	1	0	1	-1
4879	234	1375	\N	3	1	0	1	-1
4880	348	35	\N	3	1	0	1	-1
4881	348	87	\N	3	1	0	1	-1
4882	348	113	\N	3	1	0	1	-1
4883	348	159	\N	3	1	0	1	-1
4884	348	234	\N	3	1	0	1	-1
4885	348	390	\N	3	1	0	1	-1
4886	348	410	\N	3	1	0	1	-1
4887	348	587	\N	3	1	0	1	-1
4888	348	633	\N	3	1	0	1	-1
4889	348	1112	\N	3	1	0	1	-1
4890	348	1197	\N	3	1	0	1	-1
4891	348	1343	\N	3	1	0	1	-1
4892	348	1375	\N	3	1	0	1	-1
4893	390	35	\N	3	1	0	1	-1
4894	390	87	\N	3	1	0	1	-1
4895	390	113	\N	3	1	0	1	-1
4896	390	159	\N	3	1	0	1	-1
4897	390	234	\N	3	1	0	1	-1
4898	390	348	\N	3	1	0	1	-1
4899	390	410	\N	3	1	0	1	-1
4900	390	587	\N	3	1	0	1	-1
4901	390	633	\N	3	1	0	1	-1
4902	390	1112	\N	3	1	0	1	-1
4903	390	1197	\N	3	1	0	1	-1
4904	390	1343	\N	3	1	0	1	-1
4905	390	1375	\N	3	1	0	1	-1
4906	410	35	\N	3	1	0	1	-1
4907	410	87	\N	3	1	0	1	-1
4908	410	113	\N	3	1	0	1	-1
4909	410	159	\N	3	1	0	1	-1
4910	410	234	\N	3	1	0	1	-1
4911	410	348	\N	3	1	0	1	-1
4912	410	390	\N	3	1	0	1	-1
4913	410	587	\N	3	1	0	1	-1
4914	410	633	\N	3	1	0	1	-1
4915	410	1112	\N	3	1	0	1	-1
4916	410	1197	\N	3	1	0	1	-1
4917	410	1343	\N	3	1	0	1	-1
4918	410	1375	\N	3	1	0	1	-1
4919	587	35	\N	3	1	0	1	-1
4920	587	87	\N	3	1	0	1	-1
4921	587	113	\N	3	1	0	1	-1
4922	587	159	\N	3	1	0	1	-1
4923	587	234	\N	3	1	0	1	-1
4924	587	348	\N	3	1	0	1	-1
4925	587	390	\N	3	1	0	1	-1
4926	587	410	\N	3	1	0	1	-1
4927	587	633	\N	3	1	0	1	-1
4928	587	1112	\N	3	1	0	1	-1
4929	587	1197	\N	3	1	0	1	-1
4930	587	1343	\N	3	1	0	1	-1
4931	587	1375	\N	3	1	0	1	-1
4932	633	35	\N	3	1	0	1	-1
4933	633	87	\N	3	1	0	1	-1
4934	633	113	\N	3	1	0	1	-1
4935	633	159	\N	3	1	0	1	-1
4936	633	234	\N	3	1	0	1	-1
4937	633	348	\N	3	1	0	1	-1
4938	633	390	\N	3	1	0	1	-1
4939	633	410	\N	3	1	0	1	-1
4940	633	587	\N	3	1	0	1	-1
4941	633	1112	\N	3	1	0	1	-1
4942	633	1197	\N	3	1	0	1	-1
4943	633	1343	\N	3	1	0	1	-1
4944	633	1375	\N	3	1	0	1	-1
4945	1112	35	\N	3	1	0	1	-1
4946	1112	87	\N	3	1	0	1	-1
4947	1112	113	\N	3	1	0	1	-1
4948	1112	159	\N	3	1	0	1	-1
4949	1112	234	\N	3	1	0	1	-1
4950	1112	348	\N	3	1	0	1	-1
4951	1112	390	\N	3	1	0	1	-1
4952	1112	410	\N	3	1	0	1	-1
4953	1112	587	\N	3	1	0	1	-1
4954	1112	633	\N	3	1	0	1	-1
4955	1112	1197	\N	3	1	0	1	-1
4956	1112	1343	\N	3	1	0	1	-1
4957	1112	1375	\N	3	1	0	1	-1
4958	1197	35	\N	3	1	0	1	-1
4959	1197	87	\N	3	1	0	1	-1
4960	1197	113	\N	3	1	0	1	-1
4961	1197	159	\N	3	1	0	1	-1
4962	1197	234	\N	3	1	0	1	-1
4963	1197	348	\N	3	1	0	1	-1
4964	1197	390	\N	3	1	0	1	-1
4965	1197	410	\N	3	1	0	1	-1
4966	1197	587	\N	3	1	0	1	-1
4967	1197	633	\N	3	1	0	1	-1
4968	1197	1112	\N	3	1	0	1	-1
4969	1197	1343	\N	3	1	0	1	-1
4970	1197	1375	\N	3	1	0	1	-1
4971	1343	35	\N	3	1	0	1	-1
4972	1343	87	\N	3	1	0	1	-1
4973	1343	113	\N	3	1	0	1	-1
4974	1343	159	\N	3	1	0	1	-1
4975	1343	234	\N	3	1	0	1	-1
4976	1343	348	\N	3	1	0	1	-1
4977	1343	390	\N	3	1	0	1	-1
4978	1343	410	\N	3	1	0	1	-1
4979	1343	587	\N	3	1	0	1	-1
4980	1343	633	\N	3	1	0	1	-1
4981	1343	1112	\N	3	1	0	1	-1
4982	1343	1197	\N	3	1	0	1	-1
4983	1343	1375	\N	3	1	0	1	-1
4984	1375	35	\N	3	1	0	1	-1
4985	1375	87	\N	3	1	0	1	-1
4986	1375	113	\N	3	1	0	1	-1
4987	1375	159	\N	3	1	0	1	-1
4988	1375	234	\N	3	1	0	1	-1
4989	1375	348	\N	3	1	0	1	-1
4990	1375	390	\N	3	1	0	1	-1
4991	1375	410	\N	3	1	0	1	-1
4992	1375	587	\N	3	1	0	1	-1
4993	1375	633	\N	3	1	0	1	-1
4994	1375	1112	\N	3	1	0	1	-1
4995	1375	1197	\N	3	1	0	1	-1
4996	1375	1343	\N	3	1	0	1	-1
4997	58	77	\N	3	1	0	1	-1
4998	58	278	\N	3	1	0	1	-1
4999	58	297	\N	3	1	0	1	-1
5000	77	58	\N	3	1	0	1	-1
5001	77	278	\N	3	1	0	1	-1
5002	77	297	\N	3	1	0	1	-1
5003	278	58	\N	3	1	0	1	-1
5004	278	77	\N	3	1	0	1	-1
5005	278	297	\N	3	1	0	1	-1
5006	297	58	\N	3	1	0	1	-1
5007	297	77	\N	3	1	0	1	-1
5008	297	278	\N	3	1	0	1	-1
5009	59	76	\N	3	1	0	1	-1
5010	59	279	\N	3	1	0	1	-1
5011	59	296	\N	3	1	0	1	-1
5012	76	59	\N	3	1	0	1	-1
5013	76	279	\N	3	1	0	1	-1
5014	76	296	\N	3	1	0	1	-1
5015	279	59	\N	3	1	0	1	-1
5016	279	76	\N	3	1	0	1	-1
5017	279	296	\N	3	1	0	1	-1
5018	296	59	\N	3	1	0	1	-1
5019	296	76	\N	3	1	0	1	-1
5020	296	279	\N	3	1	0	1	-1
5021	60	75	\N	3	1	0	1	-1
5022	60	280	\N	3	1	0	1	-1
5023	60	295	\N	3	1	0	1	-1
5024	75	60	\N	3	1	0	1	-1
5025	75	280	\N	3	1	0	1	-1
5026	75	295	\N	3	1	0	1	-1
5027	280	60	\N	3	1	0	1	-1
5028	280	75	\N	3	1	0	1	-1
5029	280	295	\N	3	1	0	1	-1
5030	295	60	\N	3	1	0	1	-1
5031	295	75	\N	3	1	0	1	-1
5032	295	280	\N	3	1	0	1	-1
5033	61	74	\N	3	1	0	1	-1
5034	61	281	\N	3	1	0	1	-1
5035	61	294	\N	3	1	0	1	-1
5036	74	61	\N	3	1	0	1	-1
5037	74	281	\N	3	1	0	1	-1
5038	74	294	\N	3	1	0	1	-1
5039	281	61	\N	3	1	0	1	-1
5040	281	74	\N	3	1	0	1	-1
5041	281	294	\N	3	1	0	1	-1
5042	294	61	\N	3	1	0	1	-1
5043	294	74	\N	3	1	0	1	-1
5044	294	281	\N	3	1	0	1	-1
5045	62	73	\N	3	1	0	1	-1
5046	62	282	\N	3	1	0	1	-1
5047	62	293	\N	3	1	0	1	-1
5048	73	62	\N	3	1	0	1	-1
5049	73	282	\N	3	1	0	1	-1
5050	73	293	\N	3	1	0	1	-1
5051	282	62	\N	3	1	0	1	-1
5052	282	73	\N	3	1	0	1	-1
5053	282	293	\N	3	1	0	1	-1
5054	293	62	\N	3	1	0	1	-1
5055	293	73	\N	3	1	0	1	-1
5056	293	282	\N	3	1	0	1	-1
5057	63	72	\N	3	1	0	1	-1
5058	63	283	\N	3	1	0	1	-1
5059	63	292	\N	3	1	0	1	-1
5060	72	63	\N	3	1	0	1	-1
5061	72	283	\N	3	1	0	1	-1
5062	72	292	\N	3	1	0	1	-1
5063	283	63	\N	3	1	0	1	-1
5064	283	72	\N	3	1	0	1	-1
5065	283	292	\N	3	1	0	1	-1
5066	292	63	\N	3	1	0	1	-1
5067	292	72	\N	3	1	0	1	-1
5068	292	283	\N	3	1	0	1	-1
5069	64	71	\N	3	1	0	1	-1
5070	64	284	\N	3	1	0	1	-1
5071	64	291	\N	3	1	0	1	-1
5072	71	64	\N	3	1	0	1	-1
5073	71	284	\N	3	1	0	1	-1
5074	71	291	\N	3	1	0	1	-1
5075	284	64	\N	3	1	0	1	-1
5076	284	71	\N	3	1	0	1	-1
5077	284	291	\N	3	1	0	1	-1
5078	291	64	\N	3	1	0	1	-1
5079	291	71	\N	3	1	0	1	-1
5080	291	284	\N	3	1	0	1	-1
5081	65	70	\N	3	1	0	1	-1
5082	65	285	\N	3	1	0	1	-1
5083	65	290	\N	3	1	0	1	-1
5084	70	65	\N	3	1	0	1	-1
5085	70	285	\N	3	1	0	1	-1
5086	70	290	\N	3	1	0	1	-1
5087	285	65	\N	3	1	0	1	-1
5088	285	70	\N	3	1	0	1	-1
5089	285	290	\N	3	1	0	1	-1
5090	290	65	\N	3	1	0	1	-1
5091	290	70	\N	3	1	0	1	-1
5092	290	285	\N	3	1	0	1	-1
5093	66	69	\N	3	1	0	1	-1
5094	66	286	\N	3	1	0	1	-1
5095	66	289	\N	3	1	0	1	-1
5096	69	66	\N	3	1	0	1	-1
5097	69	286	\N	3	1	0	1	-1
5098	69	289	\N	3	1	0	1	-1
5099	286	66	\N	3	1	0	1	-1
5100	286	69	\N	3	1	0	1	-1
5101	286	289	\N	3	1	0	1	-1
5102	289	66	\N	3	1	0	1	-1
5103	289	69	\N	3	1	0	1	-1
5104	289	286	\N	3	1	0	1	-1
5105	67	68	\N	3	1	0	1	-1
5106	67	287	\N	3	1	0	1	-1
5107	67	288	\N	3	1	0	1	-1
5108	68	67	\N	3	1	0	1	-1
5109	68	287	\N	3	1	0	1	-1
5110	68	288	\N	3	1	0	1	-1
5111	287	67	\N	3	1	0	1	-1
5112	287	68	\N	3	1	0	1	-1
5113	287	288	\N	3	1	0	1	-1
5114	288	67	\N	3	1	0	1	-1
5115	288	68	\N	3	1	0	1	-1
5116	288	287	\N	3	1	0	1	-1
5117	95	127	\N	3	1	0	1	-1
5118	127	95	\N	3	1	0	1	-1
5119	96	126	\N	3	1	0	1	-1
5120	126	96	\N	3	1	0	1	-1
5121	97	125	\N	3	1	0	1	-1
5122	125	97	\N	3	1	0	1	-1
5123	98	124	\N	3	1	0	1	-1
5124	124	98	\N	3	1	0	1	-1
5125	99	123	\N	3	1	0	1	-1
5126	123	99	\N	3	1	0	1	-1
5127	100	122	\N	3	1	0	1	-1
5128	122	100	\N	3	1	0	1	-1
5129	101	121	\N	3	1	0	1	-1
5130	101	147	\N	3	1	0	1	-1
5131	101	167	\N	3	1	0	1	-1
5132	101	336	\N	3	1	0	1	-1
5133	101	356	\N	3	1	0	1	-1
5134	121	101	\N	3	1	0	1	-1
5135	121	147	\N	3	1	0	1	-1
5136	121	167	\N	3	1	0	1	-1
5137	121	336	\N	3	1	0	1	-1
5138	121	356	\N	3	1	0	1	-1
5139	147	101	\N	3	1	0	1	-1
5140	147	121	\N	3	1	0	1	-1
5141	147	167	\N	3	1	0	1	-1
5142	147	336	\N	3	1	0	1	-1
5143	147	356	\N	3	1	0	1	-1
5144	167	101	\N	3	1	0	1	-1
5145	167	121	\N	3	1	0	1	-1
5146	167	147	\N	3	1	0	1	-1
5147	167	336	\N	3	1	0	1	-1
5148	167	356	\N	3	1	0	1	-1
5149	336	101	\N	3	1	0	1	-1
5150	336	121	\N	3	1	0	1	-1
5151	336	147	\N	3	1	0	1	-1
5152	336	167	\N	3	1	0	1	-1
5153	336	356	\N	3	1	0	1	-1
5154	356	101	\N	3	1	0	1	-1
5155	356	121	\N	3	1	0	1	-1
5156	356	147	\N	3	1	0	1	-1
5157	356	167	\N	3	1	0	1	-1
5158	356	336	\N	3	1	0	1	-1
5159	128	187	\N	3	1	0	1	-1
5160	187	128	\N	3	1	0	1	-1
5161	129	186	\N	3	1	0	1	-1
5162	186	129	\N	3	1	0	1	-1
5163	130	185	\N	3	1	0	1	-1
5164	185	130	\N	3	1	0	1	-1
5165	131	184	\N	3	1	0	1	-1
5166	184	131	\N	3	1	0	1	-1
5167	132	183	\N	3	1	0	1	-1
5168	183	132	\N	3	1	0	1	-1
5169	133	182	\N	3	1	0	1	-1
5170	182	133	\N	3	1	0	1	-1
5171	134	181	\N	3	1	0	1	-1
5172	181	134	\N	3	1	0	1	-1
5173	135	180	\N	3	1	0	1	-1
5174	180	135	\N	3	1	0	1	-1
5175	136	179	\N	3	1	0	1	-1
5176	179	136	\N	3	1	0	1	-1
5177	137	178	\N	3	1	0	1	-1
5178	137	705	\N	3	1	0	1	-1
5179	137	712	\N	3	1	0	1	-1
5180	137	1158	\N	3	1	0	1	-1
5181	137	1173	\N	3	1	0	1	-1
5182	178	137	\N	3	1	0	1	-1
5183	178	705	\N	3	1	0	1	-1
5184	178	712	\N	3	1	0	1	-1
5185	178	1158	\N	3	1	0	1	-1
5186	178	1173	\N	3	1	0	1	-1
5187	705	137	\N	3	1	0	1	-1
5188	705	178	\N	3	1	0	1	-1
5189	705	712	\N	3	1	0	1	-1
5190	705	1158	\N	3	1	0	1	-1
5191	705	1173	\N	3	1	0	1	-1
5192	712	137	\N	3	1	0	1	-1
5193	712	178	\N	3	1	0	1	-1
5194	712	705	\N	3	1	0	1	-1
5195	712	1158	\N	3	1	0	1	-1
5196	712	1173	\N	3	1	0	1	-1
5197	1158	137	\N	3	1	0	1	-1
5198	1158	178	\N	3	1	0	1	-1
5199	1158	705	\N	3	1	0	1	-1
5200	1158	712	\N	3	1	0	1	-1
5201	1158	1173	\N	3	1	0	1	-1
5202	1173	137	\N	3	1	0	1	-1
5203	1173	178	\N	3	1	0	1	-1
5204	1173	705	\N	3	1	0	1	-1
5205	1173	712	\N	3	1	0	1	-1
5206	1173	1158	\N	3	1	0	1	-1
5207	138	177	\N	3	1	0	1	-1
5208	138	704	\N	3	1	0	1	-1
5209	138	713	\N	3	1	0	1	-1
5210	138	1157	\N	3	1	0	1	-1
5211	138	1174	\N	3	1	0	1	-1
5212	177	138	\N	3	1	0	1	-1
5213	177	704	\N	3	1	0	1	-1
5214	177	713	\N	3	1	0	1	-1
5215	177	1157	\N	3	1	0	1	-1
5216	177	1174	\N	3	1	0	1	-1
5217	704	138	\N	3	1	0	1	-1
5218	704	177	\N	3	1	0	1	-1
5219	704	713	\N	3	1	0	1	-1
5220	704	1157	\N	3	1	0	1	-1
5221	704	1174	\N	3	1	0	1	-1
5222	713	138	\N	3	1	0	1	-1
5223	713	177	\N	3	1	0	1	-1
5224	713	704	\N	3	1	0	1	-1
5225	713	1157	\N	3	1	0	1	-1
5226	713	1174	\N	3	1	0	1	-1
5227	1157	138	\N	3	1	0	1	-1
5228	1157	177	\N	3	1	0	1	-1
5229	1157	704	\N	3	1	0	1	-1
5230	1157	713	\N	3	1	0	1	-1
5231	1157	1174	\N	3	1	0	1	-1
5232	1174	138	\N	3	1	0	1	-1
5233	1174	177	\N	3	1	0	1	-1
5234	1174	704	\N	3	1	0	1	-1
5235	1174	713	\N	3	1	0	1	-1
5236	1174	1157	\N	3	1	0	1	-1
5237	139	176	\N	3	1	0	1	-1
5238	139	703	\N	3	1	0	1	-1
5239	139	714	\N	3	1	0	1	-1
5240	139	1156	\N	3	1	0	1	-1
5241	139	1175	\N	3	1	0	1	-1
5242	176	139	\N	3	1	0	1	-1
5243	176	703	\N	3	1	0	1	-1
5244	176	714	\N	3	1	0	1	-1
5245	176	1156	\N	3	1	0	1	-1
5246	176	1175	\N	3	1	0	1	-1
5247	703	139	\N	3	1	0	1	-1
5248	703	176	\N	3	1	0	1	-1
5249	703	714	\N	3	1	0	1	-1
5250	703	1156	\N	3	1	0	1	-1
5251	703	1175	\N	3	1	0	1	-1
5252	714	139	\N	3	1	0	1	-1
5253	714	176	\N	3	1	0	1	-1
5254	714	703	\N	3	1	0	1	-1
5255	714	1156	\N	3	1	0	1	-1
5256	714	1175	\N	3	1	0	1	-1
5257	1156	139	\N	3	1	0	1	-1
5258	1156	176	\N	3	1	0	1	-1
5259	1156	703	\N	3	1	0	1	-1
5260	1156	714	\N	3	1	0	1	-1
5261	1156	1175	\N	3	1	0	1	-1
5262	1175	139	\N	3	1	0	1	-1
5263	1175	176	\N	3	1	0	1	-1
5264	1175	703	\N	3	1	0	1	-1
5265	1175	714	\N	3	1	0	1	-1
5266	1175	1156	\N	3	1	0	1	-1
5267	140	175	\N	3	1	0	1	-1
5268	140	702	\N	3	1	0	1	-1
5269	140	715	\N	3	1	0	1	-1
5270	140	1155	\N	3	1	0	1	-1
5271	140	1176	\N	3	1	0	1	-1
5272	175	140	\N	3	1	0	1	-1
5273	175	702	\N	3	1	0	1	-1
5274	175	715	\N	3	1	0	1	-1
5275	175	1155	\N	3	1	0	1	-1
5276	175	1176	\N	3	1	0	1	-1
5277	702	140	\N	3	1	0	1	-1
5278	702	175	\N	3	1	0	1	-1
5279	702	715	\N	3	1	0	1	-1
5280	702	1155	\N	3	1	0	1	-1
5281	702	1176	\N	3	1	0	1	-1
5282	715	140	\N	3	1	0	1	-1
5283	715	175	\N	3	1	0	1	-1
5284	715	702	\N	3	1	0	1	-1
5285	715	1155	\N	3	1	0	1	-1
5286	715	1176	\N	3	1	0	1	-1
5287	1155	140	\N	3	1	0	1	-1
5288	1155	175	\N	3	1	0	1	-1
5289	1155	702	\N	3	1	0	1	-1
5290	1155	715	\N	3	1	0	1	-1
5291	1155	1176	\N	3	1	0	1	-1
5292	1176	140	\N	3	1	0	1	-1
5293	1176	175	\N	3	1	0	1	-1
5294	1176	702	\N	3	1	0	1	-1
5295	1176	715	\N	3	1	0	1	-1
5296	1176	1155	\N	3	1	0	1	-1
5297	141	174	\N	3	1	0	1	-1
5298	141	701	\N	3	1	0	1	-1
5299	141	716	\N	3	1	0	1	-1
5300	141	1154	\N	3	1	0	1	-1
5301	141	1177	\N	3	1	0	1	-1
5302	141	1412	\N	3	1	0	1	-1
5303	141	1425	\N	3	1	0	1	-1
5304	174	141	\N	3	1	0	1	-1
5305	174	701	\N	3	1	0	1	-1
5306	174	716	\N	3	1	0	1	-1
5307	174	1154	\N	3	1	0	1	-1
5308	174	1177	\N	3	1	0	1	-1
5309	174	1412	\N	3	1	0	1	-1
5310	174	1425	\N	3	1	0	1	-1
5311	701	141	\N	3	1	0	1	-1
5312	701	174	\N	3	1	0	1	-1
5313	701	716	\N	3	1	0	1	-1
5314	701	1154	\N	3	1	0	1	-1
5315	701	1177	\N	3	1	0	1	-1
5316	701	1412	\N	3	1	0	1	-1
5317	701	1425	\N	3	1	0	1	-1
5318	716	141	\N	3	1	0	1	-1
5319	716	174	\N	3	1	0	1	-1
5320	716	701	\N	3	1	0	1	-1
5321	716	1154	\N	3	1	0	1	-1
5322	716	1177	\N	3	1	0	1	-1
5323	716	1412	\N	3	1	0	1	-1
5324	716	1425	\N	3	1	0	1	-1
5325	1154	141	\N	3	1	0	1	-1
5326	1154	174	\N	3	1	0	1	-1
5327	1154	701	\N	3	1	0	1	-1
5328	1154	716	\N	3	1	0	1	-1
5329	1154	1177	\N	3	1	0	1	-1
5330	1154	1412	\N	3	1	0	1	-1
5331	1154	1425	\N	3	1	0	1	-1
5332	1177	141	\N	3	1	0	1	-1
5333	1177	174	\N	3	1	0	1	-1
5334	1177	701	\N	3	1	0	1	-1
5335	1177	716	\N	3	1	0	1	-1
5336	1177	1154	\N	3	1	0	1	-1
5337	1177	1412	\N	3	1	0	1	-1
5338	1177	1425	\N	3	1	0	1	-1
5339	1412	141	\N	3	1	0	1	-1
5340	1412	174	\N	3	1	0	1	-1
5341	1412	701	\N	3	1	0	1	-1
5342	1412	716	\N	3	1	0	1	-1
5343	1412	1154	\N	3	1	0	1	-1
5344	1412	1177	\N	3	1	0	1	-1
5345	1412	1425	\N	3	1	0	1	-1
5346	1425	141	\N	3	1	0	1	-1
5347	1425	174	\N	3	1	0	1	-1
5348	1425	701	\N	3	1	0	1	-1
5349	1425	716	\N	3	1	0	1	-1
5350	1425	1154	\N	3	1	0	1	-1
5351	1425	1177	\N	3	1	0	1	-1
5352	1425	1412	\N	3	1	0	1	-1
5353	142	173	\N	3	1	0	1	-1
5354	142	700	\N	3	1	0	1	-1
5355	142	717	\N	3	1	0	1	-1
5356	142	1153	\N	3	1	0	1	-1
5357	142	1178	\N	3	1	0	1	-1
5358	142	1411	\N	3	1	0	1	-1
5359	142	1426	\N	3	1	0	1	-1
5360	173	142	\N	3	1	0	1	-1
5361	173	700	\N	3	1	0	1	-1
5362	173	717	\N	3	1	0	1	-1
5363	173	1153	\N	3	1	0	1	-1
5364	173	1178	\N	3	1	0	1	-1
5365	173	1411	\N	3	1	0	1	-1
5366	173	1426	\N	3	1	0	1	-1
5367	700	142	\N	3	1	0	1	-1
5368	700	173	\N	3	1	0	1	-1
5369	700	717	\N	3	1	0	1	-1
5370	700	1153	\N	3	1	0	1	-1
5371	700	1178	\N	3	1	0	1	-1
5372	700	1411	\N	3	1	0	1	-1
5373	700	1426	\N	3	1	0	1	-1
5374	717	142	\N	3	1	0	1	-1
5375	717	173	\N	3	1	0	1	-1
5376	717	700	\N	3	1	0	1	-1
5377	717	1153	\N	3	1	0	1	-1
5378	717	1178	\N	3	1	0	1	-1
5379	717	1411	\N	3	1	0	1	-1
5380	717	1426	\N	3	1	0	1	-1
5381	1153	142	\N	3	1	0	1	-1
5382	1153	173	\N	3	1	0	1	-1
5383	1153	700	\N	3	1	0	1	-1
5384	1153	717	\N	3	1	0	1	-1
5385	1153	1178	\N	3	1	0	1	-1
5386	1153	1411	\N	3	1	0	1	-1
5387	1153	1426	\N	3	1	0	1	-1
5388	1178	142	\N	3	1	0	1	-1
5389	1178	173	\N	3	1	0	1	-1
5390	1178	700	\N	3	1	0	1	-1
5391	1178	717	\N	3	1	0	1	-1
5392	1178	1153	\N	3	1	0	1	-1
5393	1178	1411	\N	3	1	0	1	-1
5394	1178	1426	\N	3	1	0	1	-1
5395	1411	142	\N	3	1	0	1	-1
5396	1411	173	\N	3	1	0	1	-1
5397	1411	700	\N	3	1	0	1	-1
5398	1411	717	\N	3	1	0	1	-1
5399	1411	1153	\N	3	1	0	1	-1
5400	1411	1178	\N	3	1	0	1	-1
5401	1411	1426	\N	3	1	0	1	-1
5402	1426	142	\N	3	1	0	1	-1
5403	1426	173	\N	3	1	0	1	-1
5404	1426	700	\N	3	1	0	1	-1
5405	1426	717	\N	3	1	0	1	-1
5406	1426	1153	\N	3	1	0	1	-1
5407	1426	1178	\N	3	1	0	1	-1
5408	1426	1411	\N	3	1	0	1	-1
5409	143	172	\N	3	1	0	1	-1
5410	143	699	\N	3	1	0	1	-1
5411	143	718	\N	3	1	0	1	-1
5412	143	1152	\N	3	1	0	1	-1
5413	143	1179	\N	3	1	0	1	-1
5414	143	1410	\N	3	1	0	1	-1
5415	143	1427	\N	3	1	0	1	-1
5416	172	143	\N	3	1	0	1	-1
5417	172	699	\N	3	1	0	1	-1
5418	172	718	\N	3	1	0	1	-1
5419	172	1152	\N	3	1	0	1	-1
5420	172	1179	\N	3	1	0	1	-1
5421	172	1410	\N	3	1	0	1	-1
5422	172	1427	\N	3	1	0	1	-1
5423	699	143	\N	3	1	0	1	-1
5424	699	172	\N	3	1	0	1	-1
5425	699	718	\N	3	1	0	1	-1
5426	699	1152	\N	3	1	0	1	-1
5427	699	1179	\N	3	1	0	1	-1
5428	699	1410	\N	3	1	0	1	-1
5429	699	1427	\N	3	1	0	1	-1
5430	718	143	\N	3	1	0	1	-1
5431	718	172	\N	3	1	0	1	-1
5432	718	699	\N	3	1	0	1	-1
5433	718	1152	\N	3	1	0	1	-1
5434	718	1179	\N	3	1	0	1	-1
5435	718	1410	\N	3	1	0	1	-1
5436	718	1427	\N	3	1	0	1	-1
5437	1152	143	\N	3	1	0	1	-1
5438	1152	172	\N	3	1	0	1	-1
5439	1152	699	\N	3	1	0	1	-1
5440	1152	718	\N	3	1	0	1	-1
5441	1152	1179	\N	3	1	0	1	-1
5442	1152	1410	\N	3	1	0	1	-1
5443	1152	1427	\N	3	1	0	1	-1
5444	1179	143	\N	3	1	0	1	-1
5445	1179	172	\N	3	1	0	1	-1
5446	1179	699	\N	3	1	0	1	-1
5447	1179	718	\N	3	1	0	1	-1
5448	1179	1152	\N	3	1	0	1	-1
5449	1179	1410	\N	3	1	0	1	-1
5450	1179	1427	\N	3	1	0	1	-1
5451	1410	143	\N	3	1	0	1	-1
5452	1410	172	\N	3	1	0	1	-1
5453	1410	699	\N	3	1	0	1	-1
5454	1410	718	\N	3	1	0	1	-1
5455	1410	1152	\N	3	1	0	1	-1
5456	1410	1179	\N	3	1	0	1	-1
5457	1410	1427	\N	3	1	0	1	-1
5458	1427	143	\N	3	1	0	1	-1
5459	1427	172	\N	3	1	0	1	-1
5460	1427	699	\N	3	1	0	1	-1
5461	1427	718	\N	3	1	0	1	-1
5462	1427	1152	\N	3	1	0	1	-1
5463	1427	1179	\N	3	1	0	1	-1
5464	1427	1410	\N	3	1	0	1	-1
5465	144	171	\N	3	1	0	1	-1
5466	144	698	\N	3	1	0	1	-1
5467	144	719	\N	3	1	0	1	-1
5468	144	1151	\N	3	1	0	1	-1
5469	144	1180	\N	3	1	0	1	-1
5470	144	1409	\N	3	1	0	1	-1
5471	144	1428	\N	3	1	0	1	-1
5472	171	144	\N	3	1	0	1	-1
5473	171	698	\N	3	1	0	1	-1
5474	171	719	\N	3	1	0	1	-1
5475	171	1151	\N	3	1	0	1	-1
5476	171	1180	\N	3	1	0	1	-1
5477	171	1409	\N	3	1	0	1	-1
5478	171	1428	\N	3	1	0	1	-1
5479	698	144	\N	3	1	0	1	-1
5480	698	171	\N	3	1	0	1	-1
5481	698	719	\N	3	1	0	1	-1
5482	698	1151	\N	3	1	0	1	-1
5483	698	1180	\N	3	1	0	1	-1
5484	698	1409	\N	3	1	0	1	-1
5485	698	1428	\N	3	1	0	1	-1
5486	719	144	\N	3	1	0	1	-1
5487	719	171	\N	3	1	0	1	-1
5488	719	698	\N	3	1	0	1	-1
5489	719	1151	\N	3	1	0	1	-1
5490	719	1180	\N	3	1	0	1	-1
5491	719	1409	\N	3	1	0	1	-1
5492	719	1428	\N	3	1	0	1	-1
5493	1151	144	\N	3	1	0	1	-1
5494	1151	171	\N	3	1	0	1	-1
5495	1151	698	\N	3	1	0	1	-1
5496	1151	719	\N	3	1	0	1	-1
5497	1151	1180	\N	3	1	0	1	-1
5498	1151	1409	\N	3	1	0	1	-1
5499	1151	1428	\N	3	1	0	1	-1
5500	1180	144	\N	3	1	0	1	-1
5501	1180	171	\N	3	1	0	1	-1
5502	1180	698	\N	3	1	0	1	-1
5503	1180	719	\N	3	1	0	1	-1
5504	1180	1151	\N	3	1	0	1	-1
5505	1180	1409	\N	3	1	0	1	-1
5506	1180	1428	\N	3	1	0	1	-1
5507	1409	144	\N	3	1	0	1	-1
5508	1409	171	\N	3	1	0	1	-1
5509	1409	698	\N	3	1	0	1	-1
5510	1409	719	\N	3	1	0	1	-1
5511	1409	1151	\N	3	1	0	1	-1
5512	1409	1180	\N	3	1	0	1	-1
5513	1409	1428	\N	3	1	0	1	-1
5514	1428	144	\N	3	1	0	1	-1
5515	1428	171	\N	3	1	0	1	-1
5516	1428	698	\N	3	1	0	1	-1
5517	1428	719	\N	3	1	0	1	-1
5518	1428	1151	\N	3	1	0	1	-1
5519	1428	1180	\N	3	1	0	1	-1
5520	1428	1409	\N	3	1	0	1	-1
5521	145	170	\N	3	1	0	1	-1
5522	145	539	\N	3	1	0	1	-1
5523	145	1045	\N	3	1	0	1	-1
5524	145	1251	\N	3	1	0	1	-1
5525	145	1299	\N	3	1	0	1	-1
5526	145	1526	\N	3	1	0	1	-1
5527	170	145	\N	3	1	0	1	-1
5528	170	539	\N	3	1	0	1	-1
5529	170	1045	\N	3	1	0	1	-1
5530	170	1251	\N	3	1	0	1	-1
5531	170	1299	\N	3	1	0	1	-1
5532	170	1526	\N	3	1	0	1	-1
5533	539	145	\N	3	1	0	1	-1
5534	539	170	\N	3	1	0	1	-1
5535	539	1045	\N	3	1	0	1	-1
5536	539	1251	\N	3	1	0	1	-1
5537	539	1299	\N	3	1	0	1	-1
5538	539	1526	\N	3	1	0	1	-1
5539	1045	145	\N	3	1	0	1	-1
5540	1045	170	\N	3	1	0	1	-1
5541	1045	539	\N	3	1	0	1	-1
5542	1045	1251	\N	3	1	0	1	-1
5543	1045	1299	\N	3	1	0	1	-1
5544	1045	1526	\N	3	1	0	1	-1
5545	1251	145	\N	3	1	0	1	-1
5546	1251	170	\N	3	1	0	1	-1
5547	1251	539	\N	3	1	0	1	-1
5548	1251	1045	\N	3	1	0	1	-1
5549	1251	1299	\N	3	1	0	1	-1
5550	1251	1526	\N	3	1	0	1	-1
5551	1299	145	\N	3	1	0	1	-1
5552	1299	170	\N	3	1	0	1	-1
5553	1299	539	\N	3	1	0	1	-1
5554	1299	1045	\N	3	1	0	1	-1
5555	1299	1251	\N	3	1	0	1	-1
5556	1299	1526	\N	3	1	0	1	-1
5557	1526	145	\N	3	1	0	1	-1
5558	1526	170	\N	3	1	0	1	-1
5559	1526	539	\N	3	1	0	1	-1
5560	1526	1045	\N	3	1	0	1	-1
5561	1526	1251	\N	3	1	0	1	-1
5562	1526	1299	\N	3	1	0	1	-1
5563	168	537	\N	3	1	0	1	-1
5564	168	1043	\N	3	1	0	1	-1
5565	168	1249	\N	3	1	0	1	-1
5566	168	1297	\N	3	1	0	1	-1
5567	168	1405	\N	3	1	0	1	-1
5568	168	1432	\N	3	1	0	1	-1
5569	168	1524	\N	3	1	0	1	-1
5570	537	168	\N	3	1	0	1	-1
5571	537	1043	\N	3	1	0	1	-1
5572	537	1249	\N	3	1	0	1	-1
5573	537	1297	\N	3	1	0	1	-1
5574	537	1405	\N	3	1	0	1	-1
5575	537	1432	\N	3	1	0	1	-1
5576	537	1524	\N	3	1	0	1	-1
5577	1043	168	\N	3	1	0	1	-1
5578	1043	537	\N	3	1	0	1	-1
5579	1043	1249	\N	3	1	0	1	-1
5580	1043	1297	\N	3	1	0	1	-1
5581	1043	1405	\N	3	1	0	1	-1
5582	1043	1432	\N	3	1	0	1	-1
5583	1043	1524	\N	3	1	0	1	-1
5584	1249	168	\N	3	1	0	1	-1
5585	1249	537	\N	3	1	0	1	-1
5586	1249	1043	\N	3	1	0	1	-1
5587	1249	1297	\N	3	1	0	1	-1
5588	1249	1405	\N	3	1	0	1	-1
5589	1249	1432	\N	3	1	0	1	-1
5590	1249	1524	\N	3	1	0	1	-1
5591	1297	168	\N	3	1	0	1	-1
5592	1297	537	\N	3	1	0	1	-1
5593	1297	1043	\N	3	1	0	1	-1
5594	1297	1249	\N	3	1	0	1	-1
5595	1297	1405	\N	3	1	0	1	-1
5596	1297	1432	\N	3	1	0	1	-1
5597	1297	1524	\N	3	1	0	1	-1
5598	1405	168	\N	3	1	0	1	-1
5599	1405	537	\N	3	1	0	1	-1
5600	1405	1043	\N	3	1	0	1	-1
5601	1405	1249	\N	3	1	0	1	-1
5602	1405	1297	\N	3	1	0	1	-1
5603	1405	1432	\N	3	1	0	1	-1
5604	1405	1524	\N	3	1	0	1	-1
5605	1432	168	\N	3	1	0	1	-1
5606	1432	537	\N	3	1	0	1	-1
5607	1432	1043	\N	3	1	0	1	-1
5608	1432	1249	\N	3	1	0	1	-1
5609	1432	1297	\N	3	1	0	1	-1
5610	1432	1405	\N	3	1	0	1	-1
5611	1432	1524	\N	3	1	0	1	-1
5612	1524	168	\N	3	1	0	1	-1
5613	1524	537	\N	3	1	0	1	-1
5614	1524	1043	\N	3	1	0	1	-1
5615	1524	1249	\N	3	1	0	1	-1
5616	1524	1297	\N	3	1	0	1	-1
5617	1524	1405	\N	3	1	0	1	-1
5618	1524	1432	\N	3	1	0	1	-1
5619	169	538	\N	3	1	0	1	-1
5620	169	1044	\N	3	1	0	1	-1
5621	169	1250	\N	3	1	0	1	-1
5622	169	1298	\N	3	1	0	1	-1
5623	169	1406	\N	3	1	0	1	-1
5624	169	1431	\N	3	1	0	1	-1
5625	169	1525	\N	3	1	0	1	-1
5626	538	169	\N	3	1	0	1	-1
5627	538	1044	\N	3	1	0	1	-1
5628	538	1250	\N	3	1	0	1	-1
5629	538	1298	\N	3	1	0	1	-1
5630	538	1406	\N	3	1	0	1	-1
5631	538	1431	\N	3	1	0	1	-1
5632	538	1525	\N	3	1	0	1	-1
5633	1044	169	\N	3	1	0	1	-1
5634	1044	538	\N	3	1	0	1	-1
5635	1044	1250	\N	3	1	0	1	-1
5636	1044	1298	\N	3	1	0	1	-1
5637	1044	1406	\N	3	1	0	1	-1
5638	1044	1431	\N	3	1	0	1	-1
5639	1044	1525	\N	3	1	0	1	-1
5640	1250	169	\N	3	1	0	1	-1
5641	1250	538	\N	3	1	0	1	-1
5642	1250	1044	\N	3	1	0	1	-1
5643	1250	1298	\N	3	1	0	1	-1
5644	1250	1406	\N	3	1	0	1	-1
5645	1250	1431	\N	3	1	0	1	-1
5646	1250	1525	\N	3	1	0	1	-1
5647	1298	169	\N	3	1	0	1	-1
5648	1298	538	\N	3	1	0	1	-1
5649	1298	1044	\N	3	1	0	1	-1
5650	1298	1250	\N	3	1	0	1	-1
5651	1298	1406	\N	3	1	0	1	-1
5652	1298	1431	\N	3	1	0	1	-1
5653	1298	1525	\N	3	1	0	1	-1
5654	1406	169	\N	3	1	0	1	-1
5655	1406	538	\N	3	1	0	1	-1
5656	1406	1044	\N	3	1	0	1	-1
5657	1406	1250	\N	3	1	0	1	-1
5658	1406	1298	\N	3	1	0	1	-1
5659	1406	1431	\N	3	1	0	1	-1
5660	1406	1525	\N	3	1	0	1	-1
5661	1431	169	\N	3	1	0	1	-1
5662	1431	538	\N	3	1	0	1	-1
5663	1431	1044	\N	3	1	0	1	-1
5664	1431	1250	\N	3	1	0	1	-1
5665	1431	1298	\N	3	1	0	1	-1
5666	1431	1406	\N	3	1	0	1	-1
5667	1431	1525	\N	3	1	0	1	-1
5668	1525	169	\N	3	1	0	1	-1
5669	1525	538	\N	3	1	0	1	-1
5670	1525	1044	\N	3	1	0	1	-1
5671	1525	1250	\N	3	1	0	1	-1
5672	1525	1298	\N	3	1	0	1	-1
5673	1525	1406	\N	3	1	0	1	-1
5674	1525	1431	\N	3	1	0	1	-1
5675	188	251	\N	3	1	0	1	-1
5676	188	253	\N	3	1	0	1	-1
5677	188	322	\N	3	1	0	1	-1
5678	188	1046	\N	3	1	0	1	-1
5679	188	1129	\N	3	1	0	1	-1
5680	251	188	\N	3	1	0	1	-1
5681	251	253	\N	3	1	0	1	-1
5682	251	322	\N	3	1	0	1	-1
5683	251	1046	\N	3	1	0	1	-1
5684	251	1129	\N	3	1	0	1	-1
5685	253	188	\N	3	1	0	1	-1
5686	253	251	\N	3	1	0	1	-1
5687	253	322	\N	3	1	0	1	-1
5688	253	1046	\N	3	1	0	1	-1
5689	253	1129	\N	3	1	0	1	-1
5690	322	188	\N	3	1	0	1	-1
5691	322	251	\N	3	1	0	1	-1
5692	322	253	\N	3	1	0	1	-1
5693	322	1046	\N	3	1	0	1	-1
5694	322	1129	\N	3	1	0	1	-1
5695	1046	188	\N	3	1	0	1	-1
5696	1046	251	\N	3	1	0	1	-1
5697	1046	253	\N	3	1	0	1	-1
5698	1046	322	\N	3	1	0	1	-1
5699	1046	1129	\N	3	1	0	1	-1
5700	1129	188	\N	3	1	0	1	-1
5701	1129	251	\N	3	1	0	1	-1
5702	1129	253	\N	3	1	0	1	-1
5703	1129	322	\N	3	1	0	1	-1
5704	1129	1046	\N	3	1	0	1	-1
5705	189	250	\N	3	1	0	1	-1
5706	189	254	\N	3	1	0	1	-1
5707	189	321	\N	3	1	0	1	-1
5708	189	1047	\N	3	1	0	1	-1
5709	189	1128	\N	3	1	0	1	-1
5710	250	189	\N	3	1	0	1	-1
5711	250	254	\N	3	1	0	1	-1
5712	250	321	\N	3	1	0	1	-1
5713	250	1047	\N	3	1	0	1	-1
5714	250	1128	\N	3	1	0	1	-1
5715	254	189	\N	3	1	0	1	-1
5716	254	250	\N	3	1	0	1	-1
5717	254	321	\N	3	1	0	1	-1
5718	254	1047	\N	3	1	0	1	-1
5719	254	1128	\N	3	1	0	1	-1
5720	321	189	\N	3	1	0	1	-1
5721	321	250	\N	3	1	0	1	-1
5722	321	254	\N	3	1	0	1	-1
5723	321	1047	\N	3	1	0	1	-1
5724	321	1128	\N	3	1	0	1	-1
5725	1047	189	\N	3	1	0	1	-1
5726	1047	250	\N	3	1	0	1	-1
5727	1047	254	\N	3	1	0	1	-1
5728	1047	321	\N	3	1	0	1	-1
5729	1047	1128	\N	3	1	0	1	-1
5730	1128	189	\N	3	1	0	1	-1
5731	1128	250	\N	3	1	0	1	-1
5732	1128	254	\N	3	1	0	1	-1
5733	1128	321	\N	3	1	0	1	-1
5734	1128	1047	\N	3	1	0	1	-1
5735	190	249	\N	3	1	0	1	-1
5736	190	255	\N	3	1	0	1	-1
5737	190	320	\N	3	1	0	1	-1
5738	190	1048	\N	3	1	0	1	-1
5739	190	1127	\N	3	1	0	1	-1
5740	249	190	\N	3	1	0	1	-1
5741	249	255	\N	3	1	0	1	-1
5742	249	320	\N	3	1	0	1	-1
5743	249	1048	\N	3	1	0	1	-1
5744	249	1127	\N	3	1	0	1	-1
5745	255	190	\N	3	1	0	1	-1
5746	255	249	\N	3	1	0	1	-1
5747	255	320	\N	3	1	0	1	-1
5748	255	1048	\N	3	1	0	1	-1
5749	255	1127	\N	3	1	0	1	-1
5750	320	190	\N	3	1	0	1	-1
5751	320	249	\N	3	1	0	1	-1
5752	320	255	\N	3	1	0	1	-1
5753	320	1048	\N	3	1	0	1	-1
5754	320	1127	\N	3	1	0	1	-1
5755	1048	190	\N	3	1	0	1	-1
5756	1048	249	\N	3	1	0	1	-1
5757	1048	255	\N	3	1	0	1	-1
5758	1048	320	\N	3	1	0	1	-1
5759	1048	1127	\N	3	1	0	1	-1
5760	1127	190	\N	3	1	0	1	-1
5761	1127	249	\N	3	1	0	1	-1
5762	1127	255	\N	3	1	0	1	-1
5763	1127	320	\N	3	1	0	1	-1
5764	1127	1048	\N	3	1	0	1	-1
5765	191	248	\N	3	1	0	1	-1
5766	191	256	\N	3	1	0	1	-1
5767	191	319	\N	3	1	0	1	-1
5768	191	1049	\N	3	1	0	1	-1
5769	191	1126	\N	3	1	0	1	-1
5770	248	191	\N	3	1	0	1	-1
5771	248	256	\N	3	1	0	1	-1
5772	248	319	\N	3	1	0	1	-1
5773	248	1049	\N	3	1	0	1	-1
5774	248	1126	\N	3	1	0	1	-1
5775	256	191	\N	3	1	0	1	-1
5776	256	248	\N	3	1	0	1	-1
5777	256	319	\N	3	1	0	1	-1
5778	256	1049	\N	3	1	0	1	-1
5779	256	1126	\N	3	1	0	1	-1
5780	319	191	\N	3	1	0	1	-1
5781	319	248	\N	3	1	0	1	-1
5782	319	256	\N	3	1	0	1	-1
5783	319	1049	\N	3	1	0	1	-1
5784	319	1126	\N	3	1	0	1	-1
5785	1049	191	\N	3	1	0	1	-1
5786	1049	248	\N	3	1	0	1	-1
5787	1049	256	\N	3	1	0	1	-1
5788	1049	319	\N	3	1	0	1	-1
5789	1049	1126	\N	3	1	0	1	-1
5790	1126	191	\N	3	1	0	1	-1
5791	1126	248	\N	3	1	0	1	-1
5792	1126	256	\N	3	1	0	1	-1
5793	1126	319	\N	3	1	0	1	-1
5794	1126	1049	\N	3	1	0	1	-1
5795	192	247	\N	3	1	0	1	-1
5796	192	257	\N	3	1	0	1	-1
5797	192	318	\N	3	1	0	1	-1
5798	192	1050	\N	3	1	0	1	-1
5799	192	1125	\N	3	1	0	1	-1
5800	247	192	\N	3	1	0	1	-1
5801	247	257	\N	3	1	0	1	-1
5802	247	318	\N	3	1	0	1	-1
5803	247	1050	\N	3	1	0	1	-1
5804	247	1125	\N	3	1	0	1	-1
5805	257	192	\N	3	1	0	1	-1
5806	257	247	\N	3	1	0	1	-1
5807	257	318	\N	3	1	0	1	-1
5808	257	1050	\N	3	1	0	1	-1
5809	257	1125	\N	3	1	0	1	-1
5810	318	192	\N	3	1	0	1	-1
5811	318	247	\N	3	1	0	1	-1
5812	318	257	\N	3	1	0	1	-1
5813	318	1050	\N	3	1	0	1	-1
5814	318	1125	\N	3	1	0	1	-1
5815	1050	192	\N	3	1	0	1	-1
5816	1050	247	\N	3	1	0	1	-1
5817	1050	257	\N	3	1	0	1	-1
5818	1050	318	\N	3	1	0	1	-1
5819	1050	1125	\N	3	1	0	1	-1
5820	1125	192	\N	3	1	0	1	-1
5821	1125	247	\N	3	1	0	1	-1
5822	1125	257	\N	3	1	0	1	-1
5823	1125	318	\N	3	1	0	1	-1
5824	1125	1050	\N	3	1	0	1	-1
5825	193	246	\N	3	1	0	1	-1
5826	193	258	\N	3	1	0	1	-1
5827	193	317	\N	3	1	0	1	-1
5828	193	1051	\N	3	1	0	1	-1
5829	193	1124	\N	3	1	0	1	-1
5830	246	193	\N	3	1	0	1	-1
5831	246	258	\N	3	1	0	1	-1
5832	246	317	\N	3	1	0	1	-1
5833	246	1051	\N	3	1	0	1	-1
5834	246	1124	\N	3	1	0	1	-1
5835	258	193	\N	3	1	0	1	-1
5836	258	246	\N	3	1	0	1	-1
5837	258	317	\N	3	1	0	1	-1
5838	258	1051	\N	3	1	0	1	-1
5839	258	1124	\N	3	1	0	1	-1
5840	317	193	\N	3	1	0	1	-1
5841	317	246	\N	3	1	0	1	-1
5842	317	258	\N	3	1	0	1	-1
5843	317	1051	\N	3	1	0	1	-1
5844	317	1124	\N	3	1	0	1	-1
5845	1051	193	\N	3	1	0	1	-1
5846	1051	246	\N	3	1	0	1	-1
5847	1051	258	\N	3	1	0	1	-1
5848	1051	317	\N	3	1	0	1	-1
5849	1051	1124	\N	3	1	0	1	-1
5850	1124	193	\N	3	1	0	1	-1
5851	1124	246	\N	3	1	0	1	-1
5852	1124	258	\N	3	1	0	1	-1
5853	1124	317	\N	3	1	0	1	-1
5854	1124	1051	\N	3	1	0	1	-1
5855	194	245	\N	3	1	0	1	-1
5856	194	259	\N	3	1	0	1	-1
5857	194	316	\N	3	1	0	1	-1
5858	194	1052	\N	3	1	0	1	-1
5859	194	1123	\N	3	1	0	1	-1
5860	245	194	\N	3	1	0	1	-1
5861	245	259	\N	3	1	0	1	-1
5862	245	316	\N	3	1	0	1	-1
5863	245	1052	\N	3	1	0	1	-1
5864	245	1123	\N	3	1	0	1	-1
5865	259	194	\N	3	1	0	1	-1
5866	259	245	\N	3	1	0	1	-1
5867	259	316	\N	3	1	0	1	-1
5868	259	1052	\N	3	1	0	1	-1
5869	259	1123	\N	3	1	0	1	-1
5870	316	194	\N	3	1	0	1	-1
5871	316	245	\N	3	1	0	1	-1
5872	316	259	\N	3	1	0	1	-1
5873	316	1052	\N	3	1	0	1	-1
5874	316	1123	\N	3	1	0	1	-1
5875	1052	194	\N	3	1	0	1	-1
5876	1052	245	\N	3	1	0	1	-1
5877	1052	259	\N	3	1	0	1	-1
5878	1052	316	\N	3	1	0	1	-1
5879	1052	1123	\N	3	1	0	1	-1
5880	1123	194	\N	3	1	0	1	-1
5881	1123	245	\N	3	1	0	1	-1
5882	1123	259	\N	3	1	0	1	-1
5883	1123	316	\N	3	1	0	1	-1
5884	1123	1052	\N	3	1	0	1	-1
5885	195	244	\N	3	1	0	1	-1
5886	195	260	\N	3	1	0	1	-1
5887	195	315	\N	3	1	0	1	-1
5888	195	1053	\N	3	1	0	1	-1
5889	195	1122	\N	3	1	0	1	-1
5890	244	195	\N	3	1	0	1	-1
5891	244	260	\N	3	1	0	1	-1
5892	244	315	\N	3	1	0	1	-1
5893	244	1053	\N	3	1	0	1	-1
5894	244	1122	\N	3	1	0	1	-1
5895	260	195	\N	3	1	0	1	-1
5896	260	244	\N	3	1	0	1	-1
5897	260	315	\N	3	1	0	1	-1
5898	260	1053	\N	3	1	0	1	-1
5899	260	1122	\N	3	1	0	1	-1
5900	315	195	\N	3	1	0	1	-1
5901	315	244	\N	3	1	0	1	-1
5902	315	260	\N	3	1	0	1	-1
5903	315	1053	\N	3	1	0	1	-1
5904	315	1122	\N	3	1	0	1	-1
5905	1053	195	\N	3	1	0	1	-1
5906	1053	244	\N	3	1	0	1	-1
5907	1053	260	\N	3	1	0	1	-1
5908	1053	315	\N	3	1	0	1	-1
5909	1053	1122	\N	3	1	0	1	-1
5910	1122	195	\N	3	1	0	1	-1
5911	1122	244	\N	3	1	0	1	-1
5912	1122	260	\N	3	1	0	1	-1
5913	1122	315	\N	3	1	0	1	-1
5914	1122	1053	\N	3	1	0	1	-1
5915	196	243	\N	3	1	0	1	-1
5916	196	261	\N	3	1	0	1	-1
5917	196	314	\N	3	1	0	1	-1
5918	196	1054	\N	3	1	0	1	-1
5919	196	1121	\N	3	1	0	1	-1
5920	243	196	\N	3	1	0	1	-1
5921	243	261	\N	3	1	0	1	-1
5922	243	314	\N	3	1	0	1	-1
5923	243	1054	\N	3	1	0	1	-1
5924	243	1121	\N	3	1	0	1	-1
5925	261	196	\N	3	1	0	1	-1
5926	261	243	\N	3	1	0	1	-1
5927	261	314	\N	3	1	0	1	-1
5928	261	1054	\N	3	1	0	1	-1
5929	261	1121	\N	3	1	0	1	-1
5930	314	196	\N	3	1	0	1	-1
5931	314	243	\N	3	1	0	1	-1
5932	314	261	\N	3	1	0	1	-1
5933	314	1054	\N	3	1	0	1	-1
5934	314	1121	\N	3	1	0	1	-1
5935	1054	196	\N	3	1	0	1	-1
5936	1054	243	\N	3	1	0	1	-1
5937	1054	261	\N	3	1	0	1	-1
5938	1054	314	\N	3	1	0	1	-1
5939	1054	1121	\N	3	1	0	1	-1
5940	1121	196	\N	3	1	0	1	-1
5941	1121	243	\N	3	1	0	1	-1
5942	1121	261	\N	3	1	0	1	-1
5943	1121	314	\N	3	1	0	1	-1
5944	1121	1054	\N	3	1	0	1	-1
5945	197	242	\N	3	1	0	1	-1
5946	197	262	\N	3	1	0	1	-1
5947	197	313	\N	3	1	0	1	-1
5948	197	1055	\N	3	1	0	1	-1
5949	197	1120	\N	3	1	0	1	-1
5950	242	197	\N	3	1	0	1	-1
5951	242	262	\N	3	1	0	1	-1
5952	242	313	\N	3	1	0	1	-1
5953	242	1055	\N	3	1	0	1	-1
5954	242	1120	\N	3	1	0	1	-1
5955	262	197	\N	3	1	0	1	-1
5956	262	242	\N	3	1	0	1	-1
5957	262	313	\N	3	1	0	1	-1
5958	262	1055	\N	3	1	0	1	-1
5959	262	1120	\N	3	1	0	1	-1
5960	313	197	\N	3	1	0	1	-1
5961	313	242	\N	3	1	0	1	-1
5962	313	262	\N	3	1	0	1	-1
5963	313	1055	\N	3	1	0	1	-1
5964	313	1120	\N	3	1	0	1	-1
5965	1055	197	\N	3	1	0	1	-1
5966	1055	242	\N	3	1	0	1	-1
5967	1055	262	\N	3	1	0	1	-1
5968	1055	313	\N	3	1	0	1	-1
5969	1055	1120	\N	3	1	0	1	-1
5970	1120	197	\N	3	1	0	1	-1
5971	1120	242	\N	3	1	0	1	-1
5972	1120	262	\N	3	1	0	1	-1
5973	1120	313	\N	3	1	0	1	-1
5974	1120	1055	\N	3	1	0	1	-1
5975	198	241	\N	3	1	0	1	-1
5976	198	1056	\N	3	1	0	1	-1
5977	198	1119	\N	3	1	0	1	-1
5978	241	198	\N	3	1	0	1	-1
5979	241	1056	\N	3	1	0	1	-1
5980	241	1119	\N	3	1	0	1	-1
5981	1056	198	\N	3	1	0	1	-1
5982	1056	241	\N	3	1	0	1	-1
5983	1056	1119	\N	3	1	0	1	-1
5984	1119	198	\N	3	1	0	1	-1
5985	1119	241	\N	3	1	0	1	-1
5986	1119	1056	\N	3	1	0	1	-1
5987	199	240	\N	3	1	0	1	-1
5988	199	1057	\N	3	1	0	1	-1
5989	199	1118	\N	3	1	0	1	-1
5990	240	199	\N	3	1	0	1	-1
5991	240	1057	\N	3	1	0	1	-1
5992	240	1118	\N	3	1	0	1	-1
5993	1057	199	\N	3	1	0	1	-1
5994	1057	240	\N	3	1	0	1	-1
5995	1057	1118	\N	3	1	0	1	-1
5996	1118	199	\N	3	1	0	1	-1
5997	1118	240	\N	3	1	0	1	-1
5998	1118	1057	\N	3	1	0	1	-1
5999	200	239	\N	3	1	0	1	-1
6000	200	1058	\N	3	1	0	1	-1
6001	200	1117	\N	3	1	0	1	-1
6002	239	200	\N	3	1	0	1	-1
6003	239	1058	\N	3	1	0	1	-1
6004	239	1117	\N	3	1	0	1	-1
6005	1058	200	\N	3	1	0	1	-1
6006	1058	239	\N	3	1	0	1	-1
6007	1058	1117	\N	3	1	0	1	-1
6008	1117	200	\N	3	1	0	1	-1
6009	1117	239	\N	3	1	0	1	-1
6010	1117	1058	\N	3	1	0	1	-1
6011	201	238	\N	3	1	0	1	-1
6012	201	1059	\N	3	1	0	1	-1
6013	201	1116	\N	3	1	0	1	-1
6014	238	201	\N	3	1	0	1	-1
6015	238	1059	\N	3	1	0	1	-1
6016	238	1116	\N	3	1	0	1	-1
6017	1059	201	\N	3	1	0	1	-1
6018	1059	238	\N	3	1	0	1	-1
6019	1059	1116	\N	3	1	0	1	-1
6020	1116	201	\N	3	1	0	1	-1
6021	1116	238	\N	3	1	0	1	-1
6022	1116	1059	\N	3	1	0	1	-1
6023	202	1060	\N	3	1	0	1	-1
6024	1060	202	\N	3	1	0	1	-1
6025	203	1061	\N	3	1	0	1	-1
6026	1061	203	\N	3	1	0	1	-1
6027	206	684	\N	3	1	0	1	-1
6028	206	1131	\N	3	1	0	1	-1
6029	206	1346	\N	3	1	0	1	-1
6030	206	1373	\N	3	1	0	1	-1
6031	684	206	\N	3	1	0	1	-1
6032	684	1131	\N	3	1	0	1	-1
6033	684	1346	\N	3	1	0	1	-1
6034	684	1373	\N	3	1	0	1	-1
6035	1131	206	\N	3	1	0	1	-1
6036	1131	684	\N	3	1	0	1	-1
6037	1131	1346	\N	3	1	0	1	-1
6038	1131	1373	\N	3	1	0	1	-1
6039	1346	206	\N	3	1	0	1	-1
6040	1346	684	\N	3	1	0	1	-1
6041	1346	1131	\N	3	1	0	1	-1
6042	1346	1373	\N	3	1	0	1	-1
6043	1373	206	\N	3	1	0	1	-1
6044	1373	684	\N	3	1	0	1	-1
6045	1373	1131	\N	3	1	0	1	-1
6046	1373	1346	\N	3	1	0	1	-1
6047	208	687	\N	3	1	0	1	-1
6048	208	810	\N	3	1	0	1	-1
6049	208	1133	\N	3	1	0	1	-1
6050	208	1348	\N	3	1	0	1	-1
6051	687	208	\N	3	1	0	1	-1
6052	687	810	\N	3	1	0	1	-1
6053	687	1133	\N	3	1	0	1	-1
6054	687	1348	\N	3	1	0	1	-1
6055	810	208	\N	3	1	0	1	-1
6056	810	687	\N	3	1	0	1	-1
6057	810	1133	\N	3	1	0	1	-1
6058	810	1348	\N	3	1	0	1	-1
6059	1133	208	\N	3	1	0	1	-1
6060	1133	687	\N	3	1	0	1	-1
6061	1133	810	\N	3	1	0	1	-1
6062	1133	1348	\N	3	1	0	1	-1
6063	1348	208	\N	3	1	0	1	-1
6064	1348	687	\N	3	1	0	1	-1
6065	1348	810	\N	3	1	0	1	-1
6066	1348	1133	\N	3	1	0	1	-1
6067	209	688	\N	3	1	0	1	-1
6068	209	809	\N	3	1	0	1	-1
6069	209	1134	\N	3	1	0	1	-1
6070	209	1349	\N	3	1	0	1	-1
6071	688	209	\N	3	1	0	1	-1
6072	688	809	\N	3	1	0	1	-1
6073	688	1134	\N	3	1	0	1	-1
6074	688	1349	\N	3	1	0	1	-1
6075	809	209	\N	3	1	0	1	-1
6076	809	688	\N	3	1	0	1	-1
6077	809	1134	\N	3	1	0	1	-1
6078	809	1349	\N	3	1	0	1	-1
6079	1134	209	\N	3	1	0	1	-1
6080	1134	688	\N	3	1	0	1	-1
6081	1134	809	\N	3	1	0	1	-1
6082	1134	1349	\N	3	1	0	1	-1
6083	1349	209	\N	3	1	0	1	-1
6084	1349	688	\N	3	1	0	1	-1
6085	1349	809	\N	3	1	0	1	-1
6086	1349	1134	\N	3	1	0	1	-1
6087	210	449	\N	3	1	0	1	-1
6088	210	518	\N	3	1	0	1	-1
6089	210	742	\N	3	1	0	1	-1
6090	210	819	\N	3	1	0	1	-1
6091	210	1064	\N	3	1	0	1	-1
6092	210	1135	\N	3	1	0	1	-1
6093	210	1350	\N	3	1	0	1	-1
6094	449	210	\N	3	1	0	1	-1
6095	449	518	\N	3	1	0	1	-1
6096	449	742	\N	3	1	0	1	-1
6097	449	819	\N	3	1	0	1	-1
6098	449	1064	\N	3	1	0	1	-1
6099	449	1135	\N	3	1	0	1	-1
6100	449	1350	\N	3	1	0	1	-1
6101	518	210	\N	3	1	0	1	-1
6102	518	449	\N	3	1	0	1	-1
6103	518	742	\N	3	1	0	1	-1
6104	518	819	\N	3	1	0	1	-1
6105	518	1064	\N	3	1	0	1	-1
6106	518	1135	\N	3	1	0	1	-1
6107	518	1350	\N	3	1	0	1	-1
6108	742	210	\N	3	1	0	1	-1
6109	742	449	\N	3	1	0	1	-1
6110	742	518	\N	3	1	0	1	-1
6111	742	819	\N	3	1	0	1	-1
6112	742	1064	\N	3	1	0	1	-1
6113	742	1135	\N	3	1	0	1	-1
6114	742	1350	\N	3	1	0	1	-1
6115	819	210	\N	3	1	0	1	-1
6116	819	449	\N	3	1	0	1	-1
6117	819	518	\N	3	1	0	1	-1
6118	819	742	\N	3	1	0	1	-1
6119	819	1064	\N	3	1	0	1	-1
6120	819	1135	\N	3	1	0	1	-1
6121	819	1350	\N	3	1	0	1	-1
6122	1064	210	\N	3	1	0	1	-1
6123	1064	449	\N	3	1	0	1	-1
6124	1064	518	\N	3	1	0	1	-1
6125	1064	742	\N	3	1	0	1	-1
6126	1064	819	\N	3	1	0	1	-1
6127	1064	1135	\N	3	1	0	1	-1
6128	1064	1350	\N	3	1	0	1	-1
6129	1135	210	\N	3	1	0	1	-1
6130	1135	449	\N	3	1	0	1	-1
6131	1135	518	\N	3	1	0	1	-1
6132	1135	742	\N	3	1	0	1	-1
6133	1135	819	\N	3	1	0	1	-1
6134	1135	1064	\N	3	1	0	1	-1
6135	1135	1350	\N	3	1	0	1	-1
6136	1350	210	\N	3	1	0	1	-1
6137	1350	449	\N	3	1	0	1	-1
6138	1350	518	\N	3	1	0	1	-1
6139	1350	742	\N	3	1	0	1	-1
6140	1350	819	\N	3	1	0	1	-1
6141	1350	1064	\N	3	1	0	1	-1
6142	1350	1135	\N	3	1	0	1	-1
6143	211	450	\N	3	1	0	1	-1
6144	211	519	\N	3	1	0	1	-1
6145	211	743	\N	3	1	0	1	-1
6146	211	820	\N	3	1	0	1	-1
6147	211	1065	\N	3	1	0	1	-1
6148	211	1136	\N	3	1	0	1	-1
6149	211	1351	\N	3	1	0	1	-1
6150	450	211	\N	3	1	0	1	-1
6151	450	519	\N	3	1	0	1	-1
6152	450	743	\N	3	1	0	1	-1
6153	450	820	\N	3	1	0	1	-1
6154	450	1065	\N	3	1	0	1	-1
6155	450	1136	\N	3	1	0	1	-1
6156	450	1351	\N	3	1	0	1	-1
6157	519	211	\N	3	1	0	1	-1
6158	519	450	\N	3	1	0	1	-1
6159	519	743	\N	3	1	0	1	-1
6160	519	820	\N	3	1	0	1	-1
6161	519	1065	\N	3	1	0	1	-1
6162	519	1136	\N	3	1	0	1	-1
6163	519	1351	\N	3	1	0	1	-1
6164	743	211	\N	3	1	0	1	-1
6165	743	450	\N	3	1	0	1	-1
6166	743	519	\N	3	1	0	1	-1
6167	743	820	\N	3	1	0	1	-1
6168	743	1065	\N	3	1	0	1	-1
6169	743	1136	\N	3	1	0	1	-1
6170	743	1351	\N	3	1	0	1	-1
6171	820	211	\N	3	1	0	1	-1
6172	820	450	\N	3	1	0	1	-1
6173	820	519	\N	3	1	0	1	-1
6174	820	743	\N	3	1	0	1	-1
6175	820	1065	\N	3	1	0	1	-1
6176	820	1136	\N	3	1	0	1	-1
6177	820	1351	\N	3	1	0	1	-1
6178	1065	211	\N	3	1	0	1	-1
6179	1065	450	\N	3	1	0	1	-1
6180	1065	519	\N	3	1	0	1	-1
6181	1065	743	\N	3	1	0	1	-1
6182	1065	820	\N	3	1	0	1	-1
6183	1065	1136	\N	3	1	0	1	-1
6184	1065	1351	\N	3	1	0	1	-1
6185	1136	211	\N	3	1	0	1	-1
6186	1136	450	\N	3	1	0	1	-1
6187	1136	519	\N	3	1	0	1	-1
6188	1136	743	\N	3	1	0	1	-1
6189	1136	820	\N	3	1	0	1	-1
6190	1136	1065	\N	3	1	0	1	-1
6191	1136	1351	\N	3	1	0	1	-1
6192	1351	211	\N	3	1	0	1	-1
6193	1351	450	\N	3	1	0	1	-1
6194	1351	519	\N	3	1	0	1	-1
6195	1351	743	\N	3	1	0	1	-1
6196	1351	820	\N	3	1	0	1	-1
6197	1351	1065	\N	3	1	0	1	-1
6198	1351	1136	\N	3	1	0	1	-1
6199	212	451	\N	3	1	0	1	-1
6200	212	520	\N	3	1	0	1	-1
6201	212	744	\N	3	1	0	1	-1
6202	212	821	\N	3	1	0	1	-1
6203	212	1066	\N	3	1	0	1	-1
6204	212	1137	\N	3	1	0	1	-1
6205	212	1352	\N	3	1	0	1	-1
6206	451	212	\N	3	1	0	1	-1
6207	451	520	\N	3	1	0	1	-1
6208	451	744	\N	3	1	0	1	-1
6209	451	821	\N	3	1	0	1	-1
6210	451	1066	\N	3	1	0	1	-1
6211	451	1137	\N	3	1	0	1	-1
6212	451	1352	\N	3	1	0	1	-1
6213	520	212	\N	3	1	0	1	-1
6214	520	451	\N	3	1	0	1	-1
6215	520	744	\N	3	1	0	1	-1
6216	520	821	\N	3	1	0	1	-1
6217	520	1066	\N	3	1	0	1	-1
6218	520	1137	\N	3	1	0	1	-1
6219	520	1352	\N	3	1	0	1	-1
6220	744	212	\N	3	1	0	1	-1
6221	744	451	\N	3	1	0	1	-1
6222	744	520	\N	3	1	0	1	-1
6223	744	821	\N	3	1	0	1	-1
6224	744	1066	\N	3	1	0	1	-1
6225	744	1137	\N	3	1	0	1	-1
6226	744	1352	\N	3	1	0	1	-1
6227	821	212	\N	3	1	0	1	-1
6228	821	451	\N	3	1	0	1	-1
6229	821	520	\N	3	1	0	1	-1
6230	821	744	\N	3	1	0	1	-1
6231	821	1066	\N	3	1	0	1	-1
6232	821	1137	\N	3	1	0	1	-1
6233	821	1352	\N	3	1	0	1	-1
6234	1066	212	\N	3	1	0	1	-1
6235	1066	451	\N	3	1	0	1	-1
6236	1066	520	\N	3	1	0	1	-1
6237	1066	744	\N	3	1	0	1	-1
6238	1066	821	\N	3	1	0	1	-1
6239	1066	1137	\N	3	1	0	1	-1
6240	1066	1352	\N	3	1	0	1	-1
6241	1137	212	\N	3	1	0	1	-1
6242	1137	451	\N	3	1	0	1	-1
6243	1137	520	\N	3	1	0	1	-1
6244	1137	744	\N	3	1	0	1	-1
6245	1137	821	\N	3	1	0	1	-1
6246	1137	1066	\N	3	1	0	1	-1
6247	1137	1352	\N	3	1	0	1	-1
6248	1352	212	\N	3	1	0	1	-1
6249	1352	451	\N	3	1	0	1	-1
6250	1352	520	\N	3	1	0	1	-1
6251	1352	744	\N	3	1	0	1	-1
6252	1352	821	\N	3	1	0	1	-1
6253	1352	1066	\N	3	1	0	1	-1
6254	1352	1137	\N	3	1	0	1	-1
6255	213	452	\N	3	1	0	1	-1
6256	213	521	\N	3	1	0	1	-1
6257	213	745	\N	3	1	0	1	-1
6258	213	822	\N	3	1	0	1	-1
6259	213	1067	\N	3	1	0	1	-1
6260	213	1138	\N	3	1	0	1	-1
6261	213	1353	\N	3	1	0	1	-1
6262	452	213	\N	3	1	0	1	-1
6263	452	521	\N	3	1	0	1	-1
6264	452	745	\N	3	1	0	1	-1
6265	452	822	\N	3	1	0	1	-1
6266	452	1067	\N	3	1	0	1	-1
6267	452	1138	\N	3	1	0	1	-1
6268	452	1353	\N	3	1	0	1	-1
6269	521	213	\N	3	1	0	1	-1
6270	521	452	\N	3	1	0	1	-1
6271	521	745	\N	3	1	0	1	-1
6272	521	822	\N	3	1	0	1	-1
6273	521	1067	\N	3	1	0	1	-1
6274	521	1138	\N	3	1	0	1	-1
6275	521	1353	\N	3	1	0	1	-1
6276	745	213	\N	3	1	0	1	-1
6277	745	452	\N	3	1	0	1	-1
6278	745	521	\N	3	1	0	1	-1
6279	745	822	\N	3	1	0	1	-1
6280	745	1067	\N	3	1	0	1	-1
6281	745	1138	\N	3	1	0	1	-1
6282	745	1353	\N	3	1	0	1	-1
6283	822	213	\N	3	1	0	1	-1
6284	822	452	\N	3	1	0	1	-1
6285	822	521	\N	3	1	0	1	-1
6286	822	745	\N	3	1	0	1	-1
6287	822	1067	\N	3	1	0	1	-1
6288	822	1138	\N	3	1	0	1	-1
6289	822	1353	\N	3	1	0	1	-1
6290	1067	213	\N	3	1	0	1	-1
6291	1067	452	\N	3	1	0	1	-1
6292	1067	521	\N	3	1	0	1	-1
6293	1067	745	\N	3	1	0	1	-1
6294	1067	822	\N	3	1	0	1	-1
6295	1067	1138	\N	3	1	0	1	-1
6296	1067	1353	\N	3	1	0	1	-1
6297	1138	213	\N	3	1	0	1	-1
6298	1138	452	\N	3	1	0	1	-1
6299	1138	521	\N	3	1	0	1	-1
6300	1138	745	\N	3	1	0	1	-1
6301	1138	822	\N	3	1	0	1	-1
6302	1138	1067	\N	3	1	0	1	-1
6303	1138	1353	\N	3	1	0	1	-1
6304	1353	213	\N	3	1	0	1	-1
6305	1353	452	\N	3	1	0	1	-1
6306	1353	521	\N	3	1	0	1	-1
6307	1353	745	\N	3	1	0	1	-1
6308	1353	822	\N	3	1	0	1	-1
6309	1353	1067	\N	3	1	0	1	-1
6310	1353	1138	\N	3	1	0	1	-1
6311	214	453	\N	3	1	0	1	-1
6312	214	522	\N	3	1	0	1	-1
6313	214	746	\N	3	1	0	1	-1
6314	214	823	\N	3	1	0	1	-1
6315	214	880	\N	3	1	0	1	-1
6316	214	1068	\N	3	1	0	1	-1
6317	214	1139	\N	3	1	0	1	-1
6318	214	1354	\N	3	1	0	1	-1
6319	453	214	\N	3	1	0	1	-1
6320	453	522	\N	3	1	0	1	-1
6321	453	746	\N	3	1	0	1	-1
6322	453	823	\N	3	1	0	1	-1
6323	453	880	\N	3	1	0	1	-1
6324	453	1068	\N	3	1	0	1	-1
6325	453	1139	\N	3	1	0	1	-1
6326	453	1354	\N	3	1	0	1	-1
6327	522	214	\N	3	1	0	1	-1
6328	522	453	\N	3	1	0	1	-1
6329	522	746	\N	3	1	0	1	-1
6330	522	823	\N	3	1	0	1	-1
6331	522	880	\N	3	1	0	1	-1
6332	522	1068	\N	3	1	0	1	-1
6333	522	1139	\N	3	1	0	1	-1
6334	522	1354	\N	3	1	0	1	-1
6335	746	214	\N	3	1	0	1	-1
6336	746	453	\N	3	1	0	1	-1
6337	746	522	\N	3	1	0	1	-1
6338	746	823	\N	3	1	0	1	-1
6339	746	880	\N	3	1	0	1	-1
6340	746	1068	\N	3	1	0	1	-1
6341	746	1139	\N	3	1	0	1	-1
6342	746	1354	\N	3	1	0	1	-1
6343	823	214	\N	3	1	0	1	-1
6344	823	453	\N	3	1	0	1	-1
6345	823	522	\N	3	1	0	1	-1
6346	823	746	\N	3	1	0	1	-1
6347	823	880	\N	3	1	0	1	-1
6348	823	1068	\N	3	1	0	1	-1
6349	823	1139	\N	3	1	0	1	-1
6350	823	1354	\N	3	1	0	1	-1
6351	880	214	\N	3	1	0	1	-1
6352	880	453	\N	3	1	0	1	-1
6353	880	522	\N	3	1	0	1	-1
6354	880	746	\N	3	1	0	1	-1
6355	880	823	\N	3	1	0	1	-1
6356	880	1068	\N	3	1	0	1	-1
6357	880	1139	\N	3	1	0	1	-1
6358	880	1354	\N	3	1	0	1	-1
6359	1068	214	\N	3	1	0	1	-1
6360	1068	453	\N	3	1	0	1	-1
6361	1068	522	\N	3	1	0	1	-1
6362	1068	746	\N	3	1	0	1	-1
6363	1068	823	\N	3	1	0	1	-1
6364	1068	880	\N	3	1	0	1	-1
6365	1068	1139	\N	3	1	0	1	-1
6366	1068	1354	\N	3	1	0	1	-1
6367	1139	214	\N	3	1	0	1	-1
6368	1139	453	\N	3	1	0	1	-1
6369	1139	522	\N	3	1	0	1	-1
6370	1139	746	\N	3	1	0	1	-1
6371	1139	823	\N	3	1	0	1	-1
6372	1139	880	\N	3	1	0	1	-1
6373	1139	1068	\N	3	1	0	1	-1
6374	1139	1354	\N	3	1	0	1	-1
6375	1354	214	\N	3	1	0	1	-1
6376	1354	453	\N	3	1	0	1	-1
6377	1354	522	\N	3	1	0	1	-1
6378	1354	746	\N	3	1	0	1	-1
6379	1354	823	\N	3	1	0	1	-1
6380	1354	880	\N	3	1	0	1	-1
6381	1354	1068	\N	3	1	0	1	-1
6382	1354	1139	\N	3	1	0	1	-1
6383	215	226	\N	3	1	0	1	-1
6384	215	454	\N	3	1	0	1	-1
6385	215	523	\N	3	1	0	1	-1
6386	215	747	\N	3	1	0	1	-1
6387	215	824	\N	3	1	0	1	-1
6388	215	881	\N	3	1	0	1	-1
6389	215	1069	\N	3	1	0	1	-1
6390	215	1104	\N	3	1	0	1	-1
6391	215	1140	\N	3	1	0	1	-1
6392	215	1189	\N	3	1	0	1	-1
6393	215	1335	\N	3	1	0	1	-1
6394	215	1355	\N	3	1	0	1	-1
6395	226	215	\N	3	1	0	1	-1
6396	226	454	\N	3	1	0	1	-1
6397	226	523	\N	3	1	0	1	-1
6398	226	747	\N	3	1	0	1	-1
6399	226	824	\N	3	1	0	1	-1
6400	226	881	\N	3	1	0	1	-1
6401	226	1069	\N	3	1	0	1	-1
6402	226	1104	\N	3	1	0	1	-1
6403	226	1140	\N	3	1	0	1	-1
6404	226	1189	\N	3	1	0	1	-1
6405	226	1335	\N	3	1	0	1	-1
6406	226	1355	\N	3	1	0	1	-1
6407	454	215	\N	3	1	0	1	-1
6408	454	226	\N	3	1	0	1	-1
6409	454	523	\N	3	1	0	1	-1
6410	454	747	\N	3	1	0	1	-1
6411	454	824	\N	3	1	0	1	-1
6412	454	881	\N	3	1	0	1	-1
6413	454	1069	\N	3	1	0	1	-1
6414	454	1104	\N	3	1	0	1	-1
6415	454	1140	\N	3	1	0	1	-1
6416	454	1189	\N	3	1	0	1	-1
6417	454	1335	\N	3	1	0	1	-1
6418	454	1355	\N	3	1	0	1	-1
6419	523	215	\N	3	1	0	1	-1
6420	523	226	\N	3	1	0	1	-1
6421	523	454	\N	3	1	0	1	-1
6422	523	747	\N	3	1	0	1	-1
6423	523	824	\N	3	1	0	1	-1
6424	523	881	\N	3	1	0	1	-1
6425	523	1069	\N	3	1	0	1	-1
6426	523	1104	\N	3	1	0	1	-1
6427	523	1140	\N	3	1	0	1	-1
6428	523	1189	\N	3	1	0	1	-1
6429	523	1335	\N	3	1	0	1	-1
6430	523	1355	\N	3	1	0	1	-1
6431	747	215	\N	3	1	0	1	-1
6432	747	226	\N	3	1	0	1	-1
6433	747	454	\N	3	1	0	1	-1
6434	747	523	\N	3	1	0	1	-1
6435	747	824	\N	3	1	0	1	-1
6436	747	881	\N	3	1	0	1	-1
6437	747	1069	\N	3	1	0	1	-1
6438	747	1104	\N	3	1	0	1	-1
6439	747	1140	\N	3	1	0	1	-1
6440	747	1189	\N	3	1	0	1	-1
6441	747	1335	\N	3	1	0	1	-1
6442	747	1355	\N	3	1	0	1	-1
6443	824	215	\N	3	1	0	1	-1
6444	824	226	\N	3	1	0	1	-1
6445	824	454	\N	3	1	0	1	-1
6446	824	523	\N	3	1	0	1	-1
6447	824	747	\N	3	1	0	1	-1
6448	824	881	\N	3	1	0	1	-1
6449	824	1069	\N	3	1	0	1	-1
6450	824	1104	\N	3	1	0	1	-1
6451	824	1140	\N	3	1	0	1	-1
6452	824	1189	\N	3	1	0	1	-1
6453	824	1335	\N	3	1	0	1	-1
6454	824	1355	\N	3	1	0	1	-1
6455	881	215	\N	3	1	0	1	-1
6456	881	226	\N	3	1	0	1	-1
6457	881	454	\N	3	1	0	1	-1
6458	881	523	\N	3	1	0	1	-1
6459	881	747	\N	3	1	0	1	-1
6460	881	824	\N	3	1	0	1	-1
6461	881	1069	\N	3	1	0	1	-1
6462	881	1104	\N	3	1	0	1	-1
6463	881	1140	\N	3	1	0	1	-1
6464	881	1189	\N	3	1	0	1	-1
6465	881	1335	\N	3	1	0	1	-1
6466	881	1355	\N	3	1	0	1	-1
6467	1069	215	\N	3	1	0	1	-1
6468	1069	226	\N	3	1	0	1	-1
6469	1069	454	\N	3	1	0	1	-1
6470	1069	523	\N	3	1	0	1	-1
6471	1069	747	\N	3	1	0	1	-1
6472	1069	824	\N	3	1	0	1	-1
6473	1069	881	\N	3	1	0	1	-1
6474	1069	1104	\N	3	1	0	1	-1
6475	1069	1140	\N	3	1	0	1	-1
6476	1069	1189	\N	3	1	0	1	-1
6477	1069	1335	\N	3	1	0	1	-1
6478	1069	1355	\N	3	1	0	1	-1
6479	1104	215	\N	3	1	0	1	-1
6480	1104	226	\N	3	1	0	1	-1
6481	1104	454	\N	3	1	0	1	-1
6482	1104	523	\N	3	1	0	1	-1
6483	1104	747	\N	3	1	0	1	-1
6484	1104	824	\N	3	1	0	1	-1
6485	1104	881	\N	3	1	0	1	-1
6486	1104	1069	\N	3	1	0	1	-1
6487	1104	1140	\N	3	1	0	1	-1
6488	1104	1189	\N	3	1	0	1	-1
6489	1104	1335	\N	3	1	0	1	-1
6490	1104	1355	\N	3	1	0	1	-1
6491	1140	215	\N	3	1	0	1	-1
6492	1140	226	\N	3	1	0	1	-1
6493	1140	454	\N	3	1	0	1	-1
6494	1140	523	\N	3	1	0	1	-1
6495	1140	747	\N	3	1	0	1	-1
6496	1140	824	\N	3	1	0	1	-1
6497	1140	881	\N	3	1	0	1	-1
6498	1140	1069	\N	3	1	0	1	-1
6499	1140	1104	\N	3	1	0	1	-1
6500	1140	1189	\N	3	1	0	1	-1
6501	1140	1335	\N	3	1	0	1	-1
6502	1140	1355	\N	3	1	0	1	-1
6503	1189	215	\N	3	1	0	1	-1
6504	1189	226	\N	3	1	0	1	-1
6505	1189	454	\N	3	1	0	1	-1
6506	1189	523	\N	3	1	0	1	-1
6507	1189	747	\N	3	1	0	1	-1
6508	1189	824	\N	3	1	0	1	-1
6509	1189	881	\N	3	1	0	1	-1
6510	1189	1069	\N	3	1	0	1	-1
6511	1189	1104	\N	3	1	0	1	-1
6512	1189	1140	\N	3	1	0	1	-1
6513	1189	1335	\N	3	1	0	1	-1
6514	1189	1355	\N	3	1	0	1	-1
6515	1335	215	\N	3	1	0	1	-1
6516	1335	226	\N	3	1	0	1	-1
6517	1335	454	\N	3	1	0	1	-1
6518	1335	523	\N	3	1	0	1	-1
6519	1335	747	\N	3	1	0	1	-1
6520	1335	824	\N	3	1	0	1	-1
6521	1335	881	\N	3	1	0	1	-1
6522	1335	1069	\N	3	1	0	1	-1
6523	1335	1104	\N	3	1	0	1	-1
6524	1335	1140	\N	3	1	0	1	-1
6525	1335	1189	\N	3	1	0	1	-1
6526	1335	1355	\N	3	1	0	1	-1
6527	1355	215	\N	3	1	0	1	-1
6528	1355	226	\N	3	1	0	1	-1
6529	1355	454	\N	3	1	0	1	-1
6530	1355	523	\N	3	1	0	1	-1
6531	1355	747	\N	3	1	0	1	-1
6532	1355	824	\N	3	1	0	1	-1
6533	1355	881	\N	3	1	0	1	-1
6534	1355	1069	\N	3	1	0	1	-1
6535	1355	1104	\N	3	1	0	1	-1
6536	1355	1140	\N	3	1	0	1	-1
6537	1355	1189	\N	3	1	0	1	-1
6538	1355	1335	\N	3	1	0	1	-1
6539	216	225	\N	3	1	0	1	-1
6540	216	455	\N	3	1	0	1	-1
6541	216	524	\N	3	1	0	1	-1
6542	216	748	\N	3	1	0	1	-1
6543	216	825	\N	3	1	0	1	-1
6544	216	882	\N	3	1	0	1	-1
6545	216	1070	\N	3	1	0	1	-1
6546	216	1103	\N	3	1	0	1	-1
6547	216	1141	\N	3	1	0	1	-1
6548	216	1188	\N	3	1	0	1	-1
6549	216	1334	\N	3	1	0	1	-1
6550	216	1356	\N	3	1	0	1	-1
6551	225	216	\N	3	1	0	1	-1
6552	225	455	\N	3	1	0	1	-1
6553	225	524	\N	3	1	0	1	-1
6554	225	748	\N	3	1	0	1	-1
6555	225	825	\N	3	1	0	1	-1
6556	225	882	\N	3	1	0	1	-1
6557	225	1070	\N	3	1	0	1	-1
6558	225	1103	\N	3	1	0	1	-1
6559	225	1141	\N	3	1	0	1	-1
6560	225	1188	\N	3	1	0	1	-1
6561	225	1334	\N	3	1	0	1	-1
6562	225	1356	\N	3	1	0	1	-1
6563	455	216	\N	3	1	0	1	-1
6564	455	225	\N	3	1	0	1	-1
6565	455	524	\N	3	1	0	1	-1
6566	455	748	\N	3	1	0	1	-1
6567	455	825	\N	3	1	0	1	-1
6568	455	882	\N	3	1	0	1	-1
6569	455	1070	\N	3	1	0	1	-1
6570	455	1103	\N	3	1	0	1	-1
6571	455	1141	\N	3	1	0	1	-1
6572	455	1188	\N	3	1	0	1	-1
6573	455	1334	\N	3	1	0	1	-1
6574	455	1356	\N	3	1	0	1	-1
6575	524	216	\N	3	1	0	1	-1
6576	524	225	\N	3	1	0	1	-1
6577	524	455	\N	3	1	0	1	-1
6578	524	748	\N	3	1	0	1	-1
6579	524	825	\N	3	1	0	1	-1
6580	524	882	\N	3	1	0	1	-1
6581	524	1070	\N	3	1	0	1	-1
6582	524	1103	\N	3	1	0	1	-1
6583	524	1141	\N	3	1	0	1	-1
6584	524	1188	\N	3	1	0	1	-1
6585	524	1334	\N	3	1	0	1	-1
6586	524	1356	\N	3	1	0	1	-1
6587	748	216	\N	3	1	0	1	-1
6588	748	225	\N	3	1	0	1	-1
6589	748	455	\N	3	1	0	1	-1
6590	748	524	\N	3	1	0	1	-1
6591	748	825	\N	3	1	0	1	-1
6592	748	882	\N	3	1	0	1	-1
6593	748	1070	\N	3	1	0	1	-1
6594	748	1103	\N	3	1	0	1	-1
6595	748	1141	\N	3	1	0	1	-1
6596	748	1188	\N	3	1	0	1	-1
6597	748	1334	\N	3	1	0	1	-1
6598	748	1356	\N	3	1	0	1	-1
6599	825	216	\N	3	1	0	1	-1
6600	825	225	\N	3	1	0	1	-1
6601	825	455	\N	3	1	0	1	-1
6602	825	524	\N	3	1	0	1	-1
6603	825	748	\N	3	1	0	1	-1
6604	825	882	\N	3	1	0	1	-1
6605	825	1070	\N	3	1	0	1	-1
6606	825	1103	\N	3	1	0	1	-1
6607	825	1141	\N	3	1	0	1	-1
6608	825	1188	\N	3	1	0	1	-1
6609	825	1334	\N	3	1	0	1	-1
6610	825	1356	\N	3	1	0	1	-1
6611	882	216	\N	3	1	0	1	-1
6612	882	225	\N	3	1	0	1	-1
6613	882	455	\N	3	1	0	1	-1
6614	882	524	\N	3	1	0	1	-1
6615	882	748	\N	3	1	0	1	-1
6616	882	825	\N	3	1	0	1	-1
6617	882	1070	\N	3	1	0	1	-1
6618	882	1103	\N	3	1	0	1	-1
6619	882	1141	\N	3	1	0	1	-1
6620	882	1188	\N	3	1	0	1	-1
6621	882	1334	\N	3	1	0	1	-1
6622	882	1356	\N	3	1	0	1	-1
6623	1070	216	\N	3	1	0	1	-1
6624	1070	225	\N	3	1	0	1	-1
6625	1070	455	\N	3	1	0	1	-1
6626	1070	524	\N	3	1	0	1	-1
6627	1070	748	\N	3	1	0	1	-1
6628	1070	825	\N	3	1	0	1	-1
6629	1070	882	\N	3	1	0	1	-1
6630	1070	1103	\N	3	1	0	1	-1
6631	1070	1141	\N	3	1	0	1	-1
6632	1070	1188	\N	3	1	0	1	-1
6633	1070	1334	\N	3	1	0	1	-1
6634	1070	1356	\N	3	1	0	1	-1
6635	1103	216	\N	3	1	0	1	-1
6636	1103	225	\N	3	1	0	1	-1
6637	1103	455	\N	3	1	0	1	-1
6638	1103	524	\N	3	1	0	1	-1
6639	1103	748	\N	3	1	0	1	-1
6640	1103	825	\N	3	1	0	1	-1
6641	1103	882	\N	3	1	0	1	-1
6642	1103	1070	\N	3	1	0	1	-1
6643	1103	1141	\N	3	1	0	1	-1
6644	1103	1188	\N	3	1	0	1	-1
6645	1103	1334	\N	3	1	0	1	-1
6646	1103	1356	\N	3	1	0	1	-1
6647	1141	216	\N	3	1	0	1	-1
6648	1141	225	\N	3	1	0	1	-1
6649	1141	455	\N	3	1	0	1	-1
6650	1141	524	\N	3	1	0	1	-1
6651	1141	748	\N	3	1	0	1	-1
6652	1141	825	\N	3	1	0	1	-1
6653	1141	882	\N	3	1	0	1	-1
6654	1141	1070	\N	3	1	0	1	-1
6655	1141	1103	\N	3	1	0	1	-1
6656	1141	1188	\N	3	1	0	1	-1
6657	1141	1334	\N	3	1	0	1	-1
6658	1141	1356	\N	3	1	0	1	-1
6659	1188	216	\N	3	1	0	1	-1
6660	1188	225	\N	3	1	0	1	-1
6661	1188	455	\N	3	1	0	1	-1
6662	1188	524	\N	3	1	0	1	-1
6663	1188	748	\N	3	1	0	1	-1
6664	1188	825	\N	3	1	0	1	-1
6665	1188	882	\N	3	1	0	1	-1
6666	1188	1070	\N	3	1	0	1	-1
6667	1188	1103	\N	3	1	0	1	-1
6668	1188	1141	\N	3	1	0	1	-1
6669	1188	1334	\N	3	1	0	1	-1
6670	1188	1356	\N	3	1	0	1	-1
6671	1334	216	\N	3	1	0	1	-1
6672	1334	225	\N	3	1	0	1	-1
6673	1334	455	\N	3	1	0	1	-1
6674	1334	524	\N	3	1	0	1	-1
6675	1334	748	\N	3	1	0	1	-1
6676	1334	825	\N	3	1	0	1	-1
6677	1334	882	\N	3	1	0	1	-1
6678	1334	1070	\N	3	1	0	1	-1
6679	1334	1103	\N	3	1	0	1	-1
6680	1334	1141	\N	3	1	0	1	-1
6681	1334	1188	\N	3	1	0	1	-1
6682	1334	1356	\N	3	1	0	1	-1
6683	1356	216	\N	3	1	0	1	-1
6684	1356	225	\N	3	1	0	1	-1
6685	1356	455	\N	3	1	0	1	-1
6686	1356	524	\N	3	1	0	1	-1
6687	1356	748	\N	3	1	0	1	-1
6688	1356	825	\N	3	1	0	1	-1
6689	1356	882	\N	3	1	0	1	-1
6690	1356	1070	\N	3	1	0	1	-1
6691	1356	1103	\N	3	1	0	1	-1
6692	1356	1141	\N	3	1	0	1	-1
6693	1356	1188	\N	3	1	0	1	-1
6694	1356	1334	\N	3	1	0	1	-1
6695	217	224	\N	3	1	0	1	-1
6696	217	1002	\N	3	1	0	1	-1
6697	217	1532	\N	3	1	0	1	-1
6698	224	217	\N	3	1	0	1	-1
6699	224	1002	\N	3	1	0	1	-1
6700	224	1532	\N	3	1	0	1	-1
6701	1002	217	\N	3	1	0	1	-1
6702	1002	224	\N	3	1	0	1	-1
6703	1002	1532	\N	3	1	0	1	-1
6704	1532	217	\N	3	1	0	1	-1
6705	1532	224	\N	3	1	0	1	-1
6706	1532	1002	\N	3	1	0	1	-1
6707	218	223	\N	3	1	0	1	-1
6708	218	987	\N	3	1	0	1	-1
6709	218	1003	\N	3	1	0	1	-1
6710	218	1451	\N	3	1	0	1	-1
6711	218	1533	\N	3	1	0	1	-1
6712	223	218	\N	3	1	0	1	-1
6713	223	987	\N	3	1	0	1	-1
6714	223	1003	\N	3	1	0	1	-1
6715	223	1451	\N	3	1	0	1	-1
6716	223	1533	\N	3	1	0	1	-1
6717	987	218	\N	3	1	0	1	-1
6718	987	223	\N	3	1	0	1	-1
6719	987	1003	\N	3	1	0	1	-1
6720	987	1451	\N	3	1	0	1	-1
6721	987	1533	\N	3	1	0	1	-1
6722	1003	218	\N	3	1	0	1	-1
6723	1003	223	\N	3	1	0	1	-1
6724	1003	987	\N	3	1	0	1	-1
6725	1003	1451	\N	3	1	0	1	-1
6726	1003	1533	\N	3	1	0	1	-1
6727	1451	218	\N	3	1	0	1	-1
6728	1451	223	\N	3	1	0	1	-1
6729	1451	987	\N	3	1	0	1	-1
6730	1451	1003	\N	3	1	0	1	-1
6731	1451	1533	\N	3	1	0	1	-1
6732	1533	218	\N	3	1	0	1	-1
6733	1533	223	\N	3	1	0	1	-1
6734	1533	987	\N	3	1	0	1	-1
6735	1533	1003	\N	3	1	0	1	-1
6736	1533	1451	\N	3	1	0	1	-1
6737	219	222	\N	3	1	0	1	-1
6738	219	986	\N	3	1	0	1	-1
6739	219	1004	\N	3	1	0	1	-1
6740	219	1450	\N	3	1	0	1	-1
6741	219	1534	\N	3	1	0	1	-1
6742	222	219	\N	3	1	0	1	-1
6743	222	986	\N	3	1	0	1	-1
6744	222	1004	\N	3	1	0	1	-1
6745	222	1450	\N	3	1	0	1	-1
6746	222	1534	\N	3	1	0	1	-1
6747	986	219	\N	3	1	0	1	-1
6748	986	222	\N	3	1	0	1	-1
6749	986	1004	\N	3	1	0	1	-1
6750	986	1450	\N	3	1	0	1	-1
6751	986	1534	\N	3	1	0	1	-1
6752	1004	219	\N	3	1	0	1	-1
6753	1004	222	\N	3	1	0	1	-1
6754	1004	986	\N	3	1	0	1	-1
6755	1004	1450	\N	3	1	0	1	-1
6756	1004	1534	\N	3	1	0	1	-1
6757	1450	219	\N	3	1	0	1	-1
6758	1450	222	\N	3	1	0	1	-1
6759	1450	986	\N	3	1	0	1	-1
6760	1450	1004	\N	3	1	0	1	-1
6761	1450	1534	\N	3	1	0	1	-1
6762	1534	219	\N	3	1	0	1	-1
6763	1534	222	\N	3	1	0	1	-1
6764	1534	986	\N	3	1	0	1	-1
6765	1534	1004	\N	3	1	0	1	-1
6766	1534	1450	\N	3	1	0	1	-1
6767	220	221	\N	3	1	0	1	-1
6768	220	1005	\N	3	1	0	1	-1
6769	220	1535	\N	3	1	0	1	-1
6770	221	220	\N	3	1	0	1	-1
6771	221	1005	\N	3	1	0	1	-1
6772	221	1535	\N	3	1	0	1	-1
6773	1005	220	\N	3	1	0	1	-1
6774	1005	221	\N	3	1	0	1	-1
6775	1005	1535	\N	3	1	0	1	-1
6776	1535	220	\N	3	1	0	1	-1
6777	1535	221	\N	3	1	0	1	-1
6778	1535	1005	\N	3	1	0	1	-1
6779	227	494	\N	3	1	0	1	-1
6780	227	547	\N	3	1	0	1	-1
6781	227	771	\N	3	1	0	1	-1
6782	227	803	\N	3	1	0	1	-1
6783	227	908	\N	3	1	0	1	-1
6784	227	1105	\N	3	1	0	1	-1
6785	227	1190	\N	3	1	0	1	-1
6786	227	1336	\N	3	1	0	1	-1
6787	494	227	\N	3	1	0	1	-1
6788	494	547	\N	3	1	0	1	-1
6789	494	771	\N	3	1	0	1	-1
6790	494	803	\N	3	1	0	1	-1
6791	494	908	\N	3	1	0	1	-1
6792	494	1105	\N	3	1	0	1	-1
6793	494	1190	\N	3	1	0	1	-1
6794	494	1336	\N	3	1	0	1	-1
6795	547	227	\N	3	1	0	1	-1
6796	547	494	\N	3	1	0	1	-1
6797	547	771	\N	3	1	0	1	-1
6798	547	803	\N	3	1	0	1	-1
6799	547	908	\N	3	1	0	1	-1
6800	547	1105	\N	3	1	0	1	-1
6801	547	1190	\N	3	1	0	1	-1
6802	547	1336	\N	3	1	0	1	-1
6803	771	227	\N	3	1	0	1	-1
6804	771	494	\N	3	1	0	1	-1
6805	771	547	\N	3	1	0	1	-1
6806	771	803	\N	3	1	0	1	-1
6807	771	908	\N	3	1	0	1	-1
6808	771	1105	\N	3	1	0	1	-1
6809	771	1190	\N	3	1	0	1	-1
6810	771	1336	\N	3	1	0	1	-1
6811	803	227	\N	3	1	0	1	-1
6812	803	494	\N	3	1	0	1	-1
6813	803	547	\N	3	1	0	1	-1
6814	803	771	\N	3	1	0	1	-1
6815	803	908	\N	3	1	0	1	-1
6816	803	1105	\N	3	1	0	1	-1
6817	803	1190	\N	3	1	0	1	-1
6818	803	1336	\N	3	1	0	1	-1
6819	908	227	\N	3	1	0	1	-1
6820	908	494	\N	3	1	0	1	-1
6821	908	547	\N	3	1	0	1	-1
6822	908	771	\N	3	1	0	1	-1
6823	908	803	\N	3	1	0	1	-1
6824	908	1105	\N	3	1	0	1	-1
6825	908	1190	\N	3	1	0	1	-1
6826	908	1336	\N	3	1	0	1	-1
6827	1105	227	\N	3	1	0	1	-1
6828	1105	494	\N	3	1	0	1	-1
6829	1105	547	\N	3	1	0	1	-1
6830	1105	771	\N	3	1	0	1	-1
6831	1105	803	\N	3	1	0	1	-1
6832	1105	908	\N	3	1	0	1	-1
6833	1105	1190	\N	3	1	0	1	-1
6834	1105	1336	\N	3	1	0	1	-1
6835	1190	227	\N	3	1	0	1	-1
6836	1190	494	\N	3	1	0	1	-1
6837	1190	547	\N	3	1	0	1	-1
6838	1190	771	\N	3	1	0	1	-1
6839	1190	803	\N	3	1	0	1	-1
6840	1190	908	\N	3	1	0	1	-1
6841	1190	1105	\N	3	1	0	1	-1
6842	1190	1336	\N	3	1	0	1	-1
6843	1336	227	\N	3	1	0	1	-1
6844	1336	494	\N	3	1	0	1	-1
6845	1336	547	\N	3	1	0	1	-1
6846	1336	771	\N	3	1	0	1	-1
6847	1336	803	\N	3	1	0	1	-1
6848	1336	908	\N	3	1	0	1	-1
6849	1336	1105	\N	3	1	0	1	-1
6850	1336	1190	\N	3	1	0	1	-1
6851	228	495	\N	3	1	0	1	-1
6852	228	548	\N	3	1	0	1	-1
6853	228	772	\N	3	1	0	1	-1
6854	228	804	\N	3	1	0	1	-1
6855	228	1106	\N	3	1	0	1	-1
6856	228	1191	\N	3	1	0	1	-1
6857	228	1337	\N	3	1	0	1	-1
6858	495	228	\N	3	1	0	1	-1
6859	495	548	\N	3	1	0	1	-1
6860	495	772	\N	3	1	0	1	-1
6861	495	804	\N	3	1	0	1	-1
6862	495	1106	\N	3	1	0	1	-1
6863	495	1191	\N	3	1	0	1	-1
6864	495	1337	\N	3	1	0	1	-1
6865	548	228	\N	3	1	0	1	-1
6866	548	495	\N	3	1	0	1	-1
6867	548	772	\N	3	1	0	1	-1
6868	548	804	\N	3	1	0	1	-1
6869	548	1106	\N	3	1	0	1	-1
6870	548	1191	\N	3	1	0	1	-1
6871	548	1337	\N	3	1	0	1	-1
6872	772	228	\N	3	1	0	1	-1
6873	772	495	\N	3	1	0	1	-1
6874	772	548	\N	3	1	0	1	-1
6875	772	804	\N	3	1	0	1	-1
6876	772	1106	\N	3	1	0	1	-1
6877	772	1191	\N	3	1	0	1	-1
6878	772	1337	\N	3	1	0	1	-1
6879	804	228	\N	3	1	0	1	-1
6880	804	495	\N	3	1	0	1	-1
6881	804	548	\N	3	1	0	1	-1
6882	804	772	\N	3	1	0	1	-1
6883	804	1106	\N	3	1	0	1	-1
6884	804	1191	\N	3	1	0	1	-1
6885	804	1337	\N	3	1	0	1	-1
6886	1106	228	\N	3	1	0	1	-1
6887	1106	495	\N	3	1	0	1	-1
6888	1106	548	\N	3	1	0	1	-1
6889	1106	772	\N	3	1	0	1	-1
6890	1106	804	\N	3	1	0	1	-1
6891	1106	1191	\N	3	1	0	1	-1
6892	1106	1337	\N	3	1	0	1	-1
6893	1191	228	\N	3	1	0	1	-1
6894	1191	495	\N	3	1	0	1	-1
6895	1191	548	\N	3	1	0	1	-1
6896	1191	772	\N	3	1	0	1	-1
6897	1191	804	\N	3	1	0	1	-1
6898	1191	1106	\N	3	1	0	1	-1
6899	1191	1337	\N	3	1	0	1	-1
6900	1337	228	\N	3	1	0	1	-1
6901	1337	495	\N	3	1	0	1	-1
6902	1337	548	\N	3	1	0	1	-1
6903	1337	772	\N	3	1	0	1	-1
6904	1337	804	\N	3	1	0	1	-1
6905	1337	1106	\N	3	1	0	1	-1
6906	1337	1191	\N	3	1	0	1	-1
6907	229	496	\N	3	1	0	1	-1
6908	229	549	\N	3	1	0	1	-1
6909	229	773	\N	3	1	0	1	-1
6910	229	805	\N	3	1	0	1	-1
6911	229	1107	\N	3	1	0	1	-1
6912	229	1192	\N	3	1	0	1	-1
6913	229	1338	\N	3	1	0	1	-1
6914	496	229	\N	3	1	0	1	-1
6915	496	549	\N	3	1	0	1	-1
6916	496	773	\N	3	1	0	1	-1
6917	496	805	\N	3	1	0	1	-1
6918	496	1107	\N	3	1	0	1	-1
6919	496	1192	\N	3	1	0	1	-1
6920	496	1338	\N	3	1	0	1	-1
6921	549	229	\N	3	1	0	1	-1
6922	549	496	\N	3	1	0	1	-1
6923	549	773	\N	3	1	0	1	-1
6924	549	805	\N	3	1	0	1	-1
6925	549	1107	\N	3	1	0	1	-1
6926	549	1192	\N	3	1	0	1	-1
6927	549	1338	\N	3	1	0	1	-1
6928	773	229	\N	3	1	0	1	-1
6929	773	496	\N	3	1	0	1	-1
6930	773	549	\N	3	1	0	1	-1
6931	773	805	\N	3	1	0	1	-1
6932	773	1107	\N	3	1	0	1	-1
6933	773	1192	\N	3	1	0	1	-1
6934	773	1338	\N	3	1	0	1	-1
6935	805	229	\N	3	1	0	1	-1
6936	805	496	\N	3	1	0	1	-1
6937	805	549	\N	3	1	0	1	-1
6938	805	773	\N	3	1	0	1	-1
6939	805	1107	\N	3	1	0	1	-1
6940	805	1192	\N	3	1	0	1	-1
6941	805	1338	\N	3	1	0	1	-1
6942	1107	229	\N	3	1	0	1	-1
6943	1107	496	\N	3	1	0	1	-1
6944	1107	549	\N	3	1	0	1	-1
6945	1107	773	\N	3	1	0	1	-1
6946	1107	805	\N	3	1	0	1	-1
6947	1107	1192	\N	3	1	0	1	-1
6948	1107	1338	\N	3	1	0	1	-1
6949	1192	229	\N	3	1	0	1	-1
6950	1192	496	\N	3	1	0	1	-1
6951	1192	549	\N	3	1	0	1	-1
6952	1192	773	\N	3	1	0	1	-1
6953	1192	805	\N	3	1	0	1	-1
6954	1192	1107	\N	3	1	0	1	-1
6955	1192	1338	\N	3	1	0	1	-1
6956	1338	229	\N	3	1	0	1	-1
6957	1338	496	\N	3	1	0	1	-1
6958	1338	549	\N	3	1	0	1	-1
6959	1338	773	\N	3	1	0	1	-1
6960	1338	805	\N	3	1	0	1	-1
6961	1338	1107	\N	3	1	0	1	-1
6962	1338	1192	\N	3	1	0	1	-1
6963	230	497	\N	3	1	0	1	-1
6964	230	550	\N	3	1	0	1	-1
6965	230	774	\N	3	1	0	1	-1
6966	230	806	\N	3	1	0	1	-1
6967	230	1108	\N	3	1	0	1	-1
6968	230	1193	\N	3	1	0	1	-1
6969	230	1339	\N	3	1	0	1	-1
6970	497	230	\N	3	1	0	1	-1
6971	497	550	\N	3	1	0	1	-1
6972	497	774	\N	3	1	0	1	-1
6973	497	806	\N	3	1	0	1	-1
6974	497	1108	\N	3	1	0	1	-1
6975	497	1193	\N	3	1	0	1	-1
6976	497	1339	\N	3	1	0	1	-1
6977	550	230	\N	3	1	0	1	-1
6978	550	497	\N	3	1	0	1	-1
6979	550	774	\N	3	1	0	1	-1
6980	550	806	\N	3	1	0	1	-1
6981	550	1108	\N	3	1	0	1	-1
6982	550	1193	\N	3	1	0	1	-1
6983	550	1339	\N	3	1	0	1	-1
6984	774	230	\N	3	1	0	1	-1
6985	774	497	\N	3	1	0	1	-1
6986	774	550	\N	3	1	0	1	-1
6987	774	806	\N	3	1	0	1	-1
6988	774	1108	\N	3	1	0	1	-1
6989	774	1193	\N	3	1	0	1	-1
6990	774	1339	\N	3	1	0	1	-1
6991	806	230	\N	3	1	0	1	-1
6992	806	497	\N	3	1	0	1	-1
6993	806	550	\N	3	1	0	1	-1
6994	806	774	\N	3	1	0	1	-1
6995	806	1108	\N	3	1	0	1	-1
6996	806	1193	\N	3	1	0	1	-1
6997	806	1339	\N	3	1	0	1	-1
6998	1108	230	\N	3	1	0	1	-1
6999	1108	497	\N	3	1	0	1	-1
7000	1108	550	\N	3	1	0	1	-1
7001	1108	774	\N	3	1	0	1	-1
7002	1108	806	\N	3	1	0	1	-1
7003	1108	1193	\N	3	1	0	1	-1
7004	1108	1339	\N	3	1	0	1	-1
7005	1193	230	\N	3	1	0	1	-1
7006	1193	497	\N	3	1	0	1	-1
7007	1193	550	\N	3	1	0	1	-1
7008	1193	774	\N	3	1	0	1	-1
7009	1193	806	\N	3	1	0	1	-1
7010	1193	1108	\N	3	1	0	1	-1
7011	1193	1339	\N	3	1	0	1	-1
7012	1339	230	\N	3	1	0	1	-1
7013	1339	497	\N	3	1	0	1	-1
7014	1339	550	\N	3	1	0	1	-1
7015	1339	774	\N	3	1	0	1	-1
7016	1339	806	\N	3	1	0	1	-1
7017	1339	1108	\N	3	1	0	1	-1
7018	1339	1193	\N	3	1	0	1	-1
7019	231	498	\N	3	1	0	1	-1
7020	231	551	\N	3	1	0	1	-1
7021	231	775	\N	3	1	0	1	-1
7022	231	807	\N	3	1	0	1	-1
7023	231	1109	\N	3	1	0	1	-1
7024	231	1194	\N	3	1	0	1	-1
7025	231	1340	\N	3	1	0	1	-1
7026	498	231	\N	3	1	0	1	-1
7027	498	551	\N	3	1	0	1	-1
7028	498	775	\N	3	1	0	1	-1
7029	498	807	\N	3	1	0	1	-1
7030	498	1109	\N	3	1	0	1	-1
7031	498	1194	\N	3	1	0	1	-1
7032	498	1340	\N	3	1	0	1	-1
7033	551	231	\N	3	1	0	1	-1
7034	551	498	\N	3	1	0	1	-1
7035	551	775	\N	3	1	0	1	-1
7036	551	807	\N	3	1	0	1	-1
7037	551	1109	\N	3	1	0	1	-1
7038	551	1194	\N	3	1	0	1	-1
7039	551	1340	\N	3	1	0	1	-1
7040	775	231	\N	3	1	0	1	-1
7041	775	498	\N	3	1	0	1	-1
7042	775	551	\N	3	1	0	1	-1
7043	775	807	\N	3	1	0	1	-1
7044	775	1109	\N	3	1	0	1	-1
7045	775	1194	\N	3	1	0	1	-1
7046	775	1340	\N	3	1	0	1	-1
7047	807	231	\N	3	1	0	1	-1
7048	807	498	\N	3	1	0	1	-1
7049	807	551	\N	3	1	0	1	-1
7050	807	775	\N	3	1	0	1	-1
7051	807	1109	\N	3	1	0	1	-1
7052	807	1194	\N	3	1	0	1	-1
7053	807	1340	\N	3	1	0	1	-1
7054	1109	231	\N	3	1	0	1	-1
7055	1109	498	\N	3	1	0	1	-1
7056	1109	551	\N	3	1	0	1	-1
7057	1109	775	\N	3	1	0	1	-1
7058	1109	807	\N	3	1	0	1	-1
7059	1109	1194	\N	3	1	0	1	-1
7060	1109	1340	\N	3	1	0	1	-1
7061	1194	231	\N	3	1	0	1	-1
7062	1194	498	\N	3	1	0	1	-1
7063	1194	551	\N	3	1	0	1	-1
7064	1194	775	\N	3	1	0	1	-1
7065	1194	807	\N	3	1	0	1	-1
7066	1194	1109	\N	3	1	0	1	-1
7067	1194	1340	\N	3	1	0	1	-1
7068	1340	231	\N	3	1	0	1	-1
7069	1340	498	\N	3	1	0	1	-1
7070	1340	551	\N	3	1	0	1	-1
7071	1340	775	\N	3	1	0	1	-1
7072	1340	807	\N	3	1	0	1	-1
7073	1340	1109	\N	3	1	0	1	-1
7074	1340	1194	\N	3	1	0	1	-1
7075	232	499	\N	3	1	0	1	-1
7076	232	552	\N	3	1	0	1	-1
7077	232	776	\N	3	1	0	1	-1
7078	232	808	\N	3	1	0	1	-1
7079	232	1110	\N	3	1	0	1	-1
7080	232	1195	\N	3	1	0	1	-1
7081	232	1341	\N	3	1	0	1	-1
7082	499	232	\N	3	1	0	1	-1
7083	499	552	\N	3	1	0	1	-1
7084	499	776	\N	3	1	0	1	-1
7085	499	808	\N	3	1	0	1	-1
7086	499	1110	\N	3	1	0	1	-1
7087	499	1195	\N	3	1	0	1	-1
7088	499	1341	\N	3	1	0	1	-1
7089	552	232	\N	3	1	0	1	-1
7090	552	499	\N	3	1	0	1	-1
7091	552	776	\N	3	1	0	1	-1
7092	552	808	\N	3	1	0	1	-1
7093	552	1110	\N	3	1	0	1	-1
7094	552	1195	\N	3	1	0	1	-1
7095	552	1341	\N	3	1	0	1	-1
7096	776	232	\N	3	1	0	1	-1
7097	776	499	\N	3	1	0	1	-1
7098	776	552	\N	3	1	0	1	-1
7099	776	808	\N	3	1	0	1	-1
7100	776	1110	\N	3	1	0	1	-1
7101	776	1195	\N	3	1	0	1	-1
7102	776	1341	\N	3	1	0	1	-1
7103	808	232	\N	3	1	0	1	-1
7104	808	499	\N	3	1	0	1	-1
7105	808	552	\N	3	1	0	1	-1
7106	808	776	\N	3	1	0	1	-1
7107	808	1110	\N	3	1	0	1	-1
7108	808	1195	\N	3	1	0	1	-1
7109	808	1341	\N	3	1	0	1	-1
7110	1110	232	\N	3	1	0	1	-1
7111	1110	499	\N	3	1	0	1	-1
7112	1110	552	\N	3	1	0	1	-1
7113	1110	776	\N	3	1	0	1	-1
7114	1110	808	\N	3	1	0	1	-1
7115	1110	1195	\N	3	1	0	1	-1
7116	1110	1341	\N	3	1	0	1	-1
7117	1195	232	\N	3	1	0	1	-1
7118	1195	499	\N	3	1	0	1	-1
7119	1195	552	\N	3	1	0	1	-1
7120	1195	776	\N	3	1	0	1	-1
7121	1195	808	\N	3	1	0	1	-1
7122	1195	1110	\N	3	1	0	1	-1
7123	1195	1341	\N	3	1	0	1	-1
7124	1341	232	\N	3	1	0	1	-1
7125	1341	499	\N	3	1	0	1	-1
7126	1341	552	\N	3	1	0	1	-1
7127	1341	776	\N	3	1	0	1	-1
7128	1341	808	\N	3	1	0	1	-1
7129	1341	1110	\N	3	1	0	1	-1
7130	1341	1195	\N	3	1	0	1	-1
7131	233	435	\N	3	1	0	1	-1
7132	233	1111	\N	3	1	0	1	-1
7133	233	1196	\N	3	1	0	1	-1
7134	233	1342	\N	3	1	0	1	-1
7135	435	233	\N	3	1	0	1	-1
7136	435	1111	\N	3	1	0	1	-1
7137	435	1196	\N	3	1	0	1	-1
7138	435	1342	\N	3	1	0	1	-1
7139	1111	233	\N	3	1	0	1	-1
7140	1111	435	\N	3	1	0	1	-1
7141	1111	1196	\N	3	1	0	1	-1
7142	1111	1342	\N	3	1	0	1	-1
7143	1196	233	\N	3	1	0	1	-1
7144	1196	435	\N	3	1	0	1	-1
7145	1196	1111	\N	3	1	0	1	-1
7146	1196	1342	\N	3	1	0	1	-1
7147	1342	233	\N	3	1	0	1	-1
7148	1342	435	\N	3	1	0	1	-1
7149	1342	1111	\N	3	1	0	1	-1
7150	1342	1196	\N	3	1	0	1	-1
7151	236	502	\N	3	1	0	1	-1
7152	236	779	\N	3	1	0	1	-1
7153	236	1114	\N	3	1	0	1	-1
7154	236	1377	\N	3	1	0	1	-1
7155	236	1400	\N	3	1	0	1	-1
7156	502	236	\N	3	1	0	1	-1
7157	502	779	\N	3	1	0	1	-1
7158	502	1114	\N	3	1	0	1	-1
7159	502	1377	\N	3	1	0	1	-1
7160	502	1400	\N	3	1	0	1	-1
7161	779	236	\N	3	1	0	1	-1
7162	779	502	\N	3	1	0	1	-1
7163	779	1114	\N	3	1	0	1	-1
7164	779	1377	\N	3	1	0	1	-1
7165	779	1400	\N	3	1	0	1	-1
7166	1114	236	\N	3	1	0	1	-1
7167	1114	502	\N	3	1	0	1	-1
7168	1114	779	\N	3	1	0	1	-1
7169	1114	1377	\N	3	1	0	1	-1
7170	1114	1400	\N	3	1	0	1	-1
7171	1377	236	\N	3	1	0	1	-1
7172	1377	502	\N	3	1	0	1	-1
7173	1377	779	\N	3	1	0	1	-1
7174	1377	1114	\N	3	1	0	1	-1
7175	1377	1400	\N	3	1	0	1	-1
7176	1400	236	\N	3	1	0	1	-1
7177	1400	502	\N	3	1	0	1	-1
7178	1400	779	\N	3	1	0	1	-1
7179	1400	1114	\N	3	1	0	1	-1
7180	1400	1377	\N	3	1	0	1	-1
7181	237	503	\N	3	1	0	1	-1
7182	237	780	\N	3	1	0	1	-1
7183	237	1115	\N	3	1	0	1	-1
7184	237	1378	\N	3	1	0	1	-1
7185	237	1399	\N	3	1	0	1	-1
7186	503	237	\N	3	1	0	1	-1
7187	503	780	\N	3	1	0	1	-1
7188	503	1115	\N	3	1	0	1	-1
7189	503	1378	\N	3	1	0	1	-1
7190	503	1399	\N	3	1	0	1	-1
7191	780	237	\N	3	1	0	1	-1
7192	780	503	\N	3	1	0	1	-1
7193	780	1115	\N	3	1	0	1	-1
7194	780	1378	\N	3	1	0	1	-1
7195	780	1399	\N	3	1	0	1	-1
7196	1115	237	\N	3	1	0	1	-1
7197	1115	503	\N	3	1	0	1	-1
7198	1115	780	\N	3	1	0	1	-1
7199	1115	1378	\N	3	1	0	1	-1
7200	1115	1399	\N	3	1	0	1	-1
7201	1378	237	\N	3	1	0	1	-1
7202	1378	503	\N	3	1	0	1	-1
7203	1378	780	\N	3	1	0	1	-1
7204	1378	1115	\N	3	1	0	1	-1
7205	1378	1399	\N	3	1	0	1	-1
7206	1399	237	\N	3	1	0	1	-1
7207	1399	503	\N	3	1	0	1	-1
7208	1399	780	\N	3	1	0	1	-1
7209	1399	1115	\N	3	1	0	1	-1
7210	1399	1378	\N	3	1	0	1	-1
7211	252	323	\N	3	1	0	1	-1
7212	323	252	\N	3	1	0	1	-1
7213	263	312	\N	3	1	0	1	-1
7214	263	961	\N	3	1	0	1	-1
7215	263	1029	\N	3	1	0	1	-1
7216	263	1234	\N	3	1	0	1	-1
7217	263	1235	\N	3	1	0	1	-1
7218	263	1475	\N	3	1	0	1	-1
7219	263	1510	\N	3	1	0	1	-1
7220	312	263	\N	3	1	0	1	-1
7221	312	961	\N	3	1	0	1	-1
7222	312	1029	\N	3	1	0	1	-1
7223	312	1234	\N	3	1	0	1	-1
7224	312	1235	\N	3	1	0	1	-1
7225	312	1475	\N	3	1	0	1	-1
7226	312	1510	\N	3	1	0	1	-1
7227	961	263	\N	3	1	0	1	-1
7228	961	312	\N	3	1	0	1	-1
7229	961	1029	\N	3	1	0	1	-1
7230	961	1234	\N	3	1	0	1	-1
7231	961	1235	\N	3	1	0	1	-1
7232	961	1475	\N	3	1	0	1	-1
7233	961	1510	\N	3	1	0	1	-1
7234	1029	263	\N	3	1	0	1	-1
7235	1029	312	\N	3	1	0	1	-1
7236	1029	961	\N	3	1	0	1	-1
7237	1029	1234	\N	3	1	0	1	-1
7238	1029	1235	\N	3	1	0	1	-1
7239	1029	1475	\N	3	1	0	1	-1
7240	1029	1510	\N	3	1	0	1	-1
7241	1234	263	\N	3	1	0	1	-1
7242	1234	312	\N	3	1	0	1	-1
7243	1234	961	\N	3	1	0	1	-1
7244	1234	1029	\N	3	1	0	1	-1
7245	1234	1235	\N	3	1	0	1	-1
7246	1234	1475	\N	3	1	0	1	-1
7247	1234	1510	\N	3	1	0	1	-1
7248	1235	263	\N	3	1	0	1	-1
7249	1235	312	\N	3	1	0	1	-1
7250	1235	961	\N	3	1	0	1	-1
7251	1235	1029	\N	3	1	0	1	-1
7252	1235	1234	\N	3	1	0	1	-1
7253	1235	1475	\N	3	1	0	1	-1
7254	1235	1510	\N	3	1	0	1	-1
7255	1475	263	\N	3	1	0	1	-1
7256	1475	312	\N	3	1	0	1	-1
7257	1475	961	\N	3	1	0	1	-1
7258	1475	1029	\N	3	1	0	1	-1
7259	1475	1234	\N	3	1	0	1	-1
7260	1475	1235	\N	3	1	0	1	-1
7261	1475	1510	\N	3	1	0	1	-1
7262	1510	263	\N	3	1	0	1	-1
7263	1510	312	\N	3	1	0	1	-1
7264	1510	961	\N	3	1	0	1	-1
7265	1510	1029	\N	3	1	0	1	-1
7266	1510	1234	\N	3	1	0	1	-1
7267	1510	1235	\N	3	1	0	1	-1
7268	1510	1475	\N	3	1	0	1	-1
7269	264	311	\N	3	1	0	1	-1
7270	264	962	\N	3	1	0	1	-1
7271	264	1028	\N	3	1	0	1	-1
7272	264	1476	\N	3	1	0	1	-1
7273	264	1509	\N	3	1	0	1	-1
7274	311	264	\N	3	1	0	1	-1
7275	311	962	\N	3	1	0	1	-1
7276	311	1028	\N	3	1	0	1	-1
7277	311	1476	\N	3	1	0	1	-1
7278	311	1509	\N	3	1	0	1	-1
7279	962	264	\N	3	1	0	1	-1
7280	962	311	\N	3	1	0	1	-1
7281	962	1028	\N	3	1	0	1	-1
7282	962	1476	\N	3	1	0	1	-1
7283	962	1509	\N	3	1	0	1	-1
7284	1028	264	\N	3	1	0	1	-1
7285	1028	311	\N	3	1	0	1	-1
7286	1028	962	\N	3	1	0	1	-1
7287	1028	1476	\N	3	1	0	1	-1
7288	1028	1509	\N	3	1	0	1	-1
7289	1476	264	\N	3	1	0	1	-1
7290	1476	311	\N	3	1	0	1	-1
7291	1476	962	\N	3	1	0	1	-1
7292	1476	1028	\N	3	1	0	1	-1
7293	1476	1509	\N	3	1	0	1	-1
7294	1509	264	\N	3	1	0	1	-1
7295	1509	311	\N	3	1	0	1	-1
7296	1509	962	\N	3	1	0	1	-1
7297	1509	1028	\N	3	1	0	1	-1
7298	1509	1476	\N	3	1	0	1	-1
7299	265	310	\N	3	1	0	1	-1
7300	265	963	\N	3	1	0	1	-1
7301	265	1027	\N	3	1	0	1	-1
7302	265	1477	\N	3	1	0	1	-1
7303	265	1508	\N	3	1	0	1	-1
7304	310	265	\N	3	1	0	1	-1
7305	310	963	\N	3	1	0	1	-1
7306	310	1027	\N	3	1	0	1	-1
7307	310	1477	\N	3	1	0	1	-1
7308	310	1508	\N	3	1	0	1	-1
7309	963	265	\N	3	1	0	1	-1
7310	963	310	\N	3	1	0	1	-1
7311	963	1027	\N	3	1	0	1	-1
7312	963	1477	\N	3	1	0	1	-1
7313	963	1508	\N	3	1	0	1	-1
7314	1027	265	\N	3	1	0	1	-1
7315	1027	310	\N	3	1	0	1	-1
7316	1027	963	\N	3	1	0	1	-1
7317	1027	1477	\N	3	1	0	1	-1
7318	1027	1508	\N	3	1	0	1	-1
7319	1477	265	\N	3	1	0	1	-1
7320	1477	310	\N	3	1	0	1	-1
7321	1477	963	\N	3	1	0	1	-1
7322	1477	1027	\N	3	1	0	1	-1
7323	1477	1508	\N	3	1	0	1	-1
7324	1508	265	\N	3	1	0	1	-1
7325	1508	310	\N	3	1	0	1	-1
7326	1508	963	\N	3	1	0	1	-1
7327	1508	1027	\N	3	1	0	1	-1
7328	1508	1477	\N	3	1	0	1	-1
7329	266	309	\N	3	1	0	1	-1
7330	266	964	\N	3	1	0	1	-1
7331	266	1026	\N	3	1	0	1	-1
7332	266	1478	\N	3	1	0	1	-1
7333	266	1507	\N	3	1	0	1	-1
7334	309	266	\N	3	1	0	1	-1
7335	309	964	\N	3	1	0	1	-1
7336	309	1026	\N	3	1	0	1	-1
7337	309	1478	\N	3	1	0	1	-1
7338	309	1507	\N	3	1	0	1	-1
7339	964	266	\N	3	1	0	1	-1
7340	964	309	\N	3	1	0	1	-1
7341	964	1026	\N	3	1	0	1	-1
7342	964	1478	\N	3	1	0	1	-1
7343	964	1507	\N	3	1	0	1	-1
7344	1026	266	\N	3	1	0	1	-1
7345	1026	309	\N	3	1	0	1	-1
7346	1026	964	\N	3	1	0	1	-1
7347	1026	1478	\N	3	1	0	1	-1
7348	1026	1507	\N	3	1	0	1	-1
7349	1478	266	\N	3	1	0	1	-1
7350	1478	309	\N	3	1	0	1	-1
7351	1478	964	\N	3	1	0	1	-1
7352	1478	1026	\N	3	1	0	1	-1
7353	1478	1507	\N	3	1	0	1	-1
7354	1507	266	\N	3	1	0	1	-1
7355	1507	309	\N	3	1	0	1	-1
7356	1507	964	\N	3	1	0	1	-1
7357	1507	1026	\N	3	1	0	1	-1
7358	1507	1478	\N	3	1	0	1	-1
7359	267	308	\N	3	1	0	1	-1
7360	267	965	\N	3	1	0	1	-1
7361	267	1025	\N	3	1	0	1	-1
7362	267	1479	\N	3	1	0	1	-1
7363	267	1506	\N	3	1	0	1	-1
7364	308	267	\N	3	1	0	1	-1
7365	308	965	\N	3	1	0	1	-1
7366	308	1025	\N	3	1	0	1	-1
7367	308	1479	\N	3	1	0	1	-1
7368	308	1506	\N	3	1	0	1	-1
7369	965	267	\N	3	1	0	1	-1
7370	965	308	\N	3	1	0	1	-1
7371	965	1025	\N	3	1	0	1	-1
7372	965	1479	\N	3	1	0	1	-1
7373	965	1506	\N	3	1	0	1	-1
7374	1025	267	\N	3	1	0	1	-1
7375	1025	308	\N	3	1	0	1	-1
7376	1025	965	\N	3	1	0	1	-1
7377	1025	1479	\N	3	1	0	1	-1
7378	1025	1506	\N	3	1	0	1	-1
7379	1479	267	\N	3	1	0	1	-1
7380	1479	308	\N	3	1	0	1	-1
7381	1479	965	\N	3	1	0	1	-1
7382	1479	1025	\N	3	1	0	1	-1
7383	1479	1506	\N	3	1	0	1	-1
7384	1506	267	\N	3	1	0	1	-1
7385	1506	308	\N	3	1	0	1	-1
7386	1506	965	\N	3	1	0	1	-1
7387	1506	1025	\N	3	1	0	1	-1
7388	1506	1479	\N	3	1	0	1	-1
7389	268	307	\N	3	1	0	1	-1
7390	268	966	\N	3	1	0	1	-1
7391	268	1024	\N	3	1	0	1	-1
7392	268	1480	\N	3	1	0	1	-1
7393	268	1505	\N	3	1	0	1	-1
7394	307	268	\N	3	1	0	1	-1
7395	307	966	\N	3	1	0	1	-1
7396	307	1024	\N	3	1	0	1	-1
7397	307	1480	\N	3	1	0	1	-1
7398	307	1505	\N	3	1	0	1	-1
7399	966	268	\N	3	1	0	1	-1
7400	966	307	\N	3	1	0	1	-1
7401	966	1024	\N	3	1	0	1	-1
7402	966	1480	\N	3	1	0	1	-1
7403	966	1505	\N	3	1	0	1	-1
7404	1024	268	\N	3	1	0	1	-1
7405	1024	307	\N	3	1	0	1	-1
7406	1024	966	\N	3	1	0	1	-1
7407	1024	1480	\N	3	1	0	1	-1
7408	1024	1505	\N	3	1	0	1	-1
7409	1480	268	\N	3	1	0	1	-1
7410	1480	307	\N	3	1	0	1	-1
7411	1480	966	\N	3	1	0	1	-1
7412	1480	1024	\N	3	1	0	1	-1
7413	1480	1505	\N	3	1	0	1	-1
7414	1505	268	\N	3	1	0	1	-1
7415	1505	307	\N	3	1	0	1	-1
7416	1505	966	\N	3	1	0	1	-1
7417	1505	1024	\N	3	1	0	1	-1
7418	1505	1480	\N	3	1	0	1	-1
7419	269	306	\N	3	1	0	1	-1
7420	269	967	\N	3	1	0	1	-1
7421	269	1023	\N	3	1	0	1	-1
7422	269	1481	\N	3	1	0	1	-1
7423	269	1504	\N	3	1	0	1	-1
7424	306	269	\N	3	1	0	1	-1
7425	306	967	\N	3	1	0	1	-1
7426	306	1023	\N	3	1	0	1	-1
7427	306	1481	\N	3	1	0	1	-1
7428	306	1504	\N	3	1	0	1	-1
7429	967	269	\N	3	1	0	1	-1
7430	967	306	\N	3	1	0	1	-1
7431	967	1023	\N	3	1	0	1	-1
7432	967	1481	\N	3	1	0	1	-1
7433	967	1504	\N	3	1	0	1	-1
7434	1023	269	\N	3	1	0	1	-1
7435	1023	306	\N	3	1	0	1	-1
7436	1023	967	\N	3	1	0	1	-1
7437	1023	1481	\N	3	1	0	1	-1
7438	1023	1504	\N	3	1	0	1	-1
7439	1481	269	\N	3	1	0	1	-1
7440	1481	306	\N	3	1	0	1	-1
7441	1481	967	\N	3	1	0	1	-1
7442	1481	1023	\N	3	1	0	1	-1
7443	1481	1504	\N	3	1	0	1	-1
7444	1504	269	\N	3	1	0	1	-1
7445	1504	306	\N	3	1	0	1	-1
7446	1504	967	\N	3	1	0	1	-1
7447	1504	1023	\N	3	1	0	1	-1
7448	1504	1481	\N	3	1	0	1	-1
7449	270	305	\N	3	1	0	1	-1
7450	270	968	\N	3	1	0	1	-1
7451	270	1022	\N	3	1	0	1	-1
7452	270	1482	\N	3	1	0	1	-1
7453	270	1503	\N	3	1	0	1	-1
7454	305	270	\N	3	1	0	1	-1
7455	305	968	\N	3	1	0	1	-1
7456	305	1022	\N	3	1	0	1	-1
7457	305	1482	\N	3	1	0	1	-1
7458	305	1503	\N	3	1	0	1	-1
7459	968	270	\N	3	1	0	1	-1
7460	968	305	\N	3	1	0	1	-1
7461	968	1022	\N	3	1	0	1	-1
7462	968	1482	\N	3	1	0	1	-1
7463	968	1503	\N	3	1	0	1	-1
7464	1022	270	\N	3	1	0	1	-1
7465	1022	305	\N	3	1	0	1	-1
7466	1022	968	\N	3	1	0	1	-1
7467	1022	1482	\N	3	1	0	1	-1
7468	1022	1503	\N	3	1	0	1	-1
7469	1482	270	\N	3	1	0	1	-1
7470	1482	305	\N	3	1	0	1	-1
7471	1482	968	\N	3	1	0	1	-1
7472	1482	1022	\N	3	1	0	1	-1
7473	1482	1503	\N	3	1	0	1	-1
7474	1503	270	\N	3	1	0	1	-1
7475	1503	305	\N	3	1	0	1	-1
7476	1503	968	\N	3	1	0	1	-1
7477	1503	1022	\N	3	1	0	1	-1
7478	1503	1482	\N	3	1	0	1	-1
7479	271	304	\N	3	1	0	1	-1
7480	271	969	\N	3	1	0	1	-1
7481	271	1021	\N	3	1	0	1	-1
7482	271	1483	\N	3	1	0	1	-1
7483	271	1502	\N	3	1	0	1	-1
7484	304	271	\N	3	1	0	1	-1
7485	304	969	\N	3	1	0	1	-1
7486	304	1021	\N	3	1	0	1	-1
7487	304	1483	\N	3	1	0	1	-1
7488	304	1502	\N	3	1	0	1	-1
7489	969	271	\N	3	1	0	1	-1
7490	969	304	\N	3	1	0	1	-1
7491	969	1021	\N	3	1	0	1	-1
7492	969	1483	\N	3	1	0	1	-1
7493	969	1502	\N	3	1	0	1	-1
7494	1021	271	\N	3	1	0	1	-1
7495	1021	304	\N	3	1	0	1	-1
7496	1021	969	\N	3	1	0	1	-1
7497	1021	1483	\N	3	1	0	1	-1
7498	1021	1502	\N	3	1	0	1	-1
7499	1483	271	\N	3	1	0	1	-1
7500	1483	304	\N	3	1	0	1	-1
7501	1483	969	\N	3	1	0	1	-1
7502	1483	1021	\N	3	1	0	1	-1
7503	1483	1502	\N	3	1	0	1	-1
7504	1502	271	\N	3	1	0	1	-1
7505	1502	304	\N	3	1	0	1	-1
7506	1502	969	\N	3	1	0	1	-1
7507	1502	1021	\N	3	1	0	1	-1
7508	1502	1483	\N	3	1	0	1	-1
7509	272	303	\N	3	1	0	1	-1
7510	272	970	\N	3	1	0	1	-1
7511	272	1020	\N	3	1	0	1	-1
7512	272	1484	\N	3	1	0	1	-1
7513	272	1501	\N	3	1	0	1	-1
7514	303	272	\N	3	1	0	1	-1
7515	303	970	\N	3	1	0	1	-1
7516	303	1020	\N	3	1	0	1	-1
7517	303	1484	\N	3	1	0	1	-1
7518	303	1501	\N	3	1	0	1	-1
7519	970	272	\N	3	1	0	1	-1
7520	970	303	\N	3	1	0	1	-1
7521	970	1020	\N	3	1	0	1	-1
7522	970	1484	\N	3	1	0	1	-1
7523	970	1501	\N	3	1	0	1	-1
7524	1020	272	\N	3	1	0	1	-1
7525	1020	303	\N	3	1	0	1	-1
7526	1020	970	\N	3	1	0	1	-1
7527	1020	1484	\N	3	1	0	1	-1
7528	1020	1501	\N	3	1	0	1	-1
7529	1484	272	\N	3	1	0	1	-1
7530	1484	303	\N	3	1	0	1	-1
7531	1484	970	\N	3	1	0	1	-1
7532	1484	1020	\N	3	1	0	1	-1
7533	1484	1501	\N	3	1	0	1	-1
7534	1501	272	\N	3	1	0	1	-1
7535	1501	303	\N	3	1	0	1	-1
7536	1501	970	\N	3	1	0	1	-1
7537	1501	1020	\N	3	1	0	1	-1
7538	1501	1484	\N	3	1	0	1	-1
7539	324	368	\N	3	1	0	1	-1
7540	368	324	\N	3	1	0	1	-1
7541	325	367	\N	3	1	0	1	-1
7542	367	325	\N	3	1	0	1	-1
7543	326	366	\N	3	1	0	1	-1
7544	366	326	\N	3	1	0	1	-1
7545	327	365	\N	3	1	0	1	-1
7546	365	327	\N	3	1	0	1	-1
7547	328	364	\N	3	1	0	1	-1
7548	364	328	\N	3	1	0	1	-1
7549	329	363	\N	3	1	0	1	-1
7550	363	329	\N	3	1	0	1	-1
7551	330	362	\N	3	1	0	1	-1
7552	362	330	\N	3	1	0	1	-1
7553	331	361	\N	3	1	0	1	-1
7554	361	331	\N	3	1	0	1	-1
7555	332	360	\N	3	1	0	1	-1
7556	360	332	\N	3	1	0	1	-1
7557	333	359	\N	3	1	0	1	-1
7558	359	333	\N	3	1	0	1	-1
7559	334	358	\N	3	1	0	1	-1
7560	358	334	\N	3	1	0	1	-1
7561	335	357	\N	3	1	0	1	-1
7562	357	335	\N	3	1	0	1	-1
7563	369	407	\N	3	1	0	1	-1
7564	407	369	\N	3	1	0	1	-1
7565	370	406	\N	3	1	0	1	-1
7566	406	370	\N	3	1	0	1	-1
7567	371	405	\N	3	1	0	1	-1
7568	405	371	\N	3	1	0	1	-1
7569	372	404	\N	3	1	0	1	-1
7570	404	372	\N	3	1	0	1	-1
7571	373	403	\N	3	1	0	1	-1
7572	403	373	\N	3	1	0	1	-1
7573	374	402	\N	3	1	0	1	-1
7574	402	374	\N	3	1	0	1	-1
7575	375	401	\N	3	1	0	1	-1
7576	401	375	\N	3	1	0	1	-1
7577	376	400	\N	3	1	0	1	-1
7578	400	376	\N	3	1	0	1	-1
7579	377	399	\N	3	1	0	1	-1
7580	399	377	\N	3	1	0	1	-1
7581	378	398	\N	3	1	0	1	-1
7582	398	378	\N	3	1	0	1	-1
7583	379	397	\N	3	1	0	1	-1
7584	397	379	\N	3	1	0	1	-1
7585	380	396	\N	3	1	0	1	-1
7586	396	380	\N	3	1	0	1	-1
7587	418	427	\N	3	1	0	1	-1
7588	427	418	\N	3	1	0	1	-1
7589	419	426	\N	3	1	0	1	-1
7590	426	419	\N	3	1	0	1	-1
7591	420	425	\N	3	1	0	1	-1
7592	425	420	\N	3	1	0	1	-1
7593	421	424	\N	3	1	0	1	-1
7594	424	421	\N	3	1	0	1	-1
7595	422	423	\N	3	1	0	1	-1
7596	423	422	\N	3	1	0	1	-1
7597	434	448	\N	3	1	0	1	-1
7598	434	517	\N	3	1	0	1	-1
7599	434	741	\N	3	1	0	1	-1
7600	434	818	\N	3	1	0	1	-1
7601	434	1063	\N	3	1	0	1	-1
7602	448	434	\N	3	1	0	1	-1
7603	448	517	\N	3	1	0	1	-1
7604	448	741	\N	3	1	0	1	-1
7605	448	818	\N	3	1	0	1	-1
7606	448	1063	\N	3	1	0	1	-1
7607	517	434	\N	3	1	0	1	-1
7608	517	448	\N	3	1	0	1	-1
7609	517	741	\N	3	1	0	1	-1
7610	517	818	\N	3	1	0	1	-1
7611	517	1063	\N	3	1	0	1	-1
7612	741	434	\N	3	1	0	1	-1
7613	741	448	\N	3	1	0	1	-1
7614	741	517	\N	3	1	0	1	-1
7615	741	818	\N	3	1	0	1	-1
7616	741	1063	\N	3	1	0	1	-1
7617	818	434	\N	3	1	0	1	-1
7618	818	448	\N	3	1	0	1	-1
7619	818	517	\N	3	1	0	1	-1
7620	818	741	\N	3	1	0	1	-1
7621	818	1063	\N	3	1	0	1	-1
7622	1063	434	\N	3	1	0	1	-1
7623	1063	448	\N	3	1	0	1	-1
7624	1063	517	\N	3	1	0	1	-1
7625	1063	741	\N	3	1	0	1	-1
7626	1063	818	\N	3	1	0	1	-1
7627	456	525	\N	3	1	0	1	-1
7628	456	749	\N	3	1	0	1	-1
7629	456	826	\N	3	1	0	1	-1
7630	456	883	\N	3	1	0	1	-1
7631	456	989	\N	3	1	0	1	-1
7632	456	1071	\N	3	1	0	1	-1
7633	456	1142	\N	3	1	0	1	-1
7634	456	1256	\N	3	1	0	1	-1
7635	456	1304	\N	3	1	0	1	-1
7636	456	1357	\N	3	1	0	1	-1
7637	456	1453	\N	3	1	0	1	-1
7638	525	456	\N	3	1	0	1	-1
7639	525	749	\N	3	1	0	1	-1
7640	525	826	\N	3	1	0	1	-1
7641	525	883	\N	3	1	0	1	-1
7642	525	989	\N	3	1	0	1	-1
7643	525	1071	\N	3	1	0	1	-1
7644	525	1142	\N	3	1	0	1	-1
7645	525	1256	\N	3	1	0	1	-1
7646	525	1304	\N	3	1	0	1	-1
7647	525	1357	\N	3	1	0	1	-1
7648	525	1453	\N	3	1	0	1	-1
7649	749	456	\N	3	1	0	1	-1
7650	749	525	\N	3	1	0	1	-1
7651	749	826	\N	3	1	0	1	-1
7652	749	883	\N	3	1	0	1	-1
7653	749	989	\N	3	1	0	1	-1
7654	749	1071	\N	3	1	0	1	-1
7655	749	1142	\N	3	1	0	1	-1
7656	749	1256	\N	3	1	0	1	-1
7657	749	1304	\N	3	1	0	1	-1
7658	749	1357	\N	3	1	0	1	-1
7659	749	1453	\N	3	1	0	1	-1
7660	826	456	\N	3	1	0	1	-1
7661	826	525	\N	3	1	0	1	-1
7662	826	749	\N	3	1	0	1	-1
7663	826	883	\N	3	1	0	1	-1
7664	826	989	\N	3	1	0	1	-1
7665	826	1071	\N	3	1	0	1	-1
7666	826	1142	\N	3	1	0	1	-1
7667	826	1256	\N	3	1	0	1	-1
7668	826	1304	\N	3	1	0	1	-1
7669	826	1357	\N	3	1	0	1	-1
7670	826	1453	\N	3	1	0	1	-1
7671	883	456	\N	3	1	0	1	-1
7672	883	525	\N	3	1	0	1	-1
7673	883	749	\N	3	1	0	1	-1
7674	883	826	\N	3	1	0	1	-1
7675	883	989	\N	3	1	0	1	-1
7676	883	1071	\N	3	1	0	1	-1
7677	883	1142	\N	3	1	0	1	-1
7678	883	1256	\N	3	1	0	1	-1
7679	883	1304	\N	3	1	0	1	-1
7680	883	1357	\N	3	1	0	1	-1
7681	883	1453	\N	3	1	0	1	-1
7682	989	456	\N	3	1	0	1	-1
7683	989	525	\N	3	1	0	1	-1
7684	989	749	\N	3	1	0	1	-1
7685	989	826	\N	3	1	0	1	-1
7686	989	883	\N	3	1	0	1	-1
7687	989	1071	\N	3	1	0	1	-1
7688	989	1142	\N	3	1	0	1	-1
7689	989	1256	\N	3	1	0	1	-1
7690	989	1304	\N	3	1	0	1	-1
7691	989	1357	\N	3	1	0	1	-1
7692	989	1453	\N	3	1	0	1	-1
7693	1071	456	\N	3	1	0	1	-1
7694	1071	525	\N	3	1	0	1	-1
7695	1071	749	\N	3	1	0	1	-1
7696	1071	826	\N	3	1	0	1	-1
7697	1071	883	\N	3	1	0	1	-1
7698	1071	989	\N	3	1	0	1	-1
7699	1071	1142	\N	3	1	0	1	-1
7700	1071	1256	\N	3	1	0	1	-1
7701	1071	1304	\N	3	1	0	1	-1
7702	1071	1357	\N	3	1	0	1	-1
7703	1071	1453	\N	3	1	0	1	-1
7704	1142	456	\N	3	1	0	1	-1
7705	1142	525	\N	3	1	0	1	-1
7706	1142	749	\N	3	1	0	1	-1
7707	1142	826	\N	3	1	0	1	-1
7708	1142	883	\N	3	1	0	1	-1
7709	1142	989	\N	3	1	0	1	-1
7710	1142	1071	\N	3	1	0	1	-1
7711	1142	1256	\N	3	1	0	1	-1
7712	1142	1304	\N	3	1	0	1	-1
7713	1142	1357	\N	3	1	0	1	-1
7714	1142	1453	\N	3	1	0	1	-1
7715	1256	456	\N	3	1	0	1	-1
7716	1256	525	\N	3	1	0	1	-1
7717	1256	749	\N	3	1	0	1	-1
7718	1256	826	\N	3	1	0	1	-1
7719	1256	883	\N	3	1	0	1	-1
7720	1256	989	\N	3	1	0	1	-1
7721	1256	1071	\N	3	1	0	1	-1
7722	1256	1142	\N	3	1	0	1	-1
7723	1256	1304	\N	3	1	0	1	-1
7724	1256	1357	\N	3	1	0	1	-1
7725	1256	1453	\N	3	1	0	1	-1
7726	1304	456	\N	3	1	0	1	-1
7727	1304	525	\N	3	1	0	1	-1
7728	1304	749	\N	3	1	0	1	-1
7729	1304	826	\N	3	1	0	1	-1
7730	1304	883	\N	3	1	0	1	-1
7731	1304	989	\N	3	1	0	1	-1
7732	1304	1071	\N	3	1	0	1	-1
7733	1304	1142	\N	3	1	0	1	-1
7734	1304	1256	\N	3	1	0	1	-1
7735	1304	1357	\N	3	1	0	1	-1
7736	1304	1453	\N	3	1	0	1	-1
7737	1357	456	\N	3	1	0	1	-1
7738	1357	525	\N	3	1	0	1	-1
7739	1357	749	\N	3	1	0	1	-1
7740	1357	826	\N	3	1	0	1	-1
7741	1357	883	\N	3	1	0	1	-1
7742	1357	989	\N	3	1	0	1	-1
7743	1357	1071	\N	3	1	0	1	-1
7744	1357	1142	\N	3	1	0	1	-1
7745	1357	1256	\N	3	1	0	1	-1
7746	1357	1304	\N	3	1	0	1	-1
7747	1357	1453	\N	3	1	0	1	-1
7748	1453	456	\N	3	1	0	1	-1
7749	1453	525	\N	3	1	0	1	-1
7750	1453	749	\N	3	1	0	1	-1
7751	1453	826	\N	3	1	0	1	-1
7752	1453	883	\N	3	1	0	1	-1
7753	1453	989	\N	3	1	0	1	-1
7754	1453	1071	\N	3	1	0	1	-1
7755	1453	1142	\N	3	1	0	1	-1
7756	1453	1256	\N	3	1	0	1	-1
7757	1453	1304	\N	3	1	0	1	-1
7758	1453	1357	\N	3	1	0	1	-1
7759	457	750	\N	3	1	0	1	-1
7760	457	827	\N	3	1	0	1	-1
7761	457	1072	\N	3	1	0	1	-1
7762	457	1257	\N	3	1	0	1	-1
7763	457	1305	\N	3	1	0	1	-1
7764	457	1358	\N	3	1	0	1	-1
7765	750	457	\N	3	1	0	1	-1
7766	750	827	\N	3	1	0	1	-1
7767	750	1072	\N	3	1	0	1	-1
7768	750	1257	\N	3	1	0	1	-1
7769	750	1305	\N	3	1	0	1	-1
7770	750	1358	\N	3	1	0	1	-1
7771	827	457	\N	3	1	0	1	-1
7772	827	750	\N	3	1	0	1	-1
7773	827	1072	\N	3	1	0	1	-1
7774	827	1257	\N	3	1	0	1	-1
7775	827	1305	\N	3	1	0	1	-1
7776	827	1358	\N	3	1	0	1	-1
7777	1072	457	\N	3	1	0	1	-1
7778	1072	750	\N	3	1	0	1	-1
7779	1072	827	\N	3	1	0	1	-1
7780	1072	1257	\N	3	1	0	1	-1
7781	1072	1305	\N	3	1	0	1	-1
7782	1072	1358	\N	3	1	0	1	-1
7783	1257	457	\N	3	1	0	1	-1
7784	1257	750	\N	3	1	0	1	-1
7785	1257	827	\N	3	1	0	1	-1
7786	1257	1072	\N	3	1	0	1	-1
7787	1257	1305	\N	3	1	0	1	-1
7788	1257	1358	\N	3	1	0	1	-1
7789	1305	457	\N	3	1	0	1	-1
7790	1305	750	\N	3	1	0	1	-1
7791	1305	827	\N	3	1	0	1	-1
7792	1305	1072	\N	3	1	0	1	-1
7793	1305	1257	\N	3	1	0	1	-1
7794	1305	1358	\N	3	1	0	1	-1
7795	1358	457	\N	3	1	0	1	-1
7796	1358	750	\N	3	1	0	1	-1
7797	1358	827	\N	3	1	0	1	-1
7798	1358	1072	\N	3	1	0	1	-1
7799	1358	1257	\N	3	1	0	1	-1
7800	1358	1305	\N	3	1	0	1	-1
7801	458	1258	\N	3	1	0	1	-1
7802	458	1306	\N	3	1	0	1	-1
7803	458	1359	\N	3	1	0	1	-1
7804	1258	458	\N	3	1	0	1	-1
7805	1258	1306	\N	3	1	0	1	-1
7806	1258	1359	\N	3	1	0	1	-1
7807	1306	458	\N	3	1	0	1	-1
7808	1306	1258	\N	3	1	0	1	-1
7809	1306	1359	\N	3	1	0	1	-1
7810	1359	458	\N	3	1	0	1	-1
7811	1359	1258	\N	3	1	0	1	-1
7812	1359	1306	\N	3	1	0	1	-1
7813	459	1259	\N	3	1	0	1	-1
7814	459	1307	\N	3	1	0	1	-1
7815	459	1360	\N	3	1	0	1	-1
7816	1259	459	\N	3	1	0	1	-1
7817	1259	1307	\N	3	1	0	1	-1
7818	1259	1360	\N	3	1	0	1	-1
7819	1307	459	\N	3	1	0	1	-1
7820	1307	1259	\N	3	1	0	1	-1
7821	1307	1360	\N	3	1	0	1	-1
7822	1360	459	\N	3	1	0	1	-1
7823	1360	1259	\N	3	1	0	1	-1
7824	1360	1307	\N	3	1	0	1	-1
7825	460	487	\N	3	1	0	1	-1
7826	487	460	\N	3	1	0	1	-1
7827	461	486	\N	3	1	0	1	-1
7828	486	461	\N	3	1	0	1	-1
7829	462	485	\N	3	1	0	1	-1
7830	485	462	\N	3	1	0	1	-1
7831	463	484	\N	3	1	0	1	-1
7832	484	463	\N	3	1	0	1	-1
7833	464	483	\N	3	1	0	1	-1
7834	483	464	\N	3	1	0	1	-1
7835	465	482	\N	3	1	0	1	-1
7836	482	465	\N	3	1	0	1	-1
7837	466	481	\N	3	1	0	1	-1
7838	481	466	\N	3	1	0	1	-1
7839	467	480	\N	3	1	0	1	-1
7840	480	467	\N	3	1	0	1	-1
7841	468	479	\N	3	1	0	1	-1
7842	479	468	\N	3	1	0	1	-1
7843	469	478	\N	3	1	0	1	-1
7844	478	469	\N	3	1	0	1	-1
7845	470	477	\N	3	1	0	1	-1
7846	477	470	\N	3	1	0	1	-1
7847	471	476	\N	3	1	0	1	-1
7848	476	471	\N	3	1	0	1	-1
7849	472	475	\N	3	1	0	1	-1
7850	475	472	\N	3	1	0	1	-1
7851	473	474	\N	3	1	0	1	-1
7852	474	473	\N	3	1	0	1	-1
7853	488	1210	\N	3	1	0	1	-1
7854	488	1282	\N	3	1	0	1	-1
7855	488	1330	\N	3	1	0	1	-1
7856	1210	488	\N	3	1	0	1	-1
7857	1210	1282	\N	3	1	0	1	-1
7858	1210	1330	\N	3	1	0	1	-1
7859	1282	488	\N	3	1	0	1	-1
7860	1282	1210	\N	3	1	0	1	-1
7861	1282	1330	\N	3	1	0	1	-1
7862	1330	488	\N	3	1	0	1	-1
7863	1330	1210	\N	3	1	0	1	-1
7864	1330	1282	\N	3	1	0	1	-1
7865	489	1211	\N	3	1	0	1	-1
7866	489	1283	\N	3	1	0	1	-1
7867	489	1331	\N	3	1	0	1	-1
7868	1211	489	\N	3	1	0	1	-1
7869	1211	1283	\N	3	1	0	1	-1
7870	1211	1331	\N	3	1	0	1	-1
7871	1283	489	\N	3	1	0	1	-1
7872	1283	1211	\N	3	1	0	1	-1
7873	1283	1331	\N	3	1	0	1	-1
7874	1331	489	\N	3	1	0	1	-1
7875	1331	1211	\N	3	1	0	1	-1
7876	1331	1283	\N	3	1	0	1	-1
7877	490	1212	\N	3	1	0	1	-1
7878	490	1284	\N	3	1	0	1	-1
7879	490	1332	\N	3	1	0	1	-1
7880	1212	490	\N	3	1	0	1	-1
7881	1212	1284	\N	3	1	0	1	-1
7882	1212	1332	\N	3	1	0	1	-1
7883	1284	490	\N	3	1	0	1	-1
7884	1284	1212	\N	3	1	0	1	-1
7885	1284	1332	\N	3	1	0	1	-1
7886	1332	490	\N	3	1	0	1	-1
7887	1332	1212	\N	3	1	0	1	-1
7888	1332	1284	\N	3	1	0	1	-1
7889	493	546	\N	3	1	0	1	-1
7890	493	770	\N	3	1	0	1	-1
7891	493	802	\N	3	1	0	1	-1
7892	493	907	\N	3	1	0	1	-1
7893	546	493	\N	3	1	0	1	-1
7894	546	770	\N	3	1	0	1	-1
7895	546	802	\N	3	1	0	1	-1
7896	546	907	\N	3	1	0	1	-1
7897	770	493	\N	3	1	0	1	-1
7898	770	546	\N	3	1	0	1	-1
7899	770	802	\N	3	1	0	1	-1
7900	770	907	\N	3	1	0	1	-1
7901	802	493	\N	3	1	0	1	-1
7902	802	546	\N	3	1	0	1	-1
7903	802	770	\N	3	1	0	1	-1
7904	802	907	\N	3	1	0	1	-1
7905	907	493	\N	3	1	0	1	-1
7906	907	546	\N	3	1	0	1	-1
7907	907	770	\N	3	1	0	1	-1
7908	907	802	\N	3	1	0	1	-1
7909	500	553	\N	3	1	0	1	-1
7910	500	689	\N	3	1	0	1	-1
7911	500	777	\N	3	1	0	1	-1
7912	553	500	\N	3	1	0	1	-1
7913	553	689	\N	3	1	0	1	-1
7914	553	777	\N	3	1	0	1	-1
7915	689	500	\N	3	1	0	1	-1
7916	689	553	\N	3	1	0	1	-1
7917	689	777	\N	3	1	0	1	-1
7918	777	500	\N	3	1	0	1	-1
7919	777	553	\N	3	1	0	1	-1
7920	777	689	\N	3	1	0	1	-1
7921	501	778	\N	3	1	0	1	-1
7922	501	817	\N	3	1	0	1	-1
7923	778	501	\N	3	1	0	1	-1
7924	778	817	\N	3	1	0	1	-1
7925	817	501	\N	3	1	0	1	-1
7926	817	778	\N	3	1	0	1	-1
7927	526	884	\N	3	1	0	1	-1
7928	526	990	\N	3	1	0	1	-1
7929	526	1143	\N	3	1	0	1	-1
7930	526	1213	\N	3	1	0	1	-1
7931	526	1285	\N	3	1	0	1	-1
7932	526	1454	\N	3	1	0	1	-1
7933	884	526	\N	3	1	0	1	-1
7934	884	990	\N	3	1	0	1	-1
7935	884	1143	\N	3	1	0	1	-1
7936	884	1213	\N	3	1	0	1	-1
7937	884	1285	\N	3	1	0	1	-1
7938	884	1454	\N	3	1	0	1	-1
7939	990	526	\N	3	1	0	1	-1
7940	990	884	\N	3	1	0	1	-1
7941	990	1143	\N	3	1	0	1	-1
7942	990	1213	\N	3	1	0	1	-1
7943	990	1285	\N	3	1	0	1	-1
7944	990	1454	\N	3	1	0	1	-1
7945	1143	526	\N	3	1	0	1	-1
7946	1143	884	\N	3	1	0	1	-1
7947	1143	990	\N	3	1	0	1	-1
7948	1143	1213	\N	3	1	0	1	-1
7949	1143	1285	\N	3	1	0	1	-1
7950	1143	1454	\N	3	1	0	1	-1
7951	1213	526	\N	3	1	0	1	-1
7952	1213	884	\N	3	1	0	1	-1
7953	1213	990	\N	3	1	0	1	-1
7954	1213	1143	\N	3	1	0	1	-1
7955	1213	1285	\N	3	1	0	1	-1
7956	1213	1454	\N	3	1	0	1	-1
7957	1285	526	\N	3	1	0	1	-1
7958	1285	884	\N	3	1	0	1	-1
7959	1285	990	\N	3	1	0	1	-1
7960	1285	1143	\N	3	1	0	1	-1
7961	1285	1213	\N	3	1	0	1	-1
7962	1285	1454	\N	3	1	0	1	-1
7963	1454	526	\N	3	1	0	1	-1
7964	1454	884	\N	3	1	0	1	-1
7965	1454	990	\N	3	1	0	1	-1
7966	1454	1143	\N	3	1	0	1	-1
7967	1454	1213	\N	3	1	0	1	-1
7968	1454	1285	\N	3	1	0	1	-1
7969	527	543	\N	3	1	0	1	-1
7970	527	885	\N	3	1	0	1	-1
7971	527	904	\N	3	1	0	1	-1
7972	527	991	\N	3	1	0	1	-1
7973	527	1000	\N	3	1	0	1	-1
7974	527	1144	\N	3	1	0	1	-1
7975	527	1186	\N	3	1	0	1	-1
7976	527	1214	\N	3	1	0	1	-1
7977	527	1255	\N	3	1	0	1	-1
7978	527	1286	\N	3	1	0	1	-1
7979	527	1303	\N	3	1	0	1	-1
7980	527	1455	\N	3	1	0	1	-1
7981	527	1530	\N	3	1	0	1	-1
7982	543	527	\N	3	1	0	1	-1
7983	543	885	\N	3	1	0	1	-1
7984	543	904	\N	3	1	0	1	-1
7985	543	991	\N	3	1	0	1	-1
7986	543	1000	\N	3	1	0	1	-1
7987	543	1144	\N	3	1	0	1	-1
7988	543	1186	\N	3	1	0	1	-1
7989	543	1214	\N	3	1	0	1	-1
7990	543	1255	\N	3	1	0	1	-1
7991	543	1286	\N	3	1	0	1	-1
7992	543	1303	\N	3	1	0	1	-1
7993	543	1455	\N	3	1	0	1	-1
7994	543	1530	\N	3	1	0	1	-1
7995	885	527	\N	3	1	0	1	-1
7996	885	543	\N	3	1	0	1	-1
7997	885	904	\N	3	1	0	1	-1
7998	885	991	\N	3	1	0	1	-1
7999	885	1000	\N	3	1	0	1	-1
8000	885	1144	\N	3	1	0	1	-1
8001	885	1186	\N	3	1	0	1	-1
8002	885	1214	\N	3	1	0	1	-1
8003	885	1255	\N	3	1	0	1	-1
8004	885	1286	\N	3	1	0	1	-1
8005	885	1303	\N	3	1	0	1	-1
8006	885	1455	\N	3	1	0	1	-1
8007	885	1530	\N	3	1	0	1	-1
8008	904	527	\N	3	1	0	1	-1
8009	904	543	\N	3	1	0	1	-1
8010	904	885	\N	3	1	0	1	-1
8011	904	991	\N	3	1	0	1	-1
8012	904	1000	\N	3	1	0	1	-1
8013	904	1144	\N	3	1	0	1	-1
8014	904	1186	\N	3	1	0	1	-1
8015	904	1214	\N	3	1	0	1	-1
8016	904	1255	\N	3	1	0	1	-1
8017	904	1286	\N	3	1	0	1	-1
8018	904	1303	\N	3	1	0	1	-1
8019	904	1455	\N	3	1	0	1	-1
8020	904	1530	\N	3	1	0	1	-1
8021	991	527	\N	3	1	0	1	-1
8022	991	543	\N	3	1	0	1	-1
8023	991	885	\N	3	1	0	1	-1
8024	991	904	\N	3	1	0	1	-1
8025	991	1000	\N	3	1	0	1	-1
8026	991	1144	\N	3	1	0	1	-1
8027	991	1186	\N	3	1	0	1	-1
8028	991	1214	\N	3	1	0	1	-1
8029	991	1255	\N	3	1	0	1	-1
8030	991	1286	\N	3	1	0	1	-1
8031	991	1303	\N	3	1	0	1	-1
8032	991	1455	\N	3	1	0	1	-1
8033	991	1530	\N	3	1	0	1	-1
8034	1000	527	\N	3	1	0	1	-1
8035	1000	543	\N	3	1	0	1	-1
8036	1000	885	\N	3	1	0	1	-1
8037	1000	904	\N	3	1	0	1	-1
8038	1000	991	\N	3	1	0	1	-1
8039	1000	1144	\N	3	1	0	1	-1
8040	1000	1186	\N	3	1	0	1	-1
8041	1000	1214	\N	3	1	0	1	-1
8042	1000	1255	\N	3	1	0	1	-1
8043	1000	1286	\N	3	1	0	1	-1
8044	1000	1303	\N	3	1	0	1	-1
8045	1000	1455	\N	3	1	0	1	-1
8046	1000	1530	\N	3	1	0	1	-1
8047	1144	527	\N	3	1	0	1	-1
8048	1144	543	\N	3	1	0	1	-1
8049	1144	885	\N	3	1	0	1	-1
8050	1144	904	\N	3	1	0	1	-1
8051	1144	991	\N	3	1	0	1	-1
8052	1144	1000	\N	3	1	0	1	-1
8053	1144	1186	\N	3	1	0	1	-1
8054	1144	1214	\N	3	1	0	1	-1
8055	1144	1255	\N	3	1	0	1	-1
8056	1144	1286	\N	3	1	0	1	-1
8057	1144	1303	\N	3	1	0	1	-1
8058	1144	1455	\N	3	1	0	1	-1
8059	1144	1530	\N	3	1	0	1	-1
8060	1186	527	\N	3	1	0	1	-1
8061	1186	543	\N	3	1	0	1	-1
8062	1186	885	\N	3	1	0	1	-1
8063	1186	904	\N	3	1	0	1	-1
8064	1186	991	\N	3	1	0	1	-1
8065	1186	1000	\N	3	1	0	1	-1
8066	1186	1144	\N	3	1	0	1	-1
8067	1186	1214	\N	3	1	0	1	-1
8068	1186	1255	\N	3	1	0	1	-1
8069	1186	1286	\N	3	1	0	1	-1
8070	1186	1303	\N	3	1	0	1	-1
8071	1186	1455	\N	3	1	0	1	-1
8072	1186	1530	\N	3	1	0	1	-1
8073	1214	527	\N	3	1	0	1	-1
8074	1214	543	\N	3	1	0	1	-1
8075	1214	885	\N	3	1	0	1	-1
8076	1214	904	\N	3	1	0	1	-1
8077	1214	991	\N	3	1	0	1	-1
8078	1214	1000	\N	3	1	0	1	-1
8079	1214	1144	\N	3	1	0	1	-1
8080	1214	1186	\N	3	1	0	1	-1
8081	1214	1255	\N	3	1	0	1	-1
8082	1214	1286	\N	3	1	0	1	-1
8083	1214	1303	\N	3	1	0	1	-1
8084	1214	1455	\N	3	1	0	1	-1
8085	1214	1530	\N	3	1	0	1	-1
8086	1255	527	\N	3	1	0	1	-1
8087	1255	543	\N	3	1	0	1	-1
8088	1255	885	\N	3	1	0	1	-1
8089	1255	904	\N	3	1	0	1	-1
8090	1255	991	\N	3	1	0	1	-1
8091	1255	1000	\N	3	1	0	1	-1
8092	1255	1144	\N	3	1	0	1	-1
8093	1255	1186	\N	3	1	0	1	-1
8094	1255	1214	\N	3	1	0	1	-1
8095	1255	1286	\N	3	1	0	1	-1
8096	1255	1303	\N	3	1	0	1	-1
8097	1255	1455	\N	3	1	0	1	-1
8098	1255	1530	\N	3	1	0	1	-1
8099	1286	527	\N	3	1	0	1	-1
8100	1286	543	\N	3	1	0	1	-1
8101	1286	885	\N	3	1	0	1	-1
8102	1286	904	\N	3	1	0	1	-1
8103	1286	991	\N	3	1	0	1	-1
8104	1286	1000	\N	3	1	0	1	-1
8105	1286	1144	\N	3	1	0	1	-1
8106	1286	1186	\N	3	1	0	1	-1
8107	1286	1214	\N	3	1	0	1	-1
8108	1286	1255	\N	3	1	0	1	-1
8109	1286	1303	\N	3	1	0	1	-1
8110	1286	1455	\N	3	1	0	1	-1
8111	1286	1530	\N	3	1	0	1	-1
8112	1303	527	\N	3	1	0	1	-1
8113	1303	543	\N	3	1	0	1	-1
8114	1303	885	\N	3	1	0	1	-1
8115	1303	904	\N	3	1	0	1	-1
8116	1303	991	\N	3	1	0	1	-1
8117	1303	1000	\N	3	1	0	1	-1
8118	1303	1144	\N	3	1	0	1	-1
8119	1303	1186	\N	3	1	0	1	-1
8120	1303	1214	\N	3	1	0	1	-1
8121	1303	1255	\N	3	1	0	1	-1
8122	1303	1286	\N	3	1	0	1	-1
8123	1303	1455	\N	3	1	0	1	-1
8124	1303	1530	\N	3	1	0	1	-1
8125	1455	527	\N	3	1	0	1	-1
8126	1455	543	\N	3	1	0	1	-1
8127	1455	885	\N	3	1	0	1	-1
8128	1455	904	\N	3	1	0	1	-1
8129	1455	991	\N	3	1	0	1	-1
8130	1455	1000	\N	3	1	0	1	-1
8131	1455	1144	\N	3	1	0	1	-1
8132	1455	1186	\N	3	1	0	1	-1
8133	1455	1214	\N	3	1	0	1	-1
8134	1455	1255	\N	3	1	0	1	-1
8135	1455	1286	\N	3	1	0	1	-1
8136	1455	1303	\N	3	1	0	1	-1
8137	1455	1530	\N	3	1	0	1	-1
8138	1530	527	\N	3	1	0	1	-1
8139	1530	543	\N	3	1	0	1	-1
8140	1530	885	\N	3	1	0	1	-1
8141	1530	904	\N	3	1	0	1	-1
8142	1530	991	\N	3	1	0	1	-1
8143	1530	1000	\N	3	1	0	1	-1
8144	1530	1144	\N	3	1	0	1	-1
8145	1530	1186	\N	3	1	0	1	-1
8146	1530	1214	\N	3	1	0	1	-1
8147	1530	1255	\N	3	1	0	1	-1
8148	1530	1286	\N	3	1	0	1	-1
8149	1530	1303	\N	3	1	0	1	-1
8150	1530	1455	\N	3	1	0	1	-1
8151	528	542	\N	3	1	0	1	-1
8152	528	886	\N	3	1	0	1	-1
8153	528	903	\N	3	1	0	1	-1
8154	528	992	\N	3	1	0	1	-1
8155	528	999	\N	3	1	0	1	-1
8156	528	1145	\N	3	1	0	1	-1
8157	528	1185	\N	3	1	0	1	-1
8158	528	1215	\N	3	1	0	1	-1
8159	528	1254	\N	3	1	0	1	-1
8160	528	1287	\N	3	1	0	1	-1
8161	528	1302	\N	3	1	0	1	-1
8162	528	1456	\N	3	1	0	1	-1
8163	528	1529	\N	3	1	0	1	-1
8164	542	528	\N	3	1	0	1	-1
8165	542	886	\N	3	1	0	1	-1
8166	542	903	\N	3	1	0	1	-1
8167	542	992	\N	3	1	0	1	-1
8168	542	999	\N	3	1	0	1	-1
8169	542	1145	\N	3	1	0	1	-1
8170	542	1185	\N	3	1	0	1	-1
8171	542	1215	\N	3	1	0	1	-1
8172	542	1254	\N	3	1	0	1	-1
8173	542	1287	\N	3	1	0	1	-1
8174	542	1302	\N	3	1	0	1	-1
8175	542	1456	\N	3	1	0	1	-1
8176	542	1529	\N	3	1	0	1	-1
8177	886	528	\N	3	1	0	1	-1
8178	886	542	\N	3	1	0	1	-1
8179	886	903	\N	3	1	0	1	-1
8180	886	992	\N	3	1	0	1	-1
8181	886	999	\N	3	1	0	1	-1
8182	886	1145	\N	3	1	0	1	-1
8183	886	1185	\N	3	1	0	1	-1
8184	886	1215	\N	3	1	0	1	-1
8185	886	1254	\N	3	1	0	1	-1
8186	886	1287	\N	3	1	0	1	-1
8187	886	1302	\N	3	1	0	1	-1
8188	886	1456	\N	3	1	0	1	-1
8189	886	1529	\N	3	1	0	1	-1
8190	903	528	\N	3	1	0	1	-1
8191	903	542	\N	3	1	0	1	-1
8192	903	886	\N	3	1	0	1	-1
8193	903	992	\N	3	1	0	1	-1
8194	903	999	\N	3	1	0	1	-1
8195	903	1145	\N	3	1	0	1	-1
8196	903	1185	\N	3	1	0	1	-1
8197	903	1215	\N	3	1	0	1	-1
8198	903	1254	\N	3	1	0	1	-1
8199	903	1287	\N	3	1	0	1	-1
8200	903	1302	\N	3	1	0	1	-1
8201	903	1456	\N	3	1	0	1	-1
8202	903	1529	\N	3	1	0	1	-1
8203	992	528	\N	3	1	0	1	-1
8204	992	542	\N	3	1	0	1	-1
8205	992	886	\N	3	1	0	1	-1
8206	992	903	\N	3	1	0	1	-1
8207	992	999	\N	3	1	0	1	-1
8208	992	1145	\N	3	1	0	1	-1
8209	992	1185	\N	3	1	0	1	-1
8210	992	1215	\N	3	1	0	1	-1
8211	992	1254	\N	3	1	0	1	-1
8212	992	1287	\N	3	1	0	1	-1
8213	992	1302	\N	3	1	0	1	-1
8214	992	1456	\N	3	1	0	1	-1
8215	992	1529	\N	3	1	0	1	-1
8216	999	528	\N	3	1	0	1	-1
8217	999	542	\N	3	1	0	1	-1
8218	999	886	\N	3	1	0	1	-1
8219	999	903	\N	3	1	0	1	-1
8220	999	992	\N	3	1	0	1	-1
8221	999	1145	\N	3	1	0	1	-1
8222	999	1185	\N	3	1	0	1	-1
8223	999	1215	\N	3	1	0	1	-1
8224	999	1254	\N	3	1	0	1	-1
8225	999	1287	\N	3	1	0	1	-1
8226	999	1302	\N	3	1	0	1	-1
8227	999	1456	\N	3	1	0	1	-1
8228	999	1529	\N	3	1	0	1	-1
8229	1145	528	\N	3	1	0	1	-1
8230	1145	542	\N	3	1	0	1	-1
8231	1145	886	\N	3	1	0	1	-1
8232	1145	903	\N	3	1	0	1	-1
8233	1145	992	\N	3	1	0	1	-1
8234	1145	999	\N	3	1	0	1	-1
8235	1145	1185	\N	3	1	0	1	-1
8236	1145	1215	\N	3	1	0	1	-1
8237	1145	1254	\N	3	1	0	1	-1
8238	1145	1287	\N	3	1	0	1	-1
8239	1145	1302	\N	3	1	0	1	-1
8240	1145	1456	\N	3	1	0	1	-1
8241	1145	1529	\N	3	1	0	1	-1
8242	1185	528	\N	3	1	0	1	-1
8243	1185	542	\N	3	1	0	1	-1
8244	1185	886	\N	3	1	0	1	-1
8245	1185	903	\N	3	1	0	1	-1
8246	1185	992	\N	3	1	0	1	-1
8247	1185	999	\N	3	1	0	1	-1
8248	1185	1145	\N	3	1	0	1	-1
8249	1185	1215	\N	3	1	0	1	-1
8250	1185	1254	\N	3	1	0	1	-1
8251	1185	1287	\N	3	1	0	1	-1
8252	1185	1302	\N	3	1	0	1	-1
8253	1185	1456	\N	3	1	0	1	-1
8254	1185	1529	\N	3	1	0	1	-1
8255	1215	528	\N	3	1	0	1	-1
8256	1215	542	\N	3	1	0	1	-1
8257	1215	886	\N	3	1	0	1	-1
8258	1215	903	\N	3	1	0	1	-1
8259	1215	992	\N	3	1	0	1	-1
8260	1215	999	\N	3	1	0	1	-1
8261	1215	1145	\N	3	1	0	1	-1
8262	1215	1185	\N	3	1	0	1	-1
8263	1215	1254	\N	3	1	0	1	-1
8264	1215	1287	\N	3	1	0	1	-1
8265	1215	1302	\N	3	1	0	1	-1
8266	1215	1456	\N	3	1	0	1	-1
8267	1215	1529	\N	3	1	0	1	-1
8268	1254	528	\N	3	1	0	1	-1
8269	1254	542	\N	3	1	0	1	-1
8270	1254	886	\N	3	1	0	1	-1
8271	1254	903	\N	3	1	0	1	-1
8272	1254	992	\N	3	1	0	1	-1
8273	1254	999	\N	3	1	0	1	-1
8274	1254	1145	\N	3	1	0	1	-1
8275	1254	1185	\N	3	1	0	1	-1
8276	1254	1215	\N	3	1	0	1	-1
8277	1254	1287	\N	3	1	0	1	-1
8278	1254	1302	\N	3	1	0	1	-1
8279	1254	1456	\N	3	1	0	1	-1
8280	1254	1529	\N	3	1	0	1	-1
8281	1287	528	\N	3	1	0	1	-1
8282	1287	542	\N	3	1	0	1	-1
8283	1287	886	\N	3	1	0	1	-1
8284	1287	903	\N	3	1	0	1	-1
8285	1287	992	\N	3	1	0	1	-1
8286	1287	999	\N	3	1	0	1	-1
8287	1287	1145	\N	3	1	0	1	-1
8288	1287	1185	\N	3	1	0	1	-1
8289	1287	1215	\N	3	1	0	1	-1
8290	1287	1254	\N	3	1	0	1	-1
8291	1287	1302	\N	3	1	0	1	-1
8292	1287	1456	\N	3	1	0	1	-1
8293	1287	1529	\N	3	1	0	1	-1
8294	1302	528	\N	3	1	0	1	-1
8295	1302	542	\N	3	1	0	1	-1
8296	1302	886	\N	3	1	0	1	-1
8297	1302	903	\N	3	1	0	1	-1
8298	1302	992	\N	3	1	0	1	-1
8299	1302	999	\N	3	1	0	1	-1
8300	1302	1145	\N	3	1	0	1	-1
8301	1302	1185	\N	3	1	0	1	-1
8302	1302	1215	\N	3	1	0	1	-1
8303	1302	1254	\N	3	1	0	1	-1
8304	1302	1287	\N	3	1	0	1	-1
8305	1302	1456	\N	3	1	0	1	-1
8306	1302	1529	\N	3	1	0	1	-1
8307	1456	528	\N	3	1	0	1	-1
8308	1456	542	\N	3	1	0	1	-1
8309	1456	886	\N	3	1	0	1	-1
8310	1456	903	\N	3	1	0	1	-1
8311	1456	992	\N	3	1	0	1	-1
8312	1456	999	\N	3	1	0	1	-1
8313	1456	1145	\N	3	1	0	1	-1
8314	1456	1185	\N	3	1	0	1	-1
8315	1456	1215	\N	3	1	0	1	-1
8316	1456	1254	\N	3	1	0	1	-1
8317	1456	1287	\N	3	1	0	1	-1
8318	1456	1302	\N	3	1	0	1	-1
8319	1456	1529	\N	3	1	0	1	-1
8320	1529	528	\N	3	1	0	1	-1
8321	1529	542	\N	3	1	0	1	-1
8322	1529	886	\N	3	1	0	1	-1
8323	1529	903	\N	3	1	0	1	-1
8324	1529	992	\N	3	1	0	1	-1
8325	1529	999	\N	3	1	0	1	-1
8326	1529	1145	\N	3	1	0	1	-1
8327	1529	1185	\N	3	1	0	1	-1
8328	1529	1215	\N	3	1	0	1	-1
8329	1529	1254	\N	3	1	0	1	-1
8330	1529	1287	\N	3	1	0	1	-1
8331	1529	1302	\N	3	1	0	1	-1
8332	1529	1456	\N	3	1	0	1	-1
8333	529	541	\N	3	1	0	1	-1
8334	529	993	\N	3	1	0	1	-1
8335	529	998	\N	3	1	0	1	-1
8336	529	1146	\N	3	1	0	1	-1
8337	529	1184	\N	3	1	0	1	-1
8338	529	1216	\N	3	1	0	1	-1
8339	529	1253	\N	3	1	0	1	-1
8340	529	1288	\N	3	1	0	1	-1
8341	529	1301	\N	3	1	0	1	-1
8342	529	1457	\N	3	1	0	1	-1
8343	529	1528	\N	3	1	0	1	-1
8344	541	529	\N	3	1	0	1	-1
8345	541	993	\N	3	1	0	1	-1
8346	541	998	\N	3	1	0	1	-1
8347	541	1146	\N	3	1	0	1	-1
8348	541	1184	\N	3	1	0	1	-1
8349	541	1216	\N	3	1	0	1	-1
8350	541	1253	\N	3	1	0	1	-1
8351	541	1288	\N	3	1	0	1	-1
8352	541	1301	\N	3	1	0	1	-1
8353	541	1457	\N	3	1	0	1	-1
8354	541	1528	\N	3	1	0	1	-1
8355	993	529	\N	3	1	0	1	-1
8356	993	541	\N	3	1	0	1	-1
8357	993	998	\N	3	1	0	1	-1
8358	993	1146	\N	3	1	0	1	-1
8359	993	1184	\N	3	1	0	1	-1
8360	993	1216	\N	3	1	0	1	-1
8361	993	1253	\N	3	1	0	1	-1
8362	993	1288	\N	3	1	0	1	-1
8363	993	1301	\N	3	1	0	1	-1
8364	993	1457	\N	3	1	0	1	-1
8365	993	1528	\N	3	1	0	1	-1
8366	998	529	\N	3	1	0	1	-1
8367	998	541	\N	3	1	0	1	-1
8368	998	993	\N	3	1	0	1	-1
8369	998	1146	\N	3	1	0	1	-1
8370	998	1184	\N	3	1	0	1	-1
8371	998	1216	\N	3	1	0	1	-1
8372	998	1253	\N	3	1	0	1	-1
8373	998	1288	\N	3	1	0	1	-1
8374	998	1301	\N	3	1	0	1	-1
8375	998	1457	\N	3	1	0	1	-1
8376	998	1528	\N	3	1	0	1	-1
8377	1146	529	\N	3	1	0	1	-1
8378	1146	541	\N	3	1	0	1	-1
8379	1146	993	\N	3	1	0	1	-1
8380	1146	998	\N	3	1	0	1	-1
8381	1146	1184	\N	3	1	0	1	-1
8382	1146	1216	\N	3	1	0	1	-1
8383	1146	1253	\N	3	1	0	1	-1
8384	1146	1288	\N	3	1	0	1	-1
8385	1146	1301	\N	3	1	0	1	-1
8386	1146	1457	\N	3	1	0	1	-1
8387	1146	1528	\N	3	1	0	1	-1
8388	1184	529	\N	3	1	0	1	-1
8389	1184	541	\N	3	1	0	1	-1
8390	1184	993	\N	3	1	0	1	-1
8391	1184	998	\N	3	1	0	1	-1
8392	1184	1146	\N	3	1	0	1	-1
8393	1184	1216	\N	3	1	0	1	-1
8394	1184	1253	\N	3	1	0	1	-1
8395	1184	1288	\N	3	1	0	1	-1
8396	1184	1301	\N	3	1	0	1	-1
8397	1184	1457	\N	3	1	0	1	-1
8398	1184	1528	\N	3	1	0	1	-1
8399	1216	529	\N	3	1	0	1	-1
8400	1216	541	\N	3	1	0	1	-1
8401	1216	993	\N	3	1	0	1	-1
8402	1216	998	\N	3	1	0	1	-1
8403	1216	1146	\N	3	1	0	1	-1
8404	1216	1184	\N	3	1	0	1	-1
8405	1216	1253	\N	3	1	0	1	-1
8406	1216	1288	\N	3	1	0	1	-1
8407	1216	1301	\N	3	1	0	1	-1
8408	1216	1457	\N	3	1	0	1	-1
8409	1216	1528	\N	3	1	0	1	-1
8410	1253	529	\N	3	1	0	1	-1
8411	1253	541	\N	3	1	0	1	-1
8412	1253	993	\N	3	1	0	1	-1
8413	1253	998	\N	3	1	0	1	-1
8414	1253	1146	\N	3	1	0	1	-1
8415	1253	1184	\N	3	1	0	1	-1
8416	1253	1216	\N	3	1	0	1	-1
8417	1253	1288	\N	3	1	0	1	-1
8418	1253	1301	\N	3	1	0	1	-1
8419	1253	1457	\N	3	1	0	1	-1
8420	1253	1528	\N	3	1	0	1	-1
8421	1288	529	\N	3	1	0	1	-1
8422	1288	541	\N	3	1	0	1	-1
8423	1288	993	\N	3	1	0	1	-1
8424	1288	998	\N	3	1	0	1	-1
8425	1288	1146	\N	3	1	0	1	-1
8426	1288	1184	\N	3	1	0	1	-1
8427	1288	1216	\N	3	1	0	1	-1
8428	1288	1253	\N	3	1	0	1	-1
8429	1288	1301	\N	3	1	0	1	-1
8430	1288	1457	\N	3	1	0	1	-1
8431	1288	1528	\N	3	1	0	1	-1
8432	1301	529	\N	3	1	0	1	-1
8433	1301	541	\N	3	1	0	1	-1
8434	1301	993	\N	3	1	0	1	-1
8435	1301	998	\N	3	1	0	1	-1
8436	1301	1146	\N	3	1	0	1	-1
8437	1301	1184	\N	3	1	0	1	-1
8438	1301	1216	\N	3	1	0	1	-1
8439	1301	1253	\N	3	1	0	1	-1
8440	1301	1288	\N	3	1	0	1	-1
8441	1301	1457	\N	3	1	0	1	-1
8442	1301	1528	\N	3	1	0	1	-1
8443	1457	529	\N	3	1	0	1	-1
8444	1457	541	\N	3	1	0	1	-1
8445	1457	993	\N	3	1	0	1	-1
8446	1457	998	\N	3	1	0	1	-1
8447	1457	1146	\N	3	1	0	1	-1
8448	1457	1184	\N	3	1	0	1	-1
8449	1457	1216	\N	3	1	0	1	-1
8450	1457	1253	\N	3	1	0	1	-1
8451	1457	1288	\N	3	1	0	1	-1
8452	1457	1301	\N	3	1	0	1	-1
8453	1457	1528	\N	3	1	0	1	-1
8454	1528	529	\N	3	1	0	1	-1
8455	1528	541	\N	3	1	0	1	-1
8456	1528	993	\N	3	1	0	1	-1
8457	1528	998	\N	3	1	0	1	-1
8458	1528	1146	\N	3	1	0	1	-1
8459	1528	1184	\N	3	1	0	1	-1
8460	1528	1216	\N	3	1	0	1	-1
8461	1528	1253	\N	3	1	0	1	-1
8462	1528	1288	\N	3	1	0	1	-1
8463	1528	1301	\N	3	1	0	1	-1
8464	1528	1457	\N	3	1	0	1	-1
8465	530	540	\N	3	1	0	1	-1
8466	530	994	\N	3	1	0	1	-1
8467	530	997	\N	3	1	0	1	-1
8468	530	1147	\N	3	1	0	1	-1
8469	530	1183	\N	3	1	0	1	-1
8470	530	1217	\N	3	1	0	1	-1
8471	530	1252	\N	3	1	0	1	-1
8472	530	1289	\N	3	1	0	1	-1
8473	530	1300	\N	3	1	0	1	-1
8474	530	1458	\N	3	1	0	1	-1
8475	530	1527	\N	3	1	0	1	-1
8476	540	530	\N	3	1	0	1	-1
8477	540	994	\N	3	1	0	1	-1
8478	540	997	\N	3	1	0	1	-1
8479	540	1147	\N	3	1	0	1	-1
8480	540	1183	\N	3	1	0	1	-1
8481	540	1217	\N	3	1	0	1	-1
8482	540	1252	\N	3	1	0	1	-1
8483	540	1289	\N	3	1	0	1	-1
8484	540	1300	\N	3	1	0	1	-1
8485	540	1458	\N	3	1	0	1	-1
8486	540	1527	\N	3	1	0	1	-1
8487	994	530	\N	3	1	0	1	-1
8488	994	540	\N	3	1	0	1	-1
8489	994	997	\N	3	1	0	1	-1
8490	994	1147	\N	3	1	0	1	-1
8491	994	1183	\N	3	1	0	1	-1
8492	994	1217	\N	3	1	0	1	-1
8493	994	1252	\N	3	1	0	1	-1
8494	994	1289	\N	3	1	0	1	-1
8495	994	1300	\N	3	1	0	1	-1
8496	994	1458	\N	3	1	0	1	-1
8497	994	1527	\N	3	1	0	1	-1
8498	997	530	\N	3	1	0	1	-1
8499	997	540	\N	3	1	0	1	-1
8500	997	994	\N	3	1	0	1	-1
8501	997	1147	\N	3	1	0	1	-1
8502	997	1183	\N	3	1	0	1	-1
8503	997	1217	\N	3	1	0	1	-1
8504	997	1252	\N	3	1	0	1	-1
8505	997	1289	\N	3	1	0	1	-1
8506	997	1300	\N	3	1	0	1	-1
8507	997	1458	\N	3	1	0	1	-1
8508	997	1527	\N	3	1	0	1	-1
8509	1147	530	\N	3	1	0	1	-1
8510	1147	540	\N	3	1	0	1	-1
8511	1147	994	\N	3	1	0	1	-1
8512	1147	997	\N	3	1	0	1	-1
8513	1147	1183	\N	3	1	0	1	-1
8514	1147	1217	\N	3	1	0	1	-1
8515	1147	1252	\N	3	1	0	1	-1
8516	1147	1289	\N	3	1	0	1	-1
8517	1147	1300	\N	3	1	0	1	-1
8518	1147	1458	\N	3	1	0	1	-1
8519	1147	1527	\N	3	1	0	1	-1
8520	1183	530	\N	3	1	0	1	-1
8521	1183	540	\N	3	1	0	1	-1
8522	1183	994	\N	3	1	0	1	-1
8523	1183	997	\N	3	1	0	1	-1
8524	1183	1147	\N	3	1	0	1	-1
8525	1183	1217	\N	3	1	0	1	-1
8526	1183	1252	\N	3	1	0	1	-1
8527	1183	1289	\N	3	1	0	1	-1
8528	1183	1300	\N	3	1	0	1	-1
8529	1183	1458	\N	3	1	0	1	-1
8530	1183	1527	\N	3	1	0	1	-1
8531	1217	530	\N	3	1	0	1	-1
8532	1217	540	\N	3	1	0	1	-1
8533	1217	994	\N	3	1	0	1	-1
8534	1217	997	\N	3	1	0	1	-1
8535	1217	1147	\N	3	1	0	1	-1
8536	1217	1183	\N	3	1	0	1	-1
8537	1217	1252	\N	3	1	0	1	-1
8538	1217	1289	\N	3	1	0	1	-1
8539	1217	1300	\N	3	1	0	1	-1
8540	1217	1458	\N	3	1	0	1	-1
8541	1217	1527	\N	3	1	0	1	-1
8542	1252	530	\N	3	1	0	1	-1
8543	1252	540	\N	3	1	0	1	-1
8544	1252	994	\N	3	1	0	1	-1
8545	1252	997	\N	3	1	0	1	-1
8546	1252	1147	\N	3	1	0	1	-1
8547	1252	1183	\N	3	1	0	1	-1
8548	1252	1217	\N	3	1	0	1	-1
8549	1252	1289	\N	3	1	0	1	-1
8550	1252	1300	\N	3	1	0	1	-1
8551	1252	1458	\N	3	1	0	1	-1
8552	1252	1527	\N	3	1	0	1	-1
8553	1289	530	\N	3	1	0	1	-1
8554	1289	540	\N	3	1	0	1	-1
8555	1289	994	\N	3	1	0	1	-1
8556	1289	997	\N	3	1	0	1	-1
8557	1289	1147	\N	3	1	0	1	-1
8558	1289	1183	\N	3	1	0	1	-1
8559	1289	1217	\N	3	1	0	1	-1
8560	1289	1252	\N	3	1	0	1	-1
8561	1289	1300	\N	3	1	0	1	-1
8562	1289	1458	\N	3	1	0	1	-1
8563	1289	1527	\N	3	1	0	1	-1
8564	1300	530	\N	3	1	0	1	-1
8565	1300	540	\N	3	1	0	1	-1
8566	1300	994	\N	3	1	0	1	-1
8567	1300	997	\N	3	1	0	1	-1
8568	1300	1147	\N	3	1	0	1	-1
8569	1300	1183	\N	3	1	0	1	-1
8570	1300	1217	\N	3	1	0	1	-1
8571	1300	1252	\N	3	1	0	1	-1
8572	1300	1289	\N	3	1	0	1	-1
8573	1300	1458	\N	3	1	0	1	-1
8574	1300	1527	\N	3	1	0	1	-1
8575	1458	530	\N	3	1	0	1	-1
8576	1458	540	\N	3	1	0	1	-1
8577	1458	994	\N	3	1	0	1	-1
8578	1458	997	\N	3	1	0	1	-1
8579	1458	1147	\N	3	1	0	1	-1
8580	1458	1183	\N	3	1	0	1	-1
8581	1458	1217	\N	3	1	0	1	-1
8582	1458	1252	\N	3	1	0	1	-1
8583	1458	1289	\N	3	1	0	1	-1
8584	1458	1300	\N	3	1	0	1	-1
8585	1458	1527	\N	3	1	0	1	-1
8586	1527	530	\N	3	1	0	1	-1
8587	1527	540	\N	3	1	0	1	-1
8588	1527	994	\N	3	1	0	1	-1
8589	1527	997	\N	3	1	0	1	-1
8590	1527	1147	\N	3	1	0	1	-1
8591	1527	1183	\N	3	1	0	1	-1
8592	1527	1217	\N	3	1	0	1	-1
8593	1527	1252	\N	3	1	0	1	-1
8594	1527	1289	\N	3	1	0	1	-1
8595	1527	1300	\N	3	1	0	1	-1
8596	1527	1458	\N	3	1	0	1	-1
8597	531	995	\N	3	1	0	1	-1
8598	531	1148	\N	3	1	0	1	-1
8599	531	1218	\N	3	1	0	1	-1
8600	531	1290	\N	3	1	0	1	-1
8601	531	1459	\N	3	1	0	1	-1
8602	995	531	\N	3	1	0	1	-1
8603	995	1148	\N	3	1	0	1	-1
8604	995	1218	\N	3	1	0	1	-1
8605	995	1290	\N	3	1	0	1	-1
8606	995	1459	\N	3	1	0	1	-1
8607	1148	531	\N	3	1	0	1	-1
8608	1148	995	\N	3	1	0	1	-1
8609	1148	1218	\N	3	1	0	1	-1
8610	1148	1290	\N	3	1	0	1	-1
8611	1148	1459	\N	3	1	0	1	-1
8612	1218	531	\N	3	1	0	1	-1
8613	1218	995	\N	3	1	0	1	-1
8614	1218	1148	\N	3	1	0	1	-1
8615	1218	1290	\N	3	1	0	1	-1
8616	1218	1459	\N	3	1	0	1	-1
8617	1290	531	\N	3	1	0	1	-1
8618	1290	995	\N	3	1	0	1	-1
8619	1290	1148	\N	3	1	0	1	-1
8620	1290	1218	\N	3	1	0	1	-1
8621	1290	1459	\N	3	1	0	1	-1
8622	1459	531	\N	3	1	0	1	-1
8623	1459	995	\N	3	1	0	1	-1
8624	1459	1148	\N	3	1	0	1	-1
8625	1459	1218	\N	3	1	0	1	-1
8626	1459	1290	\N	3	1	0	1	-1
8627	532	996	\N	3	1	0	1	-1
8628	532	1149	\N	3	1	0	1	-1
8629	532	1182	\N	3	1	0	1	-1
8630	532	1219	\N	3	1	0	1	-1
8631	532	1291	\N	3	1	0	1	-1
8632	532	1407	\N	3	1	0	1	-1
8633	532	1430	\N	3	1	0	1	-1
8634	532	1460	\N	3	1	0	1	-1
8635	996	532	\N	3	1	0	1	-1
8636	996	1149	\N	3	1	0	1	-1
8637	996	1182	\N	3	1	0	1	-1
8638	996	1219	\N	3	1	0	1	-1
8639	996	1291	\N	3	1	0	1	-1
8640	996	1407	\N	3	1	0	1	-1
8641	996	1430	\N	3	1	0	1	-1
8642	996	1460	\N	3	1	0	1	-1
8643	1149	532	\N	3	1	0	1	-1
8644	1149	996	\N	3	1	0	1	-1
8645	1149	1182	\N	3	1	0	1	-1
8646	1149	1219	\N	3	1	0	1	-1
8647	1149	1291	\N	3	1	0	1	-1
8648	1149	1407	\N	3	1	0	1	-1
8649	1149	1430	\N	3	1	0	1	-1
8650	1149	1460	\N	3	1	0	1	-1
8651	1182	532	\N	3	1	0	1	-1
8652	1182	996	\N	3	1	0	1	-1
8653	1182	1149	\N	3	1	0	1	-1
8654	1182	1219	\N	3	1	0	1	-1
8655	1182	1291	\N	3	1	0	1	-1
8656	1182	1407	\N	3	1	0	1	-1
8657	1182	1430	\N	3	1	0	1	-1
8658	1182	1460	\N	3	1	0	1	-1
8659	1219	532	\N	3	1	0	1	-1
8660	1219	996	\N	3	1	0	1	-1
8661	1219	1149	\N	3	1	0	1	-1
8662	1219	1182	\N	3	1	0	1	-1
8663	1219	1291	\N	3	1	0	1	-1
8664	1219	1407	\N	3	1	0	1	-1
8665	1219	1430	\N	3	1	0	1	-1
8666	1219	1460	\N	3	1	0	1	-1
8667	1291	532	\N	3	1	0	1	-1
8668	1291	996	\N	3	1	0	1	-1
8669	1291	1149	\N	3	1	0	1	-1
8670	1291	1182	\N	3	1	0	1	-1
8671	1291	1219	\N	3	1	0	1	-1
8672	1291	1407	\N	3	1	0	1	-1
8673	1291	1430	\N	3	1	0	1	-1
8674	1291	1460	\N	3	1	0	1	-1
8675	1407	532	\N	3	1	0	1	-1
8676	1407	996	\N	3	1	0	1	-1
8677	1407	1149	\N	3	1	0	1	-1
8678	1407	1182	\N	3	1	0	1	-1
8679	1407	1219	\N	3	1	0	1	-1
8680	1407	1291	\N	3	1	0	1	-1
8681	1407	1430	\N	3	1	0	1	-1
8682	1407	1460	\N	3	1	0	1	-1
8683	1430	532	\N	3	1	0	1	-1
8684	1430	996	\N	3	1	0	1	-1
8685	1430	1149	\N	3	1	0	1	-1
8686	1430	1182	\N	3	1	0	1	-1
8687	1430	1219	\N	3	1	0	1	-1
8688	1430	1291	\N	3	1	0	1	-1
8689	1430	1407	\N	3	1	0	1	-1
8690	1430	1460	\N	3	1	0	1	-1
8691	1460	532	\N	3	1	0	1	-1
8692	1460	996	\N	3	1	0	1	-1
8693	1460	1149	\N	3	1	0	1	-1
8694	1460	1182	\N	3	1	0	1	-1
8695	1460	1219	\N	3	1	0	1	-1
8696	1460	1291	\N	3	1	0	1	-1
8697	1460	1407	\N	3	1	0	1	-1
8698	1460	1430	\N	3	1	0	1	-1
8699	533	947	\N	3	1	0	1	-1
8700	533	1220	\N	3	1	0	1	-1
8701	533	1292	\N	3	1	0	1	-1
8702	533	1461	\N	3	1	0	1	-1
8703	947	533	\N	3	1	0	1	-1
8704	947	1220	\N	3	1	0	1	-1
8705	947	1292	\N	3	1	0	1	-1
8706	947	1461	\N	3	1	0	1	-1
8707	1220	533	\N	3	1	0	1	-1
8708	1220	947	\N	3	1	0	1	-1
8709	1220	1292	\N	3	1	0	1	-1
8710	1220	1461	\N	3	1	0	1	-1
8711	1292	533	\N	3	1	0	1	-1
8712	1292	947	\N	3	1	0	1	-1
8713	1292	1220	\N	3	1	0	1	-1
8714	1292	1461	\N	3	1	0	1	-1
8715	1461	533	\N	3	1	0	1	-1
8716	1461	947	\N	3	1	0	1	-1
8717	1461	1220	\N	3	1	0	1	-1
8718	1461	1292	\N	3	1	0	1	-1
8719	534	536	\N	3	1	0	1	-1
8720	534	948	\N	3	1	0	1	-1
8721	534	1042	\N	3	1	0	1	-1
8722	534	1221	\N	3	1	0	1	-1
8723	534	1248	\N	3	1	0	1	-1
8724	534	1293	\N	3	1	0	1	-1
8725	534	1296	\N	3	1	0	1	-1
8726	534	1404	\N	3	1	0	1	-1
8727	534	1433	\N	3	1	0	1	-1
8728	534	1462	\N	3	1	0	1	-1
8729	534	1523	\N	3	1	0	1	-1
8730	536	534	\N	3	1	0	1	-1
8731	536	948	\N	3	1	0	1	-1
8732	536	1042	\N	3	1	0	1	-1
8733	536	1221	\N	3	1	0	1	-1
8734	536	1248	\N	3	1	0	1	-1
8735	536	1293	\N	3	1	0	1	-1
8736	536	1296	\N	3	1	0	1	-1
8737	536	1404	\N	3	1	0	1	-1
8738	536	1433	\N	3	1	0	1	-1
8739	536	1462	\N	3	1	0	1	-1
8740	536	1523	\N	3	1	0	1	-1
8741	948	534	\N	3	1	0	1	-1
8742	948	536	\N	3	1	0	1	-1
8743	948	1042	\N	3	1	0	1	-1
8744	948	1221	\N	3	1	0	1	-1
8745	948	1248	\N	3	1	0	1	-1
8746	948	1293	\N	3	1	0	1	-1
8747	948	1296	\N	3	1	0	1	-1
8748	948	1404	\N	3	1	0	1	-1
8749	948	1433	\N	3	1	0	1	-1
8750	948	1462	\N	3	1	0	1	-1
8751	948	1523	\N	3	1	0	1	-1
8752	1042	534	\N	3	1	0	1	-1
8753	1042	536	\N	3	1	0	1	-1
8754	1042	948	\N	3	1	0	1	-1
8755	1042	1221	\N	3	1	0	1	-1
8756	1042	1248	\N	3	1	0	1	-1
8757	1042	1293	\N	3	1	0	1	-1
8758	1042	1296	\N	3	1	0	1	-1
8759	1042	1404	\N	3	1	0	1	-1
8760	1042	1433	\N	3	1	0	1	-1
8761	1042	1462	\N	3	1	0	1	-1
8762	1042	1523	\N	3	1	0	1	-1
8763	1221	534	\N	3	1	0	1	-1
8764	1221	536	\N	3	1	0	1	-1
8765	1221	948	\N	3	1	0	1	-1
8766	1221	1042	\N	3	1	0	1	-1
8767	1221	1248	\N	3	1	0	1	-1
8768	1221	1293	\N	3	1	0	1	-1
8769	1221	1296	\N	3	1	0	1	-1
8770	1221	1404	\N	3	1	0	1	-1
8771	1221	1433	\N	3	1	0	1	-1
8772	1221	1462	\N	3	1	0	1	-1
8773	1221	1523	\N	3	1	0	1	-1
8774	1248	534	\N	3	1	0	1	-1
8775	1248	536	\N	3	1	0	1	-1
8776	1248	948	\N	3	1	0	1	-1
8777	1248	1042	\N	3	1	0	1	-1
8778	1248	1221	\N	3	1	0	1	-1
8779	1248	1293	\N	3	1	0	1	-1
8780	1248	1296	\N	3	1	0	1	-1
8781	1248	1404	\N	3	1	0	1	-1
8782	1248	1433	\N	3	1	0	1	-1
8783	1248	1462	\N	3	1	0	1	-1
8784	1248	1523	\N	3	1	0	1	-1
8785	1293	534	\N	3	1	0	1	-1
8786	1293	536	\N	3	1	0	1	-1
8787	1293	948	\N	3	1	0	1	-1
8788	1293	1042	\N	3	1	0	1	-1
8789	1293	1221	\N	3	1	0	1	-1
8790	1293	1248	\N	3	1	0	1	-1
8791	1293	1296	\N	3	1	0	1	-1
8792	1293	1404	\N	3	1	0	1	-1
8793	1293	1433	\N	3	1	0	1	-1
8794	1293	1462	\N	3	1	0	1	-1
8795	1293	1523	\N	3	1	0	1	-1
8796	1296	534	\N	3	1	0	1	-1
8797	1296	536	\N	3	1	0	1	-1
8798	1296	948	\N	3	1	0	1	-1
8799	1296	1042	\N	3	1	0	1	-1
8800	1296	1221	\N	3	1	0	1	-1
8801	1296	1248	\N	3	1	0	1	-1
8802	1296	1293	\N	3	1	0	1	-1
8803	1296	1404	\N	3	1	0	1	-1
8804	1296	1433	\N	3	1	0	1	-1
8805	1296	1462	\N	3	1	0	1	-1
8806	1296	1523	\N	3	1	0	1	-1
8807	1404	534	\N	3	1	0	1	-1
8808	1404	536	\N	3	1	0	1	-1
8809	1404	948	\N	3	1	0	1	-1
8810	1404	1042	\N	3	1	0	1	-1
8811	1404	1221	\N	3	1	0	1	-1
8812	1404	1248	\N	3	1	0	1	-1
8813	1404	1293	\N	3	1	0	1	-1
8814	1404	1296	\N	3	1	0	1	-1
8815	1404	1433	\N	3	1	0	1	-1
8816	1404	1462	\N	3	1	0	1	-1
8817	1404	1523	\N	3	1	0	1	-1
8818	1433	534	\N	3	1	0	1	-1
8819	1433	536	\N	3	1	0	1	-1
8820	1433	948	\N	3	1	0	1	-1
8821	1433	1042	\N	3	1	0	1	-1
8822	1433	1221	\N	3	1	0	1	-1
8823	1433	1248	\N	3	1	0	1	-1
8824	1433	1293	\N	3	1	0	1	-1
8825	1433	1296	\N	3	1	0	1	-1
8826	1433	1404	\N	3	1	0	1	-1
8827	1433	1462	\N	3	1	0	1	-1
8828	1433	1523	\N	3	1	0	1	-1
8829	1462	534	\N	3	1	0	1	-1
8830	1462	536	\N	3	1	0	1	-1
8831	1462	948	\N	3	1	0	1	-1
8832	1462	1042	\N	3	1	0	1	-1
8833	1462	1221	\N	3	1	0	1	-1
8834	1462	1248	\N	3	1	0	1	-1
8835	1462	1293	\N	3	1	0	1	-1
8836	1462	1296	\N	3	1	0	1	-1
8837	1462	1404	\N	3	1	0	1	-1
8838	1462	1433	\N	3	1	0	1	-1
8839	1462	1523	\N	3	1	0	1	-1
8840	1523	534	\N	3	1	0	1	-1
8841	1523	536	\N	3	1	0	1	-1
8842	1523	948	\N	3	1	0	1	-1
8843	1523	1042	\N	3	1	0	1	-1
8844	1523	1221	\N	3	1	0	1	-1
8845	1523	1248	\N	3	1	0	1	-1
8846	1523	1293	\N	3	1	0	1	-1
8847	1523	1296	\N	3	1	0	1	-1
8848	1523	1404	\N	3	1	0	1	-1
8849	1523	1433	\N	3	1	0	1	-1
8850	1523	1462	\N	3	1	0	1	-1
8851	544	768	\N	3	1	0	1	-1
8852	544	800	\N	3	1	0	1	-1
8853	544	905	\N	3	1	0	1	-1
8854	544	1001	\N	3	1	0	1	-1
8855	544	1102	\N	3	1	0	1	-1
8856	544	1187	\N	3	1	0	1	-1
8857	544	1333	\N	3	1	0	1	-1
8858	544	1531	\N	3	1	0	1	-1
8859	768	544	\N	3	1	0	1	-1
8860	768	800	\N	3	1	0	1	-1
8861	768	905	\N	3	1	0	1	-1
8862	768	1001	\N	3	1	0	1	-1
8863	768	1102	\N	3	1	0	1	-1
8864	768	1187	\N	3	1	0	1	-1
8865	768	1333	\N	3	1	0	1	-1
8866	768	1531	\N	3	1	0	1	-1
8867	800	544	\N	3	1	0	1	-1
8868	800	768	\N	3	1	0	1	-1
8869	800	905	\N	3	1	0	1	-1
8870	800	1001	\N	3	1	0	1	-1
8871	800	1102	\N	3	1	0	1	-1
8872	800	1187	\N	3	1	0	1	-1
8873	800	1333	\N	3	1	0	1	-1
8874	800	1531	\N	3	1	0	1	-1
8875	905	544	\N	3	1	0	1	-1
8876	905	768	\N	3	1	0	1	-1
8877	905	800	\N	3	1	0	1	-1
8878	905	1001	\N	3	1	0	1	-1
8879	905	1102	\N	3	1	0	1	-1
8880	905	1187	\N	3	1	0	1	-1
8881	905	1333	\N	3	1	0	1	-1
8882	905	1531	\N	3	1	0	1	-1
8883	1001	544	\N	3	1	0	1	-1
8884	1001	768	\N	3	1	0	1	-1
8885	1001	800	\N	3	1	0	1	-1
8886	1001	905	\N	3	1	0	1	-1
8887	1001	1102	\N	3	1	0	1	-1
8888	1001	1187	\N	3	1	0	1	-1
8889	1001	1333	\N	3	1	0	1	-1
8890	1001	1531	\N	3	1	0	1	-1
8891	1102	544	\N	3	1	0	1	-1
8892	1102	768	\N	3	1	0	1	-1
8893	1102	800	\N	3	1	0	1	-1
8894	1102	905	\N	3	1	0	1	-1
8895	1102	1001	\N	3	1	0	1	-1
8896	1102	1187	\N	3	1	0	1	-1
8897	1102	1333	\N	3	1	0	1	-1
8898	1102	1531	\N	3	1	0	1	-1
8899	1187	544	\N	3	1	0	1	-1
8900	1187	768	\N	3	1	0	1	-1
8901	1187	800	\N	3	1	0	1	-1
8902	1187	905	\N	3	1	0	1	-1
8903	1187	1001	\N	3	1	0	1	-1
8904	1187	1102	\N	3	1	0	1	-1
8905	1187	1333	\N	3	1	0	1	-1
8906	1187	1531	\N	3	1	0	1	-1
8907	1333	544	\N	3	1	0	1	-1
8908	1333	768	\N	3	1	0	1	-1
8909	1333	800	\N	3	1	0	1	-1
8910	1333	905	\N	3	1	0	1	-1
8911	1333	1001	\N	3	1	0	1	-1
8912	1333	1102	\N	3	1	0	1	-1
8913	1333	1187	\N	3	1	0	1	-1
8914	1333	1531	\N	3	1	0	1	-1
8915	1531	544	\N	3	1	0	1	-1
8916	1531	768	\N	3	1	0	1	-1
8917	1531	800	\N	3	1	0	1	-1
8918	1531	905	\N	3	1	0	1	-1
8919	1531	1001	\N	3	1	0	1	-1
8920	1531	1102	\N	3	1	0	1	-1
8921	1531	1187	\N	3	1	0	1	-1
8922	1531	1333	\N	3	1	0	1	-1
8923	545	769	\N	3	1	0	1	-1
8924	545	801	\N	3	1	0	1	-1
8925	545	906	\N	3	1	0	1	-1
8926	769	545	\N	3	1	0	1	-1
8927	769	801	\N	3	1	0	1	-1
8928	769	906	\N	3	1	0	1	-1
8929	801	545	\N	3	1	0	1	-1
8930	801	769	\N	3	1	0	1	-1
8931	801	906	\N	3	1	0	1	-1
8932	906	545	\N	3	1	0	1	-1
8933	906	769	\N	3	1	0	1	-1
8934	906	801	\N	3	1	0	1	-1
8935	560	590	\N	3	1	0	1	-1
8936	590	560	\N	3	1	0	1	-1
8937	562	592	\N	3	1	0	1	-1
8938	592	562	\N	3	1	0	1	-1
8939	563	593	\N	3	1	0	1	-1
8940	593	563	\N	3	1	0	1	-1
8941	564	594	\N	3	1	0	1	-1
8942	594	564	\N	3	1	0	1	-1
8943	565	595	\N	3	1	0	1	-1
8944	595	565	\N	3	1	0	1	-1
8945	566	596	\N	3	1	0	1	-1
8946	596	566	\N	3	1	0	1	-1
8947	567	597	\N	3	1	0	1	-1
8948	597	567	\N	3	1	0	1	-1
8949	568	598	\N	3	1	0	1	-1
8950	598	568	\N	3	1	0	1	-1
8951	569	580	\N	3	1	0	1	-1
8952	569	599	\N	3	1	0	1	-1
8953	569	626	\N	3	1	0	1	-1
8954	580	569	\N	3	1	0	1	-1
8955	580	599	\N	3	1	0	1	-1
8956	580	626	\N	3	1	0	1	-1
8957	599	569	\N	3	1	0	1	-1
8958	599	580	\N	3	1	0	1	-1
8959	599	626	\N	3	1	0	1	-1
8960	626	569	\N	3	1	0	1	-1
8961	626	580	\N	3	1	0	1	-1
8962	626	599	\N	3	1	0	1	-1
8963	570	579	\N	3	1	0	1	-1
8964	570	600	\N	3	1	0	1	-1
8965	570	625	\N	3	1	0	1	-1
8966	579	570	\N	3	1	0	1	-1
8967	579	600	\N	3	1	0	1	-1
8968	579	625	\N	3	1	0	1	-1
8969	600	570	\N	3	1	0	1	-1
8970	600	579	\N	3	1	0	1	-1
8971	600	625	\N	3	1	0	1	-1
8972	625	570	\N	3	1	0	1	-1
8973	625	579	\N	3	1	0	1	-1
8974	625	600	\N	3	1	0	1	-1
8975	571	578	\N	3	1	0	1	-1
8976	571	601	\N	3	1	0	1	-1
8977	571	624	\N	3	1	0	1	-1
8978	578	571	\N	3	1	0	1	-1
8979	578	601	\N	3	1	0	1	-1
8980	578	624	\N	3	1	0	1	-1
8981	601	571	\N	3	1	0	1	-1
8982	601	578	\N	3	1	0	1	-1
8983	601	624	\N	3	1	0	1	-1
8984	624	571	\N	3	1	0	1	-1
8985	624	578	\N	3	1	0	1	-1
8986	624	601	\N	3	1	0	1	-1
8987	572	577	\N	3	1	0	1	-1
8988	577	572	\N	3	1	0	1	-1
8989	573	576	\N	3	1	0	1	-1
8990	576	573	\N	3	1	0	1	-1
8991	574	575	\N	3	1	0	1	-1
8992	575	574	\N	3	1	0	1	-1
8993	581	627	\N	3	1	0	1	-1
8994	627	581	\N	3	1	0	1	-1
8995	582	628	\N	3	1	0	1	-1
8996	628	582	\N	3	1	0	1	-1
8997	583	629	\N	3	1	0	1	-1
8998	629	583	\N	3	1	0	1	-1
8999	584	630	\N	3	1	0	1	-1
9000	630	584	\N	3	1	0	1	-1
9001	585	631	\N	3	1	0	1	-1
9002	585	685	\N	3	1	0	1	-1
9003	631	585	\N	3	1	0	1	-1
9004	631	685	\N	3	1	0	1	-1
9005	685	585	\N	3	1	0	1	-1
9006	685	631	\N	3	1	0	1	-1
9007	602	623	\N	3	1	0	1	-1
9008	602	649	\N	3	1	0	1	-1
9009	602	668	\N	3	1	0	1	-1
9010	623	602	\N	3	1	0	1	-1
9011	623	649	\N	3	1	0	1	-1
9012	623	668	\N	3	1	0	1	-1
9013	649	602	\N	3	1	0	1	-1
9014	649	623	\N	3	1	0	1	-1
9015	649	668	\N	3	1	0	1	-1
9016	668	602	\N	3	1	0	1	-1
9017	668	623	\N	3	1	0	1	-1
9018	668	649	\N	3	1	0	1	-1
9019	603	622	\N	3	1	0	1	-1
9020	603	648	\N	3	1	0	1	-1
9021	603	669	\N	3	1	0	1	-1
9022	622	603	\N	3	1	0	1	-1
9023	622	648	\N	3	1	0	1	-1
9024	622	669	\N	3	1	0	1	-1
9025	648	603	\N	3	1	0	1	-1
9026	648	622	\N	3	1	0	1	-1
9027	648	669	\N	3	1	0	1	-1
9028	669	603	\N	3	1	0	1	-1
9029	669	622	\N	3	1	0	1	-1
9030	669	648	\N	3	1	0	1	-1
9031	604	621	\N	3	1	0	1	-1
9032	604	647	\N	3	1	0	1	-1
9033	604	670	\N	3	1	0	1	-1
9034	621	604	\N	3	1	0	1	-1
9035	621	647	\N	3	1	0	1	-1
9036	621	670	\N	3	1	0	1	-1
9037	647	604	\N	3	1	0	1	-1
9038	647	621	\N	3	1	0	1	-1
9039	647	670	\N	3	1	0	1	-1
9040	670	604	\N	3	1	0	1	-1
9041	670	621	\N	3	1	0	1	-1
9042	670	647	\N	3	1	0	1	-1
9043	605	620	\N	3	1	0	1	-1
9044	605	646	\N	3	1	0	1	-1
9045	605	671	\N	3	1	0	1	-1
9046	605	981	\N	3	1	0	1	-1
9047	605	1009	\N	3	1	0	1	-1
9048	605	1445	\N	3	1	0	1	-1
9049	605	1539	\N	3	1	0	1	-1
9050	620	605	\N	3	1	0	1	-1
9051	620	646	\N	3	1	0	1	-1
9052	620	671	\N	3	1	0	1	-1
9053	620	981	\N	3	1	0	1	-1
9054	620	1009	\N	3	1	0	1	-1
9055	620	1445	\N	3	1	0	1	-1
9056	620	1539	\N	3	1	0	1	-1
9057	646	605	\N	3	1	0	1	-1
9058	646	620	\N	3	1	0	1	-1
9059	646	671	\N	3	1	0	1	-1
9060	646	981	\N	3	1	0	1	-1
9061	646	1009	\N	3	1	0	1	-1
9062	646	1445	\N	3	1	0	1	-1
9063	646	1539	\N	3	1	0	1	-1
9064	671	605	\N	3	1	0	1	-1
9065	671	620	\N	3	1	0	1	-1
9066	671	646	\N	3	1	0	1	-1
9067	671	981	\N	3	1	0	1	-1
9068	671	1009	\N	3	1	0	1	-1
9069	671	1445	\N	3	1	0	1	-1
9070	671	1539	\N	3	1	0	1	-1
9071	981	605	\N	3	1	0	1	-1
9072	981	620	\N	3	1	0	1	-1
9073	981	646	\N	3	1	0	1	-1
9074	981	671	\N	3	1	0	1	-1
9075	981	1009	\N	3	1	0	1	-1
9076	981	1445	\N	3	1	0	1	-1
9077	981	1539	\N	3	1	0	1	-1
9078	1009	605	\N	3	1	0	1	-1
9079	1009	620	\N	3	1	0	1	-1
9080	1009	646	\N	3	1	0	1	-1
9081	1009	671	\N	3	1	0	1	-1
9082	1009	981	\N	3	1	0	1	-1
9083	1009	1445	\N	3	1	0	1	-1
9084	1009	1539	\N	3	1	0	1	-1
9085	1445	605	\N	3	1	0	1	-1
9086	1445	620	\N	3	1	0	1	-1
9087	1445	646	\N	3	1	0	1	-1
9088	1445	671	\N	3	1	0	1	-1
9089	1445	981	\N	3	1	0	1	-1
9090	1445	1009	\N	3	1	0	1	-1
9091	1445	1539	\N	3	1	0	1	-1
9092	1539	605	\N	3	1	0	1	-1
9093	1539	620	\N	3	1	0	1	-1
9094	1539	646	\N	3	1	0	1	-1
9095	1539	671	\N	3	1	0	1	-1
9096	1539	981	\N	3	1	0	1	-1
9097	1539	1009	\N	3	1	0	1	-1
9098	1539	1445	\N	3	1	0	1	-1
9099	606	619	\N	3	1	0	1	-1
9100	606	645	\N	3	1	0	1	-1
9101	606	672	\N	3	1	0	1	-1
9102	606	980	\N	3	1	0	1	-1
9103	606	1010	\N	3	1	0	1	-1
9104	606	1444	\N	3	1	0	1	-1
9105	606	1540	\N	3	1	0	1	-1
9106	619	606	\N	3	1	0	1	-1
9107	619	645	\N	3	1	0	1	-1
9108	619	672	\N	3	1	0	1	-1
9109	619	980	\N	3	1	0	1	-1
9110	619	1010	\N	3	1	0	1	-1
9111	619	1444	\N	3	1	0	1	-1
9112	619	1540	\N	3	1	0	1	-1
9113	645	606	\N	3	1	0	1	-1
9114	645	619	\N	3	1	0	1	-1
9115	645	672	\N	3	1	0	1	-1
9116	645	980	\N	3	1	0	1	-1
9117	645	1010	\N	3	1	0	1	-1
9118	645	1444	\N	3	1	0	1	-1
9119	645	1540	\N	3	1	0	1	-1
9120	672	606	\N	3	1	0	1	-1
9121	672	619	\N	3	1	0	1	-1
9122	672	645	\N	3	1	0	1	-1
9123	672	980	\N	3	1	0	1	-1
9124	672	1010	\N	3	1	0	1	-1
9125	672	1444	\N	3	1	0	1	-1
9126	672	1540	\N	3	1	0	1	-1
9127	980	606	\N	3	1	0	1	-1
9128	980	619	\N	3	1	0	1	-1
9129	980	645	\N	3	1	0	1	-1
9130	980	672	\N	3	1	0	1	-1
9131	980	1010	\N	3	1	0	1	-1
9132	980	1444	\N	3	1	0	1	-1
9133	980	1540	\N	3	1	0	1	-1
9134	1010	606	\N	3	1	0	1	-1
9135	1010	619	\N	3	1	0	1	-1
9136	1010	645	\N	3	1	0	1	-1
9137	1010	672	\N	3	1	0	1	-1
9138	1010	980	\N	3	1	0	1	-1
9139	1010	1444	\N	3	1	0	1	-1
9140	1010	1540	\N	3	1	0	1	-1
9141	1444	606	\N	3	1	0	1	-1
9142	1444	619	\N	3	1	0	1	-1
9143	1444	645	\N	3	1	0	1	-1
9144	1444	672	\N	3	1	0	1	-1
9145	1444	980	\N	3	1	0	1	-1
9146	1444	1010	\N	3	1	0	1	-1
9147	1444	1540	\N	3	1	0	1	-1
9148	1540	606	\N	3	1	0	1	-1
9149	1540	619	\N	3	1	0	1	-1
9150	1540	645	\N	3	1	0	1	-1
9151	1540	672	\N	3	1	0	1	-1
9152	1540	980	\N	3	1	0	1	-1
9153	1540	1010	\N	3	1	0	1	-1
9154	1540	1444	\N	3	1	0	1	-1
9155	607	644	\N	3	1	0	1	-1
9156	607	673	\N	3	1	0	1	-1
9157	607	1011	\N	3	1	0	1	-1
9158	607	1541	\N	3	1	0	1	-1
9159	644	607	\N	3	1	0	1	-1
9160	644	673	\N	3	1	0	1	-1
9161	644	1011	\N	3	1	0	1	-1
9162	644	1541	\N	3	1	0	1	-1
9163	673	607	\N	3	1	0	1	-1
9164	673	644	\N	3	1	0	1	-1
9165	673	1011	\N	3	1	0	1	-1
9166	673	1541	\N	3	1	0	1	-1
9167	1011	607	\N	3	1	0	1	-1
9168	1011	644	\N	3	1	0	1	-1
9169	1011	673	\N	3	1	0	1	-1
9170	1011	1541	\N	3	1	0	1	-1
9171	1541	607	\N	3	1	0	1	-1
9172	1541	644	\N	3	1	0	1	-1
9173	1541	673	\N	3	1	0	1	-1
9174	1541	1011	\N	3	1	0	1	-1
9175	608	617	\N	3	1	0	1	-1
9176	608	854	\N	3	1	0	1	-1
9177	608	933	\N	3	1	0	1	-1
9178	608	1542	\N	3	1	0	1	-1
9179	617	608	\N	3	1	0	1	-1
9180	617	854	\N	3	1	0	1	-1
9181	617	933	\N	3	1	0	1	-1
9182	617	1542	\N	3	1	0	1	-1
9183	854	608	\N	3	1	0	1	-1
9184	854	617	\N	3	1	0	1	-1
9185	854	933	\N	3	1	0	1	-1
9186	854	1542	\N	3	1	0	1	-1
9187	933	608	\N	3	1	0	1	-1
9188	933	617	\N	3	1	0	1	-1
9189	933	854	\N	3	1	0	1	-1
9190	933	1542	\N	3	1	0	1	-1
9191	1542	608	\N	3	1	0	1	-1
9192	1542	617	\N	3	1	0	1	-1
9193	1542	854	\N	3	1	0	1	-1
9194	1542	933	\N	3	1	0	1	-1
9195	609	616	\N	3	1	0	1	-1
9196	609	853	\N	3	1	0	1	-1
9197	609	934	\N	3	1	0	1	-1
9198	609	1543	\N	3	1	0	1	-1
9199	616	609	\N	3	1	0	1	-1
9200	616	853	\N	3	1	0	1	-1
9201	616	934	\N	3	1	0	1	-1
9202	616	1543	\N	3	1	0	1	-1
9203	853	609	\N	3	1	0	1	-1
9204	853	616	\N	3	1	0	1	-1
9205	853	934	\N	3	1	0	1	-1
9206	853	1543	\N	3	1	0	1	-1
9207	934	609	\N	3	1	0	1	-1
9208	934	616	\N	3	1	0	1	-1
9209	934	853	\N	3	1	0	1	-1
9210	934	1543	\N	3	1	0	1	-1
9211	1543	609	\N	3	1	0	1	-1
9212	1543	616	\N	3	1	0	1	-1
9213	1543	853	\N	3	1	0	1	-1
9214	1543	934	\N	3	1	0	1	-1
9215	610	615	\N	3	1	0	1	-1
9216	610	852	\N	3	1	0	1	-1
9217	610	935	\N	3	1	0	1	-1
9218	615	610	\N	3	1	0	1	-1
9219	615	852	\N	3	1	0	1	-1
9220	615	935	\N	3	1	0	1	-1
9221	852	610	\N	3	1	0	1	-1
9222	852	615	\N	3	1	0	1	-1
9223	852	935	\N	3	1	0	1	-1
9224	935	610	\N	3	1	0	1	-1
9225	935	615	\N	3	1	0	1	-1
9226	935	852	\N	3	1	0	1	-1
9227	611	614	\N	3	1	0	1	-1
9228	611	851	\N	3	1	0	1	-1
9229	611	936	\N	3	1	0	1	-1
9230	614	611	\N	3	1	0	1	-1
9231	614	851	\N	3	1	0	1	-1
9232	614	936	\N	3	1	0	1	-1
9233	851	611	\N	3	1	0	1	-1
9234	851	614	\N	3	1	0	1	-1
9235	851	936	\N	3	1	0	1	-1
9236	936	611	\N	3	1	0	1	-1
9237	936	614	\N	3	1	0	1	-1
9238	936	851	\N	3	1	0	1	-1
9239	612	613	\N	3	1	0	1	-1
9240	613	612	\N	3	1	0	1	-1
9241	618	855	\N	3	1	0	1	-1
9242	618	932	\N	3	1	0	1	-1
9243	855	618	\N	3	1	0	1	-1
9244	855	932	\N	3	1	0	1	-1
9245	932	618	\N	3	1	0	1	-1
9246	932	855	\N	3	1	0	1	-1
9247	635	682	\N	3	1	0	1	-1
9248	682	635	\N	3	1	0	1	-1
9249	636	681	\N	3	1	0	1	-1
9250	681	636	\N	3	1	0	1	-1
9251	637	680	\N	3	1	0	1	-1
9252	680	637	\N	3	1	0	1	-1
9253	638	679	\N	3	1	0	1	-1
9254	679	638	\N	3	1	0	1	-1
9255	639	678	\N	3	1	0	1	-1
9256	678	639	\N	3	1	0	1	-1
9257	640	677	\N	3	1	0	1	-1
9258	677	640	\N	3	1	0	1	-1
9259	641	676	\N	3	1	0	1	-1
9260	676	641	\N	3	1	0	1	-1
9261	642	675	\N	3	1	0	1	-1
9262	675	642	\N	3	1	0	1	-1
9263	643	674	\N	3	1	0	1	-1
9264	674	643	\N	3	1	0	1	-1
9265	650	667	\N	3	1	0	1	-1
9266	667	650	\N	3	1	0	1	-1
9267	651	666	\N	3	1	0	1	-1
9268	666	651	\N	3	1	0	1	-1
9269	652	665	\N	3	1	0	1	-1
9270	665	652	\N	3	1	0	1	-1
9271	653	664	\N	3	1	0	1	-1
9272	653	909	\N	3	1	0	1	-1
9273	664	653	\N	3	1	0	1	-1
9274	664	909	\N	3	1	0	1	-1
9275	909	653	\N	3	1	0	1	-1
9276	909	664	\N	3	1	0	1	-1
9277	654	663	\N	3	1	0	1	-1
9278	663	654	\N	3	1	0	1	-1
9279	655	662	\N	3	1	0	1	-1
9280	662	655	\N	3	1	0	1	-1
9281	656	661	\N	3	1	0	1	-1
9282	661	656	\N	3	1	0	1	-1
9283	657	660	\N	3	1	0	1	-1
9284	660	657	\N	3	1	0	1	-1
9285	658	659	\N	3	1	0	1	-1
9286	659	658	\N	3	1	0	1	-1
9287	693	724	\N	3	1	0	1	-1
9288	724	693	\N	3	1	0	1	-1
9289	694	723	\N	3	1	0	1	-1
9290	723	694	\N	3	1	0	1	-1
9291	695	722	\N	3	1	0	1	-1
9292	722	695	\N	3	1	0	1	-1
9293	696	721	\N	3	1	0	1	-1
9294	721	696	\N	3	1	0	1	-1
9295	697	720	\N	3	1	0	1	-1
9296	697	1150	\N	3	1	0	1	-1
9297	697	1181	\N	3	1	0	1	-1
9298	697	1408	\N	3	1	0	1	-1
9299	697	1429	\N	3	1	0	1	-1
9300	720	697	\N	3	1	0	1	-1
9301	720	1150	\N	3	1	0	1	-1
9302	720	1181	\N	3	1	0	1	-1
9303	720	1408	\N	3	1	0	1	-1
9304	720	1429	\N	3	1	0	1	-1
9305	1150	697	\N	3	1	0	1	-1
9306	1150	720	\N	3	1	0	1	-1
9307	1150	1181	\N	3	1	0	1	-1
9308	1150	1408	\N	3	1	0	1	-1
9309	1150	1429	\N	3	1	0	1	-1
9310	1181	697	\N	3	1	0	1	-1
9311	1181	720	\N	3	1	0	1	-1
9312	1181	1150	\N	3	1	0	1	-1
9313	1181	1408	\N	3	1	0	1	-1
9314	1181	1429	\N	3	1	0	1	-1
9315	1408	697	\N	3	1	0	1	-1
9316	1408	720	\N	3	1	0	1	-1
9317	1408	1150	\N	3	1	0	1	-1
9318	1408	1181	\N	3	1	0	1	-1
9319	1408	1429	\N	3	1	0	1	-1
9320	1429	697	\N	3	1	0	1	-1
9321	1429	720	\N	3	1	0	1	-1
9322	1429	1150	\N	3	1	0	1	-1
9323	1429	1181	\N	3	1	0	1	-1
9324	1429	1408	\N	3	1	0	1	-1
9325	706	711	\N	3	1	0	1	-1
9326	711	706	\N	3	1	0	1	-1
9327	707	710	\N	3	1	0	1	-1
9328	710	707	\N	3	1	0	1	-1
9329	708	709	\N	3	1	0	1	-1
9330	709	708	\N	3	1	0	1	-1
9331	730	784	\N	3	1	0	1	-1
9332	730	1032	\N	3	1	0	1	-1
9333	730	1238	\N	3	1	0	1	-1
9334	730	1382	\N	3	1	0	1	-1
9335	730	1395	\N	3	1	0	1	-1
9336	730	1513	\N	3	1	0	1	-1
9337	784	730	\N	3	1	0	1	-1
9338	784	1032	\N	3	1	0	1	-1
9339	784	1238	\N	3	1	0	1	-1
9340	784	1382	\N	3	1	0	1	-1
9341	784	1395	\N	3	1	0	1	-1
9342	784	1513	\N	3	1	0	1	-1
9343	1032	730	\N	3	1	0	1	-1
9344	1032	784	\N	3	1	0	1	-1
9345	1032	1238	\N	3	1	0	1	-1
9346	1032	1382	\N	3	1	0	1	-1
9347	1032	1395	\N	3	1	0	1	-1
9348	1032	1513	\N	3	1	0	1	-1
9349	1238	730	\N	3	1	0	1	-1
9350	1238	784	\N	3	1	0	1	-1
9351	1238	1032	\N	3	1	0	1	-1
9352	1238	1382	\N	3	1	0	1	-1
9353	1238	1395	\N	3	1	0	1	-1
9354	1238	1513	\N	3	1	0	1	-1
9355	1382	730	\N	3	1	0	1	-1
9356	1382	784	\N	3	1	0	1	-1
9357	1382	1032	\N	3	1	0	1	-1
9358	1382	1238	\N	3	1	0	1	-1
9359	1382	1395	\N	3	1	0	1	-1
9360	1382	1513	\N	3	1	0	1	-1
9361	1395	730	\N	3	1	0	1	-1
9362	1395	784	\N	3	1	0	1	-1
9363	1395	1032	\N	3	1	0	1	-1
9364	1395	1238	\N	3	1	0	1	-1
9365	1395	1382	\N	3	1	0	1	-1
9366	1395	1513	\N	3	1	0	1	-1
9367	1513	730	\N	3	1	0	1	-1
9368	1513	784	\N	3	1	0	1	-1
9369	1513	1032	\N	3	1	0	1	-1
9370	1513	1238	\N	3	1	0	1	-1
9371	1513	1382	\N	3	1	0	1	-1
9372	1513	1395	\N	3	1	0	1	-1
9373	731	1033	\N	3	1	0	1	-1
9374	731	1239	\N	3	1	0	1	-1
9375	731	1514	\N	3	1	0	1	-1
9376	1033	731	\N	3	1	0	1	-1
9377	1033	1239	\N	3	1	0	1	-1
9378	1033	1514	\N	3	1	0	1	-1
9379	1239	731	\N	3	1	0	1	-1
9380	1239	1033	\N	3	1	0	1	-1
9381	1239	1514	\N	3	1	0	1	-1
9382	1514	731	\N	3	1	0	1	-1
9383	1514	1033	\N	3	1	0	1	-1
9384	1514	1239	\N	3	1	0	1	-1
9385	732	1034	\N	3	1	0	1	-1
9386	732	1240	\N	3	1	0	1	-1
9387	732	1515	\N	3	1	0	1	-1
9388	1034	732	\N	3	1	0	1	-1
9389	1034	1240	\N	3	1	0	1	-1
9390	1034	1515	\N	3	1	0	1	-1
9391	1240	732	\N	3	1	0	1	-1
9392	1240	1034	\N	3	1	0	1	-1
9393	1240	1515	\N	3	1	0	1	-1
9394	1515	732	\N	3	1	0	1	-1
9395	1515	1034	\N	3	1	0	1	-1
9396	1515	1240	\N	3	1	0	1	-1
9397	733	1035	\N	3	1	0	1	-1
9398	733	1241	\N	3	1	0	1	-1
9399	733	1516	\N	3	1	0	1	-1
9400	1035	733	\N	3	1	0	1	-1
9401	1035	1241	\N	3	1	0	1	-1
9402	1035	1516	\N	3	1	0	1	-1
9403	1241	733	\N	3	1	0	1	-1
9404	1241	1035	\N	3	1	0	1	-1
9405	1241	1516	\N	3	1	0	1	-1
9406	1516	733	\N	3	1	0	1	-1
9407	1516	1035	\N	3	1	0	1	-1
9408	1516	1241	\N	3	1	0	1	-1
9409	734	1036	\N	3	1	0	1	-1
9410	734	1242	\N	3	1	0	1	-1
9411	734	1517	\N	3	1	0	1	-1
9412	1036	734	\N	3	1	0	1	-1
9413	1036	1242	\N	3	1	0	1	-1
9414	1036	1517	\N	3	1	0	1	-1
9415	1242	734	\N	3	1	0	1	-1
9416	1242	1036	\N	3	1	0	1	-1
9417	1242	1517	\N	3	1	0	1	-1
9418	1517	734	\N	3	1	0	1	-1
9419	1517	1036	\N	3	1	0	1	-1
9420	1517	1242	\N	3	1	0	1	-1
9421	751	766	\N	3	1	0	1	-1
9422	751	798	\N	3	1	0	1	-1
9423	751	828	\N	3	1	0	1	-1
9424	751	1073	\N	3	1	0	1	-1
9425	751	1100	\N	3	1	0	1	-1
9426	766	751	\N	3	1	0	1	-1
9427	766	798	\N	3	1	0	1	-1
9428	766	828	\N	3	1	0	1	-1
9429	766	1073	\N	3	1	0	1	-1
9430	766	1100	\N	3	1	0	1	-1
9431	798	751	\N	3	1	0	1	-1
9432	798	766	\N	3	1	0	1	-1
9433	798	828	\N	3	1	0	1	-1
9434	798	1073	\N	3	1	0	1	-1
9435	798	1100	\N	3	1	0	1	-1
9436	828	751	\N	3	1	0	1	-1
9437	828	766	\N	3	1	0	1	-1
9438	828	798	\N	3	1	0	1	-1
9439	828	1073	\N	3	1	0	1	-1
9440	828	1100	\N	3	1	0	1	-1
9441	1073	751	\N	3	1	0	1	-1
9442	1073	766	\N	3	1	0	1	-1
9443	1073	798	\N	3	1	0	1	-1
9444	1073	828	\N	3	1	0	1	-1
9445	1073	1100	\N	3	1	0	1	-1
9446	1100	751	\N	3	1	0	1	-1
9447	1100	766	\N	3	1	0	1	-1
9448	1100	798	\N	3	1	0	1	-1
9449	1100	828	\N	3	1	0	1	-1
9450	1100	1073	\N	3	1	0	1	-1
9451	752	829	\N	3	1	0	1	-1
9452	752	1074	\N	3	1	0	1	-1
9453	829	752	\N	3	1	0	1	-1
9454	829	1074	\N	3	1	0	1	-1
9455	1074	752	\N	3	1	0	1	-1
9456	1074	829	\N	3	1	0	1	-1
9457	753	764	\N	3	1	0	1	-1
9458	753	1075	\N	3	1	0	1	-1
9459	753	1098	\N	3	1	0	1	-1
9460	764	753	\N	3	1	0	1	-1
9461	764	1075	\N	3	1	0	1	-1
9462	764	1098	\N	3	1	0	1	-1
9463	1075	753	\N	3	1	0	1	-1
9464	1075	764	\N	3	1	0	1	-1
9465	1075	1098	\N	3	1	0	1	-1
9466	1098	753	\N	3	1	0	1	-1
9467	1098	764	\N	3	1	0	1	-1
9468	1098	1075	\N	3	1	0	1	-1
9469	754	763	\N	3	1	0	1	-1
9470	754	1076	\N	3	1	0	1	-1
9471	754	1097	\N	3	1	0	1	-1
9472	763	754	\N	3	1	0	1	-1
9473	763	1076	\N	3	1	0	1	-1
9474	763	1097	\N	3	1	0	1	-1
9475	1076	754	\N	3	1	0	1	-1
9476	1076	763	\N	3	1	0	1	-1
9477	1076	1097	\N	3	1	0	1	-1
9478	1097	754	\N	3	1	0	1	-1
9479	1097	763	\N	3	1	0	1	-1
9480	1097	1076	\N	3	1	0	1	-1
9481	755	762	\N	3	1	0	1	-1
9482	755	1077	\N	3	1	0	1	-1
9483	755	1096	\N	3	1	0	1	-1
9484	762	755	\N	3	1	0	1	-1
9485	762	1077	\N	3	1	0	1	-1
9486	762	1096	\N	3	1	0	1	-1
9487	1077	755	\N	3	1	0	1	-1
9488	1077	762	\N	3	1	0	1	-1
9489	1077	1096	\N	3	1	0	1	-1
9490	1096	755	\N	3	1	0	1	-1
9491	1096	762	\N	3	1	0	1	-1
9492	1096	1077	\N	3	1	0	1	-1
9493	756	761	\N	3	1	0	1	-1
9494	756	1078	\N	3	1	0	1	-1
9495	756	1095	\N	3	1	0	1	-1
9496	761	756	\N	3	1	0	1	-1
9497	761	1078	\N	3	1	0	1	-1
9498	761	1095	\N	3	1	0	1	-1
9499	1078	756	\N	3	1	0	1	-1
9500	1078	761	\N	3	1	0	1	-1
9501	1078	1095	\N	3	1	0	1	-1
9502	1095	756	\N	3	1	0	1	-1
9503	1095	761	\N	3	1	0	1	-1
9504	1095	1078	\N	3	1	0	1	-1
9505	757	760	\N	3	1	0	1	-1
9506	757	1079	\N	3	1	0	1	-1
9507	757	1094	\N	3	1	0	1	-1
9508	760	757	\N	3	1	0	1	-1
9509	760	1079	\N	3	1	0	1	-1
9510	760	1094	\N	3	1	0	1	-1
9511	1079	757	\N	3	1	0	1	-1
9512	1079	760	\N	3	1	0	1	-1
9513	1079	1094	\N	3	1	0	1	-1
9514	1094	757	\N	3	1	0	1	-1
9515	1094	760	\N	3	1	0	1	-1
9516	1094	1079	\N	3	1	0	1	-1
9517	758	759	\N	3	1	0	1	-1
9518	759	758	\N	3	1	0	1	-1
9519	765	797	\N	3	1	0	1	-1
9520	765	1099	\N	3	1	0	1	-1
9521	797	765	\N	3	1	0	1	-1
9522	797	1099	\N	3	1	0	1	-1
9523	1099	765	\N	3	1	0	1	-1
9524	1099	797	\N	3	1	0	1	-1
9525	767	799	\N	3	1	0	1	-1
9526	767	1101	\N	3	1	0	1	-1
9527	799	767	\N	3	1	0	1	-1
9528	799	1101	\N	3	1	0	1	-1
9529	1101	767	\N	3	1	0	1	-1
9530	1101	799	\N	3	1	0	1	-1
9531	781	1379	\N	3	1	0	1	-1
9532	781	1398	\N	3	1	0	1	-1
9533	1379	781	\N	3	1	0	1	-1
9534	1379	1398	\N	3	1	0	1	-1
9535	1398	781	\N	3	1	0	1	-1
9536	1398	1379	\N	3	1	0	1	-1
9537	782	1380	\N	3	1	0	1	-1
9538	782	1397	\N	3	1	0	1	-1
9539	1380	782	\N	3	1	0	1	-1
9540	1380	1397	\N	3	1	0	1	-1
9541	1397	782	\N	3	1	0	1	-1
9542	1397	1380	\N	3	1	0	1	-1
9543	783	1381	\N	3	1	0	1	-1
9544	783	1396	\N	3	1	0	1	-1
9545	1381	783	\N	3	1	0	1	-1
9546	1381	1396	\N	3	1	0	1	-1
9547	1396	783	\N	3	1	0	1	-1
9548	1396	1381	\N	3	1	0	1	-1
9549	786	840	\N	3	1	0	1	-1
9550	840	786	\N	3	1	0	1	-1
9551	787	839	\N	3	1	0	1	-1
9552	839	787	\N	3	1	0	1	-1
9553	788	838	\N	3	1	0	1	-1
9554	838	788	\N	3	1	0	1	-1
9555	789	837	\N	3	1	0	1	-1
9556	837	789	\N	3	1	0	1	-1
9557	790	836	\N	3	1	0	1	-1
9558	836	790	\N	3	1	0	1	-1
9559	791	835	\N	3	1	0	1	-1
9560	835	791	\N	3	1	0	1	-1
9561	792	834	\N	3	1	0	1	-1
9562	834	792	\N	3	1	0	1	-1
9563	793	833	\N	3	1	0	1	-1
9564	833	793	\N	3	1	0	1	-1
9565	794	832	\N	3	1	0	1	-1
9566	832	794	\N	3	1	0	1	-1
9567	795	831	\N	3	1	0	1	-1
9568	831	795	\N	3	1	0	1	-1
9569	796	830	\N	3	1	0	1	-1
9570	830	796	\N	3	1	0	1	-1
9571	813	814	\N	3	1	0	1	-1
9572	814	813	\N	3	1	0	1	-1
9573	841	946	\N	3	1	0	1	-1
9574	946	841	\N	3	1	0	1	-1
9575	842	945	\N	3	1	0	1	-1
9576	945	842	\N	3	1	0	1	-1
9577	843	944	\N	3	1	0	1	-1
9578	944	843	\N	3	1	0	1	-1
9579	844	943	\N	3	1	0	1	-1
9580	943	844	\N	3	1	0	1	-1
9581	845	942	\N	3	1	0	1	-1
9582	942	845	\N	3	1	0	1	-1
9583	846	941	\N	3	1	0	1	-1
9584	941	846	\N	3	1	0	1	-1
9585	847	940	\N	3	1	0	1	-1
9586	940	847	\N	3	1	0	1	-1
9587	848	939	\N	3	1	0	1	-1
9588	939	848	\N	3	1	0	1	-1
9589	849	938	\N	3	1	0	1	-1
9590	938	849	\N	3	1	0	1	-1
9591	850	937	\N	3	1	0	1	-1
9592	937	850	\N	3	1	0	1	-1
9593	856	931	\N	3	1	0	1	-1
9594	856	978	\N	3	1	0	1	-1
9595	856	1012	\N	3	1	0	1	-1
9596	856	1492	\N	3	1	0	1	-1
9597	856	1493	\N	3	1	0	1	-1
9598	931	856	\N	3	1	0	1	-1
9599	931	978	\N	3	1	0	1	-1
9600	931	1012	\N	3	1	0	1	-1
9601	931	1492	\N	3	1	0	1	-1
9602	931	1493	\N	3	1	0	1	-1
9603	978	856	\N	3	1	0	1	-1
9604	978	931	\N	3	1	0	1	-1
9605	978	1012	\N	3	1	0	1	-1
9606	978	1492	\N	3	1	0	1	-1
9607	978	1493	\N	3	1	0	1	-1
9608	1012	856	\N	3	1	0	1	-1
9609	1012	931	\N	3	1	0	1	-1
9610	1012	978	\N	3	1	0	1	-1
9611	1012	1492	\N	3	1	0	1	-1
9612	1012	1493	\N	3	1	0	1	-1
9613	1492	856	\N	3	1	0	1	-1
9614	1492	931	\N	3	1	0	1	-1
9615	1492	978	\N	3	1	0	1	-1
9616	1492	1012	\N	3	1	0	1	-1
9617	1492	1493	\N	3	1	0	1	-1
9618	1493	856	\N	3	1	0	1	-1
9619	1493	931	\N	3	1	0	1	-1
9620	1493	978	\N	3	1	0	1	-1
9621	1493	1012	\N	3	1	0	1	-1
9622	1493	1492	\N	3	1	0	1	-1
9623	857	930	\N	3	1	0	1	-1
9624	857	977	\N	3	1	0	1	-1
9625	857	1013	\N	3	1	0	1	-1
9626	857	1491	\N	3	1	0	1	-1
9627	857	1494	\N	3	1	0	1	-1
9628	930	857	\N	3	1	0	1	-1
9629	930	977	\N	3	1	0	1	-1
9630	930	1013	\N	3	1	0	1	-1
9631	930	1491	\N	3	1	0	1	-1
9632	930	1494	\N	3	1	0	1	-1
9633	977	857	\N	3	1	0	1	-1
9634	977	930	\N	3	1	0	1	-1
9635	977	1013	\N	3	1	0	1	-1
9636	977	1491	\N	3	1	0	1	-1
9637	977	1494	\N	3	1	0	1	-1
9638	1013	857	\N	3	1	0	1	-1
9639	1013	930	\N	3	1	0	1	-1
9640	1013	977	\N	3	1	0	1	-1
9641	1013	1491	\N	3	1	0	1	-1
9642	1013	1494	\N	3	1	0	1	-1
9643	1491	857	\N	3	1	0	1	-1
9644	1491	930	\N	3	1	0	1	-1
9645	1491	977	\N	3	1	0	1	-1
9646	1491	1013	\N	3	1	0	1	-1
9647	1491	1494	\N	3	1	0	1	-1
9648	1494	857	\N	3	1	0	1	-1
9649	1494	930	\N	3	1	0	1	-1
9650	1494	977	\N	3	1	0	1	-1
9651	1494	1013	\N	3	1	0	1	-1
9652	1494	1491	\N	3	1	0	1	-1
9653	858	929	\N	3	1	0	1	-1
9654	858	976	\N	3	1	0	1	-1
9655	858	1014	\N	3	1	0	1	-1
9656	858	1490	\N	3	1	0	1	-1
9657	858	1495	\N	3	1	0	1	-1
9658	929	858	\N	3	1	0	1	-1
9659	929	976	\N	3	1	0	1	-1
9660	929	1014	\N	3	1	0	1	-1
9661	929	1490	\N	3	1	0	1	-1
9662	929	1495	\N	3	1	0	1	-1
9663	976	858	\N	3	1	0	1	-1
9664	976	929	\N	3	1	0	1	-1
9665	976	1014	\N	3	1	0	1	-1
9666	976	1490	\N	3	1	0	1	-1
9667	976	1495	\N	3	1	0	1	-1
9668	1014	858	\N	3	1	0	1	-1
9669	1014	929	\N	3	1	0	1	-1
9670	1014	976	\N	3	1	0	1	-1
9671	1014	1490	\N	3	1	0	1	-1
9672	1014	1495	\N	3	1	0	1	-1
9673	1490	858	\N	3	1	0	1	-1
9674	1490	929	\N	3	1	0	1	-1
9675	1490	976	\N	3	1	0	1	-1
9676	1490	1014	\N	3	1	0	1	-1
9677	1490	1495	\N	3	1	0	1	-1
9678	1495	858	\N	3	1	0	1	-1
9679	1495	929	\N	3	1	0	1	-1
9680	1495	976	\N	3	1	0	1	-1
9681	1495	1014	\N	3	1	0	1	-1
9682	1495	1490	\N	3	1	0	1	-1
9683	862	924	\N	3	1	0	1	-1
9684	924	862	\N	3	1	0	1	-1
9685	863	923	\N	3	1	0	1	-1
9686	923	863	\N	3	1	0	1	-1
9687	864	922	\N	3	1	0	1	-1
9688	922	864	\N	3	1	0	1	-1
9689	865	921	\N	3	1	0	1	-1
9690	921	865	\N	3	1	0	1	-1
9691	866	920	\N	3	1	0	1	-1
9692	920	866	\N	3	1	0	1	-1
9693	867	919	\N	3	1	0	1	-1
9694	919	867	\N	3	1	0	1	-1
9695	868	918	\N	3	1	0	1	-1
9696	918	868	\N	3	1	0	1	-1
9697	869	917	\N	3	1	0	1	-1
9698	917	869	\N	3	1	0	1	-1
9699	871	916	\N	3	1	0	1	-1
9700	916	871	\N	3	1	0	1	-1
9701	872	915	\N	3	1	0	1	-1
9702	915	872	\N	3	1	0	1	-1
9703	873	914	\N	3	1	0	1	-1
9704	914	873	\N	3	1	0	1	-1
9705	875	913	\N	3	1	0	1	-1
9706	913	875	\N	3	1	0	1	-1
9707	876	912	\N	3	1	0	1	-1
9708	912	876	\N	3	1	0	1	-1
9709	877	911	\N	3	1	0	1	-1
9710	911	877	\N	3	1	0	1	-1
9711	878	910	\N	3	1	0	1	-1
9712	910	878	\N	3	1	0	1	-1
9713	887	902	\N	3	1	0	1	-1
9714	902	887	\N	3	1	0	1	-1
9715	888	901	\N	3	1	0	1	-1
9716	901	888	\N	3	1	0	1	-1
9717	889	900	\N	3	1	0	1	-1
9718	900	889	\N	3	1	0	1	-1
9719	890	899	\N	3	1	0	1	-1
9720	899	890	\N	3	1	0	1	-1
9721	891	898	\N	3	1	0	1	-1
9722	898	891	\N	3	1	0	1	-1
9723	892	897	\N	3	1	0	1	-1
9724	897	892	\N	3	1	0	1	-1
9725	893	896	\N	3	1	0	1	-1
9726	896	893	\N	3	1	0	1	-1
9727	894	895	\N	3	1	0	1	-1
9728	895	894	\N	3	1	0	1	-1
9729	949	1041	\N	3	1	0	1	-1
9730	949	1222	\N	3	1	0	1	-1
9731	949	1247	\N	3	1	0	1	-1
9732	949	1463	\N	3	1	0	1	-1
9733	949	1522	\N	3	1	0	1	-1
9734	1041	949	\N	3	1	0	1	-1
9735	1041	1222	\N	3	1	0	1	-1
9736	1041	1247	\N	3	1	0	1	-1
9737	1041	1463	\N	3	1	0	1	-1
9738	1041	1522	\N	3	1	0	1	-1
9739	1222	949	\N	3	1	0	1	-1
9740	1222	1041	\N	3	1	0	1	-1
9741	1222	1247	\N	3	1	0	1	-1
9742	1222	1463	\N	3	1	0	1	-1
9743	1222	1522	\N	3	1	0	1	-1
9744	1247	949	\N	3	1	0	1	-1
9745	1247	1041	\N	3	1	0	1	-1
9746	1247	1222	\N	3	1	0	1	-1
9747	1247	1463	\N	3	1	0	1	-1
9748	1247	1522	\N	3	1	0	1	-1
9749	1463	949	\N	3	1	0	1	-1
9750	1463	1041	\N	3	1	0	1	-1
9751	1463	1222	\N	3	1	0	1	-1
9752	1463	1247	\N	3	1	0	1	-1
9753	1463	1522	\N	3	1	0	1	-1
9754	1522	949	\N	3	1	0	1	-1
9755	1522	1041	\N	3	1	0	1	-1
9756	1522	1222	\N	3	1	0	1	-1
9757	1522	1247	\N	3	1	0	1	-1
9758	1522	1463	\N	3	1	0	1	-1
9759	950	1040	\N	3	1	0	1	-1
9760	950	1223	\N	3	1	0	1	-1
9761	950	1246	\N	3	1	0	1	-1
9762	950	1464	\N	3	1	0	1	-1
9763	950	1521	\N	3	1	0	1	-1
9764	1040	950	\N	3	1	0	1	-1
9765	1040	1223	\N	3	1	0	1	-1
9766	1040	1246	\N	3	1	0	1	-1
9767	1040	1464	\N	3	1	0	1	-1
9768	1040	1521	\N	3	1	0	1	-1
9769	1223	950	\N	3	1	0	1	-1
9770	1223	1040	\N	3	1	0	1	-1
9771	1223	1246	\N	3	1	0	1	-1
9772	1223	1464	\N	3	1	0	1	-1
9773	1223	1521	\N	3	1	0	1	-1
9774	1246	950	\N	3	1	0	1	-1
9775	1246	1040	\N	3	1	0	1	-1
9776	1246	1223	\N	3	1	0	1	-1
9777	1246	1464	\N	3	1	0	1	-1
9778	1246	1521	\N	3	1	0	1	-1
9779	1464	950	\N	3	1	0	1	-1
9780	1464	1040	\N	3	1	0	1	-1
9781	1464	1223	\N	3	1	0	1	-1
9782	1464	1246	\N	3	1	0	1	-1
9783	1464	1521	\N	3	1	0	1	-1
9784	1521	950	\N	3	1	0	1	-1
9785	1521	1040	\N	3	1	0	1	-1
9786	1521	1223	\N	3	1	0	1	-1
9787	1521	1246	\N	3	1	0	1	-1
9788	1521	1464	\N	3	1	0	1	-1
9789	951	1039	\N	3	1	0	1	-1
9790	951	1224	\N	3	1	0	1	-1
9791	951	1245	\N	3	1	0	1	-1
9792	951	1465	\N	3	1	0	1	-1
9793	951	1520	\N	3	1	0	1	-1
9794	1039	951	\N	3	1	0	1	-1
9795	1039	1224	\N	3	1	0	1	-1
9796	1039	1245	\N	3	1	0	1	-1
9797	1039	1465	\N	3	1	0	1	-1
9798	1039	1520	\N	3	1	0	1	-1
9799	1224	951	\N	3	1	0	1	-1
9800	1224	1039	\N	3	1	0	1	-1
9801	1224	1245	\N	3	1	0	1	-1
9802	1224	1465	\N	3	1	0	1	-1
9803	1224	1520	\N	3	1	0	1	-1
9804	1245	951	\N	3	1	0	1	-1
9805	1245	1039	\N	3	1	0	1	-1
9806	1245	1224	\N	3	1	0	1	-1
9807	1245	1465	\N	3	1	0	1	-1
9808	1245	1520	\N	3	1	0	1	-1
9809	1465	951	\N	3	1	0	1	-1
9810	1465	1039	\N	3	1	0	1	-1
9811	1465	1224	\N	3	1	0	1	-1
9812	1465	1245	\N	3	1	0	1	-1
9813	1465	1520	\N	3	1	0	1	-1
9814	1520	951	\N	3	1	0	1	-1
9815	1520	1039	\N	3	1	0	1	-1
9816	1520	1224	\N	3	1	0	1	-1
9817	1520	1245	\N	3	1	0	1	-1
9818	1520	1465	\N	3	1	0	1	-1
9819	952	1038	\N	3	1	0	1	-1
9820	952	1225	\N	3	1	0	1	-1
9821	952	1244	\N	3	1	0	1	-1
9822	952	1466	\N	3	1	0	1	-1
9823	952	1519	\N	3	1	0	1	-1
9824	1038	952	\N	3	1	0	1	-1
9825	1038	1225	\N	3	1	0	1	-1
9826	1038	1244	\N	3	1	0	1	-1
9827	1038	1466	\N	3	1	0	1	-1
9828	1038	1519	\N	3	1	0	1	-1
9829	1225	952	\N	3	1	0	1	-1
9830	1225	1038	\N	3	1	0	1	-1
9831	1225	1244	\N	3	1	0	1	-1
9832	1225	1466	\N	3	1	0	1	-1
9833	1225	1519	\N	3	1	0	1	-1
9834	1244	952	\N	3	1	0	1	-1
9835	1244	1038	\N	3	1	0	1	-1
9836	1244	1225	\N	3	1	0	1	-1
9837	1244	1466	\N	3	1	0	1	-1
9838	1244	1519	\N	3	1	0	1	-1
9839	1466	952	\N	3	1	0	1	-1
9840	1466	1038	\N	3	1	0	1	-1
9841	1466	1225	\N	3	1	0	1	-1
9842	1466	1244	\N	3	1	0	1	-1
9843	1466	1519	\N	3	1	0	1	-1
9844	1519	952	\N	3	1	0	1	-1
9845	1519	1038	\N	3	1	0	1	-1
9846	1519	1225	\N	3	1	0	1	-1
9847	1519	1244	\N	3	1	0	1	-1
9848	1519	1466	\N	3	1	0	1	-1
9849	953	1037	\N	3	1	0	1	-1
9850	953	1226	\N	3	1	0	1	-1
9851	953	1243	\N	3	1	0	1	-1
9852	953	1467	\N	3	1	0	1	-1
9853	953	1518	\N	3	1	0	1	-1
9854	1037	953	\N	3	1	0	1	-1
9855	1037	1226	\N	3	1	0	1	-1
9856	1037	1243	\N	3	1	0	1	-1
9857	1037	1467	\N	3	1	0	1	-1
9858	1037	1518	\N	3	1	0	1	-1
9859	1226	953	\N	3	1	0	1	-1
9860	1226	1037	\N	3	1	0	1	-1
9861	1226	1243	\N	3	1	0	1	-1
9862	1226	1467	\N	3	1	0	1	-1
9863	1226	1518	\N	3	1	0	1	-1
9864	1243	953	\N	3	1	0	1	-1
9865	1243	1037	\N	3	1	0	1	-1
9866	1243	1226	\N	3	1	0	1	-1
9867	1243	1467	\N	3	1	0	1	-1
9868	1243	1518	\N	3	1	0	1	-1
9869	1467	953	\N	3	1	0	1	-1
9870	1467	1037	\N	3	1	0	1	-1
9871	1467	1226	\N	3	1	0	1	-1
9872	1467	1243	\N	3	1	0	1	-1
9873	1467	1518	\N	3	1	0	1	-1
9874	1518	953	\N	3	1	0	1	-1
9875	1518	1037	\N	3	1	0	1	-1
9876	1518	1226	\N	3	1	0	1	-1
9877	1518	1243	\N	3	1	0	1	-1
9878	1518	1467	\N	3	1	0	1	-1
9879	954	1227	\N	3	1	0	1	-1
9880	954	1468	\N	3	1	0	1	-1
9881	1227	954	\N	3	1	0	1	-1
9882	1227	1468	\N	3	1	0	1	-1
9883	1468	954	\N	3	1	0	1	-1
9884	1468	1227	\N	3	1	0	1	-1
9885	955	1228	\N	3	1	0	1	-1
9886	955	1469	\N	3	1	0	1	-1
9887	1228	955	\N	3	1	0	1	-1
9888	1228	1469	\N	3	1	0	1	-1
9889	1469	955	\N	3	1	0	1	-1
9890	1469	1228	\N	3	1	0	1	-1
9891	956	1229	\N	3	1	0	1	-1
9892	956	1470	\N	3	1	0	1	-1
9893	1229	956	\N	3	1	0	1	-1
9894	1229	1470	\N	3	1	0	1	-1
9895	1470	956	\N	3	1	0	1	-1
9896	1470	1229	\N	3	1	0	1	-1
9897	957	1230	\N	3	1	0	1	-1
9898	957	1471	\N	3	1	0	1	-1
9899	1230	957	\N	3	1	0	1	-1
9900	1230	1471	\N	3	1	0	1	-1
9901	1471	957	\N	3	1	0	1	-1
9902	1471	1230	\N	3	1	0	1	-1
9903	958	1231	\N	3	1	0	1	-1
9904	958	1472	\N	3	1	0	1	-1
9905	1231	958	\N	3	1	0	1	-1
9906	1231	1472	\N	3	1	0	1	-1
9907	1472	958	\N	3	1	0	1	-1
9908	1472	1231	\N	3	1	0	1	-1
9909	959	1031	\N	3	1	0	1	-1
9910	959	1232	\N	3	1	0	1	-1
9911	959	1237	\N	3	1	0	1	-1
9912	959	1473	\N	3	1	0	1	-1
9913	959	1512	\N	3	1	0	1	-1
9914	1031	959	\N	3	1	0	1	-1
9915	1031	1232	\N	3	1	0	1	-1
9916	1031	1237	\N	3	1	0	1	-1
9917	1031	1473	\N	3	1	0	1	-1
9918	1031	1512	\N	3	1	0	1	-1
9919	1232	959	\N	3	1	0	1	-1
9920	1232	1031	\N	3	1	0	1	-1
9921	1232	1237	\N	3	1	0	1	-1
9922	1232	1473	\N	3	1	0	1	-1
9923	1232	1512	\N	3	1	0	1	-1
9924	1237	959	\N	3	1	0	1	-1
9925	1237	1031	\N	3	1	0	1	-1
9926	1237	1232	\N	3	1	0	1	-1
9927	1237	1473	\N	3	1	0	1	-1
9928	1237	1512	\N	3	1	0	1	-1
9929	1473	959	\N	3	1	0	1	-1
9930	1473	1031	\N	3	1	0	1	-1
9931	1473	1232	\N	3	1	0	1	-1
9932	1473	1237	\N	3	1	0	1	-1
9933	1473	1512	\N	3	1	0	1	-1
9934	1512	959	\N	3	1	0	1	-1
9935	1512	1031	\N	3	1	0	1	-1
9936	1512	1232	\N	3	1	0	1	-1
9937	1512	1237	\N	3	1	0	1	-1
9938	1512	1473	\N	3	1	0	1	-1
9939	960	1030	\N	3	1	0	1	-1
9940	960	1233	\N	3	1	0	1	-1
9941	960	1236	\N	3	1	0	1	-1
9942	960	1474	\N	3	1	0	1	-1
9943	960	1511	\N	3	1	0	1	-1
9944	1030	960	\N	3	1	0	1	-1
9945	1030	1233	\N	3	1	0	1	-1
9946	1030	1236	\N	3	1	0	1	-1
9947	1030	1474	\N	3	1	0	1	-1
9948	1030	1511	\N	3	1	0	1	-1
9949	1233	960	\N	3	1	0	1	-1
9950	1233	1030	\N	3	1	0	1	-1
9951	1233	1236	\N	3	1	0	1	-1
9952	1233	1474	\N	3	1	0	1	-1
9953	1233	1511	\N	3	1	0	1	-1
9954	1236	960	\N	3	1	0	1	-1
9955	1236	1030	\N	3	1	0	1	-1
9956	1236	1233	\N	3	1	0	1	-1
9957	1236	1474	\N	3	1	0	1	-1
9958	1236	1511	\N	3	1	0	1	-1
9959	1474	960	\N	3	1	0	1	-1
9960	1474	1030	\N	3	1	0	1	-1
9961	1474	1233	\N	3	1	0	1	-1
9962	1474	1236	\N	3	1	0	1	-1
9963	1474	1511	\N	3	1	0	1	-1
9964	1511	960	\N	3	1	0	1	-1
9965	1511	1030	\N	3	1	0	1	-1
9966	1511	1233	\N	3	1	0	1	-1
9967	1511	1236	\N	3	1	0	1	-1
9968	1511	1474	\N	3	1	0	1	-1
9969	979	1443	\N	3	1	0	1	-1
9970	1443	979	\N	3	1	0	1	-1
9971	982	1008	\N	3	1	0	1	-1
9972	982	1446	\N	3	1	0	1	-1
9973	982	1538	\N	3	1	0	1	-1
9974	1008	982	\N	3	1	0	1	-1
9975	1008	1446	\N	3	1	0	1	-1
9976	1008	1538	\N	3	1	0	1	-1
9977	1446	982	\N	3	1	0	1	-1
9978	1446	1008	\N	3	1	0	1	-1
9979	1446	1538	\N	3	1	0	1	-1
9980	1538	982	\N	3	1	0	1	-1
9981	1538	1008	\N	3	1	0	1	-1
9982	1538	1446	\N	3	1	0	1	-1
9983	983	1007	\N	3	1	0	1	-1
9984	983	1447	\N	3	1	0	1	-1
9985	983	1537	\N	3	1	0	1	-1
9986	1007	983	\N	3	1	0	1	-1
9987	1007	1447	\N	3	1	0	1	-1
9988	1007	1537	\N	3	1	0	1	-1
9989	1447	983	\N	3	1	0	1	-1
9990	1447	1007	\N	3	1	0	1	-1
9991	1447	1537	\N	3	1	0	1	-1
9992	1537	983	\N	3	1	0	1	-1
9993	1537	1007	\N	3	1	0	1	-1
9994	1537	1447	\N	3	1	0	1	-1
9995	984	1006	\N	3	1	0	1	-1
9996	984	1448	\N	3	1	0	1	-1
9997	984	1536	\N	3	1	0	1	-1
9998	1006	984	\N	3	1	0	1	-1
9999	1006	1448	\N	3	1	0	1	-1
10000	1006	1536	\N	3	1	0	1	-1
10001	1448	984	\N	3	1	0	1	-1
10002	1448	1006	\N	3	1	0	1	-1
10003	1448	1536	\N	3	1	0	1	-1
10004	1536	984	\N	3	1	0	1	-1
10005	1536	1006	\N	3	1	0	1	-1
10006	1536	1448	\N	3	1	0	1	-1
10007	985	1449	\N	3	1	0	1	-1
10008	1449	985	\N	3	1	0	1	-1
10009	988	1452	\N	3	1	0	1	-1
10010	1452	988	\N	3	1	0	1	-1
10011	1080	1093	\N	3	1	0	1	-1
10012	1093	1080	\N	3	1	0	1	-1
10013	1081	1092	\N	3	1	0	1	-1
10014	1092	1081	\N	3	1	0	1	-1
10015	1082	1091	\N	3	1	0	1	-1
10016	1091	1082	\N	3	1	0	1	-1
10017	1083	1090	\N	3	1	0	1	-1
10018	1090	1083	\N	3	1	0	1	-1
10019	1084	1089	\N	3	1	0	1	-1
10020	1089	1084	\N	3	1	0	1	-1
10021	1085	1088	\N	3	1	0	1	-1
10022	1088	1085	\N	3	1	0	1	-1
10023	1086	1087	\N	3	1	0	1	-1
10024	1087	1086	\N	3	1	0	1	-1
10025	1159	1172	\N	3	1	0	1	-1
10026	1172	1159	\N	3	1	0	1	-1
10027	1160	1171	\N	3	1	0	1	-1
10028	1171	1160	\N	3	1	0	1	-1
10029	1161	1170	\N	3	1	0	1	-1
10030	1170	1161	\N	3	1	0	1	-1
10031	1162	1169	\N	3	1	0	1	-1
10032	1169	1162	\N	3	1	0	1	-1
10033	1163	1168	\N	3	1	0	1	-1
10034	1168	1163	\N	3	1	0	1	-1
10035	1164	1167	\N	3	1	0	1	-1
10036	1167	1164	\N	3	1	0	1	-1
10037	1165	1166	\N	3	1	0	1	-1
10038	1166	1165	\N	3	1	0	1	-1
10039	1199	1270	\N	3	1	0	1	-1
10040	1199	1271	\N	3	1	0	1	-1
10041	1199	1318	\N	3	1	0	1	-1
10042	1199	1319	\N	3	1	0	1	-1
10043	1199	1371	\N	3	1	0	1	-1
10044	1270	1199	\N	3	1	0	1	-1
10045	1270	1271	\N	3	1	0	1	-1
10046	1270	1318	\N	3	1	0	1	-1
10047	1270	1319	\N	3	1	0	1	-1
10048	1270	1371	\N	3	1	0	1	-1
10049	1271	1199	\N	3	1	0	1	-1
10050	1271	1270	\N	3	1	0	1	-1
10051	1271	1318	\N	3	1	0	1	-1
10052	1271	1319	\N	3	1	0	1	-1
10053	1271	1371	\N	3	1	0	1	-1
10054	1318	1199	\N	3	1	0	1	-1
10055	1318	1270	\N	3	1	0	1	-1
10056	1318	1271	\N	3	1	0	1	-1
10057	1318	1319	\N	3	1	0	1	-1
10058	1318	1371	\N	3	1	0	1	-1
10059	1319	1199	\N	3	1	0	1	-1
10060	1319	1270	\N	3	1	0	1	-1
10061	1319	1271	\N	3	1	0	1	-1
10062	1319	1318	\N	3	1	0	1	-1
10063	1319	1371	\N	3	1	0	1	-1
10064	1371	1199	\N	3	1	0	1	-1
10065	1371	1270	\N	3	1	0	1	-1
10066	1371	1271	\N	3	1	0	1	-1
10067	1371	1318	\N	3	1	0	1	-1
10068	1371	1319	\N	3	1	0	1	-1
10069	1200	1269	\N	3	1	0	1	-1
10070	1200	1272	\N	3	1	0	1	-1
10071	1200	1317	\N	3	1	0	1	-1
10072	1200	1320	\N	3	1	0	1	-1
10073	1200	1370	\N	3	1	0	1	-1
10074	1269	1200	\N	3	1	0	1	-1
10075	1269	1272	\N	3	1	0	1	-1
10076	1269	1317	\N	3	1	0	1	-1
10077	1269	1320	\N	3	1	0	1	-1
10078	1269	1370	\N	3	1	0	1	-1
10079	1272	1200	\N	3	1	0	1	-1
10080	1272	1269	\N	3	1	0	1	-1
10081	1272	1317	\N	3	1	0	1	-1
10082	1272	1320	\N	3	1	0	1	-1
10083	1272	1370	\N	3	1	0	1	-1
10084	1317	1200	\N	3	1	0	1	-1
10085	1317	1269	\N	3	1	0	1	-1
10086	1317	1272	\N	3	1	0	1	-1
10087	1317	1320	\N	3	1	0	1	-1
10088	1317	1370	\N	3	1	0	1	-1
10089	1320	1200	\N	3	1	0	1	-1
10090	1320	1269	\N	3	1	0	1	-1
10091	1320	1272	\N	3	1	0	1	-1
10092	1320	1317	\N	3	1	0	1	-1
10093	1320	1370	\N	3	1	0	1	-1
10094	1370	1200	\N	3	1	0	1	-1
10095	1370	1269	\N	3	1	0	1	-1
10096	1370	1272	\N	3	1	0	1	-1
10097	1370	1317	\N	3	1	0	1	-1
10098	1370	1320	\N	3	1	0	1	-1
10099	1201	1268	\N	3	1	0	1	-1
10100	1201	1273	\N	3	1	0	1	-1
10101	1201	1316	\N	3	1	0	1	-1
10102	1201	1321	\N	3	1	0	1	-1
10103	1201	1369	\N	3	1	0	1	-1
10104	1268	1201	\N	3	1	0	1	-1
10105	1268	1273	\N	3	1	0	1	-1
10106	1268	1316	\N	3	1	0	1	-1
10107	1268	1321	\N	3	1	0	1	-1
10108	1268	1369	\N	3	1	0	1	-1
10109	1273	1201	\N	3	1	0	1	-1
10110	1273	1268	\N	3	1	0	1	-1
10111	1273	1316	\N	3	1	0	1	-1
10112	1273	1321	\N	3	1	0	1	-1
10113	1273	1369	\N	3	1	0	1	-1
10114	1316	1201	\N	3	1	0	1	-1
10115	1316	1268	\N	3	1	0	1	-1
10116	1316	1273	\N	3	1	0	1	-1
10117	1316	1321	\N	3	1	0	1	-1
10118	1316	1369	\N	3	1	0	1	-1
10119	1321	1201	\N	3	1	0	1	-1
10120	1321	1268	\N	3	1	0	1	-1
10121	1321	1273	\N	3	1	0	1	-1
10122	1321	1316	\N	3	1	0	1	-1
10123	1321	1369	\N	3	1	0	1	-1
10124	1369	1201	\N	3	1	0	1	-1
10125	1369	1268	\N	3	1	0	1	-1
10126	1369	1273	\N	3	1	0	1	-1
10127	1369	1316	\N	3	1	0	1	-1
10128	1369	1321	\N	3	1	0	1	-1
10129	1202	1267	\N	3	1	0	1	-1
10130	1202	1274	\N	3	1	0	1	-1
10131	1202	1315	\N	3	1	0	1	-1
10132	1202	1322	\N	3	1	0	1	-1
10133	1202	1368	\N	3	1	0	1	-1
10134	1267	1202	\N	3	1	0	1	-1
10135	1267	1274	\N	3	1	0	1	-1
10136	1267	1315	\N	3	1	0	1	-1
10137	1267	1322	\N	3	1	0	1	-1
10138	1267	1368	\N	3	1	0	1	-1
10139	1274	1202	\N	3	1	0	1	-1
10140	1274	1267	\N	3	1	0	1	-1
10141	1274	1315	\N	3	1	0	1	-1
10142	1274	1322	\N	3	1	0	1	-1
10143	1274	1368	\N	3	1	0	1	-1
10144	1315	1202	\N	3	1	0	1	-1
10145	1315	1267	\N	3	1	0	1	-1
10146	1315	1274	\N	3	1	0	1	-1
10147	1315	1322	\N	3	1	0	1	-1
10148	1315	1368	\N	3	1	0	1	-1
10149	1322	1202	\N	3	1	0	1	-1
10150	1322	1267	\N	3	1	0	1	-1
10151	1322	1274	\N	3	1	0	1	-1
10152	1322	1315	\N	3	1	0	1	-1
10153	1322	1368	\N	3	1	0	1	-1
10154	1368	1202	\N	3	1	0	1	-1
10155	1368	1267	\N	3	1	0	1	-1
10156	1368	1274	\N	3	1	0	1	-1
10157	1368	1315	\N	3	1	0	1	-1
10158	1368	1322	\N	3	1	0	1	-1
10159	1203	1266	\N	3	1	0	1	-1
10160	1203	1275	\N	3	1	0	1	-1
10161	1203	1314	\N	3	1	0	1	-1
10162	1203	1323	\N	3	1	0	1	-1
10163	1203	1367	\N	3	1	0	1	-1
10164	1266	1203	\N	3	1	0	1	-1
10165	1266	1275	\N	3	1	0	1	-1
10166	1266	1314	\N	3	1	0	1	-1
10167	1266	1323	\N	3	1	0	1	-1
10168	1266	1367	\N	3	1	0	1	-1
10169	1275	1203	\N	3	1	0	1	-1
10170	1275	1266	\N	3	1	0	1	-1
10171	1275	1314	\N	3	1	0	1	-1
10172	1275	1323	\N	3	1	0	1	-1
10173	1275	1367	\N	3	1	0	1	-1
10174	1314	1203	\N	3	1	0	1	-1
10175	1314	1266	\N	3	1	0	1	-1
10176	1314	1275	\N	3	1	0	1	-1
10177	1314	1323	\N	3	1	0	1	-1
10178	1314	1367	\N	3	1	0	1	-1
10179	1323	1203	\N	3	1	0	1	-1
10180	1323	1266	\N	3	1	0	1	-1
10181	1323	1275	\N	3	1	0	1	-1
10182	1323	1314	\N	3	1	0	1	-1
10183	1323	1367	\N	3	1	0	1	-1
10184	1367	1203	\N	3	1	0	1	-1
10185	1367	1266	\N	3	1	0	1	-1
10186	1367	1275	\N	3	1	0	1	-1
10187	1367	1314	\N	3	1	0	1	-1
10188	1367	1323	\N	3	1	0	1	-1
10189	1204	1265	\N	3	1	0	1	-1
10190	1204	1276	\N	3	1	0	1	-1
10191	1204	1313	\N	3	1	0	1	-1
10192	1204	1324	\N	3	1	0	1	-1
10193	1204	1366	\N	3	1	0	1	-1
10194	1265	1204	\N	3	1	0	1	-1
10195	1265	1276	\N	3	1	0	1	-1
10196	1265	1313	\N	3	1	0	1	-1
10197	1265	1324	\N	3	1	0	1	-1
10198	1265	1366	\N	3	1	0	1	-1
10199	1276	1204	\N	3	1	0	1	-1
10200	1276	1265	\N	3	1	0	1	-1
10201	1276	1313	\N	3	1	0	1	-1
10202	1276	1324	\N	3	1	0	1	-1
10203	1276	1366	\N	3	1	0	1	-1
10204	1313	1204	\N	3	1	0	1	-1
10205	1313	1265	\N	3	1	0	1	-1
10206	1313	1276	\N	3	1	0	1	-1
10207	1313	1324	\N	3	1	0	1	-1
10208	1313	1366	\N	3	1	0	1	-1
10209	1324	1204	\N	3	1	0	1	-1
10210	1324	1265	\N	3	1	0	1	-1
10211	1324	1276	\N	3	1	0	1	-1
10212	1324	1313	\N	3	1	0	1	-1
10213	1324	1366	\N	3	1	0	1	-1
10214	1366	1204	\N	3	1	0	1	-1
10215	1366	1265	\N	3	1	0	1	-1
10216	1366	1276	\N	3	1	0	1	-1
10217	1366	1313	\N	3	1	0	1	-1
10218	1366	1324	\N	3	1	0	1	-1
10219	1205	1264	\N	3	1	0	1	-1
10220	1205	1277	\N	3	1	0	1	-1
10221	1205	1312	\N	3	1	0	1	-1
10222	1205	1325	\N	3	1	0	1	-1
10223	1205	1365	\N	3	1	0	1	-1
10224	1264	1205	\N	3	1	0	1	-1
10225	1264	1277	\N	3	1	0	1	-1
10226	1264	1312	\N	3	1	0	1	-1
10227	1264	1325	\N	3	1	0	1	-1
10228	1264	1365	\N	3	1	0	1	-1
10229	1277	1205	\N	3	1	0	1	-1
10230	1277	1264	\N	3	1	0	1	-1
10231	1277	1312	\N	3	1	0	1	-1
10232	1277	1325	\N	3	1	0	1	-1
10233	1277	1365	\N	3	1	0	1	-1
10234	1312	1205	\N	3	1	0	1	-1
10235	1312	1264	\N	3	1	0	1	-1
10236	1312	1277	\N	3	1	0	1	-1
10237	1312	1325	\N	3	1	0	1	-1
10238	1312	1365	\N	3	1	0	1	-1
10239	1325	1205	\N	3	1	0	1	-1
10240	1325	1264	\N	3	1	0	1	-1
10241	1325	1277	\N	3	1	0	1	-1
10242	1325	1312	\N	3	1	0	1	-1
10243	1325	1365	\N	3	1	0	1	-1
10244	1365	1205	\N	3	1	0	1	-1
10245	1365	1264	\N	3	1	0	1	-1
10246	1365	1277	\N	3	1	0	1	-1
10247	1365	1312	\N	3	1	0	1	-1
10248	1365	1325	\N	3	1	0	1	-1
10249	1206	1263	\N	3	1	0	1	-1
10250	1206	1278	\N	3	1	0	1	-1
10251	1206	1311	\N	3	1	0	1	-1
10252	1206	1326	\N	3	1	0	1	-1
10253	1206	1364	\N	3	1	0	1	-1
10254	1263	1206	\N	3	1	0	1	-1
10255	1263	1278	\N	3	1	0	1	-1
10256	1263	1311	\N	3	1	0	1	-1
10257	1263	1326	\N	3	1	0	1	-1
10258	1263	1364	\N	3	1	0	1	-1
10259	1278	1206	\N	3	1	0	1	-1
10260	1278	1263	\N	3	1	0	1	-1
10261	1278	1311	\N	3	1	0	1	-1
10262	1278	1326	\N	3	1	0	1	-1
10263	1278	1364	\N	3	1	0	1	-1
10264	1311	1206	\N	3	1	0	1	-1
10265	1311	1263	\N	3	1	0	1	-1
10266	1311	1278	\N	3	1	0	1	-1
10267	1311	1326	\N	3	1	0	1	-1
10268	1311	1364	\N	3	1	0	1	-1
10269	1326	1206	\N	3	1	0	1	-1
10270	1326	1263	\N	3	1	0	1	-1
10271	1326	1278	\N	3	1	0	1	-1
10272	1326	1311	\N	3	1	0	1	-1
10273	1326	1364	\N	3	1	0	1	-1
10274	1364	1206	\N	3	1	0	1	-1
10275	1364	1263	\N	3	1	0	1	-1
10276	1364	1278	\N	3	1	0	1	-1
10277	1364	1311	\N	3	1	0	1	-1
10278	1364	1326	\N	3	1	0	1	-1
10279	1207	1262	\N	3	1	0	1	-1
10280	1207	1279	\N	3	1	0	1	-1
10281	1207	1310	\N	3	1	0	1	-1
10282	1207	1327	\N	3	1	0	1	-1
10283	1207	1363	\N	3	1	0	1	-1
10284	1262	1207	\N	3	1	0	1	-1
10285	1262	1279	\N	3	1	0	1	-1
10286	1262	1310	\N	3	1	0	1	-1
10287	1262	1327	\N	3	1	0	1	-1
10288	1262	1363	\N	3	1	0	1	-1
10289	1279	1207	\N	3	1	0	1	-1
10290	1279	1262	\N	3	1	0	1	-1
10291	1279	1310	\N	3	1	0	1	-1
10292	1279	1327	\N	3	1	0	1	-1
10293	1279	1363	\N	3	1	0	1	-1
10294	1310	1207	\N	3	1	0	1	-1
10295	1310	1262	\N	3	1	0	1	-1
10296	1310	1279	\N	3	1	0	1	-1
10297	1310	1327	\N	3	1	0	1	-1
10298	1310	1363	\N	3	1	0	1	-1
10299	1327	1207	\N	3	1	0	1	-1
10300	1327	1262	\N	3	1	0	1	-1
10301	1327	1279	\N	3	1	0	1	-1
10302	1327	1310	\N	3	1	0	1	-1
10303	1327	1363	\N	3	1	0	1	-1
10304	1363	1207	\N	3	1	0	1	-1
10305	1363	1262	\N	3	1	0	1	-1
10306	1363	1279	\N	3	1	0	1	-1
10307	1363	1310	\N	3	1	0	1	-1
10308	1363	1327	\N	3	1	0	1	-1
10309	1208	1261	\N	3	1	0	1	-1
10310	1208	1280	\N	3	1	0	1	-1
10311	1208	1309	\N	3	1	0	1	-1
10312	1208	1328	\N	3	1	0	1	-1
10313	1208	1362	\N	3	1	0	1	-1
10314	1261	1208	\N	3	1	0	1	-1
10315	1261	1280	\N	3	1	0	1	-1
10316	1261	1309	\N	3	1	0	1	-1
10317	1261	1328	\N	3	1	0	1	-1
10318	1261	1362	\N	3	1	0	1	-1
10319	1280	1208	\N	3	1	0	1	-1
10320	1280	1261	\N	3	1	0	1	-1
10321	1280	1309	\N	3	1	0	1	-1
10322	1280	1328	\N	3	1	0	1	-1
10323	1280	1362	\N	3	1	0	1	-1
10324	1309	1208	\N	3	1	0	1	-1
10325	1309	1261	\N	3	1	0	1	-1
10326	1309	1280	\N	3	1	0	1	-1
10327	1309	1328	\N	3	1	0	1	-1
10328	1309	1362	\N	3	1	0	1	-1
10329	1328	1208	\N	3	1	0	1	-1
10330	1328	1261	\N	3	1	0	1	-1
10331	1328	1280	\N	3	1	0	1	-1
10332	1328	1309	\N	3	1	0	1	-1
10333	1328	1362	\N	3	1	0	1	-1
10334	1362	1208	\N	3	1	0	1	-1
10335	1362	1261	\N	3	1	0	1	-1
10336	1362	1280	\N	3	1	0	1	-1
10337	1362	1309	\N	3	1	0	1	-1
10338	1362	1328	\N	3	1	0	1	-1
10339	1209	1260	\N	3	1	0	1	-1
10340	1209	1281	\N	3	1	0	1	-1
10341	1209	1308	\N	3	1	0	1	-1
10342	1209	1329	\N	3	1	0	1	-1
10343	1209	1361	\N	3	1	0	1	-1
10344	1260	1209	\N	3	1	0	1	-1
10345	1260	1281	\N	3	1	0	1	-1
10346	1260	1308	\N	3	1	0	1	-1
10347	1260	1329	\N	3	1	0	1	-1
10348	1260	1361	\N	3	1	0	1	-1
10349	1281	1209	\N	3	1	0	1	-1
10350	1281	1260	\N	3	1	0	1	-1
10351	1281	1308	\N	3	1	0	1	-1
10352	1281	1329	\N	3	1	0	1	-1
10353	1281	1361	\N	3	1	0	1	-1
10354	1308	1209	\N	3	1	0	1	-1
10355	1308	1260	\N	3	1	0	1	-1
10356	1308	1281	\N	3	1	0	1	-1
10357	1308	1329	\N	3	1	0	1	-1
10358	1308	1361	\N	3	1	0	1	-1
10359	1329	1209	\N	3	1	0	1	-1
10360	1329	1260	\N	3	1	0	1	-1
10361	1329	1281	\N	3	1	0	1	-1
10362	1329	1308	\N	3	1	0	1	-1
10363	1329	1361	\N	3	1	0	1	-1
10364	1361	1209	\N	3	1	0	1	-1
10365	1361	1260	\N	3	1	0	1	-1
10366	1361	1281	\N	3	1	0	1	-1
10367	1361	1308	\N	3	1	0	1	-1
10368	1361	1329	\N	3	1	0	1	-1
10369	1383	1394	\N	3	1	0	1	-1
10370	1394	1383	\N	3	1	0	1	-1
10371	1384	1393	\N	3	1	0	1	-1
10372	1393	1384	\N	3	1	0	1	-1
10373	1385	1392	\N	3	1	0	1	-1
10374	1392	1385	\N	3	1	0	1	-1
10375	1386	1391	\N	3	1	0	1	-1
10376	1391	1386	\N	3	1	0	1	-1
10377	1387	1390	\N	3	1	0	1	-1
10378	1390	1387	\N	3	1	0	1	-1
10379	1388	1389	\N	3	1	0	1	-1
10380	1389	1388	\N	3	1	0	1	-1
10381	1413	1424	\N	3	1	0	1	-1
10382	1424	1413	\N	3	1	0	1	-1
10383	1414	1423	\N	3	1	0	1	-1
10384	1423	1414	\N	3	1	0	1	-1
10385	1415	1422	\N	3	1	0	1	-1
10386	1422	1415	\N	3	1	0	1	-1
10387	1416	1421	\N	3	1	0	1	-1
10388	1421	1416	\N	3	1	0	1	-1
10389	1417	1420	\N	3	1	0	1	-1
10390	1420	1417	\N	3	1	0	1	-1
10391	1418	1419	\N	3	1	0	1	-1
10392	1419	1418	\N	3	1	0	1	-1
10393	1435	1550	\N	3	1	0	1	-1
10394	1550	1435	\N	3	1	0	1	-1
10395	1436	1549	\N	3	1	0	1	-1
10396	1549	1436	\N	3	1	0	1	-1
10397	1437	1548	\N	3	1	0	1	-1
10398	1548	1437	\N	3	1	0	1	-1
10399	1438	1547	\N	3	1	0	1	-1
10400	1547	1438	\N	3	1	0	1	-1
10401	1439	1546	\N	3	1	0	1	-1
10402	1546	1439	\N	3	1	0	1	-1
10403	1440	1545	\N	3	1	0	1	-1
10404	1545	1440	\N	3	1	0	1	-1
10405	1441	1544	\N	3	1	0	1	-1
10406	1544	1441	\N	3	1	0	1	-1
10407	3	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10408	40	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10409	45	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10410	92	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10411	104	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10412	118	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10413	150	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10414	164	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10415	339	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10416	353	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10417	395	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10418	415	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10419	430	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10420	513	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10421	557	737	\N	0.939635790367119	1	0.07830298253059324	1	-1
10422	3	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10423	40	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10424	45	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10425	92	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10426	104	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10427	118	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10428	150	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10429	164	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10430	339	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10431	353	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10432	395	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10433	415	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10434	430	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10435	513	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10436	557	381	\N	0.9412449852612697	1	0.0784370821051058	1	-1
10437	4	738	\N	0.12	1	0.01	1	-1
10438	39	738	\N	0.12	1	0.01	1	-1
10439	46	738	\N	0.12	1	0.01	1	-1
10440	91	738	\N	0.12	1	0.01	1	-1
10441	105	738	\N	0.12	1	0.01	1	-1
10442	117	738	\N	0.12	1	0.01	1	-1
10443	151	738	\N	0.12	1	0.01	1	-1
10444	163	738	\N	0.12	1	0.01	1	-1
10445	340	738	\N	0.12	1	0.01	1	-1
10446	352	738	\N	0.12	1	0.01	1	-1
10447	382	738	\N	0.12	1	0.01	1	-1
10448	394	738	\N	0.12	1	0.01	1	-1
10449	414	738	\N	0.12	1	0.01	1	-1
10450	431	738	\N	0.12	1	0.01	1	-1
10451	514	738	\N	0.12	1	0.01	1	-1
10452	556	738	\N	0.12	1	0.01	1	-1
10453	692	738	\N	0.12	1	0.01	1	-1
10454	725	738	\N	0.12	1	0.01	1	-1
10455	4	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10456	4	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10457	39	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10458	39	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10459	46	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10460	46	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10461	91	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10462	91	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10463	105	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10464	105	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10465	117	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10466	117	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10467	151	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10468	151	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10469	163	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10470	163	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10471	340	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10472	340	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10473	352	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10474	352	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10475	382	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10476	382	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10477	394	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10478	394	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10479	414	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10480	414	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10481	431	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10482	431	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10483	514	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10484	514	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10485	556	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10486	556	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10487	692	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10488	692	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10489	725	693	\N	1.571972817625759	1	0.13099773480214658	1	-1
10490	725	724	\N	1.571972817625759	1	0.13099773480214658	1	-1
10491	7	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10492	36	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10493	49	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10494	88	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10495	108	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10496	114	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10497	154	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10498	160	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10499	204	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10500	235	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10501	343	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10502	349	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10503	385	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10504	391	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10505	411	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10506	728	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10507	1062	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10508	1113	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10509	1376	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10510	1401	447	\N	0.28515810962242405	1	0.02376317580186867	1	-1
10511	7	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10512	7	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10513	7	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10514	36	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10515	36	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10516	36	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10517	49	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10518	49	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10519	49	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10520	88	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10521	88	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10522	88	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10523	108	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10524	108	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10525	108	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10526	114	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10527	114	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10528	114	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10529	154	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10530	154	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10531	154	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10532	160	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10533	160	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10534	160	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10535	204	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10536	204	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10537	204	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10538	235	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10539	235	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10540	235	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10541	343	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10542	343	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10543	343	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10544	349	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10545	349	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10546	349	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10547	385	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10548	385	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10549	385	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10550	391	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10551	391	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10552	391	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10553	411	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10554	411	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10555	411	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10556	728	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10557	728	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10558	728	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10559	1062	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10560	1062	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10561	1062	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10562	1113	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10563	1113	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10564	1113	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10565	1376	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10566	1376	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10567	1376	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10568	1401	501	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10569	1401	778	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10570	1401	817	\N	1.6113726196594202	1	0.13428105163828502	1	-1
10571	8	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10572	8	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10573	8	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10574	8	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10575	8	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10576	8	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10577	8	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10578	8	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10579	8	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10580	8	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10581	8	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10582	8	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10583	8	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10584	8	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10585	50	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10586	50	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10587	50	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10588	50	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10589	50	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10590	50	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10591	50	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10592	50	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10593	50	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10594	50	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10595	50	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10596	50	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10597	50	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10598	50	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10599	109	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10600	109	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10601	109	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10602	109	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10603	109	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10604	109	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10605	109	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10606	109	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10607	109	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10608	109	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10609	109	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10610	109	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10611	109	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10612	109	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10613	110	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10614	110	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10615	110	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10616	110	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10617	110	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10618	110	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10619	110	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10620	110	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10621	110	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10622	110	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10623	110	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10624	110	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10625	110	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10626	110	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10627	155	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10628	155	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10629	155	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10630	155	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10631	155	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10632	155	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10633	155	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10634	155	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10635	155	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10636	155	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10637	155	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10638	155	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10639	155	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10640	155	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10641	156	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10642	156	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10643	156	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10644	156	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10645	156	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10646	156	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10647	156	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10648	156	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10649	156	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10650	156	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10651	156	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10652	156	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10653	156	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10654	156	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10655	205	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10656	205	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10657	205	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10658	205	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10659	205	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10660	205	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10661	205	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10662	205	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10663	205	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10664	205	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10665	205	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10666	205	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10667	205	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10668	205	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10669	344	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10670	344	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10671	344	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10672	344	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10673	344	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10674	344	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10675	344	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10676	344	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10677	344	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10678	344	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10679	344	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10680	344	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10681	344	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10682	344	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10683	386	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10684	386	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10685	386	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10686	386	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10687	386	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10688	386	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10689	386	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10690	386	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10691	386	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10692	386	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10693	386	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10694	386	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10695	386	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10696	386	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10697	436	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10698	436	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10699	436	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10700	436	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10701	436	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10702	436	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10703	436	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10704	436	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10705	436	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10706	436	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10707	436	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10708	436	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10709	436	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10710	436	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10711	559	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10712	559	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10713	559	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10714	559	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10715	559	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10716	559	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10717	559	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10718	559	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10719	559	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10720	559	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10721	559	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10722	559	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10723	559	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10724	559	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10725	588	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10726	588	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10727	588	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10728	588	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10729	588	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10730	588	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10731	588	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10732	588	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10733	588	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10734	588	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10735	588	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10736	588	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10737	588	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10738	588	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10739	589	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10740	589	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10741	589	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10742	589	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10743	589	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10744	589	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10745	589	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10746	589	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10747	589	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10748	589	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10749	589	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10750	589	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10751	589	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10752	589	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10753	634	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10754	634	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10755	634	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10756	634	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10757	634	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10758	634	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10759	634	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10760	634	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10761	634	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10762	634	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10763	634	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10764	634	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10765	634	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10766	634	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10767	683	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10768	683	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10769	683	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10770	683	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10771	683	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10772	683	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10773	683	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10774	683	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10775	683	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10776	683	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10777	683	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10778	683	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10779	683	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10780	683	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10781	729	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10782	729	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10783	729	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10784	729	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10785	729	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10786	729	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10787	729	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10788	729	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10789	729	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10790	729	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10791	729	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10792	729	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10793	729	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10794	729	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10795	1130	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10796	1130	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10797	1130	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10798	1130	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10799	1130	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10800	1130	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10801	1130	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10802	1130	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10803	1130	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10804	1130	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10805	1130	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10806	1130	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10807	1130	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10808	1130	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10809	1198	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10810	1198	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10811	1198	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10812	1198	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10813	1198	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10814	1198	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10815	1198	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10816	1198	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10817	1198	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10818	1198	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10819	1198	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10820	1198	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10821	1198	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10822	1198	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10823	1344	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10824	1344	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10825	1344	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10826	1344	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10827	1344	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10828	1344	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10829	1344	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10830	1344	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10831	1344	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10832	1344	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10833	1344	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10834	1344	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10835	1344	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10836	1344	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10837	1345	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10838	1345	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10839	1345	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10840	1345	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10841	1345	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10842	1345	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10843	1345	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10844	1345	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10845	1345	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10846	1345	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10847	1345	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10848	1345	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10849	1345	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10850	1345	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10851	1372	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10852	1372	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10853	1372	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10854	1372	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10855	1372	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10856	1372	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10857	1372	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10858	1372	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10859	1372	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10860	1372	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10861	1372	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10862	1372	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10863	1372	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10864	1372	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10865	1402	35	\N	2.008214482062776	1	0.16735120683856466	1	-1
10866	1402	87	\N	2.008214482062776	1	0.16735120683856466	1	-1
10867	1402	113	\N	2.008214482062776	1	0.16735120683856466	1	-1
10868	1402	159	\N	2.008214482062776	1	0.16735120683856466	1	-1
10869	1402	234	\N	2.008214482062776	1	0.16735120683856466	1	-1
10870	1402	348	\N	2.008214482062776	1	0.16735120683856466	1	-1
10871	1402	390	\N	2.008214482062776	1	0.16735120683856466	1	-1
10872	1402	410	\N	2.008214482062776	1	0.16735120683856466	1	-1
10873	1402	587	\N	2.008214482062776	1	0.16735120683856466	1	-1
10874	1402	633	\N	2.008214482062776	1	0.16735120683856466	1	-1
10875	1402	1112	\N	2.008214482062776	1	0.16735120683856466	1	-1
10876	1402	1197	\N	2.008214482062776	1	0.16735120683856466	1	-1
10877	1402	1343	\N	2.008214482062776	1	0.16735120683856466	1	-1
10878	1402	1375	\N	2.008214482062776	1	0.16735120683856466	1	-1
10879	8	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10880	50	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10881	109	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10882	110	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10883	155	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10884	156	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10885	205	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10886	344	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10887	386	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10888	436	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10889	559	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10890	588	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10891	589	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10892	634	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10893	683	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10894	729	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10895	1130	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10896	1198	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10897	1344	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10898	1345	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10899	1372	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10900	1402	816	\N	2.0589946606265945	1	0.17158288838554955	1	-1
10901	12	862	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10902	12	924	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10903	29	862	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10904	29	924	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10905	54	862	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10906	54	924	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10907	81	862	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10908	81	924	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10909	925	862	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10910	925	924	\N	2.4170013214456487	1	0.20141677678713737	1	-1
10911	14	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10912	14	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10913	14	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10914	14	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10915	14	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10916	14	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10917	14	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10918	14	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10919	14	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10920	14	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10921	14	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10922	14	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10923	27	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10924	27	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10925	27	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10926	27	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10927	27	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10928	27	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10929	27	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10930	27	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10931	27	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10932	27	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10933	27	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10934	27	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10935	56	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10936	56	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10937	56	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10938	56	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10939	56	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10940	56	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10941	56	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10942	56	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10943	56	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10944	56	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10945	56	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10946	56	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10947	79	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10948	79	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10949	79	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10950	79	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10951	79	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10952	79	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10953	79	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10954	79	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10955	79	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10956	79	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10957	79	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10958	79	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10959	860	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10960	860	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10961	860	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10962	860	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10963	860	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10964	860	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10965	860	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10966	860	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10967	860	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10968	860	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10969	860	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10970	860	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10971	927	15	\N	2.58369865016816	1	0.21530822084734666	1	-1
10972	927	26	\N	2.58369865016816	1	0.21530822084734666	1	-1
10973	927	57	\N	2.58369865016816	1	0.21530822084734666	1	-1
10974	927	78	\N	2.58369865016816	1	0.21530822084734666	1	-1
10975	927	277	\N	2.58369865016816	1	0.21530822084734666	1	-1
10976	927	298	\N	2.58369865016816	1	0.21530822084734666	1	-1
10977	927	859	\N	2.58369865016816	1	0.21530822084734666	1	-1
10978	927	928	\N	2.58369865016816	1	0.21530822084734666	1	-1
10979	927	975	\N	2.58369865016816	1	0.21530822084734666	1	-1
10980	927	1015	\N	2.58369865016816	1	0.21530822084734666	1	-1
10981	927	1489	\N	2.58369865016816	1	0.21530822084734666	1	-1
10982	927	1496	\N	2.58369865016816	1	0.21530822084734666	1	-1
10983	15	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
10984	15	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
10985	15	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
10986	15	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
10987	15	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
10988	15	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
10989	26	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
10990	26	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
10991	26	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
10992	26	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
10993	26	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
10994	26	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
10995	57	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
10996	57	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
10997	57	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
10998	57	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
10999	57	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11000	57	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11001	78	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11002	78	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11003	78	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11004	78	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11005	78	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11006	78	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11007	277	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11008	277	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11009	277	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11010	277	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11011	277	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11012	277	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11013	298	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11014	298	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11015	298	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11016	298	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11017	298	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11018	298	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11019	859	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11020	859	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11021	859	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11022	859	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11023	859	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11024	859	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11025	928	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11026	928	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11027	928	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11028	928	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11029	928	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11030	928	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11031	975	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11032	975	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11033	975	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11034	975	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11035	975	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11036	975	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11037	1015	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11038	1015	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11039	1015	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11040	1015	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11041	1015	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11042	1015	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11043	1489	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11044	1489	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11045	1489	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11046	1489	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11047	1489	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11048	1489	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11049	1496	14	\N	2.58369865016816	1	0.21530822084734666	1	-1
11050	1496	27	\N	2.58369865016816	1	0.21530822084734666	1	-1
11051	1496	56	\N	2.58369865016816	1	0.21530822084734666	1	-1
11052	1496	79	\N	2.58369865016816	1	0.21530822084734666	1	-1
11053	1496	860	\N	2.58369865016816	1	0.21530822084734666	1	-1
11054	1496	927	\N	2.58369865016816	1	0.21530822084734666	1	-1
11055	33	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11056	33	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11057	85	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11058	85	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11059	111	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11060	111	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11061	157	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11062	157	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11063	345	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11064	345	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11065	346	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11066	346	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11067	387	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11068	387	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11069	388	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11070	388	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11071	408	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11072	408	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11073	437	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11074	437	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11075	561	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11076	561	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11077	591	813	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11078	591	814	\N	2.0837710545854815	1	0.17364758788212348	1	-1
11079	33	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11080	33	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11081	33	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11082	33	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11083	33	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11084	85	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11085	85	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11086	85	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11087	85	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11088	85	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11089	111	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11090	111	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11091	111	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11092	111	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11093	111	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11094	157	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11095	157	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11096	157	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11097	157	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11098	157	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11099	345	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11100	345	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11101	345	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11102	345	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11103	345	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11104	346	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11105	346	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11106	346	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11107	346	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11108	346	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11109	387	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11110	387	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11111	387	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11112	387	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11113	387	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11114	388	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11115	388	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11116	388	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11117	388	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11118	388	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11119	408	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11120	408	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11121	408	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11122	408	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11123	408	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11124	437	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11125	437	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11126	437	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11127	437	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11128	437	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11129	561	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11130	561	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11131	561	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11132	561	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11133	561	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11134	591	206	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11135	591	684	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11136	591	1131	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11137	591	1346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11138	591	1373	\N	2.9258740958319693	1	0.24382284131933077	1	-1
11139	34	815	\N	0.12	1	0.01	1	-1
11140	86	815	\N	0.12	1	0.01	1	-1
11141	112	815	\N	0.12	1	0.01	1	-1
11142	158	815	\N	0.12	1	0.01	1	-1
11143	207	815	\N	0.12	1	0.01	1	-1
11144	347	815	\N	0.12	1	0.01	1	-1
11145	389	815	\N	0.12	1	0.01	1	-1
11146	409	815	\N	0.12	1	0.01	1	-1
11147	586	815	\N	0.12	1	0.01	1	-1
11148	632	815	\N	0.12	1	0.01	1	-1
11149	686	815	\N	0.12	1	0.01	1	-1
11150	1132	815	\N	0.12	1	0.01	1	-1
11151	1347	815	\N	0.12	1	0.01	1	-1
11152	1374	815	\N	0.12	1	0.01	1	-1
11153	34	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11154	34	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11155	34	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11156	86	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11157	86	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11158	86	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11159	112	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11160	112	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11161	112	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11162	158	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11163	158	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11164	158	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11165	207	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11166	207	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11167	207	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11168	347	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11169	347	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11170	347	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11171	389	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11172	389	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11173	389	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11174	409	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11175	409	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11176	409	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11177	586	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11178	586	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11179	586	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11180	632	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11181	632	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11182	632	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11183	686	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11184	686	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11185	686	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11186	1132	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11187	1132	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11188	1132	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11189	1347	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11190	1347	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11191	1347	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11192	1374	585	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11193	1374	631	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11194	1374	685	\N	0.6237606479679764	1	0.05198005399733137	1	-1
11195	35	816	\N	0.12	1	0.01	1	-1
11196	87	816	\N	0.12	1	0.01	1	-1
11197	113	816	\N	0.12	1	0.01	1	-1
11198	159	816	\N	0.12	1	0.01	1	-1
11199	234	816	\N	0.12	1	0.01	1	-1
11200	348	816	\N	0.12	1	0.01	1	-1
11201	390	816	\N	0.12	1	0.01	1	-1
11202	410	816	\N	0.12	1	0.01	1	-1
11203	587	816	\N	0.12	1	0.01	1	-1
11204	633	816	\N	0.12	1	0.01	1	-1
11205	1112	816	\N	0.12	1	0.01	1	-1
11206	1197	816	\N	0.12	1	0.01	1	-1
11207	1343	816	\N	0.12	1	0.01	1	-1
11208	1375	816	\N	0.12	1	0.01	1	-1
11209	35	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11210	35	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11211	35	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11212	35	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11213	35	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11214	35	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11215	35	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11216	35	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11217	35	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11218	35	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11219	35	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11220	35	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11221	35	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11222	35	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11223	35	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11224	35	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11225	35	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11226	35	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11227	35	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11228	35	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11229	35	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11230	35	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11231	87	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11232	87	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11233	87	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11234	87	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11235	87	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11236	87	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11237	87	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11238	87	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11239	87	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11240	87	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11241	87	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11242	87	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11243	87	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11244	87	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11245	87	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11246	87	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11247	87	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11248	87	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11249	87	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11250	87	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11251	87	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11252	87	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11253	113	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11254	113	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11255	113	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11256	113	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11257	113	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11258	113	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11259	113	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11260	113	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11261	113	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11262	113	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11263	113	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11264	113	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11265	113	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11266	113	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11267	113	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11268	113	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11269	113	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11270	113	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11271	113	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11272	113	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11273	113	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11274	113	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11275	159	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11276	159	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11277	159	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11278	159	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11279	159	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11280	159	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11281	159	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11282	159	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11283	159	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11284	159	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11285	159	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11286	159	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11287	159	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11288	159	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11289	159	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11290	159	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11291	159	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11292	159	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11293	159	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11294	159	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11295	159	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11296	159	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11297	234	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11298	234	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11299	234	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11300	234	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11301	234	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11302	234	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11303	234	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11304	234	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11305	234	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11306	234	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11307	234	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11308	234	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11309	234	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11310	234	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11311	234	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11312	234	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11313	234	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11314	234	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11315	234	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11316	234	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11317	234	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11318	234	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11319	348	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11320	348	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11321	348	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11322	348	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11323	348	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11324	348	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11325	348	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11326	348	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11327	348	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11328	348	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11329	348	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11330	348	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11331	348	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11332	348	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11333	348	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11334	348	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11335	348	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11336	348	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11337	348	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11338	348	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11339	348	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11340	348	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11341	390	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11342	390	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11343	390	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11344	390	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11345	390	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11346	390	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11347	390	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11348	390	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11349	390	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11350	390	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11351	390	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11352	390	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11353	390	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11354	390	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11355	390	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11356	390	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11357	390	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11358	390	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11359	390	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11360	390	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11361	390	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11362	390	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11363	410	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11364	410	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11365	410	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11366	410	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11367	410	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11368	410	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11369	410	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11370	410	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11371	410	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11372	410	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11373	410	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11374	410	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11375	410	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11376	410	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11377	410	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11378	410	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11379	410	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11380	410	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11381	410	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11382	410	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11383	410	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11384	410	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11385	587	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11386	587	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11387	587	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11388	587	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11389	587	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11390	587	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11391	587	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11392	587	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11393	587	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11394	587	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11395	587	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11396	587	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11397	587	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11398	587	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11399	587	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11400	587	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11401	587	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11402	587	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11403	587	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11404	587	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11405	587	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11406	587	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11407	633	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11408	633	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11409	633	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11410	633	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11411	633	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11412	633	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11413	633	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11414	633	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11415	633	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11416	633	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11417	633	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11418	633	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11419	633	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11420	633	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11421	633	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11422	633	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11423	633	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11424	633	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11425	633	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11426	633	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11427	633	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11428	633	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11429	1112	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11430	1112	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11431	1112	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11432	1112	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11433	1112	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11434	1112	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11435	1112	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11436	1112	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11437	1112	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11438	1112	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11439	1112	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11440	1112	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11441	1112	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11442	1112	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11443	1112	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11444	1112	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11445	1112	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11446	1112	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11447	1112	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11448	1112	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11449	1112	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11450	1112	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11451	1197	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11452	1197	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11453	1197	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11454	1197	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11455	1197	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11456	1197	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11457	1197	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11458	1197	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11459	1197	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11460	1197	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11461	1197	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11462	1197	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11463	1197	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11464	1197	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11465	1197	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11466	1197	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11467	1197	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11468	1197	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11469	1197	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11470	1197	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11471	1197	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11472	1197	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11473	1343	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11474	1343	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11475	1343	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11476	1343	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11477	1343	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11478	1343	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11479	1343	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11480	1343	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11481	1343	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11482	1343	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11483	1343	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11484	1343	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11485	1343	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11486	1343	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11487	1343	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11488	1343	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11489	1343	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11490	1343	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11491	1343	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11492	1343	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11493	1343	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11494	1343	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11495	1375	8	\N	2.008214482062776	1	0.16735120683856466	1	-1
11496	1375	50	\N	2.008214482062776	1	0.16735120683856466	1	-1
11497	1375	109	\N	2.008214482062776	1	0.16735120683856466	1	-1
11498	1375	110	\N	2.008214482062776	1	0.16735120683856466	1	-1
11499	1375	155	\N	2.008214482062776	1	0.16735120683856466	1	-1
11500	1375	156	\N	2.008214482062776	1	0.16735120683856466	1	-1
11501	1375	205	\N	2.008214482062776	1	0.16735120683856466	1	-1
11502	1375	344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11503	1375	386	\N	2.008214482062776	1	0.16735120683856466	1	-1
11504	1375	436	\N	2.008214482062776	1	0.16735120683856466	1	-1
11505	1375	559	\N	2.008214482062776	1	0.16735120683856466	1	-1
11506	1375	588	\N	2.008214482062776	1	0.16735120683856466	1	-1
11507	1375	589	\N	2.008214482062776	1	0.16735120683856466	1	-1
11508	1375	634	\N	2.008214482062776	1	0.16735120683856466	1	-1
11509	1375	683	\N	2.008214482062776	1	0.16735120683856466	1	-1
11510	1375	729	\N	2.008214482062776	1	0.16735120683856466	1	-1
11511	1375	1130	\N	2.008214482062776	1	0.16735120683856466	1	-1
11512	1375	1198	\N	2.008214482062776	1	0.16735120683856466	1	-1
11513	1375	1344	\N	2.008214482062776	1	0.16735120683856466	1	-1
11514	1375	1345	\N	2.008214482062776	1	0.16735120683856466	1	-1
11515	1375	1372	\N	2.008214482062776	1	0.16735120683856466	1	-1
11516	1375	1402	\N	2.008214482062776	1	0.16735120683856466	1	-1
11517	101	534	\N	0.12	1	0.01	1	-1
11518	101	536	\N	0.12	1	0.01	1	-1
11519	101	948	\N	0.12	1	0.01	1	-1
11520	101	1042	\N	0.12	1	0.01	1	-1
11521	101	1221	\N	0.12	1	0.01	1	-1
11522	101	1248	\N	0.12	1	0.01	1	-1
11523	101	1293	\N	0.12	1	0.01	1	-1
11524	101	1296	\N	0.12	1	0.01	1	-1
11525	101	1404	\N	0.12	1	0.01	1	-1
11526	101	1433	\N	0.12	1	0.01	1	-1
11527	101	1462	\N	0.12	1	0.01	1	-1
11528	101	1523	\N	0.12	1	0.01	1	-1
11529	121	534	\N	0.12	1	0.01	1	-1
11530	121	536	\N	0.12	1	0.01	1	-1
11531	121	948	\N	0.12	1	0.01	1	-1
11532	121	1042	\N	0.12	1	0.01	1	-1
11533	121	1221	\N	0.12	1	0.01	1	-1
11534	121	1248	\N	0.12	1	0.01	1	-1
11535	121	1293	\N	0.12	1	0.01	1	-1
11536	121	1296	\N	0.12	1	0.01	1	-1
11537	121	1404	\N	0.12	1	0.01	1	-1
11538	121	1433	\N	0.12	1	0.01	1	-1
11539	121	1462	\N	0.12	1	0.01	1	-1
11540	121	1523	\N	0.12	1	0.01	1	-1
11541	147	534	\N	0.12	1	0.01	1	-1
11542	147	536	\N	0.12	1	0.01	1	-1
11543	147	948	\N	0.12	1	0.01	1	-1
11544	147	1042	\N	0.12	1	0.01	1	-1
11545	147	1221	\N	0.12	1	0.01	1	-1
11546	147	1248	\N	0.12	1	0.01	1	-1
11547	147	1293	\N	0.12	1	0.01	1	-1
11548	147	1296	\N	0.12	1	0.01	1	-1
11549	147	1404	\N	0.12	1	0.01	1	-1
11550	147	1433	\N	0.12	1	0.01	1	-1
11551	147	1462	\N	0.12	1	0.01	1	-1
11552	147	1523	\N	0.12	1	0.01	1	-1
11553	167	534	\N	0.12	1	0.01	1	-1
11554	167	536	\N	0.12	1	0.01	1	-1
11555	167	948	\N	0.12	1	0.01	1	-1
11556	167	1042	\N	0.12	1	0.01	1	-1
11557	167	1221	\N	0.12	1	0.01	1	-1
11558	167	1248	\N	0.12	1	0.01	1	-1
11559	167	1293	\N	0.12	1	0.01	1	-1
11560	167	1296	\N	0.12	1	0.01	1	-1
11561	167	1404	\N	0.12	1	0.01	1	-1
11562	167	1433	\N	0.12	1	0.01	1	-1
11563	167	1462	\N	0.12	1	0.01	1	-1
11564	167	1523	\N	0.12	1	0.01	1	-1
11565	336	534	\N	0.12	1	0.01	1	-1
11566	336	536	\N	0.12	1	0.01	1	-1
11567	336	948	\N	0.12	1	0.01	1	-1
11568	336	1042	\N	0.12	1	0.01	1	-1
11569	336	1221	\N	0.12	1	0.01	1	-1
11570	336	1248	\N	0.12	1	0.01	1	-1
11571	336	1293	\N	0.12	1	0.01	1	-1
11572	336	1296	\N	0.12	1	0.01	1	-1
11573	336	1404	\N	0.12	1	0.01	1	-1
11574	336	1433	\N	0.12	1	0.01	1	-1
11575	336	1462	\N	0.12	1	0.01	1	-1
11576	336	1523	\N	0.12	1	0.01	1	-1
11577	356	534	\N	0.12	1	0.01	1	-1
11578	356	536	\N	0.12	1	0.01	1	-1
11579	356	948	\N	0.12	1	0.01	1	-1
11580	356	1042	\N	0.12	1	0.01	1	-1
11581	356	1221	\N	0.12	1	0.01	1	-1
11582	356	1248	\N	0.12	1	0.01	1	-1
11583	356	1293	\N	0.12	1	0.01	1	-1
11584	356	1296	\N	0.12	1	0.01	1	-1
11585	356	1404	\N	0.12	1	0.01	1	-1
11586	356	1433	\N	0.12	1	0.01	1	-1
11587	356	1462	\N	0.12	1	0.01	1	-1
11588	356	1523	\N	0.12	1	0.01	1	-1
11589	101	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11590	101	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11591	101	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11592	101	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11593	101	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11594	101	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11595	121	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11596	121	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11597	121	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11598	121	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11599	121	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11600	121	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11601	147	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11602	147	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11603	147	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11604	147	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11605	147	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11606	147	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11607	167	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11608	167	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11609	167	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11610	167	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11611	167	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11612	167	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11613	336	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11614	336	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11615	336	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11616	336	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11617	336	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11618	336	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11619	356	949	\N	2.92250013627851	1	0.24354167802320917	1	-1
11620	356	1041	\N	2.92250013627851	1	0.24354167802320917	1	-1
11621	356	1222	\N	2.92250013627851	1	0.24354167802320917	1	-1
11622	356	1247	\N	2.92250013627851	1	0.24354167802320917	1	-1
11623	356	1463	\N	2.92250013627851	1	0.24354167802320917	1	-1
11624	356	1522	\N	2.92250013627851	1	0.24354167802320917	1	-1
11625	131	132	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11626	131	183	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11627	184	132	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11628	184	183	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11629	132	131	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11630	132	184	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11631	183	131	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11632	183	184	\N	1.7609389376079614	1	0.14674491146733012	1	-1
11633	135	1159	\N	0.12	1	0.01	1	-1
11634	135	1172	\N	0.12	1	0.01	1	-1
11635	180	1159	\N	0.12	1	0.01	1	-1
11636	180	1172	\N	0.12	1	0.01	1	-1
11637	137	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11638	137	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11639	178	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11640	178	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11641	705	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11642	705	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11643	712	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11644	712	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11645	1158	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11646	1158	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11647	1173	706	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11648	1173	711	\N	2.3208211927399947	1	0.1934017660616662	1	-1
11649	137	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11650	137	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11651	137	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11652	137	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11653	137	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11654	137	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11655	178	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11656	178	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11657	178	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11658	178	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11659	178	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11660	178	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11661	705	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11662	705	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11663	705	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11664	705	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11665	705	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11666	705	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11667	712	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11668	712	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11669	712	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11670	712	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11671	712	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11672	712	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11673	1158	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11674	1158	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11675	1158	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11676	1158	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11677	1158	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11678	1158	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11679	1173	138	\N	2.508407750426066	1	0.20903397920217215	1	-1
11680	1173	177	\N	2.508407750426066	1	0.20903397920217215	1	-1
11681	1173	704	\N	2.508407750426066	1	0.20903397920217215	1	-1
11682	1173	713	\N	2.508407750426066	1	0.20903397920217215	1	-1
11683	1173	1157	\N	2.508407750426066	1	0.20903397920217215	1	-1
11684	1173	1174	\N	2.508407750426066	1	0.20903397920217215	1	-1
11685	138	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11686	138	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11687	138	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11688	138	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11689	138	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11690	138	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11691	177	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11692	177	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11693	177	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11694	177	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11695	177	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11696	177	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11697	704	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11698	704	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11699	704	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11700	704	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11701	704	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11702	704	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11703	713	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11704	713	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11705	713	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11706	713	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11707	713	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11708	713	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11709	1157	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11710	1157	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11711	1157	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11712	1157	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11713	1157	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11714	1157	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11715	1174	139	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11716	1174	176	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11717	1174	703	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11718	1174	714	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11719	1174	1156	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11720	1174	1175	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11721	138	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11722	138	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11723	138	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11724	138	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11725	138	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11726	138	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11727	177	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11728	177	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11729	177	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11730	177	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11731	177	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11732	177	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11733	704	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11734	704	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11735	704	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11736	704	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11737	704	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11738	704	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11739	713	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11740	713	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11741	713	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11742	713	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11743	713	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11744	713	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11745	1157	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11746	1157	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11747	1157	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11748	1157	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11749	1157	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11750	1157	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11751	1174	137	\N	2.508407750426066	1	0.20903397920217215	1	-1
11752	1174	178	\N	2.508407750426066	1	0.20903397920217215	1	-1
11753	1174	705	\N	2.508407750426066	1	0.20903397920217215	1	-1
11754	1174	712	\N	2.508407750426066	1	0.20903397920217215	1	-1
11755	1174	1158	\N	2.508407750426066	1	0.20903397920217215	1	-1
11756	1174	1173	\N	2.508407750426066	1	0.20903397920217215	1	-1
11757	139	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11758	139	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11759	139	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11760	139	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11761	139	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11762	139	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11763	176	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11764	176	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11765	176	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11766	176	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11767	176	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11768	176	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11769	703	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11770	703	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11771	703	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11772	703	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11773	703	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11774	703	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11775	714	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11776	714	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11777	714	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11778	714	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11779	714	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11780	714	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11781	1156	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11782	1156	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11783	1156	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11784	1156	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11785	1156	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11786	1156	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11787	1175	138	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11788	1175	177	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11789	1175	704	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11790	1175	713	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11791	1175	1157	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11792	1175	1174	\N	1.5403208623549731	1	0.12836007186291443	1	-1
11793	141	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11794	141	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11795	141	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11796	141	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11797	141	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11798	141	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11799	141	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11800	141	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11801	174	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11802	174	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11803	174	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11804	174	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11805	174	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11806	174	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11807	174	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11808	174	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11809	701	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11810	701	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11811	701	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11812	701	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11813	701	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11814	701	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11815	701	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11816	701	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11817	716	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11818	716	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11819	716	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11820	716	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11821	716	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11822	716	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11823	716	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11824	716	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11825	1154	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11826	1154	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11827	1154	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11828	1154	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11829	1154	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11830	1154	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11831	1154	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11832	1154	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11833	1177	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11834	1177	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11835	1177	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11836	1177	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11837	1177	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11838	1177	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11839	1177	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11840	1177	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11841	1412	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11842	1412	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11843	1412	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11844	1412	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11845	1412	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11846	1412	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11847	1412	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11848	1412	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11849	1425	142	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11850	1425	173	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11851	1425	700	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11852	1425	717	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11853	1425	1153	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11854	1425	1178	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11855	1425	1411	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11856	1425	1426	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11857	142	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11858	142	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11859	142	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11860	142	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11861	142	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11862	142	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11863	142	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11864	142	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11865	173	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11866	173	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11867	173	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11868	173	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11869	173	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11870	173	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11871	173	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11872	173	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11873	700	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11874	700	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11875	700	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11876	700	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11877	700	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11878	700	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11879	700	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11880	700	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11881	717	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11882	717	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11883	717	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11884	717	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11885	717	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11886	717	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11887	717	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11888	717	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11889	1153	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11890	1153	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11891	1153	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11892	1153	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11893	1153	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11894	1153	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11895	1153	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11896	1153	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11897	1178	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11898	1178	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11899	1178	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11900	1178	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11901	1178	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11902	1178	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11903	1178	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11904	1178	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11905	1411	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11906	1411	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11907	1411	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11908	1411	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11909	1411	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11910	1411	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11911	1411	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11912	1411	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11913	1426	143	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11914	1426	172	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11915	1426	699	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11916	1426	718	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11917	1426	1152	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11918	1426	1179	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11919	1426	1410	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11920	1426	1427	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11921	142	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11922	142	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11923	142	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11924	142	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11925	142	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11926	142	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11927	142	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11928	142	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11929	173	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11930	173	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11931	173	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11932	173	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11933	173	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11934	173	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11935	173	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11936	173	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11937	700	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11938	700	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11939	700	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11940	700	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11941	700	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11942	700	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11943	700	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11944	700	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11945	717	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11946	717	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11947	717	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11948	717	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11949	717	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11950	717	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11951	717	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11952	717	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11953	1153	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11954	1153	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11955	1153	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11956	1153	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11957	1153	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11958	1153	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11959	1153	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11960	1153	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11961	1178	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11962	1178	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11963	1178	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11964	1178	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11965	1178	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11966	1178	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11967	1178	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11968	1178	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11969	1411	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11970	1411	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11971	1411	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11972	1411	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11973	1411	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11974	1411	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11975	1411	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11976	1411	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11977	1426	141	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11978	1426	174	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11979	1426	701	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11980	1426	716	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11981	1426	1154	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11982	1426	1177	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11983	1426	1412	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11984	1426	1425	\N	2.8937856922000584	1	0.2411488076833382	1	-1
11985	143	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11986	143	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11987	143	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11988	143	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11989	143	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11990	143	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11991	143	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11992	143	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11993	172	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11994	172	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11995	172	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11996	172	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11997	172	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11998	172	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
11999	172	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12000	172	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12001	699	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12002	699	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12003	699	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12004	699	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12005	699	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12006	699	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12007	699	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12008	699	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12009	718	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12010	718	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12011	718	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12012	718	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12013	718	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12014	718	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12015	718	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12016	718	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12017	1152	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12018	1152	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12019	1152	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12020	1152	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12021	1152	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12022	1152	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12023	1152	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12024	1152	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12025	1179	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12026	1179	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12027	1179	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12028	1179	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12029	1179	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12030	1179	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12031	1179	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12032	1179	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12033	1410	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12034	1410	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12035	1410	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12036	1410	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12037	1410	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12038	1410	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12039	1410	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12040	1410	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12041	1427	142	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12042	1427	173	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12043	1427	700	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12044	1427	717	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12045	1427	1153	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12046	1427	1178	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12047	1427	1411	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12048	1427	1426	\N	1.1788423153118361	1	0.09823685960931969	1	-1
12049	145	532	\N	0.12	1	0.01	1	-1
12050	145	996	\N	0.12	1	0.01	1	-1
12051	145	1149	\N	0.12	1	0.01	1	-1
12052	145	1182	\N	0.12	1	0.01	1	-1
12053	145	1219	\N	0.12	1	0.01	1	-1
12054	145	1291	\N	0.12	1	0.01	1	-1
12055	145	1407	\N	0.12	1	0.01	1	-1
12056	145	1430	\N	0.12	1	0.01	1	-1
12057	145	1460	\N	0.12	1	0.01	1	-1
12058	170	532	\N	0.12	1	0.01	1	-1
12059	170	996	\N	0.12	1	0.01	1	-1
12060	170	1149	\N	0.12	1	0.01	1	-1
12061	170	1182	\N	0.12	1	0.01	1	-1
12062	170	1219	\N	0.12	1	0.01	1	-1
12063	170	1291	\N	0.12	1	0.01	1	-1
12064	170	1407	\N	0.12	1	0.01	1	-1
12065	170	1430	\N	0.12	1	0.01	1	-1
12066	170	1460	\N	0.12	1	0.01	1	-1
12067	539	532	\N	0.12	1	0.01	1	-1
12068	539	996	\N	0.12	1	0.01	1	-1
12069	539	1149	\N	0.12	1	0.01	1	-1
12070	539	1182	\N	0.12	1	0.01	1	-1
12071	539	1219	\N	0.12	1	0.01	1	-1
12072	539	1291	\N	0.12	1	0.01	1	-1
12073	539	1407	\N	0.12	1	0.01	1	-1
12074	539	1430	\N	0.12	1	0.01	1	-1
12075	539	1460	\N	0.12	1	0.01	1	-1
12076	1045	532	\N	0.12	1	0.01	1	-1
12077	1045	996	\N	0.12	1	0.01	1	-1
12078	1045	1149	\N	0.12	1	0.01	1	-1
12079	1045	1182	\N	0.12	1	0.01	1	-1
12080	1045	1219	\N	0.12	1	0.01	1	-1
12081	1045	1291	\N	0.12	1	0.01	1	-1
12082	1045	1407	\N	0.12	1	0.01	1	-1
12083	1045	1430	\N	0.12	1	0.01	1	-1
12084	1045	1460	\N	0.12	1	0.01	1	-1
12085	1251	532	\N	0.12	1	0.01	1	-1
12086	1251	996	\N	0.12	1	0.01	1	-1
12087	1251	1149	\N	0.12	1	0.01	1	-1
12088	1251	1182	\N	0.12	1	0.01	1	-1
12089	1251	1219	\N	0.12	1	0.01	1	-1
12090	1251	1291	\N	0.12	1	0.01	1	-1
12091	1251	1407	\N	0.12	1	0.01	1	-1
12092	1251	1430	\N	0.12	1	0.01	1	-1
12093	1251	1460	\N	0.12	1	0.01	1	-1
12094	1299	532	\N	0.12	1	0.01	1	-1
12095	1299	996	\N	0.12	1	0.01	1	-1
12096	1299	1149	\N	0.12	1	0.01	1	-1
12097	1299	1182	\N	0.12	1	0.01	1	-1
12098	1299	1219	\N	0.12	1	0.01	1	-1
12099	1299	1291	\N	0.12	1	0.01	1	-1
12100	1299	1407	\N	0.12	1	0.01	1	-1
12101	1299	1430	\N	0.12	1	0.01	1	-1
12102	1299	1460	\N	0.12	1	0.01	1	-1
12103	1526	532	\N	0.12	1	0.01	1	-1
12104	1526	996	\N	0.12	1	0.01	1	-1
12105	1526	1149	\N	0.12	1	0.01	1	-1
12106	1526	1182	\N	0.12	1	0.01	1	-1
12107	1526	1219	\N	0.12	1	0.01	1	-1
12108	1526	1291	\N	0.12	1	0.01	1	-1
12109	1526	1407	\N	0.12	1	0.01	1	-1
12110	1526	1430	\N	0.12	1	0.01	1	-1
12111	1526	1460	\N	0.12	1	0.01	1	-1
12112	145	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12113	145	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12114	145	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12115	145	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12116	145	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12117	145	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12118	170	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12119	170	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12120	170	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12121	170	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12122	170	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12123	170	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12124	539	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12125	539	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12126	539	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12127	539	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12128	539	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12129	539	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12130	1045	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12131	1045	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12132	1045	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12133	1045	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12134	1045	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12135	1045	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12136	1251	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12137	1251	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12138	1251	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12139	1251	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12140	1251	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12141	1251	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12142	1299	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12143	1299	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12144	1299	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12145	1299	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12146	1299	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12147	1299	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12148	1526	697	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12149	1526	720	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12150	1526	1150	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12151	1526	1181	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12152	1526	1408	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12153	1526	1429	\N	0.3429753323725793	1	0.02858127769771494	1	-1
12154	168	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12155	168	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12156	168	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12157	168	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12158	168	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12159	537	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12160	537	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12161	537	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12162	537	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12163	537	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12164	1043	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12165	1043	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12166	1043	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12167	1043	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12168	1043	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12169	1249	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12170	1249	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12171	1249	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12172	1249	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12173	1249	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12174	1297	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12175	1297	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12176	1297	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12177	1297	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12178	1297	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12179	1405	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12180	1405	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12181	1405	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12182	1405	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12183	1405	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12184	1432	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12185	1432	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12186	1432	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12187	1432	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12188	1432	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12189	1524	533	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12190	1524	947	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12191	1524	1220	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12192	1524	1292	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12193	1524	1461	\N	0.3782592097500594	1	0.03152160081250495	1	-1
12194	198	442	\N	0.4009226316730103	1	0.03341021930608419	1	-1
12195	241	442	\N	0.4009226316730103	1	0.03341021930608419	1	-1
12196	1056	442	\N	0.4009226316730103	1	0.03341021930608419	1	-1
12197	1119	442	\N	0.4009226316730103	1	0.03341021930608419	1	-1
12198	198	506	\N	0.4962245889330735	1	0.04135204907775612	1	-1
12199	241	506	\N	0.4962245889330735	1	0.04135204907775612	1	-1
12200	1056	506	\N	0.4962245889330735	1	0.04135204907775612	1	-1
12201	1119	506	\N	0.4962245889330735	1	0.04135204907775612	1	-1
12202	198	263	\N	2.746652349814743	1	0.22888769581789525	1	-1
12203	198	312	\N	2.746652349814743	1	0.22888769581789525	1	-1
12204	198	961	\N	2.746652349814743	1	0.22888769581789525	1	-1
12205	198	1029	\N	2.746652349814743	1	0.22888769581789525	1	-1
12206	198	1234	\N	2.746652349814743	1	0.22888769581789525	1	-1
12207	198	1235	\N	2.746652349814743	1	0.22888769581789525	1	-1
12208	198	1475	\N	2.746652349814743	1	0.22888769581789525	1	-1
12209	198	1510	\N	2.746652349814743	1	0.22888769581789525	1	-1
12210	241	263	\N	2.746652349814743	1	0.22888769581789525	1	-1
12211	241	312	\N	2.746652349814743	1	0.22888769581789525	1	-1
12212	241	961	\N	2.746652349814743	1	0.22888769581789525	1	-1
12213	241	1029	\N	2.746652349814743	1	0.22888769581789525	1	-1
12214	241	1234	\N	2.746652349814743	1	0.22888769581789525	1	-1
12215	241	1235	\N	2.746652349814743	1	0.22888769581789525	1	-1
12216	241	1475	\N	2.746652349814743	1	0.22888769581789525	1	-1
12217	241	1510	\N	2.746652349814743	1	0.22888769581789525	1	-1
12218	1056	263	\N	2.746652349814743	1	0.22888769581789525	1	-1
12219	1056	312	\N	2.746652349814743	1	0.22888769581789525	1	-1
12220	1056	961	\N	2.746652349814743	1	0.22888769581789525	1	-1
12221	1056	1029	\N	2.746652349814743	1	0.22888769581789525	1	-1
12222	1056	1234	\N	2.746652349814743	1	0.22888769581789525	1	-1
12223	1056	1235	\N	2.746652349814743	1	0.22888769581789525	1	-1
12224	1056	1475	\N	2.746652349814743	1	0.22888769581789525	1	-1
12225	1056	1510	\N	2.746652349814743	1	0.22888769581789525	1	-1
12226	1119	263	\N	2.746652349814743	1	0.22888769581789525	1	-1
12227	1119	312	\N	2.746652349814743	1	0.22888769581789525	1	-1
12228	1119	961	\N	2.746652349814743	1	0.22888769581789525	1	-1
12229	1119	1029	\N	2.746652349814743	1	0.22888769581789525	1	-1
12230	1119	1234	\N	2.746652349814743	1	0.22888769581789525	1	-1
12231	1119	1235	\N	2.746652349814743	1	0.22888769581789525	1	-1
12232	1119	1475	\N	2.746652349814743	1	0.22888769581789525	1	-1
12233	1119	1510	\N	2.746652349814743	1	0.22888769581789525	1	-1
12234	199	443	\N	0.12	1	0.01	1	-1
12235	240	443	\N	0.12	1	0.01	1	-1
12236	1057	443	\N	0.12	1	0.01	1	-1
12237	1118	443	\N	0.12	1	0.01	1	-1
12238	199	505	\N	0.129644314670806	1	0.010803692889233834	1	-1
12239	240	505	\N	0.129644314670806	1	0.010803692889233834	1	-1
12240	1057	505	\N	0.129644314670806	1	0.010803692889233834	1	-1
12241	1118	505	\N	0.129644314670806	1	0.010803692889233834	1	-1
12242	201	504	\N	0.9352745930394495	1	0.07793954941995412	1	-1
12243	238	504	\N	0.9352745930394495	1	0.07793954941995412	1	-1
12244	1059	504	\N	0.9352745930394495	1	0.07793954941995412	1	-1
12245	1116	504	\N	0.9352745930394495	1	0.07793954941995412	1	-1
12246	201	444	\N	0.9421818295455086	1	0.07851515246212572	1	-1
12247	238	444	\N	0.9421818295455086	1	0.07851515246212572	1	-1
12248	1059	444	\N	0.9421818295455086	1	0.07851515246212572	1	-1
12249	1116	444	\N	0.9421818295455086	1	0.07851515246212572	1	-1
12250	202	445	\N	0.5654408334664941	1	0.04712006945554117	1	-1
12251	1060	445	\N	0.5654408334664941	1	0.04712006945554117	1	-1
12252	202	237	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12253	202	503	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12254	202	780	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12255	202	1115	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12256	202	1378	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12257	202	1399	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12258	1060	237	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12259	1060	503	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12260	1060	780	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12261	1060	1115	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12262	1060	1378	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12263	1060	1399	\N	2.3648244048428575	1	0.19706870040357147	1	-1
12264	203	237	\N	1.958606862958149	1	0.16321723857984577	1	-1
12265	203	503	\N	1.958606862958149	1	0.16321723857984577	1	-1
12266	203	780	\N	1.958606862958149	1	0.16321723857984577	1	-1
12267	203	1115	\N	1.958606862958149	1	0.16321723857984577	1	-1
12268	203	1378	\N	1.958606862958149	1	0.16321723857984577	1	-1
12269	203	1399	\N	1.958606862958149	1	0.16321723857984577	1	-1
12270	1061	237	\N	1.958606862958149	1	0.16321723857984577	1	-1
12271	1061	503	\N	1.958606862958149	1	0.16321723857984577	1	-1
12272	1061	780	\N	1.958606862958149	1	0.16321723857984577	1	-1
12273	1061	1115	\N	1.958606862958149	1	0.16321723857984577	1	-1
12274	1061	1378	\N	1.958606862958149	1	0.16321723857984577	1	-1
12275	1061	1399	\N	1.958606862958149	1	0.16321723857984577	1	-1
12276	203	446	\N	2.888083190786965	1	0.2406735992322471	1	-1
12277	1061	446	\N	2.888083190786965	1	0.2406735992322471	1	-1
12278	206	560	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12279	206	590	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12280	684	560	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12281	684	590	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12282	1131	560	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12283	1131	590	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12284	1346	560	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12285	1346	590	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12286	1373	560	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12287	1373	590	\N	1.6381148416291584	1	0.1365095701357632	1	-1
12288	206	813	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12289	206	814	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12290	684	813	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12291	684	814	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12292	1131	813	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12293	1131	814	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12294	1346	813	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12295	1346	814	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12296	1373	813	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12297	1373	814	\N	2.7881220824279165	1	0.23234350686899305	1	-1
12298	206	33	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12299	206	85	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12300	206	111	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12301	206	157	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12302	206	345	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12303	206	346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12304	206	387	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12305	206	388	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12306	206	408	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12307	206	437	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12308	206	561	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12309	206	591	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12310	684	33	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12311	684	85	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12312	684	111	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12313	684	157	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12314	684	345	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12315	684	346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12316	684	387	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12317	684	388	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12318	684	408	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12319	684	437	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12320	684	561	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12321	684	591	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12322	1131	33	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12323	1131	85	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12324	1131	111	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12325	1131	157	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12326	1131	345	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12327	1131	346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12328	1131	387	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12329	1131	388	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12330	1131	408	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12331	1131	437	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12332	1131	561	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12333	1131	591	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12334	1346	33	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12335	1346	85	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12336	1346	111	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12337	1346	157	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12338	1346	345	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12339	1346	346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12340	1346	387	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12341	1346	388	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12342	1346	408	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12343	1346	437	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12344	1346	561	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12345	1346	591	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12346	1373	33	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12347	1373	85	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12348	1373	111	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12349	1373	157	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12350	1373	345	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12351	1373	346	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12352	1373	387	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12353	1373	388	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12354	1373	408	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12355	1373	437	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12356	1373	561	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12357	1373	591	\N	2.9258740958319693	1	0.24382284131933077	1	-1
12358	208	209	\N	2.056542488247118	1	0.17137854068725983	1	-1
12359	208	688	\N	2.056542488247118	1	0.17137854068725983	1	-1
12360	208	809	\N	2.056542488247118	1	0.17137854068725983	1	-1
12361	208	1134	\N	2.056542488247118	1	0.17137854068725983	1	-1
12362	208	1349	\N	2.056542488247118	1	0.17137854068725983	1	-1
12363	687	209	\N	2.056542488247118	1	0.17137854068725983	1	-1
12364	687	688	\N	2.056542488247118	1	0.17137854068725983	1	-1
12365	687	809	\N	2.056542488247118	1	0.17137854068725983	1	-1
12366	687	1134	\N	2.056542488247118	1	0.17137854068725983	1	-1
12367	687	1349	\N	2.056542488247118	1	0.17137854068725983	1	-1
12368	810	209	\N	2.056542488247118	1	0.17137854068725983	1	-1
12369	810	688	\N	2.056542488247118	1	0.17137854068725983	1	-1
12370	810	809	\N	2.056542488247118	1	0.17137854068725983	1	-1
12371	810	1134	\N	2.056542488247118	1	0.17137854068725983	1	-1
12372	810	1349	\N	2.056542488247118	1	0.17137854068725983	1	-1
12373	1133	209	\N	2.056542488247118	1	0.17137854068725983	1	-1
12374	1133	688	\N	2.056542488247118	1	0.17137854068725983	1	-1
12375	1133	809	\N	2.056542488247118	1	0.17137854068725983	1	-1
12376	1133	1134	\N	2.056542488247118	1	0.17137854068725983	1	-1
12377	1133	1349	\N	2.056542488247118	1	0.17137854068725983	1	-1
12378	1348	209	\N	2.056542488247118	1	0.17137854068725983	1	-1
12379	1348	688	\N	2.056542488247118	1	0.17137854068725983	1	-1
12380	1348	809	\N	2.056542488247118	1	0.17137854068725983	1	-1
12381	1348	1134	\N	2.056542488247118	1	0.17137854068725983	1	-1
12382	1348	1349	\N	2.056542488247118	1	0.17137854068725983	1	-1
12383	209	208	\N	2.056542488247118	1	0.17137854068725983	1	-1
12384	209	687	\N	2.056542488247118	1	0.17137854068725983	1	-1
12385	209	810	\N	2.056542488247118	1	0.17137854068725983	1	-1
12386	209	1133	\N	2.056542488247118	1	0.17137854068725983	1	-1
12387	209	1348	\N	2.056542488247118	1	0.17137854068725983	1	-1
12388	688	208	\N	2.056542488247118	1	0.17137854068725983	1	-1
12389	688	687	\N	2.056542488247118	1	0.17137854068725983	1	-1
12390	688	810	\N	2.056542488247118	1	0.17137854068725983	1	-1
12391	688	1133	\N	2.056542488247118	1	0.17137854068725983	1	-1
12392	688	1348	\N	2.056542488247118	1	0.17137854068725983	1	-1
12393	809	208	\N	2.056542488247118	1	0.17137854068725983	1	-1
12394	809	687	\N	2.056542488247118	1	0.17137854068725983	1	-1
12395	809	810	\N	2.056542488247118	1	0.17137854068725983	1	-1
12396	809	1133	\N	2.056542488247118	1	0.17137854068725983	1	-1
12397	809	1348	\N	2.056542488247118	1	0.17137854068725983	1	-1
12398	1134	208	\N	2.056542488247118	1	0.17137854068725983	1	-1
12399	1134	687	\N	2.056542488247118	1	0.17137854068725983	1	-1
12400	1134	810	\N	2.056542488247118	1	0.17137854068725983	1	-1
12401	1134	1133	\N	2.056542488247118	1	0.17137854068725983	1	-1
12402	1134	1348	\N	2.056542488247118	1	0.17137854068725983	1	-1
12403	1349	208	\N	2.056542488247118	1	0.17137854068725983	1	-1
12404	1349	687	\N	2.056542488247118	1	0.17137854068725983	1	-1
12405	1349	810	\N	2.056542488247118	1	0.17137854068725983	1	-1
12406	1349	1133	\N	2.056542488247118	1	0.17137854068725983	1	-1
12407	1349	1348	\N	2.056542488247118	1	0.17137854068725983	1	-1
12408	210	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12409	210	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12410	210	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12411	210	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12412	210	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12413	210	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12414	210	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12415	210	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12416	449	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12417	449	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12418	449	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12419	449	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12420	449	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12421	449	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12422	449	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12423	449	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12424	518	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12425	518	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12426	518	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12427	518	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12428	518	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12429	518	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12430	518	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12431	518	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12432	742	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12433	742	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12434	742	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12435	742	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12436	742	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12437	742	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12438	742	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12439	742	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12440	819	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12441	819	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12442	819	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12443	819	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12444	819	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12445	819	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12446	819	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12447	819	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12448	1064	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12449	1064	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12450	1064	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12451	1064	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12452	1064	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12453	1064	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12454	1064	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12455	1064	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12456	1135	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12457	1135	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12458	1135	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12459	1135	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12460	1135	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12461	1135	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12462	1135	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12463	1135	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12464	1350	232	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12465	1350	499	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12466	1350	552	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12467	1350	776	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12468	1350	808	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12469	1350	1110	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12470	1350	1195	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12471	1350	1341	\N	0.8961028136980475	1	0.07467523447483729	1	-1
12472	210	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12473	210	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12474	210	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12475	210	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12476	449	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12477	449	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12478	449	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12479	449	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12480	518	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12481	518	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12482	518	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12483	518	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12484	742	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12485	742	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12486	742	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12487	742	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12488	819	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12489	819	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12490	819	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12491	819	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12492	1064	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12493	1064	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12494	1064	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12495	1064	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12496	1135	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12497	1135	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12498	1135	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12499	1135	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12500	1350	500	\N	2.65530774288279	1	0.22127564524023252	1	-1
12501	1350	553	\N	2.65530774288279	1	0.22127564524023252	1	-1
12502	1350	689	\N	2.65530774288279	1	0.22127564524023252	1	-1
12503	1350	777	\N	2.65530774288279	1	0.22127564524023252	1	-1
12504	211	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12505	211	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12506	211	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12507	211	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12508	211	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12509	211	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12510	211	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12511	211	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12512	450	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12513	450	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12514	450	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12515	450	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12516	450	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12517	450	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12518	450	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12519	450	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12520	519	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12521	519	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12522	519	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12523	519	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12524	519	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12525	519	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12526	519	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12527	519	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12528	743	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12529	743	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12530	743	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12531	743	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12532	743	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12533	743	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12534	743	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12535	743	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12536	820	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12537	820	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12538	820	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12539	820	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12540	820	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12541	820	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12542	820	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12543	820	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12544	1065	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12545	1065	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12546	1065	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12547	1065	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12548	1065	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12549	1065	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12550	1065	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12551	1065	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12552	1136	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12553	1136	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12554	1136	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12555	1136	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12556	1136	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12557	1136	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12558	1136	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12559	1136	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12560	1351	231	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12561	1351	498	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12562	1351	551	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12563	1351	775	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12564	1351	807	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12565	1351	1109	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12566	1351	1194	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12567	1351	1340	\N	0.3436724526210428	1	0.028639371051753567	1	-1
12568	212	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12569	212	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12570	212	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12571	212	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12572	212	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12573	212	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12574	212	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12575	212	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12576	451	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12577	451	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12578	451	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12579	451	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12580	451	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12581	451	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12582	451	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12583	451	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12584	520	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12585	520	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12586	520	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12587	520	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12588	520	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12589	520	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12590	520	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12591	520	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12592	744	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12593	744	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12594	744	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12595	744	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12596	744	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12597	744	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12598	744	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12599	744	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12600	821	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12601	821	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12602	821	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12603	821	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12604	821	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12605	821	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12606	821	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12607	821	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12608	1066	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12609	1066	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12610	1066	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12611	1066	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12612	1066	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12613	1066	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12614	1066	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12615	1066	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12616	1137	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12617	1137	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12618	1137	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12619	1137	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12620	1137	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12621	1137	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12622	1137	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12623	1137	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12624	1352	230	\N	0.399317071472918	1	0.03327642262274317	1	-1
12625	1352	497	\N	0.399317071472918	1	0.03327642262274317	1	-1
12626	1352	550	\N	0.399317071472918	1	0.03327642262274317	1	-1
12627	1352	774	\N	0.399317071472918	1	0.03327642262274317	1	-1
12628	1352	806	\N	0.399317071472918	1	0.03327642262274317	1	-1
12629	1352	1108	\N	0.399317071472918	1	0.03327642262274317	1	-1
12630	1352	1193	\N	0.399317071472918	1	0.03327642262274317	1	-1
12631	1352	1339	\N	0.399317071472918	1	0.03327642262274317	1	-1
12632	213	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12633	213	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12634	213	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12635	213	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12636	213	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12637	213	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12638	213	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12639	213	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12640	452	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12641	452	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12642	452	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12643	452	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12644	452	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12645	452	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12646	452	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12647	452	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12648	521	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12649	521	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12650	521	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12651	521	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12652	521	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12653	521	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12654	521	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12655	521	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12656	745	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12657	745	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12658	745	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12659	745	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12660	745	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12661	745	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12662	745	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12663	745	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12664	822	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12665	822	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12666	822	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12667	822	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12668	822	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12669	822	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12670	822	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12671	822	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12672	1067	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12673	1067	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12674	1067	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12675	1067	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12676	1067	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12677	1067	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12678	1067	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12679	1067	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12680	1138	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12681	1138	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12682	1138	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12683	1138	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12684	1138	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12685	1138	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12686	1138	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12687	1138	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12688	1353	228	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12689	1353	495	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12690	1353	548	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12691	1353	772	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12692	1353	804	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12693	1353	1106	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12694	1353	1191	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12695	1353	1337	\N	0.18829617399203813	1	0.015691347832669844	1	-1
12696	213	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12697	213	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12698	452	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12699	452	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12700	521	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12701	521	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12702	745	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12703	745	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12704	822	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12705	822	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12706	1067	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12707	1067	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12708	1138	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12709	1138	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12710	1353	654	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12711	1353	663	\N	0.9703019454032983	1	0.08085849545027486	1	-1
12712	213	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12713	452	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12714	521	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12715	745	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12716	822	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12717	1067	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12718	1138	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12719	1353	879	\N	2.435411722066057	1	0.2029509768388381	1	-1
12720	214	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12721	214	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12722	214	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12723	214	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12724	214	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12725	214	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12726	214	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12727	214	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12728	214	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12729	453	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12730	453	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12731	453	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12732	453	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12733	453	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12734	453	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12735	453	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12736	453	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12737	453	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12738	522	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12739	522	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12740	522	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12741	522	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12742	522	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12743	522	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12744	522	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12745	522	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12746	522	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12747	746	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12748	746	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12749	746	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12750	746	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12751	746	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12752	746	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12753	746	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12754	746	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12755	746	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12756	823	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12757	823	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12758	823	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12759	823	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12760	823	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12761	823	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12762	823	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12763	823	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12764	823	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12765	880	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12766	880	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12767	880	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12768	880	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12769	880	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12770	880	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12771	880	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12772	880	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12773	880	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12774	1068	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12775	1068	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12776	1068	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12777	1068	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12778	1068	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12779	1068	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12780	1068	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12781	1068	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12782	1068	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12783	1139	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12784	1139	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12785	1139	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12786	1139	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12787	1139	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12788	1139	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12789	1139	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12790	1139	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12791	1139	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12792	1354	227	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12793	1354	494	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12794	1354	547	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12795	1354	771	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12796	1354	803	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12797	1354	908	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12798	1354	1105	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12799	1354	1190	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12800	1354	1336	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12801	215	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12802	215	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12803	215	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12804	215	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12805	215	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12806	226	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12807	226	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12808	226	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12809	226	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12810	226	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12811	454	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12812	454	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12813	454	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12814	454	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12815	454	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12816	523	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12817	523	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12818	523	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12819	523	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12820	523	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12821	747	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12822	747	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12823	747	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12824	747	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12825	747	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12826	824	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12827	824	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12828	824	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12829	824	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12830	824	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12831	881	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12832	881	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12833	881	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12834	881	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12835	881	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12836	1069	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12837	1069	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12838	1069	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12839	1069	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12840	1069	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12841	1104	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12842	1104	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12843	1104	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12844	1104	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12845	1104	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12846	1140	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12847	1140	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12848	1140	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12849	1140	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12850	1140	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12851	1189	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12852	1189	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12853	1189	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12854	1189	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12855	1189	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12856	1335	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12857	1335	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12858	1335	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12859	1335	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12860	1335	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12861	1355	493	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12862	1355	546	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12863	1355	770	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12864	1355	802	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12865	1355	907	\N	1.1834414462807088	1	0.0986201205233924	1	-1
12866	216	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12867	225	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12868	455	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12869	524	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12870	748	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12871	825	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12872	882	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12873	1070	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12874	1103	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12875	1141	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12876	1188	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12877	1334	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12878	1356	492	\N	0.1509969085769247	1	0.012583075714743723	1	-1
12879	216	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12880	216	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12881	216	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12882	216	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12883	225	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12884	225	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12885	225	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12886	225	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12887	455	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12888	455	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12889	455	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12890	455	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12891	524	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12892	524	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12893	524	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12894	524	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12895	748	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12896	748	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12897	748	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12898	748	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12899	825	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12900	825	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12901	825	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12902	825	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12903	882	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12904	882	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12905	882	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12906	882	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12907	1070	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12908	1070	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12909	1070	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12910	1070	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12911	1103	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12912	1103	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12913	1103	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12914	1103	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12915	1141	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12916	1141	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12917	1141	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12918	1141	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12919	1188	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12920	1188	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12921	1188	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12922	1188	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12923	1334	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12924	1334	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12925	1334	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12926	1334	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12927	1356	545	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12928	1356	769	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12929	1356	801	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12930	1356	906	\N	0.8074453639643366	1	0.06728711366369472	1	-1
12931	217	988	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12932	217	1452	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12933	224	988	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12934	224	1452	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12935	1002	988	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12936	1002	1452	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12937	1532	988	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12938	1532	1452	\N	1.0183322546698503	1	0.08486102122248754	1	-1
12939	219	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12940	219	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12941	222	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12942	222	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12943	986	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12944	986	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12945	1004	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12946	1004	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12947	1450	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12948	1450	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12949	1534	574	\N	2.145699093859383	1	0.17880825782161527	1	-1
12950	1534	575	\N	2.145699093859383	1	0.17880825782161527	1	-1
12951	220	985	\N	0.12	1	0.01	1	-1
12952	220	1449	\N	0.12	1	0.01	1	-1
12953	221	985	\N	0.12	1	0.01	1	-1
12954	221	1449	\N	0.12	1	0.01	1	-1
12955	1005	985	\N	0.12	1	0.01	1	-1
12956	1005	1449	\N	0.12	1	0.01	1	-1
12957	1535	985	\N	0.12	1	0.01	1	-1
12958	1535	1449	\N	0.12	1	0.01	1	-1
12959	227	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12960	227	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12961	227	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12962	227	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12963	227	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12964	227	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12965	227	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12966	227	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12967	227	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12968	494	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12969	494	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12970	494	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12971	494	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12972	494	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12973	494	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12974	494	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12975	494	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12976	494	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12977	547	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12978	547	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12979	547	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12980	547	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12981	547	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12982	547	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12983	547	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12984	547	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12985	547	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12986	771	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12987	771	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12988	771	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12989	771	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12990	771	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12991	771	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12992	771	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12993	771	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12994	771	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12995	803	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12996	803	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12997	803	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12998	803	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
12999	803	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13000	803	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13001	803	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13002	803	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13003	803	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13004	908	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13005	908	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13006	908	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13007	908	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13008	908	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13009	908	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13010	908	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13011	908	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13012	908	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13013	1105	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13014	1105	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13015	1105	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13016	1105	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13017	1105	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13018	1105	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13019	1105	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13020	1105	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13021	1105	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13022	1190	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13023	1190	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13024	1190	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13025	1190	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13026	1190	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13027	1190	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13028	1190	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13029	1190	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13030	1190	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13031	1336	214	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13032	1336	453	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13033	1336	522	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13034	1336	746	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13035	1336	823	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13036	1336	880	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13037	1336	1068	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13038	1336	1139	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13039	1336	1354	\N	0.8280089078166847	1	0.06900074231805706	1	-1
13040	228	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13041	228	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13042	228	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13043	228	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13044	228	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13045	228	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13046	228	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13047	228	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13048	495	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13049	495	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13050	495	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13051	495	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13052	495	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13053	495	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13054	495	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13055	495	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13056	548	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13057	548	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13058	548	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13059	548	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13060	548	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13061	548	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13062	548	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13063	548	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13064	772	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13065	772	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13066	772	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13067	772	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13068	772	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13069	772	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13070	772	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13071	772	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13072	804	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13073	804	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13074	804	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13075	804	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13076	804	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13077	804	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13078	804	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13079	804	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13080	1106	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13081	1106	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13082	1106	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13083	1106	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13084	1106	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13085	1106	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13086	1106	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13087	1106	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13088	1191	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13089	1191	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13090	1191	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13091	1191	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13092	1191	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13093	1191	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13094	1191	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13095	1191	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13096	1337	213	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13097	1337	452	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13098	1337	521	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13099	1337	745	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13100	1337	822	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13101	1337	1067	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13102	1337	1138	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13103	1337	1353	\N	0.18829617399203813	1	0.015691347832669844	1	-1
13104	228	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13105	228	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13106	495	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13107	495	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13108	548	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13109	548	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13110	772	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13111	772	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13112	804	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13113	804	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13114	1106	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13115	1106	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13116	1191	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13117	1191	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13118	1337	654	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13119	1337	663	\N	0.8593306649170739	1	0.07161088874308949	1	-1
13120	228	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13121	495	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13122	548	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13123	772	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13124	804	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13125	1106	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13126	1191	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13127	1337	879	\N	2.608475166655651	1	0.21737293055463755	1	-1
13128	230	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13129	230	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13130	230	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13131	230	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13132	230	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13133	230	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13134	230	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13135	230	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13136	497	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13137	497	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13138	497	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13139	497	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13140	497	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13141	497	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13142	497	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13143	497	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13144	550	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13145	550	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13146	550	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13147	550	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13148	550	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13149	550	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13150	550	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13151	550	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13152	774	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13153	774	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13154	774	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13155	774	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13156	774	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13157	774	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13158	774	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13159	774	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13160	806	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13161	806	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13162	806	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13163	806	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13164	806	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13165	806	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13166	806	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13167	806	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13168	1108	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13169	1108	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13170	1108	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13171	1108	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13172	1108	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13173	1108	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13174	1108	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13175	1108	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13176	1193	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13177	1193	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13178	1193	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13179	1193	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13180	1193	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13181	1193	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13182	1193	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13183	1193	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13184	1339	212	\N	0.399317071472918	1	0.03327642262274317	1	-1
13185	1339	451	\N	0.399317071472918	1	0.03327642262274317	1	-1
13186	1339	520	\N	0.399317071472918	1	0.03327642262274317	1	-1
13187	1339	744	\N	0.399317071472918	1	0.03327642262274317	1	-1
13188	1339	821	\N	0.399317071472918	1	0.03327642262274317	1	-1
13189	1339	1066	\N	0.399317071472918	1	0.03327642262274317	1	-1
13190	1339	1137	\N	0.399317071472918	1	0.03327642262274317	1	-1
13191	1339	1352	\N	0.399317071472918	1	0.03327642262274317	1	-1
13192	231	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13193	231	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13194	231	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13195	231	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13196	231	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13197	231	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13198	231	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13199	231	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13200	498	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13201	498	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13202	498	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13203	498	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13204	498	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13205	498	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13206	498	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13207	498	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13208	551	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13209	551	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13210	551	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13211	551	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13212	551	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13213	551	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13214	551	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13215	551	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13216	775	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13217	775	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13218	775	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13219	775	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13220	775	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13221	775	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13222	775	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13223	775	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13224	807	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13225	807	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13226	807	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13227	807	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13228	807	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13229	807	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13230	807	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13231	807	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13232	1109	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13233	1109	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13234	1109	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13235	1109	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13236	1109	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13237	1109	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13238	1109	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13239	1109	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13240	1194	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13241	1194	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13242	1194	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13243	1194	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13244	1194	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13245	1194	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13246	1194	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13247	1194	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13248	1340	211	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13249	1340	450	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13250	1340	519	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13251	1340	743	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13252	1340	820	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13253	1340	1065	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13254	1340	1136	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13255	1340	1351	\N	0.3436724526210428	1	0.028639371051753567	1	-1
13256	232	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13257	232	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13258	232	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13259	232	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13260	232	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13261	232	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13262	232	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13263	232	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13264	499	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13265	499	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13266	499	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13267	499	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13268	499	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13269	499	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13270	499	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13271	499	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13272	552	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13273	552	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13274	552	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13275	552	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13276	552	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13277	552	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13278	552	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13279	552	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13280	776	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13281	776	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13282	776	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13283	776	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13284	776	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13285	776	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13286	776	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13287	776	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13288	808	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13289	808	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13290	808	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13291	808	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13292	808	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13293	808	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13294	808	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13295	808	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13296	1110	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13297	1110	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13298	1110	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13299	1110	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13300	1110	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13301	1110	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13302	1110	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13303	1110	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13304	1195	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13305	1195	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13306	1195	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13307	1195	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13308	1195	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13309	1195	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13310	1195	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13311	1195	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13312	1341	210	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13313	1341	449	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13314	1341	518	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13315	1341	742	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13316	1341	819	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13317	1341	1064	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13318	1341	1135	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13319	1341	1350	\N	0.8961028136980475	1	0.07467523447483729	1	-1
13320	232	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13321	232	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13322	232	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13323	232	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13324	499	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13325	499	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13326	499	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13327	499	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13328	552	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13329	552	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13330	552	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13331	552	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13332	776	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13333	776	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13334	776	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13335	776	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13336	808	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13337	808	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13338	808	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13339	808	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13340	1110	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13341	1110	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13342	1110	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13343	1110	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13344	1195	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13345	1195	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13346	1195	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13347	1195	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13348	1341	500	\N	1.759237716824101	1	0.14660314306867508	1	-1
13349	1341	553	\N	1.759237716824101	1	0.14660314306867508	1	-1
13350	1341	689	\N	1.759237716824101	1	0.14660314306867508	1	-1
13351	1341	777	\N	1.759237716824101	1	0.14660314306867508	1	-1
13352	232	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13353	232	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13354	232	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13355	232	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13356	232	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13357	232	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13358	499	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13359	499	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13360	499	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13361	499	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13362	499	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13363	499	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13364	552	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13365	552	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13366	552	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13367	552	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13368	552	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13369	552	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13370	776	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13371	776	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13372	776	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13373	776	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13374	776	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13375	776	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13376	808	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13377	808	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13378	808	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13379	808	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13380	808	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13381	808	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13382	1110	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13383	1110	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13384	1110	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13385	1110	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13386	1110	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13387	1110	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13388	1195	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13389	1195	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13390	1195	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13391	1195	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13392	1195	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13393	1195	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13394	1341	434	\N	2.824731169203981	1	0.23539426410033173	1	-1
13395	1341	448	\N	2.824731169203981	1	0.23539426410033173	1	-1
13396	1341	517	\N	2.824731169203981	1	0.23539426410033173	1	-1
13397	1341	741	\N	2.824731169203981	1	0.23539426410033173	1	-1
13398	1341	818	\N	2.824731169203981	1	0.23539426410033173	1	-1
13399	1341	1063	\N	2.824731169203981	1	0.23539426410033173	1	-1
13400	236	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13401	502	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13402	779	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13403	1114	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13404	1377	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13405	1400	446	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13406	237	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13407	237	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13408	503	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13409	503	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13410	780	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13411	780	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13412	1115	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13413	1115	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13414	1378	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13415	1378	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13416	1399	203	\N	1.958606862958149	1	0.16321723857984577	1	-1
13417	1399	1061	\N	1.958606862958149	1	0.16321723857984577	1	-1
13418	237	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13419	237	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13420	503	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13421	503	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13422	780	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13423	780	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13424	1115	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13425	1115	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13426	1378	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13427	1378	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13428	1399	202	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13429	1399	1060	\N	2.3648244048428575	1	0.19706870040357147	1	-1
13430	237	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13431	503	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13432	780	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13433	1115	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13434	1378	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13435	1399	445	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13436	263	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13437	263	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13438	263	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13439	263	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13440	312	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13441	312	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13442	312	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13443	312	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13444	961	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13445	961	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13446	961	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13447	961	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13448	1029	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13449	1029	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13450	1029	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13451	1029	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13452	1234	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13453	1234	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13454	1234	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13455	1234	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13456	1235	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13457	1235	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13458	1235	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13459	1235	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13460	1475	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13461	1475	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13462	1475	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13463	1475	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13464	1510	198	\N	2.746652349814743	1	0.22888769581789525	1	-1
13465	1510	241	\N	2.746652349814743	1	0.22888769581789525	1	-1
13466	1510	1056	\N	2.746652349814743	1	0.22888769581789525	1	-1
13467	1510	1119	\N	2.746652349814743	1	0.22888769581789525	1	-1
13468	263	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13469	312	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13470	961	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13471	1029	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13472	1234	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13473	1235	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13474	1475	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13475	1510	442	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13476	263	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13477	312	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13478	961	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13479	1029	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13480	1234	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13481	1235	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13482	1475	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13483	1510	506	\N	2.9043472417557106	1	0.24202893681297588	1	-1
13484	264	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13485	311	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13486	962	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13487	1028	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13488	1476	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13489	1509	440	\N	2.468640449508378	1	0.20572003745903147	1	-1
13490	265	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13491	310	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13492	963	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13493	1027	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13494	1477	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13495	1508	509	\N	0.12067016254312868	1	0.010055846878594055	1	-1
13496	265	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13497	310	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13498	963	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13499	1027	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13500	1477	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13501	1508	439	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13502	266	438	\N	0.12	1	0.01	1	-1
13503	309	438	\N	0.12	1	0.01	1	-1
13504	964	438	\N	0.12	1	0.01	1	-1
13505	1026	438	\N	0.12	1	0.01	1	-1
13506	1478	438	\N	0.12	1	0.01	1	-1
13507	1507	438	\N	0.12	1	0.01	1	-1
13508	266	510	\N	0.12	1	0.01	1	-1
13509	309	510	\N	0.12	1	0.01	1	-1
13510	964	510	\N	0.12	1	0.01	1	-1
13511	1026	510	\N	0.12	1	0.01	1	-1
13512	1478	510	\N	0.12	1	0.01	1	-1
13513	1507	510	\N	0.12	1	0.01	1	-1
13514	335	949	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13515	335	1041	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13516	335	1222	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13517	335	1247	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13518	335	1463	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13519	335	1522	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13520	357	949	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13521	357	1041	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13522	357	1222	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13523	357	1247	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13524	357	1463	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13525	357	1522	\N	0.1832534930561059	1	0.015271124421342158	1	-1
13526	335	950	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13527	335	1040	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13528	335	1223	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13529	335	1246	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13530	335	1464	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13531	335	1521	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13532	357	950	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13533	357	1040	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13534	357	1223	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13535	357	1246	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13536	357	1464	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13537	357	1521	\N	2.6581054957218386	1	0.22150879131015322	1	-1
13538	376	377	\N	2.668004370834033	1	0.22233369756950275	1	-1
13539	376	399	\N	2.668004370834033	1	0.22233369756950275	1	-1
13540	400	377	\N	2.668004370834033	1	0.22233369756950275	1	-1
13541	400	399	\N	2.668004370834033	1	0.22233369756950275	1	-1
13542	377	376	\N	2.668004370834033	1	0.22233369756950275	1	-1
13543	377	400	\N	2.668004370834033	1	0.22233369756950275	1	-1
13544	399	376	\N	2.668004370834033	1	0.22233369756950275	1	-1
13545	399	400	\N	2.668004370834033	1	0.22233369756950275	1	-1
13546	378	379	\N	2.4989298666579782	1	0.2082441555548315	1	-1
13547	378	397	\N	2.4989298666579782	1	0.2082441555548315	1	-1
13548	398	379	\N	2.4989298666579782	1	0.2082441555548315	1	-1
13549	398	397	\N	2.4989298666579782	1	0.2082441555548315	1	-1
13550	379	735	\N	0.783614478880098	1	0.0653012065733415	1	-1
13551	397	735	\N	0.783614478880098	1	0.0653012065733415	1	-1
13552	379	953	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13553	379	1037	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13554	379	1226	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13555	379	1243	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13556	379	1467	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13557	379	1518	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13558	397	953	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13559	397	1037	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13560	397	1226	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13561	397	1243	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13562	397	1467	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13563	397	1518	\N	0.8770556505486787	1	0.07308797087905657	1	-1
13564	379	380	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13565	379	396	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13566	397	380	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13567	397	396	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13568	380	735	\N	0.24954601105151333	1	0.020795500920959446	1	-1
13569	396	735	\N	0.24954601105151333	1	0.020795500920959446	1	-1
13570	380	953	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13571	380	1037	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13572	380	1226	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13573	380	1243	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13574	380	1467	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13575	380	1518	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13576	396	953	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13577	396	1037	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13578	396	1226	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13579	396	1243	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13580	396	1467	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13581	396	1518	\N	0.32799737891947756	1	0.027333114909956463	1	-1
13582	380	379	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13583	380	397	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13584	396	379	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13585	396	397	\N	0.9788225180176053	1	0.08156854316813378	1	-1
13586	381	737	\N	0.12	1	0.01	1	-1
13587	381	3	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13588	381	40	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13589	381	45	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13590	381	92	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13591	381	104	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13592	381	118	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13593	381	150	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13594	381	164	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13595	381	339	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13596	381	353	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13597	381	395	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13598	381	415	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13599	381	430	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13600	381	513	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13601	381	557	\N	0.9412449852612697	1	0.0784370821051058	1	-1
13602	418	419	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13603	418	426	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13604	427	419	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13605	427	426	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13606	418	951	\N	2.714637761108268	1	0.226219813425689	1	-1
13607	418	1039	\N	2.714637761108268	1	0.226219813425689	1	-1
13608	418	1224	\N	2.714637761108268	1	0.226219813425689	1	-1
13609	418	1245	\N	2.714637761108268	1	0.226219813425689	1	-1
13610	418	1465	\N	2.714637761108268	1	0.226219813425689	1	-1
13611	418	1520	\N	2.714637761108268	1	0.226219813425689	1	-1
13612	427	951	\N	2.714637761108268	1	0.226219813425689	1	-1
13613	427	1039	\N	2.714637761108268	1	0.226219813425689	1	-1
13614	427	1224	\N	2.714637761108268	1	0.226219813425689	1	-1
13615	427	1245	\N	2.714637761108268	1	0.226219813425689	1	-1
13616	427	1465	\N	2.714637761108268	1	0.226219813425689	1	-1
13617	427	1520	\N	2.714637761108268	1	0.226219813425689	1	-1
13618	418	420	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13619	418	425	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13620	427	420	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13621	427	425	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13622	419	418	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13623	419	427	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13624	426	418	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13625	426	427	\N	0.9256762672711419	1	0.07713968893926183	1	-1
13626	419	951	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13627	419	1039	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13628	419	1224	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13629	419	1245	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13630	419	1465	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13631	419	1520	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13632	426	951	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13633	426	1039	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13634	426	1224	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13635	426	1245	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13636	426	1465	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13637	426	1520	\N	2.1333679093965086	1	0.1777806591163757	1	-1
13638	419	420	\N	2.257186190703237	1	0.18809884922526976	1	-1
13639	419	425	\N	2.257186190703237	1	0.18809884922526976	1	-1
13640	426	420	\N	2.257186190703237	1	0.18809884922526976	1	-1
13641	426	425	\N	2.257186190703237	1	0.18809884922526976	1	-1
13642	420	951	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13643	420	1039	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13644	420	1224	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13645	420	1245	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13646	420	1465	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13647	420	1520	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13648	425	951	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13649	425	1039	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13650	425	1224	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13651	425	1245	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13652	425	1465	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13653	425	1520	\N	0.19096520758244345	1	0.015913767298536954	1	-1
13654	420	419	\N	2.257186190703237	1	0.18809884922526976	1	-1
13655	420	426	\N	2.257186190703237	1	0.18809884922526976	1	-1
13656	425	419	\N	2.257186190703237	1	0.18809884922526976	1	-1
13657	425	426	\N	2.257186190703237	1	0.18809884922526976	1	-1
13658	420	418	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13659	420	427	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13660	425	418	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13661	425	427	\N	2.8744291695290904	1	0.2395357641274242	1	-1
13662	421	422	\N	2.796940713595176	1	0.233078392799598	1	-1
13663	421	423	\N	2.796940713595176	1	0.233078392799598	1	-1
13664	424	422	\N	2.796940713595176	1	0.233078392799598	1	-1
13665	424	423	\N	2.796940713595176	1	0.233078392799598	1	-1
13666	422	421	\N	2.796940713595176	1	0.233078392799598	1	-1
13667	422	424	\N	2.796940713595176	1	0.233078392799598	1	-1
13668	423	421	\N	2.796940713595176	1	0.233078392799598	1	-1
13669	423	424	\N	2.796940713595176	1	0.233078392799598	1	-1
13670	434	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13671	434	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13672	434	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13673	434	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13674	448	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13675	448	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13676	448	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13677	448	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13678	517	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13679	517	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13680	517	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13681	517	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13682	741	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13683	741	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13684	741	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13685	741	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13686	818	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13687	818	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13688	818	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13689	818	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13690	1063	500	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13691	1063	553	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13692	1063	689	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13693	1063	777	\N	1.5602885362341639	1	0.1300240446861803	1	-1
13694	434	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13695	434	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13696	434	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13697	434	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13698	434	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13699	434	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13700	434	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13701	434	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13702	448	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13703	448	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13704	448	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13705	448	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13706	448	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13707	448	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13708	448	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13709	448	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13710	517	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13711	517	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13712	517	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13713	517	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13714	517	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13715	517	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13716	517	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13717	517	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13718	741	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13719	741	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13720	741	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13721	741	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13722	741	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13723	741	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13724	741	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13725	741	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13726	818	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13727	818	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13728	818	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13729	818	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13730	818	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13731	818	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13732	818	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13733	818	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13734	1063	232	\N	2.824731169203981	1	0.23539426410033173	1	-1
13735	1063	499	\N	2.824731169203981	1	0.23539426410033173	1	-1
13736	1063	552	\N	2.824731169203981	1	0.23539426410033173	1	-1
13737	1063	776	\N	2.824731169203981	1	0.23539426410033173	1	-1
13738	1063	808	\N	2.824731169203981	1	0.23539426410033173	1	-1
13739	1063	1110	\N	2.824731169203981	1	0.23539426410033173	1	-1
13740	1063	1195	\N	2.824731169203981	1	0.23539426410033173	1	-1
13741	1063	1341	\N	2.824731169203981	1	0.23539426410033173	1	-1
13742	438	266	\N	0.12	1	0.01	1	-1
13743	438	309	\N	0.12	1	0.01	1	-1
13744	438	964	\N	0.12	1	0.01	1	-1
13745	438	1026	\N	0.12	1	0.01	1	-1
13746	438	1478	\N	0.12	1	0.01	1	-1
13747	438	1507	\N	0.12	1	0.01	1	-1
13748	438	510	\N	0.12	1	0.01	1	-1
13749	439	509	\N	0.12	1	0.01	1	-1
13750	439	265	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13751	439	310	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13752	439	963	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13753	439	1027	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13754	439	1477	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13755	439	1508	\N	0.1871806303729796	1	0.015598385864414968	1	-1
13756	440	507	\N	1.6555677377099824	1	0.13796397814249853	1	-1
13757	440	441	\N	1.679070267229229	1	0.13992252226910243	1	-1
13758	440	264	\N	2.468640449508378	1	0.20572003745903147	1	-1
13759	440	311	\N	2.468640449508378	1	0.20572003745903147	1	-1
13760	440	962	\N	2.468640449508378	1	0.20572003745903147	1	-1
13761	440	1028	\N	2.468640449508378	1	0.20572003745903147	1	-1
13762	440	1476	\N	2.468640449508378	1	0.20572003745903147	1	-1
13763	440	1509	\N	2.468640449508378	1	0.20572003745903147	1	-1
13764	441	507	\N	0.12	1	0.01	1	-1
13765	441	440	\N	1.679070267229229	1	0.13992252226910243	1	-1
13766	442	506	\N	0.14153139837313344	1	0.011794283197761121	1	-1
13767	442	198	\N	0.4009226316730103	1	0.03341021930608419	1	-1
13768	442	241	\N	0.4009226316730103	1	0.03341021930608419	1	-1
13769	442	1056	\N	0.4009226316730103	1	0.03341021930608419	1	-1
13770	442	1119	\N	0.4009226316730103	1	0.03341021930608419	1	-1
13771	442	263	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13772	442	312	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13773	442	961	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13774	442	1029	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13775	442	1234	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13776	442	1235	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13777	442	1475	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13778	442	1510	\N	2.7772310599192527	1	0.23143592165993773	1	-1
13779	443	199	\N	0.12	1	0.01	1	-1
13780	443	240	\N	0.12	1	0.01	1	-1
13781	443	1057	\N	0.12	1	0.01	1	-1
13782	443	1118	\N	0.12	1	0.01	1	-1
13783	443	505	\N	0.21164215327265087	1	0.01763684610605424	1	-1
13784	444	504	\N	0.12	1	0.01	1	-1
13785	444	201	\N	0.9421818295455086	1	0.07851515246212572	1	-1
13786	444	238	\N	0.9421818295455086	1	0.07851515246212572	1	-1
13787	444	1059	\N	0.9421818295455086	1	0.07851515246212572	1	-1
13788	444	1116	\N	0.9421818295455086	1	0.07851515246212572	1	-1
13789	445	202	\N	0.5654408334664941	1	0.04712006945554117	1	-1
13790	445	1060	\N	0.5654408334664941	1	0.04712006945554117	1	-1
13791	445	237	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13792	445	503	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13793	445	780	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13794	445	1115	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13795	445	1378	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13796	445	1399	\N	2.9044607457666825	1	0.24203839548055686	1	-1
13797	446	236	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13798	446	502	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13799	446	779	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13800	446	1114	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13801	446	1377	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13802	446	1400	\N	1.3918398649211148	1	0.1159866554100929	1	-1
13803	446	203	\N	2.888083190786965	1	0.2406735992322471	1	-1
13804	446	1061	\N	2.888083190786965	1	0.2406735992322471	1	-1
13805	447	7	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13806	447	36	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13807	447	49	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13808	447	88	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13809	447	108	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13810	447	114	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13811	447	154	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13812	447	160	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13813	447	204	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13814	447	235	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13815	447	343	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13816	447	349	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13817	447	385	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13818	447	391	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13819	447	411	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13820	447	728	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13821	447	1062	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13822	447	1113	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13823	447	1376	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13824	447	1401	\N	0.28515810962242405	1	0.02376317580186867	1	-1
13825	447	501	\N	1.695064364960236	1	0.14125536374668632	1	-1
13826	447	778	\N	1.695064364960236	1	0.14125536374668632	1	-1
13827	447	817	\N	1.695064364960236	1	0.14125536374668632	1	-1
13828	456	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13829	456	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13830	456	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13831	456	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13832	456	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13833	456	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13834	456	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13835	456	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13836	456	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13837	525	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13838	525	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13839	525	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13840	525	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13841	525	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13842	525	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13843	525	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13844	525	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13845	525	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13846	749	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13847	749	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13848	749	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13849	749	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13850	749	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13851	749	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13852	749	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13853	749	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13854	749	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13855	826	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13856	826	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13857	826	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13858	826	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13859	826	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13860	826	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13861	826	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13862	826	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13863	826	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13864	883	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13865	883	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13866	883	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13867	883	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13868	883	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13869	883	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13870	883	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13871	883	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13872	883	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13873	989	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13874	989	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13875	989	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13876	989	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13877	989	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13878	989	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13879	989	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13880	989	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13881	989	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13882	1071	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13883	1071	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13884	1071	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13885	1071	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13886	1071	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13887	1071	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13888	1071	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13889	1071	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13890	1071	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13891	1142	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13892	1142	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13893	1142	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13894	1142	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13895	1142	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13896	1142	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13897	1142	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13898	1142	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13899	1142	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13900	1256	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13901	1256	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13902	1256	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13903	1256	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13904	1256	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13905	1256	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13906	1256	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13907	1256	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13908	1256	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13909	1304	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13910	1304	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13911	1304	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13912	1304	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13913	1304	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13914	1304	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13915	1304	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13916	1304	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13917	1304	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13918	1357	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13919	1357	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13920	1357	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13921	1357	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13922	1357	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13923	1357	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13924	1357	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13925	1357	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13926	1357	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13927	1453	544	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13928	1453	768	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13929	1453	800	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13930	1453	905	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13931	1453	1001	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13932	1453	1102	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13933	1453	1187	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13934	1453	1333	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13935	1453	1531	\N	1.0723912624781013	1	0.08936593853984179	1	-1
13936	456	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13937	525	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13938	749	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13939	826	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13940	883	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13941	989	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13942	1071	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13943	1142	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13944	1256	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13945	1304	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13946	1357	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13947	1453	491	\N	1.178120567316023	1	0.09817671394300193	1	-1
13948	456	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13949	456	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13950	456	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13951	456	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13952	456	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13953	456	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13954	456	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13955	525	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13956	525	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13957	525	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13958	525	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13959	525	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13960	525	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13961	525	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13962	749	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13963	749	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13964	749	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13965	749	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13966	749	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13967	749	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13968	749	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13969	826	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13970	826	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13971	826	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13972	826	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13973	826	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13974	826	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13975	826	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13976	883	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13977	883	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13978	883	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13979	883	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13980	883	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13981	883	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13982	883	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13983	989	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13984	989	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13985	989	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13986	989	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13987	989	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13988	989	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13989	989	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13990	1071	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13991	1071	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13992	1071	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13993	1071	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13994	1071	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13995	1071	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13996	1071	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13997	1142	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13998	1142	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
13999	1142	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14000	1142	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14001	1142	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14002	1142	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14003	1142	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14004	1256	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14005	1256	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14006	1256	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14007	1256	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14008	1256	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14009	1256	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14010	1256	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14011	1304	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14012	1304	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14013	1304	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14014	1304	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14015	1304	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14016	1304	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14017	1304	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14018	1357	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14019	1357	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14020	1357	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14021	1357	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14022	1357	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14023	1357	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14024	1357	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14025	1453	526	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14026	1453	884	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14027	1453	990	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14028	1453	1143	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14029	1453	1213	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14030	1453	1285	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14031	1453	1454	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14032	457	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14033	457	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14034	457	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14035	750	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14036	750	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14037	750	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14038	827	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14039	827	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14040	827	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14041	1072	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14042	1072	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14043	1072	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14044	1257	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14045	1257	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14046	1257	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14047	1305	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14048	1305	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14049	1305	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14050	1358	767	\N	2.109818043896162	1	0.17581817032468017	1	-1
14051	1358	799	\N	2.109818043896162	1	0.17581817032468017	1	-1
14052	1358	1101	\N	2.109818043896162	1	0.17581817032468017	1	-1
14053	458	489	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14054	458	1211	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14055	458	1283	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14056	458	1331	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14057	1258	489	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14058	1258	1211	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14059	1258	1283	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14060	1258	1331	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14061	1306	489	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14062	1306	1211	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14063	1306	1283	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14064	1306	1331	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14065	1359	489	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14066	1359	1211	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14067	1359	1283	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14068	1359	1331	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14069	459	488	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14070	459	1210	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14071	459	1282	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14072	459	1330	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14073	1259	488	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14074	1259	1210	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14075	1259	1282	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14076	1259	1330	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14077	1307	488	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14078	1307	1210	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14079	1307	1282	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14080	1307	1330	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14081	1360	488	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14082	1360	1210	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14083	1360	1282	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14084	1360	1330	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14085	461	462	\N	2.45314834748378	1	0.20442902895698167	1	-1
14086	461	485	\N	2.45314834748378	1	0.20442902895698167	1	-1
14087	486	462	\N	2.45314834748378	1	0.20442902895698167	1	-1
14088	486	485	\N	2.45314834748378	1	0.20442902895698167	1	-1
14089	462	461	\N	2.45314834748378	1	0.20442902895698167	1	-1
14090	462	486	\N	2.45314834748378	1	0.20442902895698167	1	-1
14091	485	461	\N	2.45314834748378	1	0.20442902895698167	1	-1
14092	485	486	\N	2.45314834748378	1	0.20442902895698167	1	-1
14093	463	464	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14094	463	483	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14095	484	464	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14096	484	483	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14097	463	465	\N	2.992677293338274	1	0.24938977444485616	1	-1
14098	463	482	\N	2.992677293338274	1	0.24938977444485616	1	-1
14099	484	465	\N	2.992677293338274	1	0.24938977444485616	1	-1
14100	484	482	\N	2.992677293338274	1	0.24938977444485616	1	-1
14101	464	463	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14102	464	484	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14103	483	463	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14104	483	484	\N	1.2696039388353477	1	0.10580032823627898	1	-1
14105	464	465	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14106	464	482	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14107	483	465	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14108	483	482	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14109	465	464	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14110	465	483	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14111	482	464	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14112	482	483	\N	1.7663254908029764	1	0.14719379090024803	1	-1
14113	465	463	\N	2.992677293338274	1	0.24938977444485616	1	-1
14114	465	484	\N	2.992677293338274	1	0.24938977444485616	1	-1
14115	482	463	\N	2.992677293338274	1	0.24938977444485616	1	-1
14116	482	484	\N	2.992677293338274	1	0.24938977444485616	1	-1
14117	466	467	\N	2.406095845672004	1	0.20050798713933365	1	-1
14118	466	480	\N	2.406095845672004	1	0.20050798713933365	1	-1
14119	481	467	\N	2.406095845672004	1	0.20050798713933365	1	-1
14120	481	480	\N	2.406095845672004	1	0.20050798713933365	1	-1
14121	467	466	\N	2.406095845672004	1	0.20050798713933365	1	-1
14122	467	481	\N	2.406095845672004	1	0.20050798713933365	1	-1
14123	480	466	\N	2.406095845672004	1	0.20050798713933365	1	-1
14124	480	481	\N	2.406095845672004	1	0.20050798713933365	1	-1
14125	469	470	\N	1.367572414111597	1	0.11396436784263309	1	-1
14126	469	477	\N	1.367572414111597	1	0.11396436784263309	1	-1
14127	478	470	\N	1.367572414111597	1	0.11396436784263309	1	-1
14128	478	477	\N	1.367572414111597	1	0.11396436784263309	1	-1
14129	470	469	\N	1.367572414111597	1	0.11396436784263309	1	-1
14130	470	478	\N	1.367572414111597	1	0.11396436784263309	1	-1
14131	477	469	\N	1.367572414111597	1	0.11396436784263309	1	-1
14132	477	478	\N	1.367572414111597	1	0.11396436784263309	1	-1
14133	470	471	\N	2.886945263189119	1	0.24057877193242655	1	-1
14134	470	476	\N	2.886945263189119	1	0.24057877193242655	1	-1
14135	477	471	\N	2.886945263189119	1	0.24057877193242655	1	-1
14136	477	476	\N	2.886945263189119	1	0.24057877193242655	1	-1
14137	471	470	\N	2.886945263189119	1	0.24057877193242655	1	-1
14138	471	477	\N	2.886945263189119	1	0.24057877193242655	1	-1
14139	476	470	\N	2.886945263189119	1	0.24057877193242655	1	-1
14140	476	477	\N	2.886945263189119	1	0.24057877193242655	1	-1
14141	488	459	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14142	488	1259	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14143	488	1307	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14144	488	1360	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14145	1210	459	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14146	1210	1259	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14147	1210	1307	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14148	1210	1360	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14149	1282	459	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14150	1282	1259	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14151	1282	1307	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14152	1282	1360	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14153	1330	459	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14154	1330	1259	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14155	1330	1307	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14156	1330	1360	\N	0.1467773031700014	1	0.01223144193083345	1	-1
14157	489	458	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14158	489	1258	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14159	489	1306	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14160	489	1359	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14161	1211	458	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14162	1211	1258	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14163	1211	1306	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14164	1211	1359	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14165	1283	458	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14166	1283	1258	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14167	1283	1306	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14168	1283	1359	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14169	1331	458	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14170	1331	1258	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14171	1331	1306	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14172	1331	1359	\N	0.29048686420061115	1	0.024207238683384265	1	-1
14173	490	767	\N	2.393288095107981	1	0.19944067459233175	1	-1
14174	490	799	\N	2.393288095107981	1	0.19944067459233175	1	-1
14175	490	1101	\N	2.393288095107981	1	0.19944067459233175	1	-1
14176	1212	767	\N	2.393288095107981	1	0.19944067459233175	1	-1
14177	1212	799	\N	2.393288095107981	1	0.19944067459233175	1	-1
14178	1212	1101	\N	2.393288095107981	1	0.19944067459233175	1	-1
14179	1284	767	\N	2.393288095107981	1	0.19944067459233175	1	-1
14180	1284	799	\N	2.393288095107981	1	0.19944067459233175	1	-1
14181	1284	1101	\N	2.393288095107981	1	0.19944067459233175	1	-1
14182	1332	767	\N	2.393288095107981	1	0.19944067459233175	1	-1
14183	1332	799	\N	2.393288095107981	1	0.19944067459233175	1	-1
14184	1332	1101	\N	2.393288095107981	1	0.19944067459233175	1	-1
14185	491	544	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14186	491	768	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14187	491	800	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14188	491	905	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14189	491	1001	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14190	491	1102	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14191	491	1187	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14192	491	1333	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14193	491	1531	\N	0.12387780511830326	1	0.010323150426525271	1	-1
14194	491	456	\N	1.178120567316023	1	0.09817671394300193	1	-1
14195	491	525	\N	1.178120567316023	1	0.09817671394300193	1	-1
14196	491	749	\N	1.178120567316023	1	0.09817671394300193	1	-1
14197	491	826	\N	1.178120567316023	1	0.09817671394300193	1	-1
14198	491	883	\N	1.178120567316023	1	0.09817671394300193	1	-1
14199	491	989	\N	1.178120567316023	1	0.09817671394300193	1	-1
14200	491	1071	\N	1.178120567316023	1	0.09817671394300193	1	-1
14201	491	1142	\N	1.178120567316023	1	0.09817671394300193	1	-1
14202	491	1256	\N	1.178120567316023	1	0.09817671394300193	1	-1
14203	491	1304	\N	1.178120567316023	1	0.09817671394300193	1	-1
14204	491	1357	\N	1.178120567316023	1	0.09817671394300193	1	-1
14205	491	1453	\N	1.178120567316023	1	0.09817671394300193	1	-1
14206	491	526	\N	2.353470913855814	1	0.19612257615465117	1	-1
14207	491	884	\N	2.353470913855814	1	0.19612257615465117	1	-1
14208	491	990	\N	2.353470913855814	1	0.19612257615465117	1	-1
14209	491	1143	\N	2.353470913855814	1	0.19612257615465117	1	-1
14210	491	1213	\N	2.353470913855814	1	0.19612257615465117	1	-1
14211	491	1285	\N	2.353470913855814	1	0.19612257615465117	1	-1
14212	491	1454	\N	2.353470913855814	1	0.19612257615465117	1	-1
14213	492	216	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14214	492	225	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14215	492	455	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14216	492	524	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14217	492	748	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14218	492	825	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14219	492	882	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14220	492	1070	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14221	492	1103	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14222	492	1141	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14223	492	1188	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14224	492	1334	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14225	492	1356	\N	0.1509969085769247	1	0.012583075714743723	1	-1
14226	492	545	\N	0.7733101074698635	1	0.06444250895582196	1	-1
14227	492	769	\N	0.7733101074698635	1	0.06444250895582196	1	-1
14228	492	801	\N	0.7733101074698635	1	0.06444250895582196	1	-1
14229	492	906	\N	0.7733101074698635	1	0.06444250895582196	1	-1
14230	493	215	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14231	493	226	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14232	493	454	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14233	493	523	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14234	493	747	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14235	493	824	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14236	493	881	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14237	493	1069	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14238	493	1104	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14239	493	1140	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14240	493	1189	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14241	493	1335	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14242	493	1355	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14243	546	215	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14244	546	226	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14245	546	454	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14246	546	523	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14247	546	747	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14248	546	824	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14249	546	881	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14250	546	1069	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14251	546	1104	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14252	546	1140	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14253	546	1189	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14254	546	1335	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14255	546	1355	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14256	770	215	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14257	770	226	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14258	770	454	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14259	770	523	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14260	770	747	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14261	770	824	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14262	770	881	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14263	770	1069	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14264	770	1104	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14265	770	1140	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14266	770	1189	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14267	770	1335	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14268	770	1355	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14269	802	215	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14270	802	226	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14271	802	454	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14272	802	523	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14273	802	747	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14274	802	824	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14275	802	881	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14276	802	1069	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14277	802	1104	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14278	802	1140	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14279	802	1189	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14280	802	1335	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14281	802	1355	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14282	907	215	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14283	907	226	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14284	907	454	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14285	907	523	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14286	907	747	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14287	907	824	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14288	907	881	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14289	907	1069	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14290	907	1104	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14291	907	1140	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14292	907	1189	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14293	907	1335	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14294	907	1355	\N	1.1834414462807088	1	0.0986201205233924	1	-1
14295	500	434	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14296	500	448	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14297	500	517	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14298	500	741	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14299	500	818	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14300	500	1063	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14301	553	434	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14302	553	448	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14303	553	517	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14304	553	741	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14305	553	818	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14306	553	1063	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14307	689	434	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14308	689	448	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14309	689	517	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14310	689	741	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14311	689	818	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14312	689	1063	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14313	777	434	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14314	777	448	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14315	777	517	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14316	777	741	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14317	777	818	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14318	777	1063	\N	1.5602885362341639	1	0.1300240446861803	1	-1
14319	500	232	\N	1.759237716824101	1	0.14660314306867508	1	-1
14320	500	499	\N	1.759237716824101	1	0.14660314306867508	1	-1
14321	500	552	\N	1.759237716824101	1	0.14660314306867508	1	-1
14322	500	776	\N	1.759237716824101	1	0.14660314306867508	1	-1
14323	500	808	\N	1.759237716824101	1	0.14660314306867508	1	-1
14324	500	1110	\N	1.759237716824101	1	0.14660314306867508	1	-1
14325	500	1195	\N	1.759237716824101	1	0.14660314306867508	1	-1
14326	500	1341	\N	1.759237716824101	1	0.14660314306867508	1	-1
14327	553	232	\N	1.759237716824101	1	0.14660314306867508	1	-1
14328	553	499	\N	1.759237716824101	1	0.14660314306867508	1	-1
14329	553	552	\N	1.759237716824101	1	0.14660314306867508	1	-1
14330	553	776	\N	1.759237716824101	1	0.14660314306867508	1	-1
14331	553	808	\N	1.759237716824101	1	0.14660314306867508	1	-1
14332	553	1110	\N	1.759237716824101	1	0.14660314306867508	1	-1
14333	553	1195	\N	1.759237716824101	1	0.14660314306867508	1	-1
14334	553	1341	\N	1.759237716824101	1	0.14660314306867508	1	-1
14335	689	232	\N	1.759237716824101	1	0.14660314306867508	1	-1
14336	689	499	\N	1.759237716824101	1	0.14660314306867508	1	-1
14337	689	552	\N	1.759237716824101	1	0.14660314306867508	1	-1
14338	689	776	\N	1.759237716824101	1	0.14660314306867508	1	-1
14339	689	808	\N	1.759237716824101	1	0.14660314306867508	1	-1
14340	689	1110	\N	1.759237716824101	1	0.14660314306867508	1	-1
14341	689	1195	\N	1.759237716824101	1	0.14660314306867508	1	-1
14342	689	1341	\N	1.759237716824101	1	0.14660314306867508	1	-1
14343	777	232	\N	1.759237716824101	1	0.14660314306867508	1	-1
14344	777	499	\N	1.759237716824101	1	0.14660314306867508	1	-1
14345	777	552	\N	1.759237716824101	1	0.14660314306867508	1	-1
14346	777	776	\N	1.759237716824101	1	0.14660314306867508	1	-1
14347	777	808	\N	1.759237716824101	1	0.14660314306867508	1	-1
14348	777	1110	\N	1.759237716824101	1	0.14660314306867508	1	-1
14349	777	1195	\N	1.759237716824101	1	0.14660314306867508	1	-1
14350	777	1341	\N	1.759237716824101	1	0.14660314306867508	1	-1
14351	500	210	\N	2.65530774288279	1	0.22127564524023252	1	-1
14352	500	449	\N	2.65530774288279	1	0.22127564524023252	1	-1
14353	500	518	\N	2.65530774288279	1	0.22127564524023252	1	-1
14354	500	742	\N	2.65530774288279	1	0.22127564524023252	1	-1
14355	500	819	\N	2.65530774288279	1	0.22127564524023252	1	-1
14356	500	1064	\N	2.65530774288279	1	0.22127564524023252	1	-1
14357	500	1135	\N	2.65530774288279	1	0.22127564524023252	1	-1
14358	500	1350	\N	2.65530774288279	1	0.22127564524023252	1	-1
14359	553	210	\N	2.65530774288279	1	0.22127564524023252	1	-1
14360	553	449	\N	2.65530774288279	1	0.22127564524023252	1	-1
14361	553	518	\N	2.65530774288279	1	0.22127564524023252	1	-1
14362	553	742	\N	2.65530774288279	1	0.22127564524023252	1	-1
14363	553	819	\N	2.65530774288279	1	0.22127564524023252	1	-1
14364	553	1064	\N	2.65530774288279	1	0.22127564524023252	1	-1
14365	553	1135	\N	2.65530774288279	1	0.22127564524023252	1	-1
14366	553	1350	\N	2.65530774288279	1	0.22127564524023252	1	-1
14367	689	210	\N	2.65530774288279	1	0.22127564524023252	1	-1
14368	689	449	\N	2.65530774288279	1	0.22127564524023252	1	-1
14369	689	518	\N	2.65530774288279	1	0.22127564524023252	1	-1
14370	689	742	\N	2.65530774288279	1	0.22127564524023252	1	-1
14371	689	819	\N	2.65530774288279	1	0.22127564524023252	1	-1
14372	689	1064	\N	2.65530774288279	1	0.22127564524023252	1	-1
14373	689	1135	\N	2.65530774288279	1	0.22127564524023252	1	-1
14374	689	1350	\N	2.65530774288279	1	0.22127564524023252	1	-1
14375	777	210	\N	2.65530774288279	1	0.22127564524023252	1	-1
14376	777	449	\N	2.65530774288279	1	0.22127564524023252	1	-1
14377	777	518	\N	2.65530774288279	1	0.22127564524023252	1	-1
14378	777	742	\N	2.65530774288279	1	0.22127564524023252	1	-1
14379	777	819	\N	2.65530774288279	1	0.22127564524023252	1	-1
14380	777	1064	\N	2.65530774288279	1	0.22127564524023252	1	-1
14381	777	1135	\N	2.65530774288279	1	0.22127564524023252	1	-1
14382	777	1350	\N	2.65530774288279	1	0.22127564524023252	1	-1
14383	501	7	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14384	501	36	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14385	501	49	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14386	501	88	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14387	501	108	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14388	501	114	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14389	501	154	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14390	501	160	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14391	501	204	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14392	501	235	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14393	501	343	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14394	501	349	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14395	501	385	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14396	501	391	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14397	501	411	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14398	501	728	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14399	501	1062	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14400	501	1113	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14401	501	1376	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14402	501	1401	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14403	778	7	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14404	778	36	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14405	778	49	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14406	778	88	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14407	778	108	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14408	778	114	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14409	778	154	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14410	778	160	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14411	778	204	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14412	778	235	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14413	778	343	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14414	778	349	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14415	778	385	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14416	778	391	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14417	778	411	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14418	778	728	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14419	778	1062	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14420	778	1113	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14421	778	1376	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14422	778	1401	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14423	817	7	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14424	817	36	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14425	817	49	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14426	817	88	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14427	817	108	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14428	817	114	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14429	817	154	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14430	817	160	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14431	817	204	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14432	817	235	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14433	817	343	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14434	817	349	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14435	817	385	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14436	817	391	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14437	817	411	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14438	817	728	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14439	817	1062	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14440	817	1113	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14441	817	1376	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14442	817	1401	\N	1.6113726196594202	1	0.13428105163828502	1	-1
14443	501	447	\N	1.695064364960236	1	0.14125536374668632	1	-1
14444	778	447	\N	1.695064364960236	1	0.14125536374668632	1	-1
14445	817	447	\N	1.695064364960236	1	0.14125536374668632	1	-1
14446	504	444	\N	0.12	1	0.01	1	-1
14447	504	201	\N	0.9352745930394495	1	0.07793954941995412	1	-1
14448	504	238	\N	0.9352745930394495	1	0.07793954941995412	1	-1
14449	504	1059	\N	0.9352745930394495	1	0.07793954941995412	1	-1
14450	504	1116	\N	0.9352745930394495	1	0.07793954941995412	1	-1
14451	505	199	\N	0.129644314670806	1	0.010803692889233834	1	-1
14452	505	240	\N	0.129644314670806	1	0.010803692889233834	1	-1
14453	505	1057	\N	0.129644314670806	1	0.010803692889233834	1	-1
14454	505	1118	\N	0.129644314670806	1	0.010803692889233834	1	-1
14455	505	443	\N	0.21164215327265087	1	0.01763684610605424	1	-1
14456	506	442	\N	0.14153139837313344	1	0.011794283197761121	1	-1
14457	506	198	\N	0.4962245889330735	1	0.04135204907775612	1	-1
14458	506	241	\N	0.4962245889330735	1	0.04135204907775612	1	-1
14459	506	1056	\N	0.4962245889330735	1	0.04135204907775612	1	-1
14460	506	1119	\N	0.4962245889330735	1	0.04135204907775612	1	-1
14461	506	263	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14462	506	312	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14463	506	961	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14464	506	1029	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14465	506	1234	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14466	506	1235	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14467	506	1475	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14468	506	1510	\N	2.9043472417557106	1	0.24202893681297588	1	-1
14469	507	441	\N	0.12	1	0.01	1	-1
14470	507	440	\N	1.6555677377099824	1	0.13796397814249853	1	-1
14471	509	439	\N	0.12	1	0.01	1	-1
14472	509	265	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14473	509	310	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14474	509	963	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14475	509	1027	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14476	509	1477	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14477	509	1508	\N	0.12067016254312868	1	0.010055846878594055	1	-1
14478	510	266	\N	0.12	1	0.01	1	-1
14479	510	309	\N	0.12	1	0.01	1	-1
14480	510	964	\N	0.12	1	0.01	1	-1
14481	510	1026	\N	0.12	1	0.01	1	-1
14482	510	1478	\N	0.12	1	0.01	1	-1
14483	510	1507	\N	0.12	1	0.01	1	-1
14484	510	438	\N	0.12	1	0.01	1	-1
14485	526	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14486	526	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14487	526	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14488	526	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14489	526	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14490	526	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14491	526	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14492	526	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14493	526	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14494	526	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14495	526	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14496	526	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14497	884	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14498	884	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14499	884	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14500	884	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14501	884	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14502	884	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14503	884	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14504	884	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14505	884	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14506	884	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14507	884	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14508	884	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14509	990	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14510	990	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14511	990	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14512	990	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14513	990	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14514	990	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14515	990	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14516	990	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14517	990	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14518	990	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14519	990	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14520	990	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14521	1143	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14522	1143	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14523	1143	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14524	1143	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14525	1143	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14526	1143	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14527	1143	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14528	1143	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14529	1143	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14530	1143	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14531	1143	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14532	1143	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14533	1213	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14534	1213	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14535	1213	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14536	1213	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14537	1213	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14538	1213	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14539	1213	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14540	1213	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14541	1213	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14542	1213	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14543	1213	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14544	1213	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14545	1285	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14546	1285	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14547	1285	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14548	1285	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14549	1285	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14550	1285	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14551	1285	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14552	1285	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14553	1285	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14554	1285	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14555	1285	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14556	1285	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14557	1454	456	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14558	1454	525	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14559	1454	749	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14560	1454	826	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14561	1454	883	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14562	1454	989	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14563	1454	1071	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14564	1454	1142	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14565	1454	1256	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14566	1454	1304	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14567	1454	1357	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14568	1454	1453	\N	1.5726080850705748	1	0.13105067375588123	1	-1
14569	526	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14570	526	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14571	526	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14572	526	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14573	526	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14574	526	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14575	526	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14576	526	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14577	526	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14578	884	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14579	884	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14580	884	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14581	884	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14582	884	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14583	884	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14584	884	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14585	884	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14586	884	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14587	990	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14588	990	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14589	990	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14590	990	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14591	990	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14592	990	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14593	990	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14594	990	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14595	990	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14596	1143	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14597	1143	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14598	1143	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14599	1143	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14600	1143	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14601	1143	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14602	1143	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14603	1143	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14604	1143	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14605	1213	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14606	1213	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14607	1213	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14608	1213	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14609	1213	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14610	1213	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14611	1213	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14612	1213	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14613	1213	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14614	1285	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14615	1285	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14616	1285	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14617	1285	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14618	1285	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14619	1285	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14620	1285	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14621	1285	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14622	1285	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14623	1454	544	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14624	1454	768	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14625	1454	800	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14626	1454	905	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14627	1454	1001	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14628	1454	1102	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14629	1454	1187	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14630	1454	1333	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14631	1454	1531	\N	2.3066067448628993	1	0.19221722873857494	1	-1
14632	526	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14633	884	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14634	990	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14635	1143	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14636	1213	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14637	1285	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14638	1454	491	\N	2.353470913855814	1	0.19612257615465117	1	-1
14639	528	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14640	528	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14641	542	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14642	542	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14643	886	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14644	886	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14645	903	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14646	903	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14647	992	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14648	992	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14649	999	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14650	999	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14651	1145	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14652	1145	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14653	1185	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14654	1185	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14655	1215	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14656	1215	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14657	1254	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14658	1254	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14659	1287	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14660	1287	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14661	1302	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14662	1302	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14663	1456	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14664	1456	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14665	1529	887	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14666	1529	902	\N	0.7547606126777787	1	0.06289671772314823	1	-1
14667	531	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14668	531	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14669	531	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14670	531	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14671	531	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14672	531	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14673	995	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14674	995	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14675	995	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14676	995	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14677	995	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14678	995	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14679	1148	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14680	1148	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14681	1148	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14682	1148	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14683	1148	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14684	1148	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14685	1218	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14686	1218	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14687	1218	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14688	1218	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14689	1218	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14690	1218	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14691	1290	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14692	1290	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14693	1290	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14694	1290	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14695	1290	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14696	1290	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14697	1459	697	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14698	1459	720	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14699	1459	1150	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14700	1459	1181	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14701	1459	1408	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14702	1459	1429	\N	2.9030302802742964	1	0.24191919002285803	1	-1
14703	532	145	\N	0.12	1	0.01	1	-1
14704	532	170	\N	0.12	1	0.01	1	-1
14705	532	539	\N	0.12	1	0.01	1	-1
14706	532	1045	\N	0.12	1	0.01	1	-1
14707	532	1251	\N	0.12	1	0.01	1	-1
14708	532	1299	\N	0.12	1	0.01	1	-1
14709	532	1526	\N	0.12	1	0.01	1	-1
14710	996	145	\N	0.12	1	0.01	1	-1
14711	996	170	\N	0.12	1	0.01	1	-1
14712	996	539	\N	0.12	1	0.01	1	-1
14713	996	1045	\N	0.12	1	0.01	1	-1
14714	996	1251	\N	0.12	1	0.01	1	-1
14715	996	1299	\N	0.12	1	0.01	1	-1
14716	996	1526	\N	0.12	1	0.01	1	-1
14717	1149	145	\N	0.12	1	0.01	1	-1
14718	1149	170	\N	0.12	1	0.01	1	-1
14719	1149	539	\N	0.12	1	0.01	1	-1
14720	1149	1045	\N	0.12	1	0.01	1	-1
14721	1149	1251	\N	0.12	1	0.01	1	-1
14722	1149	1299	\N	0.12	1	0.01	1	-1
14723	1149	1526	\N	0.12	1	0.01	1	-1
14724	1182	145	\N	0.12	1	0.01	1	-1
14725	1182	170	\N	0.12	1	0.01	1	-1
14726	1182	539	\N	0.12	1	0.01	1	-1
14727	1182	1045	\N	0.12	1	0.01	1	-1
14728	1182	1251	\N	0.12	1	0.01	1	-1
14729	1182	1299	\N	0.12	1	0.01	1	-1
14730	1182	1526	\N	0.12	1	0.01	1	-1
14731	1219	145	\N	0.12	1	0.01	1	-1
14732	1219	170	\N	0.12	1	0.01	1	-1
14733	1219	539	\N	0.12	1	0.01	1	-1
14734	1219	1045	\N	0.12	1	0.01	1	-1
14735	1219	1251	\N	0.12	1	0.01	1	-1
14736	1219	1299	\N	0.12	1	0.01	1	-1
14737	1219	1526	\N	0.12	1	0.01	1	-1
14738	1291	145	\N	0.12	1	0.01	1	-1
14739	1291	170	\N	0.12	1	0.01	1	-1
14740	1291	539	\N	0.12	1	0.01	1	-1
14741	1291	1045	\N	0.12	1	0.01	1	-1
14742	1291	1251	\N	0.12	1	0.01	1	-1
14743	1291	1299	\N	0.12	1	0.01	1	-1
14744	1291	1526	\N	0.12	1	0.01	1	-1
14745	1407	145	\N	0.12	1	0.01	1	-1
14746	1407	170	\N	0.12	1	0.01	1	-1
14747	1407	539	\N	0.12	1	0.01	1	-1
14748	1407	1045	\N	0.12	1	0.01	1	-1
14749	1407	1251	\N	0.12	1	0.01	1	-1
14750	1407	1299	\N	0.12	1	0.01	1	-1
14751	1407	1526	\N	0.12	1	0.01	1	-1
14752	1430	145	\N	0.12	1	0.01	1	-1
14753	1430	170	\N	0.12	1	0.01	1	-1
14754	1430	539	\N	0.12	1	0.01	1	-1
14755	1430	1045	\N	0.12	1	0.01	1	-1
14756	1430	1251	\N	0.12	1	0.01	1	-1
14757	1430	1299	\N	0.12	1	0.01	1	-1
14758	1430	1526	\N	0.12	1	0.01	1	-1
14759	1460	145	\N	0.12	1	0.01	1	-1
14760	1460	170	\N	0.12	1	0.01	1	-1
14761	1460	539	\N	0.12	1	0.01	1	-1
14762	1460	1045	\N	0.12	1	0.01	1	-1
14763	1460	1251	\N	0.12	1	0.01	1	-1
14764	1460	1299	\N	0.12	1	0.01	1	-1
14765	1460	1526	\N	0.12	1	0.01	1	-1
14766	532	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14767	532	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14768	532	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14769	532	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14770	532	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14771	532	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14772	996	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14773	996	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14774	996	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14775	996	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14776	996	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14777	996	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14778	1149	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14779	1149	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14780	1149	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14781	1149	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14782	1149	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14783	1149	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14784	1182	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14785	1182	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14786	1182	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14787	1182	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14788	1182	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14789	1182	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14790	1219	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14791	1219	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14792	1219	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14793	1219	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14794	1219	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14795	1219	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14796	1291	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14797	1291	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14798	1291	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14799	1291	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14800	1291	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14801	1291	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14802	1407	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14803	1407	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14804	1407	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14805	1407	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14806	1407	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14807	1407	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14808	1430	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14809	1430	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14810	1430	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14811	1430	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14812	1430	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14813	1430	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14814	1460	697	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14815	1460	720	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14816	1460	1150	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14817	1460	1181	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14818	1460	1408	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14819	1460	1429	\N	0.3075518927458607	1	0.02562932439548839	1	-1
14820	533	168	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14821	533	537	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14822	533	1043	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14823	533	1249	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14824	533	1297	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14825	533	1405	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14826	533	1432	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14827	533	1524	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14828	947	168	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14829	947	537	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14830	947	1043	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14831	947	1249	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14832	947	1297	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14833	947	1405	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14834	947	1432	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14835	947	1524	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14836	1220	168	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14837	1220	537	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14838	1220	1043	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14839	1220	1249	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14840	1220	1297	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14841	1220	1405	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14842	1220	1432	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14843	1220	1524	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14844	1292	168	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14845	1292	537	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14846	1292	1043	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14847	1292	1249	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14848	1292	1297	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14849	1292	1405	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14850	1292	1432	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14851	1292	1524	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14852	1461	168	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14853	1461	537	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14854	1461	1043	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14855	1461	1249	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14856	1461	1297	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14857	1461	1405	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14858	1461	1432	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14859	1461	1524	\N	0.3782592097500594	1	0.03152160081250495	1	-1
14860	534	101	\N	0.12	1	0.01	1	-1
14861	534	121	\N	0.12	1	0.01	1	-1
14862	534	147	\N	0.12	1	0.01	1	-1
14863	534	167	\N	0.12	1	0.01	1	-1
14864	534	336	\N	0.12	1	0.01	1	-1
14865	534	356	\N	0.12	1	0.01	1	-1
14866	536	101	\N	0.12	1	0.01	1	-1
14867	536	121	\N	0.12	1	0.01	1	-1
14868	536	147	\N	0.12	1	0.01	1	-1
14869	536	167	\N	0.12	1	0.01	1	-1
14870	536	336	\N	0.12	1	0.01	1	-1
14871	536	356	\N	0.12	1	0.01	1	-1
14872	948	101	\N	0.12	1	0.01	1	-1
14873	948	121	\N	0.12	1	0.01	1	-1
14874	948	147	\N	0.12	1	0.01	1	-1
14875	948	167	\N	0.12	1	0.01	1	-1
14876	948	336	\N	0.12	1	0.01	1	-1
14877	948	356	\N	0.12	1	0.01	1	-1
14878	1042	101	\N	0.12	1	0.01	1	-1
14879	1042	121	\N	0.12	1	0.01	1	-1
14880	1042	147	\N	0.12	1	0.01	1	-1
14881	1042	167	\N	0.12	1	0.01	1	-1
14882	1042	336	\N	0.12	1	0.01	1	-1
14883	1042	356	\N	0.12	1	0.01	1	-1
14884	1221	101	\N	0.12	1	0.01	1	-1
14885	1221	121	\N	0.12	1	0.01	1	-1
14886	1221	147	\N	0.12	1	0.01	1	-1
14887	1221	167	\N	0.12	1	0.01	1	-1
14888	1221	336	\N	0.12	1	0.01	1	-1
14889	1221	356	\N	0.12	1	0.01	1	-1
14890	1248	101	\N	0.12	1	0.01	1	-1
14891	1248	121	\N	0.12	1	0.01	1	-1
14892	1248	147	\N	0.12	1	0.01	1	-1
14893	1248	167	\N	0.12	1	0.01	1	-1
14894	1248	336	\N	0.12	1	0.01	1	-1
14895	1248	356	\N	0.12	1	0.01	1	-1
14896	1293	101	\N	0.12	1	0.01	1	-1
14897	1293	121	\N	0.12	1	0.01	1	-1
14898	1293	147	\N	0.12	1	0.01	1	-1
14899	1293	167	\N	0.12	1	0.01	1	-1
14900	1293	336	\N	0.12	1	0.01	1	-1
14901	1293	356	\N	0.12	1	0.01	1	-1
14902	1296	101	\N	0.12	1	0.01	1	-1
14903	1296	121	\N	0.12	1	0.01	1	-1
14904	1296	147	\N	0.12	1	0.01	1	-1
14905	1296	167	\N	0.12	1	0.01	1	-1
14906	1296	336	\N	0.12	1	0.01	1	-1
14907	1296	356	\N	0.12	1	0.01	1	-1
14908	1404	101	\N	0.12	1	0.01	1	-1
14909	1404	121	\N	0.12	1	0.01	1	-1
14910	1404	147	\N	0.12	1	0.01	1	-1
14911	1404	167	\N	0.12	1	0.01	1	-1
14912	1404	336	\N	0.12	1	0.01	1	-1
14913	1404	356	\N	0.12	1	0.01	1	-1
14914	1433	101	\N	0.12	1	0.01	1	-1
14915	1433	121	\N	0.12	1	0.01	1	-1
14916	1433	147	\N	0.12	1	0.01	1	-1
14917	1433	167	\N	0.12	1	0.01	1	-1
14918	1433	336	\N	0.12	1	0.01	1	-1
14919	1433	356	\N	0.12	1	0.01	1	-1
14920	1462	101	\N	0.12	1	0.01	1	-1
14921	1462	121	\N	0.12	1	0.01	1	-1
14922	1462	147	\N	0.12	1	0.01	1	-1
14923	1462	167	\N	0.12	1	0.01	1	-1
14924	1462	336	\N	0.12	1	0.01	1	-1
14925	1462	356	\N	0.12	1	0.01	1	-1
14926	1523	101	\N	0.12	1	0.01	1	-1
14927	1523	121	\N	0.12	1	0.01	1	-1
14928	1523	147	\N	0.12	1	0.01	1	-1
14929	1523	167	\N	0.12	1	0.01	1	-1
14930	1523	336	\N	0.12	1	0.01	1	-1
14931	1523	356	\N	0.12	1	0.01	1	-1
14932	534	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14933	534	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14934	534	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14935	534	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14936	534	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14937	534	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14938	536	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14939	536	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14940	536	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14941	536	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14942	536	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14943	536	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14944	948	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14945	948	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14946	948	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14947	948	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14948	948	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14949	948	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14950	1042	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14951	1042	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14952	1042	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14953	1042	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14954	1042	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14955	1042	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14956	1221	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14957	1221	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14958	1221	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14959	1221	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14960	1221	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14961	1221	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14962	1248	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14963	1248	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14964	1248	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14965	1248	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14966	1248	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14967	1248	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14968	1293	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14969	1293	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14970	1293	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14971	1293	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14972	1293	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14973	1293	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14974	1296	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14975	1296	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14976	1296	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14977	1296	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14978	1296	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14979	1296	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14980	1404	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14981	1404	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14982	1404	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14983	1404	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14984	1404	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14985	1404	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14986	1433	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14987	1433	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14988	1433	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14989	1433	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14990	1433	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14991	1433	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14992	1462	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14993	1462	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
14994	1462	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
14995	1462	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
14996	1462	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
14997	1462	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
14998	1523	949	\N	2.909127120018101	1	0.24242726000150844	1	-1
14999	1523	1041	\N	2.909127120018101	1	0.24242726000150844	1	-1
15000	1523	1222	\N	2.909127120018101	1	0.24242726000150844	1	-1
15001	1523	1247	\N	2.909127120018101	1	0.24242726000150844	1	-1
15002	1523	1463	\N	2.909127120018101	1	0.24242726000150844	1	-1
15003	1523	1522	\N	2.909127120018101	1	0.24242726000150844	1	-1
15004	544	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15005	768	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15006	800	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15007	905	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15008	1001	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15009	1102	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15010	1187	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15011	1333	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15012	1531	491	\N	0.12387780511830326	1	0.010323150426525271	1	-1
15013	544	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15014	544	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15015	544	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15016	544	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15017	544	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15018	544	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15019	544	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15020	544	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15021	544	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15022	544	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15023	544	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15024	544	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15025	768	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15026	768	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15027	768	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15028	768	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15029	768	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15030	768	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15031	768	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15032	768	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15033	768	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15034	768	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15035	768	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15036	768	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15037	800	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15038	800	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15039	800	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15040	800	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15041	800	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15042	800	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15043	800	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15044	800	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15045	800	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15046	800	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15047	800	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15048	800	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15049	905	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15050	905	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15051	905	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15052	905	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15053	905	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15054	905	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15055	905	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15056	905	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15057	905	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15058	905	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15059	905	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15060	905	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15061	1001	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15062	1001	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15063	1001	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15064	1001	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15065	1001	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15066	1001	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15067	1001	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15068	1001	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15069	1001	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15070	1001	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15071	1001	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15072	1001	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15073	1102	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15074	1102	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15075	1102	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15076	1102	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15077	1102	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15078	1102	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15079	1102	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15080	1102	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15081	1102	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15082	1102	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15083	1102	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15084	1102	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15085	1187	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15086	1187	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15087	1187	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15088	1187	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15089	1187	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15090	1187	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15091	1187	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15092	1187	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15093	1187	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15094	1187	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15095	1187	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15096	1187	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15097	1333	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15098	1333	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15099	1333	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15100	1333	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15101	1333	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15102	1333	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15103	1333	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15104	1333	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15105	1333	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15106	1333	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15107	1333	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15108	1333	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15109	1531	456	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15110	1531	525	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15111	1531	749	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15112	1531	826	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15113	1531	883	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15114	1531	989	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15115	1531	1071	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15116	1531	1142	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15117	1531	1256	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15118	1531	1304	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15119	1531	1357	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15120	1531	1453	\N	1.0723912624781013	1	0.08936593853984179	1	-1
15121	544	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15122	544	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15123	544	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15124	544	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15125	544	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15126	544	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15127	544	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15128	768	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15129	768	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15130	768	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15131	768	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15132	768	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15133	768	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15134	768	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15135	800	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15136	800	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15137	800	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15138	800	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15139	800	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15140	800	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15141	800	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15142	905	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15143	905	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15144	905	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15145	905	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15146	905	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15147	905	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15148	905	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15149	1001	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15150	1001	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15151	1001	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15152	1001	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15153	1001	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15154	1001	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15155	1001	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15156	1102	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15157	1102	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15158	1102	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15159	1102	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15160	1102	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15161	1102	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15162	1102	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15163	1187	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15164	1187	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15165	1187	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15166	1187	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15167	1187	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15168	1187	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15169	1187	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15170	1333	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15171	1333	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15172	1333	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15173	1333	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15174	1333	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15175	1333	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15176	1333	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15177	1531	526	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15178	1531	884	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15179	1531	990	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15180	1531	1143	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15181	1531	1213	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15182	1531	1285	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15183	1531	1454	\N	2.3066067448628993	1	0.19221722873857494	1	-1
15184	545	492	\N	0.7733101074698635	1	0.06444250895582196	1	-1
15185	769	492	\N	0.7733101074698635	1	0.06444250895582196	1	-1
15186	801	492	\N	0.7733101074698635	1	0.06444250895582196	1	-1
15187	906	492	\N	0.7733101074698635	1	0.06444250895582196	1	-1
15188	545	216	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15189	545	225	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15190	545	455	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15191	545	524	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15192	545	748	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15193	545	825	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15194	545	882	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15195	545	1070	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15196	545	1103	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15197	545	1141	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15198	545	1188	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15199	545	1334	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15200	545	1356	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15201	769	216	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15202	769	225	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15203	769	455	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15204	769	524	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15205	769	748	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15206	769	825	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15207	769	882	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15208	769	1070	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15209	769	1103	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15210	769	1141	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15211	769	1188	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15212	769	1334	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15213	769	1356	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15214	801	216	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15215	801	225	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15216	801	455	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15217	801	524	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15218	801	748	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15219	801	825	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15220	801	882	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15221	801	1070	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15222	801	1103	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15223	801	1141	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15224	801	1188	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15225	801	1334	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15226	801	1356	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15227	906	216	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15228	906	225	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15229	906	455	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15230	906	524	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15231	906	748	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15232	906	825	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15233	906	882	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15234	906	1070	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15235	906	1103	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15236	906	1141	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15237	906	1188	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15238	906	1334	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15239	906	1356	\N	0.8074453639643366	1	0.06728711366369472	1	-1
15240	560	206	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15241	560	684	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15242	560	1131	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15243	560	1346	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15244	560	1373	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15245	590	206	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15246	590	684	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15247	590	1131	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15248	590	1346	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15249	590	1373	\N	1.6381148416291584	1	0.1365095701357632	1	-1
15250	562	812	\N	0.4968753858759558	1	0.04140628215632965	1	-1
15251	592	812	\N	0.4968753858759558	1	0.04140628215632965	1	-1
15252	562	813	\N	2.0716283296038416	1	0.17263569413365348	1	-1
15253	562	814	\N	2.0716283296038416	1	0.17263569413365348	1	-1
15254	592	813	\N	2.0716283296038416	1	0.17263569413365348	1	-1
15255	592	814	\N	2.0716283296038416	1	0.17263569413365348	1	-1
15256	564	871	\N	1.052982976863081	1	0.08774858140525675	1	-1
15257	564	916	\N	1.052982976863081	1	0.08774858140525675	1	-1
15258	594	871	\N	1.052982976863081	1	0.08774858140525675	1	-1
15259	594	916	\N	1.052982976863081	1	0.08774858140525675	1	-1
15260	565	566	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15261	565	596	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15262	595	566	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15263	595	596	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15264	566	565	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15265	566	595	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15266	596	565	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15267	596	595	\N	2.7780245459420296	1	0.23150204549516912	1	-1
15268	571	602	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15269	571	623	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15270	571	649	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15271	571	668	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15272	578	602	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15273	578	623	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15274	578	649	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15275	578	668	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15276	601	602	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15277	601	623	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15278	601	649	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15279	601	668	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15280	624	602	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15281	624	623	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15282	624	649	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15283	624	668	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15284	571	650	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15285	571	667	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15286	578	650	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15287	578	667	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15288	601	650	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15289	601	667	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15290	624	650	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15291	624	667	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15292	574	219	\N	2.145699093859383	1	0.17880825782161527	1	-1
15293	574	222	\N	2.145699093859383	1	0.17880825782161527	1	-1
15294	574	986	\N	2.145699093859383	1	0.17880825782161527	1	-1
15295	574	1004	\N	2.145699093859383	1	0.17880825782161527	1	-1
15296	574	1450	\N	2.145699093859383	1	0.17880825782161527	1	-1
15297	574	1534	\N	2.145699093859383	1	0.17880825782161527	1	-1
15298	575	219	\N	2.145699093859383	1	0.17880825782161527	1	-1
15299	575	222	\N	2.145699093859383	1	0.17880825782161527	1	-1
15300	575	986	\N	2.145699093859383	1	0.17880825782161527	1	-1
15301	575	1004	\N	2.145699093859383	1	0.17880825782161527	1	-1
15302	575	1450	\N	2.145699093859383	1	0.17880825782161527	1	-1
15303	575	1534	\N	2.145699093859383	1	0.17880825782161527	1	-1
15304	582	872	\N	0.9688796090024575	1	0.08073996741687146	1	-1
15305	582	915	\N	0.9688796090024575	1	0.08073996741687146	1	-1
15306	628	872	\N	0.9688796090024575	1	0.08073996741687146	1	-1
15307	628	915	\N	0.9688796090024575	1	0.08073996741687146	1	-1
15308	582	811	\N	1.064051542189758	1	0.08867096184914651	1	-1
15309	628	811	\N	1.064051542189758	1	0.08867096184914651	1	-1
15310	583	873	\N	0.22895093530658406	1	0.019079244608882006	1	-1
15311	583	914	\N	0.22895093530658406	1	0.019079244608882006	1	-1
15312	629	873	\N	0.22895093530658406	1	0.019079244608882006	1	-1
15313	629	914	\N	0.22895093530658406	1	0.019079244608882006	1	-1
15314	585	34	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15315	585	86	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15316	585	112	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15317	585	158	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15318	585	207	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15319	585	347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15320	585	389	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15321	585	409	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15322	585	586	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15323	585	632	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15324	585	686	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15325	585	1132	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15326	585	1347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15327	585	1374	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15328	631	34	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15329	631	86	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15330	631	112	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15331	631	158	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15332	631	207	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15333	631	347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15334	631	389	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15335	631	409	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15336	631	586	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15337	631	632	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15338	631	686	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15339	631	1132	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15340	631	1347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15341	631	1374	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15342	685	34	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15343	685	86	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15344	685	112	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15345	685	158	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15346	685	207	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15347	685	347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15348	685	389	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15349	685	409	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15350	685	586	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15351	685	632	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15352	685	686	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15353	685	1132	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15354	685	1347	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15355	685	1374	\N	0.6237606479679764	1	0.05198005399733137	1	-1
15356	585	815	\N	0.6468687641905084	1	0.05390573034920904	1	-1
15357	631	815	\N	0.6468687641905084	1	0.05390573034920904	1	-1
15358	685	815	\N	0.6468687641905084	1	0.05390573034920904	1	-1
15359	602	571	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15360	602	578	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15361	602	601	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15362	602	624	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15363	623	571	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15364	623	578	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15365	623	601	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15366	623	624	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15367	649	571	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15368	649	578	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15369	649	601	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15370	649	624	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15371	668	571	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15372	668	578	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15373	668	601	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15374	668	624	\N	0.5078049717889147	1	0.04231708098240956	1	-1
15375	602	650	\N	2.335235787077491	1	0.19460298225645759	1	-1
15376	602	667	\N	2.335235787077491	1	0.19460298225645759	1	-1
15377	623	650	\N	2.335235787077491	1	0.19460298225645759	1	-1
15378	623	667	\N	2.335235787077491	1	0.19460298225645759	1	-1
15379	649	650	\N	2.335235787077491	1	0.19460298225645759	1	-1
15380	649	667	\N	2.335235787077491	1	0.19460298225645759	1	-1
15381	668	650	\N	2.335235787077491	1	0.19460298225645759	1	-1
15382	668	667	\N	2.335235787077491	1	0.19460298225645759	1	-1
15383	604	982	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15384	604	1008	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15385	604	1446	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15386	604	1538	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15387	621	982	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15388	621	1008	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15389	621	1446	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15390	621	1538	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15391	647	982	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15392	647	1008	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15393	647	1446	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15394	647	1538	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15395	670	982	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15396	670	1008	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15397	670	1446	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15398	670	1538	\N	0.3695314974451671	1	0.030794291453763927	1	-1
15399	607	979	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15400	607	1443	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15401	644	979	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15402	644	1443	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15403	673	979	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15404	673	1443	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15405	1011	979	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15406	1011	1443	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15407	1541	979	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15408	1541	1443	\N	0.18504892771830686	1	0.015420743976525571	1	-1
15409	607	618	\N	0.6414623589118	1	0.053455196575983334	1	-1
15410	607	855	\N	0.6414623589118	1	0.053455196575983334	1	-1
15411	607	932	\N	0.6414623589118	1	0.053455196575983334	1	-1
15412	644	618	\N	0.6414623589118	1	0.053455196575983334	1	-1
15413	644	855	\N	0.6414623589118	1	0.053455196575983334	1	-1
15414	644	932	\N	0.6414623589118	1	0.053455196575983334	1	-1
15415	673	618	\N	0.6414623589118	1	0.053455196575983334	1	-1
15416	673	855	\N	0.6414623589118	1	0.053455196575983334	1	-1
15417	673	932	\N	0.6414623589118	1	0.053455196575983334	1	-1
15418	1011	618	\N	0.6414623589118	1	0.053455196575983334	1	-1
15419	1011	855	\N	0.6414623589118	1	0.053455196575983334	1	-1
15420	1011	932	\N	0.6414623589118	1	0.053455196575983334	1	-1
15421	1541	618	\N	0.6414623589118	1	0.053455196575983334	1	-1
15422	1541	855	\N	0.6414623589118	1	0.053455196575983334	1	-1
15423	1541	932	\N	0.6414623589118	1	0.053455196575983334	1	-1
15424	607	608	\N	2.805445966025075	1	0.2337871638354229	1	-1
15425	607	617	\N	2.805445966025075	1	0.2337871638354229	1	-1
15426	607	854	\N	2.805445966025075	1	0.2337871638354229	1	-1
15427	607	933	\N	2.805445966025075	1	0.2337871638354229	1	-1
15428	607	1542	\N	2.805445966025075	1	0.2337871638354229	1	-1
15429	644	608	\N	2.805445966025075	1	0.2337871638354229	1	-1
15430	644	617	\N	2.805445966025075	1	0.2337871638354229	1	-1
15431	644	854	\N	2.805445966025075	1	0.2337871638354229	1	-1
15432	644	933	\N	2.805445966025075	1	0.2337871638354229	1	-1
15433	644	1542	\N	2.805445966025075	1	0.2337871638354229	1	-1
15434	673	608	\N	2.805445966025075	1	0.2337871638354229	1	-1
15435	673	617	\N	2.805445966025075	1	0.2337871638354229	1	-1
15436	673	854	\N	2.805445966025075	1	0.2337871638354229	1	-1
15437	673	933	\N	2.805445966025075	1	0.2337871638354229	1	-1
15438	673	1542	\N	2.805445966025075	1	0.2337871638354229	1	-1
15439	1011	608	\N	2.805445966025075	1	0.2337871638354229	1	-1
15440	1011	617	\N	2.805445966025075	1	0.2337871638354229	1	-1
15441	1011	854	\N	2.805445966025075	1	0.2337871638354229	1	-1
15442	1011	933	\N	2.805445966025075	1	0.2337871638354229	1	-1
15443	1011	1542	\N	2.805445966025075	1	0.2337871638354229	1	-1
15444	1541	608	\N	2.805445966025075	1	0.2337871638354229	1	-1
15445	1541	617	\N	2.805445966025075	1	0.2337871638354229	1	-1
15446	1541	854	\N	2.805445966025075	1	0.2337871638354229	1	-1
15447	1541	933	\N	2.805445966025075	1	0.2337871638354229	1	-1
15448	1541	1542	\N	2.805445966025075	1	0.2337871638354229	1	-1
15449	608	618	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15450	608	855	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15451	608	932	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15452	617	618	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15453	617	855	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15454	617	932	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15455	854	618	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15456	854	855	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15457	854	932	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15458	933	618	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15459	933	855	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15460	933	932	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15461	1542	618	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15462	1542	855	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15463	1542	932	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15464	608	979	\N	2.627523179900483	1	0.21896026499170693	1	-1
15465	608	1443	\N	2.627523179900483	1	0.21896026499170693	1	-1
15466	617	979	\N	2.627523179900483	1	0.21896026499170693	1	-1
15467	617	1443	\N	2.627523179900483	1	0.21896026499170693	1	-1
15468	854	979	\N	2.627523179900483	1	0.21896026499170693	1	-1
15469	854	1443	\N	2.627523179900483	1	0.21896026499170693	1	-1
15470	933	979	\N	2.627523179900483	1	0.21896026499170693	1	-1
15471	933	1443	\N	2.627523179900483	1	0.21896026499170693	1	-1
15472	1542	979	\N	2.627523179900483	1	0.21896026499170693	1	-1
15473	1542	1443	\N	2.627523179900483	1	0.21896026499170693	1	-1
15474	608	607	\N	2.805445966025075	1	0.2337871638354229	1	-1
15475	608	644	\N	2.805445966025075	1	0.2337871638354229	1	-1
15476	608	673	\N	2.805445966025075	1	0.2337871638354229	1	-1
15477	608	1011	\N	2.805445966025075	1	0.2337871638354229	1	-1
15478	608	1541	\N	2.805445966025075	1	0.2337871638354229	1	-1
15479	617	607	\N	2.805445966025075	1	0.2337871638354229	1	-1
15480	617	644	\N	2.805445966025075	1	0.2337871638354229	1	-1
15481	617	673	\N	2.805445966025075	1	0.2337871638354229	1	-1
15482	617	1011	\N	2.805445966025075	1	0.2337871638354229	1	-1
15483	617	1541	\N	2.805445966025075	1	0.2337871638354229	1	-1
15484	854	607	\N	2.805445966025075	1	0.2337871638354229	1	-1
15485	854	644	\N	2.805445966025075	1	0.2337871638354229	1	-1
15486	854	673	\N	2.805445966025075	1	0.2337871638354229	1	-1
15487	854	1011	\N	2.805445966025075	1	0.2337871638354229	1	-1
15488	854	1541	\N	2.805445966025075	1	0.2337871638354229	1	-1
15489	933	607	\N	2.805445966025075	1	0.2337871638354229	1	-1
15490	933	644	\N	2.805445966025075	1	0.2337871638354229	1	-1
15491	933	673	\N	2.805445966025075	1	0.2337871638354229	1	-1
15492	933	1011	\N	2.805445966025075	1	0.2337871638354229	1	-1
15493	933	1541	\N	2.805445966025075	1	0.2337871638354229	1	-1
15494	1542	607	\N	2.805445966025075	1	0.2337871638354229	1	-1
15495	1542	644	\N	2.805445966025075	1	0.2337871638354229	1	-1
15496	1542	673	\N	2.805445966025075	1	0.2337871638354229	1	-1
15497	1542	1011	\N	2.805445966025075	1	0.2337871638354229	1	-1
15498	1542	1541	\N	2.805445966025075	1	0.2337871638354229	1	-1
15499	609	1442	\N	0.8280488402862659	1	0.06900407002385549	1	-1
15500	616	1442	\N	0.8280488402862659	1	0.06900407002385549	1	-1
15501	853	1442	\N	0.8280488402862659	1	0.06900407002385549	1	-1
15502	934	1442	\N	0.8280488402862659	1	0.06900407002385549	1	-1
15503	1543	1442	\N	0.8280488402862659	1	0.06900407002385549	1	-1
15504	611	850	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15505	611	937	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15506	614	850	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15507	614	937	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15508	851	850	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15509	851	937	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15510	936	850	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15511	936	937	\N	1.3676932950223817	1	0.11397444125186514	1	-1
15512	618	979	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15513	618	1443	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15514	855	979	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15515	855	1443	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15516	932	979	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15517	932	1443	\N	0.6039780913667877	1	0.05033150761389898	1	-1
15518	618	607	\N	0.6414623589118	1	0.053455196575983334	1	-1
15519	618	644	\N	0.6414623589118	1	0.053455196575983334	1	-1
15520	618	673	\N	0.6414623589118	1	0.053455196575983334	1	-1
15521	618	1011	\N	0.6414623589118	1	0.053455196575983334	1	-1
15522	618	1541	\N	0.6414623589118	1	0.053455196575983334	1	-1
15523	855	607	\N	0.6414623589118	1	0.053455196575983334	1	-1
15524	855	644	\N	0.6414623589118	1	0.053455196575983334	1	-1
15525	855	673	\N	0.6414623589118	1	0.053455196575983334	1	-1
15526	855	1011	\N	0.6414623589118	1	0.053455196575983334	1	-1
15527	855	1541	\N	0.6414623589118	1	0.053455196575983334	1	-1
15528	932	607	\N	0.6414623589118	1	0.053455196575983334	1	-1
15529	932	644	\N	0.6414623589118	1	0.053455196575983334	1	-1
15530	932	673	\N	0.6414623589118	1	0.053455196575983334	1	-1
15531	932	1011	\N	0.6414623589118	1	0.053455196575983334	1	-1
15532	932	1541	\N	0.6414623589118	1	0.053455196575983334	1	-1
15533	618	608	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15534	618	617	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15535	618	854	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15536	618	933	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15537	618	1542	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15538	855	608	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15539	855	617	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15540	855	854	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15541	855	933	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15542	855	1542	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15543	932	608	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15544	932	617	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15545	932	854	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15546	932	933	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15547	932	1542	\N	2.4898500455583994	1	0.2074875037965333	1	-1
15548	636	841	\N	0.12	1	0.01	1	-1
15549	636	946	\N	0.12	1	0.01	1	-1
15550	681	841	\N	0.12	1	0.01	1	-1
15551	681	946	\N	0.12	1	0.01	1	-1
15552	636	842	\N	2.4347223449054227	1	0.20289352874211855	1	-1
15553	636	945	\N	2.4347223449054227	1	0.20289352874211855	1	-1
15554	681	842	\N	2.4347223449054227	1	0.20289352874211855	1	-1
15555	681	945	\N	2.4347223449054227	1	0.20289352874211855	1	-1
15556	637	842	\N	1.0534099211497847	1	0.0877841600958154	1	-1
15557	637	945	\N	1.0534099211497847	1	0.0877841600958154	1	-1
15558	680	842	\N	1.0534099211497847	1	0.0877841600958154	1	-1
15559	680	945	\N	1.0534099211497847	1	0.0877841600958154	1	-1
15560	637	843	\N	1.0645500057137314	1	0.08871250047614429	1	-1
15561	637	944	\N	1.0645500057137314	1	0.08871250047614429	1	-1
15562	680	843	\N	1.0645500057137314	1	0.08871250047614429	1	-1
15563	680	944	\N	1.0645500057137314	1	0.08871250047614429	1	-1
15564	637	844	\N	2.397621843093984	1	0.19980182025783202	1	-1
15565	637	943	\N	2.397621843093984	1	0.19980182025783202	1	-1
15566	680	844	\N	2.397621843093984	1	0.19980182025783202	1	-1
15567	680	943	\N	2.397621843093984	1	0.19980182025783202	1	-1
15568	638	845	\N	0.12	1	0.01	1	-1
15569	638	942	\N	0.12	1	0.01	1	-1
15570	679	845	\N	0.12	1	0.01	1	-1
15571	679	942	\N	0.12	1	0.01	1	-1
15572	638	846	\N	2.71699149156154	1	0.22641595763012834	1	-1
15573	638	941	\N	2.71699149156154	1	0.22641595763012834	1	-1
15574	679	846	\N	2.71699149156154	1	0.22641595763012834	1	-1
15575	679	941	\N	2.71699149156154	1	0.22641595763012834	1	-1
15576	638	844	\N	2.9157798841356195	1	0.24298165701130162	1	-1
15577	638	943	\N	2.9157798841356195	1	0.24298165701130162	1	-1
15578	679	844	\N	2.9157798841356195	1	0.24298165701130162	1	-1
15579	679	943	\N	2.9157798841356195	1	0.24298165701130162	1	-1
15580	639	847	\N	0.12	1	0.01	1	-1
15581	639	940	\N	0.12	1	0.01	1	-1
15582	678	847	\N	0.12	1	0.01	1	-1
15583	678	940	\N	0.12	1	0.01	1	-1
15584	639	848	\N	1.8610916783073825	1	0.15509097319228188	1	-1
15585	639	939	\N	1.8610916783073825	1	0.15509097319228188	1	-1
15586	678	848	\N	1.8610916783073825	1	0.15509097319228188	1	-1
15587	678	939	\N	1.8610916783073825	1	0.15509097319228188	1	-1
15588	639	846	\N	2.4068894353227837	1	0.20057411961023194	1	-1
15589	639	941	\N	2.4068894353227837	1	0.20057411961023194	1	-1
15590	678	846	\N	2.4068894353227837	1	0.20057411961023194	1	-1
15591	678	941	\N	2.4068894353227837	1	0.20057411961023194	1	-1
15592	643	856	\N	0.705419758402779	1	0.058784979866898256	1	-1
15593	643	931	\N	0.705419758402779	1	0.058784979866898256	1	-1
15594	643	978	\N	0.705419758402779	1	0.058784979866898256	1	-1
15595	643	1012	\N	0.705419758402779	1	0.058784979866898256	1	-1
15596	643	1492	\N	0.705419758402779	1	0.058784979866898256	1	-1
15597	643	1493	\N	0.705419758402779	1	0.058784979866898256	1	-1
15598	674	856	\N	0.705419758402779	1	0.058784979866898256	1	-1
15599	674	931	\N	0.705419758402779	1	0.058784979866898256	1	-1
15600	674	978	\N	0.705419758402779	1	0.058784979866898256	1	-1
15601	674	1012	\N	0.705419758402779	1	0.058784979866898256	1	-1
15602	674	1492	\N	0.705419758402779	1	0.058784979866898256	1	-1
15603	674	1493	\N	0.705419758402779	1	0.058784979866898256	1	-1
15604	650	571	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15605	650	578	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15606	650	601	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15607	650	624	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15608	667	571	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15609	667	578	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15610	667	601	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15611	667	624	\N	1.8951494999766685	1	0.1579291249980557	1	-1
15612	650	602	\N	2.335235787077491	1	0.19460298225645759	1	-1
15613	650	623	\N	2.335235787077491	1	0.19460298225645759	1	-1
15614	650	649	\N	2.335235787077491	1	0.19460298225645759	1	-1
15615	650	668	\N	2.335235787077491	1	0.19460298225645759	1	-1
15616	667	602	\N	2.335235787077491	1	0.19460298225645759	1	-1
15617	667	623	\N	2.335235787077491	1	0.19460298225645759	1	-1
15618	667	649	\N	2.335235787077491	1	0.19460298225645759	1	-1
15619	667	668	\N	2.335235787077491	1	0.19460298225645759	1	-1
15620	653	879	\N	0.3871386831010355	1	0.03226155692508629	1	-1
15621	664	879	\N	0.3871386831010355	1	0.03226155692508629	1	-1
15622	909	879	\N	0.3871386831010355	1	0.03226155692508629	1	-1
15623	653	213	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15624	653	452	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15625	653	521	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15626	653	745	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15627	653	822	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15628	653	1067	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15629	653	1138	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15630	653	1353	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15631	664	213	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15632	664	452	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15633	664	521	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15634	664	745	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15635	664	822	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15636	664	1067	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15637	664	1138	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15638	664	1353	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15639	909	213	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15640	909	452	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15641	909	521	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15642	909	745	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15643	909	822	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15644	909	1067	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15645	909	1138	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15646	909	1353	\N	2.7788375414318334	1	0.23156979511931947	1	-1
15647	653	228	\N	2.956346094308939	1	0.2463621745257449	1	-1
15648	653	495	\N	2.956346094308939	1	0.2463621745257449	1	-1
15649	653	548	\N	2.956346094308939	1	0.2463621745257449	1	-1
15650	653	772	\N	2.956346094308939	1	0.2463621745257449	1	-1
15651	653	804	\N	2.956346094308939	1	0.2463621745257449	1	-1
15652	653	1106	\N	2.956346094308939	1	0.2463621745257449	1	-1
15653	653	1191	\N	2.956346094308939	1	0.2463621745257449	1	-1
15654	653	1337	\N	2.956346094308939	1	0.2463621745257449	1	-1
15655	664	228	\N	2.956346094308939	1	0.2463621745257449	1	-1
15656	664	495	\N	2.956346094308939	1	0.2463621745257449	1	-1
15657	664	548	\N	2.956346094308939	1	0.2463621745257449	1	-1
15658	664	772	\N	2.956346094308939	1	0.2463621745257449	1	-1
15659	664	804	\N	2.956346094308939	1	0.2463621745257449	1	-1
15660	664	1106	\N	2.956346094308939	1	0.2463621745257449	1	-1
15661	664	1191	\N	2.956346094308939	1	0.2463621745257449	1	-1
15662	664	1337	\N	2.956346094308939	1	0.2463621745257449	1	-1
15663	909	228	\N	2.956346094308939	1	0.2463621745257449	1	-1
15664	909	495	\N	2.956346094308939	1	0.2463621745257449	1	-1
15665	909	548	\N	2.956346094308939	1	0.2463621745257449	1	-1
15666	909	772	\N	2.956346094308939	1	0.2463621745257449	1	-1
15667	909	804	\N	2.956346094308939	1	0.2463621745257449	1	-1
15668	909	1106	\N	2.956346094308939	1	0.2463621745257449	1	-1
15669	909	1191	\N	2.956346094308939	1	0.2463621745257449	1	-1
15670	909	1337	\N	2.956346094308939	1	0.2463621745257449	1	-1
15671	654	228	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15672	654	495	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15673	654	548	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15674	654	772	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15675	654	804	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15676	654	1106	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15677	654	1191	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15678	654	1337	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15679	663	228	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15680	663	495	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15681	663	548	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15682	663	772	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15683	663	804	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15684	663	1106	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15685	663	1191	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15686	663	1337	\N	0.8593306649170739	1	0.07161088874308949	1	-1
15687	654	213	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15688	654	452	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15689	654	521	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15690	654	745	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15691	654	822	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15692	654	1067	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15693	654	1138	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15694	654	1353	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15695	663	213	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15696	663	452	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15697	663	521	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15698	663	745	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15699	663	822	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15700	663	1067	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15701	663	1138	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15702	663	1353	\N	0.9703019454032983	1	0.08085849545027486	1	-1
15703	654	879	\N	2.8686787127681073	1	0.23905655939734227	1	-1
15704	663	879	\N	2.8686787127681073	1	0.23905655939734227	1	-1
15705	655	656	\N	2.176122292130324	1	0.18134352434419365	1	-1
15706	655	661	\N	2.176122292130324	1	0.18134352434419365	1	-1
15707	662	656	\N	2.176122292130324	1	0.18134352434419365	1	-1
15708	662	661	\N	2.176122292130324	1	0.18134352434419365	1	-1
15709	656	657	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15710	656	660	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15711	661	657	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15712	661	660	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15713	656	655	\N	2.176122292130324	1	0.18134352434419365	1	-1
15714	656	662	\N	2.176122292130324	1	0.18134352434419365	1	-1
15715	661	655	\N	2.176122292130324	1	0.18134352434419365	1	-1
15716	661	662	\N	2.176122292130324	1	0.18134352434419365	1	-1
15717	657	656	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15718	657	661	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15719	660	656	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15720	660	661	\N	1.5221596167710347	1	0.12684663473091956	1	-1
15721	693	4	\N	1.571972817625759	1	0.13099773480214658	1	-1
15722	693	39	\N	1.571972817625759	1	0.13099773480214658	1	-1
15723	693	46	\N	1.571972817625759	1	0.13099773480214658	1	-1
15724	693	91	\N	1.571972817625759	1	0.13099773480214658	1	-1
15725	693	105	\N	1.571972817625759	1	0.13099773480214658	1	-1
15726	693	117	\N	1.571972817625759	1	0.13099773480214658	1	-1
15727	693	151	\N	1.571972817625759	1	0.13099773480214658	1	-1
15728	693	163	\N	1.571972817625759	1	0.13099773480214658	1	-1
15729	693	340	\N	1.571972817625759	1	0.13099773480214658	1	-1
15730	693	352	\N	1.571972817625759	1	0.13099773480214658	1	-1
15731	693	382	\N	1.571972817625759	1	0.13099773480214658	1	-1
15732	693	394	\N	1.571972817625759	1	0.13099773480214658	1	-1
15733	693	414	\N	1.571972817625759	1	0.13099773480214658	1	-1
15734	693	431	\N	1.571972817625759	1	0.13099773480214658	1	-1
15735	693	514	\N	1.571972817625759	1	0.13099773480214658	1	-1
15736	693	556	\N	1.571972817625759	1	0.13099773480214658	1	-1
15737	693	692	\N	1.571972817625759	1	0.13099773480214658	1	-1
15738	693	725	\N	1.571972817625759	1	0.13099773480214658	1	-1
15739	724	4	\N	1.571972817625759	1	0.13099773480214658	1	-1
15740	724	39	\N	1.571972817625759	1	0.13099773480214658	1	-1
15741	724	46	\N	1.571972817625759	1	0.13099773480214658	1	-1
15742	724	91	\N	1.571972817625759	1	0.13099773480214658	1	-1
15743	724	105	\N	1.571972817625759	1	0.13099773480214658	1	-1
15744	724	117	\N	1.571972817625759	1	0.13099773480214658	1	-1
15745	724	151	\N	1.571972817625759	1	0.13099773480214658	1	-1
15746	724	163	\N	1.571972817625759	1	0.13099773480214658	1	-1
15747	724	340	\N	1.571972817625759	1	0.13099773480214658	1	-1
15748	724	352	\N	1.571972817625759	1	0.13099773480214658	1	-1
15749	724	382	\N	1.571972817625759	1	0.13099773480214658	1	-1
15750	724	394	\N	1.571972817625759	1	0.13099773480214658	1	-1
15751	724	414	\N	1.571972817625759	1	0.13099773480214658	1	-1
15752	724	431	\N	1.571972817625759	1	0.13099773480214658	1	-1
15753	724	514	\N	1.571972817625759	1	0.13099773480214658	1	-1
15754	724	556	\N	1.571972817625759	1	0.13099773480214658	1	-1
15755	724	692	\N	1.571972817625759	1	0.13099773480214658	1	-1
15756	724	725	\N	1.571972817625759	1	0.13099773480214658	1	-1
15757	693	738	\N	1.6468811167107993	1	0.13724009305923326	1	-1
15758	724	738	\N	1.6468811167107993	1	0.13724009305923326	1	-1
15759	697	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15760	697	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15761	697	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15762	697	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15763	697	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15764	697	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15765	697	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15766	697	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15767	697	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15768	720	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15769	720	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15770	720	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15771	720	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15772	720	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15773	720	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15774	720	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15775	720	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15776	720	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15777	1150	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15778	1150	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15779	1150	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15780	1150	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15781	1150	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15782	1150	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15783	1150	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15784	1150	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15785	1150	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15786	1181	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15787	1181	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15788	1181	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15789	1181	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15790	1181	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15791	1181	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15792	1181	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15793	1181	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15794	1181	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15795	1408	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15796	1408	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15797	1408	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15798	1408	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15799	1408	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15800	1408	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15801	1408	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15802	1408	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15803	1408	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15804	1429	532	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15805	1429	996	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15806	1429	1149	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15807	1429	1182	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15808	1429	1219	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15809	1429	1291	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15810	1429	1407	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15811	1429	1430	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15812	1429	1460	\N	0.3075518927458607	1	0.02562932439548839	1	-1
15813	697	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15814	697	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15815	697	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15816	697	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15817	697	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15818	697	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15819	697	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15820	720	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15821	720	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15822	720	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15823	720	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15824	720	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15825	720	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15826	720	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15827	1150	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15828	1150	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15829	1150	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15830	1150	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15831	1150	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15832	1150	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15833	1150	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15834	1181	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15835	1181	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15836	1181	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15837	1181	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15838	1181	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15839	1181	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15840	1181	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15841	1408	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15842	1408	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15843	1408	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15844	1408	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15845	1408	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15846	1408	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15847	1408	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15848	1429	145	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15849	1429	170	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15850	1429	539	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15851	1429	1045	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15852	1429	1251	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15853	1429	1299	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15854	1429	1526	\N	0.3429753323725793	1	0.02858127769771494	1	-1
15855	697	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15856	697	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15857	697	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15858	697	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15859	697	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15860	697	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15861	720	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15862	720	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15863	720	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15864	720	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15865	720	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15866	720	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15867	1150	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15868	1150	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15869	1150	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15870	1150	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15871	1150	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15872	1150	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15873	1181	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15874	1181	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15875	1181	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15876	1181	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15877	1181	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15878	1181	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15879	1408	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15880	1408	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15881	1408	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15882	1408	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15883	1408	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15884	1408	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15885	1429	531	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15886	1429	995	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15887	1429	1148	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15888	1429	1218	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15889	1429	1290	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15890	1429	1459	\N	2.9030302802742964	1	0.24191919002285803	1	-1
15891	706	137	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15892	706	178	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15893	706	705	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15894	706	712	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15895	706	1158	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15896	706	1173	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15897	711	137	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15898	711	178	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15899	711	705	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15900	711	712	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15901	711	1158	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15902	711	1173	\N	2.3208211927399947	1	0.1934017660616662	1	-1
15903	730	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15904	730	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15905	784	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15906	784	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15907	1032	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15908	1032	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15909	1238	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15910	1238	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15911	1382	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15912	1382	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15913	1395	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15914	1395	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15915	1513	1383	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15916	1513	1394	\N	1.6318387300562014	1	0.13598656083801677	1	-1
15917	730	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15918	730	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15919	730	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15920	784	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15921	784	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15922	784	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15923	1032	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15924	1032	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15925	1032	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15926	1238	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15927	1238	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15928	1238	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15929	1382	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15930	1382	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15931	1382	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15932	1395	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15933	1395	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15934	1395	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15935	1513	958	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15936	1513	1231	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15937	1513	1472	\N	1.7351910996756943	1	0.14459925830630785	1	-1
15938	731	957	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15939	731	1230	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15940	731	1471	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15941	1033	957	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15942	1033	1230	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15943	1033	1471	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15944	1239	957	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15945	1239	1230	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15946	1239	1471	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15947	1514	957	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15948	1514	1230	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15949	1514	1471	\N	0.2835646280846255	1	0.023630385673718793	1	-1
15950	732	956	\N	0.6469166813566319	1	0.053909723446386	1	-1
15951	732	1229	\N	0.6469166813566319	1	0.053909723446386	1	-1
15952	732	1470	\N	0.6469166813566319	1	0.053909723446386	1	-1
15953	1034	956	\N	0.6469166813566319	1	0.053909723446386	1	-1
15954	1034	1229	\N	0.6469166813566319	1	0.053909723446386	1	-1
15955	1034	1470	\N	0.6469166813566319	1	0.053909723446386	1	-1
15956	1240	956	\N	0.6469166813566319	1	0.053909723446386	1	-1
15957	1240	1229	\N	0.6469166813566319	1	0.053909723446386	1	-1
15958	1240	1470	\N	0.6469166813566319	1	0.053909723446386	1	-1
15959	1515	956	\N	0.6469166813566319	1	0.053909723446386	1	-1
15960	1515	1229	\N	0.6469166813566319	1	0.053909723446386	1	-1
15961	1515	1470	\N	0.6469166813566319	1	0.053909723446386	1	-1
15962	733	955	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15963	733	1228	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15964	733	1469	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15965	1035	955	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15966	1035	1228	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15967	1035	1469	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15968	1241	955	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15969	1241	1228	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15970	1241	1469	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15971	1516	955	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15972	1516	1228	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15973	1516	1469	\N	0.5168610235621072	1	0.04307175196350893	1	-1
15974	734	954	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15975	734	1227	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15976	734	1468	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15977	1036	954	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15978	1036	1227	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15979	1036	1468	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15980	1242	954	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15981	1242	1227	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15982	1242	1468	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15983	1517	954	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15984	1517	1227	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15985	1517	1468	\N	0.9772789694501139	1	0.08143991412084282	1	-1
15986	735	380	\N	0.24954601105151333	1	0.020795500920959446	1	-1
15987	735	396	\N	0.24954601105151333	1	0.020795500920959446	1	-1
15988	735	953	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15989	735	1037	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15990	735	1226	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15991	735	1243	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15992	735	1467	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15993	735	1518	\N	0.4331451033914218	1	0.036095425282618485	1	-1
15994	735	379	\N	0.783614478880098	1	0.0653012065733415	1	-1
15995	735	397	\N	0.783614478880098	1	0.0653012065733415	1	-1
15996	737	381	\N	0.12	1	0.01	1	-1
15997	737	3	\N	0.939635790367119	1	0.07830298253059324	1	-1
15998	737	40	\N	0.939635790367119	1	0.07830298253059324	1	-1
15999	737	45	\N	0.939635790367119	1	0.07830298253059324	1	-1
16000	737	92	\N	0.939635790367119	1	0.07830298253059324	1	-1
16001	737	104	\N	0.939635790367119	1	0.07830298253059324	1	-1
16002	737	118	\N	0.939635790367119	1	0.07830298253059324	1	-1
16003	737	150	\N	0.939635790367119	1	0.07830298253059324	1	-1
16004	737	164	\N	0.939635790367119	1	0.07830298253059324	1	-1
16005	737	339	\N	0.939635790367119	1	0.07830298253059324	1	-1
16006	737	353	\N	0.939635790367119	1	0.07830298253059324	1	-1
16007	737	395	\N	0.939635790367119	1	0.07830298253059324	1	-1
16008	737	415	\N	0.939635790367119	1	0.07830298253059324	1	-1
16009	737	430	\N	0.939635790367119	1	0.07830298253059324	1	-1
16010	737	513	\N	0.939635790367119	1	0.07830298253059324	1	-1
16011	737	557	\N	0.939635790367119	1	0.07830298253059324	1	-1
16012	738	4	\N	0.12	1	0.01	1	-1
16013	738	39	\N	0.12	1	0.01	1	-1
16014	738	46	\N	0.12	1	0.01	1	-1
16015	738	91	\N	0.12	1	0.01	1	-1
16016	738	105	\N	0.12	1	0.01	1	-1
16017	738	117	\N	0.12	1	0.01	1	-1
16018	738	151	\N	0.12	1	0.01	1	-1
16019	738	163	\N	0.12	1	0.01	1	-1
16020	738	340	\N	0.12	1	0.01	1	-1
16021	738	352	\N	0.12	1	0.01	1	-1
16022	738	382	\N	0.12	1	0.01	1	-1
16023	738	394	\N	0.12	1	0.01	1	-1
16024	738	414	\N	0.12	1	0.01	1	-1
16025	738	431	\N	0.12	1	0.01	1	-1
16026	738	514	\N	0.12	1	0.01	1	-1
16027	738	556	\N	0.12	1	0.01	1	-1
16028	738	692	\N	0.12	1	0.01	1	-1
16029	738	725	\N	0.12	1	0.01	1	-1
16030	738	693	\N	1.6468811167107993	1	0.13724009305923326	1	-1
16031	738	724	\N	1.6468811167107993	1	0.13724009305923326	1	-1
16032	752	765	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16033	752	797	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16034	752	1099	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16035	829	765	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16036	829	797	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16037	829	1099	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16038	1074	765	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16039	1074	797	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16040	1074	1099	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16041	758	1081	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16042	758	1092	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16043	759	1081	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16044	759	1092	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16045	765	752	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16046	765	829	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16047	765	1074	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16048	797	752	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16049	797	829	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16050	797	1074	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16051	1099	752	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16052	1099	829	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16053	1099	1074	\N	0.14272323898703557	1	0.011893603248919632	1	-1
16054	767	457	\N	2.109818043896162	1	0.17581817032468017	1	-1
16055	767	750	\N	2.109818043896162	1	0.17581817032468017	1	-1
16056	767	827	\N	2.109818043896162	1	0.17581817032468017	1	-1
16057	767	1072	\N	2.109818043896162	1	0.17581817032468017	1	-1
16058	767	1257	\N	2.109818043896162	1	0.17581817032468017	1	-1
16059	767	1305	\N	2.109818043896162	1	0.17581817032468017	1	-1
16060	767	1358	\N	2.109818043896162	1	0.17581817032468017	1	-1
16061	799	457	\N	2.109818043896162	1	0.17581817032468017	1	-1
16062	799	750	\N	2.109818043896162	1	0.17581817032468017	1	-1
16063	799	827	\N	2.109818043896162	1	0.17581817032468017	1	-1
16064	799	1072	\N	2.109818043896162	1	0.17581817032468017	1	-1
16065	799	1257	\N	2.109818043896162	1	0.17581817032468017	1	-1
16066	799	1305	\N	2.109818043896162	1	0.17581817032468017	1	-1
16067	799	1358	\N	2.109818043896162	1	0.17581817032468017	1	-1
16068	1101	457	\N	2.109818043896162	1	0.17581817032468017	1	-1
16069	1101	750	\N	2.109818043896162	1	0.17581817032468017	1	-1
16070	1101	827	\N	2.109818043896162	1	0.17581817032468017	1	-1
16071	1101	1072	\N	2.109818043896162	1	0.17581817032468017	1	-1
16072	1101	1257	\N	2.109818043896162	1	0.17581817032468017	1	-1
16073	1101	1305	\N	2.109818043896162	1	0.17581817032468017	1	-1
16074	1101	1358	\N	2.109818043896162	1	0.17581817032468017	1	-1
16075	767	490	\N	2.393288095107981	1	0.19944067459233175	1	-1
16076	767	1212	\N	2.393288095107981	1	0.19944067459233175	1	-1
16077	767	1284	\N	2.393288095107981	1	0.19944067459233175	1	-1
16078	767	1332	\N	2.393288095107981	1	0.19944067459233175	1	-1
16079	799	490	\N	2.393288095107981	1	0.19944067459233175	1	-1
16080	799	1212	\N	2.393288095107981	1	0.19944067459233175	1	-1
16081	799	1284	\N	2.393288095107981	1	0.19944067459233175	1	-1
16082	799	1332	\N	2.393288095107981	1	0.19944067459233175	1	-1
16083	1101	490	\N	2.393288095107981	1	0.19944067459233175	1	-1
16084	1101	1212	\N	2.393288095107981	1	0.19944067459233175	1	-1
16085	1101	1284	\N	2.393288095107981	1	0.19944067459233175	1	-1
16086	1101	1332	\N	2.393288095107981	1	0.19944067459233175	1	-1
16087	785	786	\N	2.805018132961559	1	0.2337515110801299	1	-1
16088	785	840	\N	2.805018132961559	1	0.2337515110801299	1	-1
16089	786	785	\N	2.805018132961559	1	0.2337515110801299	1	-1
16090	840	785	\N	2.805018132961559	1	0.2337515110801299	1	-1
16091	791	792	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16092	791	834	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16093	835	792	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16094	835	834	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16095	792	793	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16096	792	833	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16097	834	793	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16098	834	833	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16099	792	791	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16100	792	835	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16101	834	791	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16102	834	835	\N	2.6941354466211895	1	0.22451128721843247	1	-1
16103	793	794	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16104	793	832	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16105	833	794	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16106	833	832	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16107	793	792	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16108	793	834	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16109	833	792	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16110	833	834	\N	2.4715024573747852	1	0.20595853811456546	1	-1
16111	793	795	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16112	793	831	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16113	833	795	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16114	833	831	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16115	794	795	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16116	794	831	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16117	832	795	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16118	832	831	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16119	794	793	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16120	794	833	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16121	832	793	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16122	832	833	\N	2.2103327946845663	1	0.1841943995570472	1	-1
16123	795	794	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16124	795	832	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16125	831	794	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16126	831	832	\N	0.9710844815451967	1	0.08092370679543305	1	-1
16127	795	793	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16128	795	833	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16129	831	793	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16130	831	833	\N	2.6577081340483666	1	0.22147567783736388	1	-1
16131	795	796	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16132	795	830	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16133	831	796	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16134	831	830	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16135	796	795	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16136	796	831	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16137	830	795	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16138	830	831	\N	2.9176969474611494	1	0.24314141228842912	1	-1
16139	811	872	\N	0.16817144653904803	1	0.014014287211587336	1	-1
16140	811	915	\N	0.16817144653904803	1	0.014014287211587336	1	-1
16141	811	582	\N	1.064051542189758	1	0.08867096184914651	1	-1
16142	811	628	\N	1.064051542189758	1	0.08867096184914651	1	-1
16143	812	562	\N	0.4968753858759558	1	0.04140628215632965	1	-1
16144	812	592	\N	0.4968753858759558	1	0.04140628215632965	1	-1
16145	812	813	\N	2.5657068234289966	1	0.2138089019524164	1	-1
16146	812	814	\N	2.5657068234289966	1	0.2138089019524164	1	-1
16147	813	562	\N	2.0716283296038416	1	0.17263569413365348	1	-1
16148	813	592	\N	2.0716283296038416	1	0.17263569413365348	1	-1
16149	814	562	\N	2.0716283296038416	1	0.17263569413365348	1	-1
16150	814	592	\N	2.0716283296038416	1	0.17263569413365348	1	-1
16151	813	33	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16152	813	85	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16153	813	111	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16154	813	157	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16155	813	345	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16156	813	346	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16157	813	387	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16158	813	388	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16159	813	408	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16160	813	437	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16161	813	561	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16162	813	591	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16163	814	33	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16164	814	85	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16165	814	111	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16166	814	157	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16167	814	345	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16168	814	346	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16169	814	387	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16170	814	388	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16171	814	408	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16172	814	437	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16173	814	561	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16174	814	591	\N	2.0837710545854815	1	0.17364758788212348	1	-1
16175	813	812	\N	2.5657068234289966	1	0.2138089019524164	1	-1
16176	814	812	\N	2.5657068234289966	1	0.2138089019524164	1	-1
16177	815	34	\N	0.12	1	0.01	1	-1
16178	815	86	\N	0.12	1	0.01	1	-1
16179	815	112	\N	0.12	1	0.01	1	-1
16180	815	158	\N	0.12	1	0.01	1	-1
16181	815	207	\N	0.12	1	0.01	1	-1
16182	815	347	\N	0.12	1	0.01	1	-1
16183	815	389	\N	0.12	1	0.01	1	-1
16184	815	409	\N	0.12	1	0.01	1	-1
16185	815	586	\N	0.12	1	0.01	1	-1
16186	815	632	\N	0.12	1	0.01	1	-1
16187	815	686	\N	0.12	1	0.01	1	-1
16188	815	1132	\N	0.12	1	0.01	1	-1
16189	815	1347	\N	0.12	1	0.01	1	-1
16190	815	1374	\N	0.12	1	0.01	1	-1
16191	815	585	\N	0.6468687641905084	1	0.05390573034920904	1	-1
16192	815	631	\N	0.6468687641905084	1	0.05390573034920904	1	-1
16193	815	685	\N	0.6468687641905084	1	0.05390573034920904	1	-1
16194	816	35	\N	0.12	1	0.01	1	-1
16195	816	87	\N	0.12	1	0.01	1	-1
16196	816	113	\N	0.12	1	0.01	1	-1
16197	816	159	\N	0.12	1	0.01	1	-1
16198	816	234	\N	0.12	1	0.01	1	-1
16199	816	348	\N	0.12	1	0.01	1	-1
16200	816	390	\N	0.12	1	0.01	1	-1
16201	816	410	\N	0.12	1	0.01	1	-1
16202	816	587	\N	0.12	1	0.01	1	-1
16203	816	633	\N	0.12	1	0.01	1	-1
16204	816	1112	\N	0.12	1	0.01	1	-1
16205	816	1197	\N	0.12	1	0.01	1	-1
16206	816	1343	\N	0.12	1	0.01	1	-1
16207	816	1375	\N	0.12	1	0.01	1	-1
16208	816	8	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16209	816	50	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16210	816	109	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16211	816	110	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16212	816	155	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16213	816	156	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16214	816	205	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16215	816	344	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16216	816	386	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16217	816	436	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16218	816	559	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16219	816	588	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16220	816	589	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16221	816	634	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16222	816	683	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16223	816	729	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16224	816	1130	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16225	816	1198	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16226	816	1344	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16227	816	1345	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16228	816	1372	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16229	816	1402	\N	2.0589946606265945	1	0.17158288838554955	1	-1
16230	841	636	\N	0.12	1	0.01	1	-1
16231	841	681	\N	0.12	1	0.01	1	-1
16232	946	636	\N	0.12	1	0.01	1	-1
16233	946	681	\N	0.12	1	0.01	1	-1
16234	841	842	\N	2.465181696600145	1	0.2054318080500121	1	-1
16235	841	945	\N	2.465181696600145	1	0.2054318080500121	1	-1
16236	946	842	\N	2.465181696600145	1	0.2054318080500121	1	-1
16237	946	945	\N	2.465181696600145	1	0.2054318080500121	1	-1
16238	842	637	\N	1.0534099211497847	1	0.0877841600958154	1	-1
16239	842	680	\N	1.0534099211497847	1	0.0877841600958154	1	-1
16240	945	637	\N	1.0534099211497847	1	0.0877841600958154	1	-1
16241	945	680	\N	1.0534099211497847	1	0.0877841600958154	1	-1
16242	842	843	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16243	842	944	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16244	945	843	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16245	945	944	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16246	842	636	\N	2.4347223449054227	1	0.20289352874211855	1	-1
16247	842	681	\N	2.4347223449054227	1	0.20289352874211855	1	-1
16248	945	636	\N	2.4347223449054227	1	0.20289352874211855	1	-1
16249	945	681	\N	2.4347223449054227	1	0.20289352874211855	1	-1
16250	843	637	\N	1.0645500057137314	1	0.08871250047614429	1	-1
16251	843	680	\N	1.0645500057137314	1	0.08871250047614429	1	-1
16252	944	637	\N	1.0645500057137314	1	0.08871250047614429	1	-1
16253	944	680	\N	1.0645500057137314	1	0.08871250047614429	1	-1
16254	843	844	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16255	843	943	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16256	944	844	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16257	944	943	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16258	843	842	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16259	843	945	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16260	944	842	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16261	944	945	\N	1.6349923772784303	1	0.1362493647732025	1	-1
16262	844	843	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16263	844	944	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16264	943	843	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16265	943	944	\N	1.3788953802666934	1	0.1149079483555578	1	-1
16266	844	637	\N	2.397621843093984	1	0.19980182025783202	1	-1
16267	844	680	\N	2.397621843093984	1	0.19980182025783202	1	-1
16268	943	637	\N	2.397621843093984	1	0.19980182025783202	1	-1
16269	943	680	\N	2.397621843093984	1	0.19980182025783202	1	-1
16270	844	842	\N	2.591620626747719	1	0.2159683855623099	1	-1
16271	844	945	\N	2.591620626747719	1	0.2159683855623099	1	-1
16272	943	842	\N	2.591620626747719	1	0.2159683855623099	1	-1
16273	943	945	\N	2.591620626747719	1	0.2159683855623099	1	-1
16274	845	638	\N	0.12	1	0.01	1	-1
16275	845	679	\N	0.12	1	0.01	1	-1
16276	942	638	\N	0.12	1	0.01	1	-1
16277	942	679	\N	0.12	1	0.01	1	-1
16278	845	846	\N	2.657151103505277	1	0.22142925862543975	1	-1
16279	845	941	\N	2.657151103505277	1	0.22142925862543975	1	-1
16280	942	846	\N	2.657151103505277	1	0.22142925862543975	1	-1
16281	942	941	\N	2.657151103505277	1	0.22142925862543975	1	-1
16282	845	844	\N	2.938965117452671	1	0.2449137597877226	1	-1
16283	845	943	\N	2.938965117452671	1	0.2449137597877226	1	-1
16284	942	844	\N	2.938965117452671	1	0.2449137597877226	1	-1
16285	942	943	\N	2.938965117452671	1	0.2449137597877226	1	-1
16286	846	639	\N	2.4068894353227837	1	0.20057411961023194	1	-1
16287	846	678	\N	2.4068894353227837	1	0.20057411961023194	1	-1
16288	941	639	\N	2.4068894353227837	1	0.20057411961023194	1	-1
16289	941	678	\N	2.4068894353227837	1	0.20057411961023194	1	-1
16290	846	847	\N	2.470915451224608	1	0.205909620935384	1	-1
16291	846	940	\N	2.470915451224608	1	0.205909620935384	1	-1
16292	941	847	\N	2.470915451224608	1	0.205909620935384	1	-1
16293	941	940	\N	2.470915451224608	1	0.205909620935384	1	-1
16294	846	845	\N	2.657151103505277	1	0.22142925862543975	1	-1
16295	846	942	\N	2.657151103505277	1	0.22142925862543975	1	-1
16296	941	845	\N	2.657151103505277	1	0.22142925862543975	1	-1
16297	941	942	\N	2.657151103505277	1	0.22142925862543975	1	-1
16298	847	639	\N	0.12	1	0.01	1	-1
16299	847	678	\N	0.12	1	0.01	1	-1
16300	940	639	\N	0.12	1	0.01	1	-1
16301	940	678	\N	0.12	1	0.01	1	-1
16302	847	848	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16303	847	939	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16304	940	848	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16305	940	939	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16306	847	846	\N	2.470915451224608	1	0.205909620935384	1	-1
16307	847	941	\N	2.470915451224608	1	0.205909620935384	1	-1
16308	940	846	\N	2.470915451224608	1	0.205909620935384	1	-1
16309	940	941	\N	2.470915451224608	1	0.205909620935384	1	-1
16310	848	847	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16311	848	940	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16312	939	847	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16313	939	940	\N	1.8038270448142326	1	0.15031892040118605	1	-1
16314	848	639	\N	1.8610916783073825	1	0.15509097319228188	1	-1
16315	848	678	\N	1.8610916783073825	1	0.15509097319228188	1	-1
16316	939	639	\N	1.8610916783073825	1	0.15509097319228188	1	-1
16317	939	678	\N	1.8610916783073825	1	0.15509097319228188	1	-1
16318	848	849	\N	2.097632212081769	1	0.1748026843401474	1	-1
16319	848	938	\N	2.097632212081769	1	0.1748026843401474	1	-1
16320	939	849	\N	2.097632212081769	1	0.1748026843401474	1	-1
16321	939	938	\N	2.097632212081769	1	0.1748026843401474	1	-1
16322	849	848	\N	2.097632212081769	1	0.1748026843401474	1	-1
16323	849	939	\N	2.097632212081769	1	0.1748026843401474	1	-1
16324	938	848	\N	2.097632212081769	1	0.1748026843401474	1	-1
16325	938	939	\N	2.097632212081769	1	0.1748026843401474	1	-1
16326	850	611	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16327	850	614	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16328	850	851	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16329	850	936	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16330	937	611	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16331	937	614	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16332	937	851	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16333	937	936	\N	1.3676932950223817	1	0.11397444125186514	1	-1
16334	856	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16335	856	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16336	931	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16337	931	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16338	978	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16339	978	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16340	1012	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16341	1012	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16342	1492	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16343	1492	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16344	1493	643	\N	0.705419758402779	1	0.058784979866898256	1	-1
16345	1493	674	\N	0.705419758402779	1	0.058784979866898256	1	-1
16346	862	12	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16347	862	29	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16348	862	54	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16349	862	81	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16350	862	925	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16351	924	12	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16352	924	29	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16353	924	54	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16354	924	81	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16355	924	925	\N	2.4170013214456487	1	0.20141677678713737	1	-1
16356	868	869	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16357	868	917	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16358	918	869	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16359	918	917	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16360	869	868	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16361	869	918	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16362	917	868	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16363	917	918	\N	1.2906760237322863	1	0.10755633531102385	1	-1
16364	869	870	\N	2.018426928040997	1	0.16820224400341643	1	-1
16365	917	870	\N	2.018426928040997	1	0.16820224400341643	1	-1
16366	870	869	\N	2.018426928040997	1	0.16820224400341643	1	-1
16367	870	917	\N	2.018426928040997	1	0.16820224400341643	1	-1
16368	871	564	\N	1.052982976863081	1	0.08774858140525675	1	-1
16369	871	594	\N	1.052982976863081	1	0.08774858140525675	1	-1
16370	916	564	\N	1.052982976863081	1	0.08774858140525675	1	-1
16371	916	594	\N	1.052982976863081	1	0.08774858140525675	1	-1
16372	872	811	\N	0.16817144653904803	1	0.014014287211587336	1	-1
16373	915	811	\N	0.16817144653904803	1	0.014014287211587336	1	-1
16374	872	582	\N	0.9688796090024575	1	0.08073996741687146	1	-1
16375	872	628	\N	0.9688796090024575	1	0.08073996741687146	1	-1
16376	915	582	\N	0.9688796090024575	1	0.08073996741687146	1	-1
16377	915	628	\N	0.9688796090024575	1	0.08073996741687146	1	-1
16378	873	583	\N	0.22895093530658406	1	0.019079244608882006	1	-1
16379	873	629	\N	0.22895093530658406	1	0.019079244608882006	1	-1
16380	914	583	\N	0.22895093530658406	1	0.019079244608882006	1	-1
16381	914	629	\N	0.22895093530658406	1	0.019079244608882006	1	-1
16382	879	653	\N	0.3871386831010355	1	0.03226155692508629	1	-1
16383	879	664	\N	0.3871386831010355	1	0.03226155692508629	1	-1
16384	879	909	\N	0.3871386831010355	1	0.03226155692508629	1	-1
16385	879	213	\N	2.435411722066057	1	0.2029509768388381	1	-1
16386	879	452	\N	2.435411722066057	1	0.2029509768388381	1	-1
16387	879	521	\N	2.435411722066057	1	0.2029509768388381	1	-1
16388	879	745	\N	2.435411722066057	1	0.2029509768388381	1	-1
16389	879	822	\N	2.435411722066057	1	0.2029509768388381	1	-1
16390	879	1067	\N	2.435411722066057	1	0.2029509768388381	1	-1
16391	879	1138	\N	2.435411722066057	1	0.2029509768388381	1	-1
16392	879	1353	\N	2.435411722066057	1	0.2029509768388381	1	-1
16393	879	228	\N	2.608475166655651	1	0.21737293055463755	1	-1
16394	879	495	\N	2.608475166655651	1	0.21737293055463755	1	-1
16395	879	548	\N	2.608475166655651	1	0.21737293055463755	1	-1
16396	879	772	\N	2.608475166655651	1	0.21737293055463755	1	-1
16397	879	804	\N	2.608475166655651	1	0.21737293055463755	1	-1
16398	879	1106	\N	2.608475166655651	1	0.21737293055463755	1	-1
16399	879	1191	\N	2.608475166655651	1	0.21737293055463755	1	-1
16400	879	1337	\N	2.608475166655651	1	0.21737293055463755	1	-1
16401	887	528	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16402	887	542	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16403	887	886	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16404	887	903	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16405	887	992	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16406	887	999	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16407	887	1145	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16408	887	1185	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16409	887	1215	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16410	887	1254	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16411	887	1287	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16412	887	1302	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16413	887	1456	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16414	887	1529	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16415	902	528	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16416	902	542	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16417	902	886	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16418	902	903	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16419	902	992	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16420	902	999	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16421	902	1145	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16422	902	1185	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16423	902	1215	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16424	902	1254	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16425	902	1287	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16426	902	1302	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16427	902	1456	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16428	902	1529	\N	0.7547606126777787	1	0.06289671772314823	1	-1
16429	889	890	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16430	889	899	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16431	900	890	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16432	900	899	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16433	890	889	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16434	890	900	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16435	899	889	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16436	899	900	\N	1.4994941111085405	1	0.12495784259237837	1	-1
16437	892	893	\N	2.761923751935463	1	0.23016031266128859	1	-1
16438	892	896	\N	2.761923751935463	1	0.23016031266128859	1	-1
16439	897	893	\N	2.761923751935463	1	0.23016031266128859	1	-1
16440	897	896	\N	2.761923751935463	1	0.23016031266128859	1	-1
16441	893	892	\N	2.761923751935463	1	0.23016031266128859	1	-1
16442	893	897	\N	2.761923751935463	1	0.23016031266128859	1	-1
16443	896	892	\N	2.761923751935463	1	0.23016031266128859	1	-1
16444	896	897	\N	2.761923751935463	1	0.23016031266128859	1	-1
16445	949	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16446	949	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16447	1041	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16448	1041	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16449	1222	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16450	1222	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16451	1247	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16452	1247	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16453	1463	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16454	1463	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16455	1522	335	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16456	1522	357	\N	0.1832534930561059	1	0.015271124421342158	1	-1
16457	949	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16458	949	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16459	949	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16460	949	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16461	949	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16462	949	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16463	1041	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16464	1041	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16465	1041	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16466	1041	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16467	1041	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16468	1041	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16469	1222	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16470	1222	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16471	1222	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16472	1222	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16473	1222	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16474	1222	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16475	1247	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16476	1247	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16477	1247	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16478	1247	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16479	1247	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16480	1247	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16481	1463	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16482	1463	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16483	1463	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16484	1463	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16485	1463	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16486	1463	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16487	1522	950	\N	2.583505987406281	1	0.21529216561719008	1	-1
16488	1522	1040	\N	2.583505987406281	1	0.21529216561719008	1	-1
16489	1522	1223	\N	2.583505987406281	1	0.21529216561719008	1	-1
16490	1522	1246	\N	2.583505987406281	1	0.21529216561719008	1	-1
16491	1522	1464	\N	2.583505987406281	1	0.21529216561719008	1	-1
16492	1522	1521	\N	2.583505987406281	1	0.21529216561719008	1	-1
16493	949	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16494	949	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16495	949	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16496	949	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16497	949	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16498	949	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16499	949	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16500	949	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16501	949	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16502	949	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16503	949	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16504	949	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16505	1041	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16506	1041	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16507	1041	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16508	1041	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16509	1041	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16510	1041	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16511	1041	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16512	1041	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16513	1041	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16514	1041	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16515	1041	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16516	1041	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16517	1222	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16518	1222	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16519	1222	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16520	1222	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16521	1222	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16522	1222	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16523	1222	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16524	1222	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16525	1222	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16526	1222	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16527	1222	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16528	1222	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16529	1247	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16530	1247	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16531	1247	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16532	1247	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16533	1247	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16534	1247	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16535	1247	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16536	1247	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16537	1247	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16538	1247	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16539	1247	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16540	1247	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16541	1463	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16542	1463	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16543	1463	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16544	1463	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16545	1463	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16546	1463	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16547	1463	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16548	1463	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16549	1463	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16550	1463	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16551	1463	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16552	1463	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16553	1522	534	\N	2.909127120018101	1	0.24242726000150844	1	-1
16554	1522	536	\N	2.909127120018101	1	0.24242726000150844	1	-1
16555	1522	948	\N	2.909127120018101	1	0.24242726000150844	1	-1
16556	1522	1042	\N	2.909127120018101	1	0.24242726000150844	1	-1
16557	1522	1221	\N	2.909127120018101	1	0.24242726000150844	1	-1
16558	1522	1248	\N	2.909127120018101	1	0.24242726000150844	1	-1
16559	1522	1293	\N	2.909127120018101	1	0.24242726000150844	1	-1
16560	1522	1296	\N	2.909127120018101	1	0.24242726000150844	1	-1
16561	1522	1404	\N	2.909127120018101	1	0.24242726000150844	1	-1
16562	1522	1433	\N	2.909127120018101	1	0.24242726000150844	1	-1
16563	1522	1462	\N	2.909127120018101	1	0.24242726000150844	1	-1
16564	1522	1523	\N	2.909127120018101	1	0.24242726000150844	1	-1
16565	950	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16566	950	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16567	950	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16568	950	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16569	950	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16570	950	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16571	1040	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16572	1040	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16573	1040	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16574	1040	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16575	1040	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16576	1040	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16577	1223	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16578	1223	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16579	1223	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16580	1223	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16581	1223	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16582	1223	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16583	1246	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16584	1246	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16585	1246	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16586	1246	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16587	1246	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16588	1246	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16589	1464	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16590	1464	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16591	1464	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16592	1464	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16593	1464	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16594	1464	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16595	1521	949	\N	2.583505987406281	1	0.21529216561719008	1	-1
16596	1521	1041	\N	2.583505987406281	1	0.21529216561719008	1	-1
16597	1521	1222	\N	2.583505987406281	1	0.21529216561719008	1	-1
16598	1521	1247	\N	2.583505987406281	1	0.21529216561719008	1	-1
16599	1521	1463	\N	2.583505987406281	1	0.21529216561719008	1	-1
16600	1521	1522	\N	2.583505987406281	1	0.21529216561719008	1	-1
16601	950	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16602	950	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16603	1040	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16604	1040	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16605	1223	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16606	1223	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16607	1246	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16608	1246	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16609	1464	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16610	1464	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16611	1521	335	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16612	1521	357	\N	2.6581054957218386	1	0.22150879131015322	1	-1
16613	951	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16614	951	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16615	1039	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16616	1039	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16617	1224	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16618	1224	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16619	1245	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16620	1245	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16621	1465	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16622	1465	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16623	1520	420	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16624	1520	425	\N	0.19096520758244345	1	0.015913767298536954	1	-1
16625	951	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16626	951	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16627	1039	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16628	1039	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16629	1224	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16630	1224	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16631	1245	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16632	1245	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16633	1465	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16634	1465	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16635	1520	419	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16636	1520	426	\N	2.1333679093965086	1	0.1777806591163757	1	-1
16637	951	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16638	951	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16639	1039	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16640	1039	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16641	1224	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16642	1224	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16643	1245	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16644	1245	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16645	1465	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16646	1465	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16647	1520	418	\N	2.714637761108268	1	0.226219813425689	1	-1
16648	1520	427	\N	2.714637761108268	1	0.226219813425689	1	-1
16649	953	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16650	953	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16651	1037	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16652	1037	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16653	1226	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16654	1226	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16655	1243	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16656	1243	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16657	1467	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16658	1467	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16659	1518	380	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16660	1518	396	\N	0.32799737891947756	1	0.027333114909956463	1	-1
16661	953	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16662	1037	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16663	1226	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16664	1243	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16665	1467	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16666	1518	735	\N	0.4331451033914218	1	0.036095425282618485	1	-1
16667	953	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16668	953	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16669	1037	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16670	1037	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16671	1226	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16672	1226	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16673	1243	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16674	1243	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16675	1467	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16676	1467	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16677	1518	379	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16678	1518	397	\N	0.8770556505486787	1	0.07308797087905657	1	-1
16679	954	734	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16680	954	1036	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16681	954	1242	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16682	954	1517	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16683	1227	734	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16684	1227	1036	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16685	1227	1242	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16686	1227	1517	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16687	1468	734	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16688	1468	1036	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16689	1468	1242	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16690	1468	1517	\N	0.9772789694501139	1	0.08143991412084282	1	-1
16691	955	733	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16692	955	1035	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16693	955	1241	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16694	955	1516	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16695	1228	733	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16696	1228	1035	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16697	1228	1241	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16698	1228	1516	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16699	1469	733	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16700	1469	1035	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16701	1469	1241	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16702	1469	1516	\N	0.5168610235621072	1	0.04307175196350893	1	-1
16703	956	732	\N	0.6469166813566319	1	0.053909723446386	1	-1
16704	956	1034	\N	0.6469166813566319	1	0.053909723446386	1	-1
16705	956	1240	\N	0.6469166813566319	1	0.053909723446386	1	-1
16706	956	1515	\N	0.6469166813566319	1	0.053909723446386	1	-1
16707	1229	732	\N	0.6469166813566319	1	0.053909723446386	1	-1
16708	1229	1034	\N	0.6469166813566319	1	0.053909723446386	1	-1
16709	1229	1240	\N	0.6469166813566319	1	0.053909723446386	1	-1
16710	1229	1515	\N	0.6469166813566319	1	0.053909723446386	1	-1
16711	1470	732	\N	0.6469166813566319	1	0.053909723446386	1	-1
16712	1470	1034	\N	0.6469166813566319	1	0.053909723446386	1	-1
16713	1470	1240	\N	0.6469166813566319	1	0.053909723446386	1	-1
16714	1470	1515	\N	0.6469166813566319	1	0.053909723446386	1	-1
16715	957	731	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16716	957	1033	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16717	957	1239	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16718	957	1514	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16719	1230	731	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16720	1230	1033	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16721	1230	1239	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16722	1230	1514	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16723	1471	731	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16724	1471	1033	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16725	1471	1239	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16726	1471	1514	\N	0.2835646280846255	1	0.023630385673718793	1	-1
16727	958	1383	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16728	958	1394	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16729	1231	1383	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16730	1231	1394	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16731	1472	1383	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16732	1472	1394	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16733	958	730	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16734	958	784	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16735	958	1032	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16736	958	1238	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16737	958	1382	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16738	958	1395	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16739	958	1513	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16740	1231	730	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16741	1231	784	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16742	1231	1032	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16743	1231	1238	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16744	1231	1382	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16745	1231	1395	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16746	1231	1513	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16747	1472	730	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16748	1472	784	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16749	1472	1032	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16750	1472	1238	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16751	1472	1382	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16752	1472	1395	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16753	1472	1513	\N	1.7351910996756943	1	0.14459925830630785	1	-1
16754	979	607	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16755	979	644	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16756	979	673	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16757	979	1011	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16758	979	1541	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16759	1443	607	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16760	1443	644	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16761	1443	673	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16762	1443	1011	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16763	1443	1541	\N	0.18504892771830686	1	0.015420743976525571	1	-1
16764	979	618	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16765	979	855	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16766	979	932	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16767	1443	618	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16768	1443	855	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16769	1443	932	\N	0.6039780913667877	1	0.05033150761389898	1	-1
16770	979	608	\N	2.627523179900483	1	0.21896026499170693	1	-1
16771	979	617	\N	2.627523179900483	1	0.21896026499170693	1	-1
16772	979	854	\N	2.627523179900483	1	0.21896026499170693	1	-1
16773	979	933	\N	2.627523179900483	1	0.21896026499170693	1	-1
16774	979	1542	\N	2.627523179900483	1	0.21896026499170693	1	-1
16775	1443	608	\N	2.627523179900483	1	0.21896026499170693	1	-1
16776	1443	617	\N	2.627523179900483	1	0.21896026499170693	1	-1
16777	1443	854	\N	2.627523179900483	1	0.21896026499170693	1	-1
16778	1443	933	\N	2.627523179900483	1	0.21896026499170693	1	-1
16779	1443	1542	\N	2.627523179900483	1	0.21896026499170693	1	-1
16780	982	604	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16781	982	621	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16782	982	647	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16783	982	670	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16784	1008	604	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16785	1008	621	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16786	1008	647	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16787	1008	670	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16788	1446	604	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16789	1446	621	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16790	1446	647	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16791	1446	670	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16792	1538	604	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16793	1538	621	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16794	1538	647	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16795	1538	670	\N	0.3695314974451671	1	0.030794291453763927	1	-1
16796	983	984	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16797	983	1006	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16798	983	1448	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16799	983	1536	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16800	1007	984	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16801	1007	1006	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16802	1007	1448	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16803	1007	1536	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16804	1447	984	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16805	1447	1006	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16806	1447	1448	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16807	1447	1536	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16808	1537	984	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16809	1537	1006	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16810	1537	1448	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16811	1537	1536	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16812	984	983	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16813	984	1007	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16814	984	1447	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16815	984	1537	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16816	1006	983	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16817	1006	1007	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16818	1006	1447	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16819	1006	1537	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16820	1448	983	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16821	1448	1007	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16822	1448	1447	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16823	1448	1537	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16824	1536	983	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16825	1536	1007	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16826	1536	1447	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16827	1536	1537	\N	2.5129230421757347	1	0.20941025351464457	1	-1
16828	985	220	\N	0.12	1	0.01	1	-1
16829	985	221	\N	0.12	1	0.01	1	-1
16830	985	1005	\N	0.12	1	0.01	1	-1
16831	985	1535	\N	0.12	1	0.01	1	-1
16832	1449	220	\N	0.12	1	0.01	1	-1
16833	1449	221	\N	0.12	1	0.01	1	-1
16834	1449	1005	\N	0.12	1	0.01	1	-1
16835	1449	1535	\N	0.12	1	0.01	1	-1
16836	988	217	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16837	988	224	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16838	988	1002	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16839	988	1532	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16840	1452	217	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16841	1452	224	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16842	1452	1002	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16843	1452	1532	\N	1.0183322546698503	1	0.08486102122248754	1	-1
16844	1081	758	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16845	1081	759	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16846	1092	758	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16847	1092	759	\N	0.28073021434192763	1	0.023394184528493973	1	-1
16848	1159	135	\N	0.12	1	0.01	1	-1
16849	1159	180	\N	0.12	1	0.01	1	-1
16850	1172	135	\N	0.12	1	0.01	1	-1
16851	1172	180	\N	0.12	1	0.01	1	-1
16852	1161	1162	\N	2.824459383887881	1	0.23537161532399006	1	-1
16853	1161	1169	\N	2.824459383887881	1	0.23537161532399006	1	-1
16854	1170	1162	\N	2.824459383887881	1	0.23537161532399006	1	-1
16855	1170	1169	\N	2.824459383887881	1	0.23537161532399006	1	-1
16856	1162	1161	\N	2.824459383887881	1	0.23537161532399006	1	-1
16857	1162	1170	\N	2.824459383887881	1	0.23537161532399006	1	-1
16858	1169	1161	\N	2.824459383887881	1	0.23537161532399006	1	-1
16859	1169	1170	\N	2.824459383887881	1	0.23537161532399006	1	-1
16860	1383	958	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16861	1383	1231	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16862	1383	1472	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16863	1394	958	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16864	1394	1231	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16865	1394	1472	\N	0.5645070297922484	1	0.04704225248268737	1	-1
16866	1383	730	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16867	1383	784	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16868	1383	1032	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16869	1383	1238	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16870	1383	1382	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16871	1383	1395	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16872	1383	1513	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16873	1394	730	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16874	1394	784	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16875	1394	1032	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16876	1394	1238	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16877	1394	1382	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16878	1394	1395	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16879	1394	1513	\N	1.6318387300562014	1	0.13598656083801677	1	-1
16880	1383	1384	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16881	1383	1393	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16882	1394	1384	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16883	1394	1393	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16884	1384	1383	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16885	1384	1394	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16886	1393	1383	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16887	1393	1394	\N	2.7021717566883177	1	0.22518097972402648	1	-1
16888	1413	1414	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16889	1413	1423	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16890	1424	1414	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16891	1424	1423	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16892	1414	1413	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16893	1414	1424	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16894	1423	1413	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16895	1423	1424	\N	1.2512137587610213	1	0.1042678132300851	1	-1
16896	1414	1415	\N	2.988429137022908	1	0.24903576141857567	1	-1
16897	1414	1422	\N	2.988429137022908	1	0.24903576141857567	1	-1
16898	1423	1415	\N	2.988429137022908	1	0.24903576141857567	1	-1
16899	1423	1422	\N	2.988429137022908	1	0.24903576141857567	1	-1
16900	1415	1414	\N	2.988429137022908	1	0.24903576141857567	1	-1
16901	1415	1423	\N	2.988429137022908	1	0.24903576141857567	1	-1
16902	1422	1414	\N	2.988429137022908	1	0.24903576141857567	1	-1
16903	1422	1423	\N	2.988429137022908	1	0.24903576141857567	1	-1
16904	1417	1418	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16905	1417	1419	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16906	1420	1418	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16907	1420	1419	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16908	1418	1417	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16909	1418	1420	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16910	1419	1417	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16911	1419	1420	\N	1.2242560899484451	1	0.1020213408290371	1	-1
16912	1442	609	\N	0.8280488402862659	1	0.06900407002385549	1	-1
16913	1442	616	\N	0.8280488402862659	1	0.06900407002385549	1	-1
16914	1442	853	\N	0.8280488402862659	1	0.06900407002385549	1	-1
16915	1442	934	\N	0.8280488402862659	1	0.06900407002385549	1	-1
16916	1442	1543	\N	0.8280488402862659	1	0.06900407002385549	1	-1
\.


--
-- Data for Name: routing_nodes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routing_nodes (id, stop_id, route_id, lat, lon) FROM stdin;
1	S1	Sajha_R1_Lagankhel_Gongabu	27.66699	85.32298
2	S2	Sajha_R1_Lagankhel_Gongabu	27.67055	85.32046
3	S3	Sajha_R1_Lagankhel_Gongabu	27.67253	85.31402
4	S4	Sajha_R1_Lagankhel_Gongabu	27.67617	85.31576
5	S5	Sajha_R1_Lagankhel_Gongabu	27.68077	85.31733
6	S6	Sajha_R1_Lagankhel_Gongabu	27.68795	85.31618
7	S7	Sajha_R1_Lagankhel_Gongabu	27.69328	85.3144
8	S8	Sajha_R1_Lagankhel_Gongabu	27.70114	85.31345
9	S9	Sajha_R1_Lagankhel_Gongabu	27.71723	85.31616
10	S10	Sajha_R1_Lagankhel_Gongabu	27.72174	85.32027
11	S11	Sajha_R1_Lagankhel_Gongabu	27.72864	85.32493
12	S12	Sajha_R1_Lagankhel_Gongabu	27.7331	85.32892
13	S13	Sajha_R1_Lagankhel_Gongabu	27.73504	85.33136
14	S14	Sajha_R1_Lagankhel_Gongabu	27.73851	85.33567
15	S15	Sajha_R1_Lagankhel_Gongabu	27.73984	85.33726
16	S16	Sajha_R1_Lagankhel_Gongabu	27.74149	85.33408
17	S17	Sajha_R1_Lagankhel_Gongabu	27.7381	85.32542
18	S18	Sajha_R1_Lagankhel_Gongabu	27.73561	85.32119
19	S19	Sajha_R1_Lagankhel_Gongabu	27.73488	85.31463
20	S20	Sajha_R1_Lagankhel_Gongabu	27.7348	85.3097
21	S20	Sajha_R1_Gongabu_Lagankhel	27.7348	85.3097
22	S19	Sajha_R1_Gongabu_Lagankhel	27.73488	85.31463
23	S18	Sajha_R1_Gongabu_Lagankhel	27.73561	85.32119
24	S17	Sajha_R1_Gongabu_Lagankhel	27.7381	85.32542
25	S16	Sajha_R1_Gongabu_Lagankhel	27.74149	85.33408
26	S15	Sajha_R1_Gongabu_Lagankhel	27.73984	85.33726
27	S14	Sajha_R1_Gongabu_Lagankhel	27.73851	85.33567
28	S13	Sajha_R1_Gongabu_Lagankhel	27.73504	85.33136
29	S12	Sajha_R1_Gongabu_Lagankhel	27.7331	85.32892
30	S11	Sajha_R1_Gongabu_Lagankhel	27.72864	85.32493
31	S10	Sajha_R1_Gongabu_Lagankhel	27.72174	85.32027
32	S9	Sajha_R1_Gongabu_Lagankhel	27.71723	85.31616
33	S21	Sajha_R1_Gongabu_Lagankhel	27.70883	85.31539
34	S22	Sajha_R1_Gongabu_Lagankhel	27.70258	85.31647
35	S23	Sajha_R1_Gongabu_Lagankhel	27.69971	85.31398
36	S7	Sajha_R1_Gongabu_Lagankhel	27.69328	85.3144
37	S6	Sajha_R1_Gongabu_Lagankhel	27.68795	85.31618
38	S5	Sajha_R1_Gongabu_Lagankhel	27.68077	85.31733
39	S4	Sajha_R1_Gongabu_Lagankhel	27.67617	85.31576
40	S3	Sajha_R1_Gongabu_Lagankhel	27.67253	85.31402
41	S2	Sajha_R1_Gongabu_Lagankhel	27.67055	85.32046
42	S1	Sajha_R1_Gongabu_Lagankhel	27.66699	85.32298
43	S1	Sajha_R2_Lagankhel_Budhanilkantha	27.66699	85.32298
44	S2	Sajha_R2_Lagankhel_Budhanilkantha	27.67055	85.32046
45	S3	Sajha_R2_Lagankhel_Budhanilkantha	27.67253	85.31402
46	S4	Sajha_R2_Lagankhel_Budhanilkantha	27.67617	85.31576
47	S5	Sajha_R2_Lagankhel_Budhanilkantha	27.68077	85.31733
48	S6	Sajha_R2_Lagankhel_Budhanilkantha	27.68795	85.31618
49	S7	Sajha_R2_Lagankhel_Budhanilkantha	27.69328	85.3144
50	S8	Sajha_R2_Lagankhel_Budhanilkantha	27.70114	85.31345
51	S9	Sajha_R2_Lagankhel_Budhanilkantha	27.71723	85.31616
52	S10	Sajha_R2_Lagankhel_Budhanilkantha	27.72174	85.32027
53	S11	Sajha_R2_Lagankhel_Budhanilkantha	27.72864	85.32493
54	S12	Sajha_R2_Lagankhel_Budhanilkantha	27.7331	85.32892
55	S13	Sajha_R2_Lagankhel_Budhanilkantha	27.73504	85.33136
56	S14	Sajha_R2_Lagankhel_Budhanilkantha	27.73851	85.33567
57	S15	Sajha_R2_Lagankhel_Budhanilkantha	27.73984	85.33726
58	S24	Sajha_R2_Lagankhel_Budhanilkantha	27.74306	85.34003
59	S25	Sajha_R2_Lagankhel_Budhanilkantha	27.74521	85.34188
60	S26	Sajha_R2_Lagankhel_Budhanilkantha	27.74842	85.34529
61	S27	Sajha_R2_Lagankhel_Budhanilkantha	27.75142	85.346
62	S28	Sajha_R2_Lagankhel_Budhanilkantha	27.75702	85.34944
63	S29	Sajha_R2_Lagankhel_Budhanilkantha	27.76082	85.352
64	S30	Sajha_R2_Lagankhel_Budhanilkantha	27.767	85.35474
65	S31	Sajha_R2_Lagankhel_Budhanilkantha	27.77143	85.3588
66	S32	Sajha_R2_Lagankhel_Budhanilkantha	27.77484	85.36115
67	S33	Sajha_R2_Lagankhel_Budhanilkantha	27.77842	85.36012
68	S33	Sajha_R2_Budhanilkantha_Lagnakhel	27.77842	85.36012
69	S32	Sajha_R2_Budhanilkantha_Lagnakhel	27.77484	85.36115
70	S31	Sajha_R2_Budhanilkantha_Lagnakhel	27.77143	85.3588
71	S30	Sajha_R2_Budhanilkantha_Lagnakhel	27.767	85.35474
72	S29	Sajha_R2_Budhanilkantha_Lagnakhel	27.76082	85.352
73	S28	Sajha_R2_Budhanilkantha_Lagnakhel	27.75702	85.34944
74	S27	Sajha_R2_Budhanilkantha_Lagnakhel	27.75142	85.346
75	S26	Sajha_R2_Budhanilkantha_Lagnakhel	27.74842	85.34529
76	S25	Sajha_R2_Budhanilkantha_Lagnakhel	27.74521	85.34188
77	S24	Sajha_R2_Budhanilkantha_Lagnakhel	27.74306	85.34003
78	S15	Sajha_R2_Budhanilkantha_Lagnakhel	27.73984	85.33726
79	S14	Sajha_R2_Budhanilkantha_Lagnakhel	27.73851	85.33567
80	S13	Sajha_R2_Budhanilkantha_Lagnakhel	27.73504	85.33136
81	S12	Sajha_R2_Budhanilkantha_Lagnakhel	27.7331	85.32892
82	S11	Sajha_R2_Budhanilkantha_Lagnakhel	27.72864	85.32493
83	S10	Sajha_R2_Budhanilkantha_Lagnakhel	27.72174	85.32027
84	S9	Sajha_R2_Budhanilkantha_Lagnakhel	27.71723	85.31616
85	S21	Sajha_R2_Budhanilkantha_Lagnakhel	27.70883	85.31539
86	S22	Sajha_R2_Budhanilkantha_Lagnakhel	27.70258	85.31647
87	S23	Sajha_R2_Budhanilkantha_Lagnakhel	27.69971	85.31398
88	S7	Sajha_R2_Budhanilkantha_Lagnakhel	27.69328	85.3144
89	S6	Sajha_R2_Budhanilkantha_Lagnakhel	27.68795	85.31618
90	S5	Sajha_R2_Budhanilkantha_Lagnakhel	27.68077	85.31733
91	S4	Sajha_R2_Budhanilkantha_Lagnakhel	27.67617	85.31576
92	S3	Sajha_R2_Budhanilkantha_Lagnakhel	27.67253	85.31402
93	S2	Sajha_R2_Budhanilkantha_Lagnakhel	27.67055	85.32046
94	S1	Sajha_R2_Budhanilkantha_Lagnakhel	27.66699	85.32298
95	S34	Sajha_R3_Godawari_RNAC	27.59458	85.37778
96	S35	Sajha_R3_Godawari_RNAC	27.61135	85.3575
97	S36	Sajha_R3_Godawari_RNAC	27.62345	85.3495
98	S37	Sajha_R3_Godawari_RNAC	27.63736	85.34171
99	S38	Sajha_R3_Godawari_RNAC	27.64794	85.33571
100	S39	Sajha_R3_Godawari_RNAC	27.65689	85.32636
101	S40	Sajha_R3_Godawari_RNAC	27.65885	85.32462
102	S1	Sajha_R3_Godawari_RNAC	27.66699	85.32298
103	S2	Sajha_R3_Godawari_RNAC	27.67055	85.32046
104	S3	Sajha_R3_Godawari_RNAC	27.67253	85.31402
105	S4	Sajha_R3_Godawari_RNAC	27.67617	85.31576
106	S5	Sajha_R3_Godawari_RNAC	27.68077	85.31733
107	S6	Sajha_R3_Godawari_RNAC	27.68795	85.31618
108	S7	Sajha_R3_Godawari_RNAC	27.69328	85.3144
109	S8	Sajha_R3_Godawari_RNAC	27.70114	85.31345
110	S8	Sajha_R3_RNAC_Godawari	27.70114	85.31345
111	S21	Sajha_R3_RNAC_Godawari	27.70883	85.31539
112	S22	Sajha_R3_RNAC_Godawari	27.70258	85.31647
113	S23	Sajha_R3_RNAC_Godawari	27.69971	85.31398
114	S7	Sajha_R3_RNAC_Godawari	27.69328	85.3144
115	S6	Sajha_R3_RNAC_Godawari	27.68795	85.31618
116	S5	Sajha_R3_RNAC_Godawari	27.68077	85.31733
117	S4	Sajha_R3_RNAC_Godawari	27.67617	85.31576
118	S3	Sajha_R3_RNAC_Godawari	27.67253	85.31402
119	S2	Sajha_R3_RNAC_Godawari	27.67055	85.32046
120	S1	Sajha_R3_RNAC_Godawari	27.66699	85.32298
121	S40	Sajha_R3_RNAC_Godawari	27.65885	85.32462
122	S39	Sajha_R3_RNAC_Godawari	27.65689	85.32636
123	S38	Sajha_R3_RNAC_Godawari	27.64794	85.33571
124	S37	Sajha_R3_RNAC_Godawari	27.63736	85.34171
125	S36	Sajha_R3_RNAC_Godawari	27.62345	85.3495
126	S35	Sajha_R3_RNAC_Godawari	27.61135	85.3575
127	S34	Sajha_R3_RNAC_Godawari	27.59458	85.37778
128	S41	Sajha_R4_Lamatar_RNAC	27.62793	85.39526
129	S42	Sajha_R4_Lamatar_RNAC	27.6328	85.39076
130	S43	Sajha_R4_Lamatar_RNAC	27.64166	85.37916
131	S44	Sajha_R4_Lamatar_RNAC	27.64282	85.37333
132	S45	Sajha_R4_Lamatar_RNAC	27.64371	85.37223
133	S46	Sajha_R4_Lamatar_RNAC	27.64734	85.36665
134	S47	Sajha_R4_Lamatar_RNAC	27.64979	85.35901
135	S48	Sajha_R4_Lamatar_RNAC	27.65082	85.35568
136	S49	Sajha_R4_Lamatar_RNAC	27.6532	85.35244
137	S50	Sajha_R4_Lamatar_RNAC	27.65491	85.34978
138	S51	Sajha_R4_Lamatar_RNAC	27.65649	85.34863
139	S52	Sajha_R4_Lamatar_RNAC	27.65738	85.3478
140	S53	Sajha_R4_Lamatar_RNAC	27.65933	85.34435
141	S54	Sajha_R4_Lamatar_RNAC	27.66167	85.34269
142	S55	Sajha_R4_Lamatar_RNAC	27.66264	85.3405
143	S56	Sajha_R4_Lamatar_RNAC	27.66313	85.33967
144	S57	Sajha_R4_Lamatar_RNAC	27.66547	85.3352
145	S58	Sajha_R4_Lamatar_RNAC	27.66646	85.33212
146	S59	Sajha_R4_Lamatar_RNAC	27.66246	85.32892
147	S40	Sajha_R4_Lamatar_RNAC	27.65885	85.32462
148	S1	Sajha_R4_Lamatar_RNAC	27.66699	85.32298
149	S2	Sajha_R4_Lamatar_RNAC	27.67055	85.32046
150	S3	Sajha_R4_Lamatar_RNAC	27.67253	85.31402
151	S4	Sajha_R4_Lamatar_RNAC	27.67617	85.31576
152	S5	Sajha_R4_Lamatar_RNAC	27.68077	85.31733
153	S6	Sajha_R4_Lamatar_RNAC	27.68795	85.31618
154	S7	Sajha_R4_Lamatar_RNAC	27.69328	85.3144
155	S8	Sajha_R4_Lamatar_RNAC	27.70114	85.31345
156	S8	Sajha_R4_RNAC_Lamatar	27.70114	85.31345
157	S21	Sajha_R4_RNAC_Lamatar	27.70883	85.31539
158	S22	Sajha_R4_RNAC_Lamatar	27.70258	85.31647
159	S23	Sajha_R4_RNAC_Lamatar	27.69971	85.31398
160	S7	Sajha_R4_RNAC_Lamatar	27.69328	85.3144
161	S6	Sajha_R4_RNAC_Lamatar	27.68795	85.31618
162	S5	Sajha_R4_RNAC_Lamatar	27.68077	85.31733
163	S4	Sajha_R4_RNAC_Lamatar	27.67617	85.31576
164	S3	Sajha_R4_RNAC_Lamatar	27.67253	85.31402
165	S2	Sajha_R4_RNAC_Lamatar	27.67055	85.32046
166	S1	Sajha_R4_RNAC_Lamatar	27.66699	85.32298
167	S40	Sajha_R4_RNAC_Lamatar	27.65885	85.32462
168	S60	Sajha_R4_RNAC_Lamatar	27.66039	85.32689
169	S61	Sajha_R4_RNAC_Lamatar	27.66438	85.33028
170	S58	Sajha_R4_RNAC_Lamatar	27.66646	85.33212
171	S57	Sajha_R4_RNAC_Lamatar	27.66547	85.3352
172	S56	Sajha_R4_RNAC_Lamatar	27.66313	85.33967
173	S55	Sajha_R4_RNAC_Lamatar	27.66264	85.3405
174	S54	Sajha_R4_RNAC_Lamatar	27.66167	85.34269
175	S53	Sajha_R4_RNAC_Lamatar	27.65933	85.34435
176	S52	Sajha_R4_RNAC_Lamatar	27.65738	85.3478
177	S51	Sajha_R4_RNAC_Lamatar	27.65649	85.34863
178	S50	Sajha_R4_RNAC_Lamatar	27.65491	85.34978
179	S49	Sajha_R4_RNAC_Lamatar	27.6532	85.35244
180	S48	Sajha_R4_RNAC_Lamatar	27.65082	85.35568
181	S47	Sajha_R4_RNAC_Lamatar	27.64979	85.35901
182	S46	Sajha_R4_RNAC_Lamatar	27.64734	85.36665
183	S45	Sajha_R4_RNAC_Lamatar	27.64371	85.37223
184	S44	Sajha_R4_RNAC_Lamatar	27.64282	85.37333
185	S43	Sajha_R4_RNAC_Lamatar	27.64166	85.37916
186	S42	Sajha_R4_RNAC_Lamatar	27.6328	85.39076
187	S41	Sajha_R4_RNAC_Lamatar	27.62793	85.39526
188	S62	Sajha_R5_Thankot_Airport	27.69939	85.20908
189	S63	Sajha_R5_Thankot_Airport	27.69352	85.21953
190	S64	Sajha_R5_Thankot_Airport	27.69026	85.22193
191	S65	Sajha_R5_Thankot_Airport	27.68901	85.22721
192	S66	Sajha_R5_Thankot_Airport	27.68773	85.24209
193	S67	Sajha_R5_Thankot_Airport	27.68689	85.25124
194	S68	Sajha_R5_Thankot_Airport	27.6862	85.25999
195	S69	Sajha_R5_Thankot_Airport	27.6871	85.26483
196	S70	Sajha_R5_Thankot_Airport	27.68802	85.26993
197	S71	Sajha_R5_Thankot_Airport	27.69132	85.2756
198	S72	Sajha_R5_Thankot_Airport	27.69337	85.28189
199	S73	Sajha_R5_Thankot_Airport	27.6942	85.28504
200	S74	Sajha_R5_Thankot_Airport	27.69564	85.29099
201	S75	Sajha_R5_Thankot_Airport	27.69685	85.29429
202	S76	Sajha_R5_Thankot_Airport	27.69846	85.29955
203	S77	Sajha_R5_Thankot_Airport	27.69785	85.30314
204	S7	Sajha_R5_Thankot_Airport	27.69328	85.3144
205	S8	Sajha_R5_Thankot_Airport	27.70114	85.31345
206	S78	Sajha_R5_Thankot_Airport	27.70669	85.31485
207	S22	Sajha_R5_Thankot_Airport	27.70258	85.31647
208	S79	Sajha_R5_Thankot_Airport	27.698	85.32141
209	S80	Sajha_R5_Thankot_Airport	27.6965	85.32101
210	S81	Sajha_R5_Thankot_Airport	27.69365	85.32156
211	S82	Sajha_R5_Thankot_Airport	27.69227	85.32442
212	S83	Sajha_R5_Thankot_Airport	27.69066	85.32787
213	S84	Sajha_R5_Thankot_Airport	27.68845	85.33487
214	S85	Sajha_R5_Thankot_Airport	27.68763	85.33868
215	S86	Sajha_R5_Thankot_Airport	27.68672	85.34266
216	S87	Sajha_R5_Thankot_Airport	27.68608	85.34551
217	S88	Sajha_R5_Thankot_Airport	27.68636	85.34923
218	S89	Sajha_R5_Thankot_Airport	27.69131	85.35287
219	S90	Sajha_R5_Thankot_Airport	27.69523	85.35492
220	S91	Sajha_R5_Thankot_Airport	27.70059	85.35371
221	S91	Sajha_R5_Airport_Thankot	27.70059	85.35371
222	S90	Sajha_R5_Airport_Thankot	27.69523	85.35492
223	S89	Sajha_R5_Airport_Thankot	27.69131	85.35287
224	S88	Sajha_R5_Airport_Thankot	27.68636	85.34923
225	S87	Sajha_R5_Airport_Thankot	27.68608	85.34551
226	S86	Sajha_R5_Airport_Thankot	27.68672	85.34266
227	S92	Sajha_R5_Airport_Thankot	27.68748	85.338
228	S93	Sajha_R5_Airport_Thankot	27.68831	85.33485
229	S94	Sajha_R5_Airport_Thankot	27.68912	85.33098
230	S95	Sajha_R5_Airport_Thankot	27.69048	85.3276
231	S96	Sajha_R5_Airport_Thankot	27.69225	85.32413
232	S97	Sajha_R5_Airport_Thankot	27.69375	85.32081
233	S98	Sajha_R5_Airport_Thankot	27.699	85.3171
234	S23	Sajha_R5_Airport_Thankot	27.69971	85.31398
235	S7	Sajha_R5_Airport_Thankot	27.69328	85.3144
236	S99	Sajha_R5_Airport_Thankot	27.69633	85.30633
237	S100	Sajha_R5_Airport_Thankot	27.6982	85.30153
238	S75	Sajha_R5_Airport_Thankot	27.69685	85.29429
239	S74	Sajha_R5_Airport_Thankot	27.69564	85.29099
240	S73	Sajha_R5_Airport_Thankot	27.6942	85.28504
241	S72	Sajha_R5_Airport_Thankot	27.69337	85.28189
242	S71	Sajha_R5_Airport_Thankot	27.69132	85.2756
243	S70	Sajha_R5_Airport_Thankot	27.68802	85.26993
244	S69	Sajha_R5_Airport_Thankot	27.6871	85.26483
245	S68	Sajha_R5_Airport_Thankot	27.6862	85.25999
246	S67	Sajha_R5_Airport_Thankot	27.68689	85.25124
247	S66	Sajha_R5_Airport_Thankot	27.68773	85.24209
248	S65	Sajha_R5_Airport_Thankot	27.68901	85.22721
249	S64	Sajha_R5_Airport_Thankot	27.69026	85.22193
250	S63	Sajha_R5_Airport_Thankot	27.69352	85.21953
251	S62	Sajha_R5_Airport_Thankot	27.69939	85.20908
252	S101	Sajha_R6_Thankot_Budhanilkantha	27.70639	85.20567
253	S62	Sajha_R6_Thankot_Budhanilkantha	27.69939	85.20908
254	S63	Sajha_R6_Thankot_Budhanilkantha	27.69352	85.21953
255	S64	Sajha_R6_Thankot_Budhanilkantha	27.69026	85.22193
256	S65	Sajha_R6_Thankot_Budhanilkantha	27.68901	85.22721
257	S66	Sajha_R6_Thankot_Budhanilkantha	27.68773	85.24209
258	S67	Sajha_R6_Thankot_Budhanilkantha	27.68689	85.25124
259	S68	Sajha_R6_Thankot_Budhanilkantha	27.6862	85.25999
260	S69	Sajha_R6_Thankot_Budhanilkantha	27.6871	85.26483
261	S70	Sajha_R6_Thankot_Budhanilkantha	27.68802	85.26993
262	S71	Sajha_R6_Thankot_Budhanilkantha	27.69132	85.2756
263	S102	Sajha_R6_Thankot_Budhanilkantha	27.69537	85.28134
264	S103	Sajha_R6_Thankot_Budhanilkantha	27.70208	85.28179
265	S104	Sajha_R6_Thankot_Budhanilkantha	27.70758	85.28248
266	S105	Sajha_R6_Thankot_Budhanilkantha	27.716	85.28353
267	S106	Sajha_R6_Thankot_Budhanilkantha	27.71967	85.28693
268	S107	Sajha_R6_Thankot_Budhanilkantha	27.72136	85.29041
269	S108	Sajha_R6_Thankot_Budhanilkantha	27.72348	85.29453
270	S109	Sajha_R6_Thankot_Budhanilkantha	27.72476	85.2977
271	S110	Sajha_R6_Thankot_Budhanilkantha	27.7272	85.30483
272	S111	Sajha_R6_Thankot_Budhanilkantha	27.73519	85.30572
273	S19	Sajha_R6_Thankot_Budhanilkantha	27.73488	85.31463
274	S18	Sajha_R6_Thankot_Budhanilkantha	27.73561	85.32119
275	S17	Sajha_R6_Thankot_Budhanilkantha	27.7381	85.32542
276	S16	Sajha_R6_Thankot_Budhanilkantha	27.74149	85.33408
277	S15	Sajha_R6_Thankot_Budhanilkantha	27.73984	85.33726
278	S24	Sajha_R6_Thankot_Budhanilkantha	27.74306	85.34003
279	S25	Sajha_R6_Thankot_Budhanilkantha	27.74521	85.34188
280	S26	Sajha_R6_Thankot_Budhanilkantha	27.74842	85.34529
281	S27	Sajha_R6_Thankot_Budhanilkantha	27.75142	85.346
282	S28	Sajha_R6_Thankot_Budhanilkantha	27.75702	85.34944
283	S29	Sajha_R6_Thankot_Budhanilkantha	27.76082	85.352
284	S30	Sajha_R6_Thankot_Budhanilkantha	27.767	85.35474
285	S31	Sajha_R6_Thankot_Budhanilkantha	27.77143	85.3588
286	S32	Sajha_R6_Thankot_Budhanilkantha	27.77484	85.36115
287	S33	Sajha_R6_Thankot_Budhanilkantha	27.77842	85.36012
288	S33	Sajha_R6_Budhanilkantha_Thankot	27.77842	85.36012
289	S32	Sajha_R6_Budhanilkantha_Thankot	27.77484	85.36115
290	S31	Sajha_R6_Budhanilkantha_Thankot	27.77143	85.3588
291	S30	Sajha_R6_Budhanilkantha_Thankot	27.767	85.35474
292	S29	Sajha_R6_Budhanilkantha_Thankot	27.76082	85.352
293	S28	Sajha_R6_Budhanilkantha_Thankot	27.75702	85.34944
294	S27	Sajha_R6_Budhanilkantha_Thankot	27.75142	85.346
295	S26	Sajha_R6_Budhanilkantha_Thankot	27.74842	85.34529
296	S25	Sajha_R6_Budhanilkantha_Thankot	27.74521	85.34188
297	S24	Sajha_R6_Budhanilkantha_Thankot	27.74306	85.34003
298	S15	Sajha_R6_Budhanilkantha_Thankot	27.73984	85.33726
299	S16	Sajha_R6_Budhanilkantha_Thankot	27.74149	85.33408
300	S17	Sajha_R6_Budhanilkantha_Thankot	27.7381	85.32542
301	S18	Sajha_R6_Budhanilkantha_Thankot	27.73561	85.32119
302	S19	Sajha_R6_Budhanilkantha_Thankot	27.73488	85.31463
303	S111	Sajha_R6_Budhanilkantha_Thankot	27.73519	85.30572
304	S110	Sajha_R6_Budhanilkantha_Thankot	27.7272	85.30483
305	S109	Sajha_R6_Budhanilkantha_Thankot	27.72476	85.2977
306	S108	Sajha_R6_Budhanilkantha_Thankot	27.72348	85.29453
307	S107	Sajha_R6_Budhanilkantha_Thankot	27.72136	85.29041
308	S106	Sajha_R6_Budhanilkantha_Thankot	27.71967	85.28693
309	S105	Sajha_R6_Budhanilkantha_Thankot	27.716	85.28353
310	S104	Sajha_R6_Budhanilkantha_Thankot	27.70758	85.28248
311	S103	Sajha_R6_Budhanilkantha_Thankot	27.70208	85.28179
312	S102	Sajha_R6_Budhanilkantha_Thankot	27.69537	85.28134
313	S71	Sajha_R6_Budhanilkantha_Thankot	27.69132	85.2756
314	S70	Sajha_R6_Budhanilkantha_Thankot	27.68802	85.26993
315	S69	Sajha_R6_Budhanilkantha_Thankot	27.6871	85.26483
316	S68	Sajha_R6_Budhanilkantha_Thankot	27.6862	85.25999
317	S67	Sajha_R6_Budhanilkantha_Thankot	27.68689	85.25124
318	S66	Sajha_R6_Budhanilkantha_Thankot	27.68773	85.24209
319	S65	Sajha_R6_Budhanilkantha_Thankot	27.68901	85.22721
320	S64	Sajha_R6_Budhanilkantha_Thankot	27.69026	85.22193
321	S63	Sajha_R6_Budhanilkantha_Thankot	27.69352	85.21953
322	S62	Sajha_R6_Budhanilkantha_Thankot	27.69939	85.20908
323	S101	Sajha_R6_Budhanilkantha_Thankot	27.70639	85.20567
324	S112	Sajha_R7_Lele_Jamal	27.56829	85.3408
325	S113	Sajha_R7_Lele_Jamal	27.57223	85.33512
326	S114	Sajha_R7_Lele_Jamal	27.57592	85.31367
327	S115	Sajha_R7_Lele_Jamal	27.58817	85.32204
328	S116	Sajha_R7_Lele_Jamal	27.59745	85.32381
329	S117	Sajha_R7_Lele_Jamal	27.60389	85.32398
330	S118	Sajha_R7_Lele_Jamal	27.61567	85.31922
331	S119	Sajha_R7_Lele_Jamal	27.62347	85.31911
332	S120	Sajha_R7_Lele_Jamal	27.63305	85.31802
333	S121	Sajha_R7_Lele_Jamal	27.64026	85.31844
334	S122	Sajha_R7_Lele_Jamal	27.64938	85.32055
335	S123	Sajha_R7_Lele_Jamal	27.65772	85.32237
336	S40	Sajha_R7_Lele_Jamal	27.65885	85.32462
337	S1	Sajha_R7_Lele_Jamal	27.66699	85.32298
338	S2	Sajha_R7_Lele_Jamal	27.67055	85.32046
339	S3	Sajha_R7_Lele_Jamal	27.67253	85.31402
340	S4	Sajha_R7_Lele_Jamal	27.67617	85.31576
341	S5	Sajha_R7_Lele_Jamal	27.68077	85.31733
342	S6	Sajha_R7_Lele_Jamal	27.68795	85.31618
343	S7	Sajha_R7_Lele_Jamal	27.69328	85.3144
344	S8	Sajha_R7_Lele_Jamal	27.70114	85.31345
345	S21	Sajha_R7_Lele_Jamal	27.70883	85.31539
346	S21	Sajha_R7_Jamal_Lele	27.70883	85.31539
347	S22	Sajha_R7_Jamal_Lele	27.70258	85.31647
348	S23	Sajha_R7_Jamal_Lele	27.69971	85.31398
349	S7	Sajha_R7_Jamal_Lele	27.69328	85.3144
350	S6	Sajha_R7_Jamal_Lele	27.68795	85.31618
351	S5	Sajha_R7_Jamal_Lele	27.68077	85.31733
352	S4	Sajha_R7_Jamal_Lele	27.67617	85.31576
353	S3	Sajha_R7_Jamal_Lele	27.67253	85.31402
354	S2	Sajha_R7_Jamal_Lele	27.67055	85.32046
355	S1	Sajha_R7_Jamal_Lele	27.66699	85.32298
356	S40	Sajha_R7_Jamal_Lele	27.65885	85.32462
357	S123	Sajha_R7_Jamal_Lele	27.65772	85.32237
358	S122	Sajha_R7_Jamal_Lele	27.64938	85.32055
359	S121	Sajha_R7_Jamal_Lele	27.64026	85.31844
360	S120	Sajha_R7_Jamal_Lele	27.63305	85.31802
361	S119	Sajha_R7_Jamal_Lele	27.62347	85.31911
362	S118	Sajha_R7_Jamal_Lele	27.61567	85.31922
363	S117	Sajha_R7_Jamal_Lele	27.60389	85.32398
364	S116	Sajha_R7_Jamal_Lele	27.59745	85.32381
365	S115	Sajha_R7_Jamal_Lele	27.58817	85.32204
366	S114	Sajha_R7_Jamal_Lele	27.57592	85.31367
367	S113	Sajha_R7_Jamal_Lele	27.57223	85.33512
368	S112	Sajha_R7_Jamal_Lele	27.56829	85.3408
369	S124	Sajha_R8_Bungamati_Jamal	27.6285	85.304
370	S125	Sajha_R8_Bungamati_Jamal	27.63921	85.30507
371	S126	Sajha_R8_Bungamati_Jamal	27.64221	85.30466
372	S127	Sajha_R8_Bungamati_Jamal	27.64617	85.3049
373	S128	Sajha_R8_Bungamati_Jamal	27.6491	85.30528
374	S129	Sajha_R8_Bungamati_Jamal	27.6521	85.30519
375	S130	Sajha_R8_Bungamati_Jamal	27.65616	85.30593
376	S131	Sajha_R8_Bungamati_Jamal	27.65963	85.3064
377	S132	Sajha_R8_Bungamati_Jamal	27.66156	85.30581
378	S133	Sajha_R8_Bungamati_Jamal	27.66535	85.30607
379	S134	Sajha_R8_Bungamati_Jamal	27.66667	85.30757
380	S135	Sajha_R8_Bungamati_Jamal	27.66686	85.30837
381	S136	Sajha_R8_Bungamati_Jamal	27.67262	85.31323
382	S4	Sajha_R8_Bungamati_Jamal	27.67617	85.31576
383	S5	Sajha_R8_Bungamati_Jamal	27.68077	85.31733
384	S6	Sajha_R8_Bungamati_Jamal	27.68795	85.31618
385	S7	Sajha_R8_Bungamati_Jamal	27.69328	85.3144
386	S8	Sajha_R8_Bungamati_Jamal	27.70114	85.31345
387	S21	Sajha_R8_Bungamati_Jamal	27.70883	85.31539
388	S21	Sajha_R8_Jamal_Bungamati	27.70883	85.31539
389	S22	Sajha_R8_Jamal_Bungamati	27.70258	85.31647
390	S23	Sajha_R8_Jamal_Bungamati	27.69971	85.31398
391	S7	Sajha_R8_Jamal_Bungamati	27.69328	85.3144
392	S6	Sajha_R8_Jamal_Bungamati	27.68795	85.31618
393	S5	Sajha_R8_Jamal_Bungamati	27.68077	85.31733
394	S4	Sajha_R8_Jamal_Bungamati	27.67617	85.31576
395	S3	Sajha_R8_Jamal_Bungamati	27.67253	85.31402
396	S135	Sajha_R8_Jamal_Bungamati	27.66686	85.30837
397	S134	Sajha_R8_Jamal_Bungamati	27.66667	85.30757
398	S133	Sajha_R8_Jamal_Bungamati	27.66535	85.30607
399	S132	Sajha_R8_Jamal_Bungamati	27.66156	85.30581
400	S131	Sajha_R8_Jamal_Bungamati	27.65963	85.3064
401	S130	Sajha_R8_Jamal_Bungamati	27.65616	85.30593
402	S129	Sajha_R8_Jamal_Bungamati	27.6521	85.30519
403	S128	Sajha_R8_Jamal_Bungamati	27.6491	85.30528
404	S127	Sajha_R8_Jamal_Bungamati	27.64617	85.3049
405	S126	Sajha_R8_Jamal_Bungamati	27.64221	85.30466
406	S125	Sajha_R8_Jamal_Bungamati	27.63921	85.30507
407	S124	Sajha_R8_Jamal_Bungamati	27.6285	85.304
408	S21	Jharana_R1_Jamal_Ranibu	27.70883	85.31539
409	S22	Jharana_R1_Jamal_Ranibu	27.70258	85.31647
410	S23	Jharana_R1_Jamal_Ranibu	27.69971	85.31398
411	S7	Jharana_R1_Jamal_Ranibu	27.69328	85.3144
412	S6	Jharana_R1_Jamal_Ranibu	27.68795	85.31618
413	S5	Jharana_R1_Jamal_Ranibu	27.68077	85.31733
414	S4	Jharana_R1_Jamal_Ranibu	27.67617	85.31576
415	S3	Jharana_R1_Jamal_Ranibu	27.67253	85.31402
416	S2	Jharana_R1_Jamal_Ranibu	27.67055	85.32046
417	S1	Jharana_R1_Jamal_Ranibu	27.66699	85.32298
418	S137	Jharana_R1_Jamal_Ranibu	27.66164	85.31856
419	S138	Jharana_R1_Jamal_Ranibu	27.66144	85.31781
420	S139	Jharana_R1_Jamal_Ranibu	27.66252	85.31634
421	S140	Jharana_R1_Jamal_Ranibu	27.65997	85.31429
422	S141	Jharana_R1_Jamal_Ranibu	27.65828	85.31289
423	S141	Jharana_R1_Ranibu_Jamal	27.65828	85.31289
424	S140	Jharana_R1_Ranibu_Jamal	27.65997	85.31429
425	S139	Jharana_R1_Ranibu_Jamal	27.66252	85.31634
426	S138	Jharana_R1_Ranibu_Jamal	27.66144	85.31781
427	S137	Jharana_R1_Ranibu_Jamal	27.66164	85.31856
428	S1	Jharana_R1_Ranibu_Jamal	27.66699	85.32298
429	S2	Jharana_R1_Ranibu_Jamal	27.67055	85.32046
430	S3	Jharana_R1_Ranibu_Jamal	27.67253	85.31402
431	S4	Jharana_R1_Ranibu_Jamal	27.67617	85.31576
432	S5	Jharana_R1_Ranibu_Jamal	27.68077	85.31733
433	S6	Jharana_R1_Ranibu_Jamal	27.68795	85.31618
434	S142	Jharana_R1_Ranibu_Jamal	27.69301	85.31857
435	S98	Jharana_R1_Ranibu_Jamal	27.699	85.3171
436	S8	Jharana_R1_Ranibu_Jamal	27.70114	85.31345
437	S21	Jharana_R1_Ranibu_Jamal	27.70883	85.31539
438	S143	Subhakamana_R1_Swayambhu_Biruwa	27.71601	85.28354
439	S144	Subhakamana_R1_Swayambhu_Biruwa	27.70744	85.28249
440	S145	Subhakamana_R1_Swayambhu_Biruwa	27.70023	85.28177
441	S146	Subhakamana_R1_Swayambhu_Biruwa	27.699	85.28147
442	S147	Subhakamana_R1_Swayambhu_Biruwa	27.69344	85.28222
443	S148	Subhakamana_R1_Swayambhu_Biruwa	27.69421	85.28497
444	S149	Subhakamana_R1_Swayambhu_Biruwa	27.69661	85.29354
445	S150	Subhakamana_R1_Swayambhu_Biruwa	27.69838	85.29908
446	S151	Subhakamana_R1_Swayambhu_Biruwa	27.69682	85.30529
447	S152	Subhakamana_R1_Swayambhu_Biruwa	27.69344	85.31456
448	S142	Subhakamana_R1_Swayambhu_Biruwa	27.69301	85.31857
449	S81	Subhakamana_R1_Swayambhu_Biruwa	27.69365	85.32156
450	S82	Subhakamana_R1_Swayambhu_Biruwa	27.69227	85.32442
451	S83	Subhakamana_R1_Swayambhu_Biruwa	27.69066	85.32787
452	S84	Subhakamana_R1_Swayambhu_Biruwa	27.68845	85.33487
453	S85	Subhakamana_R1_Swayambhu_Biruwa	27.68763	85.33868
454	S86	Subhakamana_R1_Swayambhu_Biruwa	27.68672	85.34266
455	S87	Subhakamana_R1_Swayambhu_Biruwa	27.68608	85.34551
456	S153	Subhakamana_R1_Swayambhu_Biruwa	27.67903	85.34972
457	S154	Subhakamana_R1_Swayambhu_Biruwa	27.67549	85.35146
458	S155	Subhakamana_R1_Swayambhu_Biruwa	27.67486	85.3598
459	S156	Subhakamana_R1_Swayambhu_Biruwa	27.67455	85.36428
460	S157	Subhakamana_R1_Swayambhu_Biruwa	27.66928	85.3657
461	S158	Subhakamana_R1_Swayambhu_Biruwa	27.66677	85.366
462	S159	Subhakamana_R1_Swayambhu_Biruwa	27.66501	85.3666
463	S160	Subhakamana_R1_Swayambhu_Biruwa	27.66202	85.36968
464	S161	Subhakamana_R1_Swayambhu_Biruwa	27.66107	85.36974
465	S162	Subhakamana_R1_Swayambhu_Biruwa	27.65985	85.37032
466	S163	Subhakamana_R1_Swayambhu_Biruwa	27.65472	85.37559
467	S164	Subhakamana_R1_Swayambhu_Biruwa	27.65393	85.37742
468	S165	Subhakamana_R1_Swayambhu_Biruwa	27.65041	85.38283
469	S166	Subhakamana_R1_Swayambhu_Biruwa	27.64877	85.3859
470	S167	Subhakamana_R1_Swayambhu_Biruwa	27.64827	85.38691
471	S168	Subhakamana_R1_Swayambhu_Biruwa	27.64726	85.38907
472	S169	Subhakamana_R1_Swayambhu_Biruwa	27.64092	85.39122
473	S170	Subhakamana_R1_Swayambhu_Biruwa	27.63741	85.39338
474	S170	Subhakamana_R1_Biruwa_Swayambhu	27.63741	85.39338
475	S169	Subhakamana_R1_Biruwa_Swayambhu	27.64092	85.39122
476	S168	Subhakamana_R1_Biruwa_Swayambhu	27.64726	85.38907
477	S167	Subhakamana_R1_Biruwa_Swayambhu	27.64827	85.38691
478	S166	Subhakamana_R1_Biruwa_Swayambhu	27.64877	85.3859
479	S165	Subhakamana_R1_Biruwa_Swayambhu	27.65041	85.38283
480	S164	Subhakamana_R1_Biruwa_Swayambhu	27.65393	85.37742
481	S163	Subhakamana_R1_Biruwa_Swayambhu	27.65472	85.37559
482	S162	Subhakamana_R1_Biruwa_Swayambhu	27.65985	85.37032
483	S161	Subhakamana_R1_Biruwa_Swayambhu	27.66107	85.36974
484	S160	Subhakamana_R1_Biruwa_Swayambhu	27.66202	85.36968
485	S159	Subhakamana_R1_Biruwa_Swayambhu	27.66501	85.3666
486	S158	Subhakamana_R1_Biruwa_Swayambhu	27.66677	85.366
487	S157	Subhakamana_R1_Biruwa_Swayambhu	27.66928	85.3657
488	S171	Subhakamana_R1_Biruwa_Swayambhu	27.67444	85.36428
489	S172	Subhakamana_R1_Biruwa_Swayambhu	27.67467	85.35992
490	S173	Subhakamana_R1_Biruwa_Swayambhu	27.67507	85.35415
491	S174	Subhakamana_R1_Biruwa_Swayambhu	27.67986	85.34938
492	S175	Subhakamana_R1_Biruwa_Swayambhu	27.68597	85.34548
493	S176	Subhakamana_R1_Biruwa_Swayambhu	27.68667	85.34166
494	S92	Subhakamana_R1_Biruwa_Swayambhu	27.68748	85.338
495	S93	Subhakamana_R1_Biruwa_Swayambhu	27.68831	85.33485
496	S94	Subhakamana_R1_Biruwa_Swayambhu	27.68912	85.33098
497	S95	Subhakamana_R1_Biruwa_Swayambhu	27.69048	85.3276
498	S96	Subhakamana_R1_Biruwa_Swayambhu	27.69225	85.32413
499	S97	Subhakamana_R1_Biruwa_Swayambhu	27.69375	85.32081
500	S177	Subhakamana_R1_Biruwa_Swayambhu	27.69396	85.31934
501	S178	Subhakamana_R1_Biruwa_Swayambhu	27.69387	85.31321
502	S99	Subhakamana_R1_Biruwa_Swayambhu	27.69633	85.30633
503	S100	Subhakamana_R1_Biruwa_Swayambhu	27.6982	85.30153
504	S179	Subhakamana_R1_Biruwa_Swayambhu	27.69654	85.29358
505	S180	Subhakamana_R1_Biruwa_Swayambhu	27.69416	85.28514
506	S181	Subhakamana_R1_Biruwa_Swayambhu	27.69337	85.28231
507	S182	Subhakamana_R1_Biruwa_Swayambhu	27.69902	85.28146
508	S183	Subhakamana_R1_Biruwa_Swayambhu	27.7045	85.28196
509	S184	Subhakamana_R1_Biruwa_Swayambhu	27.70749	85.28247
510	S185	Subhakamana_R1_Biruwa_Swayambhu	27.716	85.28345
511	S1	Tempo_R1_Maitighar_Lagankhel	27.66699	85.32298
512	S2	Tempo_R1_Maitighar_Lagankhel	27.67055	85.32046
513	S3	Tempo_R1_Maitighar_Lagankhel	27.67253	85.31402
514	S4	Tempo_R1_Maitighar_Lagankhel	27.67617	85.31576
515	S5	Tempo_R1_Maitighar_Lagankhel	27.68077	85.31733
516	S6	Tempo_R1_Maitighar_Lagankhel	27.68795	85.31618
517	S142	Tempo_R1_Maitighar_Lagankhel	27.69301	85.31857
518	S81	Tempo_R1_Maitighar_Lagankhel	27.69365	85.32156
519	S82	Tempo_R1_Maitighar_Lagankhel	27.69227	85.32442
520	S83	Tempo_R1_Maitighar_Lagankhel	27.69066	85.32787
521	S84	Tempo_R1_Maitighar_Lagankhel	27.68845	85.33487
522	S85	Tempo_R1_Maitighar_Lagankhel	27.68763	85.33868
523	S86	Tempo_R1_Maitighar_Lagankhel	27.68672	85.34266
524	S87	Tempo_R1_Maitighar_Lagankhel	27.68608	85.34551
525	S153	Tempo_R1_Maitighar_Lagankhel	27.67903	85.34972
526	S186	Tempo_R1_Maitighar_Lagankhel	27.67817	85.34881
527	S187	Tempo_R1_Maitighar_Lagankhel	27.67537	85.34459
528	S188	Tempo_R1_Maitighar_Lagankhel	27.67355	85.3426
529	S189	Tempo_R1_Maitighar_Lagankhel	27.67146	85.34038
530	S190	Tempo_R1_Maitighar_Lagankhel	27.67007	85.33823
531	S191	Tempo_R1_Maitighar_Lagankhel	27.66796	85.3342
532	S192	Tempo_R1_Maitighar_Lagankhel	27.66648	85.33215
533	S193	Tempo_R1_Maitighar_Lagankhel	27.66011	85.32694
534	S194	Tempo_R1_Maitighar_Lagankhel	27.65881	85.32463
535	S1	Tempo_R1_lagankhel_maitighar	27.66699	85.32298
536	S194	Tempo_R1_lagankhel_maitighar	27.65881	85.32463
537	S60	Tempo_R1_lagankhel_maitighar	27.66039	85.32689
538	S61	Tempo_R1_lagankhel_maitighar	27.66438	85.33028
539	S58	Tempo_R1_lagankhel_maitighar	27.66646	85.33212
540	S190	Tempo_R1_lagankhel_maitighar	27.67007	85.33823
541	S189	Tempo_R1_lagankhel_maitighar	27.67146	85.34038
542	S188	Tempo_R1_lagankhel_maitighar	27.67355	85.3426
543	S187	Tempo_R1_lagankhel_maitighar	27.67537	85.34459
544	S195	Tempo_R1_lagankhel_maitighar	27.6798	85.34946
545	S196	Tempo_R1_lagankhel_maitighar	27.68576	85.34609
546	S176	Tempo_R1_lagankhel_maitighar	27.68667	85.34166
547	S92	Tempo_R1_lagankhel_maitighar	27.68748	85.338
548	S93	Tempo_R1_lagankhel_maitighar	27.68831	85.33485
549	S94	Tempo_R1_lagankhel_maitighar	27.68912	85.33098
550	S95	Tempo_R1_lagankhel_maitighar	27.69048	85.3276
551	S96	Tempo_R1_lagankhel_maitighar	27.69225	85.32413
552	S97	Tempo_R1_lagankhel_maitighar	27.69375	85.32081
553	S177	Tempo_R1_lagankhel_maitighar	27.69396	85.31934
554	S6	Tempo_R1_lagankhel_maitighar	27.68795	85.31618
555	S5	Tempo_R1_lagankhel_maitighar	27.68077	85.31733
556	S4	Tempo_R1_lagankhel_maitighar	27.67617	85.31576
557	S3	Tempo_R1_lagankhel_maitighar	27.67253	85.31402
558	S2	Tempo_R1_lagankhel_maitighar	27.67055	85.32046
559	S8	Tempo_R2_RNAC_Sinamangal	27.70114	85.31345
560	S197	Tempo_R2_RNAC_Sinamangal	27.7057	85.31403
561	S21	Tempo_R2_RNAC_Sinamangal	27.70883	85.31539
562	S198	Tempo_R2_RNAC_Sinamangal	27.70798	85.31854
563	S199	Tempo_R2_RNAC_Sinamangal	27.70801	85.32181
564	S200	Tempo_R2_RNAC_Sinamangal	27.71035	85.32234
565	S201	Tempo_R2_RNAC_Sinamangal	27.71006	85.32565
566	S202	Tempo_R2_RNAC_Sinamangal	27.70955	85.32793
567	S203	Tempo_R2_RNAC_Sinamangal	27.70844	85.33234
568	S204	Tempo_R2_RNAC_Sinamangal	27.70607	85.33377
569	S205	Tempo_R2_RNAC_Sinamangal	27.70393	85.33267
570	S206	Tempo_R2_RNAC_Sinamangal	27.70305	85.33557
571	S207	Tempo_R2_RNAC_Sinamangal	27.70154	85.33992
572	S208	Tempo_R2_RNAC_Sinamangal	27.69927	85.34582
573	S209	Tempo_R2_RNAC_Sinamangal	27.69716	85.35053
574	S210	Tempo_R2_RNAC_Sinamangal	27.69566	85.35317
575	S210	Tempo_R2_Sinamangal_RNAC	27.69566	85.35317
576	S209	Tempo_R2_Sinamangal_RNAC	27.69716	85.35053
577	S208	Tempo_R2_Sinamangal_RNAC	27.69927	85.34582
578	S207	Tempo_R2_Sinamangal_RNAC	27.70154	85.33992
579	S206	Tempo_R2_Sinamangal_RNAC	27.70305	85.33557
580	S205	Tempo_R2_Sinamangal_RNAC	27.70393	85.33267
581	S211	Tempo_R2_Sinamangal_RNAC	27.70503	85.32852
582	S212	Tempo_R2_Sinamangal_RNAC	27.70559	85.32367
583	S213	Tempo_R2_Sinamangal_RNAC	27.70315	85.32242
584	S214	Tempo_R2_Sinamangal_RNAC	27.70186	85.32013
585	S215	Tempo_R2_Sinamangal_RNAC	27.70223	85.31682
586	S22	Tempo_R2_Sinamangal_RNAC	27.70258	85.31647
587	S23	Tempo_R2_Sinamangal_RNAC	27.69971	85.31398
588	S8	Tempo_R2_Sinamangal_RNAC	27.70114	85.31345
589	S8	Tempo_R3_RNAC_Tinchuli	27.70114	85.31345
590	S197	Tempo_R3_RNAC_Tinchuli	27.7057	85.31403
591	S21	Tempo_R3_RNAC_Tinchuli	27.70883	85.31539
592	S198	Tempo_R3_RNAC_Tinchuli	27.70798	85.31854
593	S199	Tempo_R3_RNAC_Tinchuli	27.70801	85.32181
594	S200	Tempo_R3_RNAC_Tinchuli	27.71035	85.32234
595	S201	Tempo_R3_RNAC_Tinchuli	27.71006	85.32565
596	S202	Tempo_R3_RNAC_Tinchuli	27.70955	85.32793
597	S203	Tempo_R3_RNAC_Tinchuli	27.70844	85.33234
598	S204	Tempo_R3_RNAC_Tinchuli	27.70607	85.33377
599	S205	Tempo_R3_RNAC_Tinchuli	27.70393	85.33267
600	S206	Tempo_R3_RNAC_Tinchuli	27.70305	85.33557
601	S207	Tempo_R3_RNAC_Tinchuli	27.70154	85.33992
602	S216	Tempo_R3_RNAC_Tinchuli	27.7017	85.34031
603	S217	Tempo_R3_RNAC_Tinchuli	27.70499	85.34195
604	S218	Tempo_R3_RNAC_Tinchuli	27.70755	85.34316
605	S219	Tempo_R3_RNAC_Tinchuli	27.71034	85.34415
606	S220	Tempo_R3_RNAC_Tinchuli	27.71316	85.34542
607	S221	Tempo_R3_RNAC_Tinchuli	27.71706	85.3465
608	S222	Tempo_R3_RNAC_Tinchuli	27.71818	85.34851
609	S223	Tempo_R3_RNAC_Tinchuli	27.71989	85.35109
610	S224	Tempo_R3_RNAC_Tinchuli	27.72427	85.35682
611	S225	Tempo_R3_RNAC_Tinchuli	27.72624	85.36363
612	S226	Tempo_R3_RNAC_Tinchuli	27.72702	85.36856
613	S226	Tempo_R3_Tinchuli_RNAC	27.72702	85.36856
614	S225	Tempo_R3_Tinchuli_RNAC	27.72624	85.36363
615	S224	Tempo_R3_Tinchuli_RNAC	27.72427	85.35682
616	S223	Tempo_R3_Tinchuli_RNAC	27.71989	85.35109
617	S222	Tempo_R3_Tinchuli_RNAC	27.71818	85.34851
618	S227	Tempo_R3_Tinchuli_RNAC	27.71754	85.34653
619	S220	Tempo_R3_Tinchuli_RNAC	27.71316	85.34542
620	S219	Tempo_R3_Tinchuli_RNAC	27.71034	85.34415
621	S218	Tempo_R3_Tinchuli_RNAC	27.70755	85.34316
622	S217	Tempo_R3_Tinchuli_RNAC	27.70499	85.34195
623	S216	Tempo_R3_Tinchuli_RNAC	27.7017	85.34031
624	S207	Tempo_R3_Tinchuli_RNAC	27.70154	85.33992
625	S206	Tempo_R3_Tinchuli_RNAC	27.70305	85.33557
626	S205	Tempo_R3_Tinchuli_RNAC	27.70393	85.33267
627	S211	Tempo_R3_Tinchuli_RNAC	27.70503	85.32852
628	S212	Tempo_R3_Tinchuli_RNAC	27.70559	85.32367
629	S213	Tempo_R3_Tinchuli_RNAC	27.70315	85.32242
630	S214	Tempo_R3_Tinchuli_RNAC	27.70186	85.32013
631	S215	Tempo_R3_Tinchuli_RNAC	27.70223	85.31682
632	S22	Tempo_R3_Tinchuli_RNAC	27.70258	85.31647
633	S23	Tempo_R3_Tinchuli_RNAC	27.69971	85.31398
634	S8	Tempo_R3_Tinchuli_RNAC	27.70114	85.31345
635	S228	Tempo_R4_Kapan _ Sankhamul	27.74464	85.35993
636	S229	Tempo_R4_Kapan _ Sankhamul	27.74045	85.3638
637	S230	Tempo_R4_Kapan _ Sankhamul	27.73825	85.36222
638	S231	Tempo_R4_Kapan _ Sankhamul	27.73533	85.36424
639	S232	Tempo_R4_Kapan _ Sankhamul	27.73207	85.36233
640	S233	Tempo_R4_Kapan _ Sankhamul	27.72859	85.35909
641	S234	Tempo_R4_Kapan _ Sankhamul	27.72733	85.35693
642	S235	Tempo_R4_Kapan _ Sankhamul	27.72442	85.35221
643	S236	Tempo_R4_Kapan _ Sankhamul	27.72193	85.34629
644	S221	Tempo_R4_Kapan _ Sankhamul	27.71706	85.3465
645	S220	Tempo_R4_Kapan _ Sankhamul	27.71316	85.34542
646	S219	Tempo_R4_Kapan _ Sankhamul	27.71034	85.34415
647	S218	Tempo_R4_Kapan _ Sankhamul	27.70755	85.34316
648	S217	Tempo_R4_Kapan _ Sankhamul	27.70499	85.34195
649	S216	Tempo_R4_Kapan _ Sankhamul	27.7017	85.34031
650	S237	Tempo_R4_Kapan _ Sankhamul	27.70033	85.33908
651	S238	Tempo_R4_Kapan _ Sankhamul	27.69711	85.33777
652	S239	Tempo_R4_Kapan _ Sankhamul	27.6927	85.33635
653	S240	Tempo_R4_Kapan _ Sankhamul	27.6903	85.33595
654	S241	Tempo_R4_Kapan _ Sankhamul	27.68791	85.33542
655	S242	Tempo_R4_Kapan _ Sankhamul	27.68561	85.33509
656	S243	Tempo_R4_Kapan _ Sankhamul	27.68453	85.33371
657	S244	Tempo_R4_Kapan _ Sankhamul	27.68344	85.33333
658	S245	Tempo_R4_Kapan _ Sankhamul	27.68113	85.33158
659	S245	Tempo_R4_Sankhamul_Kapan	27.68113	85.33158
660	S244	Tempo_R4_Sankhamul_Kapan	27.68344	85.33333
661	S243	Tempo_R4_Sankhamul_Kapan	27.68453	85.33371
662	S242	Tempo_R4_Sankhamul_Kapan	27.68561	85.33509
663	S241	Tempo_R4_Sankhamul_Kapan	27.68791	85.33542
664	S240	Tempo_R4_Sankhamul_Kapan	27.6903	85.33595
665	S239	Tempo_R4_Sankhamul_Kapan	27.6927	85.33635
666	S238	Tempo_R4_Sankhamul_Kapan	27.69711	85.33777
667	S237	Tempo_R4_Sankhamul_Kapan	27.70033	85.33908
668	S216	Tempo_R4_Sankhamul_Kapan	27.7017	85.34031
669	S217	Tempo_R4_Sankhamul_Kapan	27.70499	85.34195
670	S218	Tempo_R4_Sankhamul_Kapan	27.70755	85.34316
671	S219	Tempo_R4_Sankhamul_Kapan	27.71034	85.34415
672	S220	Tempo_R4_Sankhamul_Kapan	27.71316	85.34542
673	S221	Tempo_R4_Sankhamul_Kapan	27.71706	85.3465
674	S236	Tempo_R4_Sankhamul_Kapan	27.72193	85.34629
675	S235	Tempo_R4_Sankhamul_Kapan	27.72442	85.35221
676	S234	Tempo_R4_Sankhamul_Kapan	27.72733	85.35693
677	S233	Tempo_R4_Sankhamul_Kapan	27.72859	85.35909
678	S232	Tempo_R4_Sankhamul_Kapan	27.73207	85.36233
679	S231	Tempo_R4_Sankhamul_Kapan	27.73533	85.36424
680	S230	Tempo_R4_Sankhamul_Kapan	27.73825	85.36222
681	S229	Tempo_R4_Sankhamul_Kapan	27.74045	85.3638
682	S228	Tempo_R4_Sankhamul_Kapan	27.74464	85.35993
683	S8	Tempo_R5_Ratnapark_Imadol	27.70114	85.31345
684	S78	Tempo_R5_Ratnapark_Imadol	27.70669	85.31485
685	S215	Tempo_R5_Ratnapark_Imadol	27.70223	85.31682
686	S22	Tempo_R5_Ratnapark_Imadol	27.70258	85.31647
687	S79	Tempo_R5_Ratnapark_Imadol	27.698	85.32141
688	S80	Tempo_R5_Ratnapark_Imadol	27.6965	85.32101
689	S177	Tempo_R5_Ratnapark_Imadol	27.69396	85.31934
690	S6	Tempo_R5_Ratnapark_Imadol	27.68795	85.31618
691	S5	Tempo_R5_Ratnapark_Imadol	27.68077	85.31733
692	S4	Tempo_R5_Ratnapark_Imadol	27.67617	85.31576
693	S246	Tempo_R5_Ratnapark_Imadol	27.67687	85.31683
694	S247	Tempo_R5_Ratnapark_Imadol	27.67434	85.32076
695	S248	Tempo_R5_Ratnapark_Imadol	27.67331	85.32405
696	S249	Tempo_R5_Ratnapark_Imadol	27.66842	85.33009
697	S250	Tempo_R5_Ratnapark_Imadol	27.66647	85.33241
698	S57	Tempo_R5_Ratnapark_Imadol	27.66547	85.3352
699	S56	Tempo_R5_Ratnapark_Imadol	27.66313	85.33967
700	S55	Tempo_R5_Ratnapark_Imadol	27.66264	85.3405
701	S54	Tempo_R5_Ratnapark_Imadol	27.66167	85.34269
702	S53	Tempo_R5_Ratnapark_Imadol	27.65933	85.34435
703	S52	Tempo_R5_Ratnapark_Imadol	27.65738	85.3478
704	S51	Tempo_R5_Ratnapark_Imadol	27.65649	85.34863
705	S50	Tempo_R5_Ratnapark_Imadol	27.65491	85.34978
706	S251	Tempo_R5_Ratnapark_Imadol	27.65331	85.34901
707	S252	Tempo_R5_Ratnapark_Imadol	27.65063	85.34834
708	S253	Tempo_R5_Ratnapark_Imadol	27.64826	85.34765
709	S253	Tempo_R5_Imadol_Ratnapark	27.64826	85.34765
710	S252	Tempo_R5_Imadol_Ratnapark	27.65063	85.34834
711	S251	Tempo_R5_Imadol_Ratnapark	27.65331	85.34901
712	S50	Tempo_R5_Imadol_Ratnapark	27.65491	85.34978
713	S51	Tempo_R5_Imadol_Ratnapark	27.65649	85.34863
714	S52	Tempo_R5_Imadol_Ratnapark	27.65738	85.3478
715	S53	Tempo_R5_Imadol_Ratnapark	27.65933	85.34435
716	S54	Tempo_R5_Imadol_Ratnapark	27.66167	85.34269
717	S55	Tempo_R5_Imadol_Ratnapark	27.66264	85.3405
718	S56	Tempo_R5_Imadol_Ratnapark	27.66313	85.33967
719	S57	Tempo_R5_Imadol_Ratnapark	27.66547	85.3352
720	S250	Tempo_R5_Imadol_Ratnapark	27.66647	85.33241
721	S249	Tempo_R5_Imadol_Ratnapark	27.66842	85.33009
722	S248	Tempo_R5_Imadol_Ratnapark	27.67331	85.32405
723	S247	Tempo_R5_Imadol_Ratnapark	27.67434	85.32076
724	S246	Tempo_R5_Imadol_Ratnapark	27.67687	85.31683
725	S4	Tempo_R5_Imadol_Ratnapark	27.67617	85.31576
726	S5	Tempo_R5_Imadol_Ratnapark	27.68077	85.31733
727	S6	Tempo_R5_Imadol_Ratnapark	27.68795	85.31618
728	S7	Tempo_R5_Imadol_Ratnapark	27.69328	85.3144
729	S8	Tempo_R5_Imadol_Ratnapark	27.70114	85.31345
730	S254	Nepal_R1_Balkhu_Harhar_Mahadev	27.6849	85.29862
731	S255	Nepal_R1_Balkhu_Harhar_Mahadev	27.68441	85.30178
732	S256	Nepal_R1_Balkhu_Harhar_Mahadev	27.68126	85.30251
733	S257	Nepal_R1_Balkhu_Harhar_Mahadev	27.6749	85.30224
734	S258	Nepal_R1_Balkhu_Harhar_Mahadev	27.67168	85.30423
735	S259	Nepal_R1_Balkhu_Harhar_Mahadev	27.66692	85.30817
736	S260	Nepal_R1_Balkhu_Harhar_Mahadev	27.66977	85.31049
737	S261	Nepal_R1_Balkhu_Harhar_Mahadev	27.67261	85.31323
738	S262	Nepal_R1_Balkhu_Harhar_Mahadev	27.67616	85.31569
739	S5	Nepal_R1_Balkhu_Harhar_Mahadev	27.68077	85.31733
740	S6	Nepal_R1_Balkhu_Harhar_Mahadev	27.68795	85.31618
741	S142	Nepal_R1_Balkhu_Harhar_Mahadev	27.69301	85.31857
742	S81	Nepal_R1_Balkhu_Harhar_Mahadev	27.69365	85.32156
743	S82	Nepal_R1_Balkhu_Harhar_Mahadev	27.69227	85.32442
744	S83	Nepal_R1_Balkhu_Harhar_Mahadev	27.69066	85.32787
745	S84	Nepal_R1_Balkhu_Harhar_Mahadev	27.68845	85.33487
746	S85	Nepal_R1_Balkhu_Harhar_Mahadev	27.68763	85.33868
747	S86	Nepal_R1_Balkhu_Harhar_Mahadev	27.68672	85.34266
748	S87	Nepal_R1_Balkhu_Harhar_Mahadev	27.68608	85.34551
749	S153	Nepal_R1_Balkhu_Harhar_Mahadev	27.67903	85.34972
750	S154	Nepal_R1_Balkhu_Harhar_Mahadev	27.67549	85.35146
751	S263	Nepal_R1_Balkhu_Harhar_Mahadev	27.68461	85.35671
752	S264	Nepal_R1_Balkhu_Harhar_Mahadev	27.68892	85.36016
753	S265	Nepal_R1_Balkhu_Harhar_Mahadev	27.69026	85.36395
754	S266	Nepal_R1_Balkhu_Harhar_Mahadev	27.69311	85.36775
755	S267	Nepal_R1_Balkhu_Harhar_Mahadev	27.69419	85.3712
756	S268	Nepal_R1_Balkhu_Harhar_Mahadev	27.69606	85.37662
757	S269	Nepal_R1_Balkhu_Harhar_Mahadev	27.7009	85.3851
758	S270	Nepal_R1_Balkhu_Harhar_Mahadev	27.7049	85.39156
759	S270	Nepal_R1_Harhar_Mahadev_Balkhu	27.7049	85.39156
760	S269	Nepal_R1_Harhar_Mahadev_Balkhu	27.7009	85.3851
761	S268	Nepal_R1_Harhar_Mahadev_Balkhu	27.69606	85.37662
762	S267	Nepal_R1_Harhar_Mahadev_Balkhu	27.69419	85.3712
763	S266	Nepal_R1_Harhar_Mahadev_Balkhu	27.69311	85.36775
764	S265	Nepal_R1_Harhar_Mahadev_Balkhu	27.69026	85.36395
765	S271	Nepal_R1_Harhar_Mahadev_Balkhu	27.68886	85.36026
766	S263	Nepal_R1_Harhar_Mahadev_Balkhu	27.68461	85.35671
767	S272	Nepal_R1_Harhar_Mahadev_Balkhu	27.67646	85.35287
768	S195	Nepal_R1_Harhar_Mahadev_Balkhu	27.6798	85.34946
769	S196	Nepal_R1_Harhar_Mahadev_Balkhu	27.68576	85.34609
770	S176	Nepal_R1_Harhar_Mahadev_Balkhu	27.68667	85.34166
771	S92	Nepal_R1_Harhar_Mahadev_Balkhu	27.68748	85.338
772	S93	Nepal_R1_Harhar_Mahadev_Balkhu	27.68831	85.33485
773	S94	Nepal_R1_Harhar_Mahadev_Balkhu	27.68912	85.33098
774	S95	Nepal_R1_Harhar_Mahadev_Balkhu	27.69048	85.3276
775	S96	Nepal_R1_Harhar_Mahadev_Balkhu	27.69225	85.32413
776	S97	Nepal_R1_Harhar_Mahadev_Balkhu	27.69375	85.32081
777	S177	Nepal_R1_Harhar_Mahadev_Balkhu	27.69396	85.31934
778	S178	Nepal_R1_Harhar_Mahadev_Balkhu	27.69387	85.31321
779	S99	Nepal_R1_Harhar_Mahadev_Balkhu	27.69633	85.30633
780	S100	Nepal_R1_Harhar_Mahadev_Balkhu	27.6982	85.30153
781	S273	Nepal_R1_Harhar_Mahadev_Balkhu	27.69565	85.29864
782	S274	Nepal_R1_Harhar_Mahadev_Balkhu	27.69148	85.29883
783	S275	Nepal_R1_Harhar_Mahadev_Balkhu	27.68816	85.29828
784	S254	Nepal_R1_Harhar_Mahadev_Balkhu	27.6849	85.29862
785	S276	Nepal_R2_Mulpani_Ghantaghar	27.71435	85.39649
786	S277	Nepal_R2_Mulpani_Ghantaghar	27.71579	85.39822
787	S278	Nepal_R2_Mulpani_Ghantaghar	27.71249	85.39274
788	S279	Nepal_R2_Mulpani_Ghantaghar	27.70761	85.38309
789	S280	Nepal_R2_Mulpani_Ghantaghar	27.70684	85.37727
790	S281	Nepal_R2_Mulpani_Ghantaghar	27.70597	85.37075
791	S282	Nepal_R2_Mulpani_Ghantaghar	27.70193	85.36893
792	S283	Nepal_R2_Mulpani_Ghantaghar	27.70006	85.36807
793	S284	Nepal_R2_Mulpani_Ghantaghar	27.69822	85.36783
794	S285	Nepal_R2_Mulpani_Ghantaghar	27.69667	85.36717
795	S286	Nepal_R2_Mulpani_Ghantaghar	27.69672	85.36635
796	S287	Nepal_R2_Mulpani_Ghantaghar	27.69566	85.36419
797	S271	Nepal_R2_Mulpani_Ghantaghar	27.68886	85.36026
798	S263	Nepal_R2_Mulpani_Ghantaghar	27.68461	85.35671
799	S272	Nepal_R2_Mulpani_Ghantaghar	27.67646	85.35287
800	S195	Nepal_R2_Mulpani_Ghantaghar	27.6798	85.34946
801	S196	Nepal_R2_Mulpani_Ghantaghar	27.68576	85.34609
802	S176	Nepal_R2_Mulpani_Ghantaghar	27.68667	85.34166
803	S92	Nepal_R2_Mulpani_Ghantaghar	27.68748	85.338
804	S93	Nepal_R2_Mulpani_Ghantaghar	27.68831	85.33485
805	S94	Nepal_R2_Mulpani_Ghantaghar	27.68912	85.33098
806	S95	Nepal_R2_Mulpani_Ghantaghar	27.69048	85.3276
807	S96	Nepal_R2_Mulpani_Ghantaghar	27.69225	85.32413
808	S97	Nepal_R2_Mulpani_Ghantaghar	27.69375	85.32081
809	S80	Nepal_R2_Mulpani_Ghantaghar	27.6965	85.32101
810	S79	Nepal_R2_Mulpani_Ghantaghar	27.698	85.32141
811	S288	Nepal_R2_Mulpani_Ghantaghar	27.70576	85.32279
812	S289	Nepal_R2_Mulpani_Ghantaghar	27.70796	85.31896
813	S290	Nepal_R2_Mulpani_Ghantaghar	27.70788	85.31679
814	S290	Nepal_R2_Ghantaghar_Mulpani	27.70788	85.31679
815	S291	Nepal_R2_Ghantaghar_Mulpani	27.70261	85.31648
816	S292	Nepal_R2_Ghantaghar_Mulpani	27.69967	85.31398
817	S178	Nepal_R2_Ghantaghar_Mulpani	27.69387	85.31321
818	S142	Nepal_R2_Ghantaghar_Mulpani	27.69301	85.31857
819	S81	Nepal_R2_Ghantaghar_Mulpani	27.69365	85.32156
820	S82	Nepal_R2_Ghantaghar_Mulpani	27.69227	85.32442
821	S83	Nepal_R2_Ghantaghar_Mulpani	27.69066	85.32787
822	S84	Nepal_R2_Ghantaghar_Mulpani	27.68845	85.33487
823	S85	Nepal_R2_Ghantaghar_Mulpani	27.68763	85.33868
824	S86	Nepal_R2_Ghantaghar_Mulpani	27.68672	85.34266
825	S87	Nepal_R2_Ghantaghar_Mulpani	27.68608	85.34551
826	S153	Nepal_R2_Ghantaghar_Mulpani	27.67903	85.34972
827	S154	Nepal_R2_Ghantaghar_Mulpani	27.67549	85.35146
828	S263	Nepal_R2_Ghantaghar_Mulpani	27.68461	85.35671
829	S264	Nepal_R2_Ghantaghar_Mulpani	27.68892	85.36016
830	S287	Nepal_R2_Ghantaghar_Mulpani	27.69566	85.36419
831	S286	Nepal_R2_Ghantaghar_Mulpani	27.69672	85.36635
832	S285	Nepal_R2_Ghantaghar_Mulpani	27.69667	85.36717
833	S284	Nepal_R2_Ghantaghar_Mulpani	27.69822	85.36783
834	S283	Nepal_R2_Ghantaghar_Mulpani	27.70006	85.36807
835	S282	Nepal_R2_Ghantaghar_Mulpani	27.70193	85.36893
836	S281	Nepal_R2_Ghantaghar_Mulpani	27.70597	85.37075
837	S280	Nepal_R2_Ghantaghar_Mulpani	27.70684	85.37727
838	S279	Nepal_R2_Ghantaghar_Mulpani	27.70761	85.38309
839	S278	Nepal_R2_Ghantaghar_Mulpani	27.71249	85.39274
840	S277	Nepal_R2_Ghantaghar_Mulpani	27.71579	85.39822
841	S293	Nepal_R3_Kapan_Tikathali	27.74049	85.36378
842	S294	Nepal_R3_Kapan_Tikathali	27.73896	85.36261
843	S295	Nepal_R3_Kapan_Tikathali	27.73777	85.36294
844	S296	Nepal_R3_Kapan_Tikathali	27.73751	85.36407
845	S297	Nepal_R3_Kapan_Tikathali	27.73531	85.36419
846	S298	Nepal_R3_Kapan_Tikathali	27.73385	85.36266
847	S299	Nepal_R3_Kapan_Tikathali	27.73202	85.36234
848	S300	Nepal_R3_Kapan_Tikathali	27.73103	85.36338
849	S301	Nepal_R3_Kapan_Tikathali	27.72968	85.36429
850	S302	Nepal_R3_Kapan_Tikathali	27.72723	85.36393
851	S225	Nepal_R3_Kapan_Tikathali	27.72624	85.36363
852	S224	Nepal_R3_Kapan_Tikathali	27.72427	85.35682
853	S223	Nepal_R3_Kapan_Tikathali	27.71989	85.35109
854	S222	Nepal_R3_Kapan_Tikathali	27.71818	85.34851
855	S227	Nepal_R3_Kapan_Tikathali	27.71754	85.34653
856	S303	Nepal_R3_Kapan_Tikathali	27.72167	85.34577
857	S304	Nepal_R3_Kapan_Tikathali	27.73155	85.34449
858	S305	Nepal_R3_Kapan_Tikathali	27.73506	85.3422
859	S15	Nepal_R3_Kapan_Tikathali	27.73984	85.33726
860	S14	Nepal_R3_Kapan_Tikathali	27.73851	85.33567
861	S13	Nepal_R3_Kapan_Tikathali	27.73504	85.33136
862	S306	Nepal_R3_Kapan_Tikathali	27.73129	85.329
863	S307	Nepal_R3_Kapan_Tikathali	27.72793	85.33083
864	S308	Nepal_R3_Kapan_Tikathali	27.72458	85.33088
865	S309	Nepal_R3_Kapan_Tikathali	27.71946	85.33116
866	S310	Nepal_R3_Kapan_Tikathali	27.71693	85.33036
867	S311	Nepal_R3_Kapan_Tikathali	27.71447	85.32915
868	S312	Nepal_R3_Kapan_Tikathali	27.71495	85.32654
869	S313	Nepal_R3_Kapan_Tikathali	27.7142	85.32585
870	S314	Nepal_R3_Kapan_Tikathali	27.71315	85.32462
871	S315	Nepal_R3_Kapan_Tikathali	27.71111	85.3221
872	S316	Nepal_R3_Kapan_Tikathali	27.70584	85.3229
873	S317	Nepal_R3_Kapan_Tikathali	27.70331	85.32249
874	S318	Nepal_R3_Kapan_Tikathali	27.70076	85.32333
875	S319	Nepal_R3_Kapan_Tikathali	27.69933	85.32889
876	S320	Nepal_R3_Kapan_Tikathali	27.69399	85.32772
877	S321	Nepal_R3_Kapan_Tikathali	27.6922	85.33006
878	S322	Nepal_R3_Kapan_Tikathali	27.69149	85.33264
879	S323	Nepal_R3_Kapan_Tikathali	27.69001	85.33594
880	S85	Nepal_R3_Kapan_Tikathali	27.68763	85.33868
881	S86	Nepal_R3_Kapan_Tikathali	27.68672	85.34266
882	S87	Nepal_R3_Kapan_Tikathali	27.68608	85.34551
883	S153	Nepal_R3_Kapan_Tikathali	27.67903	85.34972
884	S186	Nepal_R3_Kapan_Tikathali	27.67817	85.34881
885	S187	Nepal_R3_Kapan_Tikathali	27.67537	85.34459
886	S188	Nepal_R3_Kapan_Tikathali	27.67355	85.3426
887	S324	Nepal_R3_Kapan_Tikathali	27.67299	85.34269
888	S325	Nepal_R3_Kapan_Tikathali	27.67001	85.34656
889	S326	Nepal_R3_Kapan_Tikathali	27.66805	85.34934
890	S327	Nepal_R3_Kapan_Tikathali	27.66766	85.35053
891	S328	Nepal_R3_Kapan_Tikathali	27.66734	85.35328
892	S329	Nepal_R3_Kapan_Tikathali	27.66587	85.35528
893	S330	Nepal_R3_Kapan_Tikathali	27.66498	85.35739
894	S331	Nepal_R3_Kapan_Tikathali	27.66705	85.361
895	S331	Nepal_R3_Tikathali_Kapan	27.66705	85.361
896	S330	Nepal_R3_Tikathali_Kapan	27.66498	85.35739
897	S329	Nepal_R3_Tikathali_Kapan	27.66587	85.35528
898	S328	Nepal_R3_Tikathali_Kapan	27.66734	85.35328
899	S327	Nepal_R3_Tikathali_Kapan	27.66766	85.35053
900	S326	Nepal_R3_Tikathali_Kapan	27.66805	85.34934
901	S325	Nepal_R3_Tikathali_Kapan	27.67001	85.34656
902	S324	Nepal_R3_Tikathali_Kapan	27.67299	85.34269
903	S188	Nepal_R3_Tikathali_Kapan	27.67355	85.3426
904	S187	Nepal_R3_Tikathali_Kapan	27.67537	85.34459
905	S195	Nepal_R3_Tikathali_Kapan	27.6798	85.34946
906	S196	Nepal_R3_Tikathali_Kapan	27.68576	85.34609
907	S176	Nepal_R3_Tikathali_Kapan	27.68667	85.34166
908	S92	Nepal_R3_Tikathali_Kapan	27.68748	85.338
909	S240	Nepal_R3_Tikathali_Kapan	27.6903	85.33595
910	S322	Nepal_R3_Tikathali_Kapan	27.69149	85.33264
911	S321	Nepal_R3_Tikathali_Kapan	27.6922	85.33006
912	S320	Nepal_R3_Tikathali_Kapan	27.69399	85.32772
913	S319	Nepal_R3_Tikathali_Kapan	27.69933	85.32889
914	S317	Nepal_R3_Tikathali_Kapan	27.70331	85.32249
915	S316	Nepal_R3_Tikathali_Kapan	27.70584	85.3229
916	S315	Nepal_R3_Tikathali_Kapan	27.71111	85.3221
917	S313	Nepal_R3_Tikathali_Kapan	27.7142	85.32585
918	S312	Nepal_R3_Tikathali_Kapan	27.71495	85.32654
919	S311	Nepal_R3_Tikathali_Kapan	27.71447	85.32915
920	S310	Nepal_R3_Tikathali_Kapan	27.71693	85.33036
921	S309	Nepal_R3_Tikathali_Kapan	27.71946	85.33116
922	S308	Nepal_R3_Tikathali_Kapan	27.72458	85.33088
923	S307	Nepal_R3_Tikathali_Kapan	27.72793	85.33083
924	S306	Nepal_R3_Tikathali_Kapan	27.73129	85.329
925	S12	Nepal_R3_Tikathali_Kapan	27.7331	85.32892
926	S13	Nepal_R3_Tikathali_Kapan	27.73504	85.33136
927	S14	Nepal_R3_Tikathali_Kapan	27.73851	85.33567
928	S15	Nepal_R3_Tikathali_Kapan	27.73984	85.33726
929	S305	Nepal_R3_Tikathali_Kapan	27.73506	85.3422
930	S304	Nepal_R3_Tikathali_Kapan	27.73155	85.34449
931	S303	Nepal_R3_Tikathali_Kapan	27.72167	85.34577
932	S227	Nepal_R3_Tikathali_Kapan	27.71754	85.34653
933	S222	Nepal_R3_Tikathali_Kapan	27.71818	85.34851
934	S223	Nepal_R3_Tikathali_Kapan	27.71989	85.35109
935	S224	Nepal_R3_Tikathali_Kapan	27.72427	85.35682
936	S225	Nepal_R3_Tikathali_Kapan	27.72624	85.36363
937	S302	Nepal_R3_Tikathali_Kapan	27.72723	85.36393
938	S301	Nepal_R3_Tikathali_Kapan	27.72968	85.36429
939	S300	Nepal_R3_Tikathali_Kapan	27.73103	85.36338
940	S299	Nepal_R3_Tikathali_Kapan	27.73202	85.36234
941	S298	Nepal_R3_Tikathali_Kapan	27.73385	85.36266
942	S297	Nepal_R3_Tikathali_Kapan	27.73531	85.36419
943	S296	Nepal_R3_Tikathali_Kapan	27.73751	85.36407
944	S295	Nepal_R3_Tikathali_Kapan	27.73777	85.36294
945	S294	Nepal_R3_Tikathali_Kapan	27.73896	85.36261
946	S293	Nepal_R3_Tikathali_Kapan	27.74049	85.36378
947	S193	Mahanagar_R1_Clockwise	27.66011	85.32694
948	S194	Mahanagar_R1_Clockwise	27.65881	85.32463
949	S332	Mahanagar_R1_Clockwise	27.65785	85.32242
950	S333	Mahanagar_R1_Clockwise	27.65912	85.32077
951	S334	Mahanagar_R1_Clockwise	27.66254	85.3165
952	S335	Mahanagar_R1_Clockwise	27.6643	85.3144
953	S336	Mahanagar_R1_Clockwise	27.66662	85.30831
954	S337	Mahanagar_R1_Clockwise	27.67207	85.30353
955	S338	Mahanagar_R1_Clockwise	27.67512	85.30188
956	S339	Mahanagar_R1_Clockwise	27.68164	85.30217
957	S340	Mahanagar_R1_Clockwise	27.68426	85.30161
958	S341	Mahanagar_R1_Clockwise	27.68476	85.29716
959	S342	Mahanagar_R1_Clockwise	27.68565	85.29323
960	S343	Mahanagar_R1_Clockwise	27.68931	85.28418
961	S102	Mahanagar_R1_Clockwise	27.69537	85.28134
962	S103	Mahanagar_R1_Clockwise	27.70208	85.28179
963	S104	Mahanagar_R1_Clockwise	27.70758	85.28248
964	S105	Mahanagar_R1_Clockwise	27.716	85.28353
965	S106	Mahanagar_R1_Clockwise	27.71967	85.28693
966	S107	Mahanagar_R1_Clockwise	27.72136	85.29041
967	S108	Mahanagar_R1_Clockwise	27.72348	85.29453
968	S109	Mahanagar_R1_Clockwise	27.72476	85.2977
969	S110	Mahanagar_R1_Clockwise	27.7272	85.30483
970	S111	Mahanagar_R1_Clockwise	27.73519	85.30572
971	S19	Mahanagar_R1_Clockwise	27.73488	85.31463
972	S18	Mahanagar_R1_Clockwise	27.73561	85.32119
973	S17	Mahanagar_R1_Clockwise	27.7381	85.32542
974	S16	Mahanagar_R1_Clockwise	27.74149	85.33408
975	S15	Mahanagar_R1_Clockwise	27.73984	85.33726
976	S305	Mahanagar_R1_Clockwise	27.73506	85.3422
977	S304	Mahanagar_R1_Clockwise	27.73155	85.34449
978	S303	Mahanagar_R1_Clockwise	27.72167	85.34577
979	S344	Mahanagar_R1_Clockwise	27.7171	85.34665
980	S220	Mahanagar_R1_Clockwise	27.71316	85.34542
981	S219	Mahanagar_R1_Clockwise	27.71034	85.34415
982	S345	Mahanagar_R1_Clockwise	27.70777	85.34335
983	S346	Mahanagar_R1_Clockwise	27.7059	85.34805
984	S347	Mahanagar_R1_Clockwise	27.7062	85.35015
985	S348	Mahanagar_R1_Clockwise	27.70062	85.35373
986	S90	Mahanagar_R1_Clockwise	27.69523	85.35492
987	S89	Mahanagar_R1_Clockwise	27.69131	85.35287
988	S349	Mahanagar_R1_Clockwise	27.68631	85.35009
989	S153	Mahanagar_R1_Clockwise	27.67903	85.34972
990	S186	Mahanagar_R1_Clockwise	27.67817	85.34881
991	S187	Mahanagar_R1_Clockwise	27.67537	85.34459
992	S188	Mahanagar_R1_Clockwise	27.67355	85.3426
993	S189	Mahanagar_R1_Clockwise	27.67146	85.34038
994	S190	Mahanagar_R1_Clockwise	27.67007	85.33823
995	S191	Mahanagar_R1_Clockwise	27.66796	85.3342
996	S192	Mahanagar_R1_Clockwise	27.66648	85.33215
997	S190	Mahanagar_R1_Anti-Clockwise	27.67007	85.33823
998	S189	Mahanagar_R1_Anti-Clockwise	27.67146	85.34038
999	S188	Mahanagar_R1_Anti-Clockwise	27.67355	85.3426
1000	S187	Mahanagar_R1_Anti-Clockwise	27.67537	85.34459
1001	S195	Mahanagar_R1_Anti-Clockwise	27.6798	85.34946
1002	S88	Mahanagar_R1_Anti-Clockwise	27.68636	85.34923
1003	S89	Mahanagar_R1_Anti-Clockwise	27.69131	85.35287
1004	S90	Mahanagar_R1_Anti-Clockwise	27.69523	85.35492
1005	S91	Mahanagar_R1_Anti-Clockwise	27.70059	85.35371
1006	S347	Mahanagar_R1_Anti-Clockwise	27.7062	85.35015
1007	S346	Mahanagar_R1_Anti-Clockwise	27.7059	85.34805
1008	S345	Mahanagar_R1_Anti-Clockwise	27.70777	85.34335
1009	S219	Mahanagar_R1_Anti-Clockwise	27.71034	85.34415
1010	S220	Mahanagar_R1_Anti-Clockwise	27.71316	85.34542
1011	S221	Mahanagar_R1_Anti-Clockwise	27.71706	85.3465
1012	S303	Mahanagar_R1_Anti-Clockwise	27.72167	85.34577
1013	S304	Mahanagar_R1_Anti-Clockwise	27.73155	85.34449
1014	S305	Mahanagar_R1_Anti-Clockwise	27.73506	85.3422
1015	S15	Mahanagar_R1_Anti-Clockwise	27.73984	85.33726
1016	S16	Mahanagar_R1_Anti-Clockwise	27.74149	85.33408
1017	S17	Mahanagar_R1_Anti-Clockwise	27.7381	85.32542
1018	S18	Mahanagar_R1_Anti-Clockwise	27.73561	85.32119
1019	S19	Mahanagar_R1_Anti-Clockwise	27.73488	85.31463
1020	S111	Mahanagar_R1_Anti-Clockwise	27.73519	85.30572
1021	S110	Mahanagar_R1_Anti-Clockwise	27.7272	85.30483
1022	S109	Mahanagar_R1_Anti-Clockwise	27.72476	85.2977
1023	S108	Mahanagar_R1_Anti-Clockwise	27.72348	85.29453
1024	S107	Mahanagar_R1_Anti-Clockwise	27.72136	85.29041
1025	S106	Mahanagar_R1_Anti-Clockwise	27.71967	85.28693
1026	S105	Mahanagar_R1_Anti-Clockwise	27.716	85.28353
1027	S104	Mahanagar_R1_Anti-Clockwise	27.70758	85.28248
1028	S103	Mahanagar_R1_Anti-Clockwise	27.70208	85.28179
1029	S102	Mahanagar_R1_Anti-Clockwise	27.69537	85.28134
1030	S343	Mahanagar_R1_Anti-Clockwise	27.68931	85.28418
1031	S342	Mahanagar_R1_Anti-Clockwise	27.68565	85.29323
1032	S254	Mahanagar_R1_Anti-Clockwise	27.6849	85.29862
1033	S255	Mahanagar_R1_Anti-Clockwise	27.68441	85.30178
1034	S256	Mahanagar_R1_Anti-Clockwise	27.68126	85.30251
1035	S257	Mahanagar_R1_Anti-Clockwise	27.6749	85.30224
1036	S258	Mahanagar_R1_Anti-Clockwise	27.67168	85.30423
1037	S336	Mahanagar_R1_Anti-Clockwise	27.66662	85.30831
1038	S335	Mahanagar_R1_Anti-Clockwise	27.6643	85.3144
1039	S334	Mahanagar_R1_Anti-Clockwise	27.66254	85.3165
1040	S333	Mahanagar_R1_Anti-Clockwise	27.65912	85.32077
1041	S332	Mahanagar_R1_Anti-Clockwise	27.65785	85.32242
1042	S194	Mahanagar_R1_Anti-Clockwise	27.65881	85.32463
1043	S60	Mahanagar_R1_Anti-Clockwise	27.66039	85.32689
1044	S61	Mahanagar_R1_Anti-Clockwise	27.66438	85.33028
1045	S58	Mahanagar_R1_Anti-Clockwise	27.66646	85.33212
1046	S62	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69939	85.20908
1047	S63	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69352	85.21953
1048	S64	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69026	85.22193
1049	S65	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68901	85.22721
1050	S66	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68773	85.24209
1051	S67	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68689	85.25124
1052	S68	Riddhi_Siddhi_R1_Thankot_Mulpani	27.6862	85.25999
1053	S69	Riddhi_Siddhi_R1_Thankot_Mulpani	27.6871	85.26483
1054	S70	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68802	85.26993
1055	S71	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69132	85.2756
1056	S72	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69337	85.28189
1057	S73	Riddhi_Siddhi_R1_Thankot_Mulpani	27.6942	85.28504
1058	S74	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69564	85.29099
1059	S75	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69685	85.29429
1060	S76	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69846	85.29955
1061	S77	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69785	85.30314
1062	S7	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69328	85.3144
1063	S142	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69301	85.31857
1064	S81	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69365	85.32156
1065	S82	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69227	85.32442
1066	S83	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69066	85.32787
1067	S84	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68845	85.33487
1068	S85	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68763	85.33868
1069	S86	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68672	85.34266
1070	S87	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68608	85.34551
1071	S153	Riddhi_Siddhi_R1_Thankot_Mulpani	27.67903	85.34972
1072	S154	Riddhi_Siddhi_R1_Thankot_Mulpani	27.67549	85.35146
1073	S263	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68461	85.35671
1074	S264	Riddhi_Siddhi_R1_Thankot_Mulpani	27.68892	85.36016
1075	S265	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69026	85.36395
1076	S266	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69311	85.36775
1077	S267	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69419	85.3712
1078	S268	Riddhi_Siddhi_R1_Thankot_Mulpani	27.69606	85.37662
1079	S269	Riddhi_Siddhi_R1_Thankot_Mulpani	27.7009	85.3851
1080	S350	Riddhi_Siddhi_R1_Thankot_Mulpani	27.70239	85.38701
1081	S351	Riddhi_Siddhi_R1_Thankot_Mulpani	27.70473	85.39142
1082	S352	Riddhi_Siddhi_R1_Thankot_Mulpani	27.7068	85.39479
1083	S353	Riddhi_Siddhi_R1_Thankot_Mulpani	27.71163	85.40306
1084	S354	Riddhi_Siddhi_R1_Thankot_Mulpani	27.7157	85.40621
1085	S355	Riddhi_Siddhi_R1_Thankot_Mulpani	27.71334	85.41713
1086	S356	Riddhi_Siddhi_R1_Thankot_Mulpani	27.7109	85.41655
1087	S356	Riddhi_Siddhi_R1_Mulpani_Thankot	27.7109	85.41655
1088	S355	Riddhi_Siddhi_R1_Mulpani_Thankot	27.71334	85.41713
1089	S354	Riddhi_Siddhi_R1_Mulpani_Thankot	27.7157	85.40621
1090	S353	Riddhi_Siddhi_R1_Mulpani_Thankot	27.71163	85.40306
1091	S352	Riddhi_Siddhi_R1_Mulpani_Thankot	27.7068	85.39479
1092	S351	Riddhi_Siddhi_R1_Mulpani_Thankot	27.70473	85.39142
1093	S350	Riddhi_Siddhi_R1_Mulpani_Thankot	27.70239	85.38701
1094	S269	Riddhi_Siddhi_R1_Mulpani_Thankot	27.7009	85.3851
1095	S268	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69606	85.37662
1096	S267	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69419	85.3712
1097	S266	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69311	85.36775
1098	S265	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69026	85.36395
1099	S271	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68886	85.36026
1100	S263	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68461	85.35671
1101	S272	Riddhi_Siddhi_R1_Mulpani_Thankot	27.67646	85.35287
1102	S195	Riddhi_Siddhi_R1_Mulpani_Thankot	27.6798	85.34946
1103	S87	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68608	85.34551
1104	S86	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68672	85.34266
1105	S92	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68748	85.338
1106	S93	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68831	85.33485
1107	S94	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68912	85.33098
1108	S95	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69048	85.3276
1109	S96	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69225	85.32413
1110	S97	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69375	85.32081
1111	S98	Riddhi_Siddhi_R1_Mulpani_Thankot	27.699	85.3171
1112	S23	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69971	85.31398
1113	S7	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69328	85.3144
1114	S99	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69633	85.30633
1115	S100	Riddhi_Siddhi_R1_Mulpani_Thankot	27.6982	85.30153
1116	S75	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69685	85.29429
1117	S74	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69564	85.29099
1118	S73	Riddhi_Siddhi_R1_Mulpani_Thankot	27.6942	85.28504
1119	S72	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69337	85.28189
1120	S71	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69132	85.2756
1121	S70	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68802	85.26993
1122	S69	Riddhi_Siddhi_R1_Mulpani_Thankot	27.6871	85.26483
1123	S68	Riddhi_Siddhi_R1_Mulpani_Thankot	27.6862	85.25999
1124	S67	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68689	85.25124
1125	S66	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68773	85.24209
1126	S65	Riddhi_Siddhi_R1_Mulpani_Thankot	27.68901	85.22721
1127	S64	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69026	85.22193
1128	S63	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69352	85.21953
1129	S62	Riddhi_Siddhi_R1_Mulpani_Thankot	27.69939	85.20908
1130	S8	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.70114	85.31345
1131	S78	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.70669	85.31485
1132	S22	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.70258	85.31647
1133	S79	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.698	85.32141
1134	S80	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.6965	85.32101
1135	S81	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.69365	85.32156
1136	S82	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.69227	85.32442
1137	S83	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.69066	85.32787
1138	S84	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.68845	85.33487
1139	S85	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.68763	85.33868
1140	S86	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.68672	85.34266
1141	S87	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.68608	85.34551
1142	S153	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67903	85.34972
1143	S186	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67817	85.34881
1144	S187	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67537	85.34459
1145	S188	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67355	85.3426
1146	S189	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67146	85.34038
1147	S190	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.67007	85.33823
1148	S191	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66796	85.3342
1149	S192	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66648	85.33215
1150	S250	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66647	85.33241
1151	S57	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66547	85.3352
1152	S56	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66313	85.33967
1153	S55	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66264	85.3405
1154	S54	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.66167	85.34269
1155	S53	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.65933	85.34435
1156	S52	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.65738	85.3478
1157	S51	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.65649	85.34863
1158	S50	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.65491	85.34978
1159	S357	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.6508	85.35576
1160	S358	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.64832	85.35511
1161	S359	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.64459	85.35282
1162	S360	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.64268	85.35179
1163	S361	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.63821	85.35187
1164	S362	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.63419	85.35054
1165	S363	Riddhi_Siddhi_R2_RNAC_Harisiddhi	27.63444	85.34732
1166	S363	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.63444	85.34732
1167	S362	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.63419	85.35054
1168	S361	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.63821	85.35187
1169	S360	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.64268	85.35179
1170	S359	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.64459	85.35282
1171	S358	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.64832	85.35511
1172	S357	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.6508	85.35576
1173	S50	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.65491	85.34978
1174	S51	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.65649	85.34863
1175	S52	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.65738	85.3478
1176	S53	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.65933	85.34435
1177	S54	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66167	85.34269
1178	S55	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66264	85.3405
1179	S56	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66313	85.33967
1180	S57	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66547	85.3352
1181	S250	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66647	85.33241
1182	S192	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.66648	85.33215
1183	S190	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.67007	85.33823
1184	S189	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.67146	85.34038
1185	S188	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.67355	85.3426
1186	S187	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.67537	85.34459
1187	S195	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.6798	85.34946
1188	S87	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.68608	85.34551
1189	S86	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.68672	85.34266
1190	S92	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.68748	85.338
1191	S93	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.68831	85.33485
1192	S94	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.68912	85.33098
1193	S95	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.69048	85.3276
1194	S96	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.69225	85.32413
1195	S97	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.69375	85.32081
1196	S98	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.699	85.3171
1197	S23	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.69971	85.31398
1198	S8	Riddhi_Siddhi_R2_Harisiddhi_RNAC	27.70114	85.31345
1199	S364	Bhaktapur_R1_Bhaktapur_Kalanki	27.67721	85.43697
1200	S365	Bhaktapur_R1_Bhaktapur_Kalanki	27.67345	85.4383
1201	S366	Bhaktapur_R1_Bhaktapur_Kalanki	27.66652	85.43641
1202	S367	Bhaktapur_R1_Bhaktapur_Kalanki	27.66543	85.42726
1203	S368	Bhaktapur_R1_Bhaktapur_Kalanki	27.66711	85.41699
1204	S369	Bhaktapur_R1_Bhaktapur_Kalanki	27.67129	85.40884
1205	S370	Bhaktapur_R1_Bhaktapur_Kalanki	27.67452	85.3976
1206	S371	Bhaktapur_R1_Bhaktapur_Kalanki	27.67331	85.38639
1207	S372	Bhaktapur_R1_Bhaktapur_Kalanki	27.67329	85.38168
1208	S373	Bhaktapur_R1_Bhaktapur_Kalanki	27.67342	85.37901
1209	S374	Bhaktapur_R1_Bhaktapur_Kalanki	27.67394	85.37234
1210	S171	Bhaktapur_R1_Bhaktapur_Kalanki	27.67444	85.36428
1211	S172	Bhaktapur_R1_Bhaktapur_Kalanki	27.67467	85.35992
1212	S173	Bhaktapur_R1_Bhaktapur_Kalanki	27.67507	85.35415
1213	S186	Bhaktapur_R1_Bhaktapur_Kalanki	27.67817	85.34881
1214	S187	Bhaktapur_R1_Bhaktapur_Kalanki	27.67537	85.34459
1215	S188	Bhaktapur_R1_Bhaktapur_Kalanki	27.67355	85.3426
1216	S189	Bhaktapur_R1_Bhaktapur_Kalanki	27.67146	85.34038
1217	S190	Bhaktapur_R1_Bhaktapur_Kalanki	27.67007	85.33823
1218	S191	Bhaktapur_R1_Bhaktapur_Kalanki	27.66796	85.3342
1219	S192	Bhaktapur_R1_Bhaktapur_Kalanki	27.66648	85.33215
1220	S193	Bhaktapur_R1_Bhaktapur_Kalanki	27.66011	85.32694
1221	S194	Bhaktapur_R1_Bhaktapur_Kalanki	27.65881	85.32463
1222	S332	Bhaktapur_R1_Bhaktapur_Kalanki	27.65785	85.32242
1223	S333	Bhaktapur_R1_Bhaktapur_Kalanki	27.65912	85.32077
1224	S334	Bhaktapur_R1_Bhaktapur_Kalanki	27.66254	85.3165
1225	S335	Bhaktapur_R1_Bhaktapur_Kalanki	27.6643	85.3144
1226	S336	Bhaktapur_R1_Bhaktapur_Kalanki	27.66662	85.30831
1227	S337	Bhaktapur_R1_Bhaktapur_Kalanki	27.67207	85.30353
1228	S338	Bhaktapur_R1_Bhaktapur_Kalanki	27.67512	85.30188
1229	S339	Bhaktapur_R1_Bhaktapur_Kalanki	27.68164	85.30217
1230	S340	Bhaktapur_R1_Bhaktapur_Kalanki	27.68426	85.30161
1231	S341	Bhaktapur_R1_Bhaktapur_Kalanki	27.68476	85.29716
1232	S342	Bhaktapur_R1_Bhaktapur_Kalanki	27.68565	85.29323
1233	S343	Bhaktapur_R1_Bhaktapur_Kalanki	27.68931	85.28418
1234	S102	Bhaktapur_R1_Bhaktapur_Kalanki	27.69537	85.28134
1235	S102	Bhaktapur_R1_Kalanki_Bhaktapur	27.69537	85.28134
1236	S343	Bhaktapur_R1_Kalanki_Bhaktapur	27.68931	85.28418
1237	S342	Bhaktapur_R1_Kalanki_Bhaktapur	27.68565	85.29323
1238	S254	Bhaktapur_R1_Kalanki_Bhaktapur	27.6849	85.29862
1239	S255	Bhaktapur_R1_Kalanki_Bhaktapur	27.68441	85.30178
1240	S256	Bhaktapur_R1_Kalanki_Bhaktapur	27.68126	85.30251
1241	S257	Bhaktapur_R1_Kalanki_Bhaktapur	27.6749	85.30224
1242	S258	Bhaktapur_R1_Kalanki_Bhaktapur	27.67168	85.30423
1243	S336	Bhaktapur_R1_Kalanki_Bhaktapur	27.66662	85.30831
1244	S335	Bhaktapur_R1_Kalanki_Bhaktapur	27.6643	85.3144
1245	S334	Bhaktapur_R1_Kalanki_Bhaktapur	27.66254	85.3165
1246	S333	Bhaktapur_R1_Kalanki_Bhaktapur	27.65912	85.32077
1247	S332	Bhaktapur_R1_Kalanki_Bhaktapur	27.65785	85.32242
1248	S194	Bhaktapur_R1_Kalanki_Bhaktapur	27.65881	85.32463
1249	S60	Bhaktapur_R1_Kalanki_Bhaktapur	27.66039	85.32689
1250	S61	Bhaktapur_R1_Kalanki_Bhaktapur	27.66438	85.33028
1251	S58	Bhaktapur_R1_Kalanki_Bhaktapur	27.66646	85.33212
1252	S190	Bhaktapur_R1_Kalanki_Bhaktapur	27.67007	85.33823
1253	S189	Bhaktapur_R1_Kalanki_Bhaktapur	27.67146	85.34038
1254	S188	Bhaktapur_R1_Kalanki_Bhaktapur	27.67355	85.3426
1255	S187	Bhaktapur_R1_Kalanki_Bhaktapur	27.67537	85.34459
1256	S153	Bhaktapur_R1_Kalanki_Bhaktapur	27.67903	85.34972
1257	S154	Bhaktapur_R1_Kalanki_Bhaktapur	27.67549	85.35146
1258	S155	Bhaktapur_R1_Kalanki_Bhaktapur	27.67486	85.3598
1259	S156	Bhaktapur_R1_Kalanki_Bhaktapur	27.67455	85.36428
1260	S374	Bhaktapur_R1_Kalanki_Bhaktapur	27.67394	85.37234
1261	S373	Bhaktapur_R1_Kalanki_Bhaktapur	27.67342	85.37901
1262	S372	Bhaktapur_R1_Kalanki_Bhaktapur	27.67329	85.38168
1263	S371	Bhaktapur_R1_Kalanki_Bhaktapur	27.67331	85.38639
1264	S370	Bhaktapur_R1_Kalanki_Bhaktapur	27.67452	85.3976
1265	S369	Bhaktapur_R1_Kalanki_Bhaktapur	27.67129	85.40884
1266	S368	Bhaktapur_R1_Kalanki_Bhaktapur	27.66711	85.41699
1267	S367	Bhaktapur_R1_Kalanki_Bhaktapur	27.66543	85.42726
1268	S366	Bhaktapur_R1_Kalanki_Bhaktapur	27.66652	85.43641
1269	S365	Bhaktapur_R1_Kalanki_Bhaktapur	27.67345	85.4383
1270	S364	Bhaktapur_R1_Kalanki_Bhaktapur	27.67721	85.43697
1271	S364	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67721	85.43697
1272	S365	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67345	85.4383
1273	S366	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66652	85.43641
1274	S367	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66543	85.42726
1275	S368	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66711	85.41699
1276	S369	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67129	85.40884
1277	S370	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67452	85.3976
1278	S371	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67331	85.38639
1279	S372	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67329	85.38168
1280	S373	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67342	85.37901
1281	S374	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67394	85.37234
1282	S171	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67444	85.36428
1283	S172	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67467	85.35992
1284	S173	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67507	85.35415
1285	S186	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67817	85.34881
1286	S187	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67537	85.34459
1287	S188	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67355	85.3426
1288	S189	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67146	85.34038
1289	S190	Bhaktapur_R2_Bhaktapur_Lagankhel	27.67007	85.33823
1290	S191	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66796	85.3342
1291	S192	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66648	85.33215
1292	S193	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66011	85.32694
1293	S194	Bhaktapur_R2_Bhaktapur_Lagankhel	27.65881	85.32463
1294	S1	Bhaktapur_R2_Bhaktapur_Lagankhel	27.66699	85.32298
1295	S1	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66699	85.32298
1296	S194	Bhaktapur_R2_Lagankhel_Bhaktapur	27.65881	85.32463
1297	S60	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66039	85.32689
1298	S61	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66438	85.33028
1299	S58	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66646	85.33212
1300	S190	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67007	85.33823
1301	S189	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67146	85.34038
1302	S188	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67355	85.3426
1303	S187	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67537	85.34459
1304	S153	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67903	85.34972
1305	S154	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67549	85.35146
1306	S155	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67486	85.3598
1307	S156	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67455	85.36428
1308	S374	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67394	85.37234
1309	S373	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67342	85.37901
1310	S372	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67329	85.38168
1311	S371	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67331	85.38639
1312	S370	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67452	85.3976
1313	S369	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67129	85.40884
1314	S368	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66711	85.41699
1315	S367	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66543	85.42726
1316	S366	Bhaktapur_R2_Lagankhel_Bhaktapur	27.66652	85.43641
1317	S365	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67345	85.4383
1318	S364	Bhaktapur_R2_Lagankhel_Bhaktapur	27.67721	85.43697
1319	S364	Bhaktapur_R3_Bhaktapur_RNAC	27.67721	85.43697
1320	S365	Bhaktapur_R3_Bhaktapur_RNAC	27.67345	85.4383
1321	S366	Bhaktapur_R3_Bhaktapur_RNAC	27.66652	85.43641
1322	S367	Bhaktapur_R3_Bhaktapur_RNAC	27.66543	85.42726
1323	S368	Bhaktapur_R3_Bhaktapur_RNAC	27.66711	85.41699
1324	S369	Bhaktapur_R3_Bhaktapur_RNAC	27.67129	85.40884
1325	S370	Bhaktapur_R3_Bhaktapur_RNAC	27.67452	85.3976
1326	S371	Bhaktapur_R3_Bhaktapur_RNAC	27.67331	85.38639
1327	S372	Bhaktapur_R3_Bhaktapur_RNAC	27.67329	85.38168
1328	S373	Bhaktapur_R3_Bhaktapur_RNAC	27.67342	85.37901
1329	S374	Bhaktapur_R3_Bhaktapur_RNAC	27.67394	85.37234
1330	S171	Bhaktapur_R3_Bhaktapur_RNAC	27.67444	85.36428
1331	S172	Bhaktapur_R3_Bhaktapur_RNAC	27.67467	85.35992
1332	S173	Bhaktapur_R3_Bhaktapur_RNAC	27.67507	85.35415
1333	S195	Bhaktapur_R3_Bhaktapur_RNAC	27.6798	85.34946
1334	S87	Bhaktapur_R3_Bhaktapur_RNAC	27.68608	85.34551
1335	S86	Bhaktapur_R3_Bhaktapur_RNAC	27.68672	85.34266
1336	S92	Bhaktapur_R3_Bhaktapur_RNAC	27.68748	85.338
1337	S93	Bhaktapur_R3_Bhaktapur_RNAC	27.68831	85.33485
1338	S94	Bhaktapur_R3_Bhaktapur_RNAC	27.68912	85.33098
1339	S95	Bhaktapur_R3_Bhaktapur_RNAC	27.69048	85.3276
1340	S96	Bhaktapur_R3_Bhaktapur_RNAC	27.69225	85.32413
1341	S97	Bhaktapur_R3_Bhaktapur_RNAC	27.69375	85.32081
1342	S98	Bhaktapur_R3_Bhaktapur_RNAC	27.699	85.3171
1343	S23	Bhaktapur_R3_Bhaktapur_RNAC	27.69971	85.31398
1344	S8	Bhaktapur_R3_Bhaktapur_RNAC	27.70114	85.31345
1345	S8	Bhaktapur_R3_RNAC_Bhaktapur	27.70114	85.31345
1346	S78	Bhaktapur_R3_RNAC_Bhaktapur	27.70669	85.31485
1347	S22	Bhaktapur_R3_RNAC_Bhaktapur	27.70258	85.31647
1348	S79	Bhaktapur_R3_RNAC_Bhaktapur	27.698	85.32141
1349	S80	Bhaktapur_R3_RNAC_Bhaktapur	27.6965	85.32101
1350	S81	Bhaktapur_R3_RNAC_Bhaktapur	27.69365	85.32156
1351	S82	Bhaktapur_R3_RNAC_Bhaktapur	27.69227	85.32442
1352	S83	Bhaktapur_R3_RNAC_Bhaktapur	27.69066	85.32787
1353	S84	Bhaktapur_R3_RNAC_Bhaktapur	27.68845	85.33487
1354	S85	Bhaktapur_R3_RNAC_Bhaktapur	27.68763	85.33868
1355	S86	Bhaktapur_R3_RNAC_Bhaktapur	27.68672	85.34266
1356	S87	Bhaktapur_R3_RNAC_Bhaktapur	27.68608	85.34551
1357	S153	Bhaktapur_R3_RNAC_Bhaktapur	27.67903	85.34972
1358	S154	Bhaktapur_R3_RNAC_Bhaktapur	27.67549	85.35146
1359	S155	Bhaktapur_R3_RNAC_Bhaktapur	27.67486	85.3598
1360	S156	Bhaktapur_R3_RNAC_Bhaktapur	27.67455	85.36428
1361	S374	Bhaktapur_R3_RNAC_Bhaktapur	27.67394	85.37234
1362	S373	Bhaktapur_R3_RNAC_Bhaktapur	27.67342	85.37901
1363	S372	Bhaktapur_R3_RNAC_Bhaktapur	27.67329	85.38168
1364	S371	Bhaktapur_R3_RNAC_Bhaktapur	27.67331	85.38639
1365	S370	Bhaktapur_R3_RNAC_Bhaktapur	27.67452	85.3976
1366	S369	Bhaktapur_R3_RNAC_Bhaktapur	27.67129	85.40884
1367	S368	Bhaktapur_R3_RNAC_Bhaktapur	27.66711	85.41699
1368	S367	Bhaktapur_R3_RNAC_Bhaktapur	27.66543	85.42726
1369	S366	Bhaktapur_R3_RNAC_Bhaktapur	27.66652	85.43641
1370	S365	Bhaktapur_R3_RNAC_Bhaktapur	27.67345	85.4383
1371	S364	Bhaktapur_R3_RNAC_Bhaktapur	27.67721	85.43697
1372	S8	Micro_R1_RNAC_Kritipur	27.70114	85.31345
1373	S78	Micro_R1_RNAC_Kritipur	27.70669	85.31485
1374	S22	Micro_R1_RNAC_Kritipur	27.70258	85.31647
1375	S23	Micro_R1_RNAC_Kritipur	27.69971	85.31398
1376	S7	Micro_R1_RNAC_Kritipur	27.69328	85.3144
1377	S99	Micro_R1_RNAC_Kritipur	27.69633	85.30633
1378	S100	Micro_R1_RNAC_Kritipur	27.6982	85.30153
1379	S273	Micro_R1_RNAC_Kritipur	27.69565	85.29864
1380	S274	Micro_R1_RNAC_Kritipur	27.69148	85.29883
1381	S275	Micro_R1_RNAC_Kritipur	27.68816	85.29828
1382	S254	Micro_R1_RNAC_Kritipur	27.6849	85.29862
1383	S375	Micro_R1_RNAC_Kritipur	27.68438	85.29737
1384	S376	Micro_R1_RNAC_Kritipur	27.68264	85.29854
1385	S377	Micro_R1_RNAC_Kritipur	27.67879	85.2972
1386	S378	Micro_R1_RNAC_Kritipur	27.6791	85.2898
1387	S379	Micro_R1_RNAC_Kritipur	27.67844	85.28498
1388	S380	Micro_R1_RNAC_Kritipur	27.67706	85.28195
1389	S380	Micro_R1_Kritipur_RNAC	27.67706	85.28195
1390	S379	Micro_R1_Kritipur_RNAC	27.67844	85.28498
1391	S378	Micro_R1_Kritipur_RNAC	27.6791	85.2898
1392	S377	Micro_R1_Kritipur_RNAC	27.67879	85.2972
1393	S376	Micro_R1_Kritipur_RNAC	27.68264	85.29854
1394	S375	Micro_R1_Kritipur_RNAC	27.68438	85.29737
1395	S254	Micro_R1_Kritipur_RNAC	27.6849	85.29862
1396	S275	Micro_R1_Kritipur_RNAC	27.68816	85.29828
1397	S274	Micro_R1_Kritipur_RNAC	27.69148	85.29883
1398	S273	Micro_R1_Kritipur_RNAC	27.69565	85.29864
1399	S100	Micro_R1_Kritipur_RNAC	27.6982	85.30153
1400	S99	Micro_R1_Kritipur_RNAC	27.69633	85.30633
1401	S7	Micro_R1_Kritipur_RNAC	27.69328	85.3144
1402	S8	Micro_R1_Kritipur_RNAC	27.70114	85.31345
1403	S1	Local_R1_Lagankhel_Tikathali	27.66699	85.32298
1404	S194	Local_R1_Lagankhel_Tikathali	27.65881	85.32463
1405	S60	Local_R1_Lagankhel_Tikathali	27.66039	85.32689
1406	S61	Local_R1_Lagankhel_Tikathali	27.66438	85.33028
1407	S192	Local_R1_Lagankhel_Tikathali	27.66648	85.33215
1408	S250	Local_R1_Lagankhel_Tikathali	27.66647	85.33241
1409	S57	Local_R1_Lagankhel_Tikathali	27.66547	85.3352
1410	S56	Local_R1_Lagankhel_Tikathali	27.66313	85.33967
1411	S55	Local_R1_Lagankhel_Tikathali	27.66264	85.3405
1412	S54	Local_R1_Lagankhel_Tikathali	27.66167	85.34269
1413	S381	Local_R1_Lagankhel_Tikathali	27.66122	85.34696
1414	S382	Local_R1_Lagankhel_Tikathali	27.66134	85.34801
1415	S383	Local_R1_Lagankhel_Tikathali	27.66095	85.3505
1416	S384	Local_R1_Lagankhel_Tikathali	27.65934	85.3541
1417	S385	Local_R1_Lagankhel_Tikathali	27.65883	85.35689
1418	S386	Local_R1_Lagankhel_Tikathali	27.65899	85.35791
1419	S386	Local_R1_Tikathali_Lagankhel	27.65899	85.35791
1420	S385	Local_R1_Tikathali_Lagankhel	27.65883	85.35689
1421	S384	Local_R1_Tikathali_Lagankhel	27.65934	85.3541
1422	S383	Local_R1_Tikathali_Lagankhel	27.66095	85.3505
1423	S382	Local_R1_Tikathali_Lagankhel	27.66134	85.34801
1424	S381	Local_R1_Tikathali_Lagankhel	27.66122	85.34696
1425	S54	Local_R1_Tikathali_Lagankhel	27.66167	85.34269
1426	S55	Local_R1_Tikathali_Lagankhel	27.66264	85.3405
1427	S56	Local_R1_Tikathali_Lagankhel	27.66313	85.33967
1428	S57	Local_R1_Tikathali_Lagankhel	27.66547	85.3352
1429	S250	Local_R1_Tikathali_Lagankhel	27.66647	85.33241
1430	S192	Local_R1_Tikathali_Lagankhel	27.66648	85.33215
1431	S61	Local_R1_Tikathali_Lagankhel	27.66438	85.33028
1432	S60	Local_R1_Tikathali_Lagankhel	27.66039	85.32689
1433	S194	Local_R1_Tikathali_Lagankhel	27.65881	85.32463
1434	S1	Local_R1_Tikathali_Lagankhel	27.66699	85.32298
1435	S387	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73738	85.38683
1436	S388	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73095	85.38502
1437	S389	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7283	85.38449
1438	S390	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72184	85.38286
1439	S391	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72155	85.37922
1440	S392	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72184	85.37307
1441	S393	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7205	85.36076
1442	S394	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.71927	85.35106
1443	S344	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7171	85.34665
1444	S220	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.71316	85.34542
1445	S219	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.71034	85.34415
1446	S345	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.70777	85.34335
1447	S346	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7059	85.34805
1448	S347	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7062	85.35015
1449	S348	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.70062	85.35373
1450	S90	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.69523	85.35492
1451	S89	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.69131	85.35287
1452	S349	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68631	85.35009
1453	S153	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67903	85.34972
1454	S186	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67817	85.34881
1455	S187	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67537	85.34459
1456	S188	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67355	85.3426
1457	S189	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67146	85.34038
1458	S190	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67007	85.33823
1459	S191	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.66796	85.3342
1460	S192	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.66648	85.33215
1461	S193	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.66011	85.32694
1462	S194	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.65881	85.32463
1463	S332	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.65785	85.32242
1464	S333	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.65912	85.32077
1465	S334	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.66254	85.3165
1466	S335	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.6643	85.3144
1467	S336	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.66662	85.30831
1468	S337	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67207	85.30353
1469	S338	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.67512	85.30188
1470	S339	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68164	85.30217
1471	S340	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68426	85.30161
1472	S341	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68476	85.29716
1473	S342	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68565	85.29323
1474	S343	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.68931	85.28418
1475	S102	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.69537	85.28134
1476	S103	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.70208	85.28179
1477	S104	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.70758	85.28248
1478	S105	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.716	85.28353
1479	S106	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.71967	85.28693
1480	S107	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72136	85.29041
1481	S108	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72348	85.29453
1482	S109	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72476	85.2977
1483	S110	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7272	85.30483
1484	S111	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73519	85.30572
1485	S19	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73488	85.31463
1486	S18	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73561	85.32119
1487	S17	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.7381	85.32542
1488	S16	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.74149	85.33408
1489	S15	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73984	85.33726
1490	S305	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73506	85.3422
1491	S304	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.73155	85.34449
1492	S303	Gokarneshwor_R1_Gokarneshwor_Gopi_kishan	27.72167	85.34577
1493	S303	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72167	85.34577
1494	S304	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73155	85.34449
1495	S305	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73506	85.3422
1496	S15	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73984	85.33726
1497	S16	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.74149	85.33408
1498	S17	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7381	85.32542
1499	S18	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73561	85.32119
1500	S19	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73488	85.31463
1501	S111	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73519	85.30572
1502	S110	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7272	85.30483
1503	S109	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72476	85.2977
1504	S108	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72348	85.29453
1505	S107	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72136	85.29041
1506	S106	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71967	85.28693
1507	S105	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.716	85.28353
1508	S104	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.70758	85.28248
1509	S103	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.70208	85.28179
1510	S102	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.69537	85.28134
1511	S343	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.68931	85.28418
1512	S342	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.68565	85.29323
1513	S254	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.6849	85.29862
1514	S255	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.68441	85.30178
1515	S256	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.68126	85.30251
1516	S257	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.6749	85.30224
1517	S258	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.67168	85.30423
1518	S336	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.66662	85.30831
1519	S335	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.6643	85.3144
1520	S334	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.66254	85.3165
1521	S333	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.65912	85.32077
1522	S332	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.65785	85.32242
1523	S194	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.65881	85.32463
1524	S60	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.66039	85.32689
1525	S61	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.66438	85.33028
1526	S58	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.66646	85.33212
1527	S190	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.67007	85.33823
1528	S189	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.67146	85.34038
1529	S188	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.67355	85.3426
1530	S187	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.67537	85.34459
1531	S195	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.6798	85.34946
1532	S88	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.68636	85.34923
1533	S89	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.69131	85.35287
1534	S90	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.69523	85.35492
1535	S91	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.70059	85.35371
1536	S347	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7062	85.35015
1537	S346	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7059	85.34805
1538	S345	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.70777	85.34335
1539	S219	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71034	85.34415
1540	S220	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71316	85.34542
1541	S221	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71706	85.3465
1542	S222	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71818	85.34851
1543	S223	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.71989	85.35109
1544	S393	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7205	85.36076
1545	S392	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72184	85.37307
1546	S391	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72155	85.37922
1547	S390	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.72184	85.38286
1548	S389	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.7283	85.38449
1549	S388	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73095	85.38502
1550	S387	Gokarneshwor_R1r_Gopi_kishan_Gokarneshwor	27.73738	85.38683
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: stops; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stops (id, name, latitude, longitude, geom) FROM stdin;
S1	Lagankhel	27.66699	85.32298	0101000020E6100000C6504EB4AB54554050C24CDBBFAA3B40
S2	Kumaripati	27.67055	85.32046	0101000020E610000046EBA86A825455403255302AA9AB3B40
S3	Jawalakhel	27.67253	85.31402	0101000020E61000008E9257E718545540319413ED2AAC3B40
S4	Pulchowk	27.67617	85.31576	0101000020E6100000A3586E69355455404C89247A19AD3B40
S5	Harihar Bhawan	27.68077	85.31733	0101000020E61000008A027D224F545540111956F146AE3B40
S6	Kupandol	27.68795	85.31618	0101000020E61000008EE9094B3C5455408048BF7D1DB03B40
S7	Tripureshwor	27.69328	85.3144	0101000020E610000032772D211F5455408CF84ECC7AB13B40
S8	RNAC	27.70114	85.31345	0101000020E610000099BB96900F545540DDEA39E97DB33B40
S9	Lainchaur	27.71723	85.31616	0101000020E61000006A1327F73B545540C8B5A1629CB73B40
S10	Lazimpat	27.72174	85.32027	0101000020E6100000F4F8BD4D7F5455400D37E0F3C3B83B40
S11	Panipokhari	27.72864	85.32493	0101000020E610000050DF32A7CB545540B48EAA2688BA3B40
S12	President's Residence	27.7331	85.32892	0101000020E610000005C078060D55554096B20C71ACBB3B40
S13	Teaching Hospital	27.73504	85.33136	0101000020E6100000F7CC9200355555407940D9942BBC3B40
S14	US Embassy	27.73851	85.33567	0101000020E6100000E40F069E7B555540DBC4C9FD0EBD3B40
S15	Narayan Gopal Chowk	27.73984	85.33726	0101000020E6100000EF8FF7AA95555540CC457C2766BD3B40
S16	Chiray Hospital	27.74149	85.33408	0101000020E6100000DA8F149161555540A04FE449D2BD3B40
S17	Basundhara	27.7381	85.32542	0101000020E6100000B75D68AED3545540772D211FF4BC3B40
S18	Samakhusi	27.73561	85.32119	0101000020E6100000587380608E5455404E9CDCEF50BC3B40
S19	Gongabu	27.73488	85.31463	0101000020E6100000CA15DEE522545540077C7E1821BC3B40
S20	Gongabu Bus Park	27.7348	85.3097	0101000020E61000008FE4F21FD2535540CE1951DA1BBC3B40
S21	Jamal	27.70883	85.31539	0101000020E610000011DF89592F545540766C04E275B53B40
S22	Bhirkutimandap	27.70258	85.31647	0101000020E6100000910A630B41545540DDD26A48DCB33B40
S23	Sahid Gate	27.69971	85.31398	0101000020E610000047E6913F1854554025AFCE3120B33B40
S24	Bansbari	27.74306	85.34003	0101000020E61000002B6A300DC35555403CF71E2E39BE3B40
S25	Gangalal Hospital	27.74521	85.34188	0101000020E610000004CAA65CE1555540F4A62215C6BE3B40
S26	Neuro Hospital	27.74842	85.34529	0101000020E6100000B2683A3B195655401DACFF7398BF3B40
S27	Golfutar	27.75142	85.346	0101000020E6100000A01A2FDD24565540718FA50F5DC03B40
S28	Hattigauda	27.75702	85.34944	0101000020E610000083FA96395D565540FD6A0E10CCC13B40
S29	Ganesh Chowk	27.76082	85.352	0101000020E61000004A0C022B8756554089247A19C5C23B40
S30	Chapali Ghumti	27.767	85.35474	0101000020E610000051A5660FB45655403108AC1C5AC43B40
S31	Rudreshwor Chowk	27.77143	85.3588	0101000020E610000082734694F65655403D27BD6F7CC53B40
S32	Deuba Chowk	27.77484	85.36115	0101000020E6100000D3BCE3141D575540F5A10BEA5BC63B40
S33	Budhanilkantha	27.77842	85.36012	0101000020E6100000ACA8C1340C575540658D7A8846C73B40
S34	Godawari	27.59458	85.37778	0101000020E61000004E452A8C2D5855400EDB166536983B40
S35	Taukhel	27.61135	85.3575	0101000020E61000007B14AE47E1565540DC68006F819C3B40
S36	Thaiba	27.62345	85.3495	0101000020E6100000EE7C3F355E565540F2B0506B9A9F3B40
S37	Harisiddhi	27.63736	85.34171	0101000020E6100000D6AD9E93DE55554050C763062AA33B40
S38	Hattiban	27.64794	85.33571	0101000020E61000002CBCCB457C5555402EC55565DFA53B40
S39	Dhapakhel Dobato	27.65689	85.32636	0101000020E61000003EAE0D15E3545540C7116BF129A83B40
S40	Satdobato	27.65885	85.32462	0101000020E610000029E8F692C654554038F8C264AAA83B40
S41	Dungin	27.62793	85.39526	0101000020E6100000AF5A99F04B595540622D3E05C0A03B40
S42	Lamatar	27.6328	85.39076	0101000020E610000070253B3602595540A7E8482EFFA13B40
S43	Mahalaxmi Campus	27.64166	85.37916	0101000020E6100000E3FC4D2844585540C0266BD443A43B40
S44	Lubhu	27.64282	85.37333	0101000020E6100000672783A3E4575540F836FDD98FA43B40
S45	Kwo Lachhi	27.64371	85.37223	0101000020E6100000C425C79DD2575540B01BB62DCAA43B40
S46	Narkate Chowk	27.64734	85.36665	0101000020E610000005C58F317757554084640113B8A53B40
S47	Sanagaun	27.64979	85.35901	0101000020E6100000F73B1405FA56554091442FA358A63B40
S48	Bhatbhateni Siddshipur	27.65082	85.35568	0101000020E6100000D8F50B76C35655402D95B7239CA63B40
S49	Goalbhata	27.6532	85.35244	0101000020E6100000587380608E56554048BF7D1D38A73B40
S50	Imadol Tempo Park	27.65491	85.34978	0101000020E6100000DF32A7CB62565540C8D2872EA8A73B40
S51	Imadol Kamalpokhari	27.65649	85.34863	0101000020E6100000E31934F44F565540AB2688BA0FA83B40
S52	Mahalaxmi Municipality	27.65738	85.3478	0101000020E61000002063EE5A42565540630B410E4AA83B40
S53	Imadol Kharibot	27.65933	85.34435	0101000020E61000002B1895D4095655408D45D3D9C9A83B40
S54	Imadol Krishna Mandir	27.66167	85.34269	0101000020E6100000A4AA09A2EE5555408CBE823463A93B40
S55	Imadol Pipalbot	27.66264	85.3405	0101000020E61000006F1283C0CA5555407D0569C6A2A93B40
S56	Rata Makai Chowk	27.66313	85.33967	0101000020E6100000AB5B3D27BD55554019FF3EE3C2A93B40
S57	Kist Hospital	27.66547	85.3352	0101000020E6100000A167B3EA735555401878EE3D5CAA3B40
S58	Gwarko	27.66646	85.33212	0101000020E61000003E963E74415555409817601F9DAA3B40
S59	Satdobato Swimming Pool	27.66246	85.32892	0101000020E610000005C078060D5555407DE882FA96A93B40
S60	Satdobato Swimming Pool	27.66039	85.32689	0101000020E6100000EDD808C4EB545540FE9AAC510FA93B40
S61	B & B Hospital	27.66438	85.33028	0101000020E610000077A1B94E23555540D21DC4CE14AA3B40
S62	Thankot	27.69939	85.20908	0101000020E6100000DA8F1491614D5540422619390BB33B40
S63	Thankot (Kharibot)	27.69352	85.21953	0101000020E61000006B9F8EC70C4E5540361FD7868AB13B40
S64	Thankot  Bus Stop	27.69026	85.22193	0101000020E61000001500E319344E5540A9BC1DE1B4B03B40
S65	Thankot Checkpost	27.68901	85.22721	0101000020E6100000BFD4CF9B8A4E5540F19D98F562B03B40
S66	Gurjudhara	27.68773	85.24209	0101000020E6100000132C0E677E4F5540637AC2120FB03B40
S67	Satungal	27.68689	85.25124	0101000020E61000009CDCEF50145055400EF3E505D8AF3B40
S68	Balkhu Pul	27.6862	85.25999	0101000020E61000005FD218ADA3505540E4839ECDAAAF3B40
S69	Naikap	27.6871	85.26483	0101000020E6100000FB3F87F9F2505540E4141DC9E5AF3B40
S70	Tinthana	27.68802	85.26993	0101000020E6100000658D7A884651554072FE261422B03B40
S71	Dhungeaddha	27.69132	85.2756	0101000020E6100000C4B12E6EA35155401B12F758FAB03B40
S72	Kalanki	27.69337	85.28189	0101000020E610000072C45A7C0A5255400C0742B280B13B40
S73	Kalanki Mandhir	27.6942	85.28504	0101000020E6100000518369183E52554019E25817B7B13B40
S74	Ravi Bhawan	27.69564	85.29099	0101000020E6100000A25D85949F52554019CA897615B23B40
S75	Soltimod	27.69685	85.29429	0101000020E61000008D62B9A5D5525540B537F8C264B23B40
S76	Kalimati	27.69846	85.29955	0101000020E61000001361C3D32B5355406D904946CEB23B40
S77	Teku	27.69785	85.30314	0101000020E6100000018750A5665355407B832F4CA6B23B40
S78	Ratnapark	27.70669	85.31485	0101000020E610000052499D80265455400569C6A2E9B43B40
S79	Singha Durbar	27.698	85.32141	0101000020E6100000DFA63FFB91545540A69BC420B0B23B40
S80	Suprime Court	27.6965	85.32101	0101000020E610000018EC866D8B545540FCA9F1D24DB23B40
S81	Maitighar	27.69365	85.32156	0101000020E6100000EAEC647094545540D3DEE00B93B13B40
S82	Babarmahal	27.69227	85.32442	0101000020E6100000C68A1A4CC35455407E00529B38B13B40
S83	Bijuli Bazar	27.69066	85.32787	0101000020E6100000BBD573D2FB545540C6A70018CFB03B40
S84	New Baneshwor	27.68845	85.33487	0101000020E6100000569A94826E55554063EE5A423EB03B40
S85	Min Bhawan	27.68763	85.33868	0101000020E6100000CBF3E0EEAC5555409CBF098508B03B40
S86	Shantinagar	27.68672	85.34266	0101000020E61000006E693524EE5555405682C5E1CCAF3B40
S87	Subhidanagar	27.68608	85.34551	0101000020E6100000399CF9D51C5655408F705AF0A2AF3B40
S88	Tinkune	27.68636	85.34923	0101000020E61000000E32C9C8595655405648F949B5AF3B40
S89	Sinamangal Oralo	27.69131	85.35287	0101000020E6100000546F0D6C95565540D46531B1F9B03B40
S90	Sinamangal	27.69523	85.35492	0101000020E6100000912C6002B7565540B532E197FAB13B40
S91	Tribhuvan International Airport	27.70059	85.35371	0101000020E61000002A91442FA356554096E7C1DD59B33B40
S92	Civil Hospital	27.68748	85.338	0101000020E61000001283C0CAA155554072A774B0FEAF3B40
S93	New Baneshwor	27.68831	85.33485	0101000020E610000033C4B12E6E55554080828B1535B03B40
S94	Alfa Beta	27.68912	85.33098	0101000020E610000053E8BCC62E555540FF04172B6AB03B40
S95	Bijuli Bazar	27.69048	85.3276	0101000020E6100000DB8AFD65F7545540C68A1A4CC3B03B40
S96	Babarmahal	27.69225	85.32413	0101000020E6100000C269C18BBE545540F0A7C64B37B13B40
S97	Maitighar	27.69375	85.32081	0101000020E6100000B48EAA26885455409A99999999B13B40
S98	Bhadrakali	27.699	85.3171	0101000020E6100000F163CC5D4B5455406DE7FBA9F1B23B40
S99	Teku	27.69633	85.30633	0101000020E610000028F224E99A5355404339D1AE42B23B40
S100	Kalimati	27.6982	85.30153	0101000020E6100000D3307C444C5355403411363CBDB23B40
S101	Nagdhunga	27.70639	85.20567	0101000020E61000002CF180B2294D5540B0389CF9D5B43B40
S102	Kalanki Makalu Stop	27.69537	85.28134	0101000020E6100000A0C37C7901525540999EB0C403B23B40
S103	Bafal	27.70208	85.28179	0101000020E6100000C095ECD808525540F92CCF83BBB33B40
S104	Sitapaila	27.70758	85.28248	0101000020E61000008B71FE2614525540BE4D7FF623B53B40
S105	Swayambhu	27.716	85.28353	0101000020E6100000D55B035B255255409EEFA7C64BB73B40
S106	Thulo Bhrayang	27.71967	85.28693	0101000020E6100000718FA50F5D5255408EE9094B3CB83B40
S107	Sano Bharyang	27.72136	85.29041	0101000020E61000009B1BD313965255407FA4880CABB83B40
S108	Dhungedhara	27.72348	85.29453	0101000020E6100000376C5B94D9525540614F3BFC35B93B40
S109	Banashthali	27.72476	85.2977	0101000020E61000003B014D840D535540EF7211DF89B93B40
S110	Balaju	27.7272	85.30483	0101000020E6100000BD35B05582535540B5A679C729BA3B40
S111	Machha Pokhari	27.73519	85.30572	0101000020E6100000EB6E9EEA90535540A3586E6935BC3B40
S112	Lele Bus Park	27.56829	85.3408	0101000020E6100000849ECDAACF555540D3A414747B913B40
S113	Champeshwori Mandhir	27.57223	85.33512	0101000020E6100000130F289B7255554043CA4FAA7D923B40
S114	Tikabhairav	27.57592	85.31367	0101000020E610000020EF552B13545540C11C3D7E6F933B40
S115	Tahakhel	27.58817	85.32204	0101000020E61000003F00A94D9C545540037D224F92963B40
S116	Pyangaun	27.59745	85.32381	0101000020E61000008907944DB9545540C5FEB27BF2983B40
S117	Chapagaun	27.60389	85.32398	0101000020E6100000B8239C16BC545540A661F888989A3B40
S118	Thecho	27.61567	85.31922	0101000020E6100000AA0EB9196E545540DA20938C9C9D3B40
S119	Ntc Thecho	27.62347	85.31911	0101000020E6100000E674594C6C5455408109DCBA9B9F3B40
S120	Sunakothi	27.63305	85.31802	0101000020E610000055DE8E705A54554099BB96900FA23B40
S121	Dholahiti	27.64026	85.31844	0101000020E61000003F6F2A5261545540DDEF5014E8A33B40
S122	Khumaltar	27.64938	85.32055	0101000020E6100000E6AE25E4835455402EAD86C43DA63B40
S123	Chapagaun Dobato	27.65772	85.32237	0101000020E61000008ACDC7B5A1545540D5EC815660A83B40
S124	Bungamati	27.6285	85.304	0101000020E6100000FA7E6ABC7453554037894160E5A03B40
S125	Chyasikot	27.63921	85.30507	0101000020E6100000683F524486535540B2463D44A3A33B40
S126	Kalika	27.64221	85.30466	0101000020E61000008F19A88C7F535540062AE3DF67A43B40
S127	Mahila Ghar	27.64617	85.3049	0101000020E61000003A234A7B8353554005A8A9656BA53B40
S128	Sanibu	27.6491	85.30528	0101000020E6100000DD0720B58953554067D5E76A2BA63B40
S129	Bhaisepati	27.6521	85.30519	0101000020E61000003D44A33B88535540BBB88D06F0A63B40
S130	Charghari	27.65616	85.30593	0101000020E610000061376C5B9453554080F10C1AFAA73B40
S131	Phurbari Marg	27.65963	85.3064	0101000020E6100000A4DFBE0E9C535540E275FD82DDA83B40
S132	Nakkhu	27.66156	85.30581	0101000020E61000008B321B64925355407E5704FF5BA93B40
S133	Vaishnavi Temple	27.66535	85.30607	0101000020E61000005A12A0A696535540C364AA6054AA3B40
S134	Ekantakuna	27.66667	85.30757	0101000020E6100000C4CE143AAF5355406D3997E2AAAA3B40
S135	Ekantakuna	27.66686	85.30837	0101000020E610000052448655BC535540B4024356B7AA3B40
S136	Jawalakhel Chowk	27.67262	85.31323	0101000020E61000001288D7F50B545540B1A206D330AC3B40
S137	Mahalakxmisthan	27.66164	85.31856	0101000020E610000015747B4963545540B6B9313D61A93B40
S138	Mahalakxmisthan	27.66144	85.31781	0101000020E6100000DF15C1FF565455402844C02154A93B40
S139	Thasikhel	27.66252	85.31634	0101000020E6100000AA9A20EA3E54554028F224E99AA93B40
S140	Kusunti	27.65997	85.31429	0101000020E61000006EDDCD531D54554054573ECBF3A83B40
S141	Ranibu	27.65828	85.31289	0101000020E6100000B54FC76306545540639CBF0985A83B40
S142	Thapathali	27.69301	85.31857	0101000020E610000026DF6C73635455400CCD751A69B13B40
S143	Swayambhu	27.71601	85.28354	0101000020E6100000E7C6F48425525540E59B6D6E4CB73B40
S144	Sitapaila	27.70744	85.28249	0101000020E61000009CDCEF5014525540DAE1AFC91AB53B40
S145	Narayani Petrol Pump	27.70023	85.28177	0101000020E61000009CBF09850852554097ADF54542B33B40
S146	Syuchatar	27.699	85.28147	0101000020E61000008733BF9A035255406DE7FBA9F1B23B40
S147	Kalanki	27.69344	85.28222	0101000020E6100000BC9179E40F525540FDBCA94885B13B40
S148	Kalanki Mandir	27.69421	85.28497	0101000020E6100000D595CFF23C525540618E1EBFB7B13B40
S149	Soltimod	27.69661	85.29354	0101000020E61000005704FF5BC95255400A11700855B23B40
S150	Kalimati	27.69838	85.29908	0101000020E6100000D0B8702024535540342E1C08C9B23B40
S151	Teku	27.69682	85.30529	0101000020E6100000EF7211DF89535540DF32A7CB62B23B40
S152	Tripureshwor	27.69344	85.31456	0101000020E61000004E2844C021545540FDBCA94885B13B40
S153	Koteshwor	27.67903	85.34972	0101000020E610000075B0FECF61565540BD00FBE8D4AD3B40
S154	Jadibuti	27.67549	85.35146	0101000020E61000008A7615527E56554069C6A2E9ECAC3B40
S155	Lokanthali	27.67486	85.3598	0101000020E6100000744694F606575540E960FD9FC3AC3B40
S156	Kausaltar	27.67455	85.36428	0101000020E61000008FA50F5D505755404D840D4FAFAC3B40
S157	Red Cross Chowk	27.66928	85.3657	0101000020E61000006C09F9A067575540ECDD1FEF55AB3B40
S158	Balkot	27.66677	85.366	0101000020E61000008195438B6C57554034F44F70B1AA3B40
S159	Balkot Chowk	27.66501	85.3666	0101000020E6100000ACADD85F76575540518369183EAA3B40
S160	Bagmati Yatayat	27.66202	85.36968	0101000020E61000000F7F4DD6A8575540444C89247AA93B40
S161	Balkot	27.66107	85.36974	0101000020E61000007901F6D1A9575540E15D2EE23BA93B40
S162	Ikudol	27.65985	85.37032	0101000020E61000008143A852B3575540FE43FAEDEBA83B40
S163	Milan Chowk	27.65472	85.37559	0101000020E610000019ADA3AA095855408109DCBA9BA73B40
S164	Sirutar	27.65393	85.37742	0101000020E6100000CE3637A6275855408FDFDBF467A73B40
S165	Chardobato Bus Stop	27.65041	85.38283	0101000020E61000005F7B664980585540CAFD0E4581A63B40
S166	Dhalekopipal Bot	27.64877	85.3859	0101000020E6100000B1E1E995B25855403CA06CCA15A63B40
S167	Mishra Stop	27.64827	85.38691	0101000020E6100000B41F2922C358554059FAD005F5A53B40
S168	Anantalingeshwor	27.64726	85.38907	0101000020E6100000B476DB85E65855404B02D4D4B2A53B40
S169	Biruwa Bus Stop	27.64092	85.39122	0101000020E6100000A2629CBF09595540325A475513A43B40
S170	Biruwa 	27.63741	85.39338	0101000020E6100000A1B94E232D595540B324404D2DA33B40
S171	Kausaltar	27.67444	85.36428	0101000020E61000008FA50F5D505755403F1D8F19A8AC3B40
S172	Lokanthali	27.67467	85.35992	0101000020E6100000494BE5ED08575540A297512CB7AC3B40
S173	Jadibuti	27.67507	85.35415	0101000020E610000038F8C264AA565540BF823463D1AC3B40
S174	Koteshwor	27.67986	85.34938	0101000020E61000001878EE3D5C565540CBDB114E0BAE3B40
S175	Tinkune	27.68597	85.34548	0101000020E6100000035B25581C5655408109DCBA9BAF3B40
S176	Shantinagar	27.68667	85.34166	0101000020E61000007D96E7C1DD555540F224E99AC9AF3B40
S177	Thapathali	27.69396	85.31934	0101000020E61000007F130A11705455406FBBD05CA7B13B40
S178	Tripureshwor	27.69387	85.31321	0101000020E6100000EEB1F4A10B545540EFACDD76A1B13B40
S179	Soltimod	27.69654	85.29358	0101000020E61000009FB0C403CA525540185B087250B23B40
S180	Kalanki Mandir	27.69416	85.28514	0101000020E610000003B2D7BB3F525540FD304278B4B13B40
S181	Kalanki	27.69337	85.28231	0101000020E61000005C55F65D115255400C0742B280B13B40
S182	Syuchatar	27.69902	85.28146	0101000020E610000075C8CD7003525540FB3F87F9F2B23B40
S183	Solteedobato Chowk	27.7045	85.28196	0101000020E6100000EEB1F4A10B5255403108AC1C5AB43B40
S184	Sitapaila	27.70749	85.28247	0101000020E610000079060DFD135255403E3F8C101EB53B40
S185	Swayambhu	27.716	85.28345	0101000020E61000004703780B245255409EEFA7C64BB73B40
S186	Koteshwor 	27.67817	85.34881	0101000020E610000023A12DE752565540DA20938C9CAD3B40
S187	Koteshwor Bhatbhateni	27.67537	85.34459	0101000020E6100000D52137C30D56554014B35E0CE5AC3B40
S188	Balkumari Pool	27.67355	85.3426	0101000020E610000004E78C28ED5555408638D6C56DAC3B40
S189	Balkumari	27.67146	85.34038	0101000020E6100000990D32C9C8555540799274CDE4AB3B40
S190	Balkumari Kharibot	27.67007	85.33823	0101000020E6100000AB21718FA5555540DD0720B589AB3B40
S191	Royal Tulip Hotel	27.66796	85.3342	0101000020E6100000AF946588635555404209336DFFAA3B40
S192	Gwarko	27.66648	85.33215	0101000020E610000073D712F2415555402670EB6E9EAA3B40
S193	Satdobato Swimming Pool	27.66011	85.32694	0101000020E610000045F0BF95EC54554037C30DF8FCA83B40
S194	Sadobato 	27.65881	85.32463	0101000020E61000003B53E8BCC65455401B47ACC5A7A83B40
S195	Koteshwor	27.6798	85.34946	0101000020E6100000A6D0798D5D56554020D26F5F07AE3B40
S196	Subhidanagar	27.68576	85.34609	0101000020E610000040DEAB5626565540ABE7A4F78DAF3B40
S197	Bir Hospital	27.7057	85.31403	0101000020E6100000A0FD48111954554086C954C1A8B43B40
S198	Kamaladi	27.70798	85.31854	0101000020E6100000F19D98F562545540DA38622D3EB53B40
S199	Putalisadak Tempo Stand	27.70801	85.32181	0101000020E6100000A661F88898545540B03DB32440B53B40
S200	Krishna Pauroti	27.71035	85.32234	0101000020E6100000548CF337A1545540AEB6627FD9B53B40
S201	Kamalpokhari	27.71006	85.32565	0101000020E610000050FC1873D7545540A032FE7DC6B53B40
S202	Charkhal	27.70955	85.32793	0101000020E610000025581CCEFC54554076E09C11A5B53B40
S203	Ganeshwor Marg	27.70844	85.33234	0101000020E6100000C5C9FD0E45555540A12DE7525CB53B40
S204	Maitidevi Temple	27.70607	85.33377	0101000020E6100000B398D87C5C555540CDAFE600C1B43B40
S205	Maitidevi Chwok	27.70393	85.33267	0101000020E61000000F971C774A5555405CACA8C134B43B40
S206	Seto Pul	27.70305	85.33557	0101000020E610000033E197FA79555540EB73B515FBB33B40
S207	Old Baneshwor	27.70154	85.33992	0101000020E610000068D0D03FC1555540FAD51C2098B33B40
S208	Bhimsencola	27.69927	85.34582	0101000020E6100000609335EA21565540EC12D55B03B33B40
S209	Tara Hall Chowk	27.69716	85.35053	0101000020E6100000159161156F5655405114E81379B23B40
S210	Sinamangal Kmc	27.69566	85.35317	0101000020E61000006AFB57569A565540A72215C616B23B40
S211	Dili Bazar Pipal Bot	27.70503	85.32852	0101000020E61000003E05C07806555540EAB298D87CB43B40
S212	Dili Bazar	27.70559	85.32367	0101000020E6100000912C6002B75455407862D68BA1B43B40
S213	Sankar Dev Campus	27.70315	85.32242	0101000020E6100000E2E47E87A2545540B22E6EA301B43B40
S214	Kathmandu Fun Park	27.70186	85.32013	0101000020E6100000FC1D8A027D545540DD5ED218ADB33B40
S215	Tudikhel	27.70223	85.31682	0101000020E610000000AE64C74654554024456458C5B33B40
S216	Battisputali	27.7017	85.34031	0101000020E61000001D2098A3C75555406B9A779CA2B33B40
S217	Dwarika Hotel	27.70499	85.34195	0101000020E610000080B74082E2555540CD0182397AB43B40
S218	Gaushala	27.70755	85.34316	0101000020E6100000E7525C55F6555540E9482EFF21B53B40
S219	Jay Bageshwori	27.71034	85.34415	0101000020E6100000C7BAB88D06565540670A9DD7D8B53B40
S220	Mitrapark	27.71316	85.34542	0101000020E610000099D87C5C1B565540BBD05CA791B63B40
S221	Chabahil	27.71706	85.3465	0101000020E61000001904560E2D5655400F45813E91B73B40
S222	Maiju Bahal Chabahil	27.71818	85.34851	0101000020E61000000E15E3FC4D5655402BA4FCA4DAB73B40
S223	Chuchhepati	27.71989	85.35109	0101000020E6100000F8FC304278565540AAB706B64AB83B40
S224	Mahankal	27.72427	85.35682	0101000020E6100000C2A38D23D656554053793BC269B93B40
S225	Ramsterdam Cafe Mahankal	27.72624	85.36363	0101000020E61000000C76C3B6455755400B0C59DDEAB93B40
S226	Tinchuli Chowk	27.72702	85.36856	0101000020E610000048A7AE7C96575540B58993FB1DBA3B40
S227	Chabahil	27.71754	85.34653	0101000020E61000004E452A8C2D565540649291B3B0B73B40
S228	Kapan Tempro Stand	27.74464	85.35993	0101000020E61000005BB6D617095755401F4B1FBAA0BE3B40
S229	Kapan Krishna Mandir	27.74045	85.3638	0101000020E61000003A92CB7F48575540BD5296218EBD3B40
S230	Dhaulagiri Chowk	27.73825	85.36222	0101000020E6100000417DCB9C2E575540A245B6F3FDBC3B40
S231	Kharibot Chowk Kapon	27.73533	85.36424	0101000020E610000048F949B54F57554087C43D963EBC3B40
S232	Fikal Chowk Kapon	27.73207	85.36233	0101000020E610000005172B6A30575540FA6184F068BB3B40
S233	Tenzing Chowk Kapon	27.72859	85.35909	0101000020E610000085949F54FB5655405131CEDF84BA3B40
S234	Bhrikuti Chowk Kapon	27.72733	85.35693	0101000020E6100000863DEDF0D75655405166834C32BA3B40
S235	Saraswati Marg Kapon	27.72442	85.35221	0101000020E6100000BFD4CF9B8A5655407D91D09673B93B40
S236	Chabahil Tempo Stand	27.72193	85.34629	0101000020E6100000A33B889D2956554054008C67D0B83B40
S237	Old Baneshwor (Global College)	27.70033	85.33908	0101000020E610000092AE997CB35555405E68AED348B33B40
S238	Venus Hospital	27.69711	85.33777	0101000020E61000007AE40F069E555540EDB60BCD75B23B40
S239	Eyeplex Mall	27.6927	85.33635	0101000020E61000009D8026C2865555406FF085C954B13B40
S240	New Baneshwor (Panitanki)	27.6903	85.33595	0101000020E6100000D6C56D3480555540C66D3480B7B03B40
S241	New Baneshwor (Sankhamul Side)	27.68791	85.33542	0101000020E6100000289B7285775555406397A8DE1AB03B40
S242	Kirti Marg	27.68561	85.33509	0101000020E6100000DDCD531D7255554081CF0F2384AF3B40
S243	Godhuli Marg	27.68453	85.33371	0101000020E6100000481630815B5555408121AB5B3DAF3B40
S244	Sandar Chowk	27.68344	85.33333	0101000020E6100000A5315A47555555403BC780ECF5AE3B40
S245	Sankhamul	27.68113	85.33158	0101000020E61000007E00529B38555540115322895EAE3B40
S246	Labim Mall	27.67687	85.31683	0101000020E6100000111956F146545540BEA4315A47AD3B40
S247	Pimbahal	27.67434	85.32076	0101000020E61000005C77F354875455407862D68BA1AC3B40
S248	Patan Durbar Square	27.67331	85.32405	0101000020E61000003411363CBD545540DC114E0B5EAC3B40
S249	Tyagal	27.66842	85.33009	0101000020E610000025AFCE312055554009FEB7921DAB3B40
S250	Gwarko Chowk	27.66647	85.33241	0101000020E610000041B7973446555540DFC325C79DAA3B40
S251	Cozy Home Gate Imadol	27.65331	85.34901	0101000020E610000087FE092E565655405726FC523FA73B40
S252	Shital Height Pharmacy (Imadol)	27.65063	85.34834	0101000020E6100000DFF8DA334B565540E6CB0BB08FA63B40
S253	Shital Height 	27.64826	85.34765	0101000020E6100000151DC9E53F565540124E0B5EF4A53B40
S254	Balkhu	27.6849	85.29862	0101000020E61000009E7B0F971C535540C8073D9B55AF3B40
S255	Sanepa	27.68441	85.30178	0101000020E61000008FA50F5D505355402C0E677E35AF3B40
S256	Star Hospital	27.68126	85.30251	0101000020E6100000A12DE7525C535540AE122C0E67AE3B40
S257	Dhobigat	27.6749	85.30224	0101000020E6100000C1E270E6575355400612143FC6AC3B40
S258	Nakhu	27.67168	85.30423	0101000020E6100000931D1B817853554095607138F3AB3B40
S259	Ekantakuna	27.66692	85.30817	0101000020E6100000EFE6A90EB95355405F0CE544BBAA3B40
S260	Jawalakhel 	27.66977	85.31049	0101000020E61000000BEF7211DF53554088D7F50B76AB3B40
S261	Jawalakhel Chowk	27.67261	85.31323	0101000020E61000001288D7F50B5455406AF6402B30AC3B40
S262	Pulchowk	27.67616	85.31569	0101000020E6100000276BD4433454554005DD5ED218AD3B40
S263	Chhapro	27.68461	85.35671	0101000020E6100000FF092E56D4565540BA83D89942AF3B40
S264	Pepsicola	27.68892	85.36016	0101000020E6100000F35487DC0C575540718FA50F5DB03B40
S265	Sai Ram Chowk	27.69026	85.36395	0101000020E610000045D8F0F44A575540A9BC1DE1B4B03B40
S266	Sunrise Chowk	27.69311	85.36775	0101000020E6100000A8C64B3789575540D3872EA86FB13B40
S267	Suncity	27.69419	85.3712	0101000020E61000009D11A5BDC1575540D235936FB6B13B40
S268	Laure Chowk	27.69606	85.37662	0101000020E610000040C1C58A1A585540C30DF8FC30B23B40
S269	Har Har Mahadev Temple	27.7009	85.3851	0101000020E6100000226C787AA558554033C4B12E6EB33B40
S270	Harhar Mahadev (Nepal Yatayat Bus Park)	27.7049	85.39156	0101000020E6100000FE9AAC510F5955404DF38E5374B43B40
S271	Pepsicola	27.68886	85.36026	0101000020E6100000A583F57F0E575540C685032159B03B40
S272	Jadibuti	27.67646	85.35287	0101000020E6100000546F0D6C955655405A0D897B2CAD3B40
S273	Global Ime Kuleshwor	27.69565	85.29864	0101000020E6100000C251F2EA1C53554060764F1E16B23B40
S274	Nabil Kuleshowr	27.69148	85.29883	0101000020E61000001344DD07205355408CD651D504B13B40
S275	Kitab Kalam Kuleshwor	27.68816	85.29828	0101000020E61000004243FF0417535540556AF6402BB03B40
S276	Mulpani Nepal Yatayat	27.71435	85.39649	0101000020E61000003ACC971760595540C9E53FA4DFB63B40
S277	Milan Chowk	27.71579	85.39822	0101000020E61000003D27BD6F7C595540C8CD70033EB73B40
S278	Baba Chowk	27.71249	85.39274	0101000020E610000030F5F3A6225955401FBAA0BE65B63B40
S279	Gaurinath Chowk	27.70761	85.38309	0101000020E61000002D5BEB8B845855409352D0ED25B53B40
S280	Godhargaun	27.70684	85.37727	0101000020E6100000C3F011312558554030815B77F3B43B40
S281	Mahantar	27.70597	85.37075	0101000020E61000007D3F355EBA57554006F52D73BAB43B40
S282	Dotel Dairy	27.70193	85.36893	0101000020E6100000DA20938C9C575540CF143AAFB1B33B40
S283	Hatti Dada	27.70006	85.36807	0101000020E6100000E12879758E575540DE3CD52137B33B40
S284	Sundhari Chowk	27.69822	85.36783	0101000020E6100000361FD7868A575540C269C18BBEB23B40
S285	Khahare	27.69667	85.36717	0101000020E6100000A18499B67F575540B51A12F758B23B40
S286	Khahare Bus Stop	27.69672	85.36635	0101000020E6100000EF384547725755401878EE3D5CB23B40
S287	Seto Ghar	27.69566	85.36419	0101000020E6100000EFE192E34E575540A72215C616B23B40
S288	Putalisadak	27.70576	85.32279	0101000020E6100000745E6397A854554031D3F6AFACB43B40
S289	Skywalk Tower	27.70796	85.31896	0101000020E6100000DC2E34D7695455404CE0D6DD3CB53B40
S290	Ghantaghar	27.70788	85.31679	0101000020E6100000CA6C904946545540137EA99F37B53B40
S291	Bhirkutimandap	27.70261	85.31648	0101000020E6100000A375543541545540B2D7BB3FDEB33B40
S292	Sahid Gate	27.69967	85.31398	0101000020E610000047E6913F1854554009FEB7921DB33B40
S293	Kapan	27.74049	85.36378	0101000020E610000017BCE82B48575540DA03ADC090BD3B40
S294	Banglamukhi Kapan	27.73896	85.36261	0101000020E6100000F7CC9200355755405A0D897B2CBD3B40
S295	Dhaulagiri Chowk	27.73777	85.36294	0101000020E6100000419AB1683A5755404DF8A57EDEBC3B40
S296	Aani Gumba Kapan	27.73751	85.36407	0101000020E61000001ADD41EC4C57554014799274CDBC3B40
S297	Kharibot Faika	27.73531	85.36419	0101000020E6100000EFE192E34E575540F86BB2463DBC3B40
S298	Sanima Bank Faika	27.73385	85.36266	0101000020E610000050E449D2355755406B2BF697DDBB3B40
S299	Faika Chowk	27.73202	85.36234	0101000020E610000017821C94305755409604A8A965BB3B40
S300	Mandala Banquet Mahankal	27.73103	85.36338	0101000020E61000005001309E41575540176536C824BB3B40
S301	Muhu Gumba Mahankal	27.72968	85.36429	0101000020E6100000A110018750575540978BF84ECCBA3B40
S302	Bajranagar	27.72723	85.36393	0101000020E610000021020EA14A5755408AABCABE2BBA3B40
S303	Gopi Krishna	27.72167	85.34577	0101000020E6100000077C7E18215655401B81785DBFB83B40
S304	Dhumbarahi	27.73155	85.34449	0101000020E610000023F3C81F0C56554088635DDC46BB3B40
S305	Chhapal Karkhana	27.73506	85.3422	0101000020E61000003D2CD49AE6555540079964E42CBC3B40
S306	Baluwatar	27.73129	85.329	0101000020E6100000931804560E55554050E449D235BB3B40
S307	Kalika Tower Baluwatar	27.72793	85.33083	0101000020E610000049A297512C555540FCC6D79E59BA3B40
S308	Rastrya Bank Baluwatar	27.72458	85.33088	0101000020E6100000A1B94E232D555540EF552B137EB93B40
S309	Naxal Bbsm	27.71946	85.33116	0101000020E6100000936FB6B931555540B9C7D2872EB83B40
S310	Tangal	27.71693	85.33036	0101000020E610000005FA449E24555540738577B988B73B40
S311	Naxal 	27.71447	85.32915	0101000020E61000009E5E29CB105555401EF98381E7B63B40
S312	Narayan Chaur	27.71495	85.32654	0101000020E61000007E350708E6545540744694F606B73B40
S313	Nagpokhari	27.7142	85.32585	0101000020E6100000B459F5B9DA5455409FCDAACFD5B63B40
S314	Marriott Hotel	27.71315	85.32462	0101000020E610000029E8F692C6545540742497FF90B63B40
S315	Hattisar	27.71111	85.3221	0101000020E6100000AA8251499D545540CBDB114E0BB63B40
S316	Putalisadak	27.70584	85.3229	0101000020E610000038F8C264AA545540693524EEB1B43B40
S317	Sankhar Dev Campus	27.70331	85.32249	0101000020E61000005FD218ADA354554023F3C81F0CB43B40
S318	New Plaza	27.70076	85.32333	0101000020E610000034F44F70B15455404F58E20165B33B40
S319	Anamnagar	27.69933	85.32889	0101000020E6100000D07EA4880C555540971C774A07B33B40
S320	Hanumansthan	27.69399	85.32772	0101000020E6100000B08F4E5DF954554044C02154A9B13B40
S321	Anamnagar Bbsm	27.6922	85.33006	0101000020E6100000F06DFAB31F5555408C4AEA0434B13B40
S322	Thapagaun	27.69149	85.33264	0101000020E6100000DA5548F949555540D482177D05B13B40
S323	Baneshwor Panitanki	27.69001	85.33594	0101000020E6100000C45A7C0A80555540B8E9CF7EA4B03B40
S324	Balkumari Nepal Yatayat Stop	27.67299	85.34269	0101000020E6100000A4AA09A2EE555540F888981249AC3B40
S325	Manohara Corridor Police Sector	27.67001	85.34656	0101000020E61000008386FE092E56554033FE7DC685AB3B40
S326	Boje Pokhari Bridge Manohara	27.66805	85.34934	0101000020E6100000D1CB28965B565540C217265305AB3B40
S327	Mahalaxmi Tikathali	27.66766	85.35053	0101000020E6100000159161156F565540EDD808C4EBAA3B40
S328	Bhagwati Mandir Tikathali	27.66734	85.35328	0101000020E61000002D95B7239C565540095053CBD6AA3B40
S329	Jhikuchu Tikathali	27.66587	85.35528	0101000020E6100000103B53E8BC5655403563D17476AA3B40
S330	Bigmart Tikathali	27.66498	85.35739	0101000020E6100000B77A4E7ADF5655407C7E18213CAA3B40
S331	Tikathali	27.66705	85.361	0101000020E6100000C976BE9F1A575540FBCBEEC9C3AA3B40
S332	Chapagaun Dobato	27.65785	85.32242	0101000020E6100000E2E47E87A254554071AC8BDB68A83B40
S333	Talchikhel	27.65912	85.32077	0101000020E61000006DE2E47E87545540B8239C16BCA83B40
S334	Mahalakxmisthan	27.66254	85.3165	0101000020E6100000C74B378941545540B64AB0389CA93B40
S335	Kusunti	27.6643	85.3144	0101000020E610000032772D211F54554099BB96900FAA3B40
S336	Ekantakuna	27.66662	85.30831	0101000020E6100000E8C1DD59BB5355400ADCBA9BA7AA3B40
S337	Nakhu	27.67207	85.30353	0101000020E6100000B6D617096D5355406B9F8EC70CAC3B40
S338	Dhobigat	27.67512	85.30188	0101000020E610000041D47D005253554022E010AAD4AC3B40
S339	Star Hospital	27.68164	85.30217	0101000020E610000045F5D6C0565355403CA583F57FAE3B40
S340	Sanepa	27.68426	85.30161	0101000020E6100000618907944D53554001F6D1A92BAF3B40
S341	Balkhu	27.68476	85.29716	0101000020E61000007B6B60AB04535540E59B6D6E4CAF3B40
S342	Advanced College Of Engineering	27.68565	85.29323	0101000020E6100000300DC347C45255409D8026C286AF3B40
S343	Khashi Bazar	27.68931	85.28418	0101000020E6100000598B4F013052554046CEC29E76B03B40
S344	Chabahil	27.7171	85.34665	0101000020E6100000234A7B832F5655402BF697DD93B73B40
S345	Gaushala	27.70777	85.34335	0101000020E610000039454772F955554005172B6A30B53B40
S346	Pashupati Temple	27.7059	85.34805	0101000020E6100000DCD7817346565540143FC6DCB5B43B40
S347	Tilganga Eye Hospital	27.7062	85.35015	0101000020E610000071AC8BDB68565540696FF085C9B43B40
S348	Tribhuvan International Airport	27.70062	85.35373	0101000020E61000004D672783A35655406CEC12D55BB33B40
S349	Tinkune	27.68631	85.35009	0101000020E6100000062AE3DF67565540F2EA1C03B2AF3B40
S350	Bista Gaun	27.70239	85.38701	0101000020E6100000664E97C5C45855409609BFD4CFB33B40
S351	Christian School	27.70473	85.39142	0101000020E610000005C078060D59554095826E2F69B43B40
S352	Mulpani Pipalbot	27.7068	85.39479	0101000020E61000006CB2463D4459554014D044D8F0B43B40
S353	Mulpani Volleyball Center	27.71163	85.40306	0101000020E6100000D9942BBCCB5955403CDA38622DB63B40
S354	Mulpani Chaur	27.7157	85.40621	0101000020E6100000B9533A58FF59554048BF7D1D38B73B40
S355	Sunrise Bakery Mulpani	27.71334	85.41713	0101000020E61000008D0B0742B25A5540BBED42739DB63B40
S356	Riddhi Siddhi Mulpani	27.7109	85.41655	0101000020E610000086C954C1A85A5540F5B9DA8AFDB53B40
S357	A Chanacho 	27.6508	85.35576	0101000020E6100000664E97C5C45655409F3C2CD49AA63B40
S358	B Shanti Pokhari	27.64832	85.35511	0101000020E6100000E21E4B1FBA565540BC57AD4CF8A53B40
S359	C Thasikwa Falcha	27.64459	85.35282	0101000020E6100000FB57569A945655402254A9D903A53B40
S360	D Siddhipur Height Gate	27.64268	85.35179	0101000020E6100000D44334BA8356554014CB2DAD86A43B40
S361	E Harisiddhi Naya Basti	27.63821	85.35187	0101000020E6100000639CBF0985565540ECFA05BB61A33B40
S362	Lakur Chwok	27.63419	85.35054	0101000020E610000026FC523F6F56554043739D465AA23B40
S363	Riddi Shiddhi Bus Park	27.63444	85.34732	0101000020E6100000CA4FAA7D3A5655403546EBA86AA23B40
S364	Kamalbinayak	27.67721	85.43697	0101000020E610000052D50451F75B55402F8672A25DAD3B40
S365	Chaymasing	27.67345	85.4383	0101000020E61000008E75711B0D5C5540BF7D1D3867AC3B40
S366	Jagati	27.66652	85.43641	0101000020E61000006E693524EE5B55404221020EA1AA3B40
S367	Suryabinayak	27.66543	85.42726	0101000020E6100000E5B8533A585B5540FCC6D79E59AA3B40
S368	Chunudevi	27.66711	85.41699	0101000020E61000009430D3F6AF5A5540A6D590B8C7AA3B40
S369	Sallaghari	27.67129	85.40884	0101000020E6100000FC523F6F2A5A5540C02154A9D9AB3B40
S370	Radhe Radhe	27.67452	85.3976	0101000020E6100000EF38454772595540787FBC57ADAC3B40
S371	Thimi	27.67331	85.38639	0101000020E610000018601F9DBA585540DC114E0B5EAC3B40
S372	Tuberculosis Hospital	27.67329	85.38168	0101000020E61000006362F3716D5855404EB9C2BB5CAC3B40
S373	Chardobato	27.67342	85.37901	0101000020E6100000D8B628B341585540EA78CC4065AC3B40
S374	Ghattaghar	27.67394	85.37234	0101000020E610000087BF266BD45755405C77F35487AC3B40
S375	Balkhu (Kritipur Side)	27.68438	85.29737	0101000020E6100000F0332E1C085355405709168733AF3B40
S376	Kumari Club	27.68264	85.29854	0101000020E6100000102384471B53554002F1BA7EC1AE3B40
S377	Tu Gate	27.67879	85.2972	0101000020E6100000C21726530553554012DA722EC5AD3B40
S378	Tu Cricket Ground	27.6791	85.2898	0101000020E61000005F984C158C525540AEB6627FD9AD3B40
S379	Tu University	27.67844	85.28498	0101000020E6100000E700C11C3D525540594C6C3EAEAD3B40
S380	Kritipur Nayabazar Gate	27.67706	85.28195	0101000020E6100000DC4603780B525540056EDDCD53AD3B40
S381	Manakamna Mandir	27.66122	85.34696	0101000020E61000004A41B797345655400C76C3B645A93B40
S382	Mahendra Adarsha School	27.66134	85.34801	0101000020E6100000952BBCCB45565540618907944DA93B40
S383	Ansari Medical	27.66095	85.3505	0101000020E6100000DF4F8D976E5655408C4AEA0434A93B40
S384	Pawan Prakriti School	27.65934	85.3541	0101000020E6100000DFE00B93A9565540D4F19881CAA83B40
S385	Tikathali Tinkune	27.65883	85.35689	0101000020E61000003F912749D7565540A99F3715A9A83B40
S386	Tikathali Bus Stop	27.65899	85.35791	0101000020E6100000543A58FFE75655401B649291B3A83B40
S387	Gokarneshwor	27.73738	85.38683	0101000020E610000026C79DD2C158554078B988EFC4BC3B40
S388	Makalbari Bridge	27.73095	85.38502	0101000020E61000009413ED2AA4585540DE02098A1FBB3B40
S389	Jaya Multiple Campus	27.7283	85.38449	0101000020E6100000E6E8F17B9B58554043AD69DE71BA3B40
S390	Dakshindhoka	27.72184	85.38286	0101000020E610000094BC3AC780585540D4F19881CAB83B40
S391	Narayantar	27.72155	85.37922	0101000020E61000004E7FF62345585540C66D3480B7B83B40
S392	Jorpati	27.72184	85.37307	0101000020E61000009947FE60E0575540D4F19881CAB83B40
S393	Bouddha	27.7205	85.36076	0101000020E61000001E6D1CB1165755409CC420B072B83B40
S394	Chuchepati	27.71927	85.35106	0101000020E6100000C3BB5CC47756554072FE261422B83B40
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transfers (id, from_stop_id, to_stop_id, walking_time_min, walking_distance_m) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, hashed_password, reset_otp_hash, reset_otp_expires_at, created_at, profile_image_filename) FROM stdin;
a878b667-b459-4391-8ab7-8f11799aabcc	Test User	test1786381237@example.com	$2b$12$hpYo5s73g2ygG1jqbqmmWOCmG8iAf9ekKtNXxE0gXRMjspvEnHk7a	\N	\N	2026-08-10 22:45:37.396288+05:45	\N
2180083d-06a2-4585-bf22-8d65493f7e1e	Bipin Tharu	bipin123@gmail.com	$2b$12$1a66DPmw8MpD8K0uj8/pnOOlKJ0W95h8QIuvKZUScN1WwxGiGKc2C	\N	\N	2026-08-10 23:05:36.191378+05:45	2180083d-06a2-4585-bf22-8d65493f7e1e-b51d98f3b63448f3b2e92fa4a81959be.jpg
d5e1e713-b44b-4d6e-9630-7ecc4612316b	bibektharu	bibek143@gmail.com	$2b$12$Xqg4pv7gF57dgOaKSUjtlepxOLT0JXzzgs7ZTJaVbLq.ckqEejqmW	\N	\N	2026-08-11 14:40:01.818012+05:45	\N
dd6b90c6-40c6-4e34-8783-9af45577447b	Bipin Tharu	bibektharu412@gmail.com	$2b$12$UyJUt8fy8BeJFsnH8p90iuqgxUvkRtDUTr7v9tw1C4ld6nBYYZZCO	$2b$12$i8J3nJWMh6fGixG/4EbeZ.8wxq2nXx5/1DeEFEAWwz6cGC2IBl9h6	2026-08-13 18:49:47.769364+05:45	2026-08-11 21:44:38.900763+05:45	\N
\.


--
-- Name: route_stops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.route_stops_id_seq', 1559, true);


--
-- Name: routing_edges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.routing_edges_id_seq', 16916, true);


--
-- Name: routing_nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.routing_nodes_id_seq', 1550, true);


--
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transfers_id_seq', 1, false);


--
-- Name: route_stops route_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.route_stops
    ADD CONSTRAINT route_stops_pkey PRIMARY KEY (id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: routing_edges routing_edges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_edges
    ADD CONSTRAINT routing_edges_pkey PRIMARY KEY (id);


--
-- Name: routing_nodes routing_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_nodes
    ADD CONSTRAINT routing_nodes_pkey PRIMARY KEY (id);


--
-- Name: stops stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_stops_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stops_geom ON public.stops USING gist (geom);


--
-- Name: idx_stops_name_lower; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stops_name_lower ON public.stops USING btree (lower(name));


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: route_stops route_stops_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.route_stops
    ADD CONSTRAINT route_stops_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id);


--
-- Name: route_stops route_stops_stop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.route_stops
    ADD CONSTRAINT route_stops_stop_id_fkey FOREIGN KEY (stop_id) REFERENCES public.stops(id);


--
-- Name: routing_edges routing_edges_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_edges
    ADD CONSTRAINT routing_edges_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id);


--
-- Name: routing_edges routing_edges_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_edges
    ADD CONSTRAINT routing_edges_source_fkey FOREIGN KEY (source) REFERENCES public.routing_nodes(id);


--
-- Name: routing_edges routing_edges_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_edges
    ADD CONSTRAINT routing_edges_target_fkey FOREIGN KEY (target) REFERENCES public.routing_nodes(id);


--
-- Name: routing_nodes routing_nodes_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_nodes
    ADD CONSTRAINT routing_nodes_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id);


--
-- Name: routing_nodes routing_nodes_stop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routing_nodes
    ADD CONSTRAINT routing_nodes_stop_id_fkey FOREIGN KEY (stop_id) REFERENCES public.stops(id);


--
-- Name: transfers transfers_from_stop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_from_stop_id_fkey FOREIGN KEY (from_stop_id) REFERENCES public.stops(id);


--
-- Name: transfers transfers_to_stop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_to_stop_id_fkey FOREIGN KEY (to_stop_id) REFERENCES public.stops(id);


--
-- PostgreSQL database dump complete
--

\unrestrict brYgBapLIBUGavihiFdgheIY4l7SuA4lOYbR5XfpkYBB5f9Y8mQxTmkOc9Pi6fL

