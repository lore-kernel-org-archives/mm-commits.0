From: akpm@linux-foundation.org
Subject: + hpet-clarify-maintainer-entry.patch added to -mm tree
Date: Wed, 23 Jul 2008 00:42:00 -0700
Message-ID: <200807230742.m6N7g0wq009405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYGWHm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 03:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hpet: clarify maintainer entry
has been added to the -mm tree.  Its filename is
     hpet-clarify-maintainer-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: clarify maintainer entry
From: Clemens Ladisch <clemens@ladisch.de>

The existing HPET maintainer entries are somewhat unclear about which one
applies to what part of the kernel.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~hpet-clarify-maintainer-entry MAINTAINERS
--- a/MAINTAINERS~hpet-clarify-maintainer-entry
+++ a/MAINTAINERS
@@ -1998,7 +1998,7 @@ P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes
 
-HPET:	High Precision Event Timers driver (hpet.c)
+HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
_

Patches currently in -mm which might be from clemens@ladisch.de are

origin.patch
if-0-hpet_unregister.patch
hpet-clarify-maintainer-entry.patch

