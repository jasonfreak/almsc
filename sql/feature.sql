--time
alter table mars_tianchi_features drop column month, drop column day, drop column season, drop column week, drop column weekday, drop column holiday, drop column n_holiday, drop column i_holiday; 
alter table mars_tianchi_features add (month int, day int, season int, week int, weekday int, holiday int, n_holiday int, i_holiday int);
update mars_tianchi_features
left join mars_tianchi_ds on mars_tianchi_features.ds = mars_tianchi_ds.ds set
mars_tianchi_features.month = mars_tianchi_ds.month,
mars_tianchi_features.day = mars_tianchi_ds.day,
mars_tianchi_features.season = mars_tianchi_ds.season,
mars_tianchi_features.week = mars_tianchi_ds.week,
mars_tianchi_features.weekday = mars_tianchi_ds.weekday,
mars_tianchi_features.holiday = mars_tianchi_ds.holiday,
mars_tianchi_features.n_holiday = mars_tianchi_ds.n_holiday,
mars_tianchi_features.i_holiday = mars_tianchi_ds.i_holiday;

--artist
select @begin_week_train:=week(min(ds)) from mars_tianchi_features where is_train = '1';
select @begin_week_test:=week(min(ds)) from mars_tianchi_features where is_train = '0';
alter table mars_tianchi_features drop column plays_last_1_week, drop column plays_last_2_week, drop column plays_last_3_week, drop column plays_last_4_week, drop column plays_last_5_week;
alter table mars_tianchi_features add(plays_last_1_week int, plays_last_2_week int, plays_last_3_week int, plays_last_4_week int, plays_last_5_week int);
update mars_tianchi_features set
mars_tianchi_features.plays_last_1_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_train - week(mars_tianchi_artist_actions.ds) = 1),
mars_tianchi_features.plays_last_2_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_train - week(mars_tianchi_artist_actions.ds) = 2),
mars_tianchi_features.plays_last_3_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_train - week(mars_tianchi_artist_actions.ds) = 3),
mars_tianchi_features.plays_last_4_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_train - week(mars_tianchi_artist_actions.ds) = 4),
mars_tianchi_features.plays_last_5_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_train - week(mars_tianchi_artist_actions.ds) = 5)
where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set
mars_tianchi_features.plays_last_1_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_test - week(mars_tianchi_artist_actions.ds) = 1),
mars_tianchi_features.plays_last_2_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_test - week(mars_tianchi_artist_actions.ds) = 2),
mars_tianchi_features.plays_last_3_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_test - week(mars_tianchi_artist_actions.ds) = 3),
mars_tianchi_features.plays_last_4_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_test - week(mars_tianchi_artist_actions.ds) = 4),
mars_tianchi_features.plays_last_5_week = (select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and @begin_week_test - week(mars_tianchi_artist_actions.ds) = 5)
where mars_tianchi_features.is_train = '0';