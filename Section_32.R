#===============SECTION 32: NLP================#

#libraries
install.packages('tm',repos='http://cran.us.r-project.org')
install.packages('twitteR',repos='http://cran.us.r-project.org')
install.packages('wordcloud',repos='http://cran.us.r-project.org')
install.packages('RColorBrewer',repos='http://cran.us.r-project.org')
install.packages('e1017',repos='http://cran.us.r-project.org')
install.packages('class',repos='http://cran.us.r-project.org')

library(tm)
library(twitteR)
library(wordcloud)
library(RColorBrewer)

#Connect to twitter
setup_twitter_oauth(consumer_key = "oAjxV71dfm35rxzeVXtm0XL5y", consumer_secret = "n2K5QYKvIAT2MtuqKi6UzNZm1i2NbNx8gC3HmgxWWSv49Kh3ka", access_token="2596859822-DHYuy81tjV4ITahiy7x8iYyd8pYxJAigGmb3FWn", access_secret="8MZHivu3ILishs8U8sUSRCWkuEKbZg5b2SPTn0fa8kXNj")

##search twitter
soccer.tweets <- searchTwitter('soccer',n=1000,lang="en")


soccer.text <- sapply(soccer.tweets, function(x) x$getText())

#Clean text data
soccer.text <- iconv(soccer.text, "UTF-8", "ASCII")

soccer.corpus <- Corpus(VectorSource(soccer.text))

##Document term matrix
term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
                                      control = list(removePunctuation = T,
                                                     stopwords=c("soccer", stopwords('english'),
                                                     removeNumbers=T,
                                                     tolower=T)))

#Convert term.doc.matrix into a matrix
term.doc.matrix <- as.matrix(term.doc.matrix)

word.freq <- sort(rowSums(term.doc.matrix),decreasing=T)
dm <- data.frame(word=names(word.freq), freq=word.freq)

#Wordcloud
wordcloud(dm$word, dm$freq, random.order=F, colors=brewer.pal(8,"Dark2"))
