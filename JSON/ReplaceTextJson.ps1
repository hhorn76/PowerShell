#Create variables
$var1 = "10"
$var2 = "above"

#Read JSON as text
$txtJson=‘{
"duration": $var1,
"operator": $var2,
"priority": "critical",
"threshold": "1",
"time_function": "all"
}‘
#Replace variables
$txtjson=$txtjson.replace(‘$var1‘,$var1)
$txtjson=$txtjson.replace(‘$var2‘,$var2)
$txtjson
