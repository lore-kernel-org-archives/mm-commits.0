From: akpm@linux-foundation.org
Subject: - integrity-ima-integrity_measure-support-fix-2.patch removed from -mm tree
Date: Wed, 09 May 2007 03:01:04 -0700
Message-ID: <200705091001.l49A14gq020684@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927AbXEIKB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity-ima-integrity_measure-support-fix-2
has been removed from the -mm tree.  Its filename was
     integrity-ima-integrity_measure-support-fix-2.patch

This patch was dropped because it was folded into integrity-ima-integrity_measure-support.patch

------------------------------------------------------
Subject: integrity-ima-integrity_measure-support-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Fix ia64 buid:

ima_fs_cleanup: discarded in section `.exit.text' from security/built-in.o

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/evm/ima/ima_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_fs.c
--- a/security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-fix-2
+++ a/security/evm/ima/ima_fs.c
@@ -269,7 +269,7 @@ out:
 	return -1;
 }
 
-void __exit ima_fs_cleanup(void)
+void ima_fs_cleanup(void)
 {
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
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
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
