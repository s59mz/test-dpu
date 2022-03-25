cd /media/sd-mmcblk0p1/app/model
echo "Recognising Unknown Image..."

XLNX_VART_FIRMWARE=/media/sd-mmcblk0p1/dpu.xclbin \
	LD_LIBRARY_PATH=/media/sd-mmcblk0p1/app/samples/lib \
	/media/sd-mmcblk0p1/dpu-test \
	/media/sd-mmcblk0p1/test-dpu/img/unknown_image.jpeg 
cd -
