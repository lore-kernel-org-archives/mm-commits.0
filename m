From: akpm@linux-foundation.org
Subject: [merged] arm-mach-l7200-fix-spelling-of-sys_clock_off.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:15 -0700
Message-ID: <200905261935.n4QJZF9q006115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064AbZEZTfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:35:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: proski@gnu.org, mm-commits@vger.kernel.org


The patch titled
     arm: mach-l7200: fix spelling of SYS_CLOCK_OFF
has been removed from the -mm tree.  Its filename was
     arm-mach-l7200-fix-spelling-of-sys_clock_off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: mach-l7200: fix spelling of SYS_CLOCK_OFF
From: Pavel Roskin <proski@gnu.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-l7200/include/mach/sys-clock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-l7200/include/mach/sys-clock.h~arm-mach-l7200-fix-spelling-of-sys_clock_off arch/arm/mach-l7200/include/mach/sys-clock.h
--- a/arch/arm/mach-l7200/include/mach/sys-clock.h~arm-mach-l7200-fix-spelling-of-sys_clock_off
+++ a/arch/arm/mach-l7200/include/mach/sys-clock.h
@@ -18,7 +18,7 @@
 
 /* IO_START and IO_BASE are defined in hardware.h */
 
-#define SYS_CLOCK_START (IO_START + SYS_CLCOK_OFF)  /* Physical address */
+#define SYS_CLOCK_START (IO_START + SYS_CLOCK_OFF)  /* Physical address */
 #define SYS_CLOCK_BASE  (IO_BASE  + SYS_CLOCK_OFF)  /* Virtual address  */
 
 /* Define the interface to the SYS_CLOCK */
_

Patches currently in -mm which might be from proski@gnu.org are

linux-next.patch
intelfb-fix-spelling-of-clock.patch

