From: akpm@linux-foundation.org
Subject: [merged] hpilo-increment-version.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:18 -0800
Message-ID: <200901301914.n0UJEIue027217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbZA3TOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.altobelli@hp.com, mm-commits@vger.kernel.org


The patch titled
     hpilo: increment version
has been removed from the -mm tree.  Its filename was
     hpilo-increment-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpilo: increment version
From: David Altobelli <david.altobelli@hp.com>

Bump hpilo module version to indicate that the open/close bug is fixed.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.c~hpilo-increment-version drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-increment-version
+++ a/drivers/misc/hpilo.c
@@ -758,7 +758,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.05");
+MODULE_VERSION("0.06");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
_

Patches currently in -mm which might be from david.altobelli@hp.com are

origin.patch
hpilo-open-close-fix.patch

