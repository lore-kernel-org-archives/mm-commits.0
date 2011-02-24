From: akpm@linux-foundation.org
Subject: + maintainers-update-media-path.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:33:52 -0800
Message-ID: <201102242233.p1OMXqjG030729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756118Ab1BXWd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, harryxiyou@gmail.com, maximlevitsky@gmail.com


The patch titled
     MAINTAINERS: update media path
has been added to the -mm tree.  Its filename is
     maintainers-update-media-path.patch

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
Subject: MAINTAINERS: update media path
From: Joe Perches <joe@perches.com>

Commit 52b661449ae ("[media] rc: Rename remote controller type to rc_type
instead of ir_type") moved it around.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-media-path MAINTAINERS
--- a/MAINTAINERS~maintainers-update-media-path
+++ a/MAINTAINERS
@@ -2454,8 +2454,7 @@ F:	include/linux/cb710.h
 ENE KB2426 (ENE0100/ENE020XX) INFRARED RECEIVER
 M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
-F:	drivers/media/IR/ene_ir.c
-F:	drivers/media/IR/ene_ir.h
+F:	drivers/media/rc/ene_ir.*
 
 EPSON 1355 FRAMEBUFFER DRIVER
 M:	Christopher Hoover <ch@murgatroid.com>
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

