From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-tp_printk-to-list-of-logging-functions.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:24:45 -0800
Message-ID: <20171120212445.Y9Cf5yJu1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdKTVYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, songliubraving@fb.com


The patch titled
     Subject: checkpatch: add TP_printk to list of logging functions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-tp_printk-to-list-of-logging-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add TP_printk to list of logging functions

So the line length check can be bypassed by its callers.

Link: http://lkml.kernel.org/r/7de542c08a6e79f2ebe7c1416c9f403c23fdcc09.1508282823.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Song Liu <songliubraving@fb.com>
Tested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions
+++ a/scripts/checkpatch.pl
@@ -454,6 +454,7 @@ our $zero_initializer = qr{(?:(?:0[xX])?
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	TP_printk|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+|
_

Patches currently in -mm which might be from joe@perches.com are


