library(dplyr)
setwd('D:/r-data') 
# 컬럼이 한글일 때 fileEncoding = 'CP949'
health_data = read.csv('health.csv',
                       fileEncoding = 'CP949',
                       encoding = "UTF-8",
                       check.names = FALSE
)
#View(health_data)

# 컬럼에 괄호가 있으면 ``으로 묶어줍니다.
# health_data = health_data %>%
#  select(`연령대코드(5세단위)`, `시력(좌)`)
# print(health_data)


# 디플리알 3문제
# 시력(좌)와 시력(우) 평균이 0.9 이하면 
# vision이라는 컬럼에 Check 아니면 No Check를 생성하시오.

# 컬럼 생성 -> mutate
# 평균-> mean
# ~~라면(가정) -> ifelse

result = health_data %>%
  mutate(vision = ifelse((`시력(좌)`+`시력(우)`) / 2 <= 0.9
                         ,'Check','No Check'))

# View(result)
# vision별 Check 수와 No Check수 조회
# 그룹핑 결과 count -> summarise(count = n())
group_result = result %>%
  group_by(vision) %>%
  summarise(count = n())
# View(result)

# 이완기 혈압이 평균보다 낮은 사람 행의 수
# filter에 mean, max, min, sd ... 기초통계 사용 가능
r_mean_result = result %>%
  filter(이완기혈압 <= mean(이완기혈압)) %>%
  nrow()
# View(r_mean_result) 

# min-max 스케일링
# 남성의 혈청지오티(간기능 검사)를 최소-최대(min-max) 
# 적도로 변환 후, 변환된 값이 0.8보다 큰 남성의 
# 연령대 코드, 신장, 체중, 혈정지오티 추출하기
# 단, 혈청지오티 기준으로 내림차순할 것

# 혈청지오티 40 U/L 이하는 정상 
# 성별 1 : 남자, 2: 여자
scaled_health = result %>%
  filter(성별 == 1) %>%
  mutate(AST_Scaled = 
           (`혈청지오티(AST)` - min(`혈청지오티(AST)`))
         /(max(`혈청지오티(AST)`) - min(`혈청지오티(AST)`))) # min-max 컬럼 추가

# View(scaled_health)
scaled_health = scaled_health %>%
  filter(AST_Scaled > 0.8) %>%
  select(`연령대코드(5세단위)`, 
         `신장(5cm단위)`, 
         `체중(5kg단위)`, 
         `혈청지오티(AST)`) %>%
  arrange(desc(`혈청지오티(AST)`))

# 연령대코드 5에서 15사이 중 
# 연령대코드 별 시력(좌), 
# 시력(우) 평균값 조회 단, 시력(좌), 
# 시력(우) 각각 내림차순
result = health_data %>%
  filter(`연령대코드(5세단위)` >= 5 &
           `연령대코드(5세단위)` <= 15) %>%
  group_by(`연령대코드(5세단위)`) %>%
  summarise(
    시력좌평균 = mean(`시력(좌)`, na.rm = TRUE),
    시력우평균 = mean(`시력(우)`, na.rm = TRUE)
  ) %>%
  arrange(desc(시력좌평균),desc(시력우평균))
View(result)

# 산점도 그래프 만들기
# 산점도(Scatter)? 두 개의 변수 간의 관계를 시각적으로 나타냄
# 예) 키와 몸무게 관계, 온도와 에너지 소비량 관계

# 그래프 기본 만들기
# install.packages('ggplot2') #그래프 설치


# 데이터 생성
# 중간고사 점수와 기말고사 점수 산점도 그래프로 표현

students = data.frame(
  ID = 1:10, # 1부터 10까지 생성 (학생 ID)
  Midterm = c(87,59,68,97,84,76,65,90,72,88), #중간고사 점수
  Final = c(85,62,70,95,89,80,67,98,75,200) #기말고사 점수
)
# View(students)

# 산점도 그래프 그리기
# data = students : 그래프에 추가할 데이터 프레임
# ase : Aesthetics : 미학
# x 축 : 중간고사 점수, y 축 : 기말고사 점수
# labs : Laboratory (연구소, 실험실)
# lm : Linear Motion (선형)
library(ggplot2) # 그래프 로드
library(plotly) # 그래프 이벤트 로드
p = ggplot(data = students, aes(x = Midterm, y = Final)) +
  geom_point(aes(text = paste("ID:", ID)), size = 10) + # 산점도 점 크기 조절
  geom_smooth(method = 'lm',se = FALSE, color = 'red') + #회귀선 추가
  labs(title = "중간고사 vs 기말고사 성적 분포도",
       x = "중간고사 점수",
       y = "기말고사 점수")

p = ggplotly(p) #인터랙티브 그래프 변환

print(p)

# 작성한 그래프 pdf 파일로 만들기
# ggsave('산점도그래프.pdf')

# install.packages('plotly') # 그래프 이벤트 설치


# 퀴즈 : 
# 건강검진 csv파일을 사용해서
# 신장과 몸무게 관계를 산점도 그래프로 표현하라
# x 축은 신장, y 축은 체중
# 회귀선 추가할 것
library(dplyr)
library(ggplot2)
setwd('D:/r-data') 
# 컬럼이 한글일 때 fileEncoding = 'CP949'
health_data = read.csv('health.csv',
                       fileEncoding = 'CP949',
                       encoding = "UTF-8",
                       check.names = FALSE
)
# x 축은 신장, y 축은 체중
p = ggplot(health_data, aes(x = `신장(5cm단위)`
                            , y = `체중(5kg단위)`)) + 
  geom_point() +
  geom_smooth(method = "lm", color = "#a49bf2") +
  labs(title = '신장과 체중 관계',
       x = '신장(cm)',
       y = '체중(kg)' )
# print(p)


# 혈색소 vs BMI 관계를 파악하고싶다. (명제)
# 혈색소가 높은사람은 세모표시 그외 동그라미 표시
# 남자와 여자를 구분하고 싶다.
# 혈색소가 높으면 심장마비, 뇌졸증 발생할 가능성 높음
# BMI를 구해야함. 체중/ (신장/100)^2

# 디플리알을 이용해서 전처리 작업을 한다.
# BMI 구합니다.

# mutate로 BMI 구하기
# 혈색소가 높은사람은 세모표시?
# 혈색소가 16이 넘으면 높은 것
health_data2 = health_data %>%
  mutate(BMI = `체중(5kg단위)` / 
           (`신장(5cm단위)` / 100)^2 ,
         Grade = ifelse(혈색소 >= 16,"High","Normal"),
         Gender = ifelse(성별 == 1, "Male", "Female")
  )
# View(health_data2)

# 전처리 끝났으면 그래프로 표현하기
# 17번 세모, 16번 동그라미
p = ggplot(data = health_data2, aes(x = 혈색소,y = BMI)) +
  geom_point(aes(color = Gender, shape = Grade), size = 1.5) +
  scale_color_manual(values = c("Male" = "blue", "Female" = "red")) +
  scale_shape_manual(values = c("High" = 17, "Normal" = 16)) +
  geom_smooth(method = "lm", color = "orange") +
  labs(title = "BMI와 혈색소 관계"
       , x = "혈색소"
       , y = "BMI"
       , color = "Gender"
       , shape = "Grade") +
  theme_minimal() #뒤에 회색 배경 지우기
print(p)


# 퀴즈
# 연령코드가 5~8번이고, 지역코드가 41번인 사람의
# 허리둘레와 식전혈당(공복혈당) 관계를 그래프 표현하기

# 단, 남성은 파랑색 여성은 빨강색 표기
# 식전혈당(공복혈당) 100 이상은 별 모양(11번) 그 외 동그라미 
# 표기하기
# pdf로 저장까지 할 것.

health_data3 = health_data %>% 
  filter((`연령대코드(5세단위)` >= 5 
          & `연령대코드(5세단위)` <= 8)
         & 시도코드 == 41) %>% 
  mutate(Gender = ifelse(성별 == 1, "Male", "Female"),
         Grade = ifelse(`식전혈당(공복혈당)` >= 100, "High","Normal")
  ) %>% 
  select(허리둘레, `식전혈당(공복혈당)`,Gender,Grade)

# View(health_data3)


p = ggplot(data = health_data3, aes(x = `식전혈당(공복혈당)`,y = 허리둘레)) +
  geom_point(aes(color = Gender, shape = Grade), size = 1.5) +
  scale_color_manual(values = c("Male" = "blue", "Female" = "red")) +
  scale_shape_manual(values = c("High" = 11, "Normal" = 16)) +
  geom_smooth(method = "lm", color = "orange") +
  labs(title = "식전혈당(공복혈당) vs 허리둘레"
       , x = "식전혈당(공복혈당)"
       , y = "허리둘레"
       , color = "Gender"
       , shape = "Grade") +
  theme_minimal() #뒤에 회색 배경 지우기



pdf.options(family = "Korea1deb")
ggsave("plot.pdf")

## 이상치(outlier)
# 이상치는 데이터분석에서 가장 중요한 개념
# 데이터 분포에서 극단적으로 벗어난 값을 의미
# 이를 탐지하고 제거해야 올바른 예측을 할 수 있습니다.

# 이상치 제거하는 알고리즘은 다양함.
# 그 중 'Z-Score'를 배워보자.
# Z 스코어 공식
# Z = 원본 (데이터 값 - 평균) / 표준편차

# Z 스코어가 0이면 데이터 값이 평균과 동일함을 의미
# 결과가 양수면 평균에서 멀리 떨어져 있음을 나타냄

# 데이터프레임 생성
students = data.frame(
  Student = c("Alice", "Bob", "Charlie", "David", "Jose"),
  Score = c(50,60,70,80,200)
)
mean_score = mean(students$Score) #스코어 평균구하기
print('평균 : ')
print(mean_score)

# 이상치를 이용해서 튄 데이터 제거
# Z = 원본 (데이터 값 - 평균) / 표준편차
students$z_score = 
  (students$Score - mean(students$Score)) / 
  sd(students$Score)

# View(students)
# 조제 z-score : 1.7
# abs: 절댓값
students$z_score = abs(students$z_score)
#View(students)

# 1.5 : ***임계값, 상황에 따라 조절이 가능함.
# 일반적으로 2~3인 값을 이상치라고 간주합니다.
students$is_outlier = students$z_score >= 1.5
# View(students)
# z 스코어는 정규분포에서 각 값이 평균으로 얼마나 
# 떨어져 있는지 알려줍니다. 

# emp.csv를 이용해서 사원 급여를 Z-스코어를 사용해서 
# 이상치 탐지
# 임계값은 2로 설정.
# 임계값이 2 이상인 사원 정보 조회
library(dplyr)
emp = read.csv('emp.csv')
result = emp %>%
  mutate(
    z_score = abs((SAL - mean(SAL)) / sd(SAL)),
    is_outlier = ifelse(z_score >= 2,TRUE,FALSE))

result = result %>%
  filter(is_outlier) # is_outlier == TRUE 같음.

View(result)

library(ggplot2)


netflix_data = data.frame(
  Show = c("나의 완벽한 비서"
           ,"종증외상센터"
           ,"말할 수 없는 비밀"
           ,"체크인 한양"
           ,"별들에게 물어봐"), #제목
  Viewrship = c(90,98,93,66,39) #시청률 (단위 백만)
)

# 바 그래프 생성
p = ggplot(data = netflix_data, 
           aes(x = Show, y = Viewrship)) + 
  geom_col(fill = "steelblue") + # 막대그래프 색상 
  labs(
    title = "넷플릭스 인기 프로그램 시청률",
    x = "프로그램 명",
    y = "시청률(백만)"
  )

print(p)

# 퀴즈
# 성별 혈정지피티(ATL) 평균을 그래프로 표현
# 단, 연령대코드가 3 ~ 6 사이
# Gender라는 컬럼 추가 남자 Male, 여성 Female

graph_data = health_data %>%
  filter(`연령대코드(5세단위)` >= 3 
         &  `연령대코드(5세단위)` <= 6) %>%
  group_by(성별) %>%
  summarise(MEAN_ATL 
            = mean(`혈청지피티(ALT)`
                   , na.rm = TRUE)) %>%
  mutate(Gender = ifelse(성별 == 1 
                         , "Male", "Female"))
# View(graph_data)

p = ggplot(data = graph_data, aes(
  x = 성별,
  y = MEAN_ATL,
  fill = Gender 
)) +
  geom_col() + 
  scale_fill_manual(values = c("Male" = "blue"
                               , "Female" = "red")) + #색상 수동 지정
  labs(
    title = "성별 평균 혈청지피티",
    x = "성별",
    y = "평균 ATL"
  )
print(p)







