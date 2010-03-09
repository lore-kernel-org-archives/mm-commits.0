From: akpm@linux-foundation.org
Subject: [obsolete] xfs-needs-list_sort.patch removed from -mm tree
Date: Tue, 09 Mar 2010 14:32:19 -0800
Message-ID: <201003092232.o29MWKsS008973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab0CIWcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 17:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, aelder@sgi.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     xfs: needs LIST_SORT
has been removed from the -mm tree.  Its filename was
     xfs-needs-list_sort.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: needs LIST_SORT
From: Randy Dunlap <randy.dunlap@oracle.com>

xfs uses list_sort (library function), so it needs to select it.
Fixes these build errors:
fs/xfs/linux-2.6/xfs_buf.c:1918: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1996: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1950: undefined reference to `list_sort'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/xfs/Kconfig~xfs-needs-list_sort fs/xfs/Kconfig
--- a/fs/xfs/Kconfig~xfs-needs-list_sort
+++ a/fs/xfs/Kconfig
@@ -2,6 +2,7 @@ config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	select EXPORTFS
+	select LIST_SORT
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
xfs-needs-list_sort.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
scripts-kernel-doc-fix-empty-function-description-section.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch
documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

