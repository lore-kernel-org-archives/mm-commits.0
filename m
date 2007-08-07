From: akpm@linux-foundation.org
Subject: + documentation-sysrq-description-of-h-slightly-inaccurate.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:09:36 -0700
Message-ID: <200708072209.l77M9a3X007301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964835AbXHGWJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Documentation: sysrq, description of 'h' slightly inaccurate
has been added to the -mm tree.  Its filename is
     documentation-sysrq-description-of-h-slightly-inaccurate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: sysrq, description of 'h' slightly inaccurate
From: Jesper Juhl <jesper.juhl@gmail.com>

In Documentation/sysrq.txt, the description of 'h' says that any key not
listed *above* will generate help.  That's obviously not true since all the
keys listed below 'h' will do what they are described to do, not display help.
 So change the text so that it says that any key not listed in the table will
generate help, which is what really happens.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/sysrq.txt~documentation-sysrq-description-of-h-slightly-inaccurate Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~documentation-sysrq-description-of-h-slightly-inaccurate
+++ a/Documentation/sysrq.txt
@@ -1,6 +1,6 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-MAR-14
+Last update: 2007-AUG-04
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -78,7 +78,7 @@ On all -  write a character to /proc/sys
 'g'	- Used by kgdb on ppc and sh platforms.
 
 'h'     - Will display help (actually any other key than those listed
-          above will display help. but 'h' is easy to remember :-)
+          here will display help. but 'h' is easy to remember :-)
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
documentation-sysrq-description-of-h-slightly-inaccurate.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
