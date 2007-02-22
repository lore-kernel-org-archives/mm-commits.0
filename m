From: akpm@linux-foundation.org
Subject: + update-timekeeping_is_continuous-comment.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:05:35 -0800
Message-ID: <200702220105.l1M15ZxS032340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbXBVBFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:05:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     update timekeeping_is_continuous comment
has been added to the -mm tree.  Its filename is
     update-timekeeping_is_continuous-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update timekeeping_is_continuous comment
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~update-timekeeping_is_continuous-comment kernel/timer.c
--- a/kernel/timer.c~update-timekeeping_is_continuous-comment
+++ a/kernel/timer.c
@@ -908,7 +908,7 @@ static inline void change_clocksource(vo
 #endif
 
 /**
- * timeofday_is_continuous - check to see if timekeeping is free running
+ * timekeeping_is_continuous - check to see if timekeeping is free running
  */
 int timekeeping_is_continuous(void)
 {
_

Patches currently in -mm which might be from dwalker@mvista.com are

update-timekeeping_is_continuous-comment.patch
panic-on-slim-selinux.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
