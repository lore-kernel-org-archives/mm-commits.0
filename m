From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 25 Mar 2013 12:33:30 -0700
Message-ID: <20130325193330.62F3E31C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58989 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab3CYTdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:33:31 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so364489qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:33:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mxs/mach-mxs.c |  177 ---------------------------------
 drivers/video/mxsfb.c        |    9 -
 2 files changed, 186 deletions(-)

diff -puN arch/arm/mach-mxs/mach-mxs.c~linux-next-git-rejects arch/arm/mach-mxs/mach-mxs.c
--- a/arch/arm/mach-mxs/mach-mxs.c~linux-next-git-rejects
+++ a/arch/arm/mach-mxs/mach-mxs.c
@@ -27,109 +27,6 @@
 #include <mach/digctl.h>
 #include <mach/mxs.h>
 
-<<<<<<< HEAD
-static struct fb_videomode mx23evk_video_modes[] = {
-	{
-		.name		= "Samsung-LMS430HF02",
-		.refresh	= 60,
-		.xres		= 480,
-		.yres		= 272,
-		.pixclock	= 108096, /* picosecond (9.2 MHz) */
-		.left_margin	= 15,
-		.right_margin	= 8,
-		.upper_margin	= 12,
-		.lower_margin	= 4,
-		.hsync_len	= 1,
-		.vsync_len	= 1,
-	},
-};
-
-static struct fb_videomode mx28evk_video_modes[] = {
-	{
-		.name		= "Seiko-43WVF1G",
-		.refresh	= 60,
-		.xres		= 800,
-		.yres		= 480,
-		.pixclock	= 29851, /* picosecond (33.5 MHz) */
-		.left_margin	= 89,
-		.right_margin	= 164,
-		.upper_margin	= 23,
-		.lower_margin	= 10,
-		.hsync_len	= 10,
-		.vsync_len	= 10,
-	},
-};
-
-static struct fb_videomode m28evk_video_modes[] = {
-	{
-		.name		= "Ampire AM-800480R2TMQW-T01H",
-		.refresh	= 60,
-		.xres		= 800,
-		.yres		= 480,
-		.pixclock	= 30066, /* picosecond (33.26 MHz) */
-		.left_margin	= 0,
-		.right_margin	= 256,
-		.upper_margin	= 0,
-		.lower_margin	= 45,
-		.hsync_len	= 1,
-		.vsync_len	= 1,
-	},
-};
-
-static struct fb_videomode apx4devkit_video_modes[] = {
-	{
-		.name		= "HannStar PJ70112A",
-		.refresh	= 60,
-		.xres		= 800,
-		.yres		= 480,
-		.pixclock	= 33333, /* picosecond (30.00 MHz) */
-		.left_margin	= 88,
-		.right_margin	= 40,
-		.upper_margin	= 32,
-		.lower_margin	= 13,
-		.hsync_len	= 48,
-		.vsync_len	= 3,
-		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
-	},
-};
-
-static struct fb_videomode apf28dev_video_modes[] = {
-	{
-		.name = "LW700",
-		.refresh = 60,
-		.xres = 800,
-		.yres = 480,
-		.pixclock = 30303, /* picosecond */
-		.left_margin = 96,
-		.right_margin = 96, /* at least 3 & 1 */
-		.upper_margin = 0x14,
-		.lower_margin = 0x15,
-		.hsync_len = 64,
-		.vsync_len = 4,
-		.sync = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
-	},
-};
-
-static struct fb_videomode cfa10049_video_modes[] = {
-	{
-		.name		= "Himax HX8357-B",
-		.refresh	= 60,
-		.xres		= 320,
-		.yres		= 480,
-		.pixclock	= 108506, /* picosecond (9.216 MHz) */
-		.left_margin	= 2,
-		.right_margin	= 2,
-		.upper_margin	= 2,
-		.lower_margin	= 2,
-		.hsync_len	= 15,
-		.vsync_len	= 15,
-	},
-};
-
-static struct mxsfb_platform_data mxsfb_pdata __initdata;
-
-=======
->>>>>>> linux-next/akpm-base
 /*
  * MX28EVK_FLEXCAN_SWITCH is shared between both flexcan controllers
  */
@@ -243,19 +140,6 @@ static void __init update_fec_mac_prop(e
 	}
 }
 
-<<<<<<< HEAD
-static void __init imx23_evk_init(void)
-{
-	mxsfb_pdata.mode_list = mx23evk_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(mx23evk_video_modes);
-	mxsfb_pdata.default_bpp = 32;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_24BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT |
-				MXSFB_SYNC_DOTCLK_FAILING_ACT;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static inline void enable_clk_enet_out(void)
 {
 	struct clk *clk = clk_get_sys("enet_out", NULL);
@@ -268,16 +152,6 @@ static void __init imx28_evk_init(void)
 {
 	update_fec_mac_prop(OUI_FSL);
 
-<<<<<<< HEAD
-	mxsfb_pdata.mode_list = mx28evk_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(mx28evk_video_modes);
-	mxsfb_pdata.default_bpp = 32;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_24BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT |
-				MXSFB_SYNC_DOTCLK_FAILING_ACT;
-
-=======
->>>>>>> linux-next/akpm-base
 	mxs_saif_clkmux_select(MXS_DIGCTL_SAIF_CLKMUX_EXTMSTR0);
 }
 
@@ -290,23 +164,6 @@ static void __init imx28_evk_post_init(v
 	}
 }
 
-<<<<<<< HEAD
-static void __init m28evk_init(void)
-{
-	mxsfb_pdata.mode_list = m28evk_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(m28evk_video_modes);
-	mxsfb_pdata.default_bpp = 16;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT;
-}
-
-static void __init sc_sps1_init(void)
-{
-	enable_clk_enet_out();
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int apx4devkit_phy_fixup(struct phy_device *phy)
 {
 	phy->dev_flags |= MICREL_PHY_50MHZ_CLK;
@@ -320,16 +177,6 @@ static void __init apx4devkit_init(void)
 	if (IS_BUILTIN(CONFIG_PHYLIB))
 		phy_register_fixup_for_uid(PHY_ID_KSZ8051, MICREL_PHY_ID_MASK,
 					   apx4devkit_phy_fixup);
-<<<<<<< HEAD
-
-	mxsfb_pdata.mode_list = apx4devkit_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(apx4devkit_video_modes);
-	mxsfb_pdata.default_bpp = 32;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_24BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT |
-				MXSFB_SYNC_DOTCLK_FAILING_ACT;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 #define ENET0_MDC__GPIO_4_0	MXS_GPIO_NR(4, 0)
@@ -409,15 +256,6 @@ static void __init tx28_post_init(void)
 static void __init cfa10049_init(void)
 {
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
-<<<<<<< HEAD
-
-	mxsfb_pdata.mode_list = cfa10049_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(cfa10049_video_modes);
-	mxsfb_pdata.default_bpp = 32;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static void __init cfa10037_init(void)
@@ -425,21 +263,6 @@ static void __init cfa10037_init(void)
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
 }
 
-<<<<<<< HEAD
-static void __init apf28_init(void)
-{
-	enable_clk_enet_out();
-
-	mxsfb_pdata.mode_list = apf28dev_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(apf28dev_video_modes);
-	mxsfb_pdata.default_bpp = 16;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_16BIT;
-	mxsfb_pdata.sync = MXSFB_SYNC_DATA_ENABLE_HIGH_ACT |
-				MXSFB_SYNC_DOTCLK_FAILING_ACT;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void __init mxs_machine_init(void)
 {
 	if (of_machine_is_compatible("fsl,imx28-evk"))
diff -puN drivers/video/mxsfb.c~linux-next-git-rejects drivers/video/mxsfb.c
--- a/drivers/video/mxsfb.c~linux-next-git-rejects
+++ a/drivers/video/mxsfb.c
@@ -178,10 +178,6 @@ struct mxsfb_info {
 	unsigned ld_intf_width;
 	unsigned dotclk_delay;
 	const struct mxsfb_devdata *devdata;
-<<<<<<< HEAD
-	int mapped;
-=======
->>>>>>> linux-next/akpm-base
 	u32 sync;
 };
 
@@ -472,13 +468,8 @@ static int mxsfb_set_par(struct fb_info
 		vdctrl0 |= VDCTRL0_VSYNC_ACT_HIGH;
 	if (host->sync & MXSFB_SYNC_DATA_ENABLE_HIGH_ACT)
 		vdctrl0 |= VDCTRL0_ENABLE_ACT_HIGH;
-<<<<<<< HEAD
-	if (host->sync & MXSFB_SYNC_DOTCLK_FAILING_ACT)
-		vdctrl0 |= VDCTRL0_DOTCLK_ACT_FAILING;
-=======
 	if (host->sync & MXSFB_SYNC_DOTCLK_FALLING_ACT)
 		vdctrl0 |= VDCTRL0_DOTCLK_ACT_FALLING;
->>>>>>> linux-next/akpm-base
 
 	writel(vdctrl0, host->base + LCDC_VDCTRL0);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch
dma-debug-fix-locking-bug-in-check_unmap.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

