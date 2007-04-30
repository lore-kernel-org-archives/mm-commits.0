From: akpm@linux-foundation.org
Subject: - git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:32 -0700
Message-ID: <200704302144.l3ULiWKl015606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423725AbXD3Vpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivasa@in.ibm.com, benh@kernel.crashing.org, johannes@sipsolutions.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     git-powerpc: arch/powerpc/sysdev/timer.c build fix
has been removed from the -mm tree.  Its filename was
     git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-powerpc: arch/powerpc/sysdev/timer.c build fix
From: Srinivasa Ds <srinivasa@in.ibm.com>

arch/powerpc/sysdev/timer.c:51: error: variable `timer_sysclass' has 
initializer but incomplete type
arch/powerpc/sysdev/timer.c:52: error: unknown field `resume' specified in initializer
<etc>

Signed-off-by: Srinivasa Ds <srinivasa@in.ibm.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/timer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/sysdev/timer.c~git-powerpc-arch-powerpc-sysdev-timerc-build-fix arch/powerpc/sysdev/timer.c
--- a/arch/powerpc/sysdev/timer.c~git-powerpc-arch-powerpc-sysdev-timerc-build-fix
+++ a/arch/powerpc/sysdev/timer.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/sysdev.h>
 #include <asm/rtc.h>
 
 static unsigned long suspend_rtc_time;
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

origin.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
