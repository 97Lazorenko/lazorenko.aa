--типы замещающие %rowtype
create or replace type lazorenko_al.t_patient as object(
    patient_id number,
    born_date date,
    sex_id number
);
--нейминг t_...


--добавление собственного конструктора
alter type lazorenko_al.t_patient
add constructor function t_patient(
    patient_id number,
    born_date date,
    sex_id number
) return self as result
cascade;

--но тогда мы обязаны реализовать его в теле
create or replace type body lazorenko_al.t_patient
as
    constructor function t_patient(
        patient_id number,
        born_date date,
        sex_id number
    )
    return self as result
    as
    begin
        self.patient_id := patient_id;
        self.born_date := born_date;
        self.sex_id := sex_id;
        return;
    end;
end;



--массив
create or replace type lazorenko_al.t_arr_patient as table of lazorenko_al.t_patient;
--нейминг t_arr_...



--создадим еще типов
create or replace type lazorenko_al.t_documents_numbers as object(
    doc_num_id number,
    patient_id number,
    document_id number,
    value varchar2(50)
);

create or replace type lazorenko_al.t_arr_documents_numbers as table of lazorenko_al.t_documents_numbers;



--расширение типов
create or replace type lazorenko_al.t_extended_patient as object(
    patient lazorenko_al.t_patient, --использование типа внутри типа
    documents_numbers lazorenko_al.t_arr_documents_numbers
);