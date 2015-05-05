From: akpm@linux-foundation.org
Subject: +
 maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch added
 to -mm tree
Date: Tue, 05 May 2015 13:55:28 -0700
Message-ID: <55492e40.Tj5XZP/DDckYpOq3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031474AbbEEUz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 16:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cernekee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove section BROADCOM BCM33XX MIPS ARCHITECTURE
has been added to the -mm tree.  Its filename is
     maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch

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
Subject: MAINTAINERS: remove section BROADCOM BCM33XX MIPS ARCHITECTURE

commit 5f2d44591fb3 ("MIPS: bcm3384: Rename "bcm3384" target to "bmips"")
renamed the files and integrated them into an existing section.

Remove the section.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 --------
 1 file changed, 8 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-broadcom-bcm33xx-mips-architecture MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-broadcom-bcm33xx-mips-architecture
+++ a/MAINTAINERS
@@ -2137,14 +2137,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 N:	bcm2835
 
-BROADCOM BCM33XX MIPS ARCHITECTURE
-M:	Kevin Cernekee <cernekee@gmail.com>
-L:	linux-mips@linux-mips.org
-S:	Maintained
-F:	arch/mips/bcm3384/*
-F:	arch/mips/include/asm/mach-bcm3384/*
-F:	arch/mips/kernel/*bmips*
-
 BROADCOM BCM5301X ARM ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	linux-arm-kernel@lists.infradead.org
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

