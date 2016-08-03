From: akpm@linux-foundation.org
Subject: [merged] cgroup-update-cgroups-document-path.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:11:26 -0700
Message-ID: <57a233ce.tCemdXPIWsgORKod%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: update cgroup's document path
has been removed from the -mm tree.  Its filename was
     cgroup-update-cgroups-document-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "seokhoon.yoon" <iamyooon@gmail.com>
Subject: cgroup: update cgroup's document path

cgroup's document path is changed to "cgroup-v1". update it.

Link: http://lkml.kernel.org/r/1470148443-6509-1-git-send-email-iamyooon@gmail.com
Signed-off-by: seokhoon.yoon <iamyooon@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~cgroup-update-cgroups-document-path init/Kconfig
--- a/init/Kconfig~cgroup-update-cgroups-document-path
+++ a/init/Kconfig
@@ -952,7 +952,7 @@ menuconfig CGROUPS
 	  controls or device isolation.
 	  See
 		- Documentation/scheduler/sched-design-CFS.txt	(CFS)
-		- Documentation/cgroups/ (features for grouping, isolation
+		- Documentation/cgroup-v1/ (features for grouping, isolation
 					  and resource control)
 
 	  Say N if unsure.
@@ -1009,7 +1009,7 @@ config BLK_CGROUP
 	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
-	See Documentation/cgroups/blkio-controller.txt for more information.
+	See Documentation/cgroup-v1/blkio-controller.txt for more information.
 
 config DEBUG_BLK_CGROUP
 	bool "IO controller debugging"
_

Patches currently in -mm which might be from iamyooon@gmail.com are


