From: akpm@linux-foundation.org
Subject: [folded] sysctl-remove-obsolete-comments-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:25:10 -0800
Message-ID: <201101130025.p0D0PAOY012378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437Ab1AMAZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:25:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bookjovi@gmail.com, hidave.darkstar@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-remove-obsolete-comments-fix
has been removed from the -mm tree.  Its filename was
     sysctl-remove-obsolete-comments-fix.patch

This patch was dropped because it was folded into sysctl-remove-obsolete-comments.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-remove-obsolete-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix Documentation/sysctl/00-INDEX, per Dave

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Jovi Zhang <bookjovi@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments-fix Documentation/sysctl/00-INDEX
--- a/Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments-fix
+++ a/Documentation/sysctl/00-INDEX
@@ -4,8 +4,6 @@ README
 	- general information about /proc/sys/ sysctl files.
 abi.txt
 	- documentation for /proc/sys/abi/*.
-ctl_unnumbered.txt
-	- explanation of why one should not add new binary sysctl numbers.
 fs.txt
 	- documentation for /proc/sys/fs/*.
 kernel.txt
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
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

