import wget

def makeRequest():
    url = 'http://www.futurecrew.com/skaven/song_files/mp3/razorback.mp3'
    filename = wget.download(url)


if __name__ == '__main__':
    makeRequest()