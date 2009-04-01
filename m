From: akpm@linux-foundation.org
Subject: [merged] atyfb-fix-header-file-trailing-whitespace.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:20 -0700
Message-ID: <200904011842.n31IgKTu009682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758977AbZDATfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: fix header file trailing whitespace
has been removed from the -mm tree.  Its filename was
     atyfb-fix-header-file-trailing-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: fix header file trailing whitespace
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix trailing whitespace because quilt complained about it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/aty128.h |    2 
 include/video/radeon.h |  564 +++++++++++++++++++--------------------
 2 files changed, 283 insertions(+), 283 deletions(-)

diff -puN include/video/aty128.h~atyfb-fix-header-file-trailing-whitespace include/video/aty128.h
--- a/include/video/aty128.h~atyfb-fix-header-file-trailing-whitespace
+++ a/include/video/aty128.h
@@ -415,7 +415,7 @@
 #define PWR_MGT_SLOWDOWN_MCLK			0x00002000
 
 #define PMI_PMSCR_REG				0x60
-                                                                                
+
 /* used by ATI bug fix for hardware ROM */
 #define RAGE128_MPP_TB_CONFIG                   0x01c0
 
diff -puN include/video/radeon.h~atyfb-fix-header-file-trailing-whitespace include/video/radeon.h
--- a/include/video/radeon.h~atyfb-fix-header-file-trailing-whitespace
+++ a/include/video/radeon.h
@@ -5,12 +5,12 @@
 #define RADEON_REGSIZE			0x4000
 
 
-#define MM_INDEX                               0x0000  
-#define MM_DATA                                0x0004  
-#define BUS_CNTL                               0x0030  
-#define HI_STAT                                0x004C  
+#define MM_INDEX                               0x0000
+#define MM_DATA                                0x0004
+#define BUS_CNTL                               0x0030
+#define HI_STAT                                0x004C
 #define BUS_CNTL1                              0x0034
-#define I2C_CNTL_1			       0x0094  
+#define I2C_CNTL_1			       0x0094
 #define CNFG_CNTL                              0x00E0
 #define CNFG_MEMSIZE                           0x00F8
 #define CNFG_APER_0_BASE                       0x0100
@@ -18,8 +18,8 @@
 #define CNFG_APER_SIZE                         0x0108
 #define CNFG_REG_1_BASE                        0x010C
 #define CNFG_REG_APER_SIZE                     0x0110
-#define PAD_AGPINPUT_DELAY                     0x0164  
-#define PAD_CTLR_STRENGTH                      0x0168  
+#define PAD_AGPINPUT_DELAY                     0x0164
+#define PAD_CTLR_STRENGTH                      0x0168
 #define PAD_CTLR_UPDATE                        0x016C
 #define PAD_CTLR_MISC                          0x0aa0
 #define AGP_CNTL                               0x0174
@@ -27,171 +27,171 @@
 #define CAP0_TRIG_CNTL			       0x0950
 #define CAP1_TRIG_CNTL		               0x09c0
 #define VIPH_CONTROL			       0x0C40
-#define VENDOR_ID                              0x0F00  
-#define DEVICE_ID                              0x0F02  
-#define COMMAND                                0x0F04  
-#define STATUS                                 0x0F06  
-#define REVISION_ID                            0x0F08  
-#define REGPROG_INF                            0x0F09  
-#define SUB_CLASS                              0x0F0A  
-#define BASE_CODE                              0x0F0B  
-#define CACHE_LINE                             0x0F0C  
-#define LATENCY                                0x0F0D  
-#define HEADER                                 0x0F0E  
-#define BIST                                   0x0F0F  
-#define REG_MEM_BASE                           0x0F10  
-#define REG_IO_BASE                            0x0F14  
+#define VENDOR_ID                              0x0F00
+#define DEVICE_ID                              0x0F02
+#define COMMAND                                0x0F04
+#define STATUS                                 0x0F06
+#define REVISION_ID                            0x0F08
+#define REGPROG_INF                            0x0F09
+#define SUB_CLASS                              0x0F0A
+#define BASE_CODE                              0x0F0B
+#define CACHE_LINE                             0x0F0C
+#define LATENCY                                0x0F0D
+#define HEADER                                 0x0F0E
+#define BIST                                   0x0F0F
+#define REG_MEM_BASE                           0x0F10
+#define REG_IO_BASE                            0x0F14
 #define REG_REG_BASE                           0x0F18
 #define ADAPTER_ID                             0x0F2C
 #define BIOS_ROM                               0x0F30
-#define CAPABILITIES_PTR                       0x0F34  
-#define INTERRUPT_LINE                         0x0F3C  
-#define INTERRUPT_PIN                          0x0F3D  
-#define MIN_GRANT                              0x0F3E  
-#define MAX_LATENCY                            0x0F3F  
-#define ADAPTER_ID_W                           0x0F4C  
-#define PMI_CAP_ID                             0x0F50  
-#define PMI_NXT_CAP_PTR                        0x0F51  
-#define PMI_PMC_REG                            0x0F52  
-#define PM_STATUS                              0x0F54  
-#define PMI_DATA                               0x0F57  
-#define AGP_CAP_ID                             0x0F58  
-#define AGP_STATUS                             0x0F5C  
-#define AGP_COMMAND                            0x0F60  
+#define CAPABILITIES_PTR                       0x0F34
+#define INTERRUPT_LINE                         0x0F3C
+#define INTERRUPT_PIN                          0x0F3D
+#define MIN_GRANT                              0x0F3E
+#define MAX_LATENCY                            0x0F3F
+#define ADAPTER_ID_W                           0x0F4C
+#define PMI_CAP_ID                             0x0F50
+#define PMI_NXT_CAP_PTR                        0x0F51
+#define PMI_PMC_REG                            0x0F52
+#define PM_STATUS                              0x0F54
+#define PMI_DATA                               0x0F57
+#define AGP_CAP_ID                             0x0F58
+#define AGP_STATUS                             0x0F5C
+#define AGP_COMMAND                            0x0F60
 #define AIC_CTRL                               0x01D0
 #define AIC_STAT                               0x01D4
 #define AIC_PT_BASE                            0x01D8
-#define AIC_LO_ADDR                            0x01DC  
-#define AIC_HI_ADDR                            0x01E0  
-#define AIC_TLB_ADDR                           0x01E4  
-#define AIC_TLB_DATA                           0x01E8  
-#define DAC_CNTL                               0x0058  
+#define AIC_LO_ADDR                            0x01DC
+#define AIC_HI_ADDR                            0x01E0
+#define AIC_TLB_ADDR                           0x01E4
+#define AIC_TLB_DATA                           0x01E8
+#define DAC_CNTL                               0x0058
 #define DAC_CNTL2                              0x007c
-#define CRTC_GEN_CNTL                          0x0050  
-#define MEM_CNTL                               0x0140  
+#define CRTC_GEN_CNTL                          0x0050
+#define MEM_CNTL                               0x0140
 #define MC_CNTL                                0x0140
-#define EXT_MEM_CNTL                           0x0144  
+#define EXT_MEM_CNTL                           0x0144
 #define MC_TIMING_CNTL                         0x0144
-#define MC_AGP_LOCATION                        0x014C  
-#define MEM_IO_CNTL_A0                         0x0178  
+#define MC_AGP_LOCATION                        0x014C
+#define MEM_IO_CNTL_A0                         0x0178
 #define MEM_REFRESH_CNTL                       0x0178
-#define MEM_INIT_LATENCY_TIMER                 0x0154  
+#define MEM_INIT_LATENCY_TIMER                 0x0154
 #define MC_INIT_GFX_LAT_TIMER                  0x0154
-#define MEM_SDRAM_MODE_REG                     0x0158  
-#define AGP_BASE                               0x0170  
-#define MEM_IO_CNTL_A1                         0x017C  
+#define MEM_SDRAM_MODE_REG                     0x0158
+#define AGP_BASE                               0x0170
+#define MEM_IO_CNTL_A1                         0x017C
 #define MC_READ_CNTL_AB                        0x017C
 #define MEM_IO_CNTL_B0                         0x0180
 #define MC_INIT_MISC_LAT_TIMER                 0x0180
 #define MEM_IO_CNTL_B1                         0x0184
 #define MC_IOPAD_CNTL                          0x0184
 #define MC_DEBUG                               0x0188
-#define MC_STATUS                              0x0150  
-#define MEM_IO_OE_CNTL                         0x018C  
+#define MC_STATUS                              0x0150
+#define MEM_IO_OE_CNTL                         0x018C
 #define MC_CHIP_IO_OE_CNTL_AB                  0x018C
-#define MC_FB_LOCATION                         0x0148  
-#define HOST_PATH_CNTL                         0x0130  
-#define MEM_VGA_WP_SEL                         0x0038  
-#define MEM_VGA_RP_SEL                         0x003C  
-#define HDP_DEBUG                              0x0138  
+#define MC_FB_LOCATION                         0x0148
+#define HOST_PATH_CNTL                         0x0130
+#define MEM_VGA_WP_SEL                         0x0038
+#define MEM_VGA_RP_SEL                         0x003C
+#define HDP_DEBUG                              0x0138
 #define SW_SEMAPHORE                           0x013C
-#define CRTC2_GEN_CNTL                         0x03f8  
+#define CRTC2_GEN_CNTL                         0x03f8
 #define CRTC2_DISPLAY_BASE_ADDR                0x033c
-#define SURFACE_CNTL                           0x0B00  
-#define SURFACE0_LOWER_BOUND                   0x0B04  
-#define SURFACE1_LOWER_BOUND                   0x0B14  
-#define SURFACE2_LOWER_BOUND                   0x0B24  
-#define SURFACE3_LOWER_BOUND                   0x0B34  
-#define SURFACE4_LOWER_BOUND                   0x0B44  
+#define SURFACE_CNTL                           0x0B00
+#define SURFACE0_LOWER_BOUND                   0x0B04
+#define SURFACE1_LOWER_BOUND                   0x0B14
+#define SURFACE2_LOWER_BOUND                   0x0B24
+#define SURFACE3_LOWER_BOUND                   0x0B34
+#define SURFACE4_LOWER_BOUND                   0x0B44
 #define SURFACE5_LOWER_BOUND                   0x0B54
 #define SURFACE6_LOWER_BOUND                   0x0B64
 #define SURFACE7_LOWER_BOUND                   0x0B74
