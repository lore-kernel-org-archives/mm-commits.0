From: akpm@linux-foundation.org
Subject: - fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:45 -0700
Message-ID: <200705031931.l43JVjrY018289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767893AbXECTeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, greg@kroah.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Fix wrong identifier name in Documentation/driver-model/devres.txt
has been removed from the -mm tree.  Its filename was
     fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix wrong identifier name in Documentation/driver-model/devres.txt
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Above and below we talk about my_midlayer_create_something, I assume that is
also meant here.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-model/devres.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/driver-model/devres.txt~fix-wrong-identifier-name-in-documentation-driver-model-devrestxt Documentation/driver-model/devres.txt
--- a/Documentation/driver-model/devres.txt~fix-wrong-identifier-name-in-documentation-driver-model-devrestxt
+++ a/Documentation/driver-model/devres.txt
@@ -182,7 +182,7 @@ For example, you can do something like t
 
 	...
 
-	devres_close_group(dev, my_midlayer_something);
+	devres_close_group(dev, my_midlayer_create_something);
 	return 0;
   }
 
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are
