From: akpm@linux-foundation.org
Subject: + maintainers-usb-se401-moved-to-staging-update-pattern.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:34:11 -0800
Message-ID: <201102242234.p1OMYBi1030766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756169Ab1BXWeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, hverkuil@xs4all.nl, mchehab@redhat.com, pe1rxq@amsat.org


The patch titled
     MAINTAINERS: uSB SE401 moved to staging, update pattern
has been added to the -mm tree.  Its filename is
     maintainers-usb-se401-moved-to-staging-update-pattern.patch

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
Subject: MAINTAINERS: uSB SE401 moved to staging, update pattern
From: Joe Perches <joe@perches.com>

And set the status to Orphan.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeroen Vreeken <pe1rxq@amsat.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-usb-se401-moved-to-staging-update-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-usb-se401-moved-to-staging-update-pattern
+++ a/MAINTAINERS
@@ -6427,12 +6427,11 @@ S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
-M:	Jeroen Vreeken <pe1rxq@amsat.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Maintained
+S:	Orphan
 F:	Documentation/video4linux/se401.txt
-F:	drivers/media/video/se401.*
+F:	drivers/staging/se401/
 
 USB SERIAL BELKIN F5U103 DRIVER
 M:	William Greathouse <wgreathouse@smva.com>
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

