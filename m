From: akpm@linux-foundation.org
Subject: - remove-config_force_inlining-from-defconfigs.patch removed from -mm tree
Date: Mon, 11 Feb 2008 13:20:26 -0800
Message-ID: <200802112120.m1BLKQZX000991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201AbYBKVeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:34:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove CONFIG_FORCE_INLINING from defconfigs
has been removed from the -mm tree.  Its filename was
     remove-config_force_inlining-from-defconfigs.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove CONFIG_FORCE_INLINING from defconfigs
From: Harvey Harrison <harvey.harrison@gmail.com>

Option has been removed as of: 185c045c245f46485ad8bbd8cc1100e986ff3f13
x86, core: remove CONFIG_FORCED_INLINING

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/at91cap9adk_defconfig          |    1 -
 arch/arm/configs/at91sam9260ek_defconfig        |    1 -
 arch/arm/configs/at91sam9261ek_defconfig        |    1 -
 arch/arm/configs/at91sam9263ek_defconfig        |    1 -
 arch/arm/configs/at91sam9rlek_defconfig         |    1 -
 arch/arm/configs/cm_x270_defconfig              |    1 -
 arch/arm/configs/colibri_defconfig              |    1 -
 arch/arm/configs/collie_defconfig               |    1 -
 arch/arm/configs/em_x270_defconfig              |    1 -
 arch/arm/configs/ep93xx_defconfig               |    1 -
 arch/arm/configs/iop32x_defconfig               |    1 -
 arch/arm/configs/iop33x_defconfig               |    1 -
 arch/arm/configs/ixp2000_defconfig              |    1 -
 arch/arm/configs/ixp23xx_defconfig              |    1 -
 arch/arm/configs/ixp4xx_defconfig               |    1 -
 arch/arm/configs/ks8695_defconfig               |    1 -
 arch/arm/configs/littleton_defconfig            |    1 -
 arch/arm/configs/lpd270_defconfig               |    1 -
 arch/arm/configs/lpd7a404_defconfig             |    1 -
 arch/arm/configs/msm_defconfig                  |    1 -
 arch/arm/configs/netx_defconfig                 |    1 -
 arch/arm/configs/ns9xxx_defconfig               |    1 -
 arch/arm/configs/onearm_defconfig               |    1 -
 arch/arm/configs/picotux200_defconfig           |    1 -
 arch/arm/configs/pnx4008_defconfig              |    1 -
 arch/arm/configs/realview-smp_defconfig         |    1 -
 arch/arm/configs/rpc_defconfig                  |    1 -
 arch/arm/configs/s3c2410_defconfig              |    1 -
 arch/arm/configs/versatile_defconfig            |    1 -
 arch/avr32/configs/atngw100_defconfig           |    1 -
 arch/avr32/configs/atstk1002_defconfig          |    1 -
 arch/avr32/configs/atstk1003_defconfig          |    1 -
 arch/ia64/configs/bigsur_defconfig              |    1 -
 arch/ia64/configs/gensparse_defconfig           |    1 -
 arch/ia64/configs/sim_defconfig                 |    1 -
 arch/ia64/configs/sn2_defconfig                 |    1 -
 arch/ia64/configs/tiger_defconfig               |    1 -
 arch/ia64/configs/zx1_defconfig                 |    1 -
 arch/ia64/defconfig                             |    1 -
 arch/m32r/configs/opsput_defconfig              |    1 -
 arch/m32r/configs/usrv_defconfig                |    1 -
 arch/mips/configs/bigsur_defconfig              |    1 -
 arch/mips/configs/mipssim_defconfig             |    1 -
 arch/mips/configs/msp71xx_defconfig             |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig         |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig      |    1 -
 arch/mips/configs/yosemite_defconfig            |    1 -
 arch/parisc/configs/712_defconfig               |    1 -
 arch/parisc/configs/a500_defconfig              |    1 -
 arch/parisc/configs/b180_defconfig              |    1 -
 arch/parisc/configs/c3000_defconfig             |    1 -
 arch/parisc/defconfig                           |    1 -
 arch/powerpc/configs/adder875-redboot_defconfig |    1 -
 arch/powerpc/configs/adder875-uboot_defconfig   |    1 -
 arch/powerpc/configs/bamboo_defconfig           |    1 -
 arch/powerpc/configs/cell_defconfig             |    1 -
 arch/powerpc/configs/celleb_defconfig           |    1 -
 arch/powerpc/configs/chrp32_defconfig           |    1 -
 arch/powerpc/configs/ebony_defconfig            |    1 -
 arch/powerpc/configs/ep405_defconfig            |    1 -
 arch/powerpc/configs/ep8248e_defconfig          |    1 -
 arch/powerpc/configs/ep88xc_defconfig           |    1 -
 arch/powerpc/configs/g5_defconfig               |    1 -
 arch/powerpc/configs/holly_defconfig            |    1 -
 arch/powerpc/configs/iseries_defconfig          |    1 -
 arch/powerpc/configs/katmai_defconfig           |    1 -
 arch/powerpc/configs/kilauea_defconfig          |    1 -
 arch/powerpc/configs/linkstation_defconfig      |    1 -
 arch/powerpc/configs/makalu_defconfig           |    1 -
 arch/powerpc/configs/maple_defconfig            |    1 -
 arch/powerpc/configs/mpc5200_defconfig          |    1 -
 arch/powerpc/configs/mpc8272_ads_defconfig      |    1 -
 arch/powerpc/configs/mpc8313_rdb_defconfig      |    1 -
 arch/powerpc/configs/mpc8315_rdb_defconfig      |    1 -
 arch/powerpc/configs/mpc8540_ads_defconfig      |    1 -
 arch/powerpc/configs/mpc8544_ds_defconfig       |    1 -
 arch/powerpc/configs/mpc8560_ads_defconfig      |    1 -
 arch/powerpc/configs/mpc8568mds_defconfig       |    1 -
 arch/powerpc/configs/mpc8572_ds_defconfig       |    1 -
 arch/powerpc/configs/mpc85xx_cds_defconfig      |    1 -
 arch/powerpc/configs/mpc85xx_defconfig          |    1 -
 arch/powerpc/configs/mpc8610_hpcd_defconfig     |    1 -
 arch/powerpc/configs/mpc8641_hpcn_defconfig     |    1 -
 arch/powerpc/configs/mpc885_ads_defconfig       |    1 -
 arch/powerpc/configs/pasemi_defconfig           |    1 -
 arch/powerpc/configs/pmac32_defconfig           |    1 -
 arch/powerpc/configs/ppc64_defconfig            |    1 -
 arch/powerpc/configs/pq2fads_defconfig          |    1 -
 arch/powerpc/configs/ps3_defconfig              |    1 -
 arch/powerpc/configs/pseries_defconfig          |    1 -
 arch/powerpc/configs/rainier_defconfig          |    1 -
 arch/powerpc/configs/sbc8560_defconfig          |    1 -
 arch/powerpc/configs/sequoia_defconfig          |    1 -
 arch/powerpc/configs/stx_gp3_defconfig          |    1 -
 arch/powerpc/configs/taishan_defconfig          |    1 -
 arch/powerpc/configs/walnut_defconfig           |    1 -
 arch/powerpc/configs/warp_defconfig             |    1 -
 arch/ppc/configs/ml300_defconfig                |    1 -
 arch/ppc/configs/ml403_defconfig                |    1 -
 arch/ppc/configs/prep_defconfig                 |    1 -
 arch/ppc/configs/taishan_defconfig              |    1 -
 arch/s390/defconfig                             |    1 -
 arch/sh/configs/cayman_defconfig                |    1 -
 arch/sh/configs/magicpanelr2_defconfig          |    1 -
 arch/sh/configs/r7780mp_defconfig               |    1 -
 arch/sh/configs/r7785rp_defconfig               |    1 -
 arch/sh/configs/sdk7780_defconfig               |    1 -
 arch/sh/configs/se7206_defconfig                |    1 -
 arch/sh/configs/se7712_defconfig                |    1 -
 arch/sh/configs/shx3_defconfig                  |    1 -
 arch/sh/configs/titan_defconfig                 |    1 -
 arch/sparc/defconfig                            |    1 -
 arch/sparc64/defconfig                          |    1 -
 arch/um/defconfig                               |    1 -
 114 files changed, 114 deletions(-)

