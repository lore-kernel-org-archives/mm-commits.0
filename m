From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-header_extent_size-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:53:53 -0700
Message-ID: <200710160453.l9G4rrZv009686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbXJPEy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix printk format warning
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-header_extent_size-fix.patch

This patch was dropped because it was folded into ecryptfs-remove-header_extent_size.patch

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

origin.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
