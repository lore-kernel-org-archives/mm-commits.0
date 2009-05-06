From: akpm@linux-foundation.org
Subject: [folded] eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch removed from -mm tree
Date: Wed, 06 May 2009 16:01:13 -0700
Message-ID: <200905062301.n46N1Dxl031310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbZEFXGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 19:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, andi@firstfloor.org, arjan@linux.intel.com, hannes@cmpxchg.org, hugh@veritas.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     eliminate-thousands-of-warnings-with-gcc-32-build-cleanup
has been removed from the -mm tree.  Its filename was
     eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch

This patch was dropped because it was folded into eliminate-thousands-of-warnings-with-gcc-32-build.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eliminate-thousands-of-warnings-with-gcc-32-build-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/panic.c~eliminate-thousands-of-warnings-with-gcc-32-build-cleanup kernel/panic.c
--- a/kernel/panic.c~eliminate-thousands-of-warnings-with-gcc-32-build-cleanup
+++ a/kernel/panic.c
@@ -369,10 +369,9 @@ void warn_slowpath_fmt(const char *file,
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
-static const char *empty = "";
-
 void warn_slowpath_null(const char *file, int line)
 {
+	static const char *empty = "";
 	warn_slowpath_fmt(file, line, empty);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
drivers-base-iommuc-add-missing-includes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
mtd-fix-timeout-in-m25p80-driver-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

