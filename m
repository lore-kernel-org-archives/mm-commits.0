From: akpm@linux-foundation.org
Subject: + maintainers-update-marvell-ccic-f-patterns.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:16 -0800
Message-ID: <201112092343.pB9NhGoZ013487@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:41395 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1LIXnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:19 -0500
Received: by mail-bw0-f74.google.com with SMTP id s6so74076bka.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, corbet@lwn.net, mchehab@redhat.com


The patch titled
     Subject: MAINTAINERS: update marvell ccic F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-marvell-ccic-f-patterns.patch

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
Subject: MAINTAINERS: update marvell ccic F: patterns

Commit f8fc729870ee ("[media] marvell-cam: Move cafe-ccic into its own
directory") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-marvell-ccic-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-marvell-ccic-f-patterns
+++ a/MAINTAINERS
@@ -1681,7 +1681,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
-F:	drivers/media/video/cafe_ccic*
+F:	drivers/media/video/marvell-ccic/
 
 CAIF NETWORK LAYER
 M:	Sjur Braendeland <sjur.brandeland@stericsson.com>
_
Subject: Subject: MAINTAINERS: update marvell ccic F: patterns

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

