From: akpm@linux-foundation.org
Subject: + rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch added to -mm tree
Date: Fri, 22 Jun 2012 16:29:48 -0700
Message-ID: <20120622232949.14FC0A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63027 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab2FVX3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 19:29:51 -0400
Received: by qabg24 with SMTP id g24so47608qab.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 16:29:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lee.jones@linaro.org


The patch titled
     Subject: rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch

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
Subject: rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes

ERROR: code indent should use tabs where possible
#41: FILE: drivers/rtc/rtc-ab8500.c:458:
+        { .compatible = "stericsson,ab8500-rtc", },$

WARNING: please, no spaces at the start of a line
#41: FILE: drivers/rtc/rtc-ab8500.c:458:
+        { .compatible = "stericsson,ab8500-rtc", },$

ERROR: code indent should use tabs where possible
#42: FILE: drivers/rtc/rtc-ab8500.c:459:
+        {}$

WARNING: please, no spaces at the start of a line
#42: FILE: drivers/rtc/rtc-ab8500.c:459:
+        {}$

total: 2 errors, 2 warnings, 30 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes
+++ a/drivers/rtc/rtc-ab8500.c
@@ -455,8 +455,8 @@ static int __devexit ab8500_rtc_remove(s
 }
 
 static const struct of_device_id ab8500_rtc_match[] = {
-        { .compatible = "stericsson,ab8500-rtc", },
-        {}
+	{ .compatible = "stericsson,ab8500-rtc", },
+	{}
 };
 
 static struct platform_driver ab8500_rtc_driver = {
_
Subject: Subject: rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
fs-jbd2-commitc-use-new-kmap_atomic-api.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

