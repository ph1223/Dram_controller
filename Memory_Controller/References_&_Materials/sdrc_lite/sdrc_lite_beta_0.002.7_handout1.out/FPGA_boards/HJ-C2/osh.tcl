##############################################
#      	URL:    http://www.oshcn.org
#      	REV:    1.0
#	 AUTHOR:    AVIC
#	   DATE:    2010.6.19
#############################################

#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_23	-to	RESET
set_location_assignment	PIN_28	-to	CLOCK
#------------------SDRAM---------------------#
set_location_assignment	PIN_175	-to	S_DB[0]
set_location_assignment	PIN_173	-to	S_DB[1]
set_location_assignment	PIN_171	-to	S_DB[2]
set_location_assignment	PIN_170	-to	S_DB[3]
set_location_assignment	PIN_169	-to	S_DB[4]
set_location_assignment	PIN_168	-to	S_DB[5]
set_location_assignment	PIN_165	-to	S_DB[6]
set_location_assignment	PIN_164	-to	S_DB[7]
set_location_assignment	PIN_205	-to	S_DB[8]
set_location_assignment	PIN_203	-to	S_DB[9]
set_location_assignment	PIN_201	-to	S_DB[10]
set_location_assignment	PIN_200	-to	S_DB[11]
set_location_assignment	PIN_199	-to	S_DB[12]
set_location_assignment	PIN_198	-to	S_DB[13]
set_location_assignment	PIN_197	-to	S_DB[14]
set_location_assignment	PIN_195	-to	S_DB[15]

set_location_assignment	PIN_179	-to	S_A[0]
set_location_assignment	PIN_180	-to	S_A[1]
set_location_assignment	PIN_181	-to	S_A[2]
set_location_assignment	PIN_182	-to	S_A[3]
set_location_assignment	PIN_185	-to	S_A[4]
set_location_assignment	PIN_187	-to	S_A[5]
set_location_assignment	PIN_188	-to	S_A[6]
set_location_assignment	PIN_189	-to	S_A[7]
set_location_assignment	PIN_191	-to	S_A[8]
set_location_assignment	PIN_192	-to	S_A[9]
set_location_assignment	PIN_176	-to	S_A[10]
set_location_assignment	PIN_193	-to	S_A[11]

set_location_assignment	PIN_207	-to	S_CLK
set_location_assignment	PIN_151	-to	S_BA[0]
set_location_assignment	PIN_150	-to	S_BA[1]
set_location_assignment	PIN_161	-to	S_nCAS
set_location_assignment	PIN_208	-to	S_CKE
set_location_assignment	PIN_160	-to	S_nRAS
set_location_assignment	PIN_162	-to	S_nWE
set_location_assignment	PIN_152	-to	S_nCS
set_location_assignment	PIN_206	-to	S_DQM[1]
set_location_assignment	PIN_163	-to	S_DQM[0]
#------------------USB------------------------#
set_location_assignment	PIN_117	-to	USB_DB[0]
set_location_assignment	PIN_118	-to	USB_DB[1]
set_location_assignment	PIN_127	-to	USB_DB[2]
set_location_assignment	PIN_128	-to	USB_DB[3]
set_location_assignment	PIN_133	-to	USB_DB[4]
set_location_assignment	PIN_134	-to	USB_DB[5]
set_location_assignment	PIN_135	-to	USB_DB[6]
set_location_assignment	PIN_137	-to	USB_DB[7]

set_location_assignment	PIN_113	-to	USB_A0
set_location_assignment	PIN_115	-to	USB_WR
set_location_assignment	PIN_116	-to	USB_nINT
set_location_assignment	PIN_114	-to	USB_RD
#--------------------LAN----------------------#
set_location_assignment	PIN_129	-to	LAN_nINT
set_location_assignment	PIN_131 -to	LAN_nWOL
set_location_assignment	PIN_104	-to	LAN_MOSI
set_location_assignment	PIN_132	-to	LAN_MISO
set_location_assignment	PIN_103	-to	LAN_SCK
set_location_assignment	PIN_102	-to	LAN_CS 
set_location_assignment	PIN_105	-to	LAN_nRST 
#--------------------VGA----------------------#
set_location_assignment	PIN_142	-to	VGA[0]
set_location_assignment	PIN_143	-to	VGA[1]
set_location_assignment	PIN_144	-to	VGA[2]
set_location_assignment	PIN_146	-to	VGA_HS
set_location_assignment	PIN_145	-to	VGA_VS
#--------------------LCD----------------------#
set_location_assignment	PIN_8	-to	LCD_CS
set_location_assignment	PIN_12	-to	LCD_A0
set_location_assignment	PIN_11	-to	LCD_SCL
set_location_assignment	PIN_14	-to	LCD_SI
#--------------------LED----------------------#
set_location_assignment	PIN_69	-to	LED[0]
set_location_assignment	PIN_70	-to	LED[1]
set_location_assignment	PIN_72	-to	LED[2]
set_location_assignment	PIN_74	-to	LED[3]
#--------------------KEY----------------------#
set_location_assignment	PIN_3	-to	KEY[0]
set_location_assignment	PIN_5	-to	KEY[1]
set_location_assignment	PIN_4   -to	KEY[2]
set_location_assignment	PIN_10	-to	KEY[3]
set_location_assignment	PIN_6	-to	KEY[4]
#--------------------UART---------------------#
set_location_assignment	PIN_147	-to	RXD
set_location_assignment	PIN_149	-to	TXD
#--------------------24LC04-------------------#
set_location_assignment	PIN_112	-to	I2C_SDA
set_location_assignment	PIN_110	-to	I2C_SCL
#---------------------PS2---------------------#
set_location_assignment	PIN_139	-to	PS2_DAT
set_location_assignment	PIN_138	-to	PS2_CLK
#--------------------DS1302-------------------#
set_location_assignment	PIN_108	-to	RTC_SCLK
set_location_assignment	PIN_106	-to	RTC_nRST
set_location_assignment	PIN_107	-to	RTC_DATA
#------------------BUZZER---------------------#
set_location_assignment	PIN_141	-to	BUZZER
#--------------------DIG----------------------#
set_location_assignment	PIN_44	-to	DIG[0]
set_location_assignment	PIN_43	-to	DIG[1]
set_location_assignment	PIN_46	-to 	DIG[2]
set_location_assignment	PIN_56	-to	DIG[3]
set_location_assignment	PIN_57	-to	DIG[4]
set_location_assignment	PIN_48	-to	DIG[5]
set_location_assignment	PIN_47	-to	DIG[6]
set_location_assignment	PIN_45	-to 	DIG[7]
set_location_assignment	PIN_58	-to 	SEL[5]
set_location_assignment	PIN_59	-to	SEL[4]
set_location_assignment	PIN_60	-to	SEL[3]
set_location_assignment	PIN_61	-to	SEL[2]
set_location_assignment	PIN_63	-to 	SEL[1]
set_location_assignment	PIN_64	-to	SEL[0]
#------------------END-----------------------#





