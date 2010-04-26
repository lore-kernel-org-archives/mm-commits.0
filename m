From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-add-missing-export_symbolsimple_strtoll.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:47 -0400
Message-ID: <201004261728.o3QHSL6l009117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab0DZR2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hverkuil@xs4all.nl, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: add missing EXPORT_SYMBOL(simple_strtoll)
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-add-missing-export_symbolsimple_strtoll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: add missing EXPORT_SYMBOL(simple_strtoll)
From: Hans Verkuil <hverkuil@xs4all.nl>

Add a missing EXPORT_SYMBOL.

I must be the first person that wants to use this function :-)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/vsprintf.c~lib-vsprintfc-add-missing-export_symbolsimple_strtoll lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-add-missing-export_symbolsimple_strtoll
+++ a/lib/vsprintf.c
@@ -118,6 +118,7 @@ long long simple_strtoll(const char *cp,
 
 	return simple_strtoull(cp, endp, base);
 }
+EXPORT_SYMBOL(simple_strtoll);
 
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
_

Patches currently in -mm which might be from hverkuil@xs4all.nl are

origin.patch
linux-next.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
cx88-improve-error-handling.patch

