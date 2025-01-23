
import yaml

# Load the YAML content from the file
with open('acc.yaml', 'r', encoding='utf-8') as file:
    data = yaml.safe_load(file)

# Loop through each entry and update team_id and id
for item in data:
    if 'team_id' in item:
        item['team_id'] += 9  # Add 9 to the current team_id
        item['id'] = f'team{item["team_id"]}'  # Update the id to reflect the new team_id

# Convert back to YAML format
updated_yaml_content = yaml.dump(data, allow_unicode=True)

# Print the updated YAML content
print(updated_yaml_content)

# Optionally, you can write the updated content back to a new YAML file
with open('updated_teams.yaml', 'w', encoding='utf-8') as file:
    yaml.dump(data, file, allow_unicode=True)
