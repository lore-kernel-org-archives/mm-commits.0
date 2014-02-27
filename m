From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-change-mailing-list-address-for-altera-uart-drivers.patch
 removed from -mm tree
Date: Thu, 27 Feb 2014 12:24:02 -0800
Message-ID: <530f9ee2./SoxLNFV2h2QvaHg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0UYC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:24:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tklauser@distanz.ch

Subject: [merged] maintainers-change-mailing-list-address-for-altera-uart-drivers.patch removed from -mm tree
To: tklauser@distanz.ch,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:24:02 -0800


The patch titled
     Subject: MAINTAINERS: change mailing list address for Altera UART drivers
has been removed from the -mm tree.  Its filename was
     maintainers-change-mailing-list-address-for-altera-uart-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

