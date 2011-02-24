From: akpm@linux-foundation.org
Subject: + maintainers-remove-ieee1394-entry.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:33:58 -0800
Message-ID: <201102242233.p1OMXwMS030738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756524Ab1BXWeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, stefanr@s5r6.in-berlin.de


The patch titled
     MAINTAINERS: remove IEEE1394 entry
has been added to the -mm tree.  Its filename is
     maintainers-remove-ieee1394-entry.patch

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
Subject: MAINTAINERS: remove IEEE1394 entry
From: Joe Perches <joe@perches.com>

commit 66fa12c571d ("ieee1394: remove the old IEEE 1394 driver stack")

removed the code, remove the MAINTAINERS entry.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-ieee1394-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-ieee1394-entry
+++ a/MAINTAINERS
@@ -3149,15 +3149,6 @@ L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
-IEEE 1394 SUBSYSTEM
-M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-L:	linux1394-devel@lists.sourceforge.net
-W:	http://ieee1394.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Obsolete
-F:	Documentation/debugging-via-ohci1394.txt
-F:	drivers/ieee1394/
-
 IEEE 802.15.4 SUBSYSTEM
 M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 M:	Sergey Lapin <slapin@ossfans.org>
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

