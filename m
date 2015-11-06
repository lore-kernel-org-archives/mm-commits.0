From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:23:22 -0800
Message-ID: <563c0f1a.tMBjVfOgaeMk9mpd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:23:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, joern@logfs.org, mhocko@suse.cz, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix.patch

This patch was dropped because it was folded into mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix

fix Private_Hugetlb alignment

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joern Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 fs/proc/task_mmu.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix
+++ a/Documentation/filesystems/proc.txt
@@ -426,7 +426,7 @@ Referenced:          892 kB
 Anonymous:             0 kB
 AnonHugePages:         0 kB
 Shared_Hugetlb:        0 kB
-Private_Hugetlb:        0 kB
+Private_Hugetlb:       0 kB
 Swap:                  0 kB
 SwapPss:               0 kB
 KernelPageSize:        4 kB
diff -puN fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -687,7 +687,7 @@ static int show_smap(struct seq_file *m,
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
-		   "Private_Hugetlb: %8lu kB\n"
+		   "Private_Hugetlb: %7lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
_

Patches currently in -mm which might be from hughd@google.com are

mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
tmpfs-avoid-a-little-creat-and-stat-slowdown.patch
mm-documentation-a-little-tidying-in-proctxt.patch

