import sys
import psycopg2

def seed(url):
    try:
        print("Connecting to SMVD Database...")
        conn = psycopg2.connect(url)
        cur = conn.cursor()

        # 1. Create the Admin User
        print("Creating Admin User...")
        cur.execute("""
            INSERT INTO "User" (id, email, name, "isAdmin", "createdAt", "updatedAt")
            VALUES ('admin-1', 'admin@streamaura.site', 'Admin', true, NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
        """)

        # 2. Create the Master API Key
        print("Creating API Key...")
        cur.execute("""
            INSERT INTO "ApiKey" (id, "userId", name, key, "isBlocked", "createdAt", "updatedAt")
            VALUES ('key-1', 'admin-1', 'StreamAuraKey', 'dk_6452f829837c4e5a9b2d1c3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a', false, NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
        """)

        conn.commit()
        cur.close()
        conn.close()
        print("\nSUCCESS!")
        print("========================================")
        print("Your SMVD API Key is: dk_6452f829837c4e5a9b2d1c3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a")
        print("========================================")
        print("You can now add this to your Main App on Render.")

    except Exception as e:
        print(f"\nERROR: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python seed_smvd.py \"YOUR_EXTERNAL_DATABASE_URL\"")
    else:
        seed(sys.argv[1])
