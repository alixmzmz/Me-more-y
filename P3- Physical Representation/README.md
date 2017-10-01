# Me-more-y

## P3 - Physical representation
This work uses the material from http://ml4a.github.io/guides

### Openframeworks

1. ImageTSNELive
* Require the following add-ons
ofxAssignment
ofxCcv
ofxGui
ofxJSON
ofxTSNE

* Download trained model files required for tSNE from:
image-net-2012.sqlite3 - https://raw.githubusercontent.com/liuliu/ccv/unstable/samples/image-net-2012.sqlite3
image-net-2012.words - https://raw.githubusercontent.com/liuliu/ccv/unstable/samples/image-net-2012.words

* Save files in ```imagetSNELive/bin/data/```

* To run tSNE, save images in the following folder:
```imagetSNELive/bin/data/images/```


2. Mosaic
* Require the following add-ons
ofxAssignment
ofxEMD
ofxHistogram
ofxOpenCv

* Save files in ```Mosaic/bin/data/```

### Python

### Python/collage_maker-master

* Original script from here. It creates a collage/grid of images from a specified folder:
http://delimitry.blogspot.co.uk/2014/07/picture-collage-maker-using-python.html

### Python/FaceDetection-OpenCV

* Script to extract faces and eyes from pictures in a specified folder

### Python/google-images-scraper

* Script to scrap from Google images a specified number of images of a tag
* Script adapted from http://stackoverflow.com/questions/20716842/python-download-images-from-google-image-search

### Python/rename-files

* Script to rename batch of images with a tag and number in a specified folder

### Python/tSNE

* To run tSNE download and add the following to the tSNE folder (python/tsne/101_objectCategories):
https://github.com/mikeizbicki/datasets/tree/master/image/101_ObjectCategories
