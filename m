From: akpm@linux-foundation.org
Subject: + git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:27:25 -0700
Message-ID: <200704102227.l3AMRPPF019670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506AbXDJW2B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivasa@in.ibm.com, benh@kernel.crashing.org, johannes@sipsolutions.net, paulus@samba.org


The patch titled
     git-powerpc: arch/powerpc/sysdev/timer.c build fix
has been added to the -mm tree.  Its filename is
     git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-powerpc: arch/powerpc/sysdev/timer.c build fix
From: Srinivasa Ds <srinivasa@in.ibm.com>

arch/powerpc/sysdev/timer.c:51: error: variable \u2018timer_sysclass\u2019 has 
initializer but incomplete type
arch/powerpc/sysdev/timer.c:52: error: unknown field \u2018resume\u2019 specified in initializer
<etc>

Signed-off-by: Srinivasa Ds <srinivasa@in.ibm.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/timer.c |    1 +
 1 files changed, 1 insertion(+)

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

git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
