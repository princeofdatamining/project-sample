import os
from utils import Sitemap
from utils import settings


sitemap = Sitemap(settings.ENDPOINT)


def get_media(basename, makedirs=True):
    filename = os.path.join(settings.MEDIA_ROOT, basename)
    url = sitemap.join(settings.MEDIA_URL + basename)
    if makedirs:
        os.makedirs(os.path.dirname(filename), exist_ok=True)
    return filename, url
