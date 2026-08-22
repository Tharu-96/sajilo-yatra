import os
import subprocess

def import_to_neon():
    # You can paste your Neon connection string directly here between the quotes
    # Example: "postgresql://neondb_owner:xxxx@ep-xxx.neon.tech/neondb?sslmode=require"
    neon_url = "postgresql://neondb_owner:npg_J2mzrLKGX5fO@ep-aged-band-ax2lp27h-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

    sql_file_path = "../../cloud_db_seed.sql"
    if not os.path.exists(sql_file_path):
        sql_file_path = "cloud_db_seed.sql" # fallback to current dir
        if not os.path.exists(sql_file_path):
            print("Error: Could not find cloud_db_seed.sql")
            return

    print("Connecting to Neon database and importing data... (this might take a few seconds)")
    try:
        subprocess.run(["psql", "-d", neon_url, "-f", sql_file_path], check=True)
        print("Success! All data has been perfectly imported to your Neon database.")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred during import: {e}")
    except FileNotFoundError:
        print("Error: 'psql' command not found. Please install PostgreSQL client tools.")

if __name__ == "__main__":
    import_to_neon()
