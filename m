From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:37 -0700
Message-ID: <200906171838.n5HIcbkN004634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760964AbZFQSjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add file pattern to CISCO FCOE HBA DRIVER
has been removed from the -mm tree.  Its filename was
     maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add file pattern to CISCO FCOE HBA DRIVER
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-file-pattern-to-cisco-fcoe-hba-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-file-pattern-to-cisco-fcoe-hba-driver
+++ a/MAINTAINERS
@@ -1458,6 +1458,7 @@ P:	Joe Eykholt
 M:	jeykholt@cisco.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	drivers/scsi/fnic/
 
 CODA FILE SYSTEM
 P:	Jan Harkes
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

