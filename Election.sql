create database election;
use election;
show tables; 
CREATE TABLE constituencywise_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sn INT,
    candidate VARCHAR(255),
    party VARCHAR(255),
    evm_votes INT,
    postal_votes INT,
    total_votes INT,
    percentage DECIMAL(5,2),
    constituency_id VARCHAR(10)
);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/constituencywise_details.csv'
INTO TABLE constituencywise_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(sn, candidate, party, evm_votes, postal_votes, total_votes, percentage, constituency_id);
describe constituencywise_details;
describe constituencywise_results;
describe partywise_results;
describe states;
describe statewise_results;
select * from constituencywise_details;
select * from constituencywise_results;
select * from partywise_results;
select * from states;
select * from statewise_results;


-- INDIA GENERAL ELECTIonS RESULT ANALYSIS 2024---
select count(distinct(Parliament_Constituency)) as Total_Seats from constituencywise_results ;

-- What is the total number of seats available for elections in each state--
select s.state as State_Name, count(distinct(cr. Parliament_Constituency)) as total_no_of_seats from
statewise_results sr join states s on sr.State_ID = s.State_ID
join constituencywise_results cr on sr.Parliament_Constituency = cr.Parliament_Constituency
group by s.State order by s.State;

-- Total Seats Won by NDA Allianz
select sum(case when party in (
'Bharatiya Janata Party - BJP','Telugu Desam - TDP','Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS','AJSU Party - AJSUP','Apna Dal (Soneylal) - ADAL', 
'asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD','Sikkim Krantikari Morcha - SKM'
 ) then Won else 0 end) as NDA_Total_Seats_Won
from partywise_results;

-- Total Seats Won by INDIA Allianz
select sum(case when party in (
'Indian National Congress - INC','Aam Aadmi Party - AAAP','All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP','Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI','Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML','Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM','Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC','Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP','Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP','Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK') then Won else 0 end) as INDIA_Total_Seats_Won
from partywise_results;

-- Seats Won by NDA Allianz Parties
select Party, Won as Seat_won from partywise_results where Party in (
'Bharatiya Janata Party - BJP','Telugu Desam - TDP','Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS','AJSU Party - AJSUP','Apna Dal (Soneylal) - ADAL', 
'asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD','Sikkim Krantikari Morcha - SKM')
order by Seat_won desc; 

-- Seats Won by INDIA Allianz Parties
select Party, Won as Seat_won from partywise_results where Party in (
'Indian National Congress - INC','Aam Aadmi Party - AAAP','All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP','Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI','Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML','Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM','Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC','Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP','Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP','Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK')
order by Seat_won desc; 

-- Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER
alter table partywise_results add party_alliance varchar(50);

-- I.N.D.I.A Allianz --
update partywise_results set party_alliance = 'I.N.D.I.A' where party in (
'Indian National Congress - INC','Aam Aadmi Party - AAAP','All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP','Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI','Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML','Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM','Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC','Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP','Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP','Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK');

-- NDA Allianz --

update partywise_results set party_alliance = 'N.D.A' where party in (
'Bharatiya Janata Party - BJP','Telugu Desam - TDP','Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS','AJSU Party - AJSUP','Apna Dal (Soneylal) - ADAL', 
'asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD','Sikkim Krantikari Morcha - SKM');

-- OTHER --
update partywise_results set party_alliance = 'OTHER' where party_alliance is null;

-- Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?
select p.party_alliance, count(cr.Constituency_ID) as Seats_won from
partywise_results p join constituencywise_results cr on p.Party_ID = cr.Party_ID
group by party_alliance order by Seats_won desc;

-- Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency? --
select cr.Winning_Candidate, p.Party, p.party_alliance, cr.Total_Votes, cr.Margin, cr.Constituency_Name, s.State
from constituencywise_results cr join partywise_results p on cr.Party_ID = p.Party_ID
join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s on sr.State_ID = s.State_ID where s.State = 'Rajasthan' and cr.Constituency_Name = 'JAIPUR';

