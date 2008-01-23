From: akpm@linux-foundation.org
Subject: + fix-drivers-lguest-makefile-entry.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:06:23 -0800
Message-ID: <200801232106.m0NL6FQw026457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbYAWVG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:06:59 -0500
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
