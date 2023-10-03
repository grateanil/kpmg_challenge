#!/bin/bash

# Function to get nested value from a JSON object
get_nested_value() {
  local object="$1"
  local key="$2"
  local value

  # Use jq to extract the value
  value=$(echo "$object" | jq -r ".$key")

  echo "$value"
}

# Example JSON objects
object1='{"a":{"b":{"c":"d"}}}'
object2='{"x":{"y":{"z":"a"}}}'

# Example keys
key1="a.b.c"
key2="x.y.z"

# Call the function with the objects and keys
value1=$(get_nested_value "$object1" "$key1")
value2=$(get_nested_value "$object2" "$key2")

# Print the results
echo "Example 1: Value for key '$key1': $value1"
echo "Example 2: Value for key '$key2': $value2"
