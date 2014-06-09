From: akpm@linux-foundation.org
Subject: [folded-merged]
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 09 Jun 2014 15:25:28 -0700
Message-ID: <53963458.016ATWABp0QAUxbi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbaFIWZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 18:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,srivatsa.bhat@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 15:25:28 -0700


The patch titled
     Subject: cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch

This patch was dropped because it was folded into cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes

WARNING: please, no space before tabs
#169: FILE: kernel/smp.c:211:
+ * ^I^I      offline CPU. Skip this check if set to 'false'.$

total: 0 errors, 1 warnings, 83 lines checked

./patches/cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes
+++ a/kernel/smp.c
@@ -208,7 +208,7 @@ void generic_smp_call_function_single_in
  * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
  *
  * @warn_cpu_offline: If set to 'true', warn if callbacks were queued on an
- * 		      offline CPU. Skip this check if set to 'false'.
+ *		      offline CPU. Skip this check if set to 'false'.
  *
  * Flush any pending smp-call-function callbacks queued on this CPU. This is
  * invoked by the generic IPI handler, as well as by a CPU about to go offline,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

