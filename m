From: akpm@linux-foundation.org
Subject: - i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:21 -0800
Message-ID: <200802080809.m1889277014791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297AbYBHITW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bradjsmith@btinternet.com, frank@tuxrocks.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     I8K: add i8k driver to the x86_64 Kconfig
has been removed from the -mm tree.  Its filename was
     i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: I8K: add i8k driver to the x86_64 Kconfig
From: Bradley Smith <bradjsmith@btinternet.com>

Adds i8k driver to the x86_64 Kconfig.

Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
Cc: Frank Sorenson <frank@tuxrocks.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/Kconfig~i8k-adds-i8k-driver-to-the-x86_64-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~i8k-adds-i8k-driver-to-the-x86_64-kconfig
+++ a/arch/x86/Kconfig
@@ -631,7 +631,6 @@ config TOSHIBA
 
 config I8K
 	tristate "Dell laptop support"
-	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode
 	  of the CPU on the Dell Inspiron 8000. The System Management Mode
_

Patches currently in -mm which might be from bradjsmith@btinternet.com are

origin.patch
