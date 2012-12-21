From: akpm@linux-foundation.org
Subject: [merged] documentation-abi-remove-testing-sysfs-devices-node.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:14 -0800
Message-ID: <20121221204014.9EA6A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35329 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LUUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:15 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so516923qcq.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr.bueso@hp.com, greg@kroah.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: ABI: remove testing/sysfs-devices-node
has been removed from the -mm tree.  Its filename was
     documentation-abi-remove-testing-sysfs-devices-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

