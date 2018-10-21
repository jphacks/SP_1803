from keras.models import load_model
from keras.preprocessing import image
import numpy as np
import os


def load_image(img_path, show=False):

    img = image.load_img(img_path, target_size=(64, 64))
    img_tensor = image.img_to_array(img)                    # (height, width, channels)
    img_tensor = np.expand_dims(img_tensor, axis=0)         # (1, height, width, channels), add a dimension because the model expects this shape: (batch_size, height, width, channels)
    img_tensor /= 255.                                      # imshow expects values in the range [0, 1]

    return img_tensor

model = load_model("./models/model.womanep2999.h5")
new_image = load_image('./images/test.jpg')
pred = model.predict(new_image)

categories = ["cute_w","disgusting_w","good_w", "interesting_w"]


for pre in pred:
  y = pre.argmax()
  print("sense: ", categories[y])
  print("sense: ", pre[y])


print(pred[0])
