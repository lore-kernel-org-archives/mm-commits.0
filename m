From: akpm@linux-foundation.org
Subject: [merged] include-uapi-linux-dnh-pull-in-ioctlh-header.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:43 -0800
Message-ID: <52e2b85b.p8Tv8/XwtKEzt3Bo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, vapier@gentoo.org

Subject: [merged] include-uapi-linux-dnh-pull-in-ioctlh-header.patch removed from -mm tree
To: vapier@gentoo.org,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:43 -0800


The patch titled
     Subject: include/uapi/linux/dn.h: pull in ioctl.h header
has been removed from the -mm tree.  Its filename was
     include-uapi-linux-dnh-pull-in-ioctlh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: include/uapi/linux/dn.h: pull in ioctl.h header

This header uses _IOW/_IOR defines but doesn't include ioctl.h for it.  If
you try to use this w/out including ioctl.h yourself, it can fail to
build, so add the explicit include.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/dn.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/dn.h~include-uapi-linux-dnh-pull-in-ioctlh-header include/uapi/linux/dn.h
--- a/include/uapi/linux/dn.h~include-uapi-linux-dnh-pull-in-ioctlh-header
+++ a/include/uapi/linux/dn.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DN_H
 #define _LINUX_DN_H
 
+#include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
linux-next.patch

