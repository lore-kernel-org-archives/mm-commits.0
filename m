From: akpm@osdl.org
Subject: - fuse-fix-typo.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:29 -0800
Message-ID: <200701020725.l027PTLl013053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919AbXABH0A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:26:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, miklos@szeredi.hu, t.hisch@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fuse: fix typo
has been removed from the -mm tree.  Its filename was
     fuse-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix typo
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/fuse.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/fuse.txt~fuse-fix-typo Documentation/filesystems/fuse.txt
--- a/Documentation/filesystems/fuse.txt~fuse-fix-typo
+++ a/Documentation/filesystems/fuse.txt
@@ -94,8 +94,8 @@ Mount options
   filesystem is free to implement it's access policy or leave it to
   the underlying file access mechanism (e.g. in case of network
   filesystems).  This option enables permission checking, restricting
-  access based on file mode.  This is option is usually useful
-  together with the 'allow_other' mount option.
+  access based on file mode.  It is usually useful together with the
+  'allow_other' mount option.
 
 'allow_other'
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
