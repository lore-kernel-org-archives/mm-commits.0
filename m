From: akpm@osdl.org
Subject: + fuse-fix-typo.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:26:25 -0800
Message-ID: <200612282326.kBSNQPS5016062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41254 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbWL1X05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, miklos@szeredi.hu, t.hisch@gmail.com


The patch titled
     fuse: fix typo
has been added to the -mm tree.  Its filename is
     fuse-fix-typo.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix typo
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/fuse.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

fuse-fix-typo.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch

