From: akpm@linux-foundation.org
Subject: + mm-change-meminfo-cached-calculation-fix.patch added to -mm
 tree
Date: Tue, 06 Jan 2015 16:44:04 -0800
Message-ID: <54ac8154.JMQMs1cu6gibbCLV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbbAGAoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:44:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Yalin.Wang@sonymobile.com, hughd@google.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-meminfo-cached-calculation-fix
has been added to the -mm tree.  Its filename is
     mm-change-meminfo-cached-calculation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-meminfo-cached-calculation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-meminfo-cached-calculation-fix.patch

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
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch
mm-change-meminfo-cached-calculation-fix.patch
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
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

