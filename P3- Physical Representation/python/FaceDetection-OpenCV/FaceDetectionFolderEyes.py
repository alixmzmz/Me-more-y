# EYE Detection on Your Photo Collection in Python https://simplyml.com/face-detection-on-your-photo-collection-in-python/

"""

"""

# Import OpenCV - os - argparse
import cv2
import os
import argparse

# load classifiers
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')

# DETECT FACES ON A FILE
def get_faces(filename):

    # read image
    img = cv2.imread(filename)

    # convert image to greyscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # detect faces - save position in image where there is a face
    faces = face_cascade.detectMultiScale(gray, 1.2, 5)

    # array (multiple faces in image)
    face_images = []

    for (x, y, w, h) in faces:
        roi_gray = gray[y:y + h, x:x + w]
        roi_color = img[y:y + h, x:x + w]

        eyes = eye_cascade.detectMultiScale(roi_gray)
        if len(eyes) >= 1:
            face_images.append(roi_color)

        return face_images

# DETECT EYES IN FACES
def get_eyes(filename):

    # read image
    img = cv2.imread(filename)

    # convert image to greyscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # detect faces - save position in image where there is a face
    eyes = eye_cascade.detectMultiScale(gray, 1.3, 5) # 1.2 to 1.3 increase accuracy

    # array (multiple faces in image)
    eye_images = []

    for (x, y, w, h) in eyes:
        roi_gray = gray[y:y + h, x:x + w]
        roi_color = img[y:y + h, x:x + w]
        eye_images.append(roi_color)

    return eye_images


# SCAN IMAGES FROM FOLDER
def scan_images(root_dir, output_dir):
    image_extensions = ["jpg", "png", "JPG", "PNG", "jpeg", "JPEG"]
    num_eyes = 8755
    num_images = 0

    """use os.walk to walk through all the subdirectories and files in root_dir.
    For image files (in this case png and jpeg files) we call get_faces and save the resulting faces into separate files """

    for dir_name, subdir_list, file_list in os.walk(root_dir):
        print('Scanning directory: %s' % dir_name)
        for filename in file_list:
            extension = os.path.splitext(filename)[1][1:]
            if extension in image_extensions:
                eyes = get_eyes(os.path.join(dir_name, filename)) # for each valid image save all the faces that appear in the images
                num_images += 1

                # for face in faces:
                #     face_filename = os.path.join(output_dir, "face{}.png".format(num_faces))
                #     cv2.imwrite(face_filename, face)
                #     print("\tWrote {} extracted from {}".format(face_filename, filename))
                #     num_faces += 1

                for eye in eyes:
                    eye_filename = os.path.join(output_dir, "eye{}.png".format(num_eyes))
                    cv2.imwrite(eye_filename, eye)
                    print("\tWrote {} extracted from {}".format(eye_filename, filename))
                    num_eyes += 1

# MAIN PROGRAM TO SCAN IMAGES FROM A FOLDER (python FaceDetectionFolderEyes.py _facesOriginal _eyesExported)
# AND SAVE FACES IN A SPECIFIED FOLDER (mkdir _eyesExported)

# ROOT FOR ALL IMAGES INSIDE /Users/alixmzmz/Desktop/of_v0.9.8_osx_release/apps/Me-mory/06_ImageTSNELiveAll/bin/data
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract eyes from photos.')
    parser.add_argument('imagesdir', type=str, help='Input directory of images')
    parser.add_argument('outputdir', type=str, help='Output directory for eyes')
    args = parser.parse_args()

    scan_images(args.imagesdir, args.outputdir)
