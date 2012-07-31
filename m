From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:54 -0700
Message-ID: <20120731184954.A6A8210007D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2GaStz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:55 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: remind people to update Documentation/printk-formats.txt when adding printk formats
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/vsprintf.c: remind people to update Documentation/printk-formats.txt when adding printk formats

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/vsprintf.c~lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats
+++ a/lib/vsprintf.c
@@ -1297,6 +1297,8 @@ qualifier:
  *   case.
  * %n is ignored
  *
+ * ** Please update Documentation/printk-formats.txt when making changes **
+ *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

