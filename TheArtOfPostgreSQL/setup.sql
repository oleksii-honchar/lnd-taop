begin;

alter database taop
  set search_path
   to chinook,
      f1db,
      geolite,
      geoname,
      imdb,
      lastfm,
      magic,
      moma,
      opendata,
      sample,
      sandbox,
      twcache,
      tweet,
      public,
      raw;

create role cdstore with login in role taop inherit;
create role f1db    with login in role taop inherit;

alter role cdstore set search_path to chinook;
alter role f1db    set search_path to f1db;

commit;
