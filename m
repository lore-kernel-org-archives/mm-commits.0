From: akpm@linux-foundation.org
Subject: + documentation-sysrqtxt-added-short-description-for-q-timerlist.patch added to -mm tree
Date: Mon, 19 Mar 2007 23:45:46 -0800
Message-ID: <200703200745.l2K7jkUD028674@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbXCTHqn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 03:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes-kernel@saeurebad.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Documentation/sysrq.txt: added short description for 'Q' (timerlist)
has been added to the -mm tree.  Its filename is
     documentation-sysrqtxt-added-short-description-for-q-timerlist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/sysrq.txt: added short description for 'Q' (timerlist)
From: Johannes Weiner <hannes-kernel@saeurebad.de>

I added the 'Q' to list. A short description in the `Ok, so what can I
use them for'-section, on when or why to use it would be nice!

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/sysrq.txt~documentation-sysrqtxt-added-short-description-for-q-timerlist Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~documentation-sysrqtxt-added-short-description-for-q-timerlist
+++ a/Documentation/sysrq.txt
@@ -93,6 +93,8 @@ On all -  write a character to /proc/sys
 
 'p'     - Will dump the current registers and flags to your console.
 
+'q'     - Will dump a list of all running timers.
+
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
 's'     - Will attempt to sync all mounted filesystems.
_

Patches currently in -mm which might be from hannes-kernel@saeurebad.de are

documentation-sysrqtxt-added-short-description-for-q-timerlist.patch
