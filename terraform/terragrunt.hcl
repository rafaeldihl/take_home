inputs = {
  secrets = {
    secret1 = {
      name        = "testing/secret1"
      description = "This the first secret used for take-home coding task #2"
      value       = <<EOF
   {
    "name": "Example1Username",
    "password": "Example1Pass"
   }
EOF
    },
    secret2 = {
      name        = "testing/secret2"
      description = "This the second secret used for take-home coding task #2"
      value       = <<EOF
   {
    "key": "somestring"
   }
EOF
    }
  }
}
