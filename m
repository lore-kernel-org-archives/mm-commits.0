From: akpm@linux-foundation.org
Subject: + uio-howtotmpl-use-unique-output-names.patch added to -mm tree
Date: Tue, 24 Jun 2008 14:25:00 -0700
Message-ID: <200806242125.m5OLP26K006869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbYFXVZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 17:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, greg@kroah.com, hjk@linutronix.de, randy.dunlap@oracle.com


The patch titled
     uio-howto.tmpl: use unique output names
has been added to the -mm tree.  Its filename is
     uio-howtotmpl-use-unique-output-names.patch

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
Subject: uio-howto.tmpl: use unique output names
From: Mike Frysinger <vapier@gentoo.org>

The Userspace I/O HOWTO template sets two different sections with the same
html output name (about.html).  This clearly won't work, so change the
first one to a unique "aboutthis.html" to prevent clobbering.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/uio-howto.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-unique-output-names Documentation/DocBook/uio-howto.tmpl
--- a/Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-unique-output-names
+++ a/Documentation/DocBook/uio-howto.tmpl
@@ -75,7 +75,7 @@ GPL version 2.
 </bookinfo>
 
 <chapter id="aboutthisdoc">
-<?dbhtml filename="about.html"?>
+<?dbhtml filename="aboutthis.html"?>
 <title>About this document</title>
 
 <sect1 id="translations">
_

Patches currently in -mm which might be from vapier@gentoo.org are

uio-howtotmpl-use-standard-copyright-legal-markings.patch
uio-howtotmpl-use-unique-output-names.patch

