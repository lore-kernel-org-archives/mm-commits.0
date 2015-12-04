From: akpm@linux-foundation.org
Subject: +
 include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch added
 to -mm tree
Date: Fri, 04 Dec 2015 00:47:15 -0800
Message-ID: <56615313.ImU2mnRPGycfkqGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbbLDIrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 03:47:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dcache.h: remove semicolons from HASH_LEN_DECLARE
has been added to the -mm tree.  Its filename is
     include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch

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
Subject: include/linux/dcache.h: remove semicolons from HASH_LEN_DECLARE

A little cleanup - the invocation site provdes the semicolon.

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dcache.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dcache.h~include-linux-dcacheh-remove-semicolons-from-hash_len_declare include/linux/dcache.h
--- a/include/linux/dcache.h~include-linux-dcacheh-remove-semicolons-from-hash_len_declare
+++ a/include/linux/dcache.h
@@ -27,10 +27,10 @@ struct vfsmount;
 
 /* The hash is always the low bits of hash_len */
 #ifdef __LITTLE_ENDIAN
- #define HASH_LEN_DECLARE u32 hash; u32 len;
+ #define HASH_LEN_DECLARE u32 hash; u32 len
  #define bytemask_from_count(cnt)	(~(~0ul << (cnt)*8))
 #else
- #define HASH_LEN_DECLARE u32 len; u32 hash;
+ #define HASH_LEN_DECLARE u32 len; u32 hash
  #define bytemask_from_count(cnt)	(~(~0ul >> (cnt)*8))
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
linux-next-git-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

