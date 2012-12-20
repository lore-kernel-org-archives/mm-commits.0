From: akpm@linux-foundation.org
Subject: + documentation-abi-remove-testing-sysfs-devices-node.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:17:25 -0800
Message-ID: <20121220201725.99D50100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41634 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2LTUR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:17:26 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so436133qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:17:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, greg@kroah.com, mel@csn.ul.ie


The patch titled
     Subject: Documentation: ABI: remove testing/sysfs-devices-node
has been added to the -mm tree.  Its filename is
     documentation-abi-remove-testing-sysfs-devices-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Documentation: ABI: remove testing/sysfs-devices-node

This file is already documented in the stable ABI (commit 5bbe1ec1).

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-node |    7 -------
 1 file changed, 7 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-devices-node~documentation-abi-remove-testing-sysfs-devices-node /dev/null
--- a/Documentation/ABI/testing/sysfs-devices-node
+++ /dev/null
@@ -1,7 +0,0 @@
-What:		/sys/devices/system/node/nodeX/compact
-Date:		February 2010
-Contact:	Mel Gorman <mel@csn.ul.ie>
-Description:
-		When this file is written to, all memory within that node
-		will be compacted. When it completes, memory will be freed
-		into blocks which have as many contiguous pages as possible
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch
documentation-abi-remove-testing-sysfs-devices-node.patch

