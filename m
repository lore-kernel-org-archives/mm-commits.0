From: akpm@linux-foundation.org
Subject: [folded] kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:20:11 -0800
Message-ID: <201101130020.p0D0KBCw012160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab1AMAUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, drosenberg@vsecurity.com, mm-commits@vger.kernel.org


The patch titled
     kptr_restrict-for-hiding-kernel-pointers-v7-fix
has been removed from the -mm tree.  Its filename was
     kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch

This patch was dropped because it was folded into kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kptr_restrict-for-hiding-kernel-pointers-v7-fix
From: Andrew Morton <akpm@linux-foundation.org>

coding-style fixup

Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v7-fix lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v7-fix
+++ a/lib/vsprintf.c
@@ -1047,9 +1047,7 @@ char *pointer(const char *fmt, char *buf
 			if (spec.field_width == -1)
 				spec.field_width = 2 * sizeof(void *);
 			return string(buf, end, "pK-error", spec);
-		}
-
-		else if ((kptr_restrict == 0) ||
+		} else if ((kptr_restrict == 0) ||
 			 (kptr_restrict == 1 &&
 			  has_capability_noaudit(current, CAP_SYSLOG)))
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
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

