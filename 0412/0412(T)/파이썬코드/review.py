import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# 데이터 준비
# 훈련데이터와 테스트데이터 개념
# 샘플 데이터
x = [[1],[2],[3],[4],[5]] #데이터
y = [0, 1, 0 , 1, 0] # 라벨링 1 = 긍정, 0 = 부정 => 지도학습

# train_test_split : 훈련데이터와 테스트데이터로 나누는데 사용하는 함수
# 훈련 데이터 : 모델을 학습시키는데 사용
# 테스트 데이터 : 학습된 모델의 성능을 평가하는데 사용
x_train, x_test, y_train, y_test = train_test_split(x , y, test_size= 0.2, random_state=42)
# test_size= 0.2 : 데이터 상위 20% 테스트 데이터로 사용하겠다. 나머지 80% 훈련 데이터
# random_state=42 : 시드값 고정, 매번 실행할 때 동일한 순서로 동일한 값이 테스트 데이터에 포함됩니다.

print('훈련 데이터 : ', x_train)
print('테스트 데이터 : ', x_test)
# 8(훈련 데이터):2(테스트 데이터) 일반적인 머신러닝 실험에서 모델의 성능을 평가하기 위한 데이터 분할 비율

data = {
    'text': [
        '빵 하나하나 가격도 착하고 완전 맛있어요. 줄서더라도 다시가고싶네요!',
        '웨이팅이 너무 길어요 맛은 그저 그렇습니다.',
        '너무 유명한 성심당! 가성비 정말 좋고 빵도 하나하나 다 맛있습니다',
        '성심당 빵 처음 이용해봤는데 진짜 너무 맛있어요 ㅜㅜ 명란바게트빵이 최애빵입니다!!!',
        '너무 유명한 성심당! 가성비 정말 좋고 빵도 하나하나 다 맛있습니다',
        '웨이팅이 너무 길어요 맛은 그저 그렇습니다.',
        '웨이팅이 너무 길어요 맛은 그저 그렇습니다.',
        '웨이팅이 너무 길어요 맛은 그저 그렇습니다.',
        '웨이팅이 너무 길어요 길어요 길어요 맛은 그저 그렇습니다.',
        '너무 유명한 성심당! 가성비 정말 좋고 빵도 하나하나 다 맛있습니다'
    ],
    'label': [1, 0, 1, 1, 1, 0, 0, 0, 0, 1]  # 1: Positive, 0: Negative
}
df = pd.DataFrame(data)

# 텍스트 벡터화
# 텍스트를 벡터로 변환하는 이유?
# 컴퓨터는 텍스트(문자열)을 직접 처리하지 못함, 숫자 벡터로 변환하는 과정이 필요함
vectorizer = CountVectorizer()
x = vectorizer.fit_transform(df['text']) #텍스트를 벡터로 변환
y = df['label']

# 데이터 분할 (훈련데이터와 테스트데이터 분할)
# test_size 0.2 =>  80% 훈련, 20% 테스트
x_train, x_test, y_train, y_test = train_test_split(x, y , test_size=0.2, random_state=42)

# 랜덤포레스트 모델 학습
# 랜덤포레스트? 이진 분류 문제에서 많이 사용하는 알고리즘
# ex. 스팸메일 구분, 긍정/부정 감정 분석 등..
rf_model = RandomForestClassifier(random_state=42)
rf_model.fit(x_train, y_train)

# 모델 평가
y_pred = rf_model.predict(x_test)
acc = accuracy_score(y_test, y_pred) #모델 정확도

# x데이터(리뷰)와 y데이터(라벨링 긍정인지 부정인지)의 정확도를 판단
# 저 리뷰가 정말 긍정인건지? 부정인건지? 정확도가 맞는지 판단
# 보통 이진 분류에서 0.7 ~ 0.8 이상의 정확도를 목표로 삼는 것이 일반적
print('정확도 : ',acc)