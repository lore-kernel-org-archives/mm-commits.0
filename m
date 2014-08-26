From: akpm@linux-foundation.org
Subject: + list-include-linux-kernelh.patch added to -mm tree
Date: Tue, 26 Aug 2014 14:02:23 -0700
Message-ID: <53fcf5df.nVZ545ppzcqUtUM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:35440 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaHZVCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:02:24 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so1357446qgf.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:02:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.m@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list: include linux/kernel.h
has been added to the -mm tree.  Its filename is
     list-include-linux-kernelh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-include-linux-kernelh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-include-linux-kernelh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: list: include linux/kernel.h

linux/list.h uses container_of, therefore it depends on linux/kernel.h.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/list.h~list-include-linux-kernelh include/linux/list.h
--- a/include/linux/list.h~list-include-linux-kernelh
+++ a/include/linux/list.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/const.h>
+#include <linux/kernel.h>
 
 /*
  * Simple doubly linked list implementation.
_

Patches currently in -mm which might be from yamada.m@jp.panasonic.com are

list-include-linux-kernelh.patch
linux-next.patch

