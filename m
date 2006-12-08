From: akpm@osdl.org
Subject: - fault-injection-Kconfig-cleanup-config_fault_injection-help-text.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:02:51 -0800
Message-ID: <200612080902.kB892pI9014348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425193AbWLHJCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     CONFIG_FAULT_INJECTION help text
has been removed from the -mm tree.  Its filename was
     fault-injection-Kconfig-cleanup-config_fault_injection-help-text.patch

This patch was dropped because it was folded into fault-injection-stacktrace-filtering.patch

------------------------------------------------------
Subject: CONFIG_FAULT_INJECTION help text
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch add a help text for CONFIG_FAULT_INJECTION

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Kconfig.debug |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/Kconfig.debug~fault-injection-Kconfig-cleanup-config_fault_injection-help-text lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-Kconfig-cleanup-config_fault_injection-help-text
+++ a/lib/Kconfig.debug
@@ -419,6 +419,9 @@ config FAULT_INJECTION
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE
 	select FRAME_POINTER
+	help
+	  Provide fault-injection framework.
+	  For more details, see Documentation/fault-injection/.
 
 config FAILSLAB
 	bool "Fault-injection capability for kmalloc"
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bit-revese-library.patch
crc32-replace-bitreverse-by-bitrev32.patch
video-use-bitrev8.patch
isdn-hisax-use-bitrev8.patch
atm-ambassador-use-bitrev8.patch
isdn-gigaset-use-bitrev8.patch
isdn-fix-missing-unregister_capi_driver.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capability-for-kmalloc.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-Kconfig-cleanup-config_fault_injection-help-text.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch

