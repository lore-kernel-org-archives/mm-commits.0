Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03958EB64DC
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjGIAaX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjGIAaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC141E4A
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AB6460B50
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0111C433C7;
        Sun,  9 Jul 2023 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862618;
        bh=WXuPqLo+zU8ROcpCDhohwHV1vZujqA5vNea+WonGAIk=;
        h=Date:To:From:Subject:From;
        b=sLTOw6sNoeHIX0bMcAtzQX9U/MP876GABWJkRiPeFIM+0fjuHIexmrlCZL2V867S2
         ObsQLzCUcJsRbp3dmqxydl4TmjyZrUqrz0SI+d5bqJ6r7MwGppMN9QUHj22oKTd7wZ
         PgwdxfzK9xYO+GF4DaGXBTQIkoXJnv+fcI9R7Aj8=
Date:   Sat, 08 Jul 2023 17:30:17 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        ghe@suse.com, gechangwei@live.cn, ailiop@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-update-ocfs2-devel-mailing-list-address.patch removed from -mm tree
Message-Id: <20230709003017.E0111C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: docs: update ocfs2-devel mailing list address
has been removed from the -mm tree.  Its filename was
     docs-update-ocfs2-devel-mailing-list-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Iliopoulos <ailiop@suse.com>
Subject: docs: update ocfs2-devel mailing list address
Date: Wed, 28 Jun 2023 03:34:37 +0200

The ocfs2-devel mailing list has been migrated to the kernel.org
infrastructure, update all related documentation pointers to reflect the
change.

Link: https://lkml.kernel.org/r/20230628013437.47030-3-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Acked-by: Joseph Qi <jiangqi903@gmail.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/o2cb       |    4 ++--
 Documentation/ABI/removed/o2cb        |    4 ++--
 Documentation/ABI/stable/o2cb         |    4 ++--
 Documentation/ABI/testing/sysfs-ocfs2 |   12 ++++++------
 Documentation/filesystems/dlmfs.rst   |    2 +-
 Documentation/filesystems/ocfs2.rst   |    2 +-
 fs/ocfs2/Kconfig                      |    6 +++---
 7 files changed, 17 insertions(+), 17 deletions(-)

--- a/Documentation/ABI/obsolete/o2cb~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/ABI/obsolete/o2cb
@@ -1,11 +1,11 @@
 What:		/sys/o2cb
 Date:		Dec 2005
 KernelVersion:	2.6.16
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:	Ocfs2-tools looks at 'interface-revision' for versioning
 		information. Each logmask/ file controls a set of debug prints
 		and can be written into with the strings "allow", "deny", or
 		"off". Reading the file returns the current state.
 		Was renamed to /sys/fs/u2cb/
 Users:		ocfs2-tools. It's sufficient to mail proposed changes to
-		ocfs2-devel@oss.oracle.com.
+		ocfs2-devel@lists.linux.dev.
--- a/Documentation/ABI/removed/o2cb~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/ABI/removed/o2cb
@@ -1,10 +1,10 @@
 What:		/sys/o2cb symlink
 Date:		May 2011
 KernelVersion:	3.0
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink is
 		removed when new versions of ocfs2-tools which know to look
 		in /sys/fs/o2cb are sufficiently prevalent. Don't code new
 		software to look here, it should try /sys/fs/o2cb instead.
 Users:		ocfs2-tools. It's sufficient to mail proposed changes to
-		ocfs2-devel@oss.oracle.com.
+		ocfs2-devel@lists.linux.dev.
--- a/Documentation/ABI/stable/o2cb~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/ABI/stable/o2cb
@@ -1,10 +1,10 @@
 What:		/sys/fs/o2cb/
 Date:		Dec 2005
 KernelVersion:	2.6.16
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:	Ocfs2-tools looks at 'interface-revision' for versioning
 		information. Each logmask/ file controls a set of debug prints
 		and can be written into with the strings "allow", "deny", or
 		"off". Reading the file returns the current state.
 Users:		ocfs2-tools. It's sufficient to mail proposed changes to