diff -puN arch/arm/configs/at91cap9adk_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/at91cap9adk_defconfig
--- a/arch/arm/configs/at91cap9adk_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/at91cap9adk_defconfig
@@ -1108,7 +1108,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/at91sam9260ek_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/at91sam9260ek_defconfig
--- a/arch/arm/configs/at91sam9260ek_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/at91sam9260ek_defconfig
@@ -919,7 +919,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/at91sam9261ek_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/at91sam9261ek_defconfig
--- a/arch/arm/configs/at91sam9261ek_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/at91sam9261ek_defconfig
@@ -1075,7 +1075,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/at91sam9263ek_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/at91sam9263ek_defconfig
--- a/arch/arm/configs/at91sam9263ek_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/at91sam9263ek_defconfig
@@ -1153,7 +1153,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff -puN arch/arm/configs/at91sam9rlek_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/at91sam9rlek_defconfig
--- a/arch/arm/configs/at91sam9rlek_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/at91sam9rlek_defconfig
@@ -924,7 +924,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/cm_x270_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/cm_x270_defconfig
--- a/arch/arm/configs/cm_x270_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/cm_x270_defconfig
@@ -1342,7 +1342,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/colibri_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/colibri_defconfig
--- a/arch/arm/configs/colibri_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/colibri_defconfig
@@ -1399,7 +1399,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/collie_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/collie_defconfig
--- a/arch/arm/configs/collie_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/collie_defconfig
@@ -930,7 +930,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/em_x270_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/em_x270_defconfig
--- a/arch/arm/configs/em_x270_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/em_x270_defconfig
@@ -1189,7 +1189,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/ep93xx_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ep93xx_defconfig
--- a/arch/arm/configs/ep93xx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ep93xx_defconfig
@@ -1193,7 +1193,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/iop32x_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/iop32x_defconfig
--- a/arch/arm/configs/iop32x_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/iop32x_defconfig
@@ -1308,7 +1308,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/iop33x_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/iop33x_defconfig
--- a/arch/arm/configs/iop33x_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/iop33x_defconfig
@@ -1051,7 +1051,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/ixp2000_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ixp2000_defconfig
--- a/arch/arm/configs/ixp2000_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ixp2000_defconfig
@@ -1083,7 +1083,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/ixp23xx_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ixp23xx_defconfig
--- a/arch/arm/configs/ixp23xx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ixp23xx_defconfig
@@ -1378,7 +1378,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/ixp4xx_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ixp4xx_defconfig
--- a/arch/arm/configs/ixp4xx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ixp4xx_defconfig
@@ -1555,7 +1555,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/ks8695_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ks8695_defconfig
--- a/arch/arm/configs/ks8695_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ks8695_defconfig
@@ -848,7 +848,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff -puN arch/arm/configs/littleton_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/littleton_defconfig
--- a/arch/arm/configs/littleton_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/littleton_defconfig
@@ -709,7 +709,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/arm/configs/lpd270_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/lpd270_defconfig
--- a/arch/arm/configs/lpd270_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/lpd270_defconfig
@@ -1001,7 +1001,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/lpd7a404_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/lpd7a404_defconfig
--- a/arch/arm/configs/lpd7a404_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/lpd7a404_defconfig
@@ -1097,7 +1097,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/msm_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/msm_defconfig
--- a/arch/arm/configs/msm_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/msm_defconfig
@@ -863,7 +863,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_USER is not set
 # CONFIG_DEBUG_ERRORS is not set
diff -puN arch/arm/configs/netx_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/netx_defconfig
--- a/arch/arm/configs/netx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/netx_defconfig
@@ -869,7 +869,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/ns9xxx_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/ns9xxx_defconfig
--- a/arch/arm/configs/ns9xxx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/ns9xxx_defconfig
@@ -592,7 +592,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/arm/configs/onearm_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/onearm_defconfig
--- a/arch/arm/configs/onearm_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/onearm_defconfig
@@ -1104,7 +1104,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff -puN arch/arm/configs/picotux200_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/picotux200_defconfig
--- a/arch/arm/configs/picotux200_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/picotux200_defconfig
@@ -1310,7 +1310,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_USER is not set
diff -puN arch/arm/configs/pnx4008_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/pnx4008_defconfig
--- a/arch/arm/configs/pnx4008_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/pnx4008_defconfig
@@ -1601,7 +1601,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 # CONFIG_DEBUG_ERRORS is not set
diff -puN arch/arm/configs/realview-smp_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/realview-smp_defconfig
--- a/arch/arm/configs/realview-smp_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/realview-smp_defconfig
@@ -963,7 +963,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/rpc_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/rpc_defconfig
--- a/arch/arm/configs/rpc_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/rpc_defconfig
@@ -987,7 +987,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/s3c2410_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/s3c2410_defconfig
--- a/arch/arm/configs/s3c2410_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/s3c2410_defconfig
@@ -1385,7 +1385,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/versatile_defconfig~remove-config_force_inlining-from-defconfigs arch/arm/configs/versatile_defconfig
--- a/arch/arm/configs/versatile_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/arm/configs/versatile_defconfig
@@ -969,7 +969,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff -puN arch/avr32/configs/atngw100_defconfig~remove-config_force_inlining-from-defconfigs arch/avr32/configs/atngw100_defconfig
--- a/arch/avr32/configs/atngw100_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/avr32/configs/atngw100_defconfig
@@ -1069,7 +1069,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff -puN arch/avr32/configs/atstk1002_defconfig~remove-config_force_inlining-from-defconfigs arch/avr32/configs/atstk1002_defconfig
--- a/arch/avr32/configs/atstk1002_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/avr32/configs/atstk1002_defconfig
@@ -1067,7 +1067,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff -puN arch/avr32/configs/atstk1003_defconfig~remove-config_force_inlining-from-defconfigs arch/avr32/configs/atstk1003_defconfig
--- a/arch/avr32/configs/atstk1003_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/avr32/configs/atstk1003_defconfig
@@ -981,7 +981,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff -puN arch/ia64/configs/bigsur_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/bigsur_defconfig
--- a/arch/ia64/configs/bigsur_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/bigsur_defconfig
@@ -1310,7 +1310,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_IA64_GRANULE_16MB is not set
 CONFIG_IA64_GRANULE_64MB=y
diff -puN arch/ia64/configs/gensparse_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/gensparse_defconfig
--- a/arch/ia64/configs/gensparse_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/gensparse_defconfig
@@ -1344,7 +1344,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_IA64_GRANULE_16MB=y
 # CONFIG_IA64_GRANULE_64MB is not set
diff -puN arch/ia64/configs/sim_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/sim_defconfig
--- a/arch/ia64/configs/sim_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/sim_defconfig
@@ -699,7 +699,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_IA64_GRANULE_16MB is not set
 CONFIG_IA64_GRANULE_64MB=y
diff -puN arch/ia64/configs/sn2_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/sn2_defconfig
--- a/arch/ia64/configs/sn2_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/sn2_defconfig
@@ -1219,7 +1219,6 @@ CONFIG_SCHED_DEBUG=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/ia64/configs/tiger_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/tiger_defconfig
--- a/arch/ia64/configs/tiger_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/tiger_defconfig
@@ -1223,7 +1223,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_IA64_GRANULE_16MB=y
diff -puN arch/ia64/configs/zx1_defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/configs/zx1_defconfig
--- a/arch/ia64/configs/zx1_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/configs/zx1_defconfig
@@ -1549,7 +1549,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/ia64/defconfig~remove-config_force_inlining-from-defconfigs arch/ia64/defconfig
--- a/arch/ia64/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ia64/defconfig
@@ -1389,7 +1389,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_IA64_GRANULE_16MB=y
diff -puN arch/m32r/configs/opsput_defconfig~remove-config_force_inlining-from-defconfigs arch/m32r/configs/opsput_defconfig
--- a/arch/m32r/configs/opsput_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/m32r/configs/opsput_defconfig
@@ -703,7 +703,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
diff -puN arch/m32r/configs/usrv_defconfig~remove-config_force_inlining-from-defconfigs arch/m32r/configs/usrv_defconfig
--- a/arch/m32r/configs/usrv_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/m32r/configs/usrv_defconfig
@@ -707,7 +707,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
diff -puN arch/mips/configs/bigsur_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/bigsur_defconfig
--- a/arch/mips/configs/bigsur_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/bigsur_defconfig
@@ -1020,7 +1020,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
diff -puN arch/mips/configs/mipssim_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/mipssim_defconfig
--- a/arch/mips/configs/mipssim_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/mipssim_defconfig
@@ -633,7 +633,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/mips/configs/msp71xx_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/msp71xx_defconfig
--- a/arch/mips/configs/msp71xx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/msp71xx_defconfig
@@ -1411,7 +1411,6 @@ CONFIG_DEBUG_PREEMPT=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_CROSSCOMPILE=y
diff -puN arch/mips/configs/pnx8550-jbs_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/pnx8550-jbs_defconfig
--- a/arch/mips/configs/pnx8550-jbs_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/pnx8550-jbs_defconfig
@@ -1215,7 +1215,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
diff -puN arch/mips/configs/pnx8550-stb810_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/pnx8550-stb810_defconfig
--- a/arch/mips/configs/pnx8550-stb810_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/pnx8550-stb810_defconfig
@@ -1205,7 +1205,6 @@ CONFIG_DEBUG_SLAB=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
diff -puN arch/mips/configs/yosemite_defconfig~remove-config_force_inlining-from-defconfigs arch/mips/configs/yosemite_defconfig
--- a/arch/mips/configs/yosemite_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/mips/configs/yosemite_defconfig
@@ -824,7 +824,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
diff -puN arch/parisc/configs/712_defconfig~remove-config_force_inlining-from-defconfigs arch/parisc/configs/712_defconfig
--- a/arch/parisc/configs/712_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/parisc/configs/712_defconfig
@@ -910,7 +910,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_RODATA=y
diff -puN arch/parisc/configs/a500_defconfig~remove-config_force_inlining-from-defconfigs arch/parisc/configs/a500_defconfig
--- a/arch/parisc/configs/a500_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/parisc/configs/a500_defconfig
@@ -1047,7 +1047,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RODATA is not set
diff -puN arch/parisc/configs/b180_defconfig~remove-config_force_inlining-from-defconfigs arch/parisc/configs/b180_defconfig
--- a/arch/parisc/configs/b180_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/parisc/configs/b180_defconfig
@@ -1034,7 +1034,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RODATA is not set
diff -puN arch/parisc/configs/c3000_defconfig~remove-config_force_inlining-from-defconfigs arch/parisc/configs/c3000_defconfig
--- a/arch/parisc/configs/c3000_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/parisc/configs/c3000_defconfig
@@ -1264,7 +1264,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_RODATA=y
diff -puN arch/parisc/defconfig~remove-config_force_inlining-from-defconfigs arch/parisc/defconfig
--- a/arch/parisc/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/parisc/defconfig
@@ -1351,7 +1351,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RODATA is not set
diff -puN arch/powerpc/configs/adder875-redboot_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/adder875-redboot_defconfig
--- a/arch/powerpc/configs/adder875-redboot_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/adder875-redboot_defconfig
@@ -776,7 +776,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/adder875-uboot_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/adder875-uboot_defconfig
--- a/arch/powerpc/configs/adder875-uboot_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/adder875-uboot_defconfig
@@ -776,7 +776,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/bamboo_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/bamboo_defconfig
--- a/arch/powerpc/configs/bamboo_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/bamboo_defconfig
@@ -726,7 +726,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/cell_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/cell_defconfig
--- a/arch/powerpc/configs/cell_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/cell_defconfig
@@ -1439,7 +1439,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/celleb_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/celleb_defconfig
--- a/arch/powerpc/configs/celleb_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/celleb_defconfig
@@ -1240,7 +1240,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/chrp32_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/chrp32_defconfig
--- a/arch/powerpc/configs/chrp32_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/chrp32_defconfig
@@ -1395,7 +1395,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/ebony_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ebony_defconfig
--- a/arch/powerpc/configs/ebony_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ebony_defconfig
@@ -807,7 +807,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/ep405_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ep405_defconfig
--- a/arch/powerpc/configs/ep405_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ep405_defconfig
@@ -890,7 +890,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/ep8248e_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ep8248e_defconfig
--- a/arch/powerpc/configs/ep8248e_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ep8248e_defconfig
@@ -764,7 +764,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/ep88xc_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ep88xc_defconfig
--- a/arch/powerpc/configs/ep88xc_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ep88xc_defconfig
@@ -727,7 +727,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/g5_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/g5_defconfig
--- a/arch/powerpc/configs/g5_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/g5_defconfig
@@ -1599,7 +1599,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/holly_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/holly_defconfig
--- a/arch/powerpc/configs/holly_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/holly_defconfig
@@ -925,7 +925,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/iseries_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/iseries_defconfig
--- a/arch/powerpc/configs/iseries_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/iseries_defconfig
@@ -1065,7 +1065,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/katmai_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/katmai_defconfig
--- a/arch/powerpc/configs/katmai_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/katmai_defconfig
@@ -726,7 +726,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/kilauea_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/kilauea_defconfig
--- a/arch/powerpc/configs/kilauea_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/kilauea_defconfig
@@ -750,7 +750,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/linkstation_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/linkstation_defconfig
--- a/arch/powerpc/configs/linkstation_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/linkstation_defconfig
@@ -1478,7 +1478,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/makalu_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/makalu_defconfig
--- a/arch/powerpc/configs/makalu_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/makalu_defconfig
@@ -750,7 +750,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/maple_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/maple_defconfig
--- a/arch/powerpc/configs/maple_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/maple_defconfig
@@ -1102,7 +1102,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc5200_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc5200_defconfig
--- a/arch/powerpc/configs/mpc5200_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc5200_defconfig
@@ -1222,7 +1222,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8272_ads_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8272_ads_defconfig
--- a/arch/powerpc/configs/mpc8272_ads_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -882,7 +882,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/mpc8313_rdb_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8313_rdb_defconfig
--- a/arch/powerpc/configs/mpc8313_rdb_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8313_rdb_defconfig
@@ -1297,7 +1297,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8315_rdb_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8315_rdb_defconfig
--- a/arch/powerpc/configs/mpc8315_rdb_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8315_rdb_defconfig
@@ -1355,7 +1355,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8540_ads_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8540_ads_defconfig
--- a/arch/powerpc/configs/mpc8540_ads_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8540_ads_defconfig
@@ -708,7 +708,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/mpc8544_ds_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8544_ds_defconfig
--- a/arch/powerpc/configs/mpc8544_ds_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8544_ds_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8560_ads_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8560_ads_defconfig
--- a/arch/powerpc/configs/mpc8560_ads_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8560_ads_defconfig
@@ -790,7 +790,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/mpc8568mds_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8568mds_defconfig
--- a/arch/powerpc/configs/mpc8568mds_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8568mds_defconfig
@@ -1002,7 +1002,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8572_ds_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8572_ds_defconfig
--- a/arch/powerpc/configs/mpc8572_ds_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8572_ds_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc85xx_cds_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc85xx_cds_defconfig
--- a/arch/powerpc/configs/mpc85xx_cds_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc85xx_cds_defconfig
@@ -843,7 +843,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/mpc85xx_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc85xx_defconfig
--- a/arch/powerpc/configs/mpc85xx_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc85xx_defconfig
@@ -1458,7 +1458,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc8610_hpcd_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8610_hpcd_defconfig
--- a/arch/powerpc/configs/mpc8610_hpcd_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8610_hpcd_defconfig
@@ -1162,7 +1162,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/mpc8641_hpcn_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc8641_hpcn_defconfig
--- a/arch/powerpc/configs/mpc8641_hpcn_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc8641_hpcn_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/mpc885_ads_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/mpc885_ads_defconfig
--- a/arch/powerpc/configs/mpc885_ads_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/mpc885_ads_defconfig
@@ -738,7 +738,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/pasemi_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/pasemi_defconfig
--- a/arch/powerpc/configs/pasemi_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/pasemi_defconfig
@@ -1682,7 +1682,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/pmac32_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/pmac32_defconfig
--- a/arch/powerpc/configs/pmac32_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/pmac32_defconfig
@@ -1885,7 +1885,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/ppc64_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ppc64_defconfig
--- a/arch/powerpc/configs/ppc64_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -1878,7 +1878,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/pq2fads_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/pq2fads_defconfig
--- a/arch/powerpc/configs/pq2fads_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/pq2fads_defconfig
@@ -975,7 +975,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/ps3_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -1087,7 +1087,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_DEBUG_LIST=y
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/pseries_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -1530,7 +1530,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff -puN arch/powerpc/configs/rainier_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/rainier_defconfig
--- a/arch/powerpc/configs/rainier_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/rainier_defconfig
@@ -796,7 +796,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/sbc8560_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/sbc8560_defconfig
--- a/arch/powerpc/configs/sbc8560_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/sbc8560_defconfig
@@ -733,7 +733,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff -puN arch/powerpc/configs/sequoia_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/sequoia_defconfig
--- a/arch/powerpc/configs/sequoia_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/sequoia_defconfig
@@ -808,7 +808,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/stx_gp3_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/stx_gp3_defconfig
--- a/arch/powerpc/configs/stx_gp3_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/stx_gp3_defconfig
@@ -1159,7 +1159,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/taishan_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/taishan_defconfig
--- a/arch/powerpc/configs/taishan_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/taishan_defconfig
@@ -726,7 +726,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/walnut_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/walnut_defconfig
--- a/arch/powerpc/configs/walnut_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/walnut_defconfig
@@ -798,7 +798,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/powerpc/configs/warp_defconfig~remove-config_force_inlining-from-defconfigs arch/powerpc/configs/warp_defconfig
--- a/arch/powerpc/configs/warp_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/powerpc/configs/warp_defconfig
@@ -1035,7 +1035,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/ppc/configs/ml300_defconfig~remove-config_force_inlining-from-defconfigs arch/ppc/configs/ml300_defconfig
--- a/arch/ppc/configs/ml300_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ppc/configs/ml300_defconfig
@@ -716,7 +716,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff -puN arch/ppc/configs/ml403_defconfig~remove-config_force_inlining-from-defconfigs arch/ppc/configs/ml403_defconfig
--- a/arch/ppc/configs/ml403_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ppc/configs/ml403_defconfig
@@ -717,7 +717,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff -puN arch/ppc/configs/prep_defconfig~remove-config_force_inlining-from-defconfigs arch/ppc/configs/prep_defconfig
--- a/arch/ppc/configs/prep_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ppc/configs/prep_defconfig
@@ -1658,7 +1658,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_XMON is not set
 # CONFIG_BDI_SWITCH is not set
diff -puN arch/ppc/configs/taishan_defconfig~remove-config_force_inlining-from-defconfigs arch/ppc/configs/taishan_defconfig
--- a/arch/ppc/configs/taishan_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/ppc/configs/taishan_defconfig
@@ -1057,7 +1057,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff -puN arch/s390/defconfig~remove-config_force_inlining-from-defconfigs arch/s390/defconfig
--- a/arch/s390/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/s390/defconfig
@@ -722,7 +722,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/sh/configs/cayman_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/cayman_defconfig
--- a/arch/sh/configs/cayman_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/cayman_defconfig
@@ -1126,7 +1126,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/sh/configs/magicpanelr2_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/magicpanelr2_defconfig
--- a/arch/sh/configs/magicpanelr2_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/magicpanelr2_defconfig
@@ -868,7 +868,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff -puN arch/sh/configs/r7780mp_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/r7780mp_defconfig
--- a/arch/sh/configs/r7780mp_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/r7780mp_defconfig
@@ -1035,7 +1035,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/sh/configs/r7785rp_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/r7785rp_defconfig
--- a/arch/sh/configs/r7785rp_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/r7785rp_defconfig
@@ -1069,7 +1069,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/sh/configs/sdk7780_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/sdk7780_defconfig
--- a/arch/sh/configs/sdk7780_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/sdk7780_defconfig
@@ -1316,7 +1316,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff -puN arch/sh/configs/se7206_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/se7206_defconfig
@@ -726,7 +726,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
 CONFIG_EARLY_SCIF_CONSOLE=y
