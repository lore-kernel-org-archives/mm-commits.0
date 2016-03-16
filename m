From: akpm@linux-foundation.org
Subject: [merged] autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:58:04 -0700
Message-ID: <56e9bacc.ZwPSMRWhZD9WIyIu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcCPT6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix string.h include in auto_dev-ioctl.h
has been removed from the -mm tree.  Its filename was
     autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix string.h include in auto_dev-ioctl.h

Since including linux/string.h will now do the right thing remove the
conditional check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/auto_dev-ioctl.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/auto_dev-ioctl.h~autofs4-fix-stringh-include-in-auto_dev-ioctlh include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs4-fix-stringh-include-in-auto_dev-ioctlh
+++ a/include/linux/auto_dev-ioctl.h
@@ -11,12 +11,7 @@
 #define _LINUX_AUTO_DEV_IOCTL_H
 
 #include <linux/auto_fs.h>
