# Klobouk board

Osobní BBS (technicky, asi?) pro osobní účely.

## install
```
gem install bcrypt
./util_setup.rb
./utik_add_user.rb <username> <password>
```

## config
`src/boards/index.json`:
```
[
    {
        "name": "<name>",
        "key": "<key>"
        "description": "<description>"
    }
    ...
]
```
