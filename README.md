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

### Stations

List all stations.
```
GET /api/stations

query for station_type:
GET /api/stations?station_type=standard
GET /api/stations?station_type=featured
GET /api/stations?station_type=sponsored
```

Station art
```
a url hosting the station art image is returned in the station json response
```

### Playlists

list a users playlists
```
GET /api/users/:user_id/playlists
```

Read
```
GET /api/playlists/:playlist_id
```

Create
```
POST /api/users/:user_id/playlists/
example data:
{
  playlist: {
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
PUT /api/playlists/:playlist_id
example data:
{
  playlist: {
    undergroundness: 3
  }
}
```

Delete
```
DELETE /api/playlists/:playlist_id
```

### Tracks

track is played, skipped, favorited or banned
```
POST /api/playlists/:playlist_id/tracks/:track_id/play
POST /api/playlists/:playlist_id/tracks/:track_id/skipped
POST /api/playlists/:playlist_id/tracks/:track_id/favorited
POST /api/playlists/:playlist_id/tracks/:track_id/banned
```
