-- ResumeSync Pro Database Initialization Script
  -- This script sets up the database with proper extensions, 
  schemas, and initial configuration

  -- Enable required PostgreSQL extensions
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
  CREATE EXTENSION IF NOT EXISTS "pg_trgm";
  CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
  CREATE EXTENSION IF NOT EXISTS "btree_gin";

  -- Set timezone
  SET timezone = 'UTC';

  -- Create schemas for better organization
  CREATE SCHEMA IF NOT EXISTS public;
  CREATE SCHEMA IF NOT EXISTS audit;
  CREATE SCHEMA IF NOT EXISTS analytics;

  -- Create audit trigger function for tracking changes
  CREATE OR REPLACE FUNCTION audit.audit_trigger_func()
  RETURNS TRIGGER AS $$
  BEGIN
      IF TG_OP = 'INSERT' THEN
          INSERT INTO audit.audit_log (
              table_name,
              operation,
              new_data,
              changed_by,
              changed_at
          ) VALUES (
              TG_TABLE_NAME,
              'INSERT',
              row_to_json(NEW),
              current_user,
              NOW()
          );
          RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
          INSERT INTO audit.audit_log (
              table_name,
              operation,
              old_data,
              new_data,
              changed_by,
              changed_at
          ) VALUES (
              TG_TABLE_NAME,
              'UPDATE',
              row_to_json(OLD),
              row_to_json(NEW),
              current_user,
              NOW()
          );
          RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
          INSERT INTO audit.audit_log (
              table_name,
              operation,
              old_data,
              changed_by,
              changed_at
          ) VALUES (
              TG_TABLE_NAME,
              'DELETE',
              row_to_json(OLD),
              current_user,
              NOW()
          );
          RETURN OLD;
      END IF;
      RETURN NULL;
  END;
  $$ LANGUAGE plpgsql;

  -- Create audit log table
  CREATE TABLE IF NOT EXISTS audit.audit_log (
      id SERIAL PRIMARY KEY,
      table_name TEXT NOT NULL,
      operation TEXT NOT NULL CHECK (operation IN ('INSERT',
  'UPDATE', 'DELETE')),
      old_data JSONB,
      new_data JSONB,
      changed_by TEXT DEFAULT current_user,
      changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  -- Create indexes for audit log
  CREATE INDEX IF NOT EXISTS idx_audit_log_table_name ON
  audit.audit_log(table_name);
  CREATE INDEX IF NOT EXISTS idx_audit_log_operation ON
  audit.audit_log(operation);
  CREATE INDEX IF NOT EXISTS idx_audit_log_changed_at ON
  audit.audit_log(changed_at);
  CREATE INDEX IF NOT EXISTS idx_audit_log_changed_by ON
  audit.audit_log(changed_by);

  -- Create analytics schema tables for tracking usage
  CREATE TABLE IF NOT EXISTS analytics.daily_stats (
      id SERIAL PRIMARY KEY,
      date DATE NOT NULL UNIQUE,
      total_users INTEGER DEFAULT 0,
      active_users INTEGER DEFAULT 0,
      new_registrations INTEGER DEFAULT 0,
      resumes_uploaded INTEGER DEFAULT 0,
      resumes_optimized INTEGER DEFAULT 0,
      api_requests INTEGER DEFAULT 0,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  CREATE INDEX IF NOT EXISTS idx_daily_stats_date ON
  analytics.daily_stats(date);

  -- Create performance optimization settings
  ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
  ALTER SYSTEM SET pg_stat_statements.track = 'all';
  ALTER SYSTEM SET log_statement = 'ddl';
  ALTER SYSTEM SET log_min_duration_statement = 1000;

  -- Create custom data types for enums
  DO $$ BEGIN
      CREATE TYPE user_role AS ENUM ('user', 'admin',
  'super_admin');
  EXCEPTION
      WHEN duplicate_object THEN null;
  END $$;

  DO $$ BEGIN
      CREATE TYPE subscription_plan AS ENUM ('free', 'pro',
  'enterprise');
  EXCEPTION
      WHEN duplicate_object THEN null;
  END $$;

  DO $$ BEGIN
      CREATE TYPE subscription_status AS ENUM ('active', 'inactive',
   'cancelled', 'expired', 'trial');
  EXCEPTION
      WHEN duplicate_object THEN null;
  END $$;

  DO $$ BEGIN
      CREATE TYPE resume_status AS ENUM ('draft', 'processing',
  'completed', 'error');
  EXCEPTION
      WHEN duplicate_object THEN null;
  END $$;

  DO $$ BEGIN
      CREATE TYPE optimization_status AS ENUM ('pending',
  'processing', 'completed', 'failed');
  EXCEPTION
      WHEN duplicate_object THEN null;
  END $$;

  -- Create function to update updated_at column
  CREATE OR REPLACE FUNCTION public.update_updated_at_column()
  RETURNS TRIGGER AS $$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  -- Create function to generate slugs
  CREATE OR REPLACE FUNCTION public.generate_slug(input_text TEXT)
  RETURNS TEXT AS $$
  BEGIN
      RETURN lower(trim(regexp_replace(input_text, '[^a-zA-Z0-9]+',
  '-', 'g'), '-'));
  END;
  $$ LANGUAGE plpgsql;

  -- Create function for full-text search ranking
  CREATE OR REPLACE FUNCTION public.search_rank(
      document tsvector,
      query tsquery,
      boost_factor FLOAT DEFAULT 1.0
  ) RETURNS FLOAT AS $$
  BEGIN
      RETURN ts_rank_cd(document, query) * boost_factor;
  END;
  $$ LANGUAGE plpgsql;

  -- Set up database configuration for optimal performance
  ALTER DATABASE resumesync_db SET synchronous_commit = 'on';
  ALTER DATABASE resumesync_db SET wal_level = 'replica';
  ALTER DATABASE resumesync_db SET max_wal_senders = 3;
  ALTER DATABASE resumesync_db SET wal_keep_segments = 32;

  -- Grant appropriate permissions
  GRANT USAGE ON SCHEMA public TO resumesync;
  GRANT USAGE ON SCHEMA audit TO resumesync;
  GRANT USAGE ON SCHEMA analytics TO resumesync;
  GRANT ALL ON ALL TABLES IN SCHEMA public TO resumesync;
  GRANT ALL ON ALL TABLES IN SCHEMA audit TO resumesync;
  GRANT ALL ON ALL TABLES IN SCHEMA analytics TO resumesync;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO resumesync;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA audit TO resumesync;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA analytics TO resumesync;

  -- Create notification function for real-time updates
  CREATE OR REPLACE FUNCTION public.notify_table_change()
  RETURNS TRIGGER AS $$
  BEGIN
      PERFORM pg_notify(
          'table_change',
          json_build_object(
              'table', TG_TABLE_NAME,
              'operation', TG_OP,
              'id', COALESCE(NEW.id, OLD.id)
          )::text
      );

      IF TG_OP = 'DELETE' THEN
          RETURN OLD;
      ELSE
          RETURN NEW;
      END IF;
  END;
  $$ LANGUAGE plpgsql;

  -- Log successful initialization
  INSERT INTO audit.audit_log (table_name, operation, new_data,
  changed_by, changed_at)
  VALUES ('database', 'INITIALIZE', '{"message": "Database 
  initialized successfully"}', 'system', NOW());

  -- Print success message
  DO $$
  BEGIN
      RAISE NOTICE 'ResumeSync Pro database initialization completed
   successfully';
      RAISE NOTICE 'Extensions enabled: uuid-ossp, pg_trgm, 
  pg_stat_statements, btree_gin';
      RAISE NOTICE 'Schemas created: public, audit, analytics';
      RAISE NOTICE 'Custom types created: user_role, 
  subscription_plan, subscription_status, resume_status, 
  optimization_status';
      RAISE NOTICE 'Helper functions created: audit_trigger_func, 
  update_updated_at_column, generate_slug, search_rank';
  END $$;