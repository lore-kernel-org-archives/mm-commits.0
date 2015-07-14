From: akpm@linux-foundation.org
Subject: +
 mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch added to -mm tree
Date: Tue, 14 Jul 2015 14:45:01 -0700
Message-ID: <55a582dd.T++9K/4OD8HK1uWM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbGNVpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 17:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-__gfp_noretry-comment-based-on-implementation-fix
has been added to the -mm tree.  Its filename is
     mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch

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
Subject: mm-improve-__gfp_noretry-comment-based-on-implementation-fix

s/has/have/

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation-fix
+++ a/include/linux/gfp.h
@@ -64,8 +64,8 @@ struct vm_area_struct;
  * loop around allocator.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
- * return NULL when direct reclaim and memory compaction has failed to allow the
- * allocation to succeed.  The OOM killer is not called with the current
+ * return NULL when direct reclaim and memory compaction have failed to allow
+ * the allocation to succeed.  The OOM killer is not called with the current
  * implementation.
  *
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

