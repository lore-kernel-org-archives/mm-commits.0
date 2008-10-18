From: akpm@linux-foundation.org
Subject: - doc-typo-in-documentation-filesystems-nfsroottxt.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:53 -0700
Message-ID: <200810182311.m9INBrQf027812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYJRXL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcdonald.shane@gmail.com, mm-commits@vger.kernel.org


The patch titled
     doc: typo in Documentation/filesystems/nfsroot.txt
has been removed from the -mm tree.  Its filename was
     doc-typo-in-documentation-filesystems-nfsroottxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: typo in Documentation/filesystems/nfsroot.txt
From: Shane McDonald <mcdonald.shane@gmail.com>

Add a missing word to the explanation of the purpose of the zdisk and
bzdisk make targets.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nfsroot.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/nfsroot.txt~doc-typo-in-documentation-filesystems-nfsroottxt Documentation/filesystems/nfsroot.txt
--- a/Documentation/filesystems/nfsroot.txt~doc-typo-in-documentation-filesystems-nfsroottxt
+++ a/Documentation/filesystems/nfsroot.txt
@@ -169,7 +169,7 @@ They depend on various facilities being 
 3.1)  Booting from a floppy using syslinux
 
 	When building kernels, an easy way to create a boot floppy that uses
-	syslinux is to use the zdisk or bzdisk make targets which use
+	syslinux is to use the zdisk or bzdisk make targets which use zimage
       	and bzimage images respectively. Both targets accept the
      	FDARGS parameter which can be used to set the kernel command line.
 
_

Patches currently in -mm which might be from mcdonald.shane@gmail.com are

origin.patch

