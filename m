From: akpm@linux-foundation.org
Subject: - reiser4-slab-allocators-remove-slab_debug_initial-flag.patch removed from -mm tree
Date: Wed, 09 May 2007 03:07:43 -0700
Message-ID: <200705091007.l49A7hJf020880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbXEIKIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     reiser4-slab-allocators-remove-slab_debug_initial-flag
has been removed from the -mm tree.  Its filename was
     reiser4-slab-allocators-remove-slab_debug_initial-flag.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4-slab-allocators-remove-slab_debug_initial-flag
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/super_ops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/reiser4/super_ops.c~reiser4-slab-allocators-remove-slab_debug_initial-flag fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/reiser4/super_ops.c
@@ -33,8 +33,7 @@ static void init_once(void *obj, struct 
 
 	info = obj;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if ((flags & SLAB_CTOR_CONSTRUCTOR) == SLAB_CTOR_CONSTRUCTOR) {
 		/* initialize vfs inode */
 		inode_init_once(&info->vfs_inode);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
