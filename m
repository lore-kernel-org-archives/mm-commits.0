From: akpm@linux-foundation.org
Subject: - uvesafb-add-connector-entries.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:45 -0700
Message-ID: <200710162041.l9GKfjKE015818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59587 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965622AbXJPV2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     uvesafb: add connector entries
has been removed from the -mm tree.  Its filename was
     uvesafb-add-connector-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uvesafb: add connector entries
From: Michal Januszewski <spock@gentoo.org>

Add connector idx and val constants for v86d and uvesafb.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/connector.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/connector.h~uvesafb-add-connector-entries include/linux/connector.h
--- a/include/linux/connector.h~uvesafb-add-connector-entries
+++ a/include/linux/connector.h
@@ -36,9 +36,10 @@
 #define CN_VAL_CIFS                     0x1
 #define CN_W1_IDX			0x3	/* w1 communication */
 #define CN_W1_VAL			0x1
+#define CN_IDX_V86D			0x4
+#define CN_VAL_V86D_UVESAFB		0x1
 
-
-#define CN_NETLINK_USERS		4
+#define CN_NETLINK_USERS		5
 
 /*
  * Maximum connector's message size.
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
