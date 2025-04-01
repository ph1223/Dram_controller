setenv MC2_INSTALL_DIR /home/process/TN16FFC/IP/CBTK_TSMC16FFC_core_TSMC_v2.0/CIC/Memory/MC2_2013.12.00.f
set path = ($MC2_INSTALL_DIR/bin $path)

if (${?LM_LICENSE_FILE} == 0) then
    setenv LM_LICENSE_FILE 7270@lshc
else
    setenv LM_LICENSE_FILE 7270@lshc:$LM_LICENSE_FILE
endif

