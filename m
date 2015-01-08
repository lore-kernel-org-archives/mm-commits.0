From: akpm@linux-foundation.org
Subject: [nacked] mm-change-meminfo-cached-calculation-fix.patch removed
 from -mm tree
Date: Wed, 07 Jan 2015 17:53:33 -0800
Message-ID: <54ade31d.NOpAUQEbX+GG4dok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbbAHBxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 20:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Yalin.Wang@sonymobile.com, hughd@google.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-meminfo-cached-calculation-fix
has been removed from the -mm tree.  Its filename was
     mm-change-meminfo-cached-calculation-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-meminfo-cached-calculation-fix

update Documentation/filesystems/proc.txt

Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yalin Wang <yalin.wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-change-meminfo-cached-calculation-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-change-meminfo-cached-calculation-fix
+++ a/Documentation/filesystems/proc.txt
@@ -811,7 +811,7 @@ MemAvailable: An estimate of how much me
      Buffers: Relatively temporary storage for raw disk blocks
               shouldn't get tremendously large (20MB or so)
       Cached: in-memory cache for files read from the disk (the
-              pagecache).  Doesn't include SwapCached
+              pagecache).  Doesn't include SwapCached or Shmem.
   SwapCached: Memory that once was swapped out, is swapped back in but
               still also is in the swapfile (if memory is needed it
               doesn't need to be swapped out AGAIN because it is already
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

