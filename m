From: akpm@linux-foundation.org
Subject: +
 kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 16:48:58 -0700
Message-ID: <523b8d6a.bMF54CGE91oGFFow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISXs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chuansheng.liu@intel.com, akpm@linux-foundation.org

Subject: + kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch added to -mm tree
To: akpm@linux-foundation.org,chuansheng.liu@intel.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:48:58 -0700


The patch titled
     Subject: kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix
has been added to the -mm tree.  Its filename is
     kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch

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
Subject: kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix

fix comment layout

Cc: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/reboot.c~kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix kernel/reboot.c
--- a/kernel/reboot.c~kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix
+++ a/kernel/reboot.c
@@ -38,7 +38,7 @@ enum reboot_mode reboot_mode DEFAULT_REB
  * been set on the command line).  This is needed so that we can
  * suppress DMI scanning for reboot quirks.  Without it, it's
  * impossible to override a faulty reboot quirk without recompiling.
-*/
+ */
 int reboot_default = 1;
 int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

