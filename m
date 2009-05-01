From: akpm@linux-foundation.org
Subject: + drbd-add-major-number-to-majorh.patch added to -mm tree
Date: Fri, 01 May 2009 02:09:00 -0700
Message-ID: <200905010909.n41990Vi030179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbZEAJLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 05:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.reisner@linbit.com, lars.ellenberg@linbit.com


The patch titled
     drbd: add major number to major.h
has been added to the -mm tree.  Its filename is
     drbd-add-major-number-to-majorh.patch

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
Subject: drbd: add major number to major.h
From: Philipp Reisner <philipp.reisner@linbit.com>

Since we have had a LANANA major number for years, and it is documented in
devices.txt, I think that this first patch can go upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/major.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/major.h~drbd-add-major-number-to-majorh include/linux/major.h
--- a/include/linux/major.h~drbd-add-major-number-to-majorh
+++ a/include/linux/major.h
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
_

Patches currently in -mm which might be from philipp.reisner@linbit.com are

drbd-add-major-number-to-majorh.patch

