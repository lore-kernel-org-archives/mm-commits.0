From: akpm@linux-foundation.org
Subject: [obsolete] nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 11 Jun 2012 13:57:53 -0700
Message-ID: <20120611205753.E72DEA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33624 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2FKU54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 16:57:56 -0400
Received: by lbbgp10 with SMTP id gp10so255843lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 13:57:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes

ERROR: spaces required around that '==' (ctx:WxV)
#92: FILE: kernel/watchdog.c:407:
+		if (cpu ==0 || cpu0_err)
 		        ^

total: 1 errors, 0 warnings, 35 lines checked

./patches/nmi-watchdog-quiet-down-the-boot-messages.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes
+++ a/kernel/watchdog.c
@@ -404,7 +404,7 @@ static int watchdog_nmi_enable(int cpu)
 
 	if (!IS_ERR(event)) {
 		/* only print for cpu0 or different than cpu0 */
-		if (cpu ==0 || cpu0_err)
+		if (cpu == 0 || cpu0_err)
 			pr_info("enabled, takes one hw-pmu counter.\n");
 		goto out_save;
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
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
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

