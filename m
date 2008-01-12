From: akpm@linux-foundation.org
Subject: + document-make-prepare-in-make-help.patch added to -mm tree
Date: Fri, 11 Jan 2008 18:24:44 -0800
Message-ID: <200801120224.m0C2OiTN009808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYALCYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:24:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: valdis.kletnieks@vt.edu, sam@ravnborg.org


The patch titled
     document 'make prepare' in 'make help'
has been added to the -mm tree.  Its filename is
     document-make-prepare-in-make-help.patch

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
Subject: document 'make prepare' in 'make help'
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

The output of 'make help' covers a lot of options, but doesn't include
a listing for 'make prepare'.  Here's a one-liner to fix that...

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN Makefile~document-make-prepare-in-make-help Makefile
--- a/Makefile~document-make-prepare-in-make-help
+++ a/Makefile
@@ -1181,6 +1181,7 @@ help:
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[ois]  - Build specified target only'
 	@echo  '  dir/file.ko     - Build module including final link'
+	@echo  '  prepare         - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

document-make-prepare-in-make-help.patch
