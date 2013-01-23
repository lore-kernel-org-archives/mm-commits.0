From: akpm@linux-foundation.org
Subject: + maintainers-update-avr32-web-ressources.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:58:58 -0800
Message-ID: <20130123215858.8F76731C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55039 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWV67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:58:59 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so1001600yen.0
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:58:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.bgg@gmail.com, egtvedt@samfundet.no


The patch titled
     Subject: MAINTAINERS: update avr32 web ressources
has been added to the -mm tree.  Its filename is
     maintainers-update-avr32-web-ressources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: MAINTAINERS: update avr32 web ressources

Web ressource http://avr32linux.org/ is no longer available.  We add the
mirror of the web page foud at http://mirror.egtvedt.no/avr32linux.org/.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-avr32-web-ressources MAINTAINERS
--- a/MAINTAINERS~maintainers-update-avr32-web-ressources
+++ a/MAINTAINERS
@@ -1525,7 +1525,7 @@ AVR32 ARCHITECTURE
 M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
 M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
 W:	http://www.atmel.com/products/AVR32/
-W:	http://avr32linux.org/
+W:	http://mirror.egtvedt.no/avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Maintained
 F:	arch/avr32/
_

Patches currently in -mm which might be from matthias.bgg@gmail.com are

maintainers-update-avr32-web-ressources.patch

