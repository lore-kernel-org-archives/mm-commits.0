From: akpm@linux-foundation.org
Subject: + connector-add-a-blackboard-user-to-connector.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:59:43 -0700
Message-ID: <200807290659.m6T6xhoQ019934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbYG2HBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeromearbezgindre@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     connector: add a BlackBoard user to connector
has been added to the -mm tree.  Its filename is
     connector-add-a-blackboard-user-to-connector.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: connector: add a BlackBoard user to connector
From: "Jerome Arbez-Gindre" <jeromearbezgindre@gmail.com>

Add a BlackBoard user to connector.  BlackBoard is part of the TSP GPL
sampling framework (http://savannah.nongnu.org/p/tsp)

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
+#define CN_IDX_BB			0x5
 
-#define CN_NETLINK_USERS		5
+#define CN_NETLINK_USERS		6
 
 /*
  * Maximum connector's message size.
_

Patches currently in -mm which might be from jeromearbezgindre@gmail.com are

connector-add-a-blackboard-user-to-connector.patch

