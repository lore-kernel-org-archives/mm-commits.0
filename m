From: akpm@linux-foundation.org
Subject: - fix-drivers-lguest-makefile-entry.patch removed from -mm tree
Date: Thu, 24 Jan 2008 00:38:06 -0800
Message-ID: <200801240837.m0O8bwgp018203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYAXIj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jan 2008 03:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix drivers/lguest Makefile entry
has been removed from the -mm tree.  Its filename was
     fix-drivers-lguest-makefile-entry.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix drivers/lguest Makefile entry
From: Glauber de Oliveira Costa <gcosta@redhat.com>

It should depend on CONFIG_LGUEST, not CONFIG_LGUEST_GUEST

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/Makefile~fix-drivers-lguest-makefile-entry drivers/Makefile
--- a/drivers/Makefile~fix-drivers-lguest-makefile-entry
+++ a/drivers/Makefile
@@ -73,7 +73,7 @@ obj-$(CONFIG_ISDN)		+= isdn/
 obj-$(CONFIG_EDAC)		+= edac/
 obj-$(CONFIG_MCA)		+= mca/
 obj-$(CONFIG_EISA)		+= eisa/
-obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
+obj-$(CONFIG_LGUEST)		+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_MMC)		+= mmc/
_

Patches currently in -mm which might be from gcosta@redhat.com are

fix-drivers-lguest-makefile-entry.patch
git-kvm.patch
git-x86.patch
