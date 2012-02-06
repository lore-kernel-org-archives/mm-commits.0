From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-partitions-block-f-patterns.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:08 -0800
Message-ID: <20120206203109.62BA9A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42747 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2BFUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:11 -0500
Received: by eekb15 with SMTP id b15so211736eek.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update partitions block F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-partitions-block-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update partitions block F: patterns

Commit 9be96f3fd101 ("move fs/partitions to block/") moved the files,
update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-partitions-block-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-partitions-block-f-patterns
+++ a/MAINTAINERS
@@ -4136,7 +4136,7 @@ L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
 F:	Documentation/ldm.txt
-F:	fs/partitions/ldm.*
+F:	block/partitions/ldm.*
 
 LogFS
 M:	Joern Engel <joern@logfs.org>
@@ -5633,7 +5633,7 @@ W:	http://www.ibm.com/developerworks/lin
 S:	Supported
 F:	arch/s390/
 F:	drivers/s390/
-F:	fs/partitions/ibm.c
+F:	block/partitions/ibm.c
 F:	Documentation/s390/
 F:	Documentation/DocBook/s390*
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

