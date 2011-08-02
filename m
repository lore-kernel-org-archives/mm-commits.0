From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 02 Aug 2011 13:10:50 -0700
Message-ID: <201108022008.p72K8VCr010893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab1HBUJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2011 16:09:04 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p72K8Wl7020263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 2 Aug 2011 13:08:32 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-msm/io.c         |   11 +----------
 drivers/video/omap2/dss/rfbi.c |    3 ---
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN arch/arm/mach-msm/io.c~linux-next-git-rejects arch/arm/mach-msm/io.c
--- a/arch/arm/mach-msm/io.c~linux-next-git-rejects
+++ a/arch/arm/mach-msm/io.c
@@ -43,14 +43,11 @@
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X00),
-<<<<<<< HEAD
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
 	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
-=======
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
->>>>>>> linux-next/akpm-end
 	MSM_DEVICE(CLK_CTL),
 #ifdef CONFIG_MSM_DEBUG_UART
 	MSM_DEVICE(DEBUG_UART),
@@ -81,14 +78,11 @@ void __init msm_map_common_io(void)
 static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, QSD8X50),
-<<<<<<< HEAD
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, QSD8X50),
 	MSM_CHIP_DEVICE(GPIO2, QSD8X50),
-=======
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
->>>>>>> linux-next/akpm-end
 	MSM_DEVICE(CLK_CTL),
 	MSM_DEVICE(SIRC),
 	MSM_DEVICE(SCPLL),
@@ -145,14 +139,11 @@ void __init msm_map_msm8960_io(void)
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X30),
-<<<<<<< HEAD
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, MSM7X30),
 	MSM_CHIP_DEVICE(GPIO2, MSM7X30),
-=======
-	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
->>>>>>> linux-next/akpm-end
+	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(CLK_CTL),
 	MSM_DEVICE(CLK_CTL_SH2),
 	MSM_DEVICE(AD5),
diff -puN drivers/video/omap2/dss/rfbi.c~linux-next-git-rejects drivers/video/omap2/dss/rfbi.c
--- a/drivers/video/omap2/dss/rfbi.c~linux-next-git-rejects
+++ a/drivers/video/omap2/dss/rfbi.c
@@ -33,12 +33,9 @@
 #include <linux/hrtimer.h>
 #include <linux/seq_file.h>
 #include <linux/semaphore.h>
-<<<<<<< HEAD
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-=======
 #include <linux/export.h>
->>>>>>> linux-next/akpm-end
 
 #include <video/omapdss.h>
 #include "dss.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

