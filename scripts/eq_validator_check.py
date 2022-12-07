import logging
import sys

import requests
from requests.exceptions import RequestException

logger = logging.getLogger(__name__)

try:
    response = requests.get(
        "https://api.github.com/repos/ONSdigital/eq-questionnaire-validator/releases",
        timeout=120,
    )
    if response.status_code == 200:
        with open(".schema-validator-version", encoding="UTF-8") as f:
            version = next(f).strip()
        latest_tag = response.json()[0]["tag_name"]
        if latest_tag != version:
            logger.error(
                "eq-questionnaire-validator is out of date. Update version using the .schema-validator-version file"
            )
            sys.exit(1)
    else:
        logger.error("Can't check eq-questionnaire-validator version")
        sys.exit(0)

except RequestException:
    logger.error("Can't check eq-questionnaire-validator version")
    sys.exit(0)
