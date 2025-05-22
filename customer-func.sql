-- ===========================================================
-- JIRA Ticket: ABC-5678
-- Description: Upsert a customer and return the customer row
-- Script Author: Thavasumoorthi S
-- Date: YYYY-MM-DD
-- Environment: Development
-- Comments:
--   - Creates customers table if it doesn’t exist
--   - Inserts a new row or updates the existing one
--   - RETURNS the resulting row (id, name, email, is_active)
-- ===========================================================

CREATE OR REPLACE FUNCTION public.upsert_customer_func(
    p_name  TEXT,
    p_email TEXT
)
RETURNS public.customers AS
$$
DECLARE
    result_row public.customers%ROWTYPE;
BEGIN
    -- Step #1: Create table if not exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name   = 'customers'
    ) THEN
        EXECUTE 'CREATE TABLE public.customers (
                     id SERIAL PRIMARY KEY,
                     name TEXT NOT NULL,
                     email TEXT UNIQUE NOT NULL,
                     is_active BOOLEAN DEFAULT TRUE
                 )';
    END IF;

    -- Step #2: Upsert (INSERT … ON CONFLICT DO UPDATE)
    INSERT INTO public.customers (name, email)
    VALUES (p_name, p_email)
    ON CONFLICT (email) 
    DO UPDATE 
       SET name = EXCLUDED.name
    RETURNING * 
    INTO result_row;

    -- Step #3: Return the full row
    RETURN result_row;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in upsert_customer: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

