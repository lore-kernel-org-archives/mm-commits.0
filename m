From: akpm@linux-foundation.org
Subject: - fix-filemapc-kernel-doc.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:41 -0700
Message-ID: <200707312355.l6VNtfxW029245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762141AbXHAARO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fix filemap.c kernel-doc
has been removed from the -mm tree.  Its filename was
     fix-filemapc-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix filemap.c kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning:
Warning(linux-2.6.23-rc1-mm1//mm/filemap.c:864): No description found for parameter 'ra'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~fix-filemapc-kernel-doc mm/filemap.c
--- a/mm/filemap.c~fix-filemapc-kernel-doc
+++ a/mm/filemap.c
@@ -843,7 +843,7 @@ static void shrink_readahead_size_eio(st
 /**
  * do_generic_mapping_read - generic file read routine
  * @mapping:	address_space to be read
- * @_ra:	file's readahead state
+ * @ra:		file's readahead state
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
