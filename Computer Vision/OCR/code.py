from PIL import Image
import pytesseract

# Path to the Tesseract OCR executable (update this with your installation path)
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def image_to_text_table(image_path):
    # Open the image
    img = Image.open(image_path)

    # Use OCR to extract text from the image
    text = pytesseract.image_to_string(img)

    # Process the extracted text to format it into a table
    lines = text.split('\n')
    table = '+'.join(['-' * (len(cell) + 2) for cell in lines[0].split('|')])
    formatted_text = f"{table}\n|{'|'.join([cell.strip().center(len(cell) + 2) for cell in lines[0].split('|')])}|\n{table}\n"

    for line in lines[1:]:
        formatted_text += f"|{'|'.join([cell.strip().center(len(cell) + 2) for cell in line.split('|')])}|\n{table}\n"

    return formatted_text

# Example usage
image_path = 'path/to/your/table_image.png'
result = image_to_text_table(image_path)
print(result)
