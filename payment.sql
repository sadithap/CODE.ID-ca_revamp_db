-- MAIN QUERY || MODULE PAYMENT --


create table payment.bank (
	bank_entity_id int primary key,
	bank_code varchar(10) unique,
	bank_name varchar(55) unique,
	bank_modified_date timestamp
);

create table payment.fintech(
	fint_entity_id int primary key,
	fint_code varchar(10) unique,
	fint_name varchar(55) unique,
	fint_modified_date timestamp

);

create table payment.users_account(
	usac_bank_entity_id int,
	usac_user_entity_id int,
	usac_account_number varchar(25) unique,
	usac_saldo numeric,
	usac_type varchar(15),
	usac_start_date timestamp,
	usac_end_date timestamp,
	usac_modified_date timestamp,
	usac_status varchar(15),
	primary key (usac_bank_entity_id, usac_user_entity_id),
	foreign key (usac_bank_entity_id) references payment.bank(bank_entity_id),
	foreign key (usac_bank_entity_id) references payment.fintech(fint_entity_id)
);

create table payment.transaction_payment(
	trpa_id serial primary key,
	trpa_code_number varchar(55) unique,
	trpa_order_number varchar(25),
	trpa_debet numeric,
	trpa_credit numeric,
	trpa_type varchar(15),
	trpa_note varchar(255),
	trpa_modified_date timestamp,
	trpa_source_id varchar(25) not null,
	trpa_target_id varchar(25) not null,
	trpa_user_entity_id int
);

--------------------

-- ALTER ADD CONSTRAINT FOREIGN TO OTHER MODULES
alter table payment.bank
add constraint bank_bank_entity_id_fkey
foreign key (bank_entity_id)
references users.business_entity(entity_id);

alter table payment.fintech
add constraint fintech_fint_entity_id_fkey
foreign key (fint_entity_id)
references users.business_entity(entity_id);

alter table payment.users_account
add constraint users_account_usac_user_entity_id_fkey
foreign key (usac_user_entity_id)
references users.users(user_entity_id);

alter table payment.transaction_payment
add constraint transaction_payment_trpa_user_entity_id_fkey
foreign key (trpa_user_entity_id)
references users.users(user_entity_id);

-- SEQUENCE & FUNCTION --
DROP SEQUENCE IF EXISTS code_number;

CREATE SEQUENCE code_number_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 99999
    CYCLE;

CREATE OR REPLACE FUNCTION trpa_code_number_seq()
    RETURNS text AS $$
    DECLARE
        nextval_value integer;
        custom_sequence text;
    BEGIN
        SELECT nextval('code_number_seq') INTO nextval_value;
        custom_sequence := 'TR-' || to_char(current_timestamp, 'YYYYMMDD') || '-' || LPAD(nextval_value::text, 5, '0');
        RETURN custom_sequence;
    END;
    $$ LANGUAGE plpgsql;

--------------------
