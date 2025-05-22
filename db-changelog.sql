-- ===========================================================
-- JIRA Ticket: :TICKET
-- Description: Add new column is_active to users table
-- Script Author: John Doe
-- Date: YYYY-MM-DD
-- Environment: Production
-- Comments:
--   - Make sure no downtime is required
--   - Validate schema changes on staging before applying
--   - This script is idempotent (safe to run once)
-- ===========================================================

-- DO $$
-- BEGIN
--     -- === Change #1: Add column to users table ===
--     IF NOT EXISTS (
--         select 1 from information_schema.tables
--         where table_name='db_change_log' and table_schema='public'
--     ) THEN
--         create table db_change_log(
--         id serial primary KEY,
--         ticket_no text not null,
--         description text,
--         run_by text not null,
--         run_on date not null
--         );
--     END IF;

--     -- === Optional: Backfill or modify data ===
--     -- UPDATE public.users SET is_active = TRUE WHERE is_active IS NULL;

--     -- === Log to audit table (recommended) ===
--     INSERT INTO public.db_change_log (ticket_no, description, run_by, run_on)
--     VALUES (:'TICKET', 
--             'Add is_active column to users table', 
--             current_user, 
--             NOW());

-- EXCEPTION
--     WHEN OTHERS THEN
--         -- Rollback in case of error
--         RAISE NOTICE 'Error occurred, rolling back changes: %', SQLERRM;
--         ROLLBACK;
-- END;
-- $$;





-----------------------





-- ===========================================================
-- JIRA Ticket: :TICKET
-- Description: Add new column is_active to users table
-- Script Author: John Doe
-- Date: YYYY-MM-DD
-- Environment: Production
-- Comments:
--   - Make sure no downtime is required
--   - Validate schema changes on staging before applying
--   - This script is idempotent (safe to run once)
-- ===========================================================

-- 1) Create audit table if it doesn’t exist, with run_on TIMESTAMP
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
          FROM information_schema.tables
         WHERE table_schema = 'public'
           AND table_name   = 'db_change_log'
    ) THEN
        CREATE TABLE public.db_change_log (
            id          SERIAL PRIMARY KEY,
            ticket_no   TEXT NOT NULL,
            description TEXT,
            run_by      TEXT NOT NULL,
            run_on      TIMESTAMP NOT NULL
        );
    END IF;
END;
$$;

-- 2) Add the is_active column to users (if not already there)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
          FROM information_schema.columns
         WHERE table_name  = 'users' 
           AND column_name = 'is_active'
    ) THEN
        ALTER TABLE public.users
        ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
    END IF;
END;
$$;

-- 3) Log the change into db_change_log, now storing full timestamp (date + time)
INSERT INTO public.db_change_log (
    ticket_no,
    description,
    run_by,
    run_on
) VALUES (
    :'TICKET',
    'Add is_active column to users table',
    current_user,
    NOW()
);

