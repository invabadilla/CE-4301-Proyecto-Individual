import subprocess
<<<<<<< HEAD
import tkinter as tk
from PIL import Image, ImageTk
=======
import PIL.Image as Image
>>>>>>> write-into-the-file

def fileReader(path):
    file = open(path, 'r')
    data = file.read()
    file.close()
    return data

<<<<<<< HEAD
def leer_archivo_txt(nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        contenido = f.read()
    lista_numeros = [float(n) for n in contenido.split()]
    return lista_numeros
=======
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
>>>>>>> write-into-the-file

if __name__ == "__main__":

<<<<<<< HEAD
if __name__ == "__main__":

    d = input("Ingrese el valor de d: ")
    n = input("Ingrese el valor de n: ")

    llave = d + " " + n + " "

    file = open("key.txt", "w")
    file.write(llave)
    file.close()

    subprocess.call(['./deco'])

    path = './5.txt'
    ecryptedPic = leer_archivo_txt(path)
    pic = Image.new('L', (640, 960))
    pic.putdata(ecryptedPic)
    pic.save("encripted.png")
    pic.close()


    path = "./deco.txt"

    decryptedPic = leer_archivo_txt(path)
    pic = Image.new('L', (640, 480))
    pic.putdata(decryptedPic)
    pic.save("dencripted.png")
    pic.close()

    # Crea una ventana
    root = tk.Tk()
    root.geometry("1280x1440")

    # Carga las imágenes
    image1 = Image.open("encripted.png")
    image2 = Image.open("dencripted.png")

    # Convierte las imágenes a formato Tkinter
    tk_image1 = ImageTk.PhotoImage(image1)
    tk_image2 = ImageTk.PhotoImage(image2)

    # Crea dos etiquetas para mostrar las imágenes
    label1 = tk.Label(root, image=tk_image1)
    label1.grid(row=0, column=0)

    label2 = tk.Label(root, image=tk_image2)
    label2.grid(row=0, column=1)

    # Ejecuta la ventana
    root.mainloop()
=======

    subprocess.call(['./deco'])

    path = "./5.txt"
    ecryptedPic = fileReader(path)
    ecryptedPic = toList(ecryptedPic)
    pic = Image.new('L', (320, 640))
    pic.putdata(ecryptedPic)
    pic.save("encripted.png")
    pic.close()
>>>>>>> write-into-the-file

