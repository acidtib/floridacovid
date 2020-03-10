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
    "residents":12,
    "repatriated":5,
    "non_residents":1
  },
  "deaths": {
    "residents":2
  },
  "results": {
    "negative":140,
    "pending":115
  },
  "monitored": {
    "currently":302,
    "total":1104
  },
  "last_update":"7:55 a.m. ET 3/9/2020"
}
```

**Curl:**
```sh
curl -X GET "https://floridacovid.com/api/v1/cases"
```

**Browser:**
https://floridacovid.com/api/v1/cases