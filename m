From: akpm@linux-foundation.org
Subject: + maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch
 added to -mm tree
Date: Fri, 07 Mar 2014 14:30:10 -0800
Message-ID: <531a4872.7jSeMzW81yFBKyI8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaCGWaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2014 17:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, marc@cadence.com, chris@zankel.net, jcmvbkbc@gmail.com

Subject: + maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch added to -mm tree
To: jcmvbkbc@gmail.com,chris@zankel.net,marc@cadence.com
From: akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 14:30:10 -0800


The patch titled
     Subject: MAINTAINERS: add xtensa irqchips to xtensa port entry
has been added to the -mm tree.  Its filename is
     maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: MAINTAINERS: add xtensa irqchips to xtensa port entry

Now that irqchip drivers for xtensa live outside arch/xtensa we'd like
to add them to our maintenance list.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Marc Gauthier <marc@cadence.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-xtensa-irqchips-to-xtensa-port-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-xtensa-irqchips-to-xtensa-port-entry
+++ a/MAINTAINERS
@@ -8700,6 +8700,7 @@ M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
+F:	drivers/irqchip/irq-xtensa-*
 
 THANKO'S RAREMONO AM/FM/SW RADIO RECEIVER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

origin.patch
maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch

