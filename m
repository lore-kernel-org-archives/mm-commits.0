From: akpm@linux-foundation.org
Subject: - update-the-list-information-for-kexec-and-kdump.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:18 -0700
Message-ID: <200705090252.l492qI2u009558@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032211AbXEICwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Update the list information for kexec and kdump
has been removed from the -mm tree.  Its filename was
     update-the-list-information-for-kexec-and-kdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2030,7 +2030,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.linux-foundation.org
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -2080,7 +2080,7 @@ P:	Eric Biederman
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
use-menuconfig-objects-ipvs.patch
