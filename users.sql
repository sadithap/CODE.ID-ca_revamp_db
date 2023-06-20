CREATE TABLE users.business_entity (
    entity_id serial primary key --pk
   
);

CREATE TABLE users.roles (
    role_id serial primary key, --pk
	role_name varchar(35) unique,
	role_type varchar(15),
	role_modified_date timestamp	
);

CREATE TABLE users.users (
    user_entity_id int primary key, --pk,fk
    user_name varchar(15) unique,
	user_password varchar(256),
	user_first_name varchar(50),
	user_last_name varchar(50),
	user_birth_date timestamp,
	user_email_promotion int default 0,
	user_demographic json,
	user_modified_date timestamp,
	user_photo varchar(255),
	user_current_role int, --fk
	constraint FK_user_entity_id foreign key (user_entity_id) references users.business_entity (entity_id)
	
);




CREATE TABLE users.users_roles (
    usro_entity_id int, --pk,fk
	usro_role_id int, --pk,fk
	usro_modified_date timestamp,
	constraint PK_usro_entity_id_and_usro_role_id primary key(usro_entity_id, usro_role_id),
	constraint FK_usro_entity_id foreign key (usro_entity_id) references users.users (user_entity_id),
	constraint FK_usro_role_id foreign key (usro_role_id) references users.roles (role_id)
);

-- ERROR:  there is no unique constraint matching given keys for referenced table "users_roles" --
-- jadi table users_roles harus di bikin unique dulu
ALTER TABLE users.users_roles
ADD CONSTRAINT unique_usro_role_id UNIQUE (usro_role_id);
-- baru setelah itu bisa alter refrence dari table users ke tabel users_role
ALTER TABLE users.users
ADD CONSTRAINT fk_user_current_role FOREIGN KEY (user_current_role) REFERENCES users.users_roles(usro_role_id);




CREATE TABLE users.users_skill (
    uski_id serial, --fk
	uski_identity_id int, --fk,pk
	uski_modified_date timestamp,
	uski_skty_name varchar(15) unique, -- uski_skty_name reference to skty_name module master
	constraint PK_uski_id_and_uski_identity_id primary key(uski_id, uski_identity_id),
	constraint FK_uski_identity_id foreign key (uski_identity_id) references users.users (user_entity_id)
);

CREATE TABLE users.users_experiences (
    usex_id serial, --pk
	usex_entity_id int, --pk,fk
	usex_title varchar(255),
	usex_profile_headline varchar(512),
	usex_eployment_type varchar(15) CHECK (usex_eployment_type IN ('fulltime', 'freelance')),
	usex_company_name varchar(255),
	usex_is_current char(1) CHECK (usex_is_current IN ('0', '1')),
	usex_start_date timestamp,
	usex_end_date timestamp,
	usex_industry varchar(15),
	usex_description varchar(512),
	usex_experience_type varchar(15) CHECK (usex_experience_type IN ('company', 'certified', 'voluntering', 'organization', 'reward')),
    usex_city_id int, --fk dari table city dalam module master
	constraint PK_usex_id_and_usex_entity_id primary key(usex_id, usex_entity_id),
	constraint FK_usex_entity_id foreign key (usex_entity_id) references users.users (user_entity_id)
);

ALTER TABLE users.users_experiences
ADD CONSTRAINT unique_usex_id UNIQUE (usex_id);

ALTER TABLE users.users_skill
ADD CONSTRAINT unique_uski_id UNIQUE (uski_id);

CREATE TABLE users.users_experiences_skill (
    uesk_usex_id int, --pk,fk
	uesk_uski_id int, --pk,fk
	constraint PK_uesk_usex_id_and_uesk_uski_id primary key(uesk_usex_id, uesk_uski_id),
    constraint FK_uesk_usex_id foreign key (uesk_usex_id) references users.users_experiences (usex_id),
	constraint FK_uesk_uski_id foreign key (uesk_uski_id) references users.users_skill (uski_id)
);
-- ERROR:  there is no unique constraint matching given keys for referenced table "users_experiences" --
-- ERROR:  there is no unique constraint matching given keys for referenced table "users_skill" ---
-- jadi table users_experiences dan users_skill harus dibikin unique dulu





