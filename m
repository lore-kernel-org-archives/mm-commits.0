From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-pcdp-console-maintainer.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:30 -0700
Message-ID: <20120416201530.43F45A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37999 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2DPUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:30 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so640589yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khalid@hp.com, joe@perches.com, khalid.aziz@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add PCDP console maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-pcdp-console-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Khalid Aziz <khalid@hp.com>
Subject: MAINTAINERS: add PCDP console maintainer

Add missing maintainer info for PCDP console code.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-pcdp-console-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-pcdp-console-maintainer
+++ a/MAINTAINERS
@@ -5118,6 +5118,11 @@ F:	drivers/i2c/busses/i2c-pca-*
 F:	include/linux/i2c-algo-pca.h
 F:	include/linux/i2c-pca-platform.h
 
+PCDP - PRIMARY CONSOLE AND DEBUG PORT
+M:	Khalid Aziz <khalid.aziz@hp.com>
+S:	Maintained
+F:	drivers/firmware/pcdp.*
+
 PCI ERROR RECOVERY
 M:     Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
_

Patches currently in -mm which might be from khalid@hp.com are


