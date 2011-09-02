From: akpm@linux-foundation.org
Subject: + mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch added to -mm tree
Date: Fri, 02 Sep 2011 15:25:52 -0700
Message-ID: <201109022225.p82MPqjb013952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1IBWZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 18:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com


The patch titled
     mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#98: FILE: mm/page_alloc.c:5303:
+ * free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so $

ERROR: trailing whitespace
#103: FILE: mm/page_alloc.c:5307:
+int free_kbytes_sysctl_handler(ctl_table *table, int write, $

ERROR: need consistent spacing around '*' (ctx:WxV)
#103: FILE: mm/page_alloc.c:5307:
+int free_kbytes_sysctl_handler(ctl_table *table, int write, 
                                          ^

total: 3 errors, 0 warnings, 69 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-add-extra-free-kbytes-tunable-update.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes include/linux/mmzone.h
diff -puN include/linux/swap.h~mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes include/linux/swap.h
diff -puN kernel/sysctl.c~mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes kernel/sysctl.c
diff -puN mm/page_alloc.c~mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -5300,11 +5300,11 @@ int __meminit init_per_zone_wmark_min(vo
 module_init(init_per_zone_wmark_min)
 
 /*
- * free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
+ * free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so
  *	that we can call two helper functions whenever min_free_kbytes
  *	or extra_free_kbytes changes.
  */
-int free_kbytes_sysctl_handler(ctl_table *table, int write, 
+int free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug-fix.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

