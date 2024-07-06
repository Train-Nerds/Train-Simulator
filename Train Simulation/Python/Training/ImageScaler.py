from PIL import Image

def scaleImage(inName,outName,sqSize=1000,save=False,inFolderPath='Trainerds\\Training\\Unsized Training Images',outFolderPath='Trainerds\\Training\\Sized Training Images') -> Image:
    # Scale PNG image to 1000x1000 (or other square size) from any given size, returns Image object and can save the image
    image = Image.open(f'{inFolderPath}\\{inName}.png')
    newImage = image.resize((sqSize,sqSize), resample=Image.BOX)
    if (save):
        newImage.save(f'{outFolderPath}\\{outName}.png')
    return newImage