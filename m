From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:17 -0700
Message-ID: <20120611211017.4F891A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55385 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab2FKVKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 17:10:19 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so249728lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix

remove strange double-spaces

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix
+++ a/include/linux/memcontrol.h
@@ -470,7 +470,7 @@ static inline int mem_cgroup_hugetlb_fil
 	return 0;
 }
 
-static inline  void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+static inline void mem_cgroup_hugetlb_migrate(struct page *oldhpage,
 						struct page *newhpage)
 {
 	return;
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

