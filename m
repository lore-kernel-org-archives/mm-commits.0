From: akpm@linux-foundation.org
Subject: + kernel-power-changed-makefile-to-use-proper-ccflag-flag.patch added to -mm tree
Date: Tue, 16 Nov 2010 16:17:44 -0800
Message-ID: <201011170017.oAH0Hila016403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756087Ab0KQASf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 19:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, lenb@kernel.org, mmarek@suse.cz, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     kernel/power/Makefile: use proper ccflag flag
has been added to the -mm tree.  Its filename is
     kernel-power-changed-makefile-to-use-proper-ccflag-flag.patch

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
Subject: kernel/power/Makefile: use proper ccflag flag
From: Tracey Dent <tdent48227@gmail.com>

Use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/power/Makefile~kernel-power-changed-makefile-to-use-proper-ccflag-flag kernel/power/Makefile
--- a/kernel/power/Makefile~kernel-power-changed-makefile-to-use-proper-ccflag-flag
+++ a/kernel/power/Makefile
@@ -1,7 +1,4 @@
