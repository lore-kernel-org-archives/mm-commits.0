From: akpm@linux-foundation.org
Subject: [merged] maintainers-brcm80211-update-f-pattern.patch removed from -mm tree
Date: Mon, 19 Dec 2011 13:28:36 -0800
Message-ID: <20111219212837.1F543200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49309 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab1LSV2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 16:28:39 -0500
Received: by mail-ee0-f74.google.com with SMTP id c1so190513eek.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 13:28:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, arend@broadcom.com, gregkh@suse.de, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: brcm80211: update F: pattern
has been removed from the -mm tree.  Its filename was
     maintainers-brcm80211-update-f-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: brcm80211: update F: pattern

commit fc2d6e573be ("staging: brcm80211: remove brcm80211 driver from the
staging tree") moved the files, update the F: pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-brcm80211-update-f-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-brcm80211-update-f-pattern
+++ a/MAINTAINERS
@@ -1592,7 +1592,7 @@ M:	Franky (Zhenhui) Lin <frankyl@broadco
 M:	Kan Yan	<kanyan@broadcom.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
-F:	drivers/staging/brcm80211/
+F:	drivers/net/wireless/brcm80211/
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
 M:	Bhanu Prakash Gollapudi <bprakash@broadcom.com>
_

Patches currently in -mm which might be from joe@perches.com are

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
maintainers-serial-blackfin-update-f-pattern.patch
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

