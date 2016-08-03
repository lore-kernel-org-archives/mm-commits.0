From: akpm@linux-foundation.org
Subject: [merged] printk-do-not-include-interrupth.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 11:11:59 -0700
Message-ID: <57a233ef.s3y+JW4Gq8Ij5evL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbcHCSN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: do not include interrupt.h
has been removed from the -mm tree.  Its filename was
     printk-do-not-include-interrupth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: do not include interrupt.h

A trivial cosmetic change: interrupt.h header is redundant since
'commit 6b898c07cb1d ("console: use might_sleep in console_lock")'.

Link: http://lkml.kernel.org/r/20160620132847.21930-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-do-not-include-interrupth kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-do-not-include-interrupth
+++ a/kernel/printk/printk.c
@@ -26,7 +26,6 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/interrupt.h>			/* For in_interrupt() */
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


