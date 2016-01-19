From: akpm@linux-foundation.org
Subject: [merged] printk-formatstxt-remove-unimplemented-%pt.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:28 -0800
Message-ID: <569e9960.C7LT0YHyFsAgBUgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbcASUP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-formats.txt: remove unimplemented %pT
has been removed from the -mm tree.  Its filename was
     printk-formatstxt-remove-unimplemented-%pt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: printk-formats.txt: remove unimplemented %pT

%pT for task->comm has been proposed (several times, I think), but is not
actually implemented.  Remove it from printk-formats.txt and add it back
if/when it gets implemented.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN Documentation/printk-formats.txt~printk-formatstxt-remove-unimplemented-%pt Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~printk-formatstxt-remove-unimplemented-%pt
+++ a/Documentation/printk-formats.txt
@@ -306,15 +306,6 @@ Network device features:
 
 	Passed by reference.
 
-Command from struct task_struct
-
-	%pT	ls
-
-	For printing executable name excluding path from struct
-	task_struct.
-
-	Passed by reference.
