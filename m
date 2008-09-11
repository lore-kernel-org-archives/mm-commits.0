From: akpm@linux-foundation.org
Subject: + doc-typo-in-documentation-filesystems-nfsroottxt.patch added to -mm tree
Date: Thu, 11 Sep 2008 15:38:19 -0700
Message-ID: <200809112238.m8BMcJK4020086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbYIKWiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 18:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcdonald.shane@gmail.com


The patch titled
     doc: typo in Documentation/filesystems/nfsroot.txt
has been added to the -mm tree.  Its filename is
     doc-typo-in-documentation-filesystems-nfsroottxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

doc-typo-in-documentation-filesystems-nfsroottxt.patch

