From: akpm@linux-foundation.org
Subject: + maintainers-update-clkdev-location.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:33:49 -0800
Message-ID: <201102242233.p1OMXn3h030726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517Ab1BXWd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, plagnioj@jcrosoft.com, rmk+kernel@arm.linux.org.uk


The patch titled
     MAINTAINERS: update clkdev location
has been added to the -mm tree.  Its filename is
     maintainers-update-clkdev-location.patch

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
Subject: MAINTAINERS: update clkdev location
From: Joe Perches <joe@perches.com>

Commit 6d803ba736a ("ARM: 6483/1: arm & sh: factorised duplicated
clkdev.c") moved it to a separate directory.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-clkdev-location MAINTAINERS
--- a/MAINTAINERS~maintainers-update-clkdev-location
+++ a/MAINTAINERS
@@ -680,8 +680,8 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
+F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-quote-non-alphanumeric-email-addresses.patch
maintainers-update-adp5520-pattern.patch
maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch
maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch
maintainers-add-missing-after-hr-timers-f-tag.patch
maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch
maintainers-update-clkdev-location.patch
maintainers-update-media-path.patch
maintainers-update-hvc-file-patterns.patch
maintainers-remove-unused-clockeventsh.patch
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-update-tipc-patterns.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch

