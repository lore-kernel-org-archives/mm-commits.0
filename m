From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-header_extent_size-fix.patch added to -mm tree
Date: Tue, 25 Sep 2007 16:48:30 -0700
Message-ID: <200709252348.l8PNmUx3010408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758517AbXIYXsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 19:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix printk format warning
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-header_extent_size-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
fs/ecryptfs/crypto.c:1443: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-header_extent_size-fix fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-header_extent_size-fix
+++ a/fs/ecryptfs/crypto.c
@@ -1542,7 +1542,7 @@ static int parse_header_metadata(struct 
 		 * crypt_stat->num_header_extents_at_front)
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
 		rc = -EINVAL;
-		printk(KERN_WARNING "Invalid number of header extents: [%d]\n",
+		printk(KERN_WARNING "Invalid number of header extents: [%zd]\n",
 		       crypt_stat->num_header_extents_at_front);
 	}
 	return rc;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kgdb-fix-help-text.patch
kgdb-fix-docbook-and-kernel-doc-typos.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
ecryptfs-remove-header_extent_size-fix.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch
