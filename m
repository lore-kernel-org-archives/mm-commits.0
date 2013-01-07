From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-documentation-mei.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:36 -0800
Message-ID: <20130107192637.25195200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38694 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AGT0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:39 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so1262050bkc.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, tomas.winkler@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix Documentation/mei/
has been removed from the -mm tree.  Its filename was
     maintainers-fix-documentation-mei.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix Documentation/mei/

The documentation was moved to Documentation/misc-devices/mei/ instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-documentation-mei MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-documentation-mei
+++ a/MAINTAINERS
@@ -4117,7 +4117,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	include/uapi/linux/mei.h
 F:	drivers/misc/mei/*
-F:	Documentation/mei/*
+F:	Documentation/misc-devices/mei/*
 
 IOC3 ETHERNET DRIVER
 M:	Ralf Baechle <ralf@linux-mips.org>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

