From: akpm@linux-foundation.org
Subject: + maintainers-staging-tty-update-f-patterns.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:28 -0800
Message-ID: <201112092343.pB9NhTKQ028381@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45993 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1LIXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:31 -0500
Received: by mail-ee0-f74.google.com with SMTP id c14so77737eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, gregkh@suse.de


The patch titled
     Subject: MAINTAINERS: staging: tty: update F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-staging-tty-update-f-patterns.patch

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
Subject: MAINTAINERS: staging: tty: update F: patterns

commit 51c9d654c2d ("Staging: delete tty drivers") removed the files,
delete the sections too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN MAINTAINERS~maintainers-staging-tty-update-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-staging-tty-update-f-patterns
+++ a/MAINTAINERS
@@ -1905,12 +1905,6 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
-COMPUTONE INTELLIPORT MULTIPORT CARD
-W:	http://www.wittsend.com/computone.html
-S:	Orphan
-F:	Documentation/serial/computone.txt
-F:	drivers/staging/tty/ip2/
-
 CONEXANT ACCESSRUNNER USB DRIVER
 M:	Simon Arlott <cxacru@fire.lp0.eu>
 L:	accessrunner-general@lists.sourceforge.net
@@ -2214,15 +2208,6 @@ F:	drivers/md/dm*
 F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 
-DIGI INTL. EPCA DRIVER
-M:	"Digi International, Inc" <Eng.Linux@digi.com>
-L:	Eng.Linux@digi.com
-W:	http://www.digi.com
-S:	Orphan
-F:	Documentation/serial/digiepca.txt
-F:	drivers/staging/tty/epca*
-F:	drivers/staging/tty/digi*
-
 DIOLAN U2C-12 I2C DRIVER
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
 L:	linux-i2c@vger.kernel.org
@@ -5589,11 +5574,6 @@ M:	Maxim Levitsky <maximlevitsky@gmail.c
 S:	Maintained
 F:	drivers/memstick/host/r592.*
 
-RISCOM8 DRIVER
-S:	Orphan
-F:	Documentation/serial/riscom8.txt
-F:	drivers/staging/tty/riscom8*
-
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
@@ -6256,11 +6236,6 @@ F:	arch/arm/mach-spear3xx/spear3*0_evb.c
 F:	arch/arm/mach-spear6xx/spear600.c
 F:	arch/arm/mach-spear6xx/spear600_evb.c
 
-SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
-S:	Orphan
-F:	Documentation/serial/specialix.txt
-F:	drivers/staging/tty/specialix*
-
 SPI SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
_
Subject: Subject: MAINTAINERS: staging: tty: update F: patterns

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

