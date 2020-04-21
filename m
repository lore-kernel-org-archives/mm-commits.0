From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/15] MAINTAINERS: add an entry for kfifo
Date: Mon, 20 Apr 2020 18:13:48 -0700
Message-ID: <20200421011348.oIp0VsrgZ%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgDUBNt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:13:49 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com, gregkh@linuxfoundation.org, joe@perches.com, linus.walleij@linaro.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: MAINTAINERS: add an entry for kfifo

Kfifo has been written by Stefani Seibold and she's implicitly expected to
Ack any changes to it.  She's not however officially listed as kfifo
maintainer which leads to delays in patch review.  This patch proposes to
add an explitic entry for kfifo to MAINTAINERS file.

[akpm@linux-foundation.org: alphasort F: entries, per Joe]
[akpm@linux-foundation.org: remove colon, per Bartosz]
Link: http://lkml.kernel.org/r/20200124174533.21815-1-brgl@bgdev.pl
Link: http://lkml.kernel.org/r/20200413104250.26683-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked by Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-an-entry-for-kfifo
+++ a/MAINTAINERS
@@ -9416,6 +9416,13 @@ F:	include/linux/keyctl.h
 F:	include/uapi/linux/keyctl.h
 F:	security/keys/
 
+KFIFO
+M:	Stefani Seibold <stefani@seibold.net>
+S:	Maintained
+F:	include/linux/kfifo.h
+F:	lib/kfifo.c
+F:	samples/kfifo/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <daniel.thompson@linaro.org>
_
