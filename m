From: akpm@linux-foundation.org
Subject: - x86-adjust-dependencies-for-config_x86_cmov.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:19 -0700
Message-ID: <200809130745.m8D7jJmD026758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYIMHpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: adjust dependencies for CONFIG_X86_CMOV
has been removed from the -mm tree.  Its filename was
     x86-adjust-dependencies-for-config_x86_cmov.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