-#define SURFACE0_UPPER_BOUND                   0x0B08  
-#define SURFACE1_UPPER_BOUND                   0x0B18  
-#define SURFACE2_UPPER_BOUND                   0x0B28  
-#define SURFACE3_UPPER_BOUND                   0x0B38  
-#define SURFACE4_UPPER_BOUND                   0x0B48  
-#define SURFACE5_UPPER_BOUND                   0x0B58  
-#define SURFACE6_UPPER_BOUND                   0x0B68  
-#define SURFACE7_UPPER_BOUND                   0x0B78  
-#define SURFACE0_INFO                          0x0B0C  
-#define SURFACE1_INFO                          0x0B1C  
-#define SURFACE2_INFO                          0x0B2C  
-#define SURFACE3_INFO                          0x0B3C  
-#define SURFACE4_INFO                          0x0B4C  
-#define SURFACE5_INFO                          0x0B5C  
+#define SURFACE0_UPPER_BOUND                   0x0B08
+#define SURFACE1_UPPER_BOUND                   0x0B18
+#define SURFACE2_UPPER_BOUND                   0x0B28
+#define SURFACE3_UPPER_BOUND                   0x0B38
+#define SURFACE4_UPPER_BOUND                   0x0B48
+#define SURFACE5_UPPER_BOUND                   0x0B58
+#define SURFACE6_UPPER_BOUND                   0x0B68
+#define SURFACE7_UPPER_BOUND                   0x0B78
+#define SURFACE0_INFO                          0x0B0C
+#define SURFACE1_INFO                          0x0B1C
+#define SURFACE2_INFO                          0x0B2C
+#define SURFACE3_INFO                          0x0B3C
+#define SURFACE4_INFO                          0x0B4C
+#define SURFACE5_INFO                          0x0B5C
 #define SURFACE6_INFO                          0x0B6C
 #define SURFACE7_INFO                          0x0B7C
 #define SURFACE_ACCESS_FLAGS                   0x0BF8
-#define SURFACE_ACCESS_CLR                     0x0BFC  
-#define GEN_INT_CNTL                           0x0040  
-#define GEN_INT_STATUS                         0x0044  
+#define SURFACE_ACCESS_CLR                     0x0BFC
+#define GEN_INT_CNTL                           0x0040
+#define GEN_INT_STATUS                         0x0044
 #define CRTC_EXT_CNTL                          0x0054
-#define RB3D_CNTL			       0x1C3C  
-#define WAIT_UNTIL                             0x1720  
-#define ISYNC_CNTL                             0x1724  
-#define RBBM_GUICNTL                           0x172C  
-#define RBBM_STATUS                            0x0E40  
-#define RBBM_STATUS_alt_1                      0x1740  
-#define RBBM_CNTL                              0x00EC  
-#define RBBM_CNTL_alt_1                        0x0E44  
-#define RBBM_SOFT_RESET                        0x00F0  
-#define RBBM_SOFT_RESET_alt_1                  0x0E48  
-#define NQWAIT_UNTIL                           0x0E50  
+#define RB3D_CNTL			       0x1C3C
+#define WAIT_UNTIL                             0x1720
+#define ISYNC_CNTL                             0x1724
+#define RBBM_GUICNTL                           0x172C
+#define RBBM_STATUS                            0x0E40
+#define RBBM_STATUS_alt_1                      0x1740
+#define RBBM_CNTL                              0x00EC
+#define RBBM_CNTL_alt_1                        0x0E44
+#define RBBM_SOFT_RESET                        0x00F0
+#define RBBM_SOFT_RESET_alt_1                  0x0E48
+#define NQWAIT_UNTIL                           0x0E50
 #define RBBM_DEBUG                             0x0E6C
 #define RBBM_CMDFIFO_ADDR                      0x0E70
 #define RBBM_CMDFIFO_DATAL                     0x0E74
-#define RBBM_CMDFIFO_DATAH                     0x0E78  
-#define RBBM_CMDFIFO_STAT                      0x0E7C  
-#define CRTC_STATUS                            0x005C  
-#define GPIO_VGA_DDC                           0x0060  
-#define GPIO_DVI_DDC                           0x0064  
-#define GPIO_MONID                             0x0068  
+#define RBBM_CMDFIFO_DATAH                     0x0E78
+#define RBBM_CMDFIFO_STAT                      0x0E7C
+#define CRTC_STATUS                            0x005C
+#define GPIO_VGA_DDC                           0x0060
+#define GPIO_DVI_DDC                           0x0064
+#define GPIO_MONID                             0x0068
 #define GPIO_CRT2_DDC                          0x006c
-#define PALETTE_INDEX                          0x00B0  
-#define PALETTE_DATA                           0x00B4  
-#define PALETTE_30_DATA                        0x00B8  
-#define CRTC_H_TOTAL_DISP                      0x0200  
-#define CRTC_H_SYNC_STRT_WID                   0x0204  
-#define CRTC_V_TOTAL_DISP                      0x0208  
-#define CRTC_V_SYNC_STRT_WID                   0x020C  
-#define CRTC_VLINE_CRNT_VLINE                  0x0210  
+#define PALETTE_INDEX                          0x00B0
+#define PALETTE_DATA                           0x00B4
+#define PALETTE_30_DATA                        0x00B8
+#define CRTC_H_TOTAL_DISP                      0x0200
+#define CRTC_H_SYNC_STRT_WID                   0x0204
+#define CRTC_V_TOTAL_DISP                      0x0208
+#define CRTC_V_SYNC_STRT_WID                   0x020C
+#define CRTC_VLINE_CRNT_VLINE                  0x0210
 #define CRTC_CRNT_FRAME                        0x0214
 #define CRTC_GUI_TRIG_VLINE                    0x0218
 #define CRTC_DEBUG                             0x021C
