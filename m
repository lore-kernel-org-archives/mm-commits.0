From: akpm@linux-foundation.org
Subject: - video-add-spaces-on-either-side-of-the-case-operator.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:37 -0700
Message-ID: <200705090300.l4930bRt010588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032877AbXEIDAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     VIDEO: add spaces on either side of the case "..." operator
has been removed from the -mm tree.  Its filename was
     video-add-spaces-on-either-side-of-the-case-operator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VIDEO: add spaces on either side of the case "..." operator
From: "Robert P. J. Day" <rpjday@mindspring.com>

Following the programming advice laid down in the gcc manual, make
sure the case "..." operator has spaces on either side.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    4 ++--
 drivers/video/pxafb.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/modedb.c~video-add-spaces-on-either-side-of-the-case-operator drivers/video/modedb.c
--- a/drivers/video/modedb.c~video-add-spaces-on-either-side-of-the-case-operator
+++ a/drivers/video/modedb.c
@@ -395,7 +395,7 @@ static int my_atoi(const char *name)
 
     for (;; name++) {
 	switch (*name) {
-	    case '0'...'9':
+	    case '0' ... '9':
 		val = 10*val+(*name-'0');
 		break;
 	    default:
@@ -548,7 +548,7 @@ int fb_find_mode(struct fb_var_screeninf
 		    } else
 			goto done;
 		    break;
-		case '0'...'9':
+		case '0' ... '9':
 		    break;
 		case 'M':
 		    if (!yres_specified)
diff -puN drivers/video/pxafb.c~video-add-spaces-on-either-side-of-the-case-operator drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~video-add-spaces-on-either-side-of-the-case-operator
+++ a/drivers/video/pxafb.c
@@ -1203,7 +1203,7 @@ static int __init pxafb_parse_options(st
 					} else
 						goto done;
 					break;
-				case '0'...'9':
+				case '0' ... '9':
 					break;
 				default:
 					goto done;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
