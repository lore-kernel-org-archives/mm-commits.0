From: akpm@linux-foundation.org
Subject: - isofs-implement-dmode-option-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:48:34 -0800
Message-ID: <200802080848.m188mGOV016300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933260AbYBHIsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Add documentation for isofs dmode option
has been removed from the -mm tree.  Its filename was
     isofs-implement-dmode-option-fix.patch

This patch was dropped because it was folded into isofs-implement-dmode-option.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add documentation for isofs dmode option
From: Jan Kara <jack@suse.cz>

Add documentation to for new dmode option.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/isofs.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/filesystems/isofs.txt~isofs-implement-dmode-option-fix Documentation/filesystems/isofs.txt
--- a/Documentation/filesystems/isofs.txt~isofs-implement-dmode-option-fix
+++ a/Documentation/filesystems/isofs.txt
@@ -24,6 +24,7 @@ Mount options unique to the isofs filesy
   map=normal    Map non-Rock Ridge filenames to lower case
   map=acorn     As map=normal but also apply Acorn extensions if present
   mode=xxx      Sets the permissions on files to xxx
+  dmode=xxx     Sets the permissions on directories to xxx
   nojoliet      Ignore Joliet extensions if they are present.
   norock        Ignore Rock Ridge extensions if they are present.
   hide		Completely strip hidden files from the file system.
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
isofs-implement-dmode-option-fix.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
buffer_head-fix-private_list-handling.patch
quota-turn-quotas-off-when-remounting-read-only.patch
