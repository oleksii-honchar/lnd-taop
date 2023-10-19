select * from get_all_albums(127);

#------------

select *
  from get_all_albums((
    select "ArtistId"
      from "Artist"
      where "Name" = 'Red Hot Chili Peppers'
  ));


 # -----------------

select Album, Duration
from "Artist",
     lateral get_all_albums("ArtistId")
where "Artist"."Name" = 'Red Hot Chili Peppers'; 


#-----------------
with four_albums as
(
   select "ArtistId"
     from "Album"
 group by "ArtistId"
   having count(*) = 4
)
  select "Artist"."Name", "Album", "Duration"
    from four_albums join "Artist" using("ArtistId"),
         lateral get_all_albums("ArtistId")
order by "ArtistId", "Duration" desc;