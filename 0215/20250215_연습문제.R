# 주어진 코드
x = 42
y = "R 프로그래밍"
z = TRUE

# 각 변수의 자료형을 출력하는 코드를 작성하세요.
# 힌트: typeof() 함수를 사용하세요.
print(typeof(x))
print(typeof(y))
print(typeof(z))


# 다음 벡터에서 20보다 큰 숫자만 선택하여 출력하세요.
# 주어진 벡터
numbers = c(10, 15, 20, 25, 30, 35)
# 20보다 큰 숫자만 선택하고 출력하는 코드를 작성하세요.
than_20=numbers[numbers>20]
print(than_20)


# 주어진 데이터프레임
people = data.frame(
  name = c("Alice", "Bob", "Charlie", "Diana"),
  age = c(25, 35, 30, 28),
  gender = c("여", "남", "남", "여")
)
print(people)

# 데이터의 상위 5개 행 출력하기
# 힌트 : head
print(head(people,5))

# 데이터의 행과 열의 개수를 출력하기
#힌트: dim
print(dim(people))

#전체 컬럼을 출력하기
#힌트: colnames
print(colnames(people))

# 3번째 컬럼의 3번째 값은 무엇인가?
# 힌트: data[row_condition, column_condition] 콤마를 기준으로 왼쪽은 행 조건, 오른쪽은 열 조건입니다. 
#result=people[]

# 데이터 마지막 3개행을 출력하기
# 힌트: tail
print(tail(people,3))

# 새로운 컬럼 'weight' 추가, 데이터는 52,77,81,46 차례로 넣어주세요.
# 힌트: people$'새로운컬럼명' = '값'
people$weight=c(52, 77,81,46)
print(people)

# 나이가 30 이상인 사람들만 출력하는 코드를 작성하세요.
# 힌트: 데이터프레임 필터링은 대괄호 [ ]를 사용합니다.
result=people[people$age >=30,]
print(result)

# name , age 두개의 컬럼으로 구성된 새로운 데이터 프레임을 정의하기.
# 힌트 : [,c('','')]
result=people[, c('name','age')]
print(result)