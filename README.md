Stationdose//Songsort
===================

A Ruby on Rails application serving up the Stationdose API.

## QuickStart

In the console

```
// Install project ruby gems
bundle install

// Create the database
bundle exec rake db:create

// Run migrations
bundle exec rake db:migrate

// Load development data
bundle exec rake db:data:load

// Start the server
bundle exec rails s

```
Now you are good to go. Open `http://localhost:3000` in a browser to test the endpoints

## Endpoints


### Spotify token swap/refresh

```
POST /api/spotify/swap
```

```
POST /api/spotify/refresh
```

Create a Stationdose session
```
POST /api/spotify/sessions
required params:
  access_token (a valid Spotify access_token)

example response:
{
  "user": {
    "id": 5,
    "auth_token": "nP1ZzmGUsd3eNKnB5mYUgq83sRE="
  }
}
```

### Stations

List all stations.
```
GET /api/stations

query for station_type:
GET /api/stations?station_type=standard
GET /api/stations?station_type=featured
GET /api/stations?station_type=sponsored
```

Generate tracks
```
POST /api/stations/:station_id/tracks
params:
  user_id // (optional) pass in a user_id to get back a favorited flag for each track
  ll // (optional) location string in the format "latitude,longitude" e.g. "37.1,45.63"
```

Read existing tracks
```
GET /api/stations/:station_id/tracks
params:
  user_id // (required, sort of. Returns an empty list when not supplied)
```

Station art
```
a url hosting the station art image is returned in the station json response
```

### Saved Stations

list a users saved_stations
```
GET /api/users/:user_id/saved_stations

response looks like: {
  "saved_stations": [...]
}
note: see below for example saved_station json
```

Read
```
GET /api/saved_stations/:saved_station_id

response will look like:
{
  "saved_station": {
    "id": 1,
    "undergroundness": true,
    "use_weather": false,
    "use_timeofday": false,
    "autoupdate": false,
    "updated_at": "2015-12-16T22:36:52.928Z",
    "station": {
      "id": 3,
      "name": "The Living Room",
      "short_description": "Modern rock that's not too hard. A little something for everyone.",
      "station_type": "standard",
      "url": "",
      "station_art": "https://s3-us-west-2.amazonaws.com/stationdose/Station+Art/stationArt-livingRoom.png"
    }
  }
}
```

Create
```
POST /api/users/:user_id/saved_stations/
example data:
{
  saved_station: {
    user_id: 1 (required),
    station_id: 1 (required)
    undergroundness: 2 (optional),
    use_weather: true (optional),
    use_timeofday: true (optional),
    autoupdate: true (optional)
  }
}
```

Update
```
PUT /api/saved_stations/:saved_station_id
example data:
{
  saved_station: {
    undergroundness: 3
  }
}
```

Delete
```
DELETE /api/saved_stations/:saved_station_id
```

Generate new tracks
```
POST /api/saved_stations/:saved_station_id/tracks
params: 
  user_id // (optional) pass in a user_id to get back a favorited flag for each track
  ll // (optional) location string in the format "latitude,longitude" e.g. "37.1,45.63"


response will look like:
{
  "tracks": [...],
  "meta": {
    "updated_at": "2015-12-16T22:31:18.356Z"
  }
}
```

Read existing tracks
```
GET /api/saved_stations/:saved_station_id/tracks
pass in a user_id to get back a favorited flag for each track


response will look like:
{
  "tracks": [...],
  "meta": {
    "updated_at": "2015-12-16T22:31:18.356Z"
  }
}
```

### Tracks

track is played, skipped, favorited or banned
```
POST /api/tracks/:track_id/play
POST /api/tracks/:track_id/skipped
POST /api/tracks/:track_id/favorited
POST /api/tracks/:track_id/unfavorited
POST /api/tracks/:track_id/banned

required params:
  user_id
  station_id
  saved_station_id (if there is one, this will remove the track from the saved
stations existing tracks)
```
