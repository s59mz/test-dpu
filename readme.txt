###########################################################

  Testing the Deep Learning Processor Unit DPU on the 
   Xilinx ZYNQ Ultrascale+ FPGA 

  These are test Scripts for testing DPU unit performance in FPGA
  It uses pre-built models for RF Classification 

  Original project:
    https://github.com/Xilinx/Vitis-AI-Tutorials/tree/master/Design_Tutorials/10-RF_modulation_recognition

##########################################################



####   Quick Start   ####


# To run DPU Performacce test
./run_test_performance.sh


# To run Model Accuracy test
./run_test_accuracy.sh


# To run DPU Image Recognize test
./run_test_recognize_image.sh


# To check the DPU fingerprint - must be the sam as in arch.json file
 xdputil query


# To run RF Classification Application 
./run_rf_classification	.sh




####   Some details...

# Set path to FPGA bin file before running any test scripts 
 export XLNX_VART_FIRMWARE=/media/sd-mmcblk1p1/dpu.xclbin

 python3 test_performance.py 4 ./models/rfClassification.xmodel 1000

# Model Accuracy test
 python3 test_accuracy.py ./models/rfClassification.xmodel

# Image Recognition test
 export LD_LIBRARY_PATH=/media/sd-mmcblk1p1/app/samples/lib
 ./dpu-test img/unknown_image.jpeg
 

