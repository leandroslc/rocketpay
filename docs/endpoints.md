
# Endpoints

## `POST` `/api/users`
Creates a new user with a new empty account.

### Body _(json)_
```json
{
  "name": "<name>",
  "age": "<age>",
  "email": "<email>",
  "password": "<password>",
  "nickname": "<nickname>"
}
```


## `POST` `/api/signin`
Authenticates an user and returns a token.

### Body _(json)_
```json
{
  "email": "<email>",
  "password": "<password>"
}
```


## `PUT` `api/accounts/:id/deposit`
Deposit a value within the given account.

### Params _(route)_
- `id` - The account id associated with the current user.

### Body _(json)_
```json
{
  "value": "<amount>"
}
```

### Authentication
Bearer


## `PUT` `/api/accounts/:id/withdraw`
Withdraw a value from the given account.

### Params _(route)_
- `id` - The account id associated with the current user.

### Body _(json)_
```json
{
  "value": "<amount>"
}
```

### Authentication
Bearer


## `POST` `/api/accounts/transaction`
Makes a transaction of the given amount from one account to another.

### Body _(json)_
```json
{
  "to": "<account id>",
  "from": "<account id>",
  "value": "<amount>"
}
```

### Authentication
Bearer
