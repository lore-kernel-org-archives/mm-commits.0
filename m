From: akpm@linux-foundation.org
Subject: [merged] cramfs-mark-as-obsolete.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:48 -0800
Message-ID: <5283e394.W8ksPsZKfcNX+9cp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3KMUjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michael.opdenacker@free-electrons.com

Subject: [merged] cramfs-mark-as-obsolete.patch removed from -mm tree
To: michael.opdenacker@free-electrons.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:48 -0800


The patch titled
     Subject: cramfs: mark as obsolete
has been removed from the -mm tree.  Its filename was
     cramfs-mark-as-obsolete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: cramfs: mark as obsolete

Who needs cramfs when you have squashfs?  At least, we should warn people
that cramfs is obsolete.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS       |    2 +-
 fs/cramfs/Kconfig |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~cramfs-mark-as-obsolete MAINTAINERS
--- a/MAINTAINERS~cramfs-mark-as-obsolete
+++ a/MAINTAINERS
@@ -2373,7 +2373,7 @@ F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
-S:	Orphan
+S:	Orphan / Obsolete
 F:	Documentation/filesystems/cramfs.txt
 F:	fs/cramfs/
 
diff -puN fs/cramfs/Kconfig~cramfs-mark-as-obsolete fs/cramfs/Kconfig
--- a/fs/cramfs/Kconfig~cramfs-mark-as-obsolete
+++ a/fs/cramfs/Kconfig
@@ -1,5 +1,5 @@
 config CRAMFS
-	tristate "Compressed ROM file system support (cramfs)"
+	tristate "Compressed ROM file system support (cramfs) (OBSOLETE)"
 	depends on BLOCK
 	select ZLIB_INFLATE
 	help
@@ -16,4 +16,7 @@ config CRAMFS
 	  cramfs.  Note that the root file system (the one containing the
 	  directory /) cannot be compiled as a module.
 
+	  This filesystem is obsoleted by SquashFS, which is much better
+  	  in terms of performance and features.
+
 	  If unsure, say N.
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
linux-next.patch
scripts-tagssh-remove-obsolete-__devinit.patch

