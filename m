From: akpm@linux-foundation.org
Subject: + mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch added to -mm tree
Date: Wed, 29 Jul 2015 11:24:31 -0700
Message-ID: <55b91a5f.7Hxy0HlyWWx2wx6b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbG2SYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-new-mlock-system-call-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch

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
Subject: mm-mlock-add-new-mlock-system-call-checkpatch-fixes

WARNING: Missing a blank line after declarations
#99: FILE: mm/mlock.c:649:
+	vm_flags_t vm_flags = VM_LOCKED;
+	if (flags)

total: 0 errors, 1 warnings, 51 lines checked

./patches/mm-mlock-add-new-mlock-system-call.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-mlock-add-new-mlock-system-call-checkpatch-fixes mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-new-mlock-system-call-checkpatch-fixes
+++ a/mm/mlock.c
@@ -645,11 +645,10 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 {
-	vm_flags_t vm_flags = VM_LOCKED;
 	if (flags)
 		return -EINVAL;
 
-	return do_mlock(start, len, vm_flags);
+	return do_mlock(start, len, VM_LOCKED);
 }
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch
mm-introduce-vm_lockonfault-checkpatch-fixes.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

