From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
 removed from -mm tree
Date: Tue, 24 Sep 2013 15:20:28 -0700
Message-ID: <5242102c.8dJxu6ffr7O9Z2YY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IXWU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 18:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chuansheng.liu@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,chuansheng.liu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 15:20:28 -0700


The patch titled
     Subject: kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix
has been removed from the -mm tree.  Its filename was
     kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch

This patch was dropped because it was folded into kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
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

