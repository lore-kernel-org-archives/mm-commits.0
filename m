From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-add-missing-export_symbolsimple_strtoll.patch added to -mm tree
Date: Wed, 21 Apr 2010 11:13:30 -0700
Message-ID: <201004211813.o3LIDUHL001104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab0DUSOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 14:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hverkuil@xs4all.nl


The patch titled
     lib/vsprintf.c: add missing EXPORT_SYMBOL(simple_strtoll)
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-add-missing-export_symbolsimple_strtoll.patch

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

linux-next.patch
lib-vsprintfc-add-missing-export_symbolsimple_strtoll.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
cx88-improve-error-handling.patch

