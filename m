From: akpm@linux-foundation.org
Subject: + fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch added to -mm tree
Date: Fri, 27 Apr 2007 23:29:07 -0700
Message-ID: <200704280629.l3S6T7O8016339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbXD1G3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 02:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de, greg@kroah.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     Fix wrong identifier name in Documentation/driver-model/devres.txt
has been added to the -mm tree.  Its filename is
     fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch
