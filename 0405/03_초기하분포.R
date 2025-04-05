# 초기하분포
# 비복원 추출에서 사용되는 이산형 확률분포
# 비복원 : 한번 뽑은 카드는 다시 뽑을 수 없음
# 이산형 : 연속적이지 않고 구별된 값 ex) 주사위 던져 나온 숫자

# 52장의 뽑기 카드에서 당첨카드 4장 포함된 상태로 길동이가 무작위로
# 5장을 뽑을 때 2장의 당첨 카드를 뽑을 확률을 R로 계산해 보자

# 모집단 : 52장
# 표본 크기 : 5장
# 당첨 카드 수 : 4장
# 성공 항목의 개수 : 2장

N=52 # 모집단
K=4 # 성공 항목
n=5 # 표본 크기
x=2 # 성공항목의 수(당첨카드의 수)

# 초기하분포 확률 계산
# R에서는 dhyper로 쉽게 구할 수 있음
result = dhyper(x, K, N-K, n) * 100
cat('5장 중 2장의 당첨카드를 뽑을 확률 :', result, '\n') #약 4%

# 품질관리시 사용
# 100개의 부품 중 10개가 불량품이고,
# 검사관이 15개를 무작위로 추출했을 때
# 3개의 불량품이 포함된 확률을 R로 계산하기
N=100 # 모집단
n=15 # 표본(비복원) 집단
K=10 # 불량품
x=3 # 성공 항목의 개수

result=dhyper(x, K, N-K, n)*100
cat('15개 중 3개의 불량품이 포함될 확률 :', result, '\n')


# 1.setwd
# 1. 상원쿠팡은 총 4개의 창고(Location_1~Location_4)를 가지고 있음
# Location_3 창고에서 5만원 이상 제품 중 결함이 있는
# 제품 총 개수 K를 구하시오

setwd('D:/r-data')
library(dplyr)

df=read.csv('warehouse_data_1000.csv')
print(str(df)) # 항상 전처리하기 전에 데이터프레임 구조확인
#View(df)

# 불량품(K)를 알아보자
K=df%>%
  filter(Warehouse_Location=='Location_3' & Price>=50000, Defective=='Y')%>%
  nrow() # nrow() :행수

# 모집단(N) 구하기
N=df%>%
  filter(Warehouse_Location=='Location_3')%>%
  nrow()

n= 10 # 표본집단(크기)
x= 5 # 불량품 5개
  
# 2. Location_3 창고에 입고된 총 제품 수 모집단(N), 1번 정답 성공항목(K)
# 라고 할 때 10개의 제품(n)을 무작위로 추출했을 때 5개의 불량품(x)이
# 포함 된 확률을 구해보자(초기하분포)

# P : 확률
P=dhyper(x, K, N-K, n) *100
cat('10개 중 5개의 불량품이 포함될 확률 :', P, '\n') # 약1.3%


# 모집단 N : Location_2 창고에 입고된 총 제품 수
# K(모집단 중 원하는 개수) : Location_2 창고에서 2025-03-01~2025-03-21 사이에
# 입고된 제품 중 가장 결함이 많은 아이템 총 개수 K
# n(표본크기) : 5개
# x(표본 중 원하는 개수) : 1개

# 무작위로 5래를 뽑았을 때 1개의 불량품이 나올 확률(P) 구하기(초기하분포)

N=df%>%
  filter(Warehouse_Location=='Location_2')%>%
  nrow()

most_K=df%>%
  mutate(Arrival_Date=as.Date(Arrival_Date))%>%
  filter(Warehouse_Location=='Location_2' & 
           Defective=='Y'& 
           Arrival_Date>='2025-03-01'& Arrival_Date<='2025-03-21')%>%
  group_by(Item_Name)%>%
  summarise(count=n())%>%
  arrange(desc(count))%>%
  slice_head(n=1)

K=most_K$count
n=5
x=1

P=dhyper(x, K, N-K, n)*100
print(P)