-#define CRTC_OFFSET_RIGHT                      0x0220  
-#define CRTC_OFFSET                            0x0224  
-#define CRTC_OFFSET_CNTL                       0x0228  
-#define CRTC_PITCH                             0x022C  
-#define OVR_CLR                                0x0230  
-#define OVR_WID_LEFT_RIGHT                     0x0234  
-#define OVR_WID_TOP_BOTTOM                     0x0238  
-#define DISPLAY_BASE_ADDR                      0x023C  
-#define SNAPSHOT_VH_COUNTS                     0x0240  
-#define SNAPSHOT_F_COUNT                       0x0244  
-#define N_VIF_COUNT                            0x0248  
-#define SNAPSHOT_VIF_COUNT                     0x024C  
-#define FP_CRTC_H_TOTAL_DISP                   0x0250  
-#define FP_CRTC_V_TOTAL_DISP                   0x0254  
+#define CRTC_OFFSET_RIGHT                      0x0220
+#define CRTC_OFFSET                            0x0224
+#define CRTC_OFFSET_CNTL                       0x0228
+#define CRTC_PITCH                             0x022C
+#define OVR_CLR                                0x0230
+#define OVR_WID_LEFT_RIGHT                     0x0234
+#define OVR_WID_TOP_BOTTOM                     0x0238
+#define DISPLAY_BASE_ADDR                      0x023C
+#define SNAPSHOT_VH_COUNTS                     0x0240
+#define SNAPSHOT_F_COUNT                       0x0244
+#define N_VIF_COUNT                            0x0248
+#define SNAPSHOT_VIF_COUNT                     0x024C
+#define FP_CRTC_H_TOTAL_DISP                   0x0250
+#define FP_CRTC_V_TOTAL_DISP                   0x0254
 #define CRT_CRTC_H_SYNC_STRT_WID               0x0258
 #define CRT_CRTC_V_SYNC_STRT_WID               0x025C
 #define CUR_OFFSET                             0x0260
-#define CUR_HORZ_VERT_POSN                     0x0264  
-#define CUR_HORZ_VERT_OFF                      0x0268  
-#define CUR_CLR0                               0x026C  
-#define CUR_CLR1                               0x0270  
-#define FP_HORZ_VERT_ACTIVE                    0x0278  
-#define CRTC_MORE_CNTL                         0x027C  
+#define CUR_HORZ_VERT_POSN                     0x0264
+#define CUR_HORZ_VERT_OFF                      0x0268
+#define CUR_CLR0                               0x026C
+#define CUR_CLR1                               0x0270
+#define FP_HORZ_VERT_ACTIVE                    0x0278
+#define CRTC_MORE_CNTL                         0x027C
 #define CRTC_H_CUTOFF_ACTIVE_EN                (1<<4)
 #define CRTC_V_CUTOFF_ACTIVE_EN                (1<<5)
-#define DAC_EXT_CNTL                           0x0280  
-#define FP_GEN_CNTL                            0x0284  
-#define FP_HORZ_STRETCH                        0x028C  
-#define FP_VERT_STRETCH                        0x0290  
-#define FP_H_SYNC_STRT_WID                     0x02C4  
-#define FP_V_SYNC_STRT_WID                     0x02C8  
-#define AUX_WINDOW_HORZ_CNTL                   0x02D8  
-#define AUX_WINDOW_VERT_CNTL                   0x02DC  
+#define DAC_EXT_CNTL                           0x0280
+#define FP_GEN_CNTL                            0x0284
+#define FP_HORZ_STRETCH                        0x028C
+#define FP_VERT_STRETCH                        0x0290
+#define FP_H_SYNC_STRT_WID                     0x02C4
+#define FP_V_SYNC_STRT_WID                     0x02C8
+#define AUX_WINDOW_HORZ_CNTL                   0x02D8
+#define AUX_WINDOW_VERT_CNTL                   0x02DC
 //#define DDA_CONFIG			       0x02e0
 //#define DDA_ON_OFF			       0x02e4
 #define DVI_I2C_CNTL_1			       0x02e4
@@ -199,192 +199,192 @@
 #define GRPH2_BUFFER_CNTL                      0x03F0
 #define VGA_BUFFER_CNTL                        0x02F4
 #define OV0_Y_X_START                          0x0400
