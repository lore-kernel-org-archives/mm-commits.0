From: akpm@linux-foundation.org
Subject: - missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:07:12 -0700
Message-ID: <200706010707.l5177B6S004767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095AbXFAHHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vonbrand@inf.utfsm.cl, mm-commits@vger.kernel.org


The patch titled
     Missing #include <linux/mm.h> in drivers/sbus/char/flash.c
has been removed from the -mm tree.  Its filename was
     missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
