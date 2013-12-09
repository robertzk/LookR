##########
# INPUTS #
##########

# token = "Mkz9GRYoIhyuJ898YG89Ig"
# secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd"
# host = "demo.looker.com"
# port = 443

# TEST QUERIES #
LookerSetup(
	token = "Mkz9GRYoIhyuJ898YG89Ig", 
	secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd", 
	host = "demo.looker.com", 
	port = 443
)

LookerQuery(
	dictionary="thelook", 
	query="orders", 
	fields=c("orders.count", "users.count", "users.created_month"), 
	filters=c("orders.created_date:365 days", "users.created_date: 12 months ago for 10 months ")
)

LookerQuery(
	dictionary="thelook", 
	query="orders", 
	fields=c("users.created_month", "orders.count", "users.count"), 
	filters=c("orders.created_date:365 days", "users.created_date:365 days", "orders.is_first_purchase: Yes")
)

LookerQuery(
	dictionary="thelook", 
	query="orders", 
	fields=c("orders.count", "users.count", "users.created_month"), 
	filters=c("orders.created_date:365 days")
)