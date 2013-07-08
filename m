From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 15:26:09 -0700
Message-ID: <51db3c81.dMSPDEJurqhJvFWV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3GHW0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mhocko@suse.cz, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,mhocko@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:26:09 -0700


The patch titled
     Subject: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch

This patch was dropped because it was folded into mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix

make definitions more readable

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix
+++ a/mm/page_alloc.c
@@ -4793,7 +4793,8 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	unsigned long start_pfn = 0, end_pfn = 0;
+	unsigned long start_pfn = 0;
+	unsigned long end_pfn = 0;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

