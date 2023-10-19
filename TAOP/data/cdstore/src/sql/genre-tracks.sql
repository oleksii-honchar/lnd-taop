-- name: tracks-by-genre
-- Get the count of tracks by genre
select "Genre"."Name", count(*) as count
from "Genre"
  left join "Track" using("GenreId")
group by "Genre"."Name"
order by count desc;
