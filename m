From: akpm@linux-foundation.org
Subject: [folded] mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:43:23 -0700
Message-ID: <20120529214323.70DB3A021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52397 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2E2VnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:43:25 -0400
Received: by wgbdt11 with SMTP id dt11so280192wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:43:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch

This patch was dropped because it was folded into mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix

fix build

mm/sparse.c: In function 'sparse_early_usemaps_alloc_pgdat_section':
mm/sparse.c:340: error: expected ';' before '}' token

Cc: David S. Miller <davem@davemloft.net>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix mm/sparse.c
--- a/mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix
+++ a/mm/sparse.c
@@ -336,7 +336,7 @@ static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 					 unsigned long size)
 {
-	return alloc_bootmem_node_nopanic(pgdat, size)
+	return alloc_bootmem_node_nopanic(pgdat, size);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole-fix.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup-fix.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

