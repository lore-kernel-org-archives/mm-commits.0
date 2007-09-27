From: akpm@linux-foundation.org
Subject: - typo-fix-kernel-config-option.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:42:45 -0700
Message-ID: <200709270142.l8R1gjZ1013899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbXI0Bmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dth@dth.net, mm-commits@vger.kernel.org


The patch titled
     typo fix Kernel config option
has been removed from the -mm tree.  Its filename was
     typo-fix-kernel-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: typo fix Kernel config option
From: Danny ter Haar <dth@dth.net>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~typo-fix-kernel-config-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~typo-fix-kernel-config-option
+++ a/lib/Kconfig.debug
@@ -284,7 +284,7 @@ config LOCKDEP
 	select KALLSYMS_ALL
 
 config LOCK_STAT
-	bool "Lock usage statisitics"
+	bool "Lock usage statistics"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select LOCKDEP
 	select DEBUG_SPINLOCK
_

Patches currently in -mm which might be from dth@dth.net are

origin.patch
