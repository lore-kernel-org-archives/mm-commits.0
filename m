From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:55:56 -0800
Message-ID: <20120113005556.C2AD41E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42236 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2AMAz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:55:57 -0500
Received: by yhjj52 with SMTP id j52so8208yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:55:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch

This patch was dropped because it was folded into mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix

fs/nfs/write.c: In function 'nfs_migrate_page':
fs/nfs/write.c:1729: error: 'sync' undeclared (first use in this function)

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix fs/nfs/write.c
--- a/fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix
+++ a/fs/nfs/write.c
@@ -1726,7 +1726,7 @@ int nfs_migrate_page(struct address_spac
 
 	nfs_fscache_release_page(page, GFP_KERNEL);
 
-	return migrate_page(mapping, newpage, page, sync);
+	return migrate_page(mapping, newpage, page, mode);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

