From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-debugging-facility-to-access-dangling-memcgs-fix.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:30:43 -0700
Message-ID: <51b0e363.34lGhiTY+vg11iGY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3FFTao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@parallels.com, akpm@linux-foundation.org

Subject: [folded-merged] memcg-debugging-facility-to-access-dangling-memcgs-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,glommer@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:30:43 -0700


The patch titled
     Subject: memcg-debugging-facility-to-access-dangling-memcgs-fix
has been removed from the -mm tree.  Its filename was
     memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

This patch was dropped because it was folded into memcg-debugging-facility-to-access-dangling-memcgs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-debugging-facility-to-access-dangling-memcgs-fix

fix up Kconfig text

Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN init/Kconfig~memcg-debugging-facility-to-access-dangling-memcgs-fix init/Kconfig
--- a/init/Kconfig~memcg-debugging-facility-to-access-dangling-memcgs-fix
+++ a/init/Kconfig
@@ -941,14 +941,14 @@ config MEMCG_KMEM
 	  will ever exhaust kernel resources alone.
 
 config MEMCG_DEBUG_ASYNC_DESTROY
-	bool "Memory Resource Controller Debug assynchronous object destruction"
+	bool "Memory Resource Controller Debug asynchronous object destruction"
 	depends on MEMCG_KMEM || MEMCG_SWAP
 	default n
 	help
-	  When a memcg is destroyed, the memory
-	  consumed by it may not be immediately freed. This is because when some
-	  extensions are used, such as swap or kernel memory, objects can
-	  outlive the group and hold a reference to it.
+	  When a memcg is destroyed, the memory consumed by it may not be
+	  immediately freed. This is because when some extensions are used, such
+	  as swap or kernel memory, objects can outlive the group and hold a
+	  reference to it.
 
 	  If this is the case, the dangling_memcgs file will show information
 	  about what are the memcgs still alive, and which references are still
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
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
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

