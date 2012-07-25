From: akpm@linux-foundation.org
Subject: + posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes.patch added to -mm tree
Date: Wed, 25 Jul 2012 13:03:28 -0700
Message-ID: <20120725200329.49C441E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52675 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2GYUDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 16:03:30 -0400
Received: by vcqp1 with SMTP id p1so127724vcq.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 13:03:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jwboyer@redhat.com, law@redhat.com, torvalds@linux-foundation.org


The patch titled
     Subject: posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes.patch

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
Subject: posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes

ERROR: trailing whitespace
#107: FILE: include/linux/posix_types.h:19:
+ * use the one here. $

ERROR: space prohibited before open square bracket '['
#126: FILE: include/linux/posix_types.h:25:
+	unsigned long fds_bits [__FD_SETSIZE / (8 * sizeof(long))];

total: 2 errors, 0 warnings, 106 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/posix_typesh-cleanup-stale-__nfdbits-and-related-definitions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Law <law@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/posix_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/posix_types.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes include/linux/posix_types.h
--- a/include/linux/posix_types.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes
+++ a/include/linux/posix_types.h
@@ -16,13 +16,13 @@
 
 /*
  * This macro may have been defined in <gnu/types.h>. But we always
- * use the one here. 
+ * use the one here.
  */
 #undef __FD_SETSIZE
 #define __FD_SETSIZE	1024
 
 typedef struct {
-	unsigned long fds_bits [__FD_SETSIZE / (8 * sizeof(long))];
+	unsigned long fds_bits[__FD_SETSIZE / (8 * sizeof(long))];
 } __kernel_fd_set;
 
 /* Type of a signal handler.  */
_
Subject: Subject: posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
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
memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch
memcg-oom-clarify-some-oom-dump-messages-checkpatch-fixes.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
rbtree-performance-and-correctness-test-fix.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

