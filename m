From: akpm@linux-foundation.org
Subject: +
 maintainers-change-mailing-list-address-for-altera-uart-drivers.patch added to -mm tree
Date: Fri, 21 Feb 2014 12:17:48 -0800
Message-ID: <5307b46c.ag9/XZuB40/I/EyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaBUURs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tklauser@distanz.ch

Subject: + maintainers-change-mailing-list-address-for-altera-uart-drivers.patch added to -mm tree
To: tklauser@distanz.ch
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:17:48 -0800


The patch titled
     Subject: MAINTAINERS: change mailing list address for Altera UART drivers
has been added to the -mm tree.  Its filename is
     maintainers-change-mailing-list-address-for-altera-uart-drivers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-change-mailing-list-address-for-altera-uart-drivers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-change-mailing-list-address-for-altera-uart-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: MAINTAINERS: change mailing list address for Altera UART drivers

The nios2-dev list has been moved to the RocketBoards infrastructure, so
adjust the address accordingly.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-change-mailing-list-address-for-altera-uart-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-change-mailing-list-address-for-altera-uart-drivers
+++ a/MAINTAINERS
@@ -538,7 +538,7 @@ F:	arch/alpha/
 ALTERA UART/JTAG UART SERIAL DRIVERS
 M:	Tobias Klauser <tklauser@distanz.ch>
 L:	linux-serial@vger.kernel.org
-L:	nios2-dev@sopc.et.ntust.edu.tw (moderated for non-subscribers)
+L:	nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/tty/serial/altera_uart.c
 F:	drivers/tty/serial/altera_jtaguart.c
_

Patches currently in -mm which might be from tklauser@distanz.ch are

maintainers-change-mailing-list-address-for-altera-uart-drivers.patch

