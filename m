From: akpm@linux-foundation.org
Subject: + maintainers-update-tulip-f-patterns.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:21 -0800
Message-ID: <201112092343.pB9NhLwK013518@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60383 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1LIXnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:25 -0500
Received: by mail-ey0-f202.google.com with SMTP id d1so22824eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net, davies@maniac.ultranet.com, grundler@parisc-linux.org, jeffrey.t.kirsher@intel.com, tori@unhappy.mine.nu


The patch titled
     Subject: MAINTAINERS: update tulip F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-tulip-f-patterns.patch

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
Subject: MAINTAINERS: update tulip F: patterns

commit a88394cfb58 ("ewrk3/tulip: Move the DEC - Tulip drivers") moved the
files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Tobias Ringstrom <tori@unhappy.mine.nu>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: David Davies <davies@maniac.ultranet.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-tulip-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tulip-f-patterns
+++ a/MAINTAINERS
@@ -2125,7 +2125,7 @@ DAVICOM FAST ETHERNET (DMFE) NETWORK DRI
 L:	netdev@vger.kernel.org
 S:	Orphan
 F:	Documentation/networking/dmfe.txt
-F:	drivers/net/ethernet/tulip/dmfe.c
+F:	drivers/net/ethernet/dec/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
 M:	Kurt Garloff <garloff@suse.de>
@@ -6719,7 +6719,7 @@ TULIP NETWORK DRIVERS
 M:	Grant Grundler <grundler@parisc-linux.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/tulip/
+F:	drivers/net/ethernet/dec/tulip/
 
 TUN/TAP driver
 M:	Maxim Krasnyansky <maxk@qualcomm.com>
_
Subject: Subject: MAINTAINERS: update tulip F: patterns

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

