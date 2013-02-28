From: akpm@linux-foundation.org
Subject: [merged] documentation-cgroups-blkio-controllertxt-fix-typo.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:30 -0800
Message-ID: <20130228201130.AEA345A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34454 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3B1ULb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:31 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so39436vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wt@ooyala.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/cgroups/blkio-controller.txt: fix typo
has been removed from the -mm tree.  Its filename was
     documentation-cgroups-blkio-controllertxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Warren Turkal <wt@ooyala.com>
Subject: Documentation/cgroups/blkio-controller.txt: fix typo

Signed-off-by: Warren Turkal <wt@ooyala.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/blkio-controller.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/blkio-controller.txt~documentation-cgroups-blkio-controllertxt-fix-typo Documentation/cgroups/blkio-controller.txt
--- a/Documentation/cgroups/blkio-controller.txt~documentation-cgroups-blkio-controllertxt-fix-typo
+++ a/Documentation/cgroups/blkio-controller.txt
@@ -75,7 +75,7 @@ Throttling/Upper Limit policy
         mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Specify a bandwidth rate on particular device for root group. The format
-  for policy is "<major>:<minor>  <byes_per_second>".
+  for policy is "<major>:<minor>  <bytes_per_second>".
 
         echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
 
_

Patches currently in -mm which might be from wt@ooyala.com are

origin.patch

