library(dplyr)
netflix=read.csv('netflix.csv')
#View(netflix)


#문제 1: 데이터프레임의 앞부분 출력 단, 2행만
print(head(netflix,2))

#문제 2: 데이터프레임의 뒷부분 출력 단, 5행만
print(tail(netflix, 5))

#문제 3: 데이터프레임의 구조 확인
print(dim(netflix))
str(netflix) # 시험 출제시 정답으로 간주

#문제 4: 특정 열 title 선택하기
result=netflix%>% select(title)
print(result)

#문제 3: 데이터셋에서 title, type, release_year 열만 선택하세요.
result=netflix%>% select(title, type, release_year)
print(result)

#문제 4: 데이터셋에서 title, country, rating 열만 선택하세요.
result=netflix%>% select(title, country, rating)
print(result)

#문제 5: 2021년에 출시된 영화만 필터링하세요.
result= netflix%>% filter(release_year==2021)
print(result)

#문제 6: TV-MA 등급의 TV 프로그램만 필터링하세요.
result=netflix%>% filter(rating=='TV-MA' & type=='TV Show')

#문제 7: director가 "Mike Flanagan"인 영화의 
#title, director, country 열을 선택하세요.
result=netflix%>% filter(director=='Mike Flanagan')%>%
  select(title, ditector, country)

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
# []?
result=netflix%>% filter(type=='TV Show')%>%
  mutate(duration_seasons=as.numeric(gsub(' Season[s]?', '', duration)))
  arrange(duration_seasons)

  #문제 11: type 열을 기준으로 데이터를 그룹화하고,
  #각 그룹에 대해 콘텐츠의 총 개수와 평균 release_year를 계산하세요.
  #결과 데이터프레임은 type, total_count, average_release_year 열을 포함해야 합니다.
  result=netflix%>% group_by(type)%>%
    summarise(total_count=n(), average_release_year=mean(release_year, na.rm=TRUE))
  

