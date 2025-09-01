from PIL import Image
import matplotlib.pyplot as plt
import numpy as np

def merge_images_side_by_side_and_plot(img_path1, img_path2):
    # Open images
    img1 = Image.open(img_path1)
    img2 = Image.open(img_path2)

    # Resize images to same height with high-quality resampling
    if img1.height != img2.height:
        common_height = min(img1.height, img2.height)
        img1 = img1.resize((int(img1.width * common_height / img1.height), common_height), Image.LANCZOS)
        img2 = img2.resize((int(img2.width * common_height / img2.height), common_height), Image.LANCZOS)

    # Create new image with combined width
    total_width = img1.width + img2.width
    max_height = max(img1.height, img2.height)
    new_img = Image.new('RGB', (total_width, max_height))

    # Paste images side by side
    new_img.paste(img1, (0, 0))
    new_img.paste(img2, (img1.width, 0))

    # Convert to NumPy array and show with matplotlib
    merged_array = np.array(new_img)
    plt.imshow(merged_array)
    plt.axis('off')
    plt.tight_layout(pad=0)
    plt.show()

# Example usage
merge_images_side_by_side_and_plot(
    "Refresh_Counts_WUPR_AR_Comparison.png",
    "Refresh_Energy_Saving_Comparison_plot.png"
)
