From: akpm@linux-foundation.org
Subject: - checkpatch-update-maintainers-entry.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:48 -0800
Message-ID: <200901072216.n07MGmR7016472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052AbZAGWRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, jschopp@austin.ibm.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     checkpatch: update MAINTAINERS entry
has been removed from the -mm tree.  Its filename was
     checkpatch-update-maintainers-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: update MAINTAINERS entry
From: Andy Whitcroft <apw@shadowen.org>

Update my email address to my new work address.  Also, as per our recent
email conversation remove Randy and Joel from the maintainers list. 
Finally add LKML so that emails are recorded somewhere.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~checkpatch-update-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~checkpatch-update-maintainers-entry
+++ a/MAINTAINERS
@@ -1092,11 +1092,8 @@ S:	Maintained
 
 CHECKPATCH
 P:	Andy Whitcroft
-M:	apw@shadowen.org
-P:	Randy Dunlap
-M:	rdunlap@xenotime.net
-P:	Joel Schopp
-M:	jschopp@austin.ibm.com
+M:	apw@canonical.com
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 
 CISCO 10G ETHERNET DRIVER
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

