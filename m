From: akpm@linux-foundation.org
Subject: +
 hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch added to -mm tree
Date: Fri, 18 Apr 2014 13:38:44 -0700
Message-ID: <53518d54.F+HoxL6jHoKfCWpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDRUip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 16:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nacc@linux.vnet.ibm.com, mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,mgorman@suse.de,nacc@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 13:38:44 -0700


The patch titled
     Subject: hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix
has been added to the -mm tree.  Its filename is
     hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch

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
Subject: hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix

use pr_info(), per Mel

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1031,7 +1031,7 @@ static int __init init_hugetlbfs_fs(void
 	int i;
 
 	if (!hugepages_supported()) {
-		printk(KERN_ERR "hugetlbfs: Disabling because there are no supported hugepage sizes\n");
+		pr_info("hugetlbfs: disabling because there are no supported hugepage sizes\n");
 		return -ENOTSUPP;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

