From: akpm@linux-foundation.org
Subject: + maintainers-fill-entries-for-kasan.patch added to -mm tree
Date: Fri, 25 Mar 2016 11:46:33 -0700
Message-ID: <56f58789.1EZow33F07kbpOFh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbcCYSqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 14:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fill entries for KASAN
has been added to the -mm tree.  Its filename is
     maintainers-fill-entries-for-kasan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-fill-entries-for-kasan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-fill-entries-for-kasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: MAINTAINERS: fill entries for KASAN

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN MAINTAINERS~maintainers-fill-entries-for-kasan MAINTAINERS
--- a/MAINTAINERS~maintainers-fill-entries-for-kasan
+++ a/MAINTAINERS
@@ -6165,6 +6165,20 @@ S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
+KASAN
+M:	Andrey Ryabinin <aryabinin@virtuozzo.com>
+R:	Alexander Potapenko <glider@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	arch/*/include/asm/kasan.h
+F:	arch/*/mm/kasan_init*
+F:	Documentation/kasan.txt
+F:	include/linux/kasan.h
+F:	lib/test_kasan.c
+F:	mm/kasan/
+F:	scripts/Makefile.kasan
+
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

maintainers-fill-entries-for-kasan.patch

