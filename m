From: akpm@linux-foundation.org
Subject: + maintainers-change-avr32-and-at32ap-maintainer.patch added to -mm tree
Date: Tue, 21 Sep 2010 13:00:30 -0700
Message-ID: <201009212000.o8LK0Uq9031176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab0IUUAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 16:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, haavard.skinnemoen@atmel.com


The patch titled
     MAINTAINERS: change AVR32 and AT32AP maintainer
has been added to the -mm tree.  Its filename is
     maintainers-change-avr32-and-at32ap-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: change AVR32 and AT32AP maintainer
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Alter the maintainer of the AVR32 architecture and the AVR32/AT32AP
machine support to me.  Haavard is moving on to new challenges, and we've
found it better to transfer the maintainer part to me.  I will have good
contact with Haavard anyway.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-change-avr32-and-at32ap-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-change-avr32-and-at32ap-maintainer
+++ a/MAINTAINERS
@@ -1234,7 +1234,7 @@ F:	drivers/auxdisplay/
 F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
 W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
@@ -1242,7 +1242,7 @@ S:	Supported
 F:	arch/avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
 S:	Supported
 F:	arch/avr32/mach-at32ap/
 
_

Patches currently in -mm which might be from hans-christian.egtvedt@atmel.com are

maintainers-change-avr32-and-at32ap-maintainer.patch

