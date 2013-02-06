From: akpm@linux-foundation.org
Subject: + mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Wed, 06 Feb 2013 12:58:11 -0800
Message-ID: <20130206205811.85B4D5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:60745 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFU6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:58:12 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so197898vch.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:58:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, lig.fnst@cn.fujitsu.com


The patch titled
     Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix

Cc: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/da9030_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/jump_label.c~mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix kernel/jump_label.c
diff -puN drivers/power/da9030_battery.c~mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix drivers/power/da9030_battery.c
--- a/drivers/power/da9030_battery.c~mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix
+++ a/drivers/power/da9030_battery.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
+#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch
memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch
memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch
memcg-cleanup-mem_cgroup_init-comment.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix.patch

