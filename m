From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:18:43 -0700
Message-ID: <200808122018.m7CKIhv1011089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbYHLUTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:19:16 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7CKIiSj022216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2008 13:18:45 -0700
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

 arch/sparc64/kernel/sys_sparc32.c |    3 ---
 drivers/watchdog/at91rm9200_wdt.c |    5 -----
 drivers/watchdog/davinci_wdt.c    |    4 ----
 drivers/watchdog/ep93xx_wdt.c     |    4 ----
 drivers/watchdog/ixp2000_wdt.c    |    4 ----
 drivers/watchdog/ixp4xx_wdt.c     |    4 ----
 drivers/watchdog/ks8695_wdt.c     |    7 -------
 drivers/watchdog/omap_wdt.c       |    7 -------
 drivers/watchdog/pnx4008_wdt.c    |    4 ----
 drivers/watchdog/sa1100_wdt.c     |    4 ----
 drivers/watchdog/wdt285.c         |    4 ----
 11 files changed, 50 deletions(-)

diff -puN arch/sparc64/kernel/sys_sparc32.c~linux-next-git-rejects arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~linux-next-git-rejects
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -58,8 +58,6 @@
 #include <asm/mmu_context.h>
 #include <asm/compat_signal.h>
 
-<<<<<<< HEAD:arch/sparc64/kernel/sys_sparc32.c
-=======
 asmlinkage long sys32_chown16(const char __user * filename, u16 user, u16 group)
 {
 	return sys_chown(filename, low2highuid(user), low2highgid(group));
@@ -236,7 +234,6 @@ asmlinkage long sys32_getegid16(void)
 	return high2lowgid(current->cred->egid);
 }
 
->>>>>>> FETCH_HEAD:arch/sparc64/kernel/sys_sparc32.c
 /* 32-bit timeval and related flotsam.  */
 
 static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
diff -puN drivers/watchdog/at91rm9200_wdt.c~linux-next-git-rejects drivers/watchdog/at91rm9200_wdt.c
--- a/drivers/watchdog/at91rm9200_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/at91rm9200_wdt.c
@@ -20,13 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-<<<<<<< HEAD:drivers/watchdog/at91rm9200_wdt.c
 #include <linux/uaccess.h>
-#include <asm/arch/at91_st.h>
-=======
-#include <asm/uaccess.h>
 #include <mach/at91_st.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/at91rm9200_wdt.c
 
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
diff -puN drivers/watchdog/davinci_wdt.c~linux-next-git-rejects drivers/watchdog/davinci_wdt.c
--- a/drivers/watchdog/davinci_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/davinci_wdt.c
@@ -25,13 +25,9 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-<<<<<<< HEAD:drivers/watchdog/davinci_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/davinci_wdt.c
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
diff -puN drivers/watchdog/ep93xx_wdt.c~linux-next-git-rejects drivers/watchdog/ep93xx_wdt.c
--- a/drivers/watchdog/ep93xx_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/ep93xx_wdt.c
@@ -30,12 +30,8 @@
 #include <linux/timer.h>
 #include <linux/uaccess.h>
 
-<<<<<<< HEAD:drivers/watchdog/ep93xx_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/ep93xx_wdt.c
 
 #define WDT_VERSION	"0.3"
 #define PFX		"ep93xx_wdt: "
diff -puN drivers/watchdog/ixp2000_wdt.c~linux-next-git-rejects drivers/watchdog/ixp2000_wdt.c
--- a/drivers/watchdog/ixp2000_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/ixp2000_wdt.c
@@ -27,12 +27,8 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 
-<<<<<<< HEAD:drivers/watchdog/ixp2000_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/ixp2000_wdt.c
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
diff -puN drivers/watchdog/ixp4xx_wdt.c~linux-next-git-rejects drivers/watchdog/ixp4xx_wdt.c
--- a/drivers/watchdog/ixp4xx_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/ixp4xx_wdt.c
@@ -24,12 +24,8 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 
-<<<<<<< HEAD:drivers/watchdog/ixp4xx_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/ixp4xx_wdt.c
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;	/* (secs) Default is 1 minute */
diff -puN drivers/watchdog/ks8695_wdt.c~linux-next-git-rejects drivers/watchdog/ks8695_wdt.c
--- a/drivers/watchdog/ks8695_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/ks8695_wdt.c
@@ -19,16 +19,9 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-<<<<<<< HEAD:drivers/watchdog/ks8695_wdt.c
 #include <linux/io.h>
-#include <linux/uaccess.h>
-#include <asm/arch/regs-timer.h>
-=======
-#include <asm/io.h>
 #include <asm/uaccess.h>
 #include <mach/regs-timer.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/ks8695_wdt.c
-
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
 #define WDT_MAX_TIME		171	/* seconds */
diff -puN drivers/watchdog/omap_wdt.c~linux-next-git-rejects drivers/watchdog/omap_wdt.c
--- a/drivers/watchdog/omap_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/omap_wdt.c
@@ -40,16 +40,9 @@
 #include <linux/moduleparam.h>
 #include <linux/clk.h>
 #include <linux/bitops.h>
-<<<<<<< HEAD:drivers/watchdog/omap_wdt.c
 #include <linux/io.h>
-#include <linux/uaccess.h>
-#include <linux/hardware.h>
-=======
-
-#include <asm/io.h>
 #include <asm/uaccess.h>
 #include <mach/hardware.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/omap_wdt.c
 
 #include <mach/prcm.h>
 
diff -puN drivers/watchdog/pnx4008_wdt.c~linux-next-git-rejects drivers/watchdog/pnx4008_wdt.c
--- a/drivers/watchdog/pnx4008_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/pnx4008_wdt.c
@@ -31,13 +31,9 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-<<<<<<< HEAD:drivers/watchdog/pnx4008_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/pnx4008_wdt.c
 
 #define MODULE_NAME "PNX4008-WDT: "
 
diff -puN drivers/watchdog/sa1100_wdt.c~linux-next-git-rejects drivers/watchdog/sa1100_wdt.c
--- a/drivers/watchdog/sa1100_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/sa1100_wdt.c
@@ -32,13 +32,9 @@
 #include <mach/pxa-regs.h>
 #endif
 
-<<<<<<< HEAD:drivers/watchdog/sa1100_wdt.c
-#include <asm/hardware.h>
-=======
 #include <mach/reset.h>
 #include <mach/hardware.h>
 #include <asm/uaccess.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/sa1100_wdt.c
 
 #define OSCR_FREQ		CLOCK_TICK_RATE
 
diff -puN drivers/watchdog/wdt285.c~linux-next-git-rejects drivers/watchdog/wdt285.c
--- a/drivers/watchdog/wdt285.c~linux-next-git-rejects
+++ a/drivers/watchdog/wdt285.c
@@ -29,13 +29,9 @@
 #include <linux/uaccess.h>
 #include <linux/irq.h>
 
-<<<<<<< HEAD:drivers/watchdog/wdt285.c
-#include <asm/hardware.h>
-=======
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <mach/hardware.h>
->>>>>>> FETCH_HEAD:drivers/watchdog/wdt285.c
 #include <asm/mach-types.h>
 #include <asm/hardware/dec21285.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-eventpollc-fix-sys_epoll_create1-comment.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
git-drm.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix-fix.patch
git-dlm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-kvm.patch
git-mtd.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
git-nfsd.patch
sched-type-fix.patch
lockdep-spin_lock_nest_lock-fix-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

