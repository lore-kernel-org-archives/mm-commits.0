From: akpm@linux-foundation.org
Subject: + include-linux-math64h-add-div64_ul-checkpatch-fixes.patch added to -mm tree
Date: Mon, 10 Jun 2013 15:32:12 -0700
Message-ID: <51b653ec.wOypMUL4qhkIdVWn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3FJWcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alex.shi@intel.com, akpm@linux-foundation.org

Subject: + include-linux-math64h-add-div64_ul-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,alex.shi@intel.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:32:12 -0700


The patch titled
     Subject: include-linux-math64h-add-div64_ul-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     include-linux-math64h-add-div64_ul-checkpatch-fixes.patch

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
Subject: include-linux-math64h-add-div64_ul-checkpatch-fixes

ERROR: space required after that ',' (ctx:VxV)
#22: FILE: include/linux/math64.h:10:
+#define div64_ul(x,y)   div64_u64((x),(y))
                   ^

ERROR: space required after that ',' (ctx:VxV)
#22: FILE: include/linux/math64.h:10:
+#define div64_ul(x,y)   div64_u64((x),(y))
                                      ^

ERROR: space required after that ',' (ctx:VxV)
#30: FILE: include/linux/math64.h:52:
+#define div64_ul(x,y)   div_u64((x),(y))
                   ^

ERROR: space required after that ',' (ctx:VxV)
#30: FILE: include/linux/math64.h:52:
+#define div64_ul(x,y)   div_u64((x),(y))
                                    ^

total: 4 errors, 0 warnings, 14 lines checked

./patches/include-linux-math64h-add-div64_ul.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math64.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/math64.h~include-linux-math64h-add-div64_ul-checkpatch-fixes include/linux/math64.h
--- a/include/linux/math64.h~include-linux-math64h-add-div64_ul-checkpatch-fixes
+++ a/include/linux/math64.h
@@ -6,8 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
-#define div64_long(x,y) div64_s64((x),(y))
-#define div64_ul(x,y)   div64_u64((x),(y))
+#define div64_long(x, y) div64_s64((x), (y))
+#define div64_ul(x, y)   div64_u64((x), (y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -48,8 +48,8 @@ static inline s64 div64_s64(s64 dividend
 
 #elif BITS_PER_LONG == 32
 
-#define div64_long(x,y) div_s64((x),(y))
-#define div64_ul(x,y)   div_u64((x),(y))
+#define div64_long(x, y) div_s64((x), (y))
+#define div64_ul(x, y)   div_u64((x), (y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch
include-linux-math64h-add-div64_ul-checkpatch-fixes.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

