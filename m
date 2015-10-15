From: akpm@linux-foundation.org
Subject: + maintainers-add-myself-as-zsmalloc-reviewer.patch added to -mm
 tree
Date: Thu, 15 Oct 2015 12:42:26 -0700
Message-ID: <562001a2.J3lhAzp7JI60YlHK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbJOTm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Sergey as zsmalloc reviewer
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-as-zsmalloc-reviewer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-zsmalloc-reviewer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-zsmalloc-reviewer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: MAINTAINERS: add Sergey as zsmalloc reviewer

Nominate myself as a zsmalloc reviewer.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-myself-as-zsmalloc-reviewer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-myself-as-zsmalloc-reviewer
+++ a/MAINTAINERS
@@ -11651,6 +11651,7 @@ F:	drivers/tty/serial/zs.*
 ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
 M:	Nitin Gupta <ngupta@vflare.org>
+R:	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zsmalloc.c
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

maintainers-add-myself-as-zsmalloc-reviewer.patch
zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch

