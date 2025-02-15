### 데이터 프레임(중요!!!!)
# R 기초단계에서 가장 중요함
# 데이터프레임, 벡터

# R프로그래밍에서 데이터프레임은 데이터를 '행'과 '열'로
# 구성한 2차원 구조
# 다양한 데이터 유형을 한 테이블에 저장할 수 있는 자료구조
# 데이터프레임으로 통계분석, 데잍터처리, 그래프 시각화

# 데이터 프레임 구조
# 구조 : 행, 열
# 행(row) : 관측치 (가로)
# 열(column) : 속성 (세로)

ID=c(1,2,3)
Name=c('Alice', 'Bob', 'Charlie')
Age=c(25,30,35)
Salary=c(50000,60000,70000)

# 데이터프레임 생성
# data.frame(벡터값 차례대로, , )
df=data.frame(ID, Name, Age, Salary)
print(df) 

## 데이터프레임 조회하는 다른 방법들(***)
# head
print(head(df,1)) # 위에서부터 1행만 출력
print(head(df,2)) # 1~2열 출력
print(head(df)) #뒤에 숫자가 없으면 1~6행(기본)까지 출력

# 행과 열의 개수 알기
# dim
print(dim(df)) # 행, 열 순서대로출력

# 전체 컬럼 조회
print(colnames(df))

# 마지막 1행 출력
# tail : 꼬리, 마지막
print(tail(df,1)) # 아래에서부터 출력

# View(df) # 다른 화면으로 시각화되어 출력

### 특정 열만 선택하기
# '$'기호를 사용하면 결과는 벡터 형태로 반환된다.
names=df$Name # 데이터프레임의 'Name' 열가져오기
cat('특정 열 추출 : ', names, '\n')

ages=df$Age
cat('나이 추출: ', Age, '\n')

## 다수 열 선택
# 이름, 나이 출력
result= df[,c('Name', 'Age')]
print(result)

# ID, 샐러리 출력
result=df[,c('ID', 'Salary')]
print(result)

# 특정 열값 수정, 추가
df$Salary=df$Salary +100
print(df)

# Age 열값 수정 +1
df$Age=df$Age+1
print(df)

# 데이터프레임에 새로운 열 추가
df$Penalty =c('예', '아니오', '예')
View(df)



