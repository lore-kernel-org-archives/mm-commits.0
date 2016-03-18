From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-export-the-number-of-available-comp-streams-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 18:40:33 -0700
Message-ID: <56eb5c91.zNcyoT+AJZmb7GOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbcCRBke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 21:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-export-the-number-of-available-comp-streams-fix
has been removed from the -mm tree.  Its filename was
     zram-export-the-number-of-available-comp-streams-fix.patch

This patch was dropped because it was folded into zram-export-the-number-of-available-comp-streams.patch

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

mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
zram-export-the-number-of-available-comp-streams.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

