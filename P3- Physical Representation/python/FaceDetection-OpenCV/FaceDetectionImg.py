# FACE DETECTION http://docs.opencv.org/trunk/d7/d8b/tutorial_py_face_detection.html

"""
1 - install libraries in python
2 - install pip - package manager for Python - sudo easy_install pip
https://stackoverflow.com/questions/17271319/how-do-i-install-pip-on-macos-or-os-x
3 - intstall numpy through pip - pip install numpy
4 - install brew - package manager for macOS
5 - install cv2 (pip + homebrew) as cv2 is not only python
6 - brew tap homebrew/science to retrieve opencv install instructions
7 - install opencv - brew install opencv
https://stackoverflow.com/questions/3325528/how-to-install-opencv-for-python
8 - configure/connect opencv downloaded with brew with python
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work
9 - add path to bash_profilehttps://unix.stackexchange.com/questions/138504/setting-path-vs-exporting-path-in-bash-profile
10- install matplotlib through pip https://stackoverflow.com/questions/41067007/trouble-with-cv2-imshow-function
11- scrap instagram terminal: instagram-scraper --tag face -m 50
https://github.com/rarcega/instagram-scraper
12 - Face Detection on Your Photo Collection in Python
https://simplyml.com/face-detection-on-your-photo-collection-in-python/

"""

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import cv2
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')
img = cv2.imread('img/test.jpeg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


faces = face_cascade.detectMultiScale(gray, 1.3, 5)
for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
    roi_gray = gray[y:y+h, x:x+w]
    roi_color = img[y:y+h, x:x+w]
    eyes = eye_cascade.detectMultiScale(roi_gray)
    for (ex,ey,ew,eh) in eyes:
        cv2.rectangle(roi_color,(ex,ey),(ex+ew,ey+eh),(0,255,0),2)

plt.imshow(img)
plt.show()
"""
#
cv2.imshow('img',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
"""
