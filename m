From: akpm@linux-foundation.org
Subject: [merged] omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch removed from -mm tree
Date: Thu, 29 Aug 2013 12:42:57 -0700
Message-ID: <521fa441.41MUYIJ02WZLik2k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3H2Tm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, laforge@gnumonks.org, vapier@gentoo.org

Subject: [merged] omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch removed from -mm tree
To: vapier@gentoo.org,laforge@gnumonks.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:42:57 -0700


The patch titled
     Subject: Omnikey Cardman 4000: pull in ioctl.h in user header
has been removed from the -mm tree.  Its filename was
     omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: Omnikey Cardman 4000: pull in ioctl.h in user header

This file uses the ioctl helpers (_IOR/_IOW/etc...), so include ioctl.h
for the definitions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/cm4000_cs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/cm4000_cs.h~omnikey-cardman-4000-pull-in-ioctlh-in-user-header include/uapi/linux/cm4000_cs.h
--- a/include/uapi/linux/cm4000_cs.h~omnikey-cardman-4000-pull-in-ioctlh-in-user-header
+++ a/include/uapi/linux/cm4000_cs.h
@@ -2,6 +2,7 @@
 #define _UAPI_CM4000_H_
 
 #include <linux/types.h>
+#include <linux/ioctl.h>
 
 #define	MAX_ATR			33
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch

