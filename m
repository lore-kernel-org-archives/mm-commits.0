From: akpm@linux-foundation.org
Subject: + regulator-maintainers.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:40:26 -0800
Message-ID: <200803070840.m278eQhB013463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039AbYCGIlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com


The patch titled
     regulator: maintainers
has been added to the -mm tree.  Its filename is
     regulator-maintainers.patch

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

regulator-consumer-interface.patch
regulator-regulator-driver-interface.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch

