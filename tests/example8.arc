# Exemplo de interação com API externa
var tweets = async # Execução assíncrona
  from tweet in twitter.timeline
  where tweet.fromUser("one_user")
  select tweet;
# Percorre o vetor de tweets
for var tweet in tweets do
  tweet.replyTo("another_user", "Message");
  WriteLn(tweet);
end
# "async" é aconselhado para execução assíncrona, melhorando desempenho
var another_tweets = async from tweet in twitter.mentions()
where (tweet.timestamp between Date.Now - 7 and Date.Now - 1)
select tweet;
# variável "another_tweets" não é usada e será removida ;)