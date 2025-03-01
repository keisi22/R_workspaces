# R 디렉토리 변경
setwd('D:/r-data')
print(list.files()) # 해당 경로 파일 확인

# csv파일 불러오기
data= read.csv('student_data.csv')
#View(data)

# 각 과목(Math, Science, English)의 평균 점수를 계산하세요
# *mean 평균
result=mean(data$Math)
print(result)
cat('수학평균:', result,'\n')
result2=mean(data$Science)
print(result2)
cat('과학평균:', result2,'\n')
result3=mean(data$English)
print(result3)
cat('영어평균:', result3,'\n')

#컴퓨터 총합 na.rm=TRUE
computer=sum(data$Computer,na.rm=TRUE)
print(computer)
cat('결측값 제거 sum:', computer,'\n')

# 영어 표준편차 구하기
# standard deviation
English=sd(data$English)
print(English)
cat('영어 표준편차:', English,'\n')
# 영어 값들이 평균으로부터 +-4.9만큼 퍼져있음을 의미

# 과학 중앙값 구하기
# median: 중앙값
scie=median(data$Science)
print(scie)
cat('과학 중앙값:', scie,'\n')

# 수학 사분위수 구하기
# quantile
math=quantile(data$Math)
print(math)
cat('수학 사분위수:', math,'\n')

# 최대값, 최소값
# 수학 최대값, 최소값
math_max=max(data$Math)
print(math_max)
cat('최대값:', math_max,'\n')

math_min=min(data$Math)
cat('최소값:', math_min,'\n')
print(math_min)

# table : 점수별 인원 통계
print(table(data$English)) 

# 데이터프레임 기초 통계량 전체 확인
#summary  사용하면 각 컬럼(열) 별 기본 통계 확인
print(summary(data))

# installed.packages('ggplot2')
library(ggplot2)
graph_data =data.frame(
  x=c('수학평균','영어평균','과학평균'),
  y=c(result, result3, result2)
)
print(graph_data)
#그래프 생성
result4 = ggplot(data=graph_data, aes(x=x, y=y)) +
  geom_col(fill='gray') +
  labs(
    title='과목평균',
    x='과목',
    y='평균점수'
  )+
  theme_minimal()

print(result4)