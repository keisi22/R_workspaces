# pip install ~~
# pip(필요한 기능 설치하는 명령어) == package.install
import requests # 인터넷 요청
from bs4 import BeautifulSoup # 해석 도구
import pandas as pd #데이터 프레임 생성

# 데이터 수집 
# 웹 크롤링(웹페이지 데이터를 가져오다)
# 네이버뉴스기사 가져와서 데이터프레임 생성 후 csv파일 변환

# 검색어 및 페이지 설정
query = "인공지능" #검색할 키워드
page = 1 #크롤링할 페이지

# 네이버 뉴스 검색 URL 생성
url = f"https://search.naver.com/search.naver?where=news&query={query}&start={(page - 1) * 10 + 1}"

# HTTP 요청 헤더 설정 (봇 차단 방지)
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}# 네이버 뉴스 URL 생성

# 요청보내고 HTML(웹 페이지,화면) 해석하기
response = requests.get(url, headers=headers) # 요청(requests)해서 데이터 get
soup = BeautifulSoup(response.text, 'html.parser') # parer(번역) 해줘!

# print(soup)
# 데이터 저장용 배열
titles = [] #기사 제목
links = [] #기사 링크

# 네이버 뉴스 기사 필터링
articles = soup.select('a.news_tit') # a.news_tit -> a태그에 class이름이 news_tit
for article in articles: #반복문
    links.append(article['href']) # append 배열(== 벡터)에 `추가하다`
    titles.append(article['title'])

# 데이터프레임 생성
# pd : pandas(파이썬에서 데이터프레임 생성 도구)
df = pd.DataFrame({'title' : titles, 'link' : links})
print(df)

# 데이터프레임을 csv파일로 변환
# utf-8-sig : 한글 깨짐 방지
# index = False : 엑셀 넘버링 비활성
df.to_csv('naver_news.csv', index = False, encoding='utf-8-sig')