#!/bin/bash
# Define your JSON string here. You could also load this from a file using `jq` directly.
json='{
    "corrected_files": {
        "src/configs/db.ts": "import { DataSource } from \"typeorm\";\nimport configData from \"./config\";\n\nexport const dataSource = new DataSource({\n  type: \"postgres\",\n  host: configData.postgres.host,\n  port: configData.postgres.port,\n  username: configData.postgres.username,\n  password: configData.postgres.password,\n  database: \"coffee-user-svcc\",\n  entities: [\"src/entities/*.ts\"], \n  synchronize: true,\n});"
    }
}'
correction_files=$(echo "${json}" | jq -r '.corrected_files')
# Loop through the JSON object
echo "${correction_files}" | jq -r 'to_entries[] | @base64' | while read -r line; do
    # Decode the base64 to get the original JSON string
    decoded=$(echo "${line}" | base64 --decode)
    # Extract the key (filename) and value (file content) using jq
    key=$(echo "${decoded}" | jq -r '.key')
    value=$(echo "${decoded}" | jq -r '.value')
    # Use the key as the filename and the value as the content, writing to the file
    echo "${value}" > "${key}"
    echo "Written to ${key}"
done
echo "All files have been created."