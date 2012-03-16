From: akpm@linux-foundation.org
Subject: + maintainers-update-maintainership-of-ltp.patch added to -mm tree
Date: Fri, 16 Mar 2012 14:24:43 -0700
Message-ID: <20120316212443.CF4B0A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56690 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2CPVYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 17:24:45 -0400
Received: by yhgm50 with SMTP id m50so748377yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 14:24:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaowanlong@cn.fujitsu.com, caspar@casparzhang.com, chrubis@suse.cz, rishikesh.rajak@hp.com, tosubrata@gmail.com


The patch titled
     Subject: MAINTAINERS: update maintainership of LTP
has been added to the -mm tree.  Its filename is
     maintainers-update-maintainership-of-ltp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4232,12 +4232,14 @@ F:	Documentation/hwmon/ltc4261
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
Subject: Subject: MAINTAINERS: update maintainership of LTP

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

linux-next.patch
maintainers-update-maintainership-of-ltp.patch
nbd-rename-the-nbd_device-variable-from-lo-to-nbd.patch

