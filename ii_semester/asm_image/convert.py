from PIL import Image
from os import listdir


def get_pixels(image: Image, convert_format='RGB'):
    pixels = [[(0, 0, 0) for i in range(image.width)] for j in range(image.height)]
    image = image.convert(convert_format)
    for i in range(image.height):
        for j in range(image.width):
            pixels[i][j] = image.getpixel((j, i))  # Костыль
    return pixels


def merge_duplicates(colors):
    result = ''
    count = 0
    current_color = colors[0]
    for color in colors:
        if current_color != color:
            if count > 4:
                result += f'{count} dup ({current_color}),'
            else:
                result += f'{current_color},' * count
            current_color = color
            count = 1
        else:
            count += 1
    result += f'{count} dup ({current_color})'
    return result


def main(filename):
    image = Image.open(filename)
    pixels = sum(get_pixels(image), [])
    palette = {
        (255, 0, 0): 4,
        (255,204,153): 90,
        (255, 153, 255): 36,
        (255, 153, 0): 42,
        (255, 51, 153): 20,
        (255, 255, 0): 44,
        (153, 153, 153): 22,
        (51, 255, 0): 48,
        (189, 255, 247): 11,
        (0, 153, 255): 54,
        (255, 153, 153): 65,
        (102, 51, 255): 17,
        (231, 231, 148): 93,
        (107, 107, 0): 143,
        (231, 156, 33): 43,
        (255, 255, 255): 15,
        (255, 255, 254): 15,
        (236, 231, 144): 92,
        (236, 155, 0): 42,
        (189, 68, 0): 6,
        (126, 126, 0): 2,
        (0, 0, 0): 0,
        (0, 0, 1): 0,
        (156, 74, 0): 6,
        (99, 99, 99): 22,
        (89, 13, 121): 34,
        (90, 0, 123): 34,
        (89, 13, 121): 34,
        (107, 107, 0): 191,
        (181, 49, 33): 4,
        (107, 8, 0): 102,
        (173, 173, 173): 25,
        (0, 82, 8): 2,
        (140, 214, 0): 11,
        (8, 74, 0): 2
    }
    colors = list(map(lambda x: palette[x], pixels))
    merged = merge_duplicates(colors)
    i = 0
    prev = 0
    var = filename.split('.')[0]
    print(var, end=' ')
    while i < len(merged):
        i += 100
        while i < len(merged) and merged[i] != ',':
            i += 1
        print('db ' + merged[prev:i])
        i += 1
        prev = i
    print(var + f'_nums dw {image.width}, {image.height}')
    print()

if __name__ == '__main__':
    for file in listdir('.'):
        if file.endswith('.png'):
            main(file)
