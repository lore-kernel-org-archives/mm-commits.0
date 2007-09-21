From: akpm@linux-foundation.org
Subject: + typo-fix-kernel-config-option.patch added to -mm tree
Date: Fri, 21 Sep 2007 13:14:14 -0700
Message-ID: <200709212014.l8LKEECF020600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761568AbXIUUOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 16:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dth@dth.net


The patch titled
     typo fix Kernel config option
has been added to the -mm tree.  Its filename is
     typo-fix-kernel-config-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: typo fix Kernel config option
From: Danny ter Haar <dth@dth.net>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

typo-fix-kernel-config-option.patch
