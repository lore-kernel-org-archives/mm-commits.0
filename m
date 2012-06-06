From: akpm@linux-foundation.org
Subject: + btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:49:05 -0700
Message-ID: <20120606214906.231C8A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57145 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab2FFVtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:49:09 -0400
Received: by eaao13 with SMTP id o13so398655eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:49:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com


The patch titled
     Subject: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix
has been added to the -mm tree.  Its filename is
     btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch

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
Subject: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix

whitespace tweak.  checkpatch bug ;)

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix
+++ a/fs/btrfs/super.c
@@ -191,7 +191,7 @@ void btrfs_printk(struct btrfs_fs_info *
 
 	kern_level = printk_get_level(fmt);
 	if (kern_level) {
-		size_t size = printk_skip_level(fmt)  - fmt;
+		size_t size = printk_skip_level(fmt) - fmt;
 		memcpy(lvl, fmt,  size);
 		lvl[size] = '\0';
 		fmt += size;
_
Subject: Subject: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

