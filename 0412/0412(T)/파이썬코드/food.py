from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
import pandas as pd
import time

# 크롬 드라이버 설정
options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

# 다이닝코드 URL 설정
keyword = "대전 맛집"
url = f"https://www.diningcode.com/list.php?query={keyword}"
driver.get(url) # driver -> 파이썬에서 직접 웹사이트를 열어본다
time.sleep(2) # 2초 기다려!


# 특정 div를 찾기 (Scroll__List__Section 클래스)
scroll_div = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CLASS_NAME, "Scroll__List__Section"))
)

# 스크롤 함수 정의
def scroll_in_div(div_element, pause_time=5):
    last_height = driver.execute_script("return arguments[0].scrollHeight;", div_element)
    while True:
        # div 내부 스크롤 내리기
        driver.execute_script("arguments[0].scrollBy(0, arguments[0].scrollHeight);", div_element)
        time.sleep(pause_time)  # 로딩 대기

        # 새로운 높이 계산
        new_height = driver.execute_script("return arguments[0].scrollHeight;", div_element)
        if new_height == last_height:  # 더 이상 로드할 데이터가 없으면 종료
            break
        last_height = new_height

# 스크롤 실행
scroll_in_div(scroll_div)

#페이지 소스 가져오기
html = driver.page_source
#페이지를 해석
soup = BeautifulSoup(html, 'html.parser') # parser(해석기)

# print(soup)
# 해석한 데이터를 추출
# 식당명, 평점, 카테고리 추출
restaurants = []
ratings = []
categories = [] 

# 반복문을 이용해서 식당 데이터 추출
for block in soup.find_all('a', class_='PoiBlock'): # find_all :해당 html 태그 전부 가져온다.
    try: # 시도하다
        #1. 식당명 추출
        name_tag = block.find('h2', id=lambda x:x and x.startswith('title')) #h2라는 html태그 조회
        # 남은 html 태그 제거하기
        name = name_tag.get_text(strip=True).split('. ')[-1].split(' <')[0].strip()
        restaurants.append(name) #식당명 추가
        #2. 평점 추출
        rating_tag = block.find('p', class_='UserScore') #p라는 html태그 조회
        rating = rating_tag.get_text(strip=True) # strip=True: 문자중에 // <- 기호 제거
        ratings.append(rating) #평점 추가
        #3. 카테고리 추출
        category_tag = block.find('p', class_='Category')
        category = category_tag.get_text(strip=True)
        categories.append(category)#카테고리 추가
    except Exception as e: #오류 발생하면?
        print('데이터 추출 실패!')

#데이터 프레임 생성
df = pd.DataFrame({'식당명' : restaurants, '평점' : ratings, '카테고리' : categories})
print(df)

# csv 전환
df.to_csv('food.csv', index=False, encoding='utf-8-sig')
print('크롤링 완료! food.csv 파일을 확인하세요.')