CREATE SCHEMA IF NOT EXISTS job_hire
    AUTHORIZATION postgres;

create table job_hire.employee_range(
	emra_id serial primary key,
	emra_range_min int unique,
	emra_range_max int unique,
	emra_modified_date timestamp
);

create table job_hire.client(
	clit_id int primary key,
	clit_name varchar(256) unique,
	clit_about varchar(512),
	clit_modified_date timestamp,
	clit_addr_id int,
	clit_emra_id int,
	constraint clit_emra_id_fk foreign key (clit_emra_id) references job_hire.employee_range(emra_id)
);

create table job_hire.job_category(
	joca_id serial primary key,
	joca_name varchar(255),
	joca_modified_date timestamp
);

create table job_hire.job_post(
	jopo_entity_id serial primary key,
	jopo_number varchar(25) unique,
	jopo_tittle varchar(256),
	jopo_start_date timestamp,
	jopo_end_date timestamp,
	jopo_min_salary numeric,
	jopo_max_salary numeric,
	jopo_min_experience int,
	jopo_max_experience int,
	jopo_primary_skill varchar(256),
	jopo_secondary_skill varchar(256),
	jopo_publish_date timestamp,
	jopo_modified_date timestamp,
	jopo_emp_entity_id int,
	jopo_clit_id int,
	constraint jopo_clit_id_fk foreign key (jopo_clit_id) references job_hire.client(clit_id),
	jopo_joro_id int,
	jopo_joty_id int,
	jopo_joca_id int,
	constraint jopo_joca_id_fk foreign key (jopo_joca_id) references job_hire.job_category(joca_id),
	jopo_addr_id int,
	jopo_work_code varchar(15),
	jopo_edu_code varchar(5),
	jopo_indu_code varchar(15),
	jopo_status varchar(15)
);

create table job_hire.job_post_desc(
	jopo_entity_id int primary key,
	jopo_description json,
	jopo_responsibility json,
	jopo_target json,
	jopo_benefit json,
	constraint jopo_entity_id_fk foreign key (jopo_entity_id) references job_hire.job_post(jopo_entity_id)
);

create table job_hire.job_photo(
	jopho_id serial primary key,
	jopho_filename varchar(55),
	jopho_filesize  int,
	jopho_filetype varchar(15),
	jopho_modified_date timestamp,
	jopho_entity_id int,
	constraint jopho_entity_id_fk foreign key (jopho_entity_id) references job_hire.job_post(jopo_entity_id)
);

create table job_hire.talent_apply(
	taap_user_entity_id int,
	taap_entity_id int,
	taap_intro varchar(512),
	taap_scoring int,
	taap_modified_date timestamp,
	taap_status varchar(15),
	constraint talent_apply_pk primary key (taap_user_entity_id,taap_entity_id),
	constraint taap_entity_id_fk foreign key (taap_entity_id) references job_hire.job_post(jopo_entity_id)
);

create table job_hire.talent_apply_progress(
	tapr_id serial,
	taap_user_entity_id int,
	taap_entity_id int,
	tapr_modified_date timestamp,
	tapr_status varchar(15),
	tapr_comment varchar(256),
	tapr_progress_name varchar(55),
	constraint talent_apply_progress_pk primary key (tapr_id,taap_user_entity_id,taap_entity_id),
	constraint taap_entity_id_fk foreign key (taap_entity_id) references job_hire.job_post(jopo_entity_id)
);


--references from other modules--
alter table job_hire.client add constraint clit_addr_id_fk foreign key (clit_addr_id) references master.address(addr_id);
alter table job_hire.job_post add constraint jopo_status foreign key (jopo_status) references master.status(status);
alter table job_hire.job_post add constraint jopo_indu_code_fk foreign key (jopo_indu_code) references master.industry(indu_code);
alter table job_hire.job_post add constraint jopo_edu_code_fk foreign key (jopo_edu_code) references master.education(edu_code);
alter table job_hire.job_post add constraint jopo_work_code_fk foreign key (jopo_work_code) references master.working_type(woty_code);
alter table job_hire.job_post add constraint jopo_addr_id_fk foreign key (jopo_addr_id) references master.address(addr_id);
alter table job_hire.job_post add constraint jopo_joty_id_fk foreign key (jopo_joty_id) references master.job_type(joty_id);
alter table job_hire.job_post add constraint jopo_joro_id_fk foreign key (jopo_joro_id) references master.job_role(joro_id);
alter table job_hire.job_post add constraint jopo_emp_entity_id_fk foreign key (jopo_emp_entity_id) references hr.employee(emp_entity_id);
alter table job_hire.talent_apply add constraint taap_status_fk foreign key (taap_status) references master.status(status);
alter table job_hire.talent_apply add constraint taap_user_entity_id_fk foreign key (taap_user_entity_id) references users.users(user_entity_id);
alter table job_hire.talent_apply_progress add constraint taap_user_entity_id_fk1 foreign key (taap_user_entity_id) references users.users(user_entity_id);
alter table job_hire.talent_apply_progress add constraint tapr_status_fk foreign key (tapr_status) references master.status(status);
