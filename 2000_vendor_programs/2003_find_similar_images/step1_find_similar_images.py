from itertools import product
from pathlib import Path

from PIL import Image, ImageChops


def summarise(img: Image.Image) -> Image.Image:
    """Summarise an image into a 16 x 16 image."""
    resized = img.resize((16, 16))
    return resized


def difference(img1: Image.Image, img2: Image.Image) -> float:
    """Find the difference between two images."""

    diff = ImageChops.difference(img1, img2)

    acc = 0
    width, height = diff.size
    for w, h in product(range(width), range(height)):
        r, g, b = diff.getpixel((w, h))
        acc += (r + g + b) / 3

    average_diff = acc / (width * height)
    normalised_diff = average_diff / 255
    return normalised_diff


def explore_directory(path: Path) -> None:
    """Find images in a directory and compare them all."""

    files = (
        list(path.glob("*.jpg")) + list(path.glob("*.jpeg")) + list(path.glob("*.png"))
    )
    diffs = {}

    summaries = [(file, summarise(Image.open(file))) for file in files]

    for (f1, sum1), (f2, sum2) in product(summaries, repeat=2):
        key = tuple(sorted([str(f1), str(f2)]))
        if f1 == f2 or key in diffs:
            continue

        diff = difference(sum1, sum2)
        print(key, diff)
        diffs[key] = diff

    print()
    print("Near-duplicates found:")
    print("======================")
    for key, diff in diffs.items():
        if diff < 0.07:
            print(key)
    ## save results to a text file
    print(">> Writing results to text file = _tmp_step1_result_file.txt")
    with open("_tmp_step1_result_file.txt", "w") as f:
        for key, diff in diffs.items():
            if diff < 0.07:
                f.write(str(key) + "\n")        


if __name__ == "__main__":
    print("IMPORTANT NOTE: Please put all your images in this directory => find_similar_images_in_this_directory")
    explore_directory(Path("find_similar_images_in_this_directory"))
