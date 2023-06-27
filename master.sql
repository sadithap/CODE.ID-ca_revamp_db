
CREATE SCHEMA IF NOT EXISTS master
    AUTHORIZATION postgres;

create table master.status(
	status varchar(15) primary key,
	status_modified_date timestamp
);

create table master.education(
	edu_code varchar(5) primary key,
	edu_name varchar(55) unique
);

create table master.job_type(
	joty_id serial primary key,
	joty_name varchar(55)
);

create table master.industry(
	indu_code varchar(15) primary key,
	indu_name varchar(85) unique
);

create table master.address_type(
	adty_id serial primary key,
	adty_name varchar(15) unique,
	adty_modified_date timestamp
);

create table master.working_type(
	woty_code varchar(15) primary key,
	woty_name varchar(55) unique
);

create table master.job_role(
	joro_id serial primary key,
	joro_name varchar(55) unique,
	joro_modified_date timestamp
);

create table master.category(
	cate_id serial primary key,
	cate_name varchar(255) unique,
	cate_cate_id int,
	cate_modified_date timestamp
);

alter table master.category add constraint cate_cate_id_fk foreign key (cate_cate_id) references master.category(cate_id);

create table master.skill_type(
	skty_name varchar(55) primary key
);

create table master.skill_template(
	skte_id serial primary key,
	skte_skill varchar(256),
	skte_description varchar(256),
	skte_week int,
	skte_orderby int,
	skte_modified_date timestamp,
	skty_name varchar(55),
	constraint skty_name_fk foreign key (skty_name) references master.skill_type(skty_name),
	skte_skte_id int
);

alter table master.skill_template add constraint skte_skte_id_fk foreign key (skte_skte_id) references master.skill_template(skte_id);

create table master.modules(
	module_name varchar(125) primary key
);

create table master.route_actions(
	roac_id serial primary key,
	roac_name varchar(15) unique,
	roac_orderby int,
	roac_display char(1),
	roac_module_name varchar(125),
	constraint roac_module_name_fk foreign key (roac_module_name) references master.modules(module_name)
);

create table master.country(
	country_code varchar(3) primary key,
	country_name varchar(85) unique,
	country_modified_date timestamp
);

create table master.province(
	prov_id serial primary key,
	prov_code varchar(5) unique,
	prov_name varchar(85),
	prov_modified_date timestamp,
	prov_country_code varchar(3),
	constraint prov_country_code_fk foreign key (prov_country_code) references master.country(country_code)
);

create table master.city(
	city_id serial primary key,
	city_name varchar(155) unique,
	city_modified_date timestamp,
	city_prov_id int,
	constraint city_prov_id_fk foreign key (city_prov_id) references master.province(prov_id)
);

create table master.address(
	addr_id serial primary key,
	addr_line1 varchar(255) unique,
	addr_line2 varchar(255) unique,
	addr_postal_code varchar(10) unique,
	addr_spatial_location json,
	addr_modified_date timestamp,
	addr_city_id int,
	constraint addr_city_id_fk foreign key (addr_city_id) references master.city(city_id)
);