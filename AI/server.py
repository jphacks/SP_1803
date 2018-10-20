# coding: utf-8
from flask import Flask, request, make_response, jsonify
import cv2 as cv
import numpy as np
from keras.models import load_model
from keras.preprocessing import image
import os

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024

confThreshold = 0.5
nmsThreshold = 0.4
inpWidth = 416
inpHeight = 416

count = 0

send_data = []
categories = ["cute_m","cute_w", "disgusting_m", "disgusting_w", "good_m","good_w", "interesting_m", "interesting_w"]

# Yolo関連のモデルの読み込み
modelConfiguration = "yolov3-tiny.cfg"
modelWeights = "yolov3-tiny.weights"

net = cv.dnn.readNetFromDarknet(modelConfiguration, modelWeights)
net.setPreferableBackend(cv.dnn.DNN_BACKEND_OPENCV)
net.setPreferableTarget(cv.dnn.DNN_TARGET_CPU)


def getOutputsNames(net):
    layersNames = net.getLayerNames()
    return [layersNames[i[0] - 1] for i in net.getUnconnectedOutLayers()]


def load_image(img_path, show=False):
    img = image.load_img(img_path, target_size=(64, 64))
    img_tensor = image.img_to_array(img)                    # (height, width, channels)
    img_tensor = np.expand_dims(img_tensor, axis=0)         # (1, height, width, channels), add a dimension because the model expects this shape: (batch_size, height, width, channels)
    img_tensor /= 255.                                      # imshow expects values in the range [0, 1]

    return img_tensor


def drawPred(conf, left, top, right, bottom, frame):
    model = load_model("model.ep699.h5")
    tmp = {}

    dst = frame[top:bottom, left:right]
    cv.imwrite('hoge' + '.jpg', dst)

    new_image = load_image('hoge' + '.jpg')
    pred = model.predict(new_image)

    for pre in pred:
        y = pre.argmax()
        tmp = {
            categories[y]: [left, top, right, bottom]
        }

    send_data.append(tmp)


def postprocess(frame, outs):
    frameHeight = frame.shape[0]
    frameWidth = frame.shape[1]
    confidences = []
    boxes = []

    for out in outs:
        for detection in out:
            scores = detection[5:]
            classId = np.argmax(scores)
            confidence = scores[classId]
            if confidence > confThreshold:
                center_x = int(detection[0] * frameWidth)
                center_y = int(detection[1] * frameHeight)
                width = int(detection[2] * frameWidth)
                height = int(detection[3] * frameHeight)
                left = int(center_x - width / 2)
                top = int(center_y - height / 2)
                confidences.append(float(confidence))
                boxes.append([left, top, width, height])

    indices = cv.dnn.NMSBoxes(boxes, confidences, confThreshold, nmsThreshold)

    # Yoloで出力されるボックスの位置を出す
    for i in indices:
        i = i[0]
        box = boxes[i]
        left = box[0]
        top = box[1]
        width = box[2]
        height = box[3]

        drawPred(confidences[i], left, top, left + width, top + height, frame)

@app.route('/')
def hello():
    del send_data[:]
    # if 'uploadFile' not in request.files:
    #     make_response(jsonify({'result': 'uploadFile is required.'}))
    # file = request.files['uploadFile']

    # Yoloを用いたネットワークの構築
    im = cv.imread('person.jpg')
    blob = cv.dnn.blobFromImage(im, 1 / 255, (inpWidth, inpHeight), [0, 0, 0], 1, crop=False)
    net.setInput(blob)
    outs = net.forward(getOutputsNames(net))
    postprocess(im, outs)

    return jsonify(result=send_data)


if __name__ == '__main__':
    app.run(debug = True, host='0.0.0.0', port=5000)
