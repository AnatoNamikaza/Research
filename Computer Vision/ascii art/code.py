from PIL import Image

def image_to_ascii(image_path, output_width=80):
    # Open the image file
    image = Image.open(image_path)

    # Resize the image to match the desired output width
    aspect_ratio = image.height / image.width
    output_height = int(output_width * aspect_ratio)
    image = image.resize((output_width, output_height))

    # Convert each pixel to grayscale and map to ASCII characters
    ascii_chars = '@%#*+=-:. '

    ascii_image = ''
    for y in range(output_height):
        for x in range(output_width):
            pixel = image.getpixel((x, y))
            brightness = sum(pixel) / 3 / 255.0
            ascii_image += ascii_chars[int(brightness * (len(ascii_chars) - 1))]
        ascii_image += '\n'

    return ascii_image

# Example usage:
image_path = 'image.png'
ascii_text = image_to_ascii(image_path)
print(ascii_text)
