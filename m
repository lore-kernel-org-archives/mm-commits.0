From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:29:21 -0700
Message-ID: <201006231929.o5NJTL62027049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab0FWT3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com


The patch titled
     drivers/video/backlight/s6e63m0.c: set permissions on gamma_table file to 0444
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

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
Subject: drivers/video/backlight/s6e63m0.c: set permissions on gamma_table file to 0444
From: Axel Lin <axel.lin@gmail.com>

gamma_table is not writable, so set permissions to 0444.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444 drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444
+++ a/drivers/video/backlight/s6e63m0.c
@@ -729,7 +729,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_
 
 	return strlen(buf);
 }
-static DEVICE_ATTR(gamma_table, 0644,
+static DEVICE_ATTR(gamma_table, 0444,
 		s6e63m0_sysfs_show_gamma_table, NULL);
 
 static int __init s6e63m0_probe(struct spi_device *spi)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
wmi-fix-memory-leak-in-parse_wdg.patch
acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch
hp-wmi-add-error-handling-for-hp_wmi_init.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