-#define OV0_Y_X_END                            0x0404  
-#define OV0_PIPELINE_CNTL                      0x0408  
-#define OV0_REG_LOAD_CNTL                      0x0410  
-#define OV0_SCALE_CNTL                         0x0420  
-#define OV0_V_INC                              0x0424  
-#define OV0_P1_V_ACCUM_INIT                    0x0428  
-#define OV0_P23_V_ACCUM_INIT                   0x042C  
-#define OV0_P1_BLANK_LINES_AT_TOP              0x0430  
-#define OV0_P23_BLANK_LINES_AT_TOP             0x0434  
-#define OV0_BASE_ADDR                          0x043C  
-#define OV0_VID_BUF0_BASE_ADRS                 0x0440  
-#define OV0_VID_BUF1_BASE_ADRS                 0x0444  
-#define OV0_VID_BUF2_BASE_ADRS                 0x0448  
-#define OV0_VID_BUF3_BASE_ADRS                 0x044C  
+#define OV0_Y_X_END                            0x0404
+#define OV0_PIPELINE_CNTL                      0x0408
+#define OV0_REG_LOAD_CNTL                      0x0410
+#define OV0_SCALE_CNTL                         0x0420
+#define OV0_V_INC                              0x0424
+#define OV0_P1_V_ACCUM_INIT                    0x0428
+#define OV0_P23_V_ACCUM_INIT                   0x042C
+#define OV0_P1_BLANK_LINES_AT_TOP              0x0430
+#define OV0_P23_BLANK_LINES_AT_TOP             0x0434
+#define OV0_BASE_ADDR                          0x043C
+#define OV0_VID_BUF0_BASE_ADRS                 0x0440
+#define OV0_VID_BUF1_BASE_ADRS                 0x0444
+#define OV0_VID_BUF2_BASE_ADRS                 0x0448
+#define OV0_VID_BUF3_BASE_ADRS                 0x044C
 #define OV0_VID_BUF4_BASE_ADRS                 0x0450
 #define OV0_VID_BUF5_BASE_ADRS                 0x0454
 #define OV0_VID_BUF_PITCH0_VALUE               0x0460
-#define OV0_VID_BUF_PITCH1_VALUE               0x0464  
-#define OV0_AUTO_FLIP_CNTRL                    0x0470  
-#define OV0_DEINTERLACE_PATTERN                0x0474  
-#define OV0_SUBMIT_HISTORY                     0x0478  
-#define OV0_H_INC                              0x0480  
-#define OV0_STEP_BY                            0x0484  
-#define OV0_P1_H_ACCUM_INIT                    0x0488  
-#define OV0_P23_H_ACCUM_INIT                   0x048C  
-#define OV0_P1_X_START_END                     0x0494  
-#define OV0_P2_X_START_END                     0x0498  
-#define OV0_P3_X_START_END                     0x049C  
-#define OV0_FILTER_CNTL                        0x04A0  
-#define OV0_FOUR_TAP_COEF_0                    0x04B0  
-#define OV0_FOUR_TAP_COEF_1                    0x04B4  
+#define OV0_VID_BUF_PITCH1_VALUE               0x0464
+#define OV0_AUTO_FLIP_CNTRL                    0x0470
+#define OV0_DEINTERLACE_PATTERN                0x0474
+#define OV0_SUBMIT_HISTORY                     0x0478
+#define OV0_H_INC                              0x0480
+#define OV0_STEP_BY                            0x0484
+#define OV0_P1_H_ACCUM_INIT                    0x0488
+#define OV0_P23_H_ACCUM_INIT                   0x048C
+#define OV0_P1_X_START_END                     0x0494
+#define OV0_P2_X_START_END                     0x0498
+#define OV0_P3_X_START_END                     0x049C
+#define OV0_FILTER_CNTL                        0x04A0
+#define OV0_FOUR_TAP_COEF_0                    0x04B0
+#define OV0_FOUR_TAP_COEF_1                    0x04B4
 #define OV0_FOUR_TAP_COEF_2                    0x04B8
 #define OV0_FOUR_TAP_COEF_3                    0x04BC
 #define OV0_FOUR_TAP_COEF_4                    0x04C0
-#define OV0_FLAG_CNTRL                         0x04DC  
-#define OV0_SLICE_CNTL                         0x04E0  
-#define OV0_VID_KEY_CLR_LOW                    0x04E4  
-#define OV0_VID_KEY_CLR_HIGH                   0x04E8  
-#define OV0_GRPH_KEY_CLR_LOW                   0x04EC  
-#define OV0_GRPH_KEY_CLR_HIGH                  0x04F0  
-#define OV0_KEY_CNTL                           0x04F4  
-#define OV0_TEST                               0x04F8  
-#define SUBPIC_CNTL                            0x0540  
-#define SUBPIC_DEFCOLCON                       0x0544  
-#define SUBPIC_Y_X_START                       0x054C  
-#define SUBPIC_Y_X_END                         0x0550  
-#define SUBPIC_V_INC                           0x0554  
-#define SUBPIC_H_INC                           0x0558  
+#define OV0_FLAG_CNTRL                         0x04DC
+#define OV0_SLICE_CNTL                         0x04E0
+#define OV0_VID_KEY_CLR_LOW                    0x04E4
+#define OV0_VID_KEY_CLR_HIGH                   0x04E8
+#define OV0_GRPH_KEY_CLR_LOW                   0x04EC
+#define OV0_GRPH_KEY_CLR_HIGH                  0x04F0
+#define OV0_KEY_CNTL                           0x04F4
+#define OV0_TEST                               0x04F8
+#define SUBPIC_CNTL                            0x0540
+#define SUBPIC_DEFCOLCON                       0x0544
+#define SUBPIC_Y_X_START                       0x054C
+#define SUBPIC_Y_X_END                         0x0550
+#define SUBPIC_V_INC                           0x0554
+#define SUBPIC_H_INC                           0x0558
 #define SUBPIC_BUF0_OFFSET                     0x055C
 #define SUBPIC_BUF1_OFFSET                     0x0560
 #define SUBPIC_LC0_OFFSET                      0x0564
