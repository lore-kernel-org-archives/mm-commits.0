From: akpm@linux-foundation.org
Subject: + maintainers-adi-buildroot-devel-is-moderated.patch added to -mm tree
Date: Wed, 14 May 2014 12:27:39 -0700
Message-ID: <5373c3ab.KTdvAbJ0C/W942i8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaENT1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 15:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at

Subject: + maintainers-adi-buildroot-devel-is-moderated.patch added to -mm tree
To: richard@nod.at
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 12:27:39 -0700


The patch titled
     Subject: MAINTAINERS: adi-buildroot-devel is moderated
has been added to the -mm tree.  Its filename is
     maintainers-adi-buildroot-devel-is-moderated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-adi-buildroot-devel-is-moderated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-adi-buildroot-devel-is-moderated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: MAINTAINERS: adi-buildroot-devel is moderated

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN MAINTAINERS~maintainers-adi-buildroot-devel-is-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-adi-buildroot-devel-is-moderated
+++ a/MAINTAINERS
@@ -654,7 +654,7 @@ F:	sound/soc/codecs/ssm*
 F:	sound/soc/codecs/sigmadsp.*
 
 ANALOG DEVICES INC ASOC DRIVERS
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
@@ -1771,54 +1771,54 @@ F:	include/uapi/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
 M:	Steven Miao <realmz6@gmail.com>
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 T:	git git://git.code.sf.net/p/adi-linux/code
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/net/ethernet/adi/
 
 BLACKFIN RTC DRIVER
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SDH DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/mmc/host/bfin_sdh.c
 
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/tty/serial/bfin_uart.c
 
 BLACKFIN WATCHDOG DRIVER
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLACKFIN MEDIA DRIVER
 M:	Scott Jiang <scott.jiang.linux@gmail.com>
-L:	adi-buildroot-devel@lists.sourceforge.net
+L:	adi-buildroot-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/media/platform/blackfin/
_

Patches currently in -mm which might be from richard@nod.at are

maintainers-adi-buildroot-devel-is-moderated.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
sysrq-rcu-ify-__handle_sysrq.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch

