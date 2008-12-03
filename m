From: akpm@linux-foundation.org
Subject: + ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:50:27 -0800
Message-ID: <200812030906.mB3965Wm003800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYLCJGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 04:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, giometti@linux.it


The patch titled
     ldisc-n_tty-export-all-n_tty-ldisc-methods-fix
has been added to the -mm tree.  Its filename is
     ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ldisc-n_tty-export-all-n_tty-ldisc-methods-fix
From: Andrew Morton <akpm@linux-foundation.org>

i386 allnoconfig:

drivers/char/n_tty.c:230: warning: data definition has no type or storage class
drivers/char/n_tty.c:230: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/char/n_tty.c:230: warning: parameter names (without types) in function declaration
drivers/char/n_tty.c:258: warning: data definition has no type or storage class
drivers/char/n_tty.c:258: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/char/n_tty.c:258: warning: parameter names (without types) in function declaration
{etc}

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/n_tty.c~ldisc-n_tty-export-all-n_tty-ldisc-methods-fix drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~ldisc-n_tty-export-all-n_tty-ldisc-methods-fix
+++ a/drivers/char/n_tty.c
@@ -36,6 +36,7 @@
 #include <linux/signal.h>
 #include <linux/fcntl.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/timer.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bdi-register-sysfs-bdi-device-only-once-per-queue.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
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
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

