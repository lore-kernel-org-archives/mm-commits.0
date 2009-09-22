From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-ipvs-include-files.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:52 -0700
Message-ID: <200909222044.n8MKiqqQ014468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbZIVUoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heder@google.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add IPVS include files
has been removed from the -mm tree.  Its filename was
     maintainers-add-ipvs-include-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add IPVS include files
From: Hannes Eder <heder@google.com>

Signed-off-by: Hannes Eder <heder@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-ipvs-include-files MAINTAINERS
--- a/MAINTAINERS~maintainers-add-ipvs-include-files
+++ a/MAINTAINERS
@@ -2803,6 +2803,8 @@ L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
+F:	include/net/ip_vs.h
+F:	include/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
_

Patches currently in -mm which might be from heder@google.com are

origin.patch

