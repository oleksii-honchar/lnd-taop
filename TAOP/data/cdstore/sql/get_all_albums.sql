create or replace function get_all_albums
 (
   in  "ArtistId" bigint,
   out "Album"    text,
   out "Duration" interval
 )
returns setof record
language sql
as $$
  select "Title" as album,
         sum("Milliseconds") * interval '1 ms' as duration
    from "Album"
         join "Artist" using("ArtistId")
         left join "Track" using("AlbumId")
   where "ArtistId" = get_all_albums."ArtistId"
group by album
order by album;
$$;