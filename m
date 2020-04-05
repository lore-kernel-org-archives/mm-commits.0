From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Sun, 05 Apr 2020 14:16:13 -0700
Message-ID: <20200405211613.-t4e-_32c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDEVQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 5 Apr 2020 17:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/bcm2835_defconfig       |    3 ---
 arch/arm/configs/omap2plus_defconfig     |   10 ----------
 include/dt-bindings/clock/imx8mn-clock.h |    5 -----
 3 files changed, 18 deletions(-)

--- a/arch/arm/configs/bcm2835_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/bcm2835_defconfig
@@ -103,10 +103,7 @@ CONFIG_WATCHDOG=y
 CONFIG_BCM2835_WDT=y
 CONFIG_MFD_SYSCON=y
 CONFIG_REGULATOR=y
-<<<<<<< HEAD
-=======
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
->>>>>>> linux-next/akpm-base
 CONFIG_REGULATOR_GPIO=y
 CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
--- a/arch/arm/configs/omap2plus_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/omap2plus_defconfig
@@ -360,26 +360,16 @@ CONFIG_OMAP2_DSS_DSI=y
 CONFIG_DRM_OMAP_PANEL_DSI_CM=m
 CONFIG_DRM_TILCDC=m
 CONFIG_DRM_PANEL_SIMPLE=m
-<<<<<<< HEAD
-=======
 CONFIG_DRM_DISPLAY_CONNECTOR=m
 CONFIG_DRM_SIMPLE_BRIDGE=m
 CONFIG_DRM_TI_TPD12S015=m
->>>>>>> linux-next/akpm-base
 CONFIG_DRM_PANEL_LG_LB035Q02=m
 CONFIG_DRM_PANEL_NEC_NL8048HL11=m
 CONFIG_DRM_PANEL_SHARP_LS037V7DW01=m
 CONFIG_DRM_PANEL_SONY_ACX565AKM=m
 CONFIG_DRM_PANEL_TPO_TD028TTEC1=m
 CONFIG_DRM_PANEL_TPO_TD043MTEA1=m
-<<<<<<< HEAD
-CONFIG_DRM_DISPLAY_CONNECTOR=m
-CONFIG_DRM_SIMPLE_BRIDGE=m
-CONFIG_DRM_TI_TFP410=m
-CONFIG_DRM_TI_TPD12S015=m
-=======
 CONFIG_DRM_TI_TFP410=m
->>>>>>> linux-next/akpm-base
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_MODE_HELPERS=y
--- a/include/dt-bindings/clock/imx8mn-clock.h~linux-next-git-rejects
+++ a/include/dt-bindings/clock/imx8mn-clock.h
@@ -229,16 +229,11 @@
 #define IMX8MN_SYS_PLL2_500M_CG			210
 
 #define IMX8MN_CLK_SNVS_ROOT			211
-<<<<<<< HEAD
-
-#define IMX8MN_CLK_END				212
-=======
 #define IMX8MN_CLK_GPU_CORE			212
 #define IMX8MN_CLK_GPU_SHADER			213
 
 #define IMX8MN_CLK_A53_CORE			214
 
 #define IMX8MN_CLK_END				215
->>>>>>> linux-next/akpm-base
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
