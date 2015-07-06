From: akpm@linux-foundation.org
Subject: [merged] maintainers-move-jens-osterkamp-to-credits.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:11 -0700
Message-ID: <559adb7b.PbZYZ7GSKwzARSZv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbGFTsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, benh@kernel.crashing.org, jens@linux.vnet.ibm.com, kou.ishizaki@toshiba.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: move Jens Osterkamp to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-move-jens-osterkamp-to-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: move Jens Osterkamp to CREDITS

Jens' email address bounces, so move his name and entry to CREDITS.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Cc: Jens Osterkamp <jens@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN CREDITS~maintainers-move-jens-osterkamp-to-credits CREDITS
--- a/CREDITS~maintainers-move-jens-osterkamp-to-credits
+++ a/CREDITS
@@ -2740,6 +2740,10 @@ S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
 
+N: Jens Osterkamp
+E: jens@de.ibm.com
+D: Maintainer of Spidernet network driver for Cell
+
 N: Gadi Oxman
 E: gadio@netvision.net.il
 D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
diff -puN MAINTAINERS~maintainers-move-jens-osterkamp-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-move-jens-osterkamp-to-credits
+++ a/MAINTAINERS
@@ -9590,7 +9590,6 @@ F:	include/uapi/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
-M:	Jens Osterkamp <jens@de.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/spider_net.txt
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

