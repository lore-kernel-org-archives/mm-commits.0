From: akpm@linux-foundation.org
Subject: [merged] docs-fix-various-documentation-paths-in-header-files.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:33:51 -0700
Message-ID: <200909241933.n8OJXpUQ029647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbZIXTeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     docs: fix various Documentation/ paths in header files
has been removed from the -mm tree.  Its filename was
     docs-fix-various-documentation-paths-in-header-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: fix various Documentation/ paths in header files
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix various Documentation/ paths in include/linux/.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/configfs.h   |    4 ++--
 include/linux/debugfs.h    |    2 +-
 include/linux/relay.h      |    2 +-
 include/linux/tracepoint.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/configfs.h~docs-fix-various-documentation-paths-in-header-files include/linux/configfs.h
--- a/include/linux/configfs.h~docs-fix-various-documentation-paths-in-header-files
+++ a/include/linux/configfs.h
@@ -27,8 +27,8 @@
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
- * Please read Documentation/filesystems/configfs.txt before using the
- * configfs interface, ESPECIALLY the parts about reference counts and
+ * Please read Documentation/filesystems/configfs/configfs.txt before using
+ * the configfs interface, ESPECIALLY the parts about reference counts and
  * item destructors.
  */
 
diff -puN include/linux/debugfs.h~docs-fix-various-documentation-paths-in-header-files include/linux/debugfs.h
--- a/include/linux/debugfs.h~docs-fix-various-documentation-paths-in-header-files
+++ a/include/linux/debugfs.h
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/kernel-api for more details.
+ *  See Documentation/DocBook/filesystems for more details.
  */
 
 #ifndef _DEBUGFS_H_
diff -puN include/linux/relay.h~docs-fix-various-documentation-paths-in-header-files include/linux/relay.h
--- a/include/linux/relay.h~docs-fix-various-documentation-paths-in-header-files
+++ a/include/linux/relay.h
@@ -140,7 +140,7 @@ struct rchan_callbacks
 	 * cause relay_open() to create a single global buffer rather
 	 * than the default set of per-cpu buffers.
 	 *
-	 * See Documentation/filesystems/relayfs.txt for more info.
+	 * See Documentation/filesystems/relay.txt for more info.
 	 */
 	struct dentry *(*create_buf_file)(const char *filename,
 					  struct dentry *parent,
diff -puN include/linux/tracepoint.h~docs-fix-various-documentation-paths-in-header-files include/linux/tracepoint.h
--- a/include/linux/tracepoint.h~docs-fix-various-documentation-paths-in-header-files
+++ a/include/linux/tracepoint.h
@@ -4,7 +4,7 @@
 /*
  * Kernel Tracepoint API.
  *
- * See Documentation/tracepoint.txt.
+ * See Documentation/trace/tracepoints.txt.
  *
  * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

