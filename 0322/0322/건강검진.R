library(dplyr)
setwd('D:/r-data')
health=read.csv('health.csv',
                fileEncoding ='CP949',
                encoding= 'UTF-8',
                check.names=FALSE)
# 컬럼이 한글일 때 fileEncoding ='CP949'
#View(health)

# health= health%>%
#  select(`연령대코드(5세단위)`, `시력(좌)`)
#View(health)

# 시력(좌)와 시력(우) 평균이 0.9이하면
# vision이라는 컬럼에 check 아니면 No check를 생성하세요
# 컬럼 생성 -> mutate
# 평균 -> mean
# ~라면(가정) -> ifelse

result = health%>%
  mutate(vision=ifelse((`시력(좌)` + `시력(우)`)/2 <=0.9, 'Check', 'No Check' ))
         
#View(result)

# vision별 Check 수와 No Check수 조회
group_result=result%>%
  group_by(vision)%>%
  summarise(count=n())
#View(result)

# 이완기 혈압이 평균보다 낮은 사람 행의 수
r_mean_result=result%>%
  filter(이완기혈압<=mean(이완기혈압))%>%
  nrow()
#View(r_mean_result)

# min_max 스케일링
# 남성의 혈청지오티(간기능 검사)를 최소-최대(min-max)
# 적도로 변환 후, 변환된 값이 0.8보다 큰 남성의
# 연령대 코드, 신장, 체중, 혈청지오티 추출하기
# 단 혈청지오티 기준으로 내림차순
# 혈청지오티 40U/L 이하는 정상
# 성별 1=남자, 2=여자

scaled_health=result%>%
  filter(성별==1)%>%
  mutate(AST_scaled=
           (`혈청지오티(AST)`-min(`혈청지오티(AST)`))
         /(max(`혈청지오티(AST)`)-min(`혈청지오티(AST)`)))
  #View(scaled_health)

ast_health=scaled_health%>%
  filter(AST_scaled > 0.8)%>%
  select(`연령대코드(5세단위)`, `신장(5cm단위)`, `체중(5kg단위)`, `혈청지오티(AST)`)%>%
  arrange(desc(`혈청지오티(AST)`))
View(ast_health)

# 연령대코드 5에서 15사이 중
# 연령대코드 별 시력(좌),
# 시력(우) 평균값 조회 단, 시력(좌),
# 시력(우) 각각 내림차순

age_result=result%>%
  filter(`연령대코드(5세단위)`>=5 & `연령대코드(5세단위)`<=15)%>%
  group_by(`연령대코드(5세단위)`)%>%
  summarise(시력좌평균=mean(`시력(좌)`, na.rm=TRUE),
            시력우평균=mean(`시력(우)`, na.rm=TRUE)
  )%>%
  arrange(desc(시력좌평균), desc(시력우평균))
#View(age_result)