-#define SUBPIC_LC1_OFFSET                      0x0568  
-#define SUBPIC_PITCH                           0x056C  
-#define SUBPIC_BTN_HLI_COLCON                  0x0570  
-#define SUBPIC_BTN_HLI_Y_X_START               0x0574  
-#define SUBPIC_BTN_HLI_Y_X_END                 0x0578  
-#define SUBPIC_PALETTE_INDEX                   0x057C  
-#define SUBPIC_PALETTE_DATA                    0x0580  
-#define SUBPIC_H_ACCUM_INIT                    0x0584  
-#define SUBPIC_V_ACCUM_INIT                    0x0588  
-#define DISP_MISC_CNTL                         0x0D00  
-#define DAC_MACRO_CNTL                         0x0D04  
-#define DISP_PWR_MAN                           0x0D08  
-#define DISP_TEST_DEBUG_CNTL                   0x0D10  
-#define DISP_HW_DEBUG                          0x0D14  
+#define SUBPIC_LC1_OFFSET                      0x0568
+#define SUBPIC_PITCH                           0x056C
+#define SUBPIC_BTN_HLI_COLCON                  0x0570
+#define SUBPIC_BTN_HLI_Y_X_START               0x0574
+#define SUBPIC_BTN_HLI_Y_X_END                 0x0578
+#define SUBPIC_PALETTE_INDEX                   0x057C
+#define SUBPIC_PALETTE_DATA                    0x0580
+#define SUBPIC_H_ACCUM_INIT                    0x0584
+#define SUBPIC_V_ACCUM_INIT                    0x0588
+#define DISP_MISC_CNTL                         0x0D00
+#define DAC_MACRO_CNTL                         0x0D04
+#define DISP_PWR_MAN                           0x0D08
+#define DISP_TEST_DEBUG_CNTL                   0x0D10
+#define DISP_HW_DEBUG                          0x0D14
 #define DAC_CRC_SIG1                           0x0D18
 #define DAC_CRC_SIG2                           0x0D1C
 #define OV0_LIN_TRANS_A                        0x0D20
-#define OV0_LIN_TRANS_B                        0x0D24  
-#define OV0_LIN_TRANS_C                        0x0D28  
-#define OV0_LIN_TRANS_D                        0x0D2C  
-#define OV0_LIN_TRANS_E                        0x0D30  
-#define OV0_LIN_TRANS_F                        0x0D34  
-#define OV0_GAMMA_0_F                          0x0D40  
-#define OV0_GAMMA_10_1F                        0x0D44  
-#define OV0_GAMMA_20_3F                        0x0D48  
-#define OV0_GAMMA_40_7F                        0x0D4C  
-#define OV0_GAMMA_380_3BF                      0x0D50  
-#define OV0_GAMMA_3C0_3FF                      0x0D54  
-#define DISP_MERGE_CNTL                        0x0D60  
-#define DISP_OUTPUT_CNTL                       0x0D64  
-#define DISP_LIN_TRANS_GRPH_A                  0x0D80  
+#define OV0_LIN_TRANS_B                        0x0D24
+#define OV0_LIN_TRANS_C                        0x0D28
+#define OV0_LIN_TRANS_D                        0x0D2C
+#define OV0_LIN_TRANS_E                        0x0D30
+#define OV0_LIN_TRANS_F                        0x0D34
+#define OV0_GAMMA_0_F                          0x0D40
+#define OV0_GAMMA_10_1F                        0x0D44
+#define OV0_GAMMA_20_3F                        0x0D48
+#define OV0_GAMMA_40_7F                        0x0D4C
+#define OV0_GAMMA_380_3BF                      0x0D50
+#define OV0_GAMMA_3C0_3FF                      0x0D54
+#define DISP_MERGE_CNTL                        0x0D60
+#define DISP_OUTPUT_CNTL                       0x0D64
+#define DISP_LIN_TRANS_GRPH_A                  0x0D80
 #define DISP_LIN_TRANS_GRPH_B                  0x0D84
 #define DISP_LIN_TRANS_GRPH_C                  0x0D88
 #define DISP_LIN_TRANS_GRPH_D                  0x0D8C
-#define DISP_LIN_TRANS_GRPH_E                  0x0D90  
-#define DISP_LIN_TRANS_GRPH_F                  0x0D94  
-#define DISP_LIN_TRANS_VID_A                   0x0D98  
-#define DISP_LIN_TRANS_VID_B                   0x0D9C  
-#define DISP_LIN_TRANS_VID_C                   0x0DA0  
-#define DISP_LIN_TRANS_VID_D                   0x0DA4  
-#define DISP_LIN_TRANS_VID_E                   0x0DA8  
-#define DISP_LIN_TRANS_VID_F                   0x0DAC  
-#define RMX_HORZ_FILTER_0TAP_COEF              0x0DB0  
-#define RMX_HORZ_FILTER_1TAP_COEF              0x0DB4  
-#define RMX_HORZ_FILTER_2TAP_COEF              0x0DB8  
-#define RMX_HORZ_PHASE                         0x0DBC  
-#define DAC_EMBEDDED_SYNC_CNTL                 0x0DC0  
-#define DAC_BROAD_PULSE                        0x0DC4  
+#define DISP_LIN_TRANS_GRPH_E                  0x0D90
+#define DISP_LIN_TRANS_GRPH_F                  0x0D94
+#define DISP_LIN_TRANS_VID_A                   0x0D98
+#define DISP_LIN_TRANS_VID_B                   0x0D9C
+#define DISP_LIN_TRANS_VID_C                   0x0DA0
+#define DISP_LIN_TRANS_VID_D                   0x0DA4
+#define DISP_LIN_TRANS_VID_E                   0x0DA8
+#define DISP_LIN_TRANS_VID_F                   0x0DAC
+#define RMX_HORZ_FILTER_0TAP_COEF              0x0DB0
+#define RMX_HORZ_FILTER_1TAP_COEF              0x0DB4
+#define RMX_HORZ_FILTER_2TAP_COEF              0x0DB8
+#define RMX_HORZ_PHASE                         0x0DBC
+#define DAC_EMBEDDED_SYNC_CNTL                 0x0DC0
+#define DAC_BROAD_PULSE                        0x0DC4
 #define DAC_SKEW_CLKS                          0x0DC8
 #define DAC_INCR                               0x0DCC
 #define DAC_NEG_SYNC_LEVEL                     0x0DD0
