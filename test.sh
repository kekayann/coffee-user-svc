
response={"corrected_files":{"src/configs/db.ts":"import { DataSource } from \"typeorm\";\nimport configData from \"./config\";\n\nexport const dataSource = new DataSource({\n  type: \"postgres\",\n  host: configData.postgres.host,\n  port: configData.postgres.port,\n  username: configData.postgres.username,\n  password: configData.postgres.password,\n  database: configData.postgres.database,\n  entities: [\"src/entities/*.ts\"], \n  synchronize: true,\n  logging: true, // Add this line\n});"}}


files=$(echo "$response" | jq -r '.corrected_files | to_entries | map("\(.key)=\(.value)") | .[]')

# Loop through each file and save its contents
for file in $files; do
    file_path=$(echo "$file" | cut -d'=' -f1)
    file_content=$(echo "$file" | cut -d'=' -f2)

    echo "Modifying file: $file_path"
    echo "$file_content" > "$file_path"
done