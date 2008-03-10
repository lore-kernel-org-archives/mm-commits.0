From: akpm@linux-foundation.org
Subject: - regulator-maintainers.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:37:54 -0700
Message-ID: <200803101937.m2AJbs1i001929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYCJTiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     regulator: maintainers
has been removed from the -mm tree.  Its filename was
     regulator-maintainers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: maintainers
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch adds Liam Girdwood and Mark Brown as regulator maintainers.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~regulator-maintainers MAINTAINERS
--- a/MAINTAINERS~regulator-maintainers
+++ a/MAINTAINERS
@@ -4265,6 +4265,15 @@ M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+VOLTAGE AND CURRENT REGULATOR FRAMEWORK
+P:	Liam Girdwood
+M:	lg@opensource.wolfsonmicro.com
+P:	Mark Brown
+M:	broonie@opensource.wolfsonmicro.com
+W:	http://opensource.wolfsonmicro.com/node/15
+T:	git opensource.wolfsonmicro.com:/linux-2.6-audioplus.git
+S:	Supported
+
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-maintainers.patch

