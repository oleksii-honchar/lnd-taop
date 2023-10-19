-- name: genre-top-n
-- Get the N top tracks by genre
/*
* the lateral left join implements a nested loop over
* the genres and allows to fetch our Top-N tracks per
* genre, applying the order by desc limit n clause.
*
* here we choose to weight the tracks by how many
* times they appear in a playlist, so we join against
* the playlisttrack table and count appearances.
*/

/*
* the join happens in the subquery's where clause, so
* we don't need to add another one at the outer join
* level, hence the "on true" spelling.
*/

select "Genre"."Name" as genre,
       case when length(ss.name) > 15
            then substring(ss.name from 1 for 15) || '…'
            else ss.name
        end as track,
       "Artist"."Name" as artist
  from "Genre"
       left join lateral
       (
          select "Track"."Name", "Track"."AlbumId", count("PlaylistId")
            from "Track"
                 left join "PlaylistTrack" using ("TrackId")
           where "Track"."GenreId" = "Genre"."GenreId"
        group by "Track"."TrackId"
        order by count desc
           limit :n
       ) ss(name, "AlbumId", count) on true
       join "Album" using("AlbumId")
       join "Artist" using("ArtistId")
order by "Genre"."Name", ss.count desc;
