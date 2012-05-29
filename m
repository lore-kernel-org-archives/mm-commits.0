From: akpm@linux-foundation.org
Subject: [folded] memcg-always-free-struct-memcg-through-schedule_work-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:47:40 -0700
Message-ID: <20120529214741.04FA2A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43208 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2E2Vrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:47:42 -0400
Received: by qabg24 with SMTP id g24so294664qab.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:47:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-always-free-struct-memcg-through-schedule_work-fix
has been removed from the -mm tree.  Its filename was
     memcg-always-free-struct-memcg-through-schedule_work-fix.patch

This patch was dropped because it was folded into memcg-always-free-struct-memcg-through-schedule_work.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-always-free-struct-memcg-through-schedule_work-fix

tweak comment

Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work-fix
+++ a/mm/memcontrol.c
@@ -271,7 +271,7 @@ struct mem_cgroup {
 		struct rcu_head rcu_freeing;
 		/*
 		 * We also need some space for a worker in deferred freeing.
-		 * By the time we call it, rcu_freeing is not longer in use.
+		 * By the time we call it, rcu_freeing is no longer in use.
 		 */
 		struct work_struct work_freeing;
 	};
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
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
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

