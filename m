From: akpm@linux-foundation.org
Subject: - connector-change-connectors-max-message-size.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:40 -0700
Message-ID: <200710162041.l9GKfejl015813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965758AbXJPV1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     connector: change connector's max message size
has been removed from the -mm tree.  Its filename was
     connector-change-connectors-max-message-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: connector: change connector's max message size
From: Michal Januszewski <spock@gentoo.org>

Change the maximum message size to 16k to allow transfers of VBE
data blocks from userspace.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/connector.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/connector.h~connector-change-connectors-max-message-size include/linux/connector.h
--- a/include/linux/connector.h~connector-change-connectors-max-message-size
+++ a/include/linux/connector.h
@@ -43,7 +43,7 @@
 /*
  * Maximum connector's message size.
  */
-#define CONNECTOR_MAX_MSG_SIZE 	1024
+#define CONNECTOR_MAX_MSG_SIZE		16384
 
 /*
  * idx and val are unique identifiers which 
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
