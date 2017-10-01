import os, glob, argparse, sys
from sys import argv

def main(args):
    parser = argparse.ArgumentParser(description='Batch file rename')
    parser.add_argument('-s', '--start', default=0, type=int, help='starting number to count from')
    parser.add_argument('-p', '--prefix', default='img', type=str, help='Prefix to use before number')
    parser.add_argument('-d', '--directory', default='/Users/gene/Downloads/', type=str, help='Directory folder to rename')
    args = parser.parse_args()

    base_dir = args.directory
    sub_dir_list = glob.glob(base_dir + '*')

    for dir_item in sub_dir_list:
        files = glob.glob(dir_item + '/*.jpg')
        i = args.start
        for f in files:
            print(os.path.join(dir_item, str(i)))
            os.rename(f, os.path.join(dir_item, args.prefix + '_' + str(i) + '.jpg'))
            i += 1


if __name__ == '__main__':
    try:
        main(argv)
    except KeyboardInterrupt:
        pass
    sys.exit()