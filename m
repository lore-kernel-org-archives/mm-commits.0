From: akpm@linux-foundation.org
Subject: + maintainers-update-brcm-dts-pattern.patch added to -mm tree
Date: Tue, 05 May 2015 13:55:30 -0700
Message-ID: <55492e42.BlPfNfDpaYeW+xel%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031482AbbEEUzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 16:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, abrestic@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update brcm dts pattern
has been added to the -mm tree.  Its filename is
     maintainers-update-brcm-dts-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-brcm-dts-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-brcm-dts-pattern.patch

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
Subject: MAINTAINERS: update brcm dts pattern

Commit 8c0b9ee8665c ("MIPS: Move device-trees into vendor
sub-directories") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-brcm-dts-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-brcm-dts-pattern
+++ a/MAINTAINERS
@@ -2180,7 +2180,7 @@ S:	Maintained
 F:	arch/mips/bmips/*
 F:	arch/mips/include/asm/mach-bmips/*
 F:	arch/mips/kernel/*bmips*
-F:	arch/mips/boot/dts/bcm*.dts*
+F:	arch/mips/boot/dts/brcm/bcm*.dts*
 F:	drivers/irqchip/irq-bcm7*
 F:	drivers/irqchip/irq-brcmstb*
 
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

