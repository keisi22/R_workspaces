library(dplyr)
netflix=read.csv('netflix.csv')
#View(netflix)


#문제 1: 데이터프레임의 앞부분 출력 단, 2행만
#print(head(netflix,2))

#문제 2: 데이터프레임의 뒷부분 출력 단, 5행만
#print(tail(netflix, 5))

#문제 3: 데이터프레임의 구조 확인
#print(dim(netflix))
#print(str(netflix)) # 시험 출제시 정답으로 간주

#문제 4: 특정 열 title 선택하기
result=netflix%>% select(title)
#print(result)

#문제 3: 데이터셋에서 title, type, release_year 열만 선택하세요.
result=netflix%>% select(title, type, release_year)
#print(result)

#문제 4: 데이터셋에서 title, country, rating 열만 선택하세요.
result=netflix%>% select(title, country, rating)
#print(result)

#문제 5: 2021년에 출시된 영화만 필터링하세요.
result= netflix%>% filter(release_year==2021)
#print(result)

#문제 6: TV-MA 등급의 TV 프로그램만 필터링하세요.
result=netflix%>% filter(rating=='TV-MA' & type=='TV Show')

#문제 7: director가 "Mike Flanagan"인 영화의 
#title, director, country 열을 선택하세요.
result=netflix%>% filter(director=='Mike Flanagan' & type=='Movie')%>%
  select(title, director, country)

#문제 8: duration 열에서 영화의 길이가 분 단위로 제공됩니다.
#영화(type == "Movie")의 경우, duration 값을 숫자형 데이터로 변환하고 
#새로운 열 duration_minutes를 추가하세요.
result=netflix%>% filter(type=='Movie')%>%
  mutate(duration_minutes=as.numeric(gsub(' min', '', duration)))

#문제 9: 영화(type == "Movie")를 기준으로, 
#release_year(출시 연도)를 내림차순으로 정렬하세요.
result=netflix%>% filter(type=='Movie')%>%
  arrange(desc(as.Date(release_year)))

#문제 10: TV 프로그램(type == "TV Show") 중 
#시즌 수(duration)를 기준으로 오름차순으로 정렬하세요.
# duration 컬럼에 숫자와 문자가 존재
# 문자열을 제거(특정 문자로 대체) -> gsub
# []?
# 텍스트 데이터에서 숫자만 추출 뒤 정렬하는게 중요!!
result=netflix%>% filter(type=='TV Show')%>%
  mutate(duration_seasons=as.numeric(gsub(' Season[s]?', '', duration)))%>%
 arrange(duration_seasons)

#문제 11: type 열을 기준으로 데이터를 그룹화하고,
#각 그룹에 대해 콘텐츠의 총 개수와 평균 release_year를 계산하세요.
#결과 데이터프레임은 type, total_count, average_release_year 열을 포함해야 합니다.
result=netflix%>% group_by(type)%>%
  summarise(total_count=n(), average_release_year=mean(release_year, na.rm=TRUE))

# 2021년에 추가된 영화의 평균길이를 구하세요
# filter
# mean
# summarise
# gsub -> as.numeric
#result=netflix %>%
#  filter(type=='Movie' & as.Date(date_added>=2021-01-01 & date_added<=2021-12-31)%>%
#  summarise(avg_duration=mean(as.numeric(gsub(' min', '', duration))))
  
#result=netflix %>%
#  filter(type=='Movie' & as.Date(format(date_added, '%Y')==2021))%>%
#  summarise(avg_duration=mean(as.numeric(gsub(' min', '', duration))))
  
# 2021년에 제작된 영화의 평균길이를 구하세요
result=netflix %>%
  filter(type=='Movie' & release_year==2021)%>%
  summarise(avg_duration=mean(as.numeric(gsub(' min', '', duration))))
  
# 년도별 제작된 영화의 평균길이를 구하세요
result=netflix%>% filter(type=='Movie')%>%
  group_by(release_year)%>%
  summarise(avg_duration=mean(as.numeric(gsub(' min', '', duration)), na.rm=TRUE))
  #View(result)
  
# 장르가 코메디인 영화의 제목
# listed_in %in% c('Comedies') : listed_in에 Comedies가 포함되어 있는지 체크
result=netflix%>%
  filter(type=='Movie' & listed_in %in% c('Comedies'))%>%
  select(title)
  
# 'International TV Shows' 장르에 속하고, TV-MA 등급인
# TV Show의 title과 제작 국가 추출하시오
result= netflix %>%
  filter(type== 'TV Show' & rating=='TV-MA' & listed_in %in% c('International TV Shows'))%>%
  select(title, country)
  
# nrow() : 행 개수 number of rows
result= netflix %>%
  filter(type== 'TV Show' & rating=='TV-MA' & listed_in %in% c('International TV Shows'))%>%
  nrow()
  
# United States에서 제작 된 영화 개수 추출
result= netflix %>%
  filter(type=='Movie'& country=='United States')%>%
  nrow()
  
# 국가별 영화 수
# country !=''(빈값 체크하는 방법)
result = netflix %>%
  filter(type == 'Movie' & country != '') %>%
  group_by(country) %>%
  summarise(count = n())

# 국가별 영화 수 -> 가장 영화가 많은 국가 (상위 5개 추출)
# 등수 구하는 분석 시=정렬
result = netflix %>%
  filter(type == 'Movie' & country != '') %>%
  group_by(country) %>%
  summarise(count = n())%>%
  arrange(desc(count))%>%
  slice_head(n=5)

# 감독별 가장 많이 넷플릭스에 등록한 감독 탑 1명 조회
result = netflix %>%
  filter(director != '') %>%
  group_by(director) %>%
  summarise(count = n())%>%
  arrange(desc(count))%>%
  slice_head(n=1)
print(result)


# 넷플릭스 가장 많이 등장하는 장르 상위 5개

# install.packages('tidyr')
library(tidyr)

# separate_rows : 디플리알 문법 X
# 콤마로 구분된 문자열 처리할 때
# separate_rows(listed_in, sep=', ')

result= netflix %>%
  separate_rows(listed_in, sep=', ')%>%
  group_by(listed_in)%>%
  summarise(count=n())%>%
  arrange(desc(count))%>%
  slice_head(n=5)
#print(result)

result=netflix%>%
  select(date_added)%>%
  slice_head(n=5)
#View(result)


# 2021년에 추가된 영화의 타이틀 구하세요
netflix$date_added=as.Date(netflix$date_added, format='%B %d, %Y')
#View(netflix)

result=netflix %>%
  filter(type =='Movie' & format(date_added, '%Y') == 2021)%>%
  select(title)
#View(result)

# 1.formatted_add_date 컬럼(벡터) 추가
# 2. %B %d, %Y 형태로 포맷한 날짜 형 변환
netflix=netflix %>%
  mutate(formatted_add_date=as.Date(date_added, format='%B %d, %Y'))

result=netflix %>%
  filter(type =='Movie' & format(formatted_add_date, '%Y') == 2021)%>%
  select(title)
#View(result)
