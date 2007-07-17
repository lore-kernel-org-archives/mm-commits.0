From: akpm@linux-foundation.org
Subject: - char-kconfig-mxser_new-remove-experimental-comment.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:32 -0700
Message-ID: <200707172306.l6HN6WPF012024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760751AbXGQXPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: Kconfig, mxser_new: remove experimental comment
has been removed from the -mm tree.  Its filename was
     char-kconfig-mxser_new-remove-experimental-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: Kconfig, mxser_new: remove experimental comment
From: Jiri Slaby <jirislaby@gmail.com>

Kconfig, mxser_new: remove experimental comment

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/Kconfig~char-kconfig-mxser_new-remove-experimental-comment drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-kconfig-mxser_new-remove-experimental-comment
+++ a/drivers/char/Kconfig
@@ -213,8 +213,6 @@ config MOXA_SMARTIO_NEW
 	  This is upgraded (1.9.1) driver from original Moxa drivers with
 	  changes finally resulting in PCI probing.
 
-	  Use at your own risk.
-
 	  This driver can also be built as a module. The module will be called
 	  mxser_new. If you want to do that, say M here.
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
