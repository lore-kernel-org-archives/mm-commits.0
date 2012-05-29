From: akpm@linux-foundation.org
Subject: [folded] rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:55:57 -0700
Message-ID: <20120529215557.539A2A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:39578 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2E2Vz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:55:59 -0400
Received: by bkty5 with SMTP id y5so264056bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:55:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, fabio.estevam@freescale.com, festevam@gmail.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
has been removed from the -mm tree.  Its filename was
     rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

This patch was dropped because it was folded into rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/imx_v6_v7_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix arch/arm/configs/imx_v6_v7_defconfig
--- a/arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
+++ a/arch/arm/configs/imx_v6_v7_defconfig
@@ -178,7 +178,7 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_EXT2_FS=y
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch
backlight-add-lm3533-backlight-driver.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch
leds-led-module-for-da9052-53-pmic-v2.patch
leds-heartbeat-stop-on-shutdown.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch

