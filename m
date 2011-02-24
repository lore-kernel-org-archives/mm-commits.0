From: akpm@linux-foundation.org
Subject: + maintainers-remove-sharp-lh7a40x-section.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:34:05 -0800
Message-ID: <201102242234.p1OMY5Pa030756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756524Ab1BXWeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:34:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, rmk+kernel@arm.linux.org.uk


The patch titled
     MAINTAINERS: remove SHARP LH7A40X section
has been added to the -mm tree.  Its filename is
     maintainers-remove-sharp-lh7a40x-section.patch

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
Subject: MAINTAINERS: remove SHARP LH7A40X section
From: Joe Perches <joe@perches.com>

commit 82e6923e186 ("ARM: lh7a40x: remove unmaintained platform support")
removed support, remove it from MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-sharp-lh7a40x-section MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-sharp-lh7a40x-section
+++ a/MAINTAINERS
@@ -5615,17 +5615,6 @@ M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
-SHARP LH SUPPORT (LH7952X & LH7A40X)
-M:	Marc Singer <elf@buici.com>
-W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
-F:	arch/arm/mach-lh7a40x/
-F:	drivers/tty/serial/serial_lh7a40x.c
-F:	drivers/usb/gadget/lh7a40*
-F:	drivers/usb/host/ohci-lh7a40*
-
 SHM-SIGNAL LIBRARY
 M:	Gregory Haskins <ghaskins@novell.com>
 S:	Maintained
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

