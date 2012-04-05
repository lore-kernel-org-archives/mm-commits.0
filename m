From: akpm@linux-foundation.org
Subject: + maintainers-add-pcdp-console-maintainer.patch added to -mm tree
Date: Thu, 05 Apr 2012 16:55:57 -0700
Message-ID: <20120405235557.8C9D3A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:57811 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2DEXz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 19:55:58 -0400
Received: by ghbz15 with SMTP id z15so231975ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 16:55:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khalid@hp.com, joe@perches.com, khalid.aziz@hp.com


The patch titled
     Subject: MAINTAINERS: add PCDP console maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-pcdp-console-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5119,6 +5119,11 @@ F:	drivers/i2c/busses/i2c-pca-*
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
Subject: Subject: MAINTAINERS: add PCDP console maintainer

Patches currently in -mm which might be from khalid@hp.com are

maintainers-add-pcdp-console-maintainer.patch

