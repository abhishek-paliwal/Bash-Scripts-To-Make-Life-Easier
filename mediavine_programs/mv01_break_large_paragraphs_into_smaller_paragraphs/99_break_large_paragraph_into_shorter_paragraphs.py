# Your large paragraph
large_paragraph = """Chocolate Covered Kiwi, also known as Kiwi dipped in chocolate or Chocolate Dipped Kiwi, is a gratifying confection that effortlessly marries the goodness of fresh kiwifruit with the satisfaction of premium chocolate. This exquisite dessert has a stunning blend of flavors and textures. Summers are all about meeting friends and having get-togethers. But sometimes we all have guests who don’t drink any alcoholic beverages. Last week some of our friends joined us for dinner. Dinner parties usually start at 5.00 pm at my place. I know, I know, it’s too early for a dinner party. But we all chit-chat before dinner and have some good time. So even 5:00 pm feels late in that context! Agree? 🙂"""

# Set the maximum characters per chunk
max_chars = 300

# Function to break the paragraph into chunks
def break_into_chunks(paragraph, max_chars):
    chunks = []
    while len(paragraph) > max_chars:
        # Find the last occurrence of . or ! or ? in the chunk
        last_period = max(paragraph[:max_chars].rfind('.'), paragraph[:max_chars].rfind('!'), paragraph[:max_chars].rfind('?'))

        if last_period > 0:
            chunks.append(paragraph[:last_period + 1])
            paragraph = paragraph[last_period + 1:]
        else:
            chunks.append(paragraph[:max_chars])
            paragraph = paragraph[max_chars:]

    chunks.append(paragraph)
    return chunks

# Break the paragraph into chunks
chunks = break_into_chunks(large_paragraph, max_chars)

# Print the chunks
for chunk in chunks:
    print('\n')
    print(chunk)
    print(len(chunk))