-#define DAC_POS_SYNC_LEVEL                     0x0DD4  
-#define DAC_BLANK_LEVEL                        0x0DD8  
-#define CLOCK_CNTL_INDEX                       0x0008  
-#define CLOCK_CNTL_DATA                        0x000C  
-#define CP_RB_CNTL                             0x0704  
-#define CP_RB_BASE                             0x0700  
-#define CP_RB_RPTR_ADDR                        0x070C  
-#define CP_RB_RPTR                             0x0710  
-#define CP_RB_WPTR                             0x0714  
-#define CP_RB_WPTR_DELAY                       0x0718  
-#define CP_IB_BASE                             0x0738  
-#define CP_IB_BUFSZ                            0x073C  
-#define SCRATCH_REG0                           0x15E0  
-#define GUI_SCRATCH_REG0                       0x15E0  
-#define SCRATCH_REG1                           0x15E4  
-#define GUI_SCRATCH_REG1                       0x15E4  
+#define DAC_POS_SYNC_LEVEL                     0x0DD4
+#define DAC_BLANK_LEVEL                        0x0DD8
+#define CLOCK_CNTL_INDEX                       0x0008
+#define CLOCK_CNTL_DATA                        0x000C
+#define CP_RB_CNTL                             0x0704
+#define CP_RB_BASE                             0x0700
+#define CP_RB_RPTR_ADDR                        0x070C
+#define CP_RB_RPTR                             0x0710
+#define CP_RB_WPTR                             0x0714
+#define CP_RB_WPTR_DELAY                       0x0718
+#define CP_IB_BASE                             0x0738
+#define CP_IB_BUFSZ                            0x073C
+#define SCRATCH_REG0                           0x15E0
+#define GUI_SCRATCH_REG0                       0x15E0
+#define SCRATCH_REG1                           0x15E4
+#define GUI_SCRATCH_REG1                       0x15E4
 #define SCRATCH_REG2                           0x15E8
 #define GUI_SCRATCH_REG2                       0x15E8
 #define SCRATCH_REG3                           0x15EC
-#define GUI_SCRATCH_REG3                       0x15EC  
-#define SCRATCH_REG4                           0x15F0  
-#define GUI_SCRATCH_REG4                       0x15F0  
-#define SCRATCH_REG5                           0x15F4  
-#define GUI_SCRATCH_REG5                       0x15F4  
-#define SCRATCH_UMSK                           0x0770  
-#define SCRATCH_ADDR                           0x0774  
-#define DP_BRUSH_FRGD_CLR                      0x147C  
+#define GUI_SCRATCH_REG3                       0x15EC
+#define SCRATCH_REG4                           0x15F0
+#define GUI_SCRATCH_REG4                       0x15F0
+#define SCRATCH_REG5                           0x15F4
+#define GUI_SCRATCH_REG5                       0x15F4
+#define SCRATCH_UMSK                           0x0770
+#define SCRATCH_ADDR                           0x0774
+#define DP_BRUSH_FRGD_CLR                      0x147C
 #define DP_BRUSH_BKGD_CLR                      0x1478
 #define DST_LINE_START                         0x1600
-#define DST_LINE_END                           0x1604  
-#define SRC_OFFSET                             0x15AC  
+#define DST_LINE_END                           0x1604
+#define SRC_OFFSET                             0x15AC
 #define SRC_PITCH                              0x15B0
 #define SRC_TILE                               0x1704
 #define SRC_PITCH_OFFSET                       0x1428
-#define SRC_X                                  0x1414  
-#define SRC_Y                                  0x1418  
-#define SRC_X_Y                                0x1590  
-#define SRC_Y_X                                0x1434  
+#define SRC_X                                  0x1414
+#define SRC_Y                                  0x1418
+#define SRC_X_Y                                0x1590
+#define SRC_Y_X                                0x1434
 #define DST_Y_X				       0x1438
 #define DST_WIDTH_HEIGHT		       0x1598
 #define DST_HEIGHT_WIDTH		       0x143c
 #define DST_OFFSET                             0x1404
