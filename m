From: akpm@linux-foundation.org
Subject: + docs-fix-various-documentation-paths-in-header-files.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:44:54 -0700
Message-ID: <200909132344.n8DNisvw026721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbZIMXpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jj@chaosbits.net


The patch titled
     docs: fix various Documentation/ paths in header files
has been added to the -mm tree.  Its filename is
     docs-fix-various-documentation-paths-in-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
 include/linux/marker.h     |    2 +-
 include/linux/relay.h      |    2 +-
 include/linux/tracepoint.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

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
diff -puN include/linux/marker.h~docs-fix-various-documentation-paths-in-header-files include/linux/marker.h
--- a/include/linux/marker.h~docs-fix-various-documentation-paths-in-header-files
+++ a/include/linux/marker.h
@@ -4,7 +4,7 @@
 /*
  * Code markup for dynamic and static tracing.
  *
- * See Documentation/marker.txt.
+ * See Documentation/markers.txt.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
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

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

