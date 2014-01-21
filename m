From: akpm@linux-foundation.org
Subject: + score-remove-select-have_generic_hardirqs-again.patch added to
 -mm tree
Date: Tue, 21 Jan 2014 12:39:37 -0800
Message-ID: <52dedb09.8gqR0PVC9b87038U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAUUji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 15:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com, geert@linux-m68k.org

Subject: + score-remove-select-have_generic_hardirqs-again.patch added to -mm tree
To: geert@linux-m68k.org,lennox.wu@gmail.com,liqin.linux@gmail.com,schwidefsky@de.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 12:39:37 -0800


The patch titled
     Subject: Score: remove "select HAVE_GENERIC_HARDIRQS" again
has been added to the -mm tree.  Its filename is
     score-remove-select-have_generic_hardirqs-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-remove-select-have_generic_hardirqs-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-remove-select-have_generic_hardirqs-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Score: remove "select HAVE_GENERIC_HARDIRQS" again

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
score-remove-select-have_generic_hardirqs-again.patch
arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch
mm-make-setpage_address-static-inline-if-want_page_virtual.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

