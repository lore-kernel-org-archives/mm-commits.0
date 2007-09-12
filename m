From: akpm@linux-foundation.org
Subject: + add-a-00-index-file-to-documentation-sysctl.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:39:46 -0700
Message-ID: <200709120339.l8C3dkiO014483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbXILDkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, rdunlap@xenotime.net, rob@landley.net


The patch titled
     [resend] Add a 00-INDEX file to Documentation/sysctl/
has been added to the -mm tree.  Its filename is
     add-a-00-index-file-to-documentation-sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: [resend] Add a 00-INDEX file to Documentation/sysctl/
From: Jesper Juhl <jesper.juhl@gmail.com>

Add a 00-INDEX file to Documentation/sysctl/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN /dev/null Documentation/sysctl/00-INDEX
--- /dev/null
+++ a/Documentation/sysctl/00-INDEX
@@ -0,0 +1,16 @@
+00-INDEX
+	- this file.
+README
+	- general information about /proc/sys/ sysctl files.
+abi.txt
+	- documentation for /proc/sys/abi/*.
+ctl_unnumbered.txt
+	- explanation of why one should not add new binary sysctl numbers.
+fs.txt
+	- documentation for /proc/sys/fs/*.
+kernel.txt
+	- documentation for /proc/sys/kernel/*.
+sunrpc.txt
+	- documentation for /proc/sys/sunrpc/*.
+vm.txt
+	- documentation for /proc/sys/vm/*.
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
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
update-documentation-fb-00-index-add-new-files-remove-entries-for-deleted-ones.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
