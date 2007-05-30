From: akpm@linux-foundation.org
Subject: + missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch added to -mm tree
Date: Wed, 30 May 2007 10:35:04 -0700
Message-ID: <200705301735.l4UHZ5QO000714@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbXE3Rfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 13:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vonbrand@inf.utfsm.cl


The patch titled
     Missing #include <linux/mm.h> in drivers/sbus/char/flash.c
has been added to the -mm tree.  Its filename is
     missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Missing #include <linux/mm.h> in drivers/sbus/char/flash.c
From: Horst H. von Brand <vonbrand@inf.utfsm.cl>

drivers/sbus/char/flash.c does use macros VM_READ and such, needs to include
linux/mm.h.

Signed-off-by: Horst H. von Brand <vonbrand@inf.utfsm.cl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/flash.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/sbus/char/flash.c~missing-include-linux-mmh-in-drivers-sbus-char-flashc drivers/sbus/char/flash.c
--- a/drivers/sbus/char/flash.c~missing-include-linux-mmh-in-drivers-sbus-char-flashc
+++ a/drivers/sbus/char/flash.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from vonbrand@inf.utfsm.cl are