-		ocfs2-devel@oss.oracle.com.
+		ocfs2-devel@lists.linux.dev.
--- a/Documentation/ABI/testing/sysfs-ocfs2~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/ABI/testing/sysfs-ocfs2
@@ -1,13 +1,13 @@
 What:		/sys/fs/ocfs2/
 Date:		April 2008
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:
 		The /sys/fs/ocfs2 directory contains knobs used by the
 		ocfs2-tools to interact with the filesystem.
 
 What:		/sys/fs/ocfs2/max_locking_protocol
 Date:		April 2008
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:
 		The /sys/fs/ocfs2/max_locking_protocol file displays version
 		of ocfs2 locking supported by the filesystem.  This version
@@ -28,7 +28,7 @@ Description:
 
 What:		/sys/fs/ocfs2/loaded_cluster_plugins
 Date:		April 2008
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:
 		The /sys/fs/ocfs2/loaded_cluster_plugins file describes
 		the available plugins to support ocfs2 cluster operation.
@@ -48,7 +48,7 @@ Description:
 
 What:		/sys/fs/ocfs2/active_cluster_plugin
 Date:		April 2008
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:
 		The /sys/fs/ocfs2/active_cluster_plugin displays which
 		cluster plugin is currently in use by the filesystem.
@@ -65,7 +65,7 @@ Description:
 
 What:		/sys/fs/ocfs2/cluster_stack
 Date:		April 2008
-Contact:	ocfs2-devel@oss.oracle.com
+Contact:	ocfs2-devel@lists.linux.dev
 Description:
 		The /sys/fs/ocfs2/cluster_stack file contains the name
 		of current ocfs2 cluster stack.  This value is set by
@@ -86,4 +86,4 @@ Description:
 		stack return an error.
 
 Users:
-	ocfs2-tools <ocfs2-tools-devel@oss.oracle.com>
+	ocfs2-tools <ocfs2-tools-devel@lists.linux.dev>
--- a/Documentation/filesystems/dlmfs.rst~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/filesystems/dlmfs.rst
@@ -12,7 +12,7 @@ dlmfs is built with OCFS2 as it requires
 
 :Project web page:    http://ocfs2.wiki.kernel.org
 :Tools web page:      https://github.com/markfasheh/ocfs2-tools
-:OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
+:OCFS2 mailing lists: https://subspace.kernel.org/lists.linux.dev.html
 
 All code copyright 2005 Oracle except when otherwise noted.
 
--- a/Documentation/filesystems/ocfs2.rst~docs-update-ocfs2-devel-mailing-list-address
+++ a/Documentation/filesystems/ocfs2.rst
@@ -14,7 +14,7 @@ get "mount.ocfs2" and "ocfs2_hb_ctl".
 
 Project web page:    http://ocfs2.wiki.kernel.org
 Tools git tree:      https://github.com/markfasheh/ocfs2-tools
-OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
+OCFS2 mailing lists: https://subspace.kernel.org/lists.linux.dev.html
 
 All code copyright 2005 Oracle except when otherwise noted.
 
--- a/fs/ocfs2/Kconfig~docs-update-ocfs2-devel-mailing-list-address
+++ a/fs/ocfs2/Kconfig
@@ -17,9 +17,9 @@ config OCFS2_FS
 	  You'll want to install the ocfs2-tools package in order to at least
 	  get "mount.ocfs2".
 
-	  Project web page:    https://oss.oracle.com/projects/ocfs2
-	  Tools web page:      https://oss.oracle.com/projects/ocfs2-tools
-	  OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
+	  Project web page:    https://ocfs2.wiki.kernel.org/
+	  Tools web page:      https://github.com/markfasheh/ocfs2-tools
+	  OCFS2 mailing lists: https://subspace.kernel.org/lists.linux.dev.html
 
 	  For more information on OCFS2, see the file
 	  <file:Documentation/filesystems/ocfs2.rst>.
_

Patches currently in -mm which might be from ailiop@suse.com are


