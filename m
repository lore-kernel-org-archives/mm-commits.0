From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:21:19 -0700
Message-ID: <553551af.ylM3nSF9HmMPtvfd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbDTTO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: merge fix for watchdog_enable_hardlockup_detector API change
has been removed from the -mm tree.  Its filename was
     powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc: merge fix for watchdog_enable_hardlockup_detector API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/setup_64.c~powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change
+++ a/arch/powerpc/kernel/setup_64.c
@@ -793,7 +793,7 @@ u64 hw_nmi_get_sample_period(int watchdo
  */
 static int __init disable_hardlockup_detector(void)
 {
-	watchdog_enable_hardlockup_detector(false);
+	hardlockup_detector_disable();
 
 	return 0;
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

