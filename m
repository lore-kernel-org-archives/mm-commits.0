From: akpm@linux-foundation.org
Subject: + mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch added to -mm tree
Date: Thu, 21 Jun 2012 16:58:52 -0700
Message-ID: <20120621235852.66A1AA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53105 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759511Ab2FUX6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 19:58:53 -0400
Received: by ggeh3 with SMTP id h3so143896gge.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 16:58:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch

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
Subject: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes

ERROR: trailing whitespace
#62: FILE: mm/fadvise.c:106:
+^I^I * Ignore return value because fadvise() shall return $

ERROR: trailing whitespace
#64: FILE: mm/fadvise.c:108:
+^I^I */^I^I$

total: 2 errors, 0 warnings, 30 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes
+++ a/mm/fadvise.c
@@ -103,9 +103,9 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 			nrpages = ~0UL;
 
 		/*
-		 * Ignore return value because fadvise() shall return 
+		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
-		 */		
+		 */
 		force_page_cache_readahead(mapping, file, start_index,
 					   nrpages);
 		break;
_
Subject: Subject: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
fs-jbd2-commitc-use-new-kmap_atomic-api.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
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
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

