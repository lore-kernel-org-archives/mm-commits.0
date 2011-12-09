From: akpm@linux-foundation.org
Subject: + maintainers-update-various-arm-f-patterns.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:11 -0800
Message-ID: <201112092343.pB9NhBPU028105@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45993 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1LIXnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:15 -0500
Received: by eekc14 with SMTP id c14so77737eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, linux@arm.linux.org.uk


The patch titled
     Subject: MAINTAINERS: update various arm F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-various-arm-f-patterns.patch

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
Subject: MAINTAINERS: update various arm F: patterns

Track renames and missing or deleted files.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN MAINTAINERS~maintainers-update-various-arm-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-various-arm-f-patterns
+++ a/MAINTAINERS
@@ -921,7 +921,6 @@ M:	Lennert Buytenhek <kernel@wantstofly.
 M:	Nicolas Pitre <nico@fluxnic.net>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Odd Fixes
-F:	arch/arm/mach-loki/
 F:	arch/arm/mach-kirkwood/
 F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
@@ -1083,8 +1082,8 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	arch/arm/mach-s5pv210/mach-aquila.c
 F:	arch/arm/mach-s5pv210/mach-goni.c
-F:	arch/arm/mach-exynos4/mach-universal_c210.c
-F:	arch/arm/mach-exynos4/mach-nuri.c
+F:	arch/arm/mach-exynos/mach-universal_c210.c
+F:	arch/arm/mach-exynos/mach-nuri.c
 
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1112,7 +1111,6 @@ M:	Tomasz Stanislawski <t.stanislaws@sam
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-tv.c
 F:	drivers/media/video/s5p-tv/
 
 ARM/SHMOBILE ARM ARCHITECTURE
@@ -1154,7 +1152,6 @@ L:	linux-arm-kernel@lists.infradead.org 
 W:	http://www.mcuos.com
 S:	Maintained
 F:	arch/arm/mach-w90x900/
-F:	arch/arm/mach-nuc93x/
 F:	drivers/input/keyboard/w90p910_keypad.c
 F:	drivers/input/touchscreen/w90p910_ts.c
 F:	drivers/watchdog/nuc900_wdt.c
@@ -6244,9 +6241,7 @@ M:	Viresh Kumar <viresh.kumar@st.com>
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
-F:	arch/arm/mach-spear*/include/mach/clkdev.h
 F:	arch/arm/plat-spear/clock.c
-F:	arch/arm/plat-spear/include/plat/clkdev.h
 F:	arch/arm/plat-spear/include/plat/clock.h
 
 SPEAR PAD MULTIPLEXING SUPPORT
_
Subject: Subject: MAINTAINERS: update various arm F: patterns

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

