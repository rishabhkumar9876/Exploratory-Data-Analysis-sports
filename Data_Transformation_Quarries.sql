

                                             --Ipl match Perfomance quarries--


--data cleaning and team_perfomance table
select id,season,case when team1='Rising Pune Supergiant' then 'Rising Pune Supergiants'
when team1='Delhi Daredevils' then 'Delhi Capitals' else team1 end as team1
,case when team2='Rising Pune Supergiant' then 'Rising Pune Supergiants' 
when team2='Delhi Daredevils' then 'Delhi Capitals' else team2 end as team2,
case when winner='Rising Pune Supergiant' then 'Rising Pune Supergiants' 
when winner='Delhi Daredevils' then 'Delhi Capitals'
when winner is null then 'no_result'
else winner end as winner,
case when toss_winner='Rising Pune Supergiant' then 'Rising Pune Supergiants' 
when toss_winner='Delhi Daredevils' then 'Delhi Capitals' else toss_winner end as toss_winner into #team_performance_table from matches;

select * from #team_performance_table;
--teams performance with each other

select * into #performance_to_eachother from (select id,season,team1,team2,winner from #team_performance_table
union 
select id,season,team2,team1,winner from #team_performance_table) as tables;


select * from #performance_to_eachother;

--winner and runner_up by season

with cte as (select season,max(id) as id from #team_performance_table group by season)
select cte.season,i.winner,case when i.winner=team1 then team2 else team1 end as runner_up from
cte join #team_performance_table i on cte.id=i.id order by 1;

--season,runner-up by winner
with cte as (select season,max(id) as id from #team_performance_table group by season),
cte2 as (select cte.season,i.winner,case when i.winner=team1 then team2 else team1 end as runner_up from
cte join #team_performance_table i on cte.id=i.id),
cte3 as (select winner,count(winner) as Total_Trophies,string_agg(season,',') within group (order by season) as season,
string_agg(runner_up,',') within group (order by season) runner_up_respectively from cte2 group by winner)
select ipl.winner,isnull(Total_Trophies,0) Total_Trophies,isnull(season,'-') as season,isnull(runner_up_respectively,'-') as runner_up_respectively from
cte3 right join (select distinct winner from #performance_to_eachother where not winner='no_result') as ipl
on ipl.winner=cte3.winner order by 2;

--total_match vs total_win of each team


with cte as (select winner,season,count(winner) total_win from #team_performance_table group by season,winner),
cte2 as(select season,team1 as team,count(team1) as total_match from #performance_to_eachother group by season,team1)
select cte.season,team,total_match,total_win from cte right join cte2 on winner=team and cte.season=cte2.season order by 1; 

                                                   --team color--

select * from team_and_color

                                                   --Bowler color--


select bowler,max(color) Bowler_color from deliveries d join Team_and_color t on d.bowling_team=t.Team group by bowler 

                                                    --batsman color--
select batsman,max(color) batsman_color from deliveries d join Team_and_color t on d.batting_team=t.Team group by batsman

	                                                 --fielder color--

select fielder,max(color) fielder_color from deliveries d join Team_and_color t on d.bowling_team=t.Team 
where fielder is not null group by fielder 

	                                                 --fielder color--
select player_of_match as Man_of_The_Match,max(color) fielder_color from matches m join Team_and_color t on m.winner=t.Team 
group by player_of_match


