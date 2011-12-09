From: akpm@linux-foundation.org
Subject: + maintainers-spi-update-f-patterns.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:38 -0800
Message-ID: <201112092343.pB9NhdbO004663@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45993 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1LIXnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:41 -0500
Received: by mail-ee0-f74.google.com with SMTP id c14so77737eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, grant.likely@secretlab.ca


The patch titled
     Subject: MAINTAINERS: spi: update F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-spi-update-f-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: spi: update F: patterns

commit ca632f55669 ("spi: reorganize drivers") renamed the files, update
the F: patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-spi-update-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-spi-update-f-patterns
+++ a/MAINTAINERS
@@ -1153,7 +1153,7 @@ F:	drivers/watchdog/nuc900_wdt.c
 F:	drivers/net/ethernet/nuvoton/w90p910_ether.c
 F:	drivers/mtd/nand/nuc900_nand.c
 F:	drivers/rtc/rtc-nuc900.c
-F:	drivers/spi/spi_nuc900.c
+F:	drivers/spi/spi-nuc900.c
 F:	drivers/usb/host/ehci-w90x900.c
 F:	drivers/video/nuc900fb.c
 
@@ -1357,7 +1357,7 @@ F:	drivers/net/ethernet/cadence/
 ATMEL SPI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
-F:	drivers/spi/atmel_spi.*
+F:	drivers/spi/spi-atmel.*
 
 ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
@@ -5336,7 +5336,7 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
-F:	drivers/spi/pxa2xx*
+F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
_
Subject: Subject: MAINTAINERS: spi: update F: patterns

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch
get_maintainerspl-follow-renames-when-looking-up-commit-signers.patch
maintainers-update-various-arm-f-patterns.patch
maintainers-update-adp-gpio-f-patterns.patch
maintainers-update-bt8xx-gpio-f-patterns.patch
maintainers-update-marvell-ccic-f-patterns.patch
maintainers-update-mfd-f-patterns.patch
maintainers-update-sdhci-f-patterns.patch
maintainers-update-tulip-f-patterns.patch
maintainers-update-greth-f-patterns.patch
maintainers-update-encrypted-keys-f-patterns.patch
maintainers-staging-media-update-f-patterns.patch
maintainers-staging-tty-update-f-patterns.patch
maintainers-staging-westbridge-delete-section.patch
maintainers-serial-blackfin-update-f-pattern.patch
maintainers-brcm80211-update-f-pattern.patch
maintainers-delete-generic_serial-section.patch
maintainers-spi-update-f-patterns.patch
checkpatch-update-signature-might-be-better-as-warning.patch
checkpatch-prefer-__printf-not-__attribute__formatprintf.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch

