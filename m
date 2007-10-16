From: akpm@linux-foundation.org
Subject: - fbdev-update-documentation-fb-00-index.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:23 -0700
Message-ID: <200710162044.l9GKiNUF016141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbXJPVJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: Update Documentation/fb/00-INDEX
has been removed from the -mm tree.  Its filename was
     fbdev-update-documentation-fb-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: Update Documentation/fb/00-INDEX
From: Jesper Juhl <jesper.juhl@gmail.com>

An update to Documentation/fb/00-INDEX is long overdue.  This patch adds
entries for new files in the directory and removes entries for files that no
longer exist.  The files are now also sorted alphabetically.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/00-INDEX |   46 ++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff -puN Documentation/fb/00-INDEX~fbdev-update-documentation-fb-00-index Documentation/fb/00-INDEX
--- a/Documentation/fb/00-INDEX~fbdev-update-documentation-fb-00-index
+++ a/Documentation/fb/00-INDEX
@@ -5,21 +5,49 @@ please mail me.
 
 00-INDEX
 	- this file
+arkfb.txt
+	- info on the fbdev driver for ARK Logic chips.
+aty128fb.txt
+	- info on the ATI Rage128 frame buffer driver.
+cirrusfb.txt
+	- info on the driver for Cirrus Logic chipsets.
+cyblafb/
+	- directory with documentation files related to the cyblafb driver.
+deferred_io.txt
+	- an introduction to deferred IO.
+fbcon.txt
+	- intro to and usage guide for the framebuffer console (fbcon).
 framebuffer.txt
-	- introduction to frame buffer devices
+	- introduction to frame buffer devices.
+imacfb.txt
+	- info on the generic EFI platform driver for Intel based Macs.
+intel810.txt
+	- documentation for the Intel 810/815 framebuffer driver.
+intelfb.txt
+	- docs for Intel 830M/845G/852GM/855GM/865G/915G/945G fb driver.
 internals.txt
-	- quick overview of frame buffer device internals
+	- quick overview of frame buffer device internals.
+matroxfb.txt
+	- info on the Matrox framebuffer driver for Alpha, Intel and PPC.
 modedb.txt
-	- info on the video mode database
-aty128fb.txt
-	- info on the ATI Rage128 frame buffer driver
-clgenfb.txt
-	- info on the Cirrus Logic frame buffer driver
+	- info on the video mode database.
 matroxfb.txt
-	- info on the Matrox frame buffer driver
+	- info on the Matrox frame buffer driver.
 pvr2fb.txt
-	- info on the PowerVR 2 frame buffer driver
+	- info on the PowerVR 2 frame buffer driver.
+pxafb.txt
+	- info on the driver for the PXA25x LCD controller.
+s3fb.txt
+	- info on the fbdev driver for S3 Trio/Virge chips.
+sa1100fb.txt
+	- information about the driver for the SA-1100 LCD controller.
+sisfb.txt
+	- info on the framebuffer device driver for various SiS chips.
+sstfb.txt
+	- info on the frame buffer driver for 3dfx' Voodoo Graphics boards.
 tgafb.txt
 	- info on the TGA (DECChip 21030) frame buffer driver
 vesafb.txt
 	- info on the VESA frame buffer device
+vt8623fb.txt
+	- info on the fb driver for the graphics core in VIA VT8623 chipsets.
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
