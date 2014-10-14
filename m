From: akpm@linux-foundation.org
Subject: [merged]
 ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:14 -0700
Message-ID: <543d6a12.ai0Lb5UcaMmWuimG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbaJNSXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove duplicate declarations of __per_cpu_start[] and __per_cpu_end[]
has been removed from the -mm tree.  Its filename was
     ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: ia64: remove duplicate declarations of __per_cpu_start[] and __per_cpu_end[]

They're already provided by <asm/sections.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/sections.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/sections.h~ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end arch/ia64/include/asm/sections.h
--- a/arch/ia64/include/asm/sections.h~ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end
+++ a/arch/ia64/include/asm/sections.h
@@ -10,7 +10,7 @@
 #include <linux/uaccess.h>
 #include <asm-generic/sections.h>
 
-extern char __per_cpu_start[], __per_cpu_end[], __phys_per_cpu_start[];
+extern char __phys_per_cpu_start[];
 #ifdef	CONFIG_SMP
 extern char __cpu0_per_cpu[];
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

