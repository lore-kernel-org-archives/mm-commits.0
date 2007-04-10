From: akpm@linux-foundation.org
Subject: + video-add-spaces-on-either-side-of-the-case-operator.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:07:44 -0700
Message-ID: <200704102207.l3AM7n14018856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbXDJWHx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, adaplas@pol.net


The patch titled
     VIDEO: add spaces on either side of the case "..." operator
has been added to the -mm tree.  Its filename is
     video-add-spaces-on-either-side-of-the-case-operator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
