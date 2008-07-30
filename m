From: akpm@linux-foundation.org
Subject: - connector-add-a-blackboard-user-to-connector.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:51 -0700
Message-ID: <200807301914.m6UJEp75010937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbYG3TYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeromearbezgindre@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     connector: add a BlackBoard user to connector
has been removed from the -mm tree.  Its filename was
     connector-add-a-blackboard-user-to-connector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: connector: add a BlackBoard user to connector
From: "Jerome Arbez-Gindre" <jeromearbezgindre@gmail.com>

Add a BlackBoard user to connector.  BlackBoard is part of the TSP GPL
sampling framework (http://savannah.nongnu.org/p/tsp)

[akpm@linux-foundation.org: add comment]
Signed-off-by: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/connector.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/connector.h~connector-add-a-blackboard-user-to-connector include/linux/connector.h
--- a/include/linux/connector.h~connector-add-a-blackboard-user-to-connector
+++ a/include/linux/connector.h
@@ -38,8 +38,9 @@
 #define CN_W1_VAL			0x1
 #define CN_IDX_V86D			0x4
 #define CN_VAL_V86D_UVESAFB		0x1
+#define CN_IDX_BB			0x5	/* BlackBoard, from the TSP GPL sampling framework */
 
-#define CN_NETLINK_USERS		5
+#define CN_NETLINK_USERS		6
 
 /*
  * Maximum connector's message size.
_

Patches currently in -mm which might be from jeromearbezgindre@gmail.com are

origin.patch

