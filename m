From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:04 -0700
Message-ID: <533f08f0.DF/3nW4wEQi5Ke2V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaDDTdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, marc@cadence.com, chris@zankel.net, jcmvbkbc@gmail.com

Subject: [merged] maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch removed from -mm tree
To: jcmvbkbc@gmail.com,chris@zankel.net,marc@cadence.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:04 -0700


The patch titled
     Subject: MAINTAINERS: add xtensa irqchips to xtensa port entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-xtensa-irqchips-to-xtensa-port-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8765,6 +8765,7 @@ M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
+F:	drivers/irqchip/irq-xtensa-*
 
 THANKO'S RAREMONO AM/FM/SW RADIO RECEIVER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

origin.patch

