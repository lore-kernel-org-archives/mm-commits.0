From: akpm@linux-foundation.org
Subject: - fs-eventpollc-fix-sys_epoll_create1-comment.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:09 -0700
Message-ID: <200808130853.m7D8r9iZ008298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbYHMJDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, drepper@redhat.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/eventpoll.c: fix sys_epoll_create1() comment
has been removed from the -mm tree.  Its filename was
     fs-eventpollc-fix-sys_epoll_create1-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/eventpoll.c: fix sys_epoll_create1() comment
From: Andrew Morton <akpm@linux-foundation.org>

The `size' argument was removed.

Reported-by:  Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/eventpoll.c~fs-eventpollc-fix-sys_epoll_create1-comment fs/eventpoll.c
--- a/fs/eventpoll.c~fs-eventpollc-fix-sys_epoll_create1-comment
+++ a/fs/eventpoll.c
@@ -1041,10 +1041,7 @@ retry:
 }
 
 /*
- * It opens an eventpoll file descriptor. The "size" parameter is there
- * for historical reasons, when epoll was using an hash instead of an
- * RB tree. With the current implementation, the "size" parameter is ignored
- * (besides sanity checks).
+ * Open an eventpoll file descriptor.
  */
 asmlinkage long sys_epoll_create1(int flags)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
acpi-trivial-cleanups-fix.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
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
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

