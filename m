From: akpm@linux-foundation.org
Subject: + maintainers-update-gpio-subsystem-file-list.patch added to -mm tree
Date: Wed, 15 Aug 2012 14:17:00 -0700
Message-ID: <20120815211700.F30B220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:53625 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab2HOVRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 17:17:03 -0400
Received: by weyr1 with SMTP id r1so96754wey.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 14:17:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hamo.by@gmail.com


The patch titled
     Subject: MAINTAINERS: update gpio subsystem file list
has been added to the -mm tree.  Its filename is
     maintainers-update-gpio-subsystem-file-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Bai <hamo.by@gmail.com>
Subject: MAINTAINERS: update gpio subsystem file list

Signed-off-by: Yang Bai <hamo.by@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-update-gpio-subsystem-file-list MAINTAINERS
--- a/MAINTAINERS~maintainers-update-gpio-subsystem-file-list
+++ a/MAINTAINERS
@@ -3105,6 +3105,7 @@ T:	git git://git.secretlab.ca/git/linux-
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
+F:	include/asm-generic/gpio.h
 
 GRE DEMULTIPLEXER DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
_

Patches currently in -mm which might be from hamo.by@gmail.com are

linux-next.patch
maintainers-update-gpio-subsystem-file-list.patch

