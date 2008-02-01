From: akpm@linux-foundation.org
Subject: - fix-drivers-lguest-makefile-entry.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:47 -0800
Message-ID: <200802012230.m11MUl5h001934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762298AbYBAWkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:40:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix drivers/lguest Makefile entry
has been removed from the -mm tree.  Its filename was
     fix-drivers-lguest-makefile-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix drivers/lguest Makefile entry
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Parts depend on CONFIG_LGUEST, not just CONFIG_LGUEST_GUEST

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
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
+obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_MMC)		+= mmc/
_

Patches currently in -mm which might be from gcosta@redhat.com are

origin.patch
git-kvm.patch
