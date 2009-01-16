From: akpm@linux-foundation.org
Subject: [merged] sysrq-documentation-remove-the-redundant-updated-date.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:28 -0800
Message-ID: <200901161916.n0GJGS6d024942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757351AbZAPTTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysrq documentation: remove the redundant updated date
has been removed from the -mm tree.  Its filename was
     sysrq-documentation-remove-the-redundant-updated-date.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq documentation: remove the redundant updated date
From: Andy Whitcroft <apw@canonical.com>

git is maintaining the last update time much more accuratly than the
internal update time.  Remove it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/sysrq.txt~sysrq-documentation-remove-the-redundant-updated-date Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-documentation-remove-the-redundant-updated-date
+++ a/Documentation/sysrq.txt
@@ -1,6 +1,5 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-AUG-04
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

