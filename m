From: akpm@linux-foundation.org
Subject: + maintainers-update-scx200-file-pattern.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:34:03 -0800
Message-ID: <201102242234.p1OMY3PJ030753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221Ab1BXWeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, tglx@linutronix.de


The patch titled
     MAINTAINERS: update SCX200 file pattern
has been added to the -mm tree.  Its filename is
     maintainers-update-scx200-file-pattern.patch

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
Subject: MAINTAINERS: update SCX200 file pattern
From: Joe Perches <joe@perches.com>

commit 3b3da9d25ae ("x86: Move scx200 to platform") moved it, convert the
pattern too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-scx200-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-scx200-file-pattern
+++ a/MAINTAINERS
@@ -5471,7 +5471,7 @@ SCx200 CPU SUPPORT
 M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Odd Fixes
 F:	Documentation/i2c/busses/scx200_acb
-F:	arch/x86/kernel/scx200_32.c
+F:	arch/x86/platform/scx200/
 F:	drivers/watchdog/scx200_wdt.c
 F:	drivers/i2c/busses/scx200*
 F:	drivers/mtd/maps/scx200_docflash.c
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

