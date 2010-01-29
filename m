From: akpm@linux-foundation.org
Subject: [merged] serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:56 -0800
Message-ID: <201001292016.o0TKGuHT003270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab0A2URf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, sonic.zhang@analog.com, mm-commits@vger.kernel.org


The patch titled
     serial: bfin_5xx: pull in linux/io.h for ioremap prototypes
has been removed from the -mm tree.  Its filename was
     serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch
mmc-bfin_sdh-drop-redundant-mmc-depend-string.patch
mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

