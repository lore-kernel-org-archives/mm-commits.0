From: akpm@linux-foundation.org
Subject: + maintainers-move-jens-osterkamp-to-credits.patch added to -mm
 tree
Date: Thu, 21 May 2015 14:24:50 -0700
Message-ID: <555e4d22.OaEoNeOsoTne/nZ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbEUVYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 17:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, benh@kernel.crashing.org, jens@linux.vnet.ibm.com, kou.ishizaki@toshiba.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: move Jens Osterkamp to CREDITS
has been added to the -mm tree.  Its filename is
     maintainers-move-jens-osterkamp-to-credits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-move-jens-osterkamp-to-credits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-move-jens-osterkamp-to-credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -9336,7 +9336,6 @@ F:	include/uapi/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
-M:	Jens Osterkamp <jens@de.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/spider_net.txt
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-capabilities-pattern.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

