From: akpm@linux-foundation.org
Subject: + score-remove-unused-cpu_score7-kconfig-parameter.patch added to -mm tree
Date: Mon, 10 Mar 2014 12:10:47 -0700
Message-ID: <531e0e37.Zb/ZJQMVEgoIDurc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaCJTKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liqin.linux@gmail.com, lennox.wu@gmail.com, michael.opdenacker@free-electrons.com

Subject: + score-remove-unused-cpu_score7-kconfig-parameter.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,lennox.wu@gmail.com,liqin.linux@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:10:47 -0700


The patch titled
     Subject: score: remove unused CPU_SCORE7 Kconfig parameter
has been added to the -mm tree.  Its filename is
     score-remove-unused-cpu_score7-kconfig-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-remove-unused-cpu_score7-kconfig-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-remove-unused-cpu_score7-kconfig-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: score: remove unused CPU_SCORE7 Kconfig parameter

This removes the CPU_SCORE7 Kconfig parameter, which is no longer used
anywhere in the source code and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

diff -puN arch/score/Kconfig~score-remove-unused-cpu_score7-kconfig-parameter arch/score/Kconfig
--- a/arch/score/Kconfig~score-remove-unused-cpu_score7-kconfig-parameter
+++ a/arch/score/Kconfig
@@ -22,27 +22,21 @@ choice
 config ARCH_SCORE7
 	bool "SCORE7 processor"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 endchoice
 
 endmenu
 
-config CPU_SCORE7
-	bool
