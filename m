From: akpm@linux-foundation.org
Subject: + kfifo-replace-the-old-non-generic-api.patch added to -mm tree
Date: Thu, 13 May 2010 14:35:29 -0700
Message-ID: <201005132135.o4DLZTN7021634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874Ab0EMVgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, greg@kroah.com


The patch titled
     kfifo: replace the old non generic API
has been added to the -mm tree.  Its filename is
     kfifo-replace-the-old-non-generic-api.patch

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
Subject: kfifo: replace the old non generic API
From: Stefani Seibold <stefani@seibold.net>

Simply replace the whole kfifo.c and kfifo.h files with the new generic
version and fix the kerneldoc API template file.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~kfifo-replace-the-old-non-generic-api Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kfifo-replace-the-old-non-generic-api
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -132,7 +132,6 @@ X!Ilib/string.c
      <title>FIFO Buffer</title>
      <sect1><title>kfifo interface</title>
 !Iinclude/linux/kfifo.h
-!Ekernel/kfifo.c
      </sect1>
   </chapter>
 
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
linux-next.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch
kfifo-fix-kfifo-miss-use-of-nozamic.patch
kfifo-add-the-new-generic-kfifo-api.patch
kfifo-replace-the-old-non-generic-api.patch
kfifo-add-example-files-to-the-kernel-sample-directory.patch

