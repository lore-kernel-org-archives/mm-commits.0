From: akpm@linux-foundation.org
Subject: + maintainers-remove-unused-nbdh-pattern.patch added to -mm tree
Date: Tue, 05 May 2015 13:55:34 -0700
Message-ID: <55492e46.ESzlY4ajBaR5raiI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031499AbbEEUzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 16:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mpa@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unused nbd.h pattern
has been added to the -mm tree.  Its filename is
     maintainers-remove-unused-nbdh-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-unused-nbdh-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-unused-nbdh-pattern.patch

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
Subject: MAINTAINERS: remove unused nbd.h pattern

commit 13e71d69cc74 ("nbd: Remove kernel internal header") deleted the
file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unused-nbdh-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unused-nbdh-pattern
+++ a/MAINTAINERS
@@ -6764,7 +6764,6 @@ L:	nbd-general@lists.sourceforge.net
 T:	git git://git.pengutronix.de/git/mpa/linux-nbd.git
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
-F:	include/linux/nbd.h
 F:	include/uapi/linux/nbd.h
 
 NETWORK DROP MONITOR
_

Patches currently in -mm which might be from joe@perches.com are

compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
kasan-show-gcc-version-requirements-in-kconfig-and-documentation.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

