
output=function.zip

.PHONY: build clean plan apply destroy test

build: ${output}

${output}: python-demo/python-demo.py
	(cd python-demo; zip ../${output} python-demo.py)

clean:
	@if [ -e ${output} ]; then rm ${output}; fi
	@exit 0

plan: build
	terraform plan

apply: build
	terraform apply -auto-approve

destroy:
	terraform destroy

test:
	aws lambda list-functions
	aws lambda invoke --function-name python-demo --invocation-type RequestResponse output.txt
	@echo "Output:"
	@cat output.txt
	@echo
	@rm output.txt
