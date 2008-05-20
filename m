From: akpm@linux-foundation.org
Subject: - add-maintainers-for-myri10ge-driver.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:50 -0700
Message-ID: <200805202114.m4KLEoWl011499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367AbYETVPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brice@myri.com, mm-commits@vger.kernel.org


The patch titled
     Add maintainers entry for myri10ge driver
has been removed from the -mm tree.  Its filename was
     add-maintainers-for-myri10ge-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add maintainers entry for myri10ge driver
From: Brice Goglin <brice@myri.com>

Add a MAINTAINERS entry for the myri10ge driver.

Signed-off-by: Brice Goglin <brice@myri.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~add-maintainers-for-myri10ge-driver MAINTAINERS
--- a/MAINTAINERS~add-maintainers-for-myri10ge-driver
+++ a/MAINTAINERS
@@ -2827,6 +2827,15 @@ M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
+P:	Andrew Gallatin
+M:	gallatin@myri.com
+P:	Brice Goglin
+M:	brice@myri.com
+L:	netdev@vger.kernel.org
+W:	http://www.myri.com/scs/download-Myri10GE.html
+S:	Supported
+
 NATSEMI ETHERNET DRIVER (DP8381x)
 P: 	Tim Hockin
 M:	thockin@hockin.org
_

Patches currently in -mm which might be from brice@myri.com are

origin.patch

