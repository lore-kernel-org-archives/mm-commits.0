From: akpm@linux-foundation.org
Subject: [merged] ide-qd65xx-samuel-has-moved.patch removed from -mm tree
Date: Wed, 04 Feb 2009 12:52:15 -0800
Message-ID: <200902042052.n14KqFSo027394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbZBDUxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 15:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide: qd65xx.[ch]: Samuel has moved
has been removed from the -mm tree.  Its filename was
     ide-qd65xx-samuel-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide: qd65xx.[ch]: Samuel has moved
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

The @fnac.net will be shut down within a couple of months, so fix my
email address.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_qdi.c |    2 +-
 drivers/ide/qd65xx.c   |    2 +-
 drivers/ide/qd65xx.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_qdi.c~ide-qd65xx-samuel-has-moved drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~ide-qd65xx-samuel-has-moved
+++ a/drivers/ata/pata_qdi.c
@@ -12,7 +12,7 @@
  *
  * Probe code based on drivers/ide/legacy/qd65xx.c
  * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- * Samuel Thibault <samuel.thibault@fnac.net>
+ * Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 #include <linux/kernel.h>
diff -puN drivers/ide/qd65xx.c~ide-qd65xx-samuel-has-moved drivers/ide/qd65xx.c
--- a/drivers/ide/qd65xx.c~ide-qd65xx-samuel-has-moved
+++ a/drivers/ide/qd65xx.c
@@ -16,7 +16,7 @@
 
 /*
  * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- * Samuel Thibault <samuel.thibault@fnac.net>
+ * Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 #include <linux/module.h>
diff -puN drivers/ide/qd65xx.h~ide-qd65xx-samuel-has-moved drivers/ide/qd65xx.h
--- a/drivers/ide/qd65xx.h~ide-qd65xx-samuel-has-moved
+++ a/drivers/ide/qd65xx.h
@@ -4,7 +4,7 @@
 
 /*
  * Authors:	Petr Soucek <petr@ryston.cz>
- * 		Samuel Thibault <samuel.thibault@fnac.net>
+ * 		Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 /* truncates a in [b,c] */
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch

