From: akpm@linux-foundation.org
Subject: + serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:11:34 -0800
Message-ID: <201001260011.o0Q0BY2j019467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab0AZALn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, sonic.zhang@analog.com


The patch titled
     serial: bfin_5xx: pull in linux/io.h for ioremap prototypes
has been added to the -mm tree.  Its filename is
     serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch

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
Subject: serial: bfin_5xx: pull in linux/io.h for ioremap prototypes
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes
+++ a/drivers/serial/bfin_5xx.c
@@ -14,6 +14,7 @@
 
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/sysrq.h>
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control.patch
serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch
serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch
serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch
mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch
mmc-bfin_sdh-drop-redundant-mmc-depend-string.patch
mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

