# Your large paragraph
large_paragraph = """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo! conse. asdfsadfsa dfsa  asfs adfsa. asfdsadf safsa fsdf. as fs. afsaf. sd d. adf sdfsafdas fdsad fsadfsa fasdfsadf asdfsa dfasf sadfsa fdas dfasfds afdasfdasfas dfsafsadfasdf safdasfdsaf asfa sfdas fasf dasfd asfdasfsafdsa fdas dfasdfasfdsafasdfasfdasfsafasfsa fsa fdasfdsafdasfsa fd. adsfsafdsaff asdfsf. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. adf sdfsafdas fdsad fsadfsa fasdfsadf asdfsa dfasf sadfsa fdas dfasfds afdasfdasfas dfsafsadfasdf safdasfdsaf asfa sfdas fasf dasfd asfdasfsafdsa fdas dfasdfasfdsafasdfasfdasfsafasfsa fsa fdasfdsafdasfsa fd. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. adf sdfsafdas fdsad fsadfsa fasdfsadf asdfsa dfasf sadfsa fdas dfasfds afdasfdasfas dfsafsadfasdf safdasfdsaf asfa sfdas fasf dasfd asfdasfsafdsa fdas dfasdfasfdsafasdfasfdasfsafasfsa fsa fdasfdsafdasfsa fd."""

# Set the maximum characters per chunk
max_chars = 280

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
