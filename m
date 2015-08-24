From: akpm@linux-foundation.org
Subject: + schedh-dont-include-mm_typesh-fix-2.patch added to -mm tree
Date: Mon, 24 Aug 2015 15:03:55 -0700
Message-ID: <55db94cb.KnZTXCusyRp21NOa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbbHXWD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 18:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mgorman@techsingularity.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: schedh-dont-include-mm_typesh-fix-2
has been added to the -mm tree.  Its filename is
     schedh-dont-include-mm_typesh-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/schedh-dont-include-mm_typesh-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/schedh-dont-include-mm_typesh-fix-2.patch

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
Subject: schedh-dont-include-mm_typesh-fix-2

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff -puN drivers/gpu/drm/amd/amdkfd/kfd_process.c~schedh-dont-include-mm_typesh-fix-2 drivers/gpu/drm/amd/amdkfd/kfd_process.c
diff -puN fs/binfmt_elf.c~schedh-dont-include-mm_typesh-fix-2 fs/binfmt_elf.c
diff -puN fs/binfmt_elf_fdpic.c~schedh-dont-include-mm_typesh-fix-2 fs/binfmt_elf_fdpic.c
diff -puN fs/exec.c~schedh-dont-include-mm_typesh-fix-2 fs/exec.c
diff -puN fs/proc/base.c~schedh-dont-include-mm_typesh-fix-2 fs/proc/base.c
diff -puN include/linux/khugepaged.h~schedh-dont-include-mm_typesh-fix-2 include/linux/khugepaged.h
diff -puN include/linux/ksm.h~schedh-dont-include-mm_typesh-fix-2 include/linux/ksm.h
diff -puN include/linux/mm-config.h~schedh-dont-include-mm_typesh-fix-2 include/linux/mm-config.h
diff -puN include/linux/mm-flags.h~schedh-dont-include-mm_typesh-fix-2 include/linux/mm-flags.h
diff -puN include/linux/mm-rss.h~schedh-dont-include-mm_typesh-fix-2 include/linux/mm-rss.h
diff -puN include/linux/mm.h~schedh-dont-include-mm_typesh-fix-2 include/linux/mm.h
diff -puN include/linux/mm_types.h~schedh-dont-include-mm_typesh-fix-2 include/linux/mm_types.h
diff -puN include/linux/page_frag.h~schedh-dont-include-mm_typesh-fix-2 include/linux/page_frag.h
diff -puN include/linux/sched.h~schedh-dont-include-mm_typesh-fix-2 include/linux/sched.h
diff -puN include/linux/threads.h~schedh-dont-include-mm_typesh-fix-2 include/linux/threads.h
diff -puN kernel/events/uprobes.c~schedh-dont-include-mm_typesh-fix-2 kernel/events/uprobes.c
diff -puN kernel/fork.c~schedh-dont-include-mm_typesh-fix-2 kernel/fork.c
diff -puN kernel/ptrace.c~schedh-dont-include-mm_typesh-fix-2 kernel/ptrace.c
diff -puN kernel/sys.c~schedh-dont-include-mm_typesh-fix-2 kernel/sys.c
diff -puN kernel/user_namespace.c~schedh-dont-include-mm_typesh-fix-2 kernel/user_namespace.c
diff -puN lib/is_single_threaded.c~schedh-dont-include-mm_typesh-fix-2 lib/is_single_threaded.c
diff -puN mm/huge_memory.c~schedh-dont-include-mm_typesh-fix-2 mm/huge_memory.c
diff -puN mm/ksm.c~schedh-dont-include-mm_typesh-fix-2 mm/ksm.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
schedh-dont-include-mm_typesh.patch
schedh-dont-include-mm_typesh-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
schedh-dont-include-mm_typesh-fix-2.patch

