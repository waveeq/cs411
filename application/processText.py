import re
from nltk.stem import WordNetLemmatizer
from nltk import word_tokenize
from nltk.corpus import stopwords
import nltk

nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')


def process_text(text):
    stop_words = set(stopwords.words('english'))
    wn = WordNetLemmatizer()
    text = re.sub(r"[^a-zA-Z]+", ' ', text)
    clean_text = word_tokenize(text.lower())
    clean_text = [wn.lemmatize(word, pos="v") for word in clean_text]
    clean_text = [word for word in clean_text if not word in stop_words]
    return " ".join(clean_text)