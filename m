From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unused-nbdh-pattern.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:48:09 -0700
Message-ID: <559adb79.LxjVMjm7djoGv+PQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbGFTsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mpa@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unused nbd.h pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unused-nbdh-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove unused nbd.h pattern

commit 13e71d69cc74 ("nbd: Remove kernel internal header") deleted the
file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unused-nbdh-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unused-nbdh-pattern
+++ a/MAINTAINERS
@@ -7018,7 +7018,6 @@ L:	nbd-general@lists.sourceforge.net
 T:	git git://git.pengutronix.de/git/mpa/linux-nbd.git
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
-F:	include/linux/nbd.h
 F:	include/uapi/linux/nbd.h
 
 NETWORK DROP MONITOR
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

