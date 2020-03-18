# Florida COVID

## API Document

### Endpoint
https://floridacovid.com/api/v1

### Cases

**Request:**
```json
GET /cases
```
**Successful Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "cases": {
    "total": 243,
    "residents": 216,
    "repatriated": 6,
    "non_residents": 21
  },
  "deaths": {
    "residents": 7
  },
  "results": {
    "negative": 1017,
    "pending": 1061
  },
  "monitored": {
    "currently": 832
  },
    "country": {
    "name": "US",
    "confirmed": 6362,
    "recovered": 17,
    "deaths": 108
  },
  "last_update": "2020-03-18 03:55:00 +0000"
}
```

**Curl:**
```sh
curl -X GET "https://floridacovid.com/api/v1/cases"
```

**Browser:**
https://floridacovid.com/api/v1/cases