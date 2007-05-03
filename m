From: akpm@linux-foundation.org
Subject: + update-the-list-information-for-kexec-and-kdump.patch added to -mm tree
Date: Wed, 02 May 2007 21:28:50 -0700
Message-ID: <200705030428.l434SoJC004722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767377AbXECE3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, ebiederm@xmission.com


The patch titled
     Update the list information for kexec and kdump
has been added to the -mm tree.  Its filename is
     update-the-list-information-for-kexec-and-kdump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update the list information for kexec and kdump
From: Simon Horman <horms@verge.net.au>

There is a new list for kexec/kdump discussion.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~update-the-list-information-for-kexec-and-kdump MAINTAINERS
--- a/MAINTAINERS~update-the-list-information-for-kexec-and-kdump
+++ a/MAINTAINERS
@@ -2018,7 +2018,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.linux-foundation.org
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -2068,7 +2068,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.linux-foundation.org
+L:	kexec@lists.infradead.org
 S:	Maintained
 
 KPROBES
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
git-scsi-misc.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
update-the-list-information-for-kexec-and-kdump.patch
use-menuconfig-objects-ipvs.patch
