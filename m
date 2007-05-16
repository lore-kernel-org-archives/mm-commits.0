From: akpm@linux-foundation.org
Subject: - mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch removed from -mm tree
Date: Tue, 15 May 2007 23:04:00 -0700
Message-ID: <200705160604.l4G640ad027488@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280AbXEPGGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 02:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc. fixes for readahead
has been removed from the -mm tree.  Its filename was
     mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch

This patch was dropped because it was folded into mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

------------------------------------------------------
Subject: doc. fixes for readahead
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mm/readahead.c & filemap.c kernel-doc warnings (goes with readahead
patch when it's submitted).

Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'mapping'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'ra'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'filp'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'offset'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'req_size'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/filemap.c:1394): No description found for parameter 'vma'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/filemap.c:1394): No description found for parameter 'fdata'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix mm/filemap.c
--- a/mm/filemap.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix
+++ a/mm/filemap.c
@@ -1335,7 +1335,8 @@ static int fastcall page_cache_read(stru
 
 /**
  * filemap_fault - read in file data for page fault handling
- * @data:	the applicable fault_data
+ * @vma:	user vma (not used)
+ * @fdata:	the applicable fault_data
  *
  * filemap_fault() is invoked via the vma operations vector for a
  * mapped memory region to read in file data during a page fault.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
parport-mailing-list-is-subscribers-only.patch
docbook-make-kernel-locking-table-readable.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-kstrndup.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
profile-likely-unlikely-macros.patch
