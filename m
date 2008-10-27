From: akpm@linux-foundation.org
Subject: + init-do_mounts_mdc-msleep-compile-fix.patch added to -mm tree
Date: Sun, 26 Oct 2008 20:46:49 -0700
Message-ID: <200810270346.m9R3knih032717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbYJ0Dqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 26 Oct 2008 23:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     init/do_mounts_md.c: msleep compile fix
has been added to the -mm tree.  Its filename is
     init-do_mounts_mdc-msleep-compile-fix.patch

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
Subject: init/do_mounts_md.c: msleep compile fix
From: Alexey Dobriyan <adobriyan@gmail.com>

init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts_md.c~init-do_mounts_mdc-msleep-compile-fix init/do_mounts_md.c
--- a/init/do_mounts_md.c~init-do_mounts_mdc-msleep-compile-fix
+++ a/init/do_mounts_md.c
@@ -1,4 +1,4 @@
