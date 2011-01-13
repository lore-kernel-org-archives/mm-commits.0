From: akpm@linux-foundation.org
Subject: [folded] user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:25:35 -0800
Message-ID: <201101130025.p0D0PZL9012390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab1AMAZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:25:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, serge@hallyn.com, xemul@openvz.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     user_ns-improve-the-user_ns-on-the-slab-packaging-fix
has been removed from the -mm tree.  Its filename was
     user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch

This patch was dropped because it was folded into user_ns-improve-the-user_ns-on-the-slab-packaging.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: user_ns-improve-the-user_ns-on-the-slab-packaging-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/__initcall/module_init/

Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/user_namespace.c~user_ns-improve-the-user_ns-on-the-slab-packaging-fix kernel/user_namespace.c
--- a/kernel/user_namespace.c~user_ns-improve-the-user_ns-on-the-slab-packaging-fix
+++ a/kernel/user_namespace.c
@@ -134,5 +134,4 @@ static __init int user_namespaces_init(v
 	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
 	return 0;
 }
-
-__initcall(user_namespaces_init);
+module_init(user_namespaces_init);
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
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

