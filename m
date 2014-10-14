From: akpm@linux-foundation.org
Subject: [merged] list-include-linux-kernelh.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:23 -0700
Message-ID: <543d692b.SIvBtvEhOV5gty69%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaJNSTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.m@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list: include linux/kernel.h
has been removed from the -mm tree.  Its filename was
     list-include-linux-kernelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

