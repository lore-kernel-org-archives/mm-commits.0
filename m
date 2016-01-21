From: akpm@linux-foundation.org
Subject: [merged] fs-adfs-adfsh-tidy-up-comments.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 15:28:37 -0800
Message-ID: <56a169a5.2KPjnOM5zCgtpmpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs/adfs.h: tidy up comments
has been removed from the -mm tree.  Its filename was
     fs-adfs-adfsh-tidy-up-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/adfs/adfs.h: tidy up comments

Lots of needless 80-col overflows.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/adfs/adfs.h~fs-adfs-adfsh-tidy-up-comments fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-adfs-adfsh-tidy-up-comments
+++ a/fs/adfs/adfs.h
@@ -44,24 +44,24 @@ struct adfs_dir_ops;
  */
 struct adfs_sb_info {
 	union { struct {
-		struct adfs_discmap *s_map;	/* bh list containing map	 */
-		const struct adfs_dir_ops *s_dir; /* directory operations	 */
+		struct adfs_discmap *s_map;	/* bh list containing map */
+		const struct adfs_dir_ops *s_dir; /* directory operations */
 		};
-		struct rcu_head rcu;		/* used only at shutdown time	 */
+		struct rcu_head rcu;	/* used only at shutdown time	 */
 	};
-	kuid_t		s_uid;		/* owner uid				 */
-	kgid_t		s_gid;		/* owner gid				 */
-	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm		 */
-	umode_t		s_other_mask;	/* ADFS other perm -> unix perm		 */
+	kuid_t		s_uid;		/* owner uid */
+	kgid_t		s_gid;		/* owner gid */
+	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm */
+	umode_t		s_other_mask;	/* ADFS other perm -> unix perm	*/
 	int		s_ftsuffix;	/* ,xyz hex filetype suffix option */
 
-	__u32		s_ids_per_zone;	/* max. no ids in one zone		 */
-	__u32		s_idlen;	/* length of ID in map			 */
-	__u32		s_map_size;	/* sector size of a map			 */
-	unsigned long	s_size;		/* total size (in blocks) of this fs	 */
-	signed int	s_map2blk;	/* shift left by this for map->sector	 */
-	unsigned int	s_log2sharesize;/* log2 share size			 */
-	__le32		s_version;	/* disc format version			 */
+	__u32		s_ids_per_zone;	/* max. no ids in one zone */
+	__u32		s_idlen;	/* length of ID in map */
+	__u32		s_map_size;	/* sector size of a map	*/
+	unsigned long	s_size;		/* total size (in blocks) of this fs */
+	signed int	s_map2blk;	/* shift left by this for map->sector*/
+	unsigned int	s_log2sharesize;/* log2 share size */
+	__le32		s_version;	/* disc format version */
 	unsigned int	s_namelen;	/* maximum number of characters in name	 */
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-fix-kernel-crash-in-khugepaged-thread-fix.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

