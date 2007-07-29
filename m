From: akpm@linux-foundation.org
Subject: + change-order-in-kconfigcpu-i386.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:44:03 -0700
Message-ID: <200707290644.l6T6i3L2012209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759419AbXG2Goa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oliver.pntr@gmail.com, ak@suse.de, sam@ravnborg.org


The patch titled
     i386: change order in Kconfig.cpu
has been added to the -mm tree.  Its filename is
     change-order-in-kconfigcpu-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: change order in Kconfig.cpu
From: "Oliver Pinter" <oliver.pntr@gmail.com>

Change the sort in arch/i386/Kconfig.cpu file, while it is logicaller (by
productions time-line).

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/i386/Kconfig.cpu~change-order-in-kconfigcpu-i386 arch/i386/Kconfig.cpu
--- a/arch/i386/Kconfig.cpu~change-order-in-kconfigcpu-i386
+++ a/arch/i386/Kconfig.cpu
@@ -104,13 +104,6 @@ config MPENTIUMM
 	  Select this for Intel Pentium M (not Pentium-4 M)
 	  notebook chips.
 
-config MCORE2
-	bool "Core 2/newer Xeon"
-	help
-	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distinguish newer from older Xeons by the CPU family
-	  in /proc/cpuinfo. Newer ones have 6.
-
 config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
 	help
@@ -147,6 +140,12 @@ config MPENTIUM4
 
 	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
 
+config MCORE2
+	bool "Core 2/newer Xeon"
+	help
+	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
+	  CPUs. You can distinguish newer from older Xeons by the CPU family
+	  in /proc/cpuinfo. Newer ones have 6.
 
 config MK6
 	bool "K6/K6-II/K6-III"
_

Patches currently in -mm which might be from oliver.pntr@gmail.com are

x86-add-cpu-codenames-for-kconfigcpu.patch
change-order-in-kconfigcpu-i386.patch
