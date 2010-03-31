From: akpm@linux-foundation.org
Subject: [obsolete] hardware-latency-detector-remove-default-m.patch removed from -mm tree
Date: Wed, 31 Mar 2010 11:52:08 -0400
Message-ID: <201003311853.o2VIrI4m002055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576Ab0CaSxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 14:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, jcm@jonmasters.org, mm-commits@vger.kernel.org


The patch titled
     hardware latency detector: remove "default m"
has been removed from the -mm tree.  Its filename was
     hardware-latency-detector-remove-default-m.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hardware latency detector: remove "default m"
From: Andi Kleen <andi@firstfloor.org>

No reason at all why this should be default anything except n.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jon Masters <jcm@jonmasters.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/Kconfig~hardware-latency-detector-remove-default-m drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~hardware-latency-detector-remove-default-m
+++ a/drivers/misc/Kconfig
@@ -94,7 +94,6 @@ config HWLAT_DETECTOR
 	tristate "Testing module to detect hardware-induced latencies"
 	depends on DEBUG_FS
 	depends on RING_BUFFER
-	default m
 	---help---
 	  A simple hardware latency detector. Use this module to detect
 	  large latencies introduced by the behavior of the underlying
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch

