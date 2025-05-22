-- CALL public.upsert_customer('Alice Johnson', 'alice@example.com');


SELECT * 
  FROM public.upsert_customer_func('Alice Newname', 'alice@example.com');
