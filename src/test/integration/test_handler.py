from src.app.main import handler

import os
import json
import pytest

@pytest.fixture(name="apigw_event")
def apigw_event():
    sample_json_path = os.path.join(os.path.dirname(__file__), '..', 'events', 'sample_api_event.json')
    with open(sample_json_path) as json_file:
        return json.loads(json_file.read())

def test_handler_when_proxy_event_for_sum(apigw_event):
    result = handler(apigw_event, None)
    assert result["body"]["result"] == 3