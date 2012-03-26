From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-maintainership-of-ltp.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:48 -0700
Message-ID: <20120326192848.7083AA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46715 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2CZT2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:49 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298392faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, caspar@casparzhang.com, chrubis@suse.cz, rishikesh.rajak@hp.com, tosubrata@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update maintainership of LTP
has been removed from the -mm tree.  Its filename was
     maintainers-update-maintainership-of-ltp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: MAINTAINERS: update maintainership of LTP

The maintainership of LTP is out of date, so update it.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
Reviewed-by: Rishikesh K Rajak <rishikesh.rajak@hp.com>
Acked-by: Subrata Modak <tosubrata@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-maintainership-of-ltp MAINTAINERS
--- a/MAINTAINERS~maintainers-update-maintainership-of-ltp
+++ a/MAINTAINERS
@@ -4236,12 +4236,14 @@ F:	Documentation/hwmon/ltc4261
 F:	drivers/hwmon/ltc4261.c
 
 LTP (Linux Test Project)
-M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
-M:	Garrett Cooper <yanegomi@gmail.com>
+M:	Shubham Goyal <shubham@linux.vnet.ibm.com>
 M:	Mike Frysinger <vapier@gentoo.org>
-M:	Subrata Modak <subrata@linux.vnet.ibm.com>
+M:	Cyril Hrubis <chrubis@suse.cz>
+M:	Caspar Zhang <caspar@casparzhang.com>
+M:	Wanlong Gao <gaowanlong@cn.fujitsu.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
+T:	git git://github.com/linux-test-project/ltp.git
 T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch
nbd-rename-the-nbd_device-variable-from-lo-to-nbd.patch

