## 해당코드는 구글 코랩에서
# 1. 먼저 pip로 설치
# pip install matplotlib keras yfinance pandas scikit-learn

# 2. 아래 코드 실행
# Yahoo Finance API를 사용하여 애플의 주가 데이터를 가져옵니다.
import yfinance as yf

# 애플 주가 데이터 다운로드
data = yf.download('AAPL', start='2024-01-01', end='2025-04-10')
print(data.head())
# 종가(Close), 고가(High), 저가(Low), 시가(Open), 거래량(Volume)

# sklearn 스케일링
from sklearn.preprocessing import MinMaxScaler

# 종가 열 추출 및 정규화
# 종가? 주식 시장에서 하루 동안의 거래가 종료될 때 기록된 마지막 가격
# 보통 수십 달러에서 수백 달러 사이의 값으로 나타나는데, 크기 차이가 클 경우 모델학습과정에 문제가 생김
# 정규화를 통해 모든 데이터 값을 같은 범위(예: 0~1)로 변환
scaler = MinMaxScaler(feature_range=(0, 1))
data['Close'] = scaler.fit_transform(data[['Close']])

# numpy 다차원 배열 처리
import numpy as np

# 데이터 분리
# 데이터를 훈련 및 테스트 세트로 나누고, 시계열 데이터를 LSTM 입력 형식으로 변환
# 훈련 및 테스트 데이터 분리
train_size = int(len(data) * 0.8) # 전체 데이터의 80%를 훈련 데이터로 할당
train_data = data['Close'][:train_size].values.reshape(-1, 1) 
# :train_size -> :53는 데이터의 첫 번째부터 53번째까지의 값 포함
# reshape(-1, 1) : 전체 데이터를 하나의 열(column)로 변환
test_data = data['Close'][train_size:].values.reshape(-1, 1)  
# train_size: -> 53:는 데이터의 54번째부터 끝까지


# 시계열 데이터 생성 함수
# time_step 모델이 학습할 때 사용할 과거 데이터의 개수
def create_dataset(dataset, time_step=50):
    X, Y = [], []
    for i in range(len(dataset)-time_step):
        X.append(dataset[i:(i+time_step), 0]) # time_step만큼의 과거 데이터
        Y.append(dataset[i + time_step, 0]) # time_step 이후의 값
    return np.array(X), np.array(Y)


X_train, y_train = create_dataset(train_data)
X_test, y_test = create_dataset(test_data)

# LSTM 입력 형식으로 데이터 재구성
# LSTM 3차원 형식으로 재구성해야 함
# 여러 날의 데이터, 과거 60일 동안의 주가, 종가(Close) = 3차원
X_train = X_train.reshape(X_train.shape[0], X_train.shape[1], 1)
X_test = X_test.reshape(X_test.shape[0], X_test.shape[1], 1)

# **케라스(Keras)는 파이썬 기반의 딥러닝 도구
from keras.models import Sequential
from keras.layers import LSTM, Dense

# Long Short-Term Memory(LSTM) 모델
# 순환 신경망(RNN)의 한 종류 -> 시간 순서에 따라 변화하는 데이터를 처리
# 주로 시계열 데이터나 자연어 처리와 같은 작업에 사용
# ex. 주가 예측, 날씨 예측, 자연어 처리(예: 번역, 감정 분석), 음성 인식 등.

# 모델 정의
# Sequential은 레이어를 순차적으로 쌓아 모델
# 첫 번째 레이어: 데이터 입력
# 두 번째 레이어: 첫 번째 레이어의 결과를 받아 처리
# 세 번째 레이어: 최종 결과 출력
model = Sequential([
    LSTM(50, return_sequences=True, input_shape=(X_train.shape[1], 1)), 
    # eturn_sequences=True : 레이어를 쌓을 때 필수, input_shape=(X_train.shape[1], 1) : 타임스텝(예: 60일), 종가 1개
    LSTM(50), # 메모리 셀 개수
    # 메모리셀? 데이터를 기억하고, 필요에 따라 정보를 추가하거나 삭제하는 역할을 하는 핵심 구성 요소
    # 수가 증가하면 모델이 더 많은 계산을 수행해야 하므로 CPU/GPU 성능이 중요
    Dense(1) # 주가 예측에서는 다음 날 종가 1개를 예측하므로 1을 사용
])
# optimizer : 알고리즘
# 딥러닝 모델이 학습할 때, 손실(loss)을 최소화하는 알고리즘

