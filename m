From: akpm@linux-foundation.org
Subject: + fs-sysv-add-v7-alias.patch added to -mm tree
Date: Thu, 22 Jul 2010 16:06:31 -0700
Message-ID: <201007222306.o6MN6Von017466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab0GVXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkundrak@v3.sk, hch@lst.de


The patch titled
     fs/sysv: add v7 alias
has been added to the -mm tree.  Its filename is
     fs-sysv-add-v7-alias.patch

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
Subject: fs/sysv: add v7 alias
From: Lubomir Rintel <lkundrak@v3.sk>

So that the module gets autoloaded when a v7 filesystem is mounted.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/sysv/super.c~fs-sysv-add-v7-alias fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-add-v7-alias
+++ a/fs/sysv/super.c
@@ -560,4 +560,5 @@ static void __exit exit_sysv_fs(void)
 
 module_init(init_sysv_fs)
 module_exit(exit_sysv_fs)
+MODULE_ALIAS("v7");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from lkundrak@v3.sk are

fs-sysv-add-v7-alias.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch
fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch

