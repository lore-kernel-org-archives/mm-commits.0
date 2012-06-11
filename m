From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:27 -0700
Message-ID: <20120611211027.7C09DA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46490 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2FKVK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:29 -0400
Received: by were53 with SMTP id e53so251356wer.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes

ERROR: space required before the open brace '{'
#25: FILE: mm/hugetlb.c:1926:
+		    !list_empty(&cgroup->children)){

total: 1 errors, 0 warnings, 10 lines checked

./patches/memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -1923,7 +1923,7 @@ int hugetlb_force_memcg_empty(struct cgr
 
 	do {
 		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)){
+		    !list_empty(&cgroup->children)) {
 			ret = -EBUSY;
 			goto out;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

