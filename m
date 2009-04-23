From: akpm@linux-foundation.org
Subject: + arm-mach-l7200-fix-spelling-of-sys_clock_off.patch added to -mm tree
Date: Thu, 23 Apr 2009 13:42:59 -0700
Message-ID: <200904232042.n3NKgxHh032570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757583AbZDWUpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 16:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: proski@gnu.org


The patch titled
     arm: mach-l7200: fix spelling of SYS_CLOCK_OFF
has been added to the -mm tree.  Its filename is
     arm-mach-l7200-fix-spelling-of-sys_clock_off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
arm-mach-l7200-fix-spelling-of-sys_clock_off.patch
intelfb-fix-spelling-of-clock.patch

