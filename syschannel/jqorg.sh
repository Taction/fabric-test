jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups":{"SampleConsortium":{"groups": {"Org3MSP":.[1]}}}}}}}' sysconfig.json ../channel-artifacts/org3.json > modified_sysconfig.json
