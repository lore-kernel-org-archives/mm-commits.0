From: akpm@linux-foundation.org
Subject: [folded] fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:23:43 -0800
Message-ID: <201101130023.p0D0NhQG012337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab1AMAXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#36: FILE: fs/proc/base.c:382:
+^I^I^I^Iunsigned long bt = lr->backtrace[q]; $

ERROR: trailing whitespace
#73: FILE: kernel/latencytop.c:252:
+^I^I^I^Iunsigned long bt = lr->backtrace[q]; $

total: 2 errors, 0 warnings, 65 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    2 +-
 kernel/latencytop.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -379,7 +379,7 @@ static int lstats_show_proc(struct seq_f
 			seq_printf(m, "%i %li %li",
 				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				unsigned long bt = lr->backtrace[q]; 
+				unsigned long bt = lr->backtrace[q];
 				if (!bt)
 					break;
 				if (bt == ULONG_MAX)
diff -puN kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes kernel/latencytop.c
--- a/kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
+++ a/kernel/latencytop.c
@@ -248,7 +248,7 @@ static int lstats_show(struct seq_file *
 			seq_printf(m, "%i %lu %lu",
 				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				unsigned long bt = lr->backtrace[q]; 
+				unsigned long bt = lr->backtrace[q];
 				if (!bt)
 					break;
 				if (bt == ULONG_MAX)
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
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

