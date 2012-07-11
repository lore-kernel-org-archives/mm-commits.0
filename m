From: akpm@linux-foundation.org
Subject: + mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:22:20 -0700
Message-ID: <20120711212221.734A520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42981 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2GKVWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:22:23 -0400
Received: by wibhr14 with SMTP id hr14so85184wib.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:22:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com


The patch titled
     Subject: mm-have-order-0-compaction-start-off-where-it-left-v3-typo
has been added to the -mm tree.  Its filename is
     mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-have-order-0-compaction-start-off-where-it-left-v3-typo

s/laste/last/, use 80 cols

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3-typo mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3-typo
+++ a/mm/compaction.c
@@ -571,11 +571,10 @@ static isolate_migrate_t isolate_migrate
 }
 
 /*
- * Returns the start pfn of the laste page block in a zone.
- * This is the starting point for full compaction of a zone.
- * Compaction searches for free pages from the end of each zone,
- * while isolate_freepages_block scans forward inside each page
- * block.
+ * Returns the start pfn of the last page block in a zone.  This is the starting
+ * point for full compaction of a zone.  Compaction searches for free pages from
+ * the end of each zone, while isolate_freepages_block scans forward inside each
+ * page block.
  */
 static unsigned long start_free_pfn(struct zone *zone)
 {
_
Subject: Subject: mm-have-order-0-compaction-start-off-where-it-left-v3-typo

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