-#define SRC_CLUT_ADDRESS                       0x1780  
-#define SRC_CLUT_DATA                          0x1784  
-#define SRC_CLUT_DATA_RD                       0x1788  
-#define HOST_DATA0                             0x17C0  
-#define HOST_DATA1                             0x17C4  
-#define HOST_DATA2                             0x17C8  
-#define HOST_DATA3                             0x17CC  
-#define HOST_DATA4                             0x17D0  
-#define HOST_DATA5                             0x17D4  
-#define HOST_DATA6                             0x17D8  
+#define SRC_CLUT_ADDRESS                       0x1780
+#define SRC_CLUT_DATA                          0x1784
+#define SRC_CLUT_DATA_RD                       0x1788
+#define HOST_DATA0                             0x17C0
+#define HOST_DATA1                             0x17C4
+#define HOST_DATA2                             0x17C8
+#define HOST_DATA3                             0x17CC
+#define HOST_DATA4                             0x17D0
+#define HOST_DATA5                             0x17D4
+#define HOST_DATA6                             0x17D8
 #define HOST_DATA7                             0x17DC
 #define HOST_DATA_LAST                         0x17E0
 #define DP_SRC_ENDIAN                          0x15D4
-#define DP_SRC_FRGD_CLR                        0x15D8  
-#define DP_SRC_BKGD_CLR                        0x15DC  
-#define SC_LEFT                                0x1640  
-#define SC_RIGHT                               0x1644  
-#define SC_TOP                                 0x1648  
-#define SC_BOTTOM                              0x164C  
-#define SRC_SC_RIGHT                           0x1654  
-#define SRC_SC_BOTTOM                          0x165C  
-#define DP_CNTL                                0x16C0  
-#define DP_CNTL_XDIR_YDIR_YMAJOR               0x16D0  
-#define DP_DATATYPE                            0x16C4  
-#define DP_MIX                                 0x16C8  
-#define DP_WRITE_MSK                           0x16CC  
-#define DP_XOP                                 0x17F8  
+#define DP_SRC_FRGD_CLR                        0x15D8
+#define DP_SRC_BKGD_CLR                        0x15DC
+#define SC_LEFT                                0x1640
+#define SC_RIGHT                               0x1644
+#define SC_TOP                                 0x1648
+#define SC_BOTTOM                              0x164C
+#define SRC_SC_RIGHT                           0x1654
+#define SRC_SC_BOTTOM                          0x165C
+#define DP_CNTL                                0x16C0
+#define DP_CNTL_XDIR_YDIR_YMAJOR               0x16D0
+#define DP_DATATYPE                            0x16C4
+#define DP_MIX                                 0x16C8
+#define DP_WRITE_MSK                           0x16CC
+#define DP_XOP                                 0x17F8
 #define CLR_CMP_CLR_SRC                        0x15C4
 #define CLR_CMP_CLR_DST                        0x15C8
 #define CLR_CMP_CNTL                           0x15C0
-#define CLR_CMP_MSK                            0x15CC  
-#define DSTCACHE_MODE                          0x1710  
-#define DSTCACHE_CTLSTAT                       0x1714  
-#define DEFAULT_PITCH_OFFSET                   0x16E0  
-#define DEFAULT_SC_BOTTOM_RIGHT                0x16E8  
+#define CLR_CMP_MSK                            0x15CC
+#define DSTCACHE_MODE                          0x1710
+#define DSTCACHE_CTLSTAT                       0x1714
+#define DEFAULT_PITCH_OFFSET                   0x16E0
+#define DEFAULT_SC_BOTTOM_RIGHT                0x16E8
 #define DEFAULT_SC_TOP_LEFT                    0x16EC
 #define SRC_PITCH_OFFSET                       0x1428
 #define DST_PITCH_OFFSET                       0x142C
-#define DP_GUI_MASTER_CNTL                     0x146C  
-#define SC_TOP_LEFT                            0x16EC  
-#define SC_BOTTOM_RIGHT                        0x16F0  
-#define SRC_SC_BOTTOM_RIGHT                    0x16F4  
+#define DP_GUI_MASTER_CNTL                     0x146C
+#define SC_TOP_LEFT                            0x16EC
+#define SC_BOTTOM_RIGHT                        0x16F0
+#define SRC_SC_BOTTOM_RIGHT                    0x16F4
 #define RB2D_DSTCACHE_MODE		       0x3428
 #define RB2D_DSTCACHE_CTLSTAT_broken	       0x342C /* do not use */
 #define LVDS_GEN_CNTL			       0x02d0
@@ -686,7 +686,7 @@
 #define VERT_FP_LOOP_STRETCH			   (0x7 << 28)
 #define VERT_STRETCH_RESERVED			   0xf1000000
 
-/* DAC_CNTL bit constants */   
+/* DAC_CNTL bit constants */
 #define DAC_8BIT_EN                                0x00000100
 #define DAC_4BPP_PIX_ORDER                         0x00000200
 #define DAC_CRC_EN                                 0x00080000
@@ -700,7 +700,7 @@
 #define DAC_CMP_EN                                 (1 <<  3)
 #define DAC_CMP_OUTPUT                             (1 <<  7)
 
-/* DAC_CNTL2 bit constants */   
+/* DAC_CNTL2 bit constants */
 #define DAC2_EXPAND_MODE			   (1 << 14)
 #define DAC2_CMP_EN                                (1 << 7)
 #define DAC2_PALETTE_ACCESS_CNTL                   (1 << 5)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
auditsc-fix-kernel-doc-notation.patch
reiser4-export-remove_from_page_cache-fix.patch

