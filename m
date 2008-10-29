From: akpm@linux-foundation.org
Subject: - drivers-rtc-rtc-m48t35c-is-borked-too.patch removed from -mm tree
Date: Wed, 29 Oct 2008 16:28:13 -0700
Message-ID: <200810292328.m9TNSD77003416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYJ2XaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 19:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alessandro.zummo@towertech.it, ralf@linux-mips.org, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-m48t35.c is borked too
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m48t35c-is-borked-too.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-m48t35.c is borked too
From: Andrew Morton <akpm@linux-foundation.org>

drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-m48t35c-is-borked-too drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-m48t35c-is-borked-too
+++ a/drivers/rtc/Kconfig
@@ -432,6 +432,7 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T35
 	tristate "ST M48T35"
+	depends on MIPS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T35 RTC chip.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
fs-remove-prepare_write-commit_write.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

