From: akpm@linux-foundation.org
Subject: + fix-drivers-lguest-makefile-entry.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:17 -0800
Message-ID: <200801270518.m0R5IEfj031186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbYA0FSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, rusty@rustcorp.com.au


The patch titled
     fix drivers/lguest Makefile entry
has been added to the -mm tree.  Its filename is
     fix-drivers-lguest-makefile-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
git-x86.patch
fix-drivers-lguest-makefile-entry.patch
lguest-remove-pv_info-dependency.patch