CREATE TABLE users.users_license (
    usli_id serial, --pk
	usli_license_code varchar(512)unique,
	usli_modified_date timestamp,
	usli_status varchar(15) CHECK (usli_status IN ('active', 'NonActive')),
	usli_entity_id int, --pk,fk
	constraint PK_usli_id_and_usli_entity_id primary key(usli_id, usli_entity_id),
    constraint FK_usli_entity_id foreign key (usli_entity_id) references users.users (user_entity_id)
);

CREATE TABLE users.users_email(
	pmail_entity_id int, --pk,fk
	pmail_id serial, --pk
	pmail_address varchar(50),
	pmail_modified_date timestamp,
	constraint PK_pmail_entity_id_and_pmail_id primary key(pmail_entity_id, pmail_id),
    constraint FK_pmail_entity_id foreign key (pmail_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.users_media(
	usme_id serial, --pk
	usme_entity_id int, --pk,fk
	usme_file_link varchar(255),
	usme_filename varchar(55),
	usme_filesize int,
	usme_filetype varchar(15) CHECK (usme_filetype IN ('jpg', 'pdf', 'word')),
	usme_note varchar(55),
	usme_modified_date timestamp,
	constraint PK_usme_id_and_usme_entity_id primary key(usme_id, usme_entity_id),
    constraint FK_usme_entity_id foreign key (usme_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.users_education(
	usdu_id serial, --pk
	usdu_entity_id int, --pk,fk
	usdu_school varchar(255),
	usdu_degree varchar(15) CHECK (usdu_degree IN ('Bachelor', 'Diploma')),
	usdu_field_study varchar(125),
	usdu_graduate_year varchar(4),
	usdu_start_date timestamp,
	usdu_end_date timestamp,
	usdu_grade varchar(5),
	usdu_activities varchar(512),
	usdu_description varchar(512),
	usdu_modified_date timestamp,
	constraint PK_usdu_id_and_usdu_entity_id primary key(usdu_id, usdu_entity_id),
    constraint FK_usdu_entity_id foreign key (usdu_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.phone_number_type(
	ponty_code varchar(15) primary key, --pk
	ponty_modified_date timestamp
);


CREATE TABLE users.users_phones(
	uspo_entity_id int, --pk,fk
	uspo_number varchar(15), --pk
	uspo_modified_date timestamp,
	uspo_ponty_code varchar(15), --fk
	constraint PK_uspo_entity_id_and_uspo_number primary key(uspo_entity_id, uspo_number),
    constraint FK_uspo_entity_id foreign key (uspo_entity_id) references users.users (user_entity_id),
	constraint FK_uspo_ponty_code foreign key (uspo_ponty_code) references users.phone_number_type (ponty_code)
);


CREATE TABLE users.users_address(
	etad_addr_id int, --pk,fk reference ke table address pada module master
	etad_modified_date timestamp,
	etad_entity_id int, --fk
	etad_adty_id int, --fk reference ke table address_type pada module master
	constraint FK_etad_entity_id foreign key (etad_entity_id) references users.users (user_entity_id)
);


--references from other modules--
alter table users.users_skill add constraint FK_uski_skty_name foreign key (uski_skty_name) references master.skill_type(skty_name);
alter table users.users_experiences add constraint FK_usex_city_id foreign key (usex_city_id) references master.city(city_id);
alter table users.users_address add constraint FK_etad_addr_id foreign key (etad_addr_id) references master.address(addr_id);
alter table user_users_address add constraint FK_etad_adty_id foreign key (etad_adty_id) references master.address_type(adty_id);