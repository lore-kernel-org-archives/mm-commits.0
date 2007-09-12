From: akpm@linux-foundation.org
Subject: + mxser-fix-compiler-warning-when-building-withoug-config_pci.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:21:00 -0700
Message-ID: <200709120321.l8C3L0vG013859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbXILDVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     mxser: fix compiler warning when building withoug CONFIG_PCI
has been added to the -mm tree.  Its filename is
     mxser-fix-compiler-warning-when-building-withoug-config_pci.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser: fix compiler warning when building withoug CONFIG_PCI
From: Jesper Juhl <jesper.juhl@gmail.com>

drivers/char/mxser.c:386: warning: 'mxser_get_PCI_conf' declared 'static' but never defined

when building without CONFIG_PCI.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci
+++ a/drivers/char/mxser.c
@@ -383,7 +383,6 @@ static int mxser_init(void);
 
 /* static void   mxser_poll(unsigned long); */
 static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
-static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
 static void mxser_do_softint(struct work_struct *);
 static int mxser_open(struct tty_struct *, struct file *);
 static void mxser_close(struct tty_struct *, struct file *);
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
