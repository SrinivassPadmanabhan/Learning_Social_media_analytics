library(tuber)
app_id="144955269209-teo1seclp7gmpfdkqs4l9jd264k5qf29.apps.googleusercontent.com"
app_secret="XqVEBFClRb7Q0vmUQkNDwbED"
yt_oauth(app_id=app_id, app_secret=app_secret, token='')
#to get the help
help(tuber)
video_stat = get_stats(video_id="y8HEZ-x4-_w")
View(video_stat)
video_details= get_video_details(video_id='y8HEZ-x4-_w')
View(as.data.frame(video_details))
all_comments=get_all_comments(video_id='PIDN8evvTwU')
search = yt_search(term = "kangaroo",channel_id = "UCYbge2419-UBBDyv6frJ3jA")
View(search)
channel_videos = list_channel_videos(channel_id = "UC56gTxNs4f9xZ7Pa2i5xNzg", max_results = 100000)
View(channel_videos)