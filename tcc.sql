--
-- PostgreSQL database dump
--

-- Dumped from database version 12.6 (Ubuntu 12.6-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.6 (Ubuntu 12.6-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.ar_internal_metadata (key, value, created_at, updated_at) VALUES ('environment', 'development', '2021-04-27 23:57:05.836342', '2021-04-27 23:57:05.836342');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at, first_name) VALUES (1, 'user@user.com.br', '$2a$12$aUULi90dezQ56jYtYCxlxeofR66QCiY6fposxwgO8uPFtT6.EMWXK', NULL, NULL, NULL, '2021-04-27 23:57:06.167295', '2021-04-27 23:57:06.167295', 'Davide User');


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.companies (id, name, description, created_at, updated_at, user_id) VALUES (1, 'Empresa 1', 'Descrição da empresa 1', '2021-04-27 23:57:06.189066', '2021-04-27 23:57:06.189066', 1);
INSERT INTO public.companies (id, name, description, created_at, updated_at, user_id) VALUES (2, 'Empresa 2', 'Descrição da empresa 2', '2021-04-27 23:57:06.199269', '2021-04-27 23:57:06.199269', 1);


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.projects (id, name, description, company_id, created_at, updated_at, user_id, hour_price_cents, status) VALUES (2, 'Projeto 2', 'Descrição do Projeto 2', 2, '2021-04-27 23:57:06.246958', '2021-04-27 23:57:06.246958', 1, 3000, 0);
INSERT INTO public.projects (id, name, description, company_id, created_at, updated_at, user_id, hour_price_cents, status) VALUES (3, 'Projeto 3', 'Descrição do Projeto 3', 2, '2021-04-27 23:57:06.259109', '2021-04-27 23:57:06.259109', 1, 3000, 0);
INSERT INTO public.projects (id, name, description, company_id, created_at, updated_at, user_id, hour_price_cents, status) VALUES (1, 'Projeto 1', 'Descrição do Projeto 1', 1, '2021-04-27 23:57:06.233123', '2021-04-28 00:36:03.984261', 1, 3000, 1);
INSERT INTO public.projects (id, name, description, company_id, created_at, updated_at, user_id, hour_price_cents, status) VALUES (4, 'projeto banana', 'bananaaaaa', 1, '2021-05-01 20:39:53.485441', '2021-05-01 20:39:53.485441', 1, 2000, 0);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.schema_migrations (version) VALUES ('20210322145925');
INSERT INTO public.schema_migrations (version) VALUES ('20210322150421');
INSERT INTO public.schema_migrations (version) VALUES ('20210324232314');
INSERT INTO public.schema_migrations (version) VALUES ('20210324232458');
INSERT INTO public.schema_migrations (version) VALUES ('20210325000330');
INSERT INTO public.schema_migrations (version) VALUES ('20210325000420');
INSERT INTO public.schema_migrations (version) VALUES ('20210325002135');
INSERT INTO public.schema_migrations (version) VALUES ('20210413235556');
INSERT INTO public.schema_migrations (version) VALUES ('20210413235658');
INSERT INTO public.schema_migrations (version) VALUES ('20210414160836');
INSERT INTO public.schema_migrations (version) VALUES ('20210420150922');
INSERT INTO public.schema_migrations (version) VALUES ('20210423072915');
INSERT INTO public.schema_migrations (version) VALUES ('20210426195019');
INSERT INTO public.schema_migrations (version) VALUES ('20210427211516');


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.tasks (id, name, project_id, created_at, updated_at, user_id, company_id, status) VALUES (2, 'Task 2', 1, '2021-04-27 23:57:06.302347', '2021-04-27 23:57:06.302347', 1, 1, 0);
INSERT INTO public.tasks (id, name, project_id, created_at, updated_at, user_id, company_id, status) VALUES (3, 'Task 3', 2, '2021-04-27 23:57:06.315932', '2021-04-27 23:57:06.315932', 1, 2, 0);
INSERT INTO public.tasks (id, name, project_id, created_at, updated_at, user_id, company_id, status) VALUES (1, 'Task 1', 1, '2021-04-27 23:57:06.287914', '2021-04-28 22:29:08.298772', 1, 1, 0);


--
-- Data for Name: task_schedules; Type: TABLE DATA; Schema: public; Owner: davide
--

INSERT INTO public.task_schedules (id, start_date, end_date, task_id, created_at, updated_at, work_hour) VALUES (1, '2021-04-27 23:57:06.321503', '2021-04-28 03:57:06.321503', 1, '2021-04-27 23:57:06.335895', '2021-04-27 23:57:06.335895', '04:00:00');
INSERT INTO public.task_schedules (id, start_date, end_date, task_id, created_at, updated_at, work_hour) VALUES (2, '2021-04-27 23:57:06.321503', '2021-04-28 23:57:06.321503', 2, '2021-04-27 23:57:06.345522', '2021-04-27 23:57:06.345522', '24:00:00');
INSERT INTO public.task_schedules (id, start_date, end_date, task_id, created_at, updated_at, work_hour) VALUES (3, '2021-04-28 22:28:00', '2021-04-28 22:28:00', 1, '2021-04-28 22:28:39.309602', '2021-04-28 22:28:39.309602', '00:00:02');


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: davide
--

SELECT pg_catalog.setval('public.companies_id_seq', 2, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: davide
--

SELECT pg_catalog.setval('public.projects_id_seq', 4, true);


--
-- Name: task_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: davide
--

SELECT pg_catalog.setval('public.task_schedules_id_seq', 3, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: davide
--

SELECT pg_catalog.setval('public.tasks_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: davide
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

