From: akpm@linux-foundation.org
Subject: +
 makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch added to -mm tree
Date: Fri, 23 Aug 2013 16:09:26 -0700
Message-ID: <5217eba6.QHltsW7vqov5SMsz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3HWXJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 19:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slyfox@gentoo.org, mmarek@suse.cz, geert@linux-m68k.org, akpm@linux-foundation.org

Subject: + makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch added to -mm tree
To: akpm@linux-foundation.org,geert@linux-m68k.org,mmarek@suse.cz,slyfox@gentoo.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 16:09:26 -0700


The patch titled
     Subject: makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix
has been added to the -mm tree.  Its filename is
     makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch

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
Subject: makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix

fix typos in comments

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix Makefile
--- a/Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix
+++ a/Makefile
@@ -659,10 +659,10 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
-# disallog errors like 'EXPORT_GPL(foo);' with missing header
+# disallow errors like 'EXPORT_GPL(foo);' with missing header
 KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)
 
-# require functions to have argumens in prototypes, not empty 'int foo()'
+# require functions to have arguments in prototypes, not empty 'int foo()'
 KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
 
 # use the deterministic mode of AR if available
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

