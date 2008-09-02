From: akpm@linux-foundation.org
Subject: + x86-adjust-dependencies-for-config_x86_cmov.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:01:52 -0700
Message-ID: <200809022201.m82M1qG5014995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYIBWCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: adjust dependencies for CONFIG_X86_CMOV
has been added to the -mm tree.  Its filename is
     x86-adjust-dependencies-for-config_x86_cmov.patch

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
Subject: x86: adjust dependencies for CONFIG_X86_CMOV
From: "Jan Beulich" <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/Kconfig.cpu~x86-adjust-dependencies-for-config_x86_cmov arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~x86-adjust-dependencies-for-config_x86_cmov
+++ a/arch/x86/Kconfig.cpu
@@ -403,7 +403,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

