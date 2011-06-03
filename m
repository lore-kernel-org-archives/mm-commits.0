From: akpm@linux-foundation.org
Subject: + init-skip-calibration-delay-if-previously-done-fix-fix-fix.patch added to -mm tree
Date: Fri, 03 Jun 2011 15:19:56 -0700
Message-ID: <201106032219.p53MJuPJ010859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370Ab1FCWUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 18:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snanda@google.com


The patch titled
     init-skip-calibration-delay-if-previously-done-fix-fix-fix
has been added to the -mm tree.  Its filename is
     init-skip-calibration-delay-if-previously-done-fix-fix-fix.patch

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
Subject: init-skip-calibration-delay-if-previously-done-fix-fix-fix
From: Sameer Nanda <snanda@google.com>

prevent ARM build breakage :)


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix-fix init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix-fix
+++ a/init/calibrate.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
_

Patches currently in -mm which might be from snanda@google.com are

init-skip-calibration-delay-if-previously-done-fix-fix-fix.patch

