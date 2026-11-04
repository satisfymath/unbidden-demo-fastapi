-- A role that can only read, for an observer that must never write to the application's data.
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'unbidden_ro') THEN
    CREATE ROLE unbidden_ro LOGIN PASSWORD 'demo-readonly-password';
  END IF;
END $$;
GRANT CONNECT ON DATABASE app TO unbidden_ro;
GRANT USAGE ON SCHEMA public TO unbidden_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO unbidden_ro;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO unbidden_ro;
