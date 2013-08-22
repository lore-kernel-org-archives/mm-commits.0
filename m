From: akpm@linux-foundation.org
Subject: + omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch added
 to -mm tree
Date: Thu, 22 Aug 2013 15:56:57 -0700
Message-ID: <52169739.4qXdD2GE64AgzmAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3HVW46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, laforge@gnumonks.org, vapier@gentoo.org

Subject: + omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch added to -mm tree
To: vapier@gentoo.org,laforge@gnumonks.org
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:56:57 -0700


The patch titled
     Subject: Omnikey Cardman 4000: pull in ioctl.h in user header
has been added to the -mm tree.  Its filename is
     omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch

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

omnikey-cardman-4000-pull-in-ioctlh-in-user-header.patch

