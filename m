From: akpm@linux-foundation.org
Subject: + maintainers-add-an-entry-for-kfifo.patch added to -mm
 tree
Date: Sun, 26 Jan 2020 19:05:12 -0800
Message-ID: <20200127030512.G_Lad5SKd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0DFN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Jan 2020 22:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org, mm-commits@vger.kernel.org, stefani@seibold.net


The patch titled
     Subject: MAINTAINERS: add an entry for kfifo
has been added to the -mm tree.  Its filename is
     maintainers-add-an-entry-for-kfifo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-an-entry-for-kfifo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-an-entry-for-kfifo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: MAINTAINERS: add an entry for kfifo

Kfifo has been written by Stefani Seibold and she's implicitly expected to
Ack any changes to it.  She's not however officially listed as kfifo
maintainer which leads to delays in patch review.  This patch proposes to
add an explitic entry for kfifo to MAINTAINERS file.

Link: http://lkml.kernel.org/r/20200124174533.21815-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-an-entry-for-kfifo
+++ a/MAINTAINERS
@@ -9188,6 +9188,13 @@ F:	include/uapi/linux/keyctl.h
 F:	include/keys/
 F:	security/keys/
 
+KFIFO:
+M:	Stefani Seibold <stefani@seibold.net>
+S:	Maintained
+F:	lib/kfifo.c
+F:	include/linux/kfifo.h
+F:	samples/kfifo/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <daniel.thompson@linaro.org>
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

maintainers-add-an-entry-for-kfifo.patch
