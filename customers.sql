-- ===========================================================
-- JIRA Ticket: ABC-5678
-- Description: Create customers table and perform insert/update/select
-- Script Author: Thavasumoorthi S
-- Date: YYYY-MM-DD
-- Environment: Development
-- Comments:
--   - Includes basic transaction example
--   - Demonstrates INSERT, UPDATE, SELECT
--   - Safe to run multiple times (idempotent table creation)
-- ===========================================================

DO 
$$
BEGIN
    -- === Step #1: Create customers table if not exists ===
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

    -- === Step #2: Insert sample customer ===
    INSERT INTO public.customers (name, email)
    VALUES ('Alice Johnson', 'alice@example.com')
    ON CONFLICT (email) DO NOTHING;

    -- === Step #3: Update customer name ===
    UPDATE public.customers
    SET name = 'Alice J.'
    WHERE email = 'alice@example.com';

    -- === Step #4: Select customer to verify ===
    PERFORM * FROM public.customers WHERE email = 'alice@example.com';

EXCEPTION 
    WHEN OTHERS THEN
        -- Rollback is automatic inside DO block if exception is not handled
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$;
-- $$;
