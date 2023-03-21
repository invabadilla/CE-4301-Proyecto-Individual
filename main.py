import subprocess
import PIL.Image as Image

def fileReader(path):
    file = open(path, 'r')
    data = file.read()
    file.close()
    return data

def toList(data):
    listedData = []
    temp = ''
    for i in data:
        if i != ' ':
            temp += i
        else:
            listedData.append(int(temp))
            temp = ''
    listedData.append(int(temp))
    return listedData

if __name__ == "__main__":


    subprocess.call(['./deco'])

    path = "./5.txt"
    ecryptedPic = fileReader(path)
    ecryptedPic = toList(ecryptedPic)
    pic = Image.new('L', (320, 640))
    pic.putdata(ecryptedPic)
    pic.save("encripted.png")
    pic.close()