# 대표적인 Optimizer는 Adam 사용, 최신 트렌드는 Adam W 사용
# 모델이 예측한 값과 실제 값 사이의 차이(손실)를 줄이도록 조정하는 알고리즘
# ex. 손실(loss)을 산꼭대기로 생각하면, Optimizer는 산 아래(최소 손실)로 내려가는 방법을 결정
# Adam: 경사와 속도를 고려하여 효율적으로 내려감.

# mean_squared_error(MSE)  평균 제곱 오차로, 머신러닝 및 회귀 분석에서 모델의 성능을 평가하는 데 사용되는 지표
# MSE는 예측값이 실제값에 얼마나 가까운지를 수치적으로 평가하는 데 사용
model.compile(optimizer='adam', loss='mean_squared_error')

# *****모델 학습
# X_train : 입력 데이터(과거 주가 데이터)
# y_train : 정답 데이터(다음 날의 실제 주가 값)
# 에포크(epoch): 전체 데이터셋을 한 번 학습하는 과정, epochs=20은 데이터를 20번 반복해서 학습하겠다는 뜻
# 20번 반복? 같은 데이터셋을 여러 번 학습하여 더 나은 성능을 얻으려고
# ex. 교재를 총 20번 반복해서 풀어봄.
# 한번에 많은 데이터를 여러번 학습하면 메모리 사용량이 커짐 
# 데이터를 작은 그룹으로 나눠서 학습합니다. 이 작은 그룹을 Batch라고 부릅니다.
# 배치 크기(batch size): 학습 데이터를 일정한 크기의 묶음 단위
# 데이터셋이 500개이고, Batch Size가 50이라면, 한 번의 Epoch 동안 10개의 Batch를 처리합니다.
# ex. 교재를 한꺼번에 공부하지 않고, 각 장(chapter)별로 나눠서 공부하는 것 (직렬방식)
# 딥러닝 모델은 일반적으로 병렬로 여러 배치를 동시에 학습하지 않습니다.

# batch_size=32는 한 번에 32개의 데이터를 가져와 학습한다는 뜻
# 검증 데이터(validation data): 모델 성능을 평가
model.fit(X_train, y_train, epochs=20, batch_size=32, validation_data=(X_test, y_test))

# 예측 수행
predicted_stock_price = model.predict(X_test)

# 정규화 해제 (역변환) -> 스켈일된 값 원래값으로 복원
predicted_stock_price = scaler.inverse_transform(predicted_stock_price.reshape(-1, 1))
y_test_actual = scaler.inverse_transform(y_test.reshape(-1, 1))

# 시각화 작업
import matplotlib.pyplot as plt
# 데이터 분석과 조작을 위한 도구 == 디플리알
import pandas as pd

# 테스트 데이터 길이에 맞는 날짜 생성
start_date = '2024-01-01'  # 테스트 데이터 시작 날짜
end_date = '2025-04-10'    # 테스트 데이터 종료 날짜
dates = pd.date_range(start=start_date, end=end_date, periods=len(y_test_actual))

# 그래프 그리기
plt.figure(figsize=(12, 6))
plt.plot(dates, y_test_actual, label="Actual Price", color="blue")
plt.plot(dates, predicted_stock_price, label="Predicted Price", color="red")
plt.title("Apple Stock Price Prediction") # 그래프 제목
plt.xlabel("Date") #x축 글씨
plt.ylabel("Stock Price (USD)") #y축 글씨
plt.legend()
plt.xticks(rotation=45)  # x축 날짜 45도 회전
plt.show()
# Yahoo Finance API를 사용하여 애플의 주가 데이터를 가져옵니다.
import yfinance as yf

# 애플 주가 데이터 다운로드
data = yf.download('AAPL', start='2024-01-01', end='2025-04-10')
# print(data.head())
# 종가(Close), 고가(High), 저가(Low), 시가(Open), 거래량(Volume)

# sklearn 스케일링
from sklearn.preprocessing import MinMaxScaler

# 종가 열 추출 및 정규화
# 종가? 주식 시장에서 하루 동안의 거래가 종료될 때 기록된 마지막 가격
# 보통 수십 달러에서 수백 달러 사이의 값으로 나타나는데, 크기 차이가 클 경우 모델학습과정에 문제가 생김
# 정규화를 통해 모든 데이터 값을 같은 범위(예: 0~1)로 변환
scaler = MinMaxScaler(feature_range=(0, 1))
data['Close'] = scaler.fit_transform(data[['Close']])

# numpy 다차원 배열 처리
import numpy as np

# 데이터 분리
# 데이터를 훈련 및 테스트 세트로 나누고, 시계열 데이터를 LSTM 입력 형식으로 변환
# 훈련 및 테스트 데이터 분리
train_size = int(len(data) * 0.8) # 전체 데이터의 80%를 훈련 데이터로 할당
train_data = data['Close'][:train_size].values.reshape(-1, 1) 
# :train_size -> :53는 데이터의 첫 번째부터 53번째까지의 값 포함
# reshape(-1, 1) : 전체 데이터를 하나의 열(column)로 변환
test_data = data['Close'][train_size:].values.reshape(-1, 1)  
# train_size: -> 53:는 데이터의 54번째부터 끝까지


# 시계열 데이터 생성 함수
# time_step 모델이 학습할 때 사용할 과거 데이터의 개수
def create_dataset(dataset, time_step=50):
    X, Y = [], []
    for i in range(len(dataset)-time_step):
        X.append(dataset[i:(i+time_step), 0]) # time_step만큼의 과거 데이터
        Y.append(dataset[i + time_step, 0]) # time_step 이후의 값
    return np.array(X), np.array(Y)


X_train, y_train = create_dataset(train_data)
X_test, y_test = create_dataset(test_data)

# LSTM 입력 형식으로 데이터 재구성
# LSTM 3차원 형식으로 재구성해야 함
# 여러 날의 데이터, 과거 60일 동안의 주가, 종가(Close) = 3차원
X_train = X_train.reshape(X_train.shape[0], X_train.shape[1], 1)
X_test = X_test.reshape(X_test.shape[0], X_test.shape[1], 1)

# **케라스(Keras)는 파이썬 기반의 딥러닝 도구
from keras.models import Sequential
from keras.layers import LSTM, Dense

# Long Short-Term Memory(LSTM) 모델
# 순환 신경망(RNN)의 한 종류 -> 시간 순서에 따라 변화하는 데이터를 처리
# 주로 시계열 데이터나 자연어 처리와 같은 작업에 사용
# ex. 주가 예측, 날씨 예측, 자연어 처리(예: 번역, 감정 분석), 음성 인식 등.

# 모델 정의
# Sequential은 레이어를 순차적으로 쌓아 모델
# 첫 번째 레이어: 데이터 입력
# 두 번째 레이어: 첫 번째 레이어의 결과를 받아 처리
# 세 번째 레이어: 최종 결과 출력
model = Sequential([
    LSTM(50, return_sequences=True, input_shape=(X_train.shape[1], 1)), 
    # eturn_sequences=True : 레이어를 쌓을 때 필수, input_shape=(X_train.shape[1], 1) : 타임스텝(예: 60일), 종가 1개
    LSTM(50), # 메모리 셀 개수
    # 메모리셀? 데이터를 기억하고, 필요에 따라 정보를 추가하거나 삭제하는 역할을 하는 핵심 구성 요소
    # 수가 증가하면 모델이 더 많은 계산을 수행해야 하므로 CPU/GPU 성능이 중요
    Dense(1) # 주가 예측에서는 다음 날 종가 1개를 예측하므로 1을 사용
])
# optimizer : 알고리즘
# 딥러닝 모델이 학습할 때, 손실(loss)을 최소화하는 알고리즘

