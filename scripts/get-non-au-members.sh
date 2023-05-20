#!/usr/bin/env bash

###
### THE FOLLOWING SCRIPT OUTPUTS TO offending_members.csv
###

club='team-australia'
club_url="https://api.chess.com/pub/club/$club/members"
all_time_usernames=$(curl -s $club_url | jq --raw-output '.all_time[].username')
correct_country_code='https://api.chess.com/pub/country/AU'

# echo $all_time_usernames
num_users=$(echo "$all_time_usernames" | wc -l)
echo "found $num_users players, this could take a while..."
touch offending_members.csv
count=0
spinstr='|/-\'
for member in $all_time_usernames
do
	member_info=$(curl -s "https://api.chess.com/pub/player/$member")
	name=$(echo $member_info |  jq --raw-output '.username')
	country=$(echo $member_info |  jq --raw-output '.country')
	if [[ "$country" != "$correct_country_code" ]]; then
		echo 'found one'
		echo "$name, $country" | tee -a offending_members.csv
	fi
	
	temp=${spinstr#?}
	printf " [%c]  " "$spinstr"
	spinstr=$temp${spinstr%"$temp"}
	sleep 0.01
	printf "\b\b\b\b\b\b"
done
printf "    \b\b\b\b"
echo "done."