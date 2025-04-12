import numpy as np

# 예제 데이터
data = np.array([1, 2, 3, 4, 5])
print(data)
# reshape(-1, 1) 적용
reshaped_data = data.reshape(-1, 1)
print(reshaped_data)


data = [10, 20, 30, 40, 50, 60]
time_step = 3

X, Y = [], []

# 3차원 데이터 예시
# 시계열 데이터 생성
for i in range(len(data) - time_step):
    X.append(data[i:i+time_step])   # time_step만큼의 과거 데이터
    Y.append(data[i+time_step])    # time_step 이후의 값

print("X:", X)
print("Y:", Y)

import numpy as np

data = [10, 20, 30, 40, 50, 60]
time_step = 3

X, Y = [], []

# 데이터 재구성
for i in range(len(data) - time_step):
    X.append(data[i:i+time_step])   # time_step만큼의 과거 데이터
    Y.append(data[i+time_step])    # time_step 이후의 값

X = np.array(X).reshape(len(X), time_step, 1)   # LSTM 입력 형식으로 변환
Y = np.array(Y)

print("X:", X)
print("Y:", Y)


from sklearn.metrics import mean_squared_error

# 실제값과 예측값
true_y = [10, 20, 30]
pred_y = [12, 18, 33]

# MSE 계산
mse = mean_squared_error(true_y, pred_y)
print(f"MSE: {mse:.2f}") # MSE: 5.67

# 1. 각 데이터 포인트의 오차 계산:
# => 10−12 = −2, 20−18 = 2, 30−33 = −3
# 오차를 제곱:
# -2의 2제곱 : 4, 2의 2제곱 4, -3의 2제곱은 9
# 평균 계산:
# 4+4+9/3 = 5.67

# 오차를 제곱하기 때문에 음수 값이 없으며, 모든 오차가 양수로 변환
# 값이 작을수록 모델이 더 정확하다는 것을 의미



# 데이터 정규화 및 역정규화
from sklearn.preprocessing import MinMaxScaler
import numpy as np

# 원래 데이터
data = np.array([[100], [200], [300], [400], [500]])

# MinMaxScaler 객체 생성 및 데이터 정규화
scaler = MinMaxScaler()
scaled_data = scaler.fit_transform(data)

# 역정규화 수행
original_data = scaler.inverse_transform(scaled_data)

print("정규화된 데이터:", scaled_data)
print("역정규화된 데이터:", original_data)
