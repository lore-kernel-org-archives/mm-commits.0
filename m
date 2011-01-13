From: akpm@linux-foundation.org
Subject: [folded] cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:30:43 -0800
Message-ID: <201101130030.p0D0UhvG012628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMAa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:30:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix
has been removed from the -mm tree.  Its filename was
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch

This patch was dropped because it was folded into cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix
From: Andrew Morton <akpm@linux-foundation.org>

trivial comment fix

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix
+++ a/fs/cramfs/inode.c
@@ -45,7 +45,7 @@ static unsigned long cramino(struct cram
 		return offset + 1;
 
 	/*
-	 * The file mode test fix buggy mkcramfs implementations where
+	 * The file mode test fixes buggy mkcramfs implementations where
 	 * cramfs_inode->offset is set to a non zero value for entries
 	 * which did not contain data, like devices node and fifos.
 	 */
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
cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