# 대표적인 Optimizer는 Adam 사용, 최신 트렌드는 Adam W 사용
# 모델이 예측한 값과 실제 값 사이의 차이(손실)를 줄이도록 조정하는 알고리즘
# ex. 손실(loss)을 산꼭대기로 생각하면, Optimizer는 산 아래(최소 손실)로 내려가는 방법을 결정
# Adam: 경사와 속도를 고려하여 효율적으로 내려감.

# mean_squared_error(MSE)  평균 제곱 오차로, 머신러닝 및 회귀 분석에서 모델의 성능을 평가하는 데 사용되는 지표
# MSE는 예측값이 실제값에 얼마나 가까운지를 수치적으로 평가하는 데 사용
model.compile(optimizer='adam', loss='mean_squared_error')

# *****모델 학습
# X_train : 입력 데이터(과거 주가 데이터)
# y_train : 정답 데이터(다음 날의 실제 주가 값)
# 에포크(epoch): 전체 데이터셋을 한 번 학습하는 과정, epochs=20은 데이터를 20번 반복해서 학습하겠다는 뜻
# 20번 반복? 같은 데이터셋을 여러 번 학습하여 더 나은 성능을 얻으려고
# ex. 교재를 총 20번 반복해서 풀어봄.
# 한번에 많은 데이터를 여러번 학습하면 메모리 사용량이 커짐 
# 데이터를 작은 그룹으로 나눠서 학습합니다. 이 작은 그룹을 Batch라고 부릅니다.
# 배치 크기(batch size): 학습 데이터를 일정한 크기의 묶음 단위
# 데이터셋이 500개이고, Batch Size가 50이라면, 한 번의 Epoch 동안 10개의 Batch를 처리합니다.
# ex. 교재를 한꺼번에 공부하지 않고, 각 장(chapter)별로 나눠서 공부하는 것 (직렬방식)
# 딥러닝 모델은 일반적으로 병렬로 여러 배치를 동시에 학습하지 않습니다.

# batch_size=32는 한 번에 32개의 데이터를 가져와 학습한다는 뜻
# 검증 데이터(validation data): 모델 성능을 평가
model.fit(X_train, y_train, epochs=20, batch_size=32, validation_data=(X_test, y_test))

# 예측 수행
predicted_stock_price = model.predict(X_test)

# 정규화 해제 (역변환) -> 스켈일된 값 원래값으로 복원
predicted_stock_price = scaler.inverse_transform(predicted_stock_price.reshape(-1, 1))
y_test_actual = scaler.inverse_transform(y_test.reshape(-1, 1))

# 시각화 작업
import matplotlib.pyplot as plt
# 데이터 분석과 조작을 위한 도구 == 디플리알
import pandas as pd

# 테스트 데이터 길이에 맞는 날짜 생성
start_date = '2024-01-01'  # 테스트 데이터 시작 날짜
end_date = '2025-04-10'    # 테스트 데이터 종료 날짜
dates = pd.date_range(start=start_date, end=end_date, periods=len(y_test_actual))

# 그래프 그리기
plt.figure(figsize=(12, 6))
plt.plot(dates, y_test_actual, label="Actual Price", color="blue")
plt.plot(dates, predicted_stock_price, label="Predicted Price", color="red")
plt.title("Apple Stock Price Prediction") # 그래프 제목
plt.xlabel("Date") #x축 글씨
plt.ylabel("Stock Price (USD)") #y축 글씨
plt.legend()
plt.xticks(rotation=45)  # x축 날짜 45도 회전
plt.show()
