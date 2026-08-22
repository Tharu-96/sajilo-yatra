import os
import subprocess
from dotenv import load_dotenv

def export_database():
    """
    Exports the local PostgreSQL database to a dump.sql file.
    This file can be executed on Neon.tech to import all data.
    """
    load_dotenv()
    db_url = os.getenv("DATABASE_URL")
    
    if not db_url or "postgresql" not in db_url:
        print("Error: DATABASE_URL must be a PostgreSQL connection string in .env")
        return

    output_file = "cloud_db_seed.sql"
    print(f"Exporting local database to {output_file}...")
    
    try:
        # pg_dump requires the pg_dump command to be installed and in PATH
        subprocess.run(
            ["pg_dump", "--clean", "--if-exists", "--no-owner", "--no-privileges", "-f", output_file, db_url],
            check=True
        )
        print(f"Successfully exported to {output_file}")
        print("\nTo import to Neon.tech, run:")
        print(f"psql -d 'postgresql://<user>:<password>@<neon-host>/<db>?sslmode=require' -f {output_file}")
    except FileNotFoundError:
        print("Error: pg_dump tool not found. Make sure PostgreSQL client tools are installed.")
    except subprocess.CalledProcessError as e:
        print(f"Error during export: {e}")

if __name__ == "__main__":
    export_database()
