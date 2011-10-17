From: akpm@linux-foundation.org
Subject: + a.patch added to -mm tree
Date: Mon, 17 Oct 2011 15:49:03 -0700
Message-ID: <201110172249.p9HMn3Ho012675@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1JQWtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 18:49:08 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id p9HMn6P4016136
	for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2011 15:49:06 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     a.patch

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
From: Andrew Morton <akpm@google.com>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/open.c~a fs/open.c
--- a/fs/open.c~a
+++ a/fs/open.c
@@ -1056,6 +1056,8 @@ int filp_close(struct file *filp, fl_own
 
 EXPORT_SYMBOL(filp_close);
 
+foo
+
 /*
  * Careful here! We test whether the file pointer is NULL before
  * releasing the fd. This ensures that one clone task can't release
_
Subject: Subject: a

Patches currently in -mm which might be from akpm@google.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
revert-treewide-use-__printf-not-__attribute__formatprintf.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch
a.patch

