From: akpm@linux-foundation.org
Subject: + pagemap-update-documentation-fix.patch added to -mm tree
Date: Tue, 21 Jul 2015 14:26:02 -0700
Message-ID: <55aeb8ea.Y10kSSy9Mjafl7E/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbbGUV0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 17:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap-update-documentation-fix
has been added to the -mm tree.  Its filename is
     pagemap-update-documentation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-update-documentation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-update-documentation-fix.patch

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
Subject: pagemap-update-documentation-fix

various tweaks

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-update-documentation-fix Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-update-documentation-fix
+++ a/Documentation/vm/pagemap.txt
@@ -22,9 +22,9 @@ There are three components to pagemap:
     * Bit  62    page swapped
     * Bit  63    page present
 
-   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs:
-   for unprivileged users from 4.0 till 4.2 open fails with -EPERM, starting
-   from from 4.2 PFN field is zeroed if user has no CAP_SYS_ADMIN capability.
+   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs.
+   In 4.0 and 4.1 opens by unprivileged fail with -EPERM.  Starting from
+   4.2 the PFN field is zeroed if the user does not have CAP_SYS_ADMIN.
    Reason: information about PFNs helps in exploiting Rowhammer vulnerability.
 
    If the page is not present but in swap, then the PFN contains an
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-gup-add-mm_lock_present-checkpatch-fixes.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
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
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

