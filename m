From: akpm@linux-foundation.org
Subject: + document-acked-by.patch added to -mm tree
Date: Thu, 31 May 2007 19:09:16 -0700
Message-ID: <200706010209.l5129F5k000534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbXFACJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 22:09:17 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5129F9p005229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 31 May 2007 19:09:16 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     document Acked-by:
has been added to the -mm tree.  Its filename is
     document-acked-by.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: document Acked-by:
From: Andrew Morton <akpm@linux-foundation.org>

Explain what we use Acked-by: for, and how it differs from Signed-off-by:
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~document-acked-by Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~document-acked-by
+++ a/Documentation/SubmittingPatches
@@ -328,7 +328,20 @@ now, but you can do this to mark interna
 point out some special detail about the sign-off. 
 
 
-12) The canonical patch format
+12) When to use Acked-by:
+
+The Signed-off-by: tag implies that the signer was involved in the development
+of the patch, or that he/she was in the patch's delivery path.
+
+If a person was not directly involved in the preparation or handling of a
+patch but wishes to signify and record their approval of it then they can
+arrange to have an Acked-by: line added to the patch's changelog.
+
+Acked-by: is often used by the maintainer of the affected code when that
+maintainer neither wrote, merged nor forwarded the patch themselves.
+
+
+13) The canonical patch format
 
 The canonical patch subject line is:
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs_init_locked_inode-fix-array-indexing.patch
afs-needs-schedh.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-rc-fixes.patch
sparc32-build-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix-fix.patch
git-xfs.patch
git-cryptodev.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-fix.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
document-acked-by.patch
