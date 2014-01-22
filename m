From: akpm@linux-foundation.org
Subject: [merged] score-remove-select-have_generic_hardirqs-again.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:33 -0800
Message-ID: <52e025f5.+Pa7pA5PHqK9LXVO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaAVULd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com, geert@linux-m68k.org

Subject: [merged] score-remove-select-have_generic_hardirqs-again.patch removed from -mm tree
To: geert@linux-m68k.org,lennox.wu@gmail.com,liqin.linux@gmail.com,schwidefsky@de.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:33 -0800


The patch titled
     Subject: score: remove "select HAVE_GENERIC_HARDIRQS" again
has been removed from the -mm tree.  Its filename was
     score-remove-select-have_generic_hardirqs-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: score: remove "select HAVE_GENERIC_HARDIRQS" again

5fbbf8a1a93 ("Score: The commit is for compiling successfully.")
re-introduced "select HAVE_GENERIC_HARDIRQS" in v3.12-rc4, which had just
been removed in v3.12-rc1 by 0244ad004a5 ("Remove GENERIC_HARDIRQ config
option").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/score/Kconfig~score-remove-select-have_generic_hardirqs-again arch/score/Kconfig
--- a/arch/score/Kconfig~score-remove-select-have_generic_hardirqs-again
+++ a/arch/score/Kconfig
@@ -2,7 +2,6 @@ menu "Machine selection"
 
 config SCORE
        def_bool y
-       select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
        select GENERIC_ATOMIC64
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
cris-provide-inout_p.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

