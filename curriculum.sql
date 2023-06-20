CREATE SCHEMA IF NOT EXISTS curriculum
    AUTHORIZATION postgres;

create table curriculum.program_reviews(
	prow_user_entity_id int,
	prow_prog_entity_id int,
	prow_review varchar(512),
	prow_rating int,
	prow_modified_date timestamp,
	constraint program_reviews_pk primary key (prow_user_entity_id,prow_prog_entity_id)
);

create table curriculum.program_entity_description(
	pred_prog_entity_id int,
	pred_item_learning json,
	pred_item_include json,
	pred_requirement json,
	pred_description json,
	pred_target_level json,
	constraint program_entity_description_pk primary key (pred_prog_entity_id)
);

create table curriculum.program_entity(
	prog_entity_id serial,
	prog_title varchar(256),
	prog_headline varchar(512),
	prog_type varchar(15),
	prog_learning_type varchar(15),
	prog_rating numeric,
	prog_total_trinee int,
	prog_modified_date timestamp,
	prog_image varchar(256),
	prog_best_seller char(1),
	prog_price numeric,
	prog_language varchar(35),
	prog_modified_data timestamp,
	prog_duration int,
	prog_duration_type varchar(15),
	prog_tag_skill varchar(512),
	prog_city_id int,
	prog_cate_id int,
	prog_created_by int,
	prog_status varchar(15),
	constraint program_entity_pk primary key (prog_entity_id)
);

alter table curriculum.program_entity_description add constraint program_entity_description_fk1 foreign key (pred_prog_entity_id) references curriculum.program_entity(prog_entity_id);

alter table curriculum.program_reviews add constraint program_reviews_fk1 foreign key (prow_prog_entity_id) references curriculum.program_entity(prog_entity_id)

create table curriculum.sections(
	sect_id serial,
	sect_prog_entity_id int,
	sect_title varchar(100),
	sect_description varchar(256),
	sect_total_section int,
	sect_total_lecture int,
	sect_total_minute int,
	sect_modified_date timestamp,
	constraint sections_pk primary key (sect_id,sect_prog_entity_id)
);

alter table curriculum.sections add constraint sections_u1 unique (sect_id);
alter table curriculum.sections add constraint sections_fk1 foreign key (sect_prog_entity_id) references curriculum.program_entity(prog_entity_id);

create table curriculum.section_detail(
	secd_id serial,
	secd_title varchar(256),
	secd_preview char(1),
	secd_score int,
	secd_note varchar(256),
	secd_minute int,
	secd_modified_date timestamp,
	secd_sect_id int,
	constraint section_detail_pk primary key (secd_id),
	constraint section_detail_fk1 foreign key (secd_sect_id) references curriculum.sections(sect_id)
);

create table curriculum.section_detail_material(
	sedm_id serial,
	sedm_filename varchar(55),
	sedm_filesize int,
	sedm_filetype varchar(15),
	sedm_filelink varchar(255),
	sedm_modified_date timestamp,
	sedm_secd_id int,
	constraint section_detail_material_pk primary key (sedm_id),
	constraint section_detail_material_fk1 foreign key (sedm_secd_id) references curriculum.section_detail(secd_id)
);


--check value--
alter table curriculum.program_entity add constraint prog_type check (prog_type in ('bootcamp','course'));
alter table curriculum.program_entity add constraint prog_learning_type check (prog_learning_type in ('online','offline','both'));
alter table curriculum.program_entity add constraint prog_best_seller check (prog_best_seller in ('0','1'));
alter table curriculum.program_entity add constraint prog_language check (prog_language in ('english','bahasa'));
alter table curriculum.program_entity add constraint prog_durataion_type check (prog_duration_type in ('month','week','days'));
alter table curriculum.program_entity add constraint prog_status check (prog_status in ('draft','publish'));
alter table curriculum.section_detail add constraint secd_preview check (secd_preview in ('0','1'));
alter table curriculum.section_detail_material add constraint sedm_filetype check (sedm_filetype in ('video','image','text','link'));

--references from different modules--
alter table curriculum.program_reviews set constraint program_reviews_fk2 foreign key (prow_user_entity_id) references users.users(user_entity_id);
alter table curriculum.program_entity set constraint program_entity_fk1 foreign key (prog_city_id) references master.city(city_id);
alter table curriculum.program_entity set constraint program_entity_fk2 foreign key (prog_cate_id) references master.category(cate_id);
alter table curriculum.program_entity set constraint program_entity_fk3 foreign key (prog_created_by) references users.business_entity(entity_id);
alter table curriculum.program_entity set constraint program_entity_fk4 foreign key (prog_status) references master.status(status);