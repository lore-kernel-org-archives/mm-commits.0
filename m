From: akpm@linux-foundation.org
Subject: + maintainers-update-brcm-gpio-filename-pattern.patch added to
 -mm tree
Date: Tue, 05 May 2015 13:55:32 -0700
Message-ID: <55492e44.XE/Ca97bXaPlJdfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbbEEUzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 16:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sbranden@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update brcm gpio filename pattern
has been added to the -mm tree.  Its filename is
     maintainers-update-brcm-gpio-filename-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-brcm-gp=
io-filename-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-brcm-gp=
io-filename-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update brcm gpio filename pattern

commit 23a71fd616bf ("dt-bindings: brcm: rationalize Broadcom
documentation naming") renamed the file, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-brcm-gpio-filename-pattern MAI=
NTAINERS
--- a/MAINTAINERS~maintainers-update-brcm-gpio-filename-pattern
+++ a/MAINTAINERS
@@ -2232,7 +2232,7 @@ M:	Ray Jui <rjui@broadcom.com>
 L:	bcm-kernel-feedback-list@broadcom.com
 S:	Supported
 F:	drivers/gpio/gpio-bcm-kona.c
-F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
+F:	Documentation/devicetree/bindings/gpio/brcm,kona-gpio.txt
=20
 BROADCOM SPECIFIC AMBA DRIVER (BCMA)
 M:	Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
