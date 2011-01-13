From: akpm@linux-foundation.org
Subject: [folded] aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:29:25 -0800
Message-ID: <201101130029.p0D0TP0w012589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMA3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     aio-remove-unused-aio_run_iocbs-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch

This patch was dropped because it was folded into aio-remove-unused-aio_run_iocbs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio-remove-unused-aio_run_iocbs-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#25: FILE: fs/aio.c:804:
+ * ^Irun list, and keep running them until the list$

WARNING: please, no space before tabs
#26: FILE: fs/aio.c:805:
+ * ^Istays empty.$

total: 0 errors, 2 warnings, 33 lines checked

./patches/aio-remove-unused-aio_run_iocbs.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/aio.c~aio-remove-unused-aio_run_iocbs-checkpatch-fixes fs/aio.c
--- a/fs/aio.c~aio-remove-unused-aio_run_iocbs-checkpatch-fixes
+++ a/fs/aio.c
@@ -800,11 +800,10 @@ static void aio_queue_work(struct kioctx
 
 /*
  * aio_run_all_iocbs:
- * 	Process all pending retries queued on the ioctx
- * 	run list, and keep running them until the list
- * 	stays empty.
- * Assumes it is operating within the aio issuer's mm
- * context.
+ *	Process all pending retries queued on the ioctx
+ *	run list, and keep running them until the list
+ *	stays empty.
+ * Assumes it is operating within the aio issuer's mm context.
  */
 static inline void aio_run_all_iocbs(struct kioctx *ctx)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
sysctl-remove-obsolete-comments.patch
user_ns-improve-the-user_ns-on-the-slab-packaging.patch
pps-add-parallel-port-pps-signal-generator.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
aio-remove-unused-aio_run_iocbs.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

