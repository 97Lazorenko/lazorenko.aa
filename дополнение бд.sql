
create table patient_docs (
    docs_id number generated always as identity (
        start with 1 maxvalue 999999999999 minvalue 1 nocycle nocache noorder) primary key,
        passport varchar2(100),
        inipa  varchar2(100),
        itn varchar2(100),
        patient_id number references LAZORENKO_AL.patient(patient_id)
        );

