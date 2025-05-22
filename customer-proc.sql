CREATE OR REPLACE PROCEDURE public.upsert_customer(
    IN p_name TEXT,
    IN p_email TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step #1: Create table if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_name = 'customers' AND table_schema = 'public'
    ) THEN
        CREATE TABLE public.customers (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            is_active BOOLEAN DEFAULT TRUE
        );
    END IF;

    -- Step #2: Insert customer if not exists
    INSERT INTO public.customers (name, email)
    VALUES (p_name, p_email)
    ON CONFLICT (email) DO NOTHING;

    -- Step #3: Update customer name
    UPDATE public.customers
    SET name = 'Alice J.'
    WHERE email = p_email;

    -- Step #4: Just for demo - show a message (you can use SELECT instead)
    RAISE NOTICE 'Customer % updated or inserted successfully', p_email;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$;