-- What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?--

select cd.Candidate,cd.Party,cd.EVM_Votes,cd.Postal_Votes,cd.Total_Votes,cr.Constituency_Name
from constituencywise_details cd join constituencywise_results cr on cd.Constituency_ID = cr.Constituency_ID
where cr.Constituency_Name = 'JAIPUR' order by cd.Total_Votes desc;

-- Which parties won the most seats in s State, and how many seats did each party win?--
select p.Party,COUNT(cr.Constituency_ID) as Seats_Won from constituencywise_results cr 
join partywise_results p on cr.Party_ID = p.Party_ID
join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s on sr.State_ID = s.State_ID where s.state = 'Tamil Nadu'
group by p.Party order by Seats_Won desc;

-- What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024
select s.State as State_Name,
    sum(case when p.party_alliance = 'N.D.A' then 1 else 0 end) as NDA_Seats_Won,
    sum(case when p.party_alliance = 'I.N.D.I.A' then 1 else 0 end) as INDIA_Seats_Won,
	sum(case when p.party_alliance = 'OTHER' then 1 else 0 end) as OTHER_Seats_Won
from constituencywise_results cr join partywise_results p on cr.Party_ID = p.Party_ID
join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s on sr.State_ID = s.State_ID where p.party_alliance IN ('N.D.A', 'I.N.D.I.A',  'OTHER')  -- Filter for NDA and INDIA alliances
group by s.State order by s.State;

-- Which candidate received the highest number of EVM votes in each constituency (Top 10)?
select cr.Constituency_Name, cd.Constituency_ID, cd.Candidate,cd.EVM_Votes
from constituencywise_details cd join (select Constituency_ID,
MAX(EVM_Votes) as Max_EVM_Votes from constituencywise_details
group by Constituency_ID) mx
on cd.Constituency_ID = mx.Constituency_ID and cd.EVM_Votes = mx.Max_EVM_Votes
join constituencywise_results cr on cd.Constituency_ID = cr.Constituency_ID
order by cd.EVM_Votes desc limit 10;

-- Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
WITH RankedCandidates as (
    select cd.Constituency_ID,cd.Candidate,cd.Party,cd.EVM_Votes,cd.Postal_Votes,
    cd.EVM_Votes + cd.Postal_Votes as Total_Votes,
    ROW_NUMBER() OVER (PARTITIon BY cd.Constituency_ID order by cd.EVM_Votes + cd.Postal_Votes DESC) as VoteRank
    from constituencywise_details cd join constituencywise_results cr on cd.Constituency_ID = cr.Constituency_ID
    join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
    join states s on sr.State_ID = s.State_ID where s.State = 'Maharashtra')
select cr.Constituency_Name,
    MAX(CasE WHEN rc.VoteRank = 1 THEN rc.Candidate END) as Winning_Candidate,
    MAX(CasE WHEN rc.VoteRank = 2 THEN rc.Candidate END) as Runnerup_Candidate
from RankedCandidates rc join constituencywise_results cr on rc.Constituency_ID = cr.Constituency_ID
group by cr.Constituency_Name order by cr.Constituency_Name;

-- For the state of Maharashtra, what are the total number of seats, total number of candidates, total number of parties, total votes (including EVM and postal), and the breakdown of EVM and postal votes?
select count(distinct cr.Constituency_ID) as Total_Seats,count(distinct cd.Candidate) as Total_Candidates,
count(distinct p.Party) as Total_Parties,sum(cd.EVM_Votes + cd.Postal_Votes) as Total_Votes,
sum(cd.EVM_Votes) as Total_EVM_Votes,sum(cd.Postal_Votes) as Total_Postal_Votes
from  constituencywise_results cr
join constituencywise_details cd on cr.Constituency_ID = cd.Constituency_ID
join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s on sr.State_ID = s.State_ID join partywise_results p on cr.Party_ID = p.Party_ID
where s.State = 'Maharashtra';
