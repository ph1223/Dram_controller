#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

#复位引脚
set_location_assignment	PIN_27	-to	RESET
#时钟引脚
set_location_assignment	PIN_24	-to	CLOCK
#时钟输出引脚
set_location_assignment	PIN_30	-to	CLK_OUT
#外部时钟输入引脚
set_location_assignment	PIN_28	-to	CLK_IN  
#SDRAM引脚
set_location_assignment	PIN_88	-to	S_DB[0]
set_location_assignment	PIN_87	-to	S_DB[1]
set_location_assignment	PIN_86	-to	S_DB[2]
set_location_assignment	PIN_84	-to	S_DB[3]
set_location_assignment	PIN_82	-to	S_DB[4]
set_location_assignment	PIN_81	-to	S_DB[5]
set_location_assignment	PIN_80	-to	S_DB[6]
set_location_assignment	PIN_77	-to	S_DB[7]
set_location_assignment	PIN_45	-to	S_DB[8]
set_location_assignment	PIN_46	-to	S_DB[9]
set_location_assignment	PIN_47	-to	S_DB[10]
set_location_assignment	PIN_48	-to	S_DB[11]
set_location_assignment	PIN_56	-to	S_DB[12]
set_location_assignment	PIN_57	-to	S_DB[13]
set_location_assignment	PIN_58	-to	S_DB[14]
set_location_assignment	PIN_59	-to	S_DB[15]
set_location_assignment	PIN_64	-to	S_A[0]
set_location_assignment	PIN_63	-to	S_A[1]
set_location_assignment	PIN_61	-to	S_A[2]
set_location_assignment	PIN_60	-to	S_A[3]
set_location_assignment	PIN_31 	-to	S_A[4]
set_location_assignment	PIN_33	-to	S_A[5]
set_location_assignment	PIN_34	-to	S_A[6]
set_location_assignment	PIN_35	-to	S_A[7]
set_location_assignment	PIN_37	-to	S_A[8]
set_location_assignment	PIN_39	-to	S_A[9]
set_location_assignment	PIN_67	-to	S_A[10]
set_location_assignment	PIN_40	-to	S_A[11]
set_location_assignment	PIN_43	-to	S_CLK
set_location_assignment	PIN_69	-to	S_BA[0]
set_location_assignment	PIN_68	-to	S_BA[1]
set_location_assignment	PIN_74	-to	S_nCAS
set_location_assignment	PIN_41	-to	S_CKE
set_location_assignment	PIN_72	-to	S_nRAS
set_location_assignment	PIN_75	-to	S_nWE
set_location_assignment	PIN_70 	-to	S_nCS
set_location_assignment	PIN_44	-to	S_DQM[1]
set_location_assignment	PIN_76	-to	S_DQM[0]
#FLASH引脚
set_location_assignment	PIN_143	-to	F_DB[0]
set_location_assignment	PIN_144	-to	F_DB[1]
set_location_assignment	PIN_145	-to	F_DB[2]
set_location_assignment	PIN_146	-to	F_DB[3]
set_location_assignment	PIN_147	-to	F_DB[4]
set_location_assignment	PIN_149	-to	F_DB[5]
set_location_assignment	PIN_150	-to	F_DB[6]
set_location_assignment	PIN_151	-to	F_DB[7]
set_location_assignment	PIN_139	-to	F_A[0]
set_location_assignment	PIN_138	-to	F_A[1]
set_location_assignment	PIN_137	-to	F_A[2]
set_location_assignment	PIN_135	-to	F_A[3]
set_location_assignment	PIN_134 -to	F_A[4]
set_location_assignment	PIN_133	-to	F_A[5]
set_location_assignment	PIN_128	-to	F_A[6]
set_location_assignment	PIN_127	-to	F_A[7]
set_location_assignment	PIN_114	-to	F_A[8]
set_location_assignment	PIN_113	-to	F_A[9]
set_location_assignment	PIN_112	-to	F_A[10]
set_location_assignment	PIN_110	-to	F_A[11]
set_location_assignment	PIN_108	-to	F_A[12]
set_location_assignment	PIN_107	-to	F_A[13]
set_location_assignment	PIN_106 -to	F_A[14]
set_location_assignment	PIN_105	-to	F_A[15]
set_location_assignment	PIN_160	-to	F_A[16]
set_location_assignment	PIN_118	-to	F_A[17]
set_location_assignment	PIN_117	-to	F_A[18]
set_location_assignment	PIN_115	-to	F_A[19] 
set_location_assignment	PIN_152	-to	F_ALSB
set_location_assignment	PIN_116	-to	F_nWE
set_location_assignment	PIN_141 -to	F_nCE
set_location_assignment	PIN_142	-to	F_NOE
#VGA引脚
set_location_assignment	PIN_14	-to	VGA_R[0]
set_location_assignment	PIN_13	-to	VGA_R[1]
set_location_assignment	PIN_12	-to	VGA_R[2]
set_location_assignment	PIN_11	-to	VGA_G[0]
set_location_assignment	PIN_10	-to	VGA_G[1]
set_location_assignment	PIN_8	-to	VGA_G[2]
set_location_assignment	PIN_6	-to	VGA_B[0]
set_location_assignment	PIN_5	-to	VGA_B[1]
set_location_assignment	PIN_4	-to	VGA_HS
set_location_assignment	PIN_3	-to	VGA_VS
#LED引脚
set_location_assignment	PIN_201	-to	LED[0]
set_location_assignment	PIN_203	-to	LED[1]
set_location_assignment	PIN_205	-to	LED[2]
set_location_assignment	PIN_206	-to	LED[3]
set_location_assignment	PIN_207	-to	LED[4]
set_location_assignment	PIN_208	-to	LED[5]
#按键引脚
set_location_assignment	PIN_97	-to	KEY_OK
set_location_assignment	PIN_131	-to	KEY_UP
set_location_assignment	PIN_130   -to	KEY_DOWN
set_location_assignment	PIN_129	-to	KEY_LEFT
set_location_assignment	PIN_99	-to	KEY_RIGHT
set_location_assignment	PIN_132	-to	KEY_ESC
#24LC04引脚
set_location_assignment	PIN_199	-to	I2C_SDA
set_location_assignment	PIN_200	-to	I2C_SCL
#PS/2引脚
set_location_assignment	PIN_191	-to	PS2_DAT
set_location_assignment	PIN_192	-to	PS2_CLK
#DS1302（实时时钟）引脚
set_location_assignment	PIN_161	-to	RTC_SCLK
set_location_assignment	PIN_163 -to	RTC_nRST
set_location_assignment	PIN_162	-to	RTC_DATA
#蜂鸣器引脚
set_location_assignment	PIN_15	-to	BUZZER
#数码管引脚
set_location_assignment	PIN_169	-to	DIG[0]
set_location_assignment	PIN_168	-to	DIG[1]
set_location_assignment	PIN_165	-to	DIG[2]
set_location_assignment	PIN_164	-to	DIG[3]
set_location_assignment	PIN_175	-to	DIG[4]
set_location_assignment	PIN_173	-to	DIG[5]
set_location_assignment	PIN_171	-to	DIG[6]
set_location_assignment	PIN_170	-to	DIG[7]
set_location_assignment	PIN_185	-to	SEL[5]
set_location_assignment	PIN_182	-to	SEL[4]
set_location_assignment	PIN_181	-to	SEL[3]
set_location_assignment	PIN_180	-to	SEL[2]
set_location_assignment	PIN_179	-to	SEL[1] 
set_location_assignment	PIN_176	-to	SEL[0]
#USB转串口引脚
set_location_assignment		PIN_193	-to	USB2UART_RXD
set_location_assignment		PIN_195	-to	USB2UART_TXD
#串口引脚
set_location_assignment		PIN_198	-to	RXD
set_location_assignment		PIN_197	-to	TXD
#485引脚
set_location_assignment		PIN_189	-to	485RXD
set_location_assignment		PIN_187	-to	485TXD
set_location_assignment		PIN_188	-to	485DIR
#拨码开关引脚
set_location_assignment		PIN_89	-to	SW[5]
set_location_assignment		PIN_90	-to	SW[4]
set_location_assignment		PIN_92	-to	SW[3]
set_location_assignment		PIN_94	-to	SW[2]
set_location_assignment		PIN_95	-to	SW[1]
set_location_assignment		PIN_96	-to	SW[0]
#------------------END-----------------------#





