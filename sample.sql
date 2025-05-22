-- CREATE TABLE employees (
--     id SERIAL PRIMARY KEY,
--     name TEXT NOT NULL,
--     department TEXT
-- );

-- INSERT INTO employees (name, department) VALUES
-- ('Alice', 'HR'),
-- ('Bob', 'IT'),
-- ('Charlie', 'Finance');

-- SELECT * FROM employees;



DO
$$
BEGIN

     IF NOT EXISTS(
     select 1 from information_schema.tables
     where table_name='customers' and table_schema='public'
     ) Then 
     create table customers(
     id serial primary key,
     name TEXT NOT NULL,
     email TEXT unique NOT NULL,
     is_active BOOLEAN default TRUE
     );
     end if;
    

    --step 2 insert into customers table

    insert into public.customers(name,email) values('Alice Johnson', 'alice@example.com')
    on CONFLICT (email) DO NOTHING;

       -- === Step #3: Update customer name ===
    UPDATE public.customers
    SET name = 'Alice J.'
    WHERE email = 'alice@example.com';

    --========step 3 perform operation

    PERFORM * FROM  customers; 


EXCEPTION
    WHEN OTHERS THEN 
        RAISE NOTICE 'error occured: %',SQLERRM;

end;
$$;