diff -puN arch/sh/configs/se7712_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/se7712_defconfig
--- a/arch/sh/configs/se7712_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/se7712_defconfig
@@ -1012,7 +1012,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff -puN arch/sh/configs/shx3_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/shx3_defconfig
@@ -763,7 +763,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_VM=y
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SH_STANDARD_BIOS=y
diff -puN arch/sh/configs/titan_defconfig~remove-config_force_inlining-from-defconfigs arch/sh/configs/titan_defconfig
--- a/arch/sh/configs/titan_defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sh/configs/titan_defconfig
@@ -1624,7 +1624,6 @@ CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff -puN arch/sparc/defconfig~remove-config_force_inlining-from-defconfigs arch/sparc/defconfig
--- a/arch/sparc/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sparc/defconfig
@@ -842,7 +842,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
diff -puN arch/sparc64/defconfig~remove-config_force_inlining-from-defconfigs arch/sparc64/defconfig
--- a/arch/sparc64/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/sparc64/defconfig
@@ -1385,7 +1385,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
diff -puN arch/um/defconfig~remove-config_force_inlining-from-defconfigs arch/um/defconfig
--- a/arch/um/defconfig~remove-config_force_inlining-from-defconfigs
+++ a/arch/um/defconfig
@@ -516,7 +516,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
remove-config_force_inlining-from-defconfigs.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
