#20-01-2021
install.packages("twitteR", dependencies=TRUE)
install.packages("ROAuth", dependencies=TRUE)
install.packages("stringr", dependencies=TRUE)
install.packages("ggplot2", dependencies=TRUE)
install.packages("httr", dependencies=TRUE)
install.packages("wordcloud", dependencies=TRUE)
install.packages("syzhuet", dependencies=TRUE)
install.packages("RCurl", dependencies=TRUE)
install.packages("tm", dependencies=TRUE)
install.packages("plyr", dependencies=TRUE)
install.packages("dplyr", dependencies=TRUE)

library(twitteR)
library(ROAuth)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(httr)
library(wordcloud)
library(RCurl)
library(syuzhet)
library(tm)
oauth_endpoint(authorize = "https://api.twitter.com/oauth",access = "https://api.twitter.com/oauth/access_token")
#URL's
reqURL <- 'https://api.twitter.com/oauth/request_token'
accessURL <- 'https://api.twitter.com/oauth/access_token'
authURL <- 'https://api.twitter.com/oauth/authorize'

#Auth Tokens
consumerKey="q4apuDo5CmoqIEDxpCyWqqN5g" #Replace with your consumerKey
consumerSecret="F9IPqjWlQub3tdkKYu6DZZ2NgqUNDwJGz6NoV1GNtrC1xyYm3p" #Replace with your consumerSecret
bearerToken = "AAAAAAAAAAAAAAAAAAAAAIG0LwEAAAAAoB5DE8J86aaRBthppTJ8hQge12I%3DqT1PDeCj2zUe4el49gDrtZx6SD4w3qUsnwVRSaITaQCAEliq2H"
accesstoken="1351533938498437122-WOPopiiWmt0UHuOAYVCoOAHIHRe8hp" #Replace with your accesstoken
accesssecret="qPDK5uQHfXWcH7Ynsv2pkwIYouhTlCDb2GTyQ0exHh8la" #Replace with your accesssecret
?setup_twitter_oauth
#to setup the auth ke for the Twitter
setup_twitter_oauth(consumer_key=consumerKey, consumer_secret=consumerSecret, access_token =accesstoken, access_secret = accesssecret)

#trend location
trend_locations <- availableTrendLocations()
View(trend_locations)
city_woeid = subset(trend_locations, name == "Chennai")$woeid
trends = getTrends(city_woeid)
View(trends)
Hashtags = searchTwitter("#rajini", n=5000,lang = "en")
length(Hashtags)
#View(Hashtags)
#ISO 639-1
tweets = Hashtags
#?idply
tweets_df <- ldply(tweets, function (t) t$toDataFrame())
#View(tweets_df)
write.csv(tweets_df, "E:\\SCMHRD\\Academics\\Sem - 2\\Social Media Analytics\\tweets_df.csv")
#View(tweets_df$text)
#to get the tweets we are using this command
txt = sapply(Hashtags, function(x) x$getText())
  
View(txt)
length(txt)
# to remove the rt via, @ symbol from the text
txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","", txt)
#View(txt)
#to remove the hyper links
txt = gsub("http[^[:blank:]]+", "", txt)
#to remove the username that is any word starts with @
txt = gsub("@\\w+","", txt)
txt

#to remove punctuation
txt = gsub("[[:punct:]]", " ", txt)

#to remove alpha numeric
txt = gsub("[^[:alnum:]]", " ", txt)

# Create Corpus
txt = Corpus(VectorSource(txt))


# Convert to lower case
txt = tm_map(txt, content_transformer(tolower))

# Remove all stop words
txt = tm_map(txt, removeWords, stopwords("english"))

# remove all white spaces
txt = tm_map(txt, stripWhitespace)
txt$content


# Step 4 --> Data modeling
'''
In this dark2 is the color pallet and 8 is the corresponding number of the pallete
to change the colour pallete use this command
?brewer
'''
#?brewer
pal <- brewer.pal(8,"Dark2")
wordcloud(txt, min.freq = 15, max.words = 500, width=10000, height =30500, random.order = FALSE, color=pal)

#sentimental analysis
mysentiment <- get_nrc_sentiment(txt$content)
SentimentScores <- data.frame(colSums(mysentiment[,]))
names(SentimentScores) <- "Score"
SentimentScores <- cbind("sentiment" = rownames(SentimentScores), SentimentScores)
rownames(SentimentScores) <- NULL
ggplot(data = SentimentScores, aes(x = sentiment, y = Score)) +
geom_bar(aes(fill = sentiment), stat = "identity") +
theme(legend.position = "none") +
xlab("Sentiment") + ylab("Score") + ggtitle("Total Sentiment Score Based on Tweets")



