From: akpm@linux-foundation.org
Subject: + zram-export-the-number-of-available-comp-streams-fix.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 13:13:56 -0800
Message-ID: <56a7e194.+w1tDqB+TqoHVij3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbcAZVN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:13:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-export-the-number-of-available-comp-streams-fix
has been added to the -mm tree.  Its filename is
     zram-export-the-number-of-available-comp-streams-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-export-the-number-of-available-comp-streams-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-export-the-number-of-available-comp-streams-fix.patch

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
Subject: zram-export-the-number-of-available-comp-streams-fix

tweak documentation text

Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-export-the-number-of-available-comp-streams-fix Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-export-the-number-of-available-comp-streams-fix
+++ a/Documentation/blockdev/zram.txt
@@ -230,12 +230,13 @@ line of text and contains the following
 	avail_streams
 
 `avail_streams' column shows the current number of available compression
-streams, which is not necessarily equal to the number of max compression
-streams. The number of max compression streams can be set too high and be
-unreachable (depending on the load and the usage pattern, of course).
-`avail_streams' let to find out the real 'level of concurrency' that
-a particular zram device saw and to calculate the real memory consumption
-by allocated compression streams, not the theoretical maximum value.
+streams, which is not necessarily equal to the max number of compression
+streams.  The max number of compression streams can be set too high and
+can be unreachable (depending on the load and the usage pattern, of
+course).  `avail_streams' permits finding out the real 'level of
+concurrency' that a particular zram device saw and to calculate the real
+memory consumption by allocated compression streams, not the theoretical
+maximum value.
 
 9) Deactivate:
 	swapoff /dev/zram0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

