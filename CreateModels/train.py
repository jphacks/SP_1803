# coding:utf-8
 
import keras
from keras.utils import np_utils
from keras.models import Sequential
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.layers.core import Dense, Dropout, Activation, Flatten
from tensorflow.python.keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint
import numpy as np
from sklearn.model_selection import train_test_split
from PIL import Image
import glob
from keras import backend as K
import tensorflow as tf

config = tf.ConfigProto(allow_soft_placement=True)
config.gpu_options.allow_growth = True
session = tf.Session(config=config)
K.set_session(session)

folder = ["cute_m","cute_w", "disgusting_m", "disgusting_w", "good_m","good_w", "interesting_m", "interesting_w"]
image_size = 64
 
X = []
Y = []

print("loading images")

for index, name in enumerate(folder):
    dir = "./images/" + name
    files = glob.glob(dir + "/*.png")
    for i, file in enumerate(files):
        image = Image.open(file)
        image = image.convert("RGB")
        image = image.resize((image_size, image_size))
        data = np.asarray(image)
        X.append(data)
        Y.append(index)
 
X = np.array(X)
Y = np.array(Y)

X = X.astype('float32')
X = X / 255.0

# 正解ラベルの形式を変換
Y = np_utils.to_categorical(Y, 8)

# 学習用データとテストデータ
# test_size = テスト用データの割合
X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.20)

# CNNを構築

print("develop CNN")

model = Sequential()
 
model.add(Conv2D(32, (3, 3), padding='same',input_shape=X_train.shape[1:]))
model.add(Activation('relu'))
model.add(Conv2D(32, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
 
model.add(Conv2D(64, (3, 3), padding='same'))
model.add(Activation('relu'))
model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
 
model.add(Flatten())
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(8)) #クラス数
model.add(Activation('softmax'))
 
print("compile")

# コンパイル
model.compile(loss='categorical_crossentropy',optimizer='SGD',metrics=['accuracy'])

tsb = TensorBoard(log_dir='./logs')
mcp = ModelCheckpoint(filepath="./models/model.ep{epoch:02d}.h5", period=50)
period = 50
print("train start")

#訓練
history = model.fit(X_train, y_train,
        epochs=3000,
        verbose=1,
        validation_data=(X_test, y_test),
        callbacks=[tsb, mcp])

#評価 & 評価結果出力
print(model.evaluate(X_test, y_test))

