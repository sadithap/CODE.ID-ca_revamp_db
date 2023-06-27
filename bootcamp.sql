CREATE SCHEMA IF NOT EXISTS bootcamp
    AUTHORIZATION postgres;
	
create table bootcamp.program_apply(
	prap_user_entity_id int,
	prap_prog_entity_id int,
	prap_test_score int,
	prap_gpa numeric,
	prap_iq_test numeric,
	prap_review varchar(256),
	prap_modified_date timestamp,
	prap_status varchar(15),
	constraint PK_prap_user_entity_id_and_prap_prog_entity_id primary key (prap_user_entity_id, prap_prog_entity_id)
);


create table bootcamp.program_apply_progress(
	parog_id serial,
	parog_user_entity_id int,
	parog_prog_entity_id int,
	parog_action_date timestamp,
	parog_modified_date timestamp,
	parog_comment varchar(512),
	parog_progress_name varchar(15),
	parog_emp_entity_id int,
	parog_status varchar(15),
	constraint PK_parog_id_parog_user_entity_id_parog_prog_entity_id primary key (parog_id, parog_user_entity_id, parog_prog_entity_id),
	constraint FK_parog_user_entity_id_and_parog_prog_entity_id foreign key (parog_user_entity_id, parog_prog_entity_id) references bootcamp.program_apply(prap_user_entity_id, prap_prog_entity_id)
);


create table bootcamp.batch(
	batch_id serial,
	batch_entity_id int,
	batch_name varchar(15) unique,
	batch_description varchar(125),
	batch_start_date timestamp,
	batch_end_date timestamp,
	batch_reason varchar(256),
	batch_type varchar(15),
	batch_modified_date timestamp,
	batch_status varchar(15),
	batch_pic_id int,  --pic ini dari mana
	constraint PK_batch_id_and_batch_entity_id primary key (batch_id, batch_entity_id)
);

create table bootcamp.batch_trainee(
	batr_id serial,
	batr_status varchar(15),
	batr_certificated char(1),
	batr_certificate_link varchar(255),
	batr_access_token varchar(255),
	batr_access_grant char(1),
	batr_review varchar(1024),
	batr_total_score numeric,
	batr_modified_date timestamp,
	batr_trainee_entity_id int,
	batr_batch_id int,
	constraint PK_batr_id_and_batr_batch_id primary key(batr_id, batr_batch_id)
)

--Output : ERROR: there is no unique constraint matching given keys for referenced table "batch"
--maka jalankan query dibawah ini terlebih dahulu
alter table bootcamp.batch add constraint unique_batch_id unique (batch_id);
--baru jalankan query dibawah ini untuk menghubungkan batr_batch_id dengan batch_id
alter table bootcamp.batch_trainee add constraint FK_batr_batch_id foreign key (batr_batch_id) references bootcamp.batch(batch_id)

create table bootcamp.batch_trainee_evaluation(
	btev_id serial,
	btev_type varchar(15),
	btev_header varchar(256),
	btev_section varchar(256),
	btev_skill varchar(256),
	btev_week int,
	btev_skor int,
	btev_note varchar(256),
	btev_modified_date timestamp,
	btev_batch_id int,
	btev_trainee_entity_id int,
	constraint PK_btev_id primary key (btev_id),
	constraint FK_btev_batch_id foreign key (btev_batch_id) references bootcamp.batch(batch_id)
)


create table bootcamp.instructor_programs(
	batch_id int,
	inpro_entity_id int,
	inpro_emp_entity_id int,
	inpro_modified_date timestamp,
	constraint PK_batch_id_inpro_entity_id_inpro_emp_entity_id primary key (batch_id, inpro_entity_id, inpro_emp_entity_id),
	constraint FK_batch_id foreign key (batch_id) references bootcamp.batch(batch_id)
)
--references from other modules--
alter table bootcamp.program_apply add constraint prap_status_fk foreign key (prap_status) references master.status(status);
alter table bootcamp.program_apply add constraint prap_user_entity_id foreign key (prap_user_entity_id) references users.business_entity(entity_id);
alter table bootcamp.program_apply add constraint prap_prog_entity_id foreign key (prap_prog_entity_id) references curriculum.program_entity(prog_entity_id);
alter table bootcamp.program_apply_progress add constraint parog_emp_entity_id_fk foreign key (parog_emp_entity_id) references users.users(user_entity_id);
alter table bootcamp.program_apply_progress add constraint parog_status_fk foreign key (parog_status) references master.status(status);
alter table bootcamp.batch add constraint batch_status_fk foreign key (batch_status) references master.status(status);
alter table bootcamp.batch add constraint batch_entity_id_fk foreign key (batch_entity_id) references users.business_entity(entity_id);
alter table bootcamp.batch add constraint batch_pic_fk foreign key (batch_pic_id) references hr.employee(emp_entity_id);
alter table bootcamp.batch_trainee_evaluation add constraint btev_trainee_entity_id_fk foreign key (btev_trainee_entity_id) references users.users(user_entity_id);
alter table bootcamp.instructor_programs add constraint inpro_entity_id_fk foreign key (inpro_entity_id) references users.business_entity(entity_id);
alter table bootcamp.instructor_programs add constraint inpro_emp_entity_id_fk foreign key (inpro_emp_entity_id) references hr.employee(emp_entity_id);
