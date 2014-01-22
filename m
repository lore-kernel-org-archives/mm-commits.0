From: akpm@linux-foundation.org
Subject: + include-uapi-linux-dnh-pull-in-ioctlh-header.patch added to -mm tree
Date: Wed, 22 Jan 2014 13:13:49 -0800
Message-ID: <52e0348d.8ah5Vw/YUsVTXu5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVVNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 16:13:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, vapier@gentoo.org

Subject: + include-uapi-linux-dnh-pull-in-ioctlh-header.patch added to -mm tree
To: vapier@gentoo.org,davem@davemloft.net
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 13:13:49 -0800


The patch titled
     Subject: include/uapi/linux/dn.h: pull in ioctl.h header
has been added to the -mm tree.  Its filename is
     include-uapi-linux-dnh-pull-in-ioctlh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-uapi-linux-dnh-pull-in-ioctlh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-uapi-linux-dnh-pull-in-ioctlh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh.patch
include-uapi-linux-dnh-pull-in-ioctlh-header.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
linux-next.patch

