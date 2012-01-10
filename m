From: akpm@linux-foundation.org
Subject: [folded] slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:43:32 -0800
Message-ID: <20120110234333.4951E1E017F@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:54557 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJXne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:43:34 -0500
Received: by yhpp56 with SMTP id p56so19291yhp.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:43:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, penberg@cs.helsinki.fi, rientjes@google.com, sgruszka@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch

This patch was dropped because it was folded into slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes

Cc: David Rientjes <rientjes@google.com>

ERROR: trailing whitespace
#22: FILE: Documentation/ABI/testing/sysfs-kernel-slab:348:
+^I^Ipossible depending on its characteristics. $

total: 1 errors, 0 warnings, 20 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-slab |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes Documentation/ABI/testing/sysfs-kernel-slab
--- a/Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes
+++ a/Documentation/ABI/testing/sysfs-kernel-slab
@@ -345,7 +345,7 @@ Description:
 		allocated.  It is writable and can be changed to increase the
 		number of objects per slab.  If a slab cannot be allocated
 		because of fragmentation, SLUB will retry with the minimum order
-		possible depending on its characteristics. 
+		possible depending on its characteristics.
 		When debug_guardpage_minorder > 0 parameter is specified, the
 		minimum possible order is used and cannot be changed.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-make-alarm-work.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-nfs-nfs4procc-fix-printk-warnings.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

