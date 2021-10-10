.PHONY: export_requirements gpu_base_image gpu_image min_image

export_requirements:
	poetry export -o requirements.txt --without-hashes

gpu_base_image:
	docker build -f gpu.dockerfile -t openimage/jupyter:gpu-base .

gpu_image:
	docker build --build-arg BASE_IMAGE=openimage/jupyter:gpu-base -t openimage/jupyter:gpu .

min_image:
	docker build -f min.dockerfile -t openimage/jupyter:min .